import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import '../../models/lesson_topic.dart';

class QuizWebViewScreen extends StatefulWidget {
  final LessonTopic topic;

  const QuizWebViewScreen({
    Key? key,
    required this.topic,
  }) : super(key: key);

  @override
  State<QuizWebViewScreen> createState() => _QuizWebViewScreenState();
}

class _QuizWebViewScreenState extends State<QuizWebViewScreen> {
  late final WebViewController _controller;
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _initializeWebView();
  }

  void _initializeWebView() {
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0x00000000))
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) {
            if (progress == 100) {
              setState(() {
                _isLoading = false;
              });
            }
          },
          onPageStarted: (String url) {
            setState(() {
              _isLoading = true;
              _errorMessage = null;
            });
          },
          onPageFinished: (String url) {
            setState(() {
              _isLoading = false;
            });
          },
          onWebResourceError: (WebResourceError error) {
            setState(() {
              _isLoading = false;
              _errorMessage = 'Бет жүктелу қатесі: ${error.description}';
            });
          },
        ),
      )
      ..loadRequest(Uri.parse(_getQuizUrl()));
  }

  String _getQuizUrl() {
    // URL для саюақ (тест)
    return 'https://tilqural.kz/lessons/99-salem-tanysaiyq-a1/';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Сабақ',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              widget.topic.title,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.normal,
                color: Colors.grey,
              ),
            ),
          ],
        ),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              _controller.reload();
            },
          ),
          PopupMenuButton<String>(
            onSelected: (value) {
              switch (value) {
                case 'home':
                  _controller.loadRequest(Uri.parse(_getQuizUrl()));
                  break;
                case 'back':
                  _controller.goBack();
                  break;
                case 'forward':
                  _controller.goForward();
                  break;
                case 'results':
                  _showResults();
                  break;
              }
            },
            itemBuilder: (BuildContext context) => [
              const PopupMenuItem<String>(
                value: 'home',
                child: Row(
                  children: [
                    Icon(Icons.home, size: 20),
                    SizedBox(width: 8),
                    Text('Басты бет'),
                  ],
                ),
              ),
              const PopupMenuItem<String>(
                value: 'back',
                child: Row(
                  children: [
                    Icon(Icons.arrow_back, size: 20),
                    SizedBox(width: 8),
                    Text('Артқа'),
                  ],
                ),
              ),
              const PopupMenuItem<String>(
                value: 'forward',
                child: Row(
                  children: [
                    Icon(Icons.arrow_forward, size: 20),
                    SizedBox(width: 8),
                    Text('Алға'),
                  ],
                ),
              ),
              const PopupMenuItem<String>(
                value: 'results',
                child: Row(
                  children: [
                    Icon(Icons.assessment, size: 20),
                    SizedBox(width: 8),
                    Text('Нәтижелер'),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
      body: Stack(
        children: [
          if (_errorMessage != null)
            _buildErrorWidget()
          else
            WebViewWidget(controller: _controller),
          if (_isLoading)
            Container(
              color: Colors.white,
              child: const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(
                        Color(0xFF9775FA),
                      ),
                    ),
                    SizedBox(height: 16),
                    Text(
                      'Саюақ жүктелуде...',
                      style: TextStyle(
                        fontSize: 16,
                        color: Color(0xFF8F9BB3),
                      ),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
      bottomNavigationBar: _buildBottomBar(),
    );
  }

  Widget _buildErrorWidget() {
    return Container(
      color: Colors.white,
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.quiz_outlined,
                size: 80,
                color: Color(0xFF9775FA),
              ),
              const SizedBox(height: 24),
              const Text(
                'Саюақ жүктелмеді',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF222B45),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                _errorMessage ?? 'Интернет байланысын тексеріңіз',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 16,
                  color: Color(0xFF8F9BB3),
                ),
              ),
              const SizedBox(height: 32),
              ElevatedButton.icon(
                onPressed: () {
                  setState(() {
                    _errorMessage = null;
                  });
                  _controller.reload();
                },
                icon: const Icon(Icons.refresh),
                label: const Text('Қайта жүктеу'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF9775FA),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 12,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBottomBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _buildBottomButton(
              icon: Icons.arrow_back,
              label: 'Артқа',
              onPressed: () async {
                if (await _controller.canGoBack()) {
                  _controller.goBack();
                }
              },
            ),
            _buildBottomButton(
              icon: Icons.arrow_forward,
              label: 'Алға',
              onPressed: () async {
                if (await _controller.canGoForward()) {
                  _controller.goForward();
                }
              },
            ),
            _buildBottomButton(
              icon: Icons.refresh,
              label: 'Жаңарту',
              onPressed: () {
                _controller.reload();
              },
            ),
            _buildBottomButton(
              icon: Icons.assessment,
              label: 'Нәтижелер',
              onPressed: _showResults,
            ),
            _buildBottomButton(
              icon: Icons.home,
              label: 'Басты',
              onPressed: () {
                _controller.loadRequest(Uri.parse(_getQuizUrl()));
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomButton({
    required IconData icon,
    required String label,
    required VoidCallback onPressed,
  }) {
    return InkWell(
      onTap: onPressed,
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 20,
              color: const Color(0xFF8F9BB3),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: const TextStyle(
                fontSize: 10,
                color: Color(0xFF8F9BB3),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showResults() {
    _controller.runJavaScript('''
      // Try to find and show quiz results
      var resultsButton = document.querySelector('.results-btn, [data-results], button[contains(text(), "результат")]');
      if (resultsButton) {
        resultsButton.click();
      } else {
        // If no results button found, try to scroll to results section
        var resultsSection = document.querySelector('.results, .quiz-results, #results');
        if (resultsSection) {
          resultsSection.scrollIntoView({ behavior: 'smooth' });
        }
      }
    ''');
  }
}
