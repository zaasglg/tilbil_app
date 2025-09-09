import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:audioplayers/audioplayers.dart';
import '../models/material_models.dart';
import '../services/language_service.dart';

class StoryReaderScreen extends StatefulWidget {
  final StoryMaterial story;

  const StoryReaderScreen({super.key, required this.story});

  @override
  State<StoryReaderScreen> createState() => _StoryReaderScreenState();
}

class _StoryReaderScreenState extends State<StoryReaderScreen> {
  late AudioPlayer _audioPlayer;
  bool _isPlaying = false;
  bool _showTranslation = false;
  String _selectedLanguage = 'kk';
  double _fontSize = 16.0;
  Duration _currentPosition = Duration.zero;
  Duration _totalDuration = Duration.zero;

  @override
  void initState() {
    super.initState();
    _audioPlayer = AudioPlayer();
    _setupAudioPlayer();
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  void _setupAudioPlayer() {
    _audioPlayer.onDurationChanged.listen((duration) {
      setState(() {
        _totalDuration = duration;
      });
    });

    _audioPlayer.onPositionChanged.listen((position) {
      setState(() {
        _currentPosition = position;
      });
    });

    _audioPlayer.onPlayerStateChanged.listen((state) {
      setState(() {
        _isPlaying = state == PlayerState.playing;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F7F7),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black87),
          onPressed: () => Navigator.pop(context),
        ),
        title: Consumer<LanguageService>(
          builder: (context, languageService, child) {
            return Text(
              widget.story.getTitle(languageService.currentLocale.languageCode),
              style: const TextStyle(
                color: Colors.black87,
                fontSize: 20,
                fontWeight: FontWeight.w600,
              ),
            );
          },
        ),
        actions: [
          PopupMenuButton<String>(
            icon: const Icon(Icons.more_vert, color: Colors.black87),
            onSelected: (value) {
              switch (value) {
                case 'font_size':
                  _showFontSizeDialog();
                  break;
                case 'translation':
                  setState(() {
                    _showTranslation = !_showTranslation;
                  });
                  break;
              }
            },
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'font_size',
                child: Row(
                  children: [
                    Icon(Icons.text_fields, size: 20),
                    SizedBox(width: 8),
                    Text('Font Size'),
                  ],
                ),
              ),
              PopupMenuItem(
                value: 'translation',
                child: Row(
                  children: [
                    Icon(
                      _showTranslation
                          ? Icons.visibility_off
                          : Icons.visibility,
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    Text(_showTranslation
                        ? 'Hide Translation'
                        : 'Show Translation'),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
      body: Column(
        children: [
          // Audio Controls
          Container(
            color: Colors.white,
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    color: const Color(0xFF58CC02).withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: IconButton(
                    icon: Icon(
                      _isPlaying ? Icons.pause : Icons.play_arrow,
                      color: const Color(0xFF58CC02),
                    ),
                    onPressed: _toggleAudio,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _isPlaying
                            ? 'Playing audio...'
                            : 'Tap to play narration',
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 4),
                      if (_totalDuration.inSeconds > 0)
                        Text(
                          '${_formatDuration(_currentPosition)} / ${_formatDuration(_totalDuration)}',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[600],
                          ),
                        ),
                      const SizedBox(height: 4),
                      LinearProgressIndicator(
                        value: _totalDuration.inMilliseconds > 0
                            ? _currentPosition.inMilliseconds /
                                _totalDuration.inMilliseconds
                            : 0.0,
                        backgroundColor: Colors.grey[300],
                        valueColor: const AlwaysStoppedAnimation<Color>(
                          Color(0xFF58CC02),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 16),
              ],
            ),
          ),

          const Divider(height: 1),

          // Story Content
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Story Title
                  Text(
                    widget.story.getTitle(_selectedLanguage),
                    style: TextStyle(
                      fontSize: _fontSize + 8,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                      height: 1.3,
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Story Content
                  Text(
                    widget.story.getContent(_selectedLanguage),
                    style: TextStyle(
                      fontSize: _fontSize,
                      color: Colors.black87,
                      height: 1.6,
                      letterSpacing: 0.3,
                    ),
                  ),

                  // Translation (if enabled)
                  if (_showTranslation && _selectedLanguage != 'en') ...[
                    const SizedBox(height: 32),
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.blue[50],
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.blue[200]!),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(
                                Icons.translate,
                                size: 20,
                                color: Colors.blue[600],
                              ),
                              const SizedBox(width: 8),
                              Text(
                                'Translation',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.blue[600],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          Text(
                            widget.story.content,
                            style: TextStyle(
                              fontSize: _fontSize - 2,
                              color: Colors.blue[800],
                              height: 1.5,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],

                  SizedBox(
                    height: 20.0,
                  ),

                  // Complete Button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _markAsCompleted,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF58CC02),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Consumer<LanguageService>(
                        builder: (context, languageService, child) {
                          return Text(
                            _getCompleteButtonText(
                                languageService.currentLocale.languageCode),
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDifficultyChip(String difficulty) {
    Color chipColor;
    switch (difficulty.toLowerCase()) {
      case 'beginner':
        chipColor = const Color(0xFF58CC02);
        break;
      case 'intermediate':
        chipColor = const Color(0xFF1CB0F6);
        break;
      case 'advanced':
        chipColor = const Color(0xFFFF9600);
        break;
      default:
        chipColor = Colors.grey;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: chipColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Text(
        difficulty,
        style: TextStyle(
          fontSize: 12,
          color: chipColor,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  void _toggleAudio() async {
    try {
      if (_isPlaying) {
        await _audioPlayer.pause();
      } else {
        // Use the story's audio URL if available, otherwise use a placeholder
        String audioUrl = widget.story.audioUrl.isNotEmpty
            ? widget.story.audioUrl
            : 'https://www.soundjay.com/misc/sounds/bell-ringing-05.wav'; // Placeholder audio

        await _audioPlayer.play(UrlSource(audioUrl));
      }
    } catch (e) {
      print('Error playing audio: $e');
      // Show error message to user
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Error playing audio. Please try again.'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  void _showFontSizeDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Font Size'),
        content: StatefulBuilder(
          builder: (context, setState) {
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Sample text',
                  style: TextStyle(fontSize: _fontSize),
                ),
                const SizedBox(height: 16),
                Slider(
                  value: _fontSize,
                  min: 12.0,
                  max: 24.0,
                  divisions: 6,
                  label: _fontSize.round().toString(),
                  onChanged: (value) {
                    setState(() {
                      _fontSize = value;
                    });
                    this.setState(() {});
                  },
                ),
              ],
            );
          },
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Done'),
          ),
        ],
      ),
    );
  }

  void _markAsCompleted() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: const BoxDecoration(
                color: Color(0xFF58CC02),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.check,
                color: Colors.white,
                size: 24,
              ),
            ),
            const SizedBox(width: 12),
            const Text('Story Completed!'),
          ],
        ),
        content: Text(
          'Excellent! You\'ve finished reading "${widget.story.title}". '
          'Keep exploring more stories to improve your Kazakh!',
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              Navigator.of(context).pop();
            },
            child: const Text('Continue'),
          ),
        ],
      ),
    );
  }

  String _formatDuration(Duration duration) {
    final minutes = duration.inMinutes;
    final seconds = duration.inSeconds % 60;
    return '${minutes}:${seconds.toString().padLeft(2, '0')}';
  }

  String _getCompleteButtonText(String languageCode) {
    switch (languageCode) {
      case 'kk':
        return 'Оқуды аяқтау';
      case 'ru':
        return 'Завершить чтение';
      default:
        return 'Mark as Complete';
    }
  }
}
