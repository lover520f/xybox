import 'dart:async';
import 'dart:convert';
import 'dart:io';
import '../../../core/utils/logger_util.dart';

class DlnaDevice {
  final String udn;
  final String friendlyName;
  final String modelName;
  final String manufacturer;
  final String location;
  final String controlUrl;

  DlnaDevice({
    required this.udn,
    required this.friendlyName,
    required this.modelName,
    required this.manufacturer,
    required this.location,
    required this.controlUrl,
  });
}

class DlnaService {
  static final DlnaService _instance = DlnaService._internal();
  factory DlnaService() => _instance;
  DlnaService._internal();

  final List<DlnaDevice> _devices = [];
  final StreamController<List<DlnaDevice>> _deviceController = StreamController.broadcast();
  RawDatagramSocket? _socket;
  bool _isSearching = false;

  Stream<List<DlnaDevice>> get deviceStream => _deviceController.stream;
  List<DlnaDevice> get devices => List.from(_devices);

  Future<void> searchDevices() async {
    if (_isSearching) return;
    _isSearching = true;
    _devices.clear();

    try {
      _socket = await RawDatagramSocket.bind(InternetAddress.anyIPv4, 0);
      _socket!.broadcastEnabled = true;

      const searchMessage = '''M-SEARCH * HTTP/1.1
HOST: 239.255.255.250:1900
MAN: "ssdp:discover"
MX: 3
ST: urn:schemas-upnp-org:device:MediaRenderer:1.0

''';

      final address = InternetAddress('239.255.255.250');
      const port = 1900;

      for (int i = 0; i < 3; i++) {
        _socket!.send(utf8.encode(searchMessage), address, port);
        await Future.delayed(const Duration(seconds: 1));
      }

      _listenForResponses();
      await Future.delayed(const Duration(seconds: 5));
      _socket?.close();
      _isSearching = false;

      _deviceController.add(List.from(_devices));
      LoggerUtil.i('发现${_devices.length}个 DLNA 设备');
    } catch (e) {
      LoggerUtil.e('搜索 DLNA 设备失败：$e');
      _isSearching = false;
    }
  }

  void _listenForResponses() {
    _socket?.listen((RawSocketEvent event) {
      if (event == RawSocketEvent.read) {
        final datagram = _socket!.receive();
        if (datagram != null) {
          final response = utf8.decode(datagram.data);
          final headers = _parseSsdpResponse(response);
          if (headers != null) {
            final device = DlnaDevice(
              udn: headers['USN']?.split('::').first ?? '',
              friendlyName: headers['friendlyName'] ?? '未知设备',
              modelName: headers['modelName'] ?? '',
              manufacturer: headers['manufacturer'] ?? '',
              location: headers['LOCATION'] ?? '',
              controlUrl: '',
            );
            
            if (!_devices.any((d) => d.udn == device.udn)) {
              _devices.add(device);
              _deviceController.add(List.from(_devices));
            }
          }
        }
      }
    });
  }

  Map<String, String>? _parseSsdpResponse(String response) {
    final headers = <String, String>{};
    final lines = response.split('\r\n');

    for (var line in lines.skip(1)) {
      if (line.isEmpty) break;
      final parts = line.split(': ');
      if (parts.length >= 2) {
        headers[parts[0]] = parts.sublist(1).join(': ');
      }
    }

    if (headers.containsKey('LOCATION')) {
      return headers;
    }
    return null;
  }

  Future<bool> castVideo(DlnaDevice device, String videoUrl, String title) async {
    try {
      final controlUrl = await _getAvTransportUrl(device.location);
      if (controlUrl.isEmpty) return false;

      await _sendSoapRequest(controlUrl, 'Stop', '<InstanceID xmlns="urn:schemas-upnp-org:service:AVTransport:1"><InstanceID>0</InstanceID></InstanceID>');
      await _sendSoapRequest(controlUrl, 'SetAVTransportURI', '<InstanceID xmlns="urn:schemas-upnp-org:service:AVTransport:1"><InstanceID>0</InstanceID><CurrentURI xmlns="urn:schemas-upnp-org:service:AVTransport:1">$videoUrl</CurrentURI></InstanceID>');
      await _sendSoapRequest(controlUrl, 'Play', '<InstanceID xmlns="urn:schemas-upnp-org:service:AVTransport:1"><InstanceID>0</InstanceID></InstanceID>');

      LoggerUtil.i('投屏成功：$title');
      return true;
    } catch (e) {
      LoggerUtil.e('投屏失败：$e');
      return false;
    }
  }

  Future<String> _getAvTransportUrl(String location) async {
    try {
      final client = HttpClient();
      final request = await client.getUrl(Uri.parse(location));
      final response = await request.close();
      final content = await response.transform(const Utf8Decoder()).join();
      
      final controlMatch = RegExp(r'<controlURL[^>]*>([^<]+)</controlURL>').firstMatch(content);
      if (controlMatch != null) {
        final baseUrl = location.substring(0, location.lastIndexOf('/'));
        return '$baseUrl${controlMatch.group(1)}';
      }
    } catch (e) {
      LoggerUtil.e('获取控制 URL 失败：$e');
    }
    return '';
  }

  Future<void> _sendSoapRequest(String url, String action, String body) async {
    final client = HttpClient();
    try {
      final request = await client.postUrl(Uri.parse(url));
      request.headers.set('Content-Type', 'text/xml; charset=utf-8');
      request.headers.set('SOAPACTION', '"urn:schemas-upnp-org:service:AVTransport:1#$action"');
      
      final soapBody = '''<?xml version="1.0" encoding="utf-8"?>
<s:Envelope xmlns:s="http://schemas.xmlsoap.org/soap/envelope/" s:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">
  <s:Body>$body</s:Body>
</s:Envelope>''';
      
      request.write(soapBody);
      await request.close();
    } finally {
      client.close();
    }
  }

  void dispose() {
    _socket?.close();
    _deviceController.close();
  }
}
