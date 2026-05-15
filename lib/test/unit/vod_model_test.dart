import 'package:flutter_test/flutter_test.dart';
import 'package:xybox/data/models/vod_model.dart';

void main() {
  group('Vod Model Tests', () {
    test('should create Vod instance', () {
      final vod = const Vod(id: '1', name: 'Test VOD');
      expect(vod.id, '1');
      expect(vod.name, 'Test VOD');
    });

    test('should create Vod with optional fields', () {
      final vod = const Vod(
        id: '1',
        name: 'Test VOD',
        pic: 'https://example.com/pic.jpg',
        year: '2024',
        area: 'China',
        director: 'Director Name',
        actor: 'Actor Name',
        remark: 'HD',
        score: 8.5,
      );
      expect(vod.pic, 'https://example.com/pic.jpg');
      expect(vod.year, '2024');
      expect(vod.score, 8.5);
    });
  });
}
