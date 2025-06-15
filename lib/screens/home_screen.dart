import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Til Bil'),
        backgroundColor: const Color(0xFF3371B9),
        foregroundColor: Colors.white,
      ),
      body: const Center(
        child: Text(
          'Welcome to Til Bil App!',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
