import 'package:another_flutter_splash_screen/another_flutter_splash_screen.dart';
import 'package:flutter/material.dart';
// ignore: depend_on_referenced_packages
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'screens/language_selection_screen.dart';
import 'screens/onboarding_screen.dart';
import 'screens/main_screen.dart';
import 'auth/login_screen.dart';
import 'auth/multi_step_register_screen.dart';
import 'auth/auth_service.dart';
import 'services/language_service.dart';
import 'l10n/app_localizations.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Инициализируем сервисы при запуске приложения
  final authService = AuthService();
  // await authService.initialize();

  final languageService = LanguageService();
  await languageService.initialize();

  // Проверяем, выбрал ли пользователь язык
  final prefs = await SharedPreferences.getInstance();
  final hasSelectedLanguage = prefs.containsKey('selected_language');

  runApp(MyApp(
    isAuthenticated: authService.isAuthenticated,
    languageService: languageService,
    hasSelectedLanguage: hasSelectedLanguage,
  ));
}

class MyApp extends StatelessWidget {
  final bool isAuthenticated;
  final LanguageService languageService;
  final bool hasSelectedLanguage;

  const MyApp({
    super.key,
    required this.isAuthenticated,
    required this.languageService,
    required this.hasSelectedLanguage,
  });

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: languageService,
      child: Consumer<LanguageService>(
        builder: (context, languageService, child) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Til Bil App',

            // Localization configuration
            localizationsDelegates: const [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: LanguageService.supportedLocales,
            locale: languageService.currentLocale,

            theme: ThemeData(
              colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
              useMaterial3: false,
              textTheme: GoogleFonts.nunitoSansTextTheme(),
            ),
            routes: {
              '/language-selection': (context) =>
                  const LanguageSelectionScreen(),
              '/onboarding': (context) => const OnboardingScreen(),
              '/main': (context) => const MainScreen(),
              '/login': (context) => const LoginScreen(),
              '/register': (context) => const MultiStepRegisterScreen(),
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
              onInit: () {},
              onEnd: () {},
              childWidget: SizedBox(
                height: 200,
                width: 200,
                child: SvgPicture.asset("assets/icons/logo.svg"),
              ),
              duration: const Duration(milliseconds: 3000),
              onAnimationEnd: () => debugPrint("On Fade In End"),
              nextScreen: const LanguageSelectionScreen(),
            ),
          );
        },
      ),
    );
  }

  Widget _getNextScreen() {
    if (!hasSelectedLanguage) {
      return const LanguageSelectionScreen();
    } else if (isAuthenticated) {
      return const MainScreen();
    } else {
      return const OnboardingScreen();
    }
  }
}
