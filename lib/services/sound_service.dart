import 'package:just_audio/just_audio.dart';

class SoundService {
  AudioPlayer? _player;

  /// Проигрывает кусок звука из assets.
  /// [startMs] — начало в миллисекундах.
  /// [endMs] — конец в миллисекундах.
  Future<void> playSegment(int startMs, int endMs) async {
    try {
      // Останавливаем предыдущее воспроизведение если есть
      await stopAudio();
      
      _player = AudioPlayer();
      
      // Загружаем аудио (путь к твоему файлу)
      await _player!.setAsset('assets/audio/main_audio.mp3');

      // Ограничиваем воспроизведение
      await _player!.setClip(
        start: Duration(milliseconds: startMs),
        end: Duration(milliseconds: endMs),
      );

      // Проигрываем
      await _player!.play();
    } catch (e) {
      print("Ошибка при воспроизведении: $e");
      await _disposePlayer();
    }
  }

  /// Останавливает воспроизведение аудио
  Future<void> stopAudio() async {
    try {
      if (_player != null) {
        await _player!.stop();
        await _disposePlayer();
      }
    } catch (e) {
      print("Ошибка при остановке аудио: $e");
    }
  }

  /// Освобождает ресурсы плеера
  Future<void> _disposePlayer() async {
    try {
      if (_player != null) {
        await _player!.dispose();
        _player = null;
      }
    } catch (e) {
      print("Ошибка при освобождении ресурсов: $e");
    }
  }

  /// Проверяет, воспроизводится ли аудио в данный момент
  bool get isPlaying => _player?.playing ?? false;

  /// Освобождает все ресурсы при закрытии сервиса
  Future<void> dispose() async {
    await stopAudio();
  }
}

// Глобальный экземпляр для удобства использования
final soundService = SoundService();
