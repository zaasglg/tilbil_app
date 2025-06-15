class AuthService {
  // Singleton pattern
  static final AuthService _instance = AuthService._internal();
  factory AuthService() => _instance;
  AuthService._internal();

  // User authentication state
  bool _isAuthenticated = false;
  String? _phoneNumber;
  String? _userName;

  // Getters
  bool get isAuthenticated => _isAuthenticated;
  String? get phoneNumber => _phoneNumber;
  String? get userName => _userName;

  // Login method
  Future<bool> login(String phoneNumber, String password) async {
    // Here you would typically make an API call to your backend
    // For now, we'll just simulate a successful login
    await Future.delayed(const Duration(seconds: 1));

    if (password.isNotEmpty) {
      _isAuthenticated = true;
      _phoneNumber = phoneNumber;
      return true;
    }

    return false;
  }

  // Register method
  Future<bool> register(
      String name, String phoneNumber, String password) async {
    // Here you would typically make an API call to your backend
    // For now, we'll just simulate a successful registration
    await Future.delayed(const Duration(seconds: 1));

    if (name.isNotEmpty && phoneNumber.isNotEmpty && password.isNotEmpty) {
      _isAuthenticated = true;
      _phoneNumber = phoneNumber;
      _userName = name;
      return true;
    }

    return false;
  }

  // Google sign in method
  Future<bool> signInWithGoogle() async {
    // Here you would implement Google Sign In
    // For now, we'll just simulate a successful login
    await Future.delayed(const Duration(seconds: 1));

    _isAuthenticated = true;
    return true;
  }

  // Logout method
  Future<void> logout() async {
    _isAuthenticated = false;
    _phoneNumber = null;
    _userName = null;
  }
}
