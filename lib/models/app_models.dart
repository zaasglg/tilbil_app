// Модель пользователя
class User {
  final int id;
  final String name;
  final String surname;
  final String username;
  final String email;
  final String phone;
  final String birthday;
  final String gender;
  final String? avatar;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  User({
    required this.id,
    required this.name,
    required this.surname,
    required this.username,
    required this.email,
    required this.phone,
    required this.birthday,
    required this.gender,
    this.avatar,
    this.createdAt,
    this.updatedAt,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] as int,
      name: json['name'] as String,
      surname: json['surname'] as String,
      username: json['username'] as String,
      email: json['email'] as String,
      phone: json['phone'] as String,
      birthday: json['birthday'] as String,
      gender: json['gender'] as String,
      avatar: json['avatar'] as String?,
      createdAt: json['created_at'] != null 
          ? DateTime.parse(json['created_at'] as String)
          : null,
      updatedAt: json['updated_at'] != null 
          ? DateTime.parse(json['updated_at'] as String)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'surname': surname,
      'username': username,
      'email': email,
      'phone': phone,
      'birthday': birthday,
      'gender': gender,
      'avatar': avatar,
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }
}

// Модель ответа регистрации
class RegisterResponse {
  final bool success;
  final String? message;
  final RegisterData? data;

  RegisterResponse({
    required this.success,
    this.message,
    this.data,
  });

  factory RegisterResponse.fromJson(Map<String, dynamic> json) {
    return RegisterResponse(
      success: json['success'] as bool,
      message: json['message'] as String?,
      data: json['data'] != null 
          ? RegisterData.fromJson(json['data'] as Map<String, dynamic>)
          : null,
    );
  }
}

// Модель данных регистрации
class RegisterData {
  final User user;
  final String token;

  RegisterData({
    required this.user,
    required this.token,
  });

  factory RegisterData.fromJson(Map<String, dynamic> json) {
    return RegisterData(
      user: User.fromJson(json['user'] as Map<String, dynamic>),
      token: json['token'] as String,
    );
  }
}

// Модель запроса входа
class LoginRequest {
  final String email;
  final String password;

  LoginRequest({
    required this.email,
    required this.password,
  });

  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'password': password,
    };
  }
}

// Модель ответа входа
class LoginResponse {
  final bool success;
  final String? message;
  final LoginData? data;

  LoginResponse({
    required this.success,
    this.message,
    this.data,
  });

  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    return LoginResponse(
      success: json['success'] as bool,
      message: json['message'] as String?,
      data: json['data'] != null 
          ? LoginData.fromJson(json['data'] as Map<String, dynamic>)
          : null,
    );
  }
}

// Модель данных входа
class LoginData {
  final User user;
  final String token;

  LoginData({
    required this.user,
    required this.token,
  });

  factory LoginData.fromJson(Map<String, dynamic> json) {
    return LoginData(
      user: User.fromJson(json['user'] as Map<String, dynamic>),
      token: json['token'] as String,
    );
  }
}

// Модель запроса регистрации
class RegisterRequest {
  final String name;
  final String email;
  final String password;
  final String passwordConfirmation;
  final String phone;
  final String birthday;
  final String surname;
  final String username;
  final String gender;

  RegisterRequest({
    required this.name,
    required this.email,
    required this.password,
    required this.passwordConfirmation,
    required this.phone,
    required this.birthday,
    required this.surname,
    required this.username,
    required this.gender,
  });

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'email': email,
      'password': password,
      'password_confirmation': passwordConfirmation,
      'phone': phone,
      'birthday': birthday,
      'surname': surname,
      'username': username,
      'gender': gender,
    };
  }
}
