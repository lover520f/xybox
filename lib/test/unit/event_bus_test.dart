import 'package:flutter_test/flutter_test.dart';
import 'package:xybox/core/services/event_bus.dart';

void main() {
  group('EventBus Tests', () {
    late EventBus eventBus;

    setUp(() {
      eventBus = EventBus();
    });

    tearDown(() {
      eventBus.dispose();
    });

    test('should emit and receive events', () async {
      final receivedEvents = <String>[];
      final subscription = eventBus.on<String>().listen(receivedEvents.add);

      eventBus.emit('test event');
      await Future.delayed(const Duration(milliseconds: 10));

      expect(receivedEvents, ['test event']);
      await subscription.cancel();
    });

    test('should filter events by type', () async {
      final stringEvents = <String>[];
      final intEvents = <int>[];

      final sub1 = eventBus.on<String>().listen(stringEvents.add);
      final sub2 = eventBus.on<int>().listen(intEvents.add);

      eventBus.emit('string event');
      eventBus.emit(42);
      await Future.delayed(const Duration(milliseconds: 10));

      expect(stringEvents, ['string event']);
      expect(intEvents, [42]);

      await sub1.cancel();
      await sub2.cancel();
    });
  });
}
