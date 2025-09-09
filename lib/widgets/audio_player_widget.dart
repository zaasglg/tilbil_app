import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';

class AudioPlayerWidget extends StatefulWidget {
  final String? audioPath;
  final Function(String)? onAudioSelected;
  final Function(Duration, Duration)? onSegmentChanged;
  final Duration maxDuration;
  final bool showSegmentControls;
  final Color? primaryColor;
  final bool playInBackground;

  const AudioPlayerWidget({
    super.key,
    this.audioPath,
    this.onAudioSelected,
    this.onSegmentChanged,
    this.maxDuration = const Duration(minutes: 3),
    this.showSegmentControls = true,
    this.primaryColor,
    this.playInBackground = true,
  });

  @override
  State<AudioPlayerWidget> createState() => _AudioPlayerWidgetState();
}

class _AudioPlayerWidgetState extends State<AudioPlayerWidget> {
  late AudioPlayer _audioPlayer;
  bool _isPlaying = false;
  Duration _currentPosition = Duration.zero;
  Duration _totalDuration = Duration.zero;
  Duration _segmentStart = Duration.zero;
  Duration _segmentEnd = Duration.zero;
  bool _isLooping = false;

  Color get _primaryColor => widget.primaryColor ?? const Color(0xFF87CEEB);

  @override
  void initState() {
    super.initState();
    _audioPlayer = AudioPlayer();
    _setupAudioPlayer();
    if (widget.audioPath != null) {
      _loadAudio();
    }
  }

  void _setupAudioPlayer() {
    // Настройка для фонового воспроизведения
    if (widget.playInBackground) {
      _audioPlayer.setPlayerMode(PlayerMode.mediaPlayer);
    }

    _audioPlayer.onPositionChanged.listen((position) {
      setState(() {
        _currentPosition = position;
      });

      // Автоматически возвращаемся к началу сегмента при достижении конца
      if (widget.showSegmentControls &&
          _segmentEnd > Duration.zero &&
          position >= _segmentEnd) {
        if (_isLooping) {
          _audioPlayer.seek(_segmentStart);
        } else {
          _audioPlayer.pause();
          setState(() {
            _isPlaying = false;
          });
          _audioPlayer.seek(_segmentStart);
        }
      }
    });

    _audioPlayer.onDurationChanged.listen((duration) {
      setState(() {
        _totalDuration = duration;
        _segmentEnd =
            duration > widget.maxDuration ? widget.maxDuration : duration;
      });
      _notifySegmentChanged();
    });

    _audioPlayer.onPlayerComplete.listen((_) {
      setState(() {
        _isPlaying = false;
        _currentPosition = _segmentStart;
      });
    });
  }

  Future<void> _loadAudio() async {
    if (widget.audioPath != null) {
      await _audioPlayer.setSourceDeviceFile(widget.audioPath!);
    }
  }

  void _notifySegmentChanged() {
    if (widget.onSegmentChanged != null) {
      widget.onSegmentChanged!(_segmentStart, _segmentEnd);
    }
  }

  Future<void> _playPause() async {
    if (_isPlaying) {
      await _audioPlayer.pause();
    } else {
      // Начинаем с позиции начала сегмента
      if (_currentPosition < _segmentStart || _currentPosition >= _segmentEnd) {
        await _audioPlayer.seek(_segmentStart);
      }
      await _audioPlayer.resume();
    }
    setState(() {
      _isPlaying = !_isPlaying;
    });
  }

  void _toggleLoop() {
    setState(() {
      _isLooping = !_isLooping;
    });
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return '$minutes:$seconds';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Основные контролы плеера
          Row(
            children: [
              // Кнопка воспроизведения
              GestureDetector(
                onTap: widget.audioPath != null ? _playPause : null,
                child: Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: widget.audioPath != null
                        ? _primaryColor
                        : Colors.grey.shade300,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    _isPlaying ? Icons.pause : Icons.play_arrow,
                    color: Colors.white,
                    size: 24,
                  ),
                ),
              ),

              const SizedBox(width: 16),

              // Информация о треке
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.audioPath != null
                          ? 'Аудиозапись'
                          : 'Выберите аудиофайл',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${_formatDuration(_currentPosition)} / ${_formatDuration(_totalDuration)}',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
              ),

              // Кнопка зацикливания
              if (widget.showSegmentControls && widget.audioPath != null)
                IconButton(
                  onPressed: _toggleLoop,
                  icon: Icon(
                    _isLooping ? Icons.repeat_one : Icons.repeat,
                    color: _isLooping ? _primaryColor : Colors.grey,
                  ),
                ),

              // Кнопка выбора файла
              if (widget.onAudioSelected != null)
                IconButton(
                  onPressed: () => _selectAudioFile(),
                  icon: Icon(
                    Icons.folder_open,
                    color: _primaryColor,
                  ),
                ),
            ],
          ),

          const SizedBox(height: 16),

          // Прогресс бар
          if (widget.audioPath != null) ...[
            SliderTheme(
              data: SliderTheme.of(context).copyWith(
                activeTrackColor: _primaryColor,
                inactiveTrackColor: Colors.grey.shade300,
                thumbColor: _primaryColor,
                overlayColor: _primaryColor.withValues(alpha: 0.2),
                trackHeight: 4,
                thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 8),
              ),
              child: Slider(
                value: _currentPosition.inMilliseconds.toDouble(),
                max: _totalDuration.inMilliseconds.toDouble(),
                onChanged: (value) {
                  final position = Duration(milliseconds: value.toInt());
                  _audioPlayer.seek(position);
                },
              ),
            ),
          ],

          // Контролы сегмента для воспроизведения
          if (widget.showSegmentControls && widget.audioPath != null) ...[
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.grey.shade50,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        'Промежуток воспроизведения (макс. ${widget.maxDuration.inMinutes} мин)',
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const Spacer(),
                      Icon(
                        _isLooping ? Icons.repeat_one : Icons.repeat,
                        size: 16,
                        color: _isLooping ? _primaryColor : Colors.grey,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        _isLooping ? 'Зацикл.' : 'Один раз',
                        style: TextStyle(
                          fontSize: 12,
                          color: _isLooping ? _primaryColor : Colors.grey,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),

                  // Начало сегмента
                  Row(
                    children: [
                      const Text('Начало: '),
                      Expanded(
                        child: SliderTheme(
                          data: SliderTheme.of(context).copyWith(
                            activeTrackColor: Colors.green,
                            thumbColor: Colors.green,
                            trackHeight: 2,
                            thumbShape: const RoundSliderThumbShape(
                                enabledThumbRadius: 6),
                          ),
                          child: Slider(
                            value: _segmentStart.inMilliseconds.toDouble(),
                            max: (_totalDuration.inMilliseconds - 1000)
                                .toDouble(),
                            onChanged: (value) {
                              setState(() {
                                _segmentStart =
                                    Duration(milliseconds: value.toInt());
                                if (_segmentEnd <= _segmentStart) {
                                  _segmentEnd = _segmentStart +
                                      const Duration(seconds: 1);
                                }
                              });
                              _notifySegmentChanged();
                            },
                          ),
                        ),
                      ),
                      Text(_formatDuration(_segmentStart)),
                    ],
                  ),

                  // Конец сегмента
                  Row(
                    children: [
                      const Text('Конец: '),
                      Expanded(
                        child: SliderTheme(
                          data: SliderTheme.of(context).copyWith(
                            activeTrackColor: Colors.red,
                            thumbColor: Colors.red,
                            trackHeight: 2,
                            thumbShape: const RoundSliderThumbShape(
                                enabledThumbRadius: 6),
                          ),
                          child: Slider(
                            value: _segmentEnd.inMilliseconds.toDouble(),
                            min: (_segmentStart.inMilliseconds + 1000)
                                .toDouble(),
                            max: _totalDuration.inMilliseconds >
                                    widget.maxDuration.inMilliseconds
                                ? widget.maxDuration.inMilliseconds.toDouble()
                                : _totalDuration.inMilliseconds.toDouble(),
                            onChanged: (value) {
                              setState(() {
                                _segmentEnd =
                                    Duration(milliseconds: value.toInt());
                              });
                              _notifySegmentChanged();
                            },
                          ),
                        ),
                      ),
                      Text(_formatDuration(_segmentEnd)),
                    ],
                  ),

                  const SizedBox(height: 8),
                  Text(
                    'Длительность сегмента: ${_formatDuration(_segmentEnd - _segmentStart)}',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey.shade600,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Future<void> _selectAudioFile() async {
    // Простая заглушка для выбора файла
    // В реальном проекте здесь будет file_picker
    if (widget.onAudioSelected != null) {
      // Пример: widget.onAudioSelected!('/path/to/audio/file.mp3');
    }
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }
}
