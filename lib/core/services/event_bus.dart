import 'dart:async';
class EventBus {
  static final EventBus _instance = EventBus._internal();
  factory EventBus() => _instance;
  EventBus._internal();
  final StreamController _controller = StreamController.broadcast();
  Stream<T> on<T>() => _controller.stream.where((e) => e is T).cast<T>();
  void emit<T>(T event) => _controller.add(event);
  void dispose() => _controller.close();
}
