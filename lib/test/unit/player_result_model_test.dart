import 'package:flutter_test/flutter_test.dart';
import 'package:xybox/data/models/player_model.dart';

void main() {
  group('PlayerResult Model Tests', () {
    test('should create PlayerResult instance', () {
      final result = const PlayerResult(url: 'https://example.com/video.mp4');
      expect(result.url, 'https://example.com/video.mp4');
      expect(result.parse, 0);
    });

    test('should create PlayerResult with all fields', () {
      final result = const PlayerResult(
        url: 'https://example.com/video.mp4',
        parse: 1,
        playUrl: 'https://player.example.com',
        header: {'User-Agent': 'XYBox'},
        flag: 'HD',
      );
      expect(result.parse, 1);
      expect(result.playUrl, 'https://player.example.com');
      expect(result.header['User-Agent'], 'XYBox');
      expect(result.flag, 'HD');
    });
  });
}
