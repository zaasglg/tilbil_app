import 'package:another_flutter_splash_screen/another_flutter_splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'screens/onboarding_screen.dart';
import 'screens/home_screen.dart';
import 'screens/main_screen.dart';
import 'auth/login_screen.dart';
import 'auth/register_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Til Bil App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: false,
        fontFamily: "AtypDisplay",
      ),
      routes: {
        '/home': (context) => const HomeScreen(),
        '/main': (context) => const MainScreen(),
        '/login': (context) => const LoginScreen(),
        '/register': (context) => const RegisterScreen(),
      },
      home: FlutterSplashScreen.fadeIn(
        gradient: const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color(0xFF56B9CB),
            Color(0xFF3371B9),
          ],
        ),
        onInit: () {
          // debugPrint("On Init");
        },
        onEnd: () {
          // debugPrint("On End");
        },
        childWidget: SizedBox(
          height: 200,
          width: 200,
          child: SvgPicture.asset("assets/icons/logo.svg"),
        ),
        duration: const Duration(milliseconds: 3000),
        onAnimationEnd: () => debugPrint("On Fade In End"),
        nextScreen: const OnboardingScreen(),
      ),
    );
  }
}
