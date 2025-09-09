import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:video_player/video_player.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import '../models/material_models.dart';
import '../services/language_service.dart';

class VideoPlayerScreen extends StatefulWidget {
  final VideoMaterial video;

  const VideoPlayerScreen({super.key, required this.video});

  @override
  State<VideoPlayerScreen> createState() => _VideoPlayerScreenState();
}

class _VideoPlayerScreenState extends State<VideoPlayerScreen> {
  late VideoPlayerController _controller;
  bool _isPlaying = false;
  bool _showControls = true;
  bool _isInitialized = false;
  bool _hasError = false;

  @override
  void initState() {
    super.initState();
    _initializeVideo();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _initializeVideo() {
    _controller = VideoPlayerController.networkUrl(
      Uri.parse(widget.video.videoUrl),
    );

    _controller.initialize().then((_) {
      setState(() {
        _isInitialized = true;
      });
    }).catchError((error) {
      print('Error initializing video: $error');
      setState(() {
        _hasError = true;
      });
    });

    _controller.addListener(() {
      if (mounted) {
        setState(() {
          _isPlaying = _controller.value.isPlaying;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(IconlyBroken.arrowLeft, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: Consumer<LanguageService>(
          builder: (context, languageService, child) {
            return Text(
              widget.video.getTitle(languageService.currentLocale.languageCode),
              style: const TextStyle(color: Colors.white),
            );
          },
        ),
      ),
      body: Column(
        children: [
          // Video Player Area
          Expanded(
            flex: 2,
            child: Container(
              width: double.infinity,
              color: Colors.black,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  // Video player or loading/error state
                  if (_isInitialized && !_hasError)
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          _showControls = !_showControls;
                        });
                        // Hide controls after 3 seconds
                        if (_showControls) {
                          Future.delayed(const Duration(seconds: 3), () {
                            if (mounted) {
                              setState(() {
                                _showControls = false;
                              });
                            }
                          });
                        }
                      },
                      child: SizedBox(
                        width: double.infinity,
                        height: double.infinity,
                        child: VideoPlayer(_controller),
                      ),
                    )
                  else if (_hasError)
                    // Error state - show thumbnail
                    Container(
                      width: double.infinity,
                      height: double.infinity,
                      child: Image.network(
                        widget.video.thumbnailUrl,
                        width: double.infinity,
                        height: double.infinity,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            width: double.infinity,
                            height: double.infinity,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: [
                                  Colors.grey[800]!,
                                  Colors.grey[900]!,
                                ],
                              ),
                            ),
                            child: const Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  IconlyLight.video,
                                  size: 80,
                                  color: Colors.white54,
                                ),
                                SizedBox(height: 16),
                                Text(
                                  'Video Preview',
                                  style: TextStyle(
                                    color: Colors.white54,
                                    fontSize: 18,
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    )
                  else
                    // Loading state
                    Container(
                      width: double.infinity,
                      height: double.infinity,
                      color: Colors.grey[900],
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            CircularProgressIndicator(
                              color: Colors.white54,
                              strokeWidth: 3,
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'Видео жүктелуде...',
                              style: TextStyle(
                                color: Colors.white54,
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                  // Play/Pause Button
                  if (_showControls && _isInitialized && !_hasError)
                    GestureDetector(
                      onTap: _togglePlayPause,
                      child: Container(
                        width: 80,
                        height: 80,
                        decoration: BoxDecoration(
                          color: Colors.black54,
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          _isPlaying ? CupertinoIcons.pause : IconlyBold.play,
                          color: Colors.white,
                          size: 40,
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),

          // Video Controls
          if (_isInitialized && !_hasError)
            Container(
              color: Colors.black,
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  // Progress Bar
                  Row(
                    children: [
                      Text(
                        _formatDuration(_controller.value.position),
                        style:
                            const TextStyle(color: Colors.white, fontSize: 12),
                      ),
                      Expanded(
                        child: Slider(
                          value: _controller.value.position.inMilliseconds
                              .toDouble(),
                          max: _controller.value.duration.inMilliseconds
                              .toDouble(),
                          onChanged: (value) {
                            _controller
                                .seekTo(Duration(milliseconds: value.toInt()));
                          },
                          activeColor: const Color(0xFF1CB0F6),
                          inactiveColor: Colors.grey[600],
                        ),
                      ),
                      Text(
                        _formatDuration(_controller.value.duration),
                        style:
                            const TextStyle(color: Colors.white, fontSize: 12),
                      ),
                    ],
                  ),

                  // Control Buttons
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      IconButton(
                        icon: const Icon(IconlyLight.timeCircle,
                            color: Colors.white),
                        onPressed: _rewind,
                      ),
                      IconButton(
                        icon: Icon(
                          _isPlaying ? CupertinoIcons.pause : IconlyBold.play,
                          color: Colors.white,
                          size: 32,
                        ),
                        onPressed: _togglePlayPause,
                      ),
                      IconButton(
                        icon: const Icon(IconlyLight.timeCircle,
                            color: Colors.white),
                        onPressed: _fastForward,
                      ),
                    ],
                  ),
                ],
              ),
            ),

          // Video Info
          Expanded(
            flex: 3,
            child: Container(
              width: double.infinity,
              color: Colors.white,
              padding: const EdgeInsets.all(20),
              child: Consumer<LanguageService>(
                builder: (context, languageService, child) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.video.getTitle(
                            languageService.currentLocale.languageCode),
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          _buildDifficultyChip(widget.video.difficulty),
                          const SizedBox(width: 12),
                          Text(
                            widget.video.formattedDuration,
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Text(
                        widget.video.getDescription(
                            languageService.currentLocale.languageCode),
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey[700],
                          height: 1.5,
                        ),
                      ),
                      const Spacer(),

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
                          child: Text(
                            _getCompleteButtonText(
                                languageService.currentLocale.languageCode),
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ],
                  );
                },
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

  void _togglePlayPause() {
    setState(() {
      if (_controller.value.isPlaying) {
        _controller.pause();
      } else {
        _controller.play();
      }
    });
  }

  void _rewind() {
    final currentPosition = _controller.value.position;
    final newPosition = currentPosition - const Duration(seconds: 10);
    _controller
        .seekTo(newPosition < Duration.zero ? Duration.zero : newPosition);
  }

  void _fastForward() {
    final currentPosition = _controller.value.position;
    final duration = _controller.value.duration;
    final newPosition = currentPosition + const Duration(seconds: 10);
    _controller.seekTo(newPosition > duration ? duration : newPosition);
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
                IconlyBold.tickSquare,
                color: Colors.white,
                size: 24,
              ),
            ),
            const SizedBox(width: 12),
            const Text('Completed!'),
          ],
        ),
        content: const Text('Great job! You\'ve completed this video lesson.'),
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
        return 'Аяқтау';
      case 'ru':
        return 'Завершить';
      default:
        return 'Mark as Complete';
    }
  }
}
