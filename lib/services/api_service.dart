import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import '../models/app_models.dart';

class ApiService {
  // Используем тестовый URL или локальный
  static const String baseUrl = 'https://api.baulu.kz/';
  static const bool useMockData = true; // Переключатель для тестирования без сервера
  
  // Singleton pattern
  static final ApiService _instance = ApiService._internal();
  factory ApiService() => _instance;
  ApiService._internal();

  // HTTP клиент
  final http.Client _client = http.Client();
  
  // Токен авторизации
  String? _authToken;

  // Геттер для токена
  String? get authToken => _authToken;

  // Установка токена
  void setAuthToken(String token) {
    _authToken = token;
  }

  // Очистка токена
  void clearAuthToken() {
    _authToken = null;
  }

  // Базовые заголовки
  Map<String, String> get _baseHeaders => {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
    if (_authToken != null) 'Authorization': 'Bearer $_authToken',
  };

  // Регистрация пользователя
  Future<ApiResponse> register(RegisterRequest request) async {
    // Если используем мок данные, возвращаем успешный ответ
    if (useMockData) {
      return await _getMockRegisterResponse(request);
    }
    
    try {
      final response = await _client.post(
        Uri.parse('${baseUrl}api/register'),
        headers: _baseHeaders,
        body: json.encode(request.toJson()),
      ).timeout(
        const Duration(seconds: 10),
        onTimeout: () {
          throw Exception('Время ожидания ответа истекло');
        },
      );

      return _handleResponse(response);
    } on SocketException {
      return ApiResponse.error('Нет подключения к интернету');
    } on HttpException {
      return ApiResponse.error('Ошибка HTTP соединения');
    } on FormatException {
      return ApiResponse.error('Неверный формат данных');
    } catch (e) {
      return ApiResponse.error('Ошибка подключения: ${e.toString()}');
    }
  }

  // Мок ответ для регистрации (для тестирования)
  Future<ApiResponse> _getMockRegisterResponse(RegisterRequest request) async {
    // Симулируем задержку сети
    await Future.delayed(const Duration(seconds: 1));
    
    final mockUser = User(
      id: 1,
      name: request.name,
      surname: request.surname,
      username: request.username,
      email: request.email,
      phone: request.phone,
      birthday: request.birthday,
      gender: request.gender,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );

    final registerData = RegisterData(
      user: mockUser,
      token: 'mock_token_${DateTime.now().millisecondsSinceEpoch}',
    );

    // Возвращаем успешный ответ с мок данными
    return ApiResponse.success({
      'success': true,
      'message': 'Регистрация прошла успешно!',
      'data': {
        'user': mockUser.toJson(),
        'token': registerData.token,
      }
    });
  }

  // Авторизация пользователя
  Future<ApiResponse> login(LoginRequest request) async {
    if (useMockData) {
      return await _getMockLoginResponse(request);
    }
    
    try {
      final response = await _client.post(
        Uri.parse('${baseUrl}api/login'),
        headers: _baseHeaders,
        body: json.encode(request.toJson()),
      ).timeout(
        const Duration(seconds: 10),
        onTimeout: () {
          throw Exception('Время ожидания ответа истекло');
        },
      );

      return _handleResponse(response);
    } on SocketException {
      return ApiResponse.error('Нет подключения к интернету');
    } on HttpException {
      return ApiResponse.error('Ошибка HTTP соединения');
    } on FormatException {
      return ApiResponse.error('Неверный формат данных');
    } catch (e) {
      return ApiResponse.error('Ошибка подключения: ${e.toString()}');
    }
  }

  // Мок ответ для входа
  Future<ApiResponse> _getMockLoginResponse(LoginRequest request) async {
    await Future.delayed(const Duration(seconds: 1));
    
    // Простая проверка для демо (используем email вместо phone)
    if (request.email == 'test@example.com' && request.password == 'password') {
      final mockUser = User(
        id: 1,
        name: 'Тест',
        surname: 'Пользователь', 
        username: 'testuser',
        email: request.email,
        phone: '+77771234567',
        birthday: '1990-01-01',
        gender: 'male',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      return ApiResponse.success({
        'success': true,
        'message': 'Авторизация прошла успешно!',
        'data': {
          'user': mockUser.toJson(),
          'token': 'mock_login_token_${DateTime.now().millisecondsSinceEpoch}',
        }
      });
    } else {
      return ApiResponse.error('Неверный email или пароль');
    }
  }

  // Обработка HTTP ответа
  ApiResponse _handleResponse(http.Response response) {
    try {
      final data = json.decode(response.body);
      
      if (response.statusCode >= 200 && response.statusCode < 300) {
        return ApiResponse.success(data);
      } else {
        // Обработка ошибок с сервера
        String errorMessage = 'Неизвестная ошибка';
        
        if (data is Map<String, dynamic>) {
          if (data.containsKey('message')) {
            errorMessage = data['message'].toString();
          } else if (data.containsKey('errors')) {
            final errors = data['errors'];
            if (errors is Map<String, dynamic>) {
              List<String> errorList = [];
              errors.forEach((key, value) {
                if (value is List) {
                  errorList.addAll(value.cast<String>());
                } else {
                  errorList.add(value.toString());
                }
              });
              errorMessage = errorList.join(', ');
            }
          }
        }
        
        return ApiResponse.error(errorMessage);
      }
    } catch (e) {
      return ApiResponse.error('Ошибка обработки ответа: $e');
    }
  }

  // Универсальный POST запрос
  Future<ApiResponse> post(String endpoint, {Map<String, dynamic>? body}) async {
    try {
      final response = await _client.post(
        Uri.parse('$baseUrl$endpoint'),
        headers: _baseHeaders,
        body: body != null ? json.encode(body) : null,
      ).timeout(
        const Duration(seconds: 10),
        onTimeout: () {
          throw Exception('Время ожидания ответа истекло');
        },
      );

      return _handleResponse(response);
    } on SocketException {
      return ApiResponse.error('Нет подключения к интернету');
    } on HttpException {
      return ApiResponse.error('Ошибка HTTP соединения');
    } on FormatException {
      return ApiResponse.error('Неверный формат данных');
    } catch (e) {
      return ApiResponse.error('Ошибка подключения: $e');
    }
  }

  // Универсальный GET запрос
  Future<ApiResponse> get(String endpoint) async {
    try {
      final response = await _client.get(
        Uri.parse('$baseUrl$endpoint'),
        headers: _baseHeaders,
      ).timeout(
        const Duration(seconds: 10),
        onTimeout: () {
          throw Exception('Время ожидания ответа истекло');
        },
      );

      return _handleResponse(response);
    } on SocketException {
      return ApiResponse.error('Нет подключения к интернету');
    } on HttpException {
      return ApiResponse.error('Ошибка HTTP соединения');
    } on FormatException {
      return ApiResponse.error('Неверный формат данных');
    } catch (e) {
      return ApiResponse.error('Ошибка подключения: $e');
    }
  }

  // Выход из системы
  Future<ApiResponse> logout() async {
    if (useMockData) {
      // Мок ответ для выхода
      await Future.delayed(const Duration(milliseconds: 500));
      return ApiResponse.success({
        'success': true,
        'message': 'Выход выполнен успешно',
      });
    }
    
    try {
      final response = await _client.post(
        Uri.parse('${baseUrl}api/logout'),
        headers: _baseHeaders,
      ).timeout(
        const Duration(seconds: 10),
        onTimeout: () {
          throw Exception('Время ожидания ответа истекло');
        },
      );

      return _handleResponse(response);
    } on SocketException {
      return ApiResponse.error('Нет подключения к интернету');
    } on HttpException {
      return ApiResponse.error('Ошибка HTTP соединения');
    } on FormatException {
      return ApiResponse.error('Неверный формат данных');
    } catch (e) {
      return ApiResponse.error('Ошибка подключения: ${e.toString()}');
    }
  }

  // Закрытие клиента
  void dispose() {
    _client.close();
  }
}

// Модель ответа API
class ApiResponse {
  final bool isSuccess;
  final Map<String, dynamic>? data;
  final String? error;
  final int? statusCode;

  ApiResponse._(this.isSuccess, this.data, this.error, this.statusCode);

  factory ApiResponse.success(Map<String, dynamic> data) {
    return ApiResponse._(true, data, null, null);
  }

  factory ApiResponse.error(String error, {int? statusCode}) {
    return ApiResponse._(false, null, error, statusCode);
  }
}
