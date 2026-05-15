import 'package:dio/dio.dart';
import '../../core/interfaces/interfaces.dart';
class NetworkDataSourceImpl implements INetworkDataSource {
  final Dio _dio;
  NetworkDataSourceImpl({required Dio dio}) : _dio = dio;
  @override
  Future<void> initialize() async {}
  @override
  Future<dynamic> get(String url, {Map<String, dynamic>? params}) async {
    final response = await _dio.get(url, queryParameters: params);
    return response.data;
  }
  @override
  Future<dynamic> post(String url, {dynamic data, Map<String, dynamic>? params}) async {
    final response = await _dio.post(url, data: data, queryParameters: params);
    return response.data;
  }
  @override
  Future<void> dispose() async => _dio.close();
}
