import 'package:get/get.dart';
import 'package:rxdart/rxdart.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ApiService extends GetConnect {
  // Example: Using RxDart's BehaviorSubject to track global loading state
  final BehaviorSubject<bool> _isLoadingSubject = BehaviorSubject<bool>.seeded(
    false,
  );

  String? _token;
  String? _resetToken;

  // Expose stream for listeners
  Stream<bool> get isLoadingStream => _isLoadingSubject.stream;

  Future<ApiService> init() async {
    final prefs = await SharedPreferences.getInstance();
    _token = prefs.getString('auth_token');
    _resetToken = prefs.getString('reset_token');
    return this;
  }

  String? getToken() => _token;
  String? getResetToken() => _resetToken;

  Future<void> saveToken(String token) async {
    _token = token;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('auth_token', token);
  }

  Future<void> saveResetToken(String resetToken) async {
    _resetToken = resetToken;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('reset_token', resetToken);
  }

  Future<void> clearToken() async {
    _token = null;
    _resetToken = null;
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('auth_token');
    await prefs.remove('reset_token');
  }

  @override
  void onInit() {
    // Base URL for API requests
    httpClient.baseUrl = 'http://10.10.7.120:8000';

    // Default timeouts
    httpClient.timeout = const Duration(seconds: 30);

    // Default content type
    httpClient.defaultContentType = 'application/json';

    // Request modifier (Interceptors)
    httpClient.addRequestModifier<dynamic>((request) {
      request.headers['Content-Type'] = 'application/json';
      request.headers['Accept'] = 'application/json';
      request.headers['Cookie'] = 'csrftoken=JzRi4cSVcW79ODedGqUV7PoqbctoDGR3';
      // Attach token if available, but NOT for password reset confirm which 
      // strictly uses the token in the JSON payload instead.
      if (!request.url.path.contains('password-reset/confirm')) {
        String? token = getToken();
        if (token != null) request.headers['Authorization'] = 'Bearer $token';
      }
      return request;
    });

    // Response modifier
    httpClient.addResponseModifier((request, response) {
      if (response.statusCode == 401) {
        // Handle unauthorized (e.g., logout)
      }
      return response;
    });
  }

  // --- REGISTRATION API ---

  /// Initiates user registration.
  /// Expects payload mapping to specific backend requirements (e.g., name, email, password).
  Stream<Response> initiateRegistration(Map<String, dynamic> payload) {
    _isLoadingSubject.add(true);
    return Stream.fromFuture(
      post('/api/user/register/initiate/', payload),
    ).doOnDone(() => _isLoadingSubject.add(false));
  }

  Stream<Response> verifyRegistration(Map<String, dynamic> payload) {
    _isLoadingSubject.add(true);
    return Stream.fromFuture(
      post('/api/user/register/verify/', payload),
    ).doOnDone(() => _isLoadingSubject.add(false));
  }

  // --- PASSWORD RESET API ---
  Stream<Response> initiatePasswordReset(Map<String, dynamic> payload) {
    _isLoadingSubject.add(true);
    return Stream.fromFuture(
      post('/api/user/password-reset/initiate/', payload),
    ).doOnDone(() => _isLoadingSubject.add(false));
  }

  Stream<Response> verifyPasswordReset(Map<String, dynamic> payload) {
    _isLoadingSubject.add(true);
    return Stream.fromFuture(
      post('/api/user/password-reset/verify/', payload),
    ).doOnDone(() => _isLoadingSubject.add(false));
  }

  Stream<Response> confirmPasswordReset(Map<String, dynamic> payload) {
    _isLoadingSubject.add(true);
    return Stream.fromFuture(
      post('/api/user/password-reset/confirm/', payload),
    ).doOnDone(() => _isLoadingSubject.add(false));
  }

  // --- LOGIN & AUTH API ---
  Stream<Response> loginUser(Map<String, dynamic> payload) {
    _isLoadingSubject.add(true);
    return Stream.fromFuture(
      post('/api/user/login/', payload),
    ).doOnDone(() => _isLoadingSubject.add(false));
  }

  Stream<Response> googleLogin(Map<String, dynamic> payload) {
    _isLoadingSubject.add(true);
    return Stream.fromFuture(
      post('/api/user/auth/google/login/', payload),
    ).doOnDone(() => _isLoadingSubject.add(false));
  }

  Stream<Response> appleLogin(Map<String, dynamic> payload) {
    _isLoadingSubject.add(true);
    return Stream.fromFuture(
      post('/api/user/auth/apple/login/', payload),
    ).doOnDone(() => _isLoadingSubject.add(false));
  }

  Stream<Response> logout() {
    _isLoadingSubject.add(true);
    return Stream.fromFuture(
      post('/api/user/logout/', {}),
    ).doOnDone(() => _isLoadingSubject.add(false));
  }

  // --- MAINTENANCE API ---
  Stream<Response> createMaintenanceTask(Map<String, dynamic> payload) {
    _isLoadingSubject.add(true);
    return Stream.fromFuture(
      post('/api/maintenance/tasks/', payload),
    ).doOnDone(() => _isLoadingSubject.add(false));
  }

  // --- PROFILE API ---
  Stream<Response> getProfile() {
    _isLoadingSubject.add(true);
    return Stream.fromFuture(
      get('/api/user/me/'),
    ).doOnDone(() => _isLoadingSubject.add(false));
  }

  Stream<Response> updateProfile(Map<String, dynamic> payload) {
    _isLoadingSubject.add(true);
    return Stream.fromFuture(
      put('/api/user/me/', payload),
    ).doOnDone(() => _isLoadingSubject.add(false));
  }

  Stream<Response> partialUpdateProfile(Map<String, dynamic> payload) {
    _isLoadingSubject.add(true);
    return Stream.fromFuture(
      patch('/api/user/me/', payload),
    ).doOnDone(() => _isLoadingSubject.add(false));
  }

  Stream<Response> deleteAccount() {
    _isLoadingSubject.add(true);
    return Stream.fromFuture(
      delete('/api/user/me/'),
    ).doOnDone(() => _isLoadingSubject.add(false));
  }

  Stream<Response> getPublicProfile(String id) {
    _isLoadingSubject.add(true);
    return Stream.fromFuture(
      get('/api/user/profile/$id/'),
    ).doOnDone(() => _isLoadingSubject.add(false));
  }

  // Example GET request wrapped in RxDart Stream
  Stream<Response> getDataStream(String endpoint) {
    _isLoadingSubject.add(true);
    return Stream.fromFuture(get(endpoint))
        .doOnData((event) {
          // Handle positive/negative behavior here if needed
        })
        .doOnDone(() => _isLoadingSubject.add(false));
  }

  // Example POST request wrapped in RxDart Stream
  Stream<Response> postDataStream(String endpoint, dynamic data) {
    _isLoadingSubject.add(true);
    return Stream.fromFuture(
      post(endpoint, data),
    ).doOnDone(() => _isLoadingSubject.add(false));
  }

  // Proper cleanup strategy
  @override
  void onClose() {
    _isLoadingSubject.close();
    super.onClose();
  }
}
