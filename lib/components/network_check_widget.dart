import 'package:flutter/material.dart';
import 'dart:io';

class NetworkCheckWidget extends StatefulWidget {
  final Widget child;
  
  const NetworkCheckWidget({
    super.key,
    required this.child,
  });

  @override
  State<NetworkCheckWidget> createState() => _NetworkCheckWidgetState();
}

class _NetworkCheckWidgetState extends State<NetworkCheckWidget> {
  bool _isConnected = true;
  bool _isChecking = false;

  @override
  void initState() {
    super.initState();
    _checkConnection();
  }

  Future<void> _checkConnection() async {
    setState(() {
      _isChecking = true;
    });

    try {
      // Проверяем подключение к интернету
      final result = await InternetAddress.lookup('google.com').timeout(
        const Duration(seconds: 5),
      );
      if (mounted) {
        setState(() {
          _isConnected = result.isNotEmpty && result[0].rawAddress.isNotEmpty;
        });
      }
    } on SocketException catch (_) {
      if (mounted) {
        setState(() {
          _isConnected = false;
        });
      }
    } catch (_) {
      if (mounted) {
        setState(() {
          _isConnected = false;
        });
      }
    }

    if (mounted) {
      setState(() {
        _isChecking = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isConnected) {
      return widget.child;
    }

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Иконка отсутствия соединения
              Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.wifi_off,
                  size: 60,
                  color: Colors.grey[600],
                ),
              ),
              
              const SizedBox(height: 32),
              
              // Заголовок
              Text(
                'Нет подключения к интернету',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[800],
                ),
                textAlign: TextAlign.center,
              ),
              
              const SizedBox(height: 16),
              
              // Описание
              Text(
                'Проверьте подключение Wi-Fi или мобильных данных и попробуйте еще раз',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey[600],
                  height: 1.5,
                ),
                textAlign: TextAlign.center,
              ),
              
              const SizedBox(height: 48),
              
              // Кнопка повторной проверки
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: _isChecking ? null : _checkConnection,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF1CB0F6),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: _isChecking
                      ? const SizedBox(
                          width: 24,
                          height: 24,
                          child: CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                            strokeWidth: 2,
                          ),
                        )
                      : const Text(
                          'Повторить попытку',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                ),
              ),
              
              const SizedBox(height: 16),
              
              // Кнопка "Продолжить без интернета" (для тестирования)
              TextButton(
                onPressed: () {
                  setState(() {
                    _isConnected = true;
                  });
                },
                child: Text(
                  'Продолжить в автономном режиме',
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 16,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
