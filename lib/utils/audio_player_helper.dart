// import 'package:audioplayers/audioplayers.dart';
// import '../constants/audio_segments.dart';

// /// Helper класс для удобной работы с аудиосегментами
// class AudioPlayerHelper {
//   final AudioPlayer _audioPlayer;
//   AudioSegment? _currentSegment;
//   bool _isPlaying = false;
//   Function(bool)? _onPlayingStateChanged;
//   Function()? _onSegmentComplete;

//   AudioPlayerHelper(this._audioPlayer);

//   /// Текущий сегмент
//   AudioSegment? get currentSegment => _currentSegment;

//   /// Состояние воспроизведения
//   bool get isPlaying => _isPlaying;

//   /// Настроить callbacks
//   void setCallbacks({
//     Function(bool)? onPlayingStateChanged,
//     Function()? onSegmentComplete,
//   }) {
//     _onPlayingStateChanged = onPlayingStateChanged;
//     _onSegmentComplete = onSegmentComplete;
//   }

//   /// Настроить аудиоплеер для работы с сегментами
//   Future<void> setupAudioPlayer() async {
//     try {
//       // Загружаем основной аудиофайл
//       await _audioPlayer.setSource(AssetSource('audio/main_audio.mp3'));

//       // Настраиваем слушатель позиции
//       _audioPlayer.onPositionChanged.listen((position) {
//         if (_currentSegment != null && position >= _currentSegment!.endTime) {
//           _audioPlayer.pause();
//           _setPlayingState(false);
//           _onSegmentComplete?.call();
//         }
//       });

//       // Слушатель завершения воспроизведения
//       _audioPlayer.onPlayerComplete.listen((_) {
//         _setPlayingState(false);
//         _onSegmentComplete?.call();
//       });

//       print('Audio player setup complete');
//     } catch (e) {
//       print('Error setting up audio player: $e');
//       throw e;
//     }
//   }

//   /// Воспроизвести указанный сегмент
//   Future<void> playSegment(AudioSegment segment) async {
//     try {
//       _currentSegment = segment;
//       _setPlayingState(true);

//       // Переходим к началу сегмента
//       await _audioPlayer.seek(segment.startTime);
//       await _audioPlayer.resume();

//       print('Playing segment: ${segment.segmentInfo}');
//     } catch (e) {
//       print('Error playing segment: $e');
//       _setPlayingState(false);
//       throw e;
//     }
//   }

//   /// Остановить воспроизведение
//   Future<void> stop() async {
//     try {
//       await _audioPlayer.stop();
//       _setPlayingState(false);
//       _currentSegment = null;
//     } catch (e) {
//       print('Error stopping audio: $e');
//     }
//   }

//   /// Пауза
//   Future<void> pause() async {
//     try {
//       await _audioPlayer.pause();
//       _setPlayingState(false);
//     } catch (e) {
//       print('Error pausing audio: $e');
//     }
//   }

//   /// Возобновить воспроизведение
//   Future<void> resume() async {
//     try {
//       await _audioPlayer.resume();
//       _setPlayingState(true);
//     } catch (e) {
//       print('Error resuming audio: $e');
//     }
//   }

//   /// Воспроизвести сегмент по названию
//   Future<void> playSegmentByName(String name) async {
//     final segment = AudioSegment.findByName(name);
//     if (segment != null) {
//       await playSegment(segment);
//     } else {
//       print('Segment with name "$name" not found');
//     }
//   }

//   /// Получить информацию о текущем сегменте
//   String? getCurrentSegmentInfo() {
//     return _currentSegment?.segmentInfo;
//   }

//   /// Установить состояние воспроизведения
//   void _setPlayingState(bool playing) {
//     _isPlaying = playing;
//     _onPlayingStateChanged?.call(playing);
//   }

//   /// Освободить ресурсы
//   void dispose() {
//     _audioPlayer.dispose();
//   }
// }

// /// Mixin для удобного использования в StatefulWidget
// mixin AudioSegmentMixin<T extends StatefulWidget> on State<T> {
//   late AudioPlayerHelper _audioHelper;
//   late AudioPlayer _audioPlayer;

//   @override
//   void initState() {
//     super.initState();
//     _audioPlayer = AudioPlayer();
//     _audioHelper = AudioPlayerHelper(_audioPlayer);
//     _setupAudio();
//   }

//   /// Переопределите этот метод для настройки аудио
//   Future<void> _setupAudio() async {
//     _audioHelper.setCallbacks(
//       onPlayingStateChanged: (playing) {
//         if (mounted) {
//           setState(() {
//             // Обновляем UI при изменении состояния
//           });
//         }
//       },
//       onSegmentComplete: () {
//         if (mounted) {
//           onAudioSegmentComplete();
//         }
//       },
//     );

//     try {
//       await _audioHelper.setupAudioPlayer();
//     } catch (e) {
//       print('Error in audio setup: $e');
//     }
//   }

//   /// Переопределите этот метод для обработки завершения сегмента
//   void onAudioSegmentComplete() {
//     // Переопределите в дочернем классе
//   }

//   /// Воспроизвести сегмент
//   Future<void> playSegment(AudioSegment segment) async {
//     await _audioHelper.playSegment(segment);
//   }

//   /// Воспроизвести сегмент по названию
//   Future<void> playSegmentByName(String name) async {
//     await _audioHelper.playSegmentByName(name);
//   }

//   /// Получить helper для аудио
//   AudioPlayerHelper get audioHelper => _audioHelper;

//   @override
//   void dispose() {
//     _audioHelper.dispose();
//     super.dispose();
//   }
// }
