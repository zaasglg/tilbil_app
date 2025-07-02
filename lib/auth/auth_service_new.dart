import 'dart:convert';
import '../services/api_service.dart';
import '../models/app_models.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  static final AuthService _instance = AuthService._internal();
  factory AuthService() => _instance;
  AuthService._internal();

  final ApiService _apiService = ApiService();
  
  // Состояние авторизации
  bool _isAuthenticated = false;
  User? _currentUser;
  String? _currentToken;

  // Ключи для SharedPreferences
  static const String _tokenKey = 'auth_token';
  static const String _userKey = 'user_data';

  // Геттеры
  bool get isAuthenticated => _isAuthenticated;
  User? get currentUser => _currentUser;
  String? get currentToken => _currentToken;

  // Инициализация - проверяем сохраненный токен
  Future<void> initialize() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString(_tokenKey);
    final userData = prefs.getString(_userKey);

    if (token != null && userData != null) {
      try {
        final userMap = jsonDecode(userData) as Map<String, dynamic>;
        _currentToken = token;
        _currentUser = User.fromJson(userMap);
        _isAuthenticated = true;
        _apiService.setAuthToken(token);
      } catch (e) {
        // Если не удается парсить данные, очищаем их
        await _clearStoredAuth();
      }
    }
  }

  // Сохранение данных авторизации
  Future<void> _saveAuthData(String token, User user) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_tokenKey, token);
    await prefs.setString(_userKey, jsonEncode(user.toJson()));
  }

  // Очистка сохраненных данных
  Future<void> _clearStoredAuth() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_tokenKey);
    await prefs.remove(_userKey);
  }

  // Регистрация пользователя
  Future<AuthResult> register({
    required String name,
    required String surname,
    required String username,
    required String email,
    required String password,
    required String passwordConfirmation,
    required String phone,
    required String birthday,
    required String gender,
  }) async {
    try {
      // Валидация данных
      final validationError = _validateRegisterData(
        name: name,
        surname: surname,
        username: username,
        email: email,
        password: password,
        passwordConfirmation: passwordConfirmation,
        phone: phone,
        birthday: birthday,
        gender: gender,
      );

      if (validationError != null) {
        return AuthResult.error(validationError);
      }

      // Создаем запрос
      final request = RegisterRequest(
        name: name,
        email: email,
        password: password,
        passwordConfirmation: passwordConfirmation,
        phone: phone,
        birthday: birthday,
        surname: surname,
        username: username,
        gender: gender,
      );

      // Отправляем запрос на сервер
      final response = await _apiService.register(request);

      if (response.isSuccess && response.data != null) {
        // Парсим ответ
        final registerResponse = RegisterResponse.fromJson(response.data!);
        
        if (registerResponse.success && registerResponse.data != null) {
          // Сохраняем данные пользователя и токен
          _currentUser = registerResponse.data!.user;
          _currentToken = registerResponse.data!.token;
          _isAuthenticated = true;
          
          // Устанавливаем токен в API сервис
          _apiService.setAuthToken(_currentToken!);
          
          // Сохраняем в SharedPreferences
          await _saveAuthData(_currentToken!, _currentUser!);

          return AuthResult.success(
            user: _currentUser,
            token: _currentToken,
            message: registerResponse.message ?? 'Регистрация прошла успешно',
          );
        } else {
          return AuthResult.error(
            registerResponse.message ?? 'Ошибка регистрации'
          );
        }
      } else {
        return AuthResult.error(
          response.error ?? 'Ошибка при регистрации'
        );
      }
    } catch (e) {
      return AuthResult.error('Произошла ошибка: $e');
    }
  }

  // Валидация данных регистрации
  String? _validateRegisterData({
    required String name,
    required String surname,
    required String username,
    required String email,
    required String password,
    required String passwordConfirmation,
    required String phone,
    required String birthday,
    required String gender,
  }) {
    // Проверка обязательных полей
    if (name.trim().isEmpty) {
      return 'Имя не может быть пустым';
    }
    if (surname.trim().isEmpty) {
      return 'Фамилия не может быть пустой';
    }
    if (username.trim().isEmpty) {
      return 'Имя пользователя не может быть пустым';
    }
    if (email.trim().isEmpty) {
      return 'Email не может быть пустым';
    }
    if (password.isEmpty) {
      return 'Пароль не может быть пустым';
    }
    if (phone.trim().isEmpty) {
      return 'Телефон не может быть пустым';
    }

    // Проверка email
    final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+$');
    if (!emailRegex.hasMatch(email)) {
      return 'Неверный формат email';
    }

    // Проверка пароля
    if (password.length < 6) {
      return 'Пароль должен содержать минимум 6 символов';
    }
    if (password != passwordConfirmation) {
      return 'Пароли не совпадают';
    }

    // Проверка телефона (казахстанский формат)
    final phoneRegex = RegExp(r'^\+7\d{10}$');
    if (!phoneRegex.hasMatch(phone)) {
      return 'Неверный формат телефона. Используйте формат +77771234567';
    }

    // Проверка даты рождения
    try {
      final birthDate = DateTime.parse(birthday);
      final now = DateTime.now();
      final age = now.year - birthDate.year;
      
      if (birthDate.isAfter(now)) {
        return 'Дата рождения не может быть в будущем';
      }
      if (age < 5 || age > 120) {
        return 'Неверная дата рождения';
      }
    } catch (e) {
      return 'Неверный формат даты рождения. Используйте формат YYYY-MM-DD';
    }

    // Проверка пола
    if (!['male', 'female'].contains(gender.toLowerCase())) {
      return 'Пол должен быть male или female';
    }

    return null; // Все проверки пройдены
  }

  // Выход из аккаунта
  Future<void> logout() async {
    _isAuthenticated = false;
    _currentUser = null;
    _currentToken = null;
    _apiService.clearAuthToken();
    await _clearStoredAuth();
  }

  // Очистка данных
  Future<void> clear() async {
    await logout();
  }
}

// Результат операций аутентификации
class AuthResult {
  final bool isSuccess;
  final User? user;
  final String? token;
  final String? message;
  final String? error;

  AuthResult._({
    required this.isSuccess,
    this.user,
    this.token,
    this.message,
    this.error,
  });

  factory AuthResult.success({
    User? user,
    String? token,
    String? message,
  }) {
    return AuthResult._(
      isSuccess: true,
      user: user,
      token: token,
      message: message,
    );
  }

  factory AuthResult.error(String error) {
    return AuthResult._(
      isSuccess: false,
      error: error,
    );
  }
}
