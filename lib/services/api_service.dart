import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:rxdart/rxdart.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ApiService extends GetConnect {
  // Example: Using RxDart's BehaviorSubject to track global loading state
  final BehaviorSubject<bool> _isLoadingSubject = BehaviorSubject<bool>.seeded(
    false,
  );

  String? _token;
  String? _resetToken;
  String? _csrfToken;
  String? _sessionId;
  late final String apiBaseUrl;

  // Expose stream for listeners
  Stream<bool> get isLoadingStream => _isLoadingSubject.stream;

  Future<ApiService> init() async {
    final prefs = await SharedPreferences.getInstance();
    _token = prefs.getString('auth_token');
    _resetToken = prefs.getString('reset_token');
    _csrfToken = prefs.getString('csrf_token') ?? 'JzRi4cSVcW79ODedGqUV7PoqbctoDGR3';
    _sessionId = prefs.getString('last_session_id');
    _rememberMe = prefs.getBool('remember_me') ?? false;

    // Base URL for API requests
    apiBaseUrl = 'http://10.10.7.120:8000';
    baseUrl = apiBaseUrl;
    httpClient.baseUrl = apiBaseUrl;
    httpClient.timeout = const Duration(seconds: 30);
    httpClient.defaultContentType = 'application/json';

    return this;
  }

  bool _rememberMe = false;

  bool getRememberMe() => _rememberMe;

  Future<void> saveRememberMe(bool value) async {
    _rememberMe = value;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('remember_me', value);
  }

  String? getToken() => _token;
  String? getResetToken() => _resetToken;
  String? getCsrfToken() => _csrfToken;
  String? getSessionId() => _sessionId;

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

  Future<void> saveCsrfToken(String csrfToken) async {
    _csrfToken = csrfToken;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('csrf_token', csrfToken);
  }

  Future<void> saveSessionId(String sessionId) async {
    _sessionId = sessionId;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('last_session_id', sessionId);
  }

  Future<void> clearSessionId() async {
    _sessionId = null;
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('last_session_id');
  }

  Future<void> clearToken() async {
    _token = null;
    _resetToken = null;
    _csrfToken = null;
    _sessionId = null;
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('auth_token');
    await prefs.remove('reset_token');
    await prefs.remove('csrf_token');
    await prefs.remove('last_session_id');
    await prefs.remove('remember_me');
    _rememberMe = false;
  }

  @override
  void onInit() {
    // Request modifier (Interceptors)
    httpClient.addRequestModifier<dynamic>((request) {
      // Only set application/json if the body is not FormData
      final isMultipart = request.headers['content-type']?.contains('multipart/form-data') ?? false;
      if (!isMultipart) {
          request.headers['Content-Type'] = 'application/json';
      }
      request.headers['Accept'] = 'application/json';
      
      String? csrf = getCsrfToken();
      if (csrf != null) {
        request.headers['Cookie'] = 'csrftoken=$csrf';
      }

      // Attach token if available
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

  /// Recursively searches for a key in a nested Map or List structure.
  dynamic recursiveSearch(dynamic data, String key) {
    if (data is Map) {
      if (data.containsKey(key)) return data[key];
      for (var value in data.values) {
        final result = recursiveSearch(value, key);
        if (result != null) return result;
      }
    } else if (data is List) {
      for (var item in data) {
        final result = recursiveSearch(item, key);
        if (result != null) return result;
      }
    }
    return null;
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
    return Stream.fromFuture(_verifyRegistrationHttp(payload))
        .doOnDone(() => _isLoadingSubject.add(false));
  }

  Future<Response> _verifyRegistrationHttp(Map<String, dynamic> payload) async {
    final url = Uri.parse('$apiBaseUrl/api/user/register/verify/');
    final headers = await _getHeaders();
    
    try {
      final request = http.Request('POST', url);
      request.body = json.encode(payload);
      request.headers.addAll(headers);

      final streamedResponse = await request.send();
      final responseBody = await streamedResponse.stream.bytesToString();

      dynamic decodedBody;
      try {
        decodedBody = json.decode(responseBody);
      } catch (_) {
        decodedBody = responseBody;
      }

      return Response(
        statusCode: streamedResponse.statusCode,
        body: decodedBody,
        bodyString: responseBody,
        headers: streamedResponse.headers,
      );
    } catch (e) {
      debugPrint('Http Error in verifyRegistration: $e');
      return Response(statusCode: 500, statusText: e.toString());
    }
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
    return Stream.fromFuture(_loginUserHttp(payload))
        .doOnDone(() => _isLoadingSubject.add(false));
  }

  Future<Response> _loginUserHttp(Map<String, dynamic> payload) async {
    final url = Uri.parse('$apiBaseUrl/api/user/login/');
    final headers = await _getHeaders();
    
    try {
      final request = http.Request('POST', url);
      request.body = json.encode(payload);
      request.headers.addAll(headers);

      final streamedResponse = await request.send();
      final responseBody = await streamedResponse.stream.bytesToString();

      dynamic decodedBody;
      try {
        decodedBody = json.decode(responseBody);
      } catch (_) {
        decodedBody = responseBody;
      }

      return Response(
        statusCode: streamedResponse.statusCode,
        body: decodedBody,
        bodyString: responseBody,
        headers: streamedResponse.headers,
      );
    } catch (e) {
      debugPrint('Http Error in loginUser: $e');
      return Response(statusCode: 500, statusText: e.toString());
    }
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

  Future<http.Response> getMaintenanceStats() async {
    final url = Uri.parse('$apiBaseUrl/api/maintenance/tasks/stats/');
    final headers = await _getHeaders();
    
    _isLoadingSubject.add(true);
    try {
      final response = await http.get(
        url,
        headers: headers,
      );
      
      if (response.statusCode != 200) {
        debugPrint('Get Maintenance Stats Error Status: ${response.statusCode}');
        debugPrint('Get Maintenance Stats Error Body: ${response.body}');
      }
      
      return response;
    } catch (e) {
      debugPrint('Get Maintenance Stats Exception: $e');
      rethrow;
    } finally {
      _isLoadingSubject.add(false);
    }
  }

  Future<http.Response> getMaintenanceTasks(String status, {int page = 1}) async {
    final url = Uri.parse('$apiBaseUrl/api/maintenance/tasks/?status=$status&page=$page');
    final headers = await _getHeaders();
    
    _isLoadingSubject.add(true);
    try {
      final response = await http.get(
        url,
        headers: headers,
      );
      
      if (response.statusCode != 200) {
        debugPrint('Get Maintenance Tasks Error Status: ${response.statusCode}');
        debugPrint('Get Maintenance Tasks Error Body: ${response.body}');
      }
      
      return response;
    } catch (e) {
      debugPrint('Get Maintenance Tasks Exception: $e');
      rethrow;
    } finally {
      _isLoadingSubject.add(false);
    }
  }
  Future<Map<String, String>> _getHeaders() async {
    final Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };

    String? token = getToken();
    if (token != null) headers['Authorization'] = 'Bearer $token';

    String? csrf = getCsrfToken();
    if (csrf != null) {
      headers['Cookie'] = 'csrftoken=$csrf';
      headers['X-CSRFToken'] = csrf;
    }

    return headers;
  }

  // --- DIAGNOSTICS & AI CHAT API ---
  Future<http.Response> normalChat(Map<String, dynamic> payload) async {
    final url = Uri.parse('$apiBaseUrl/api/diagnostics/normal-chat/');
    final headers = await _getHeaders();
    
    _isLoadingSubject.add(true);
    try {
      debugPrint('ApiService: POST $url');
      debugPrint('ApiService: Payload: ${json.encode(payload)}');
      
      final response = await http.post(
        url,
        headers: headers,
        body: json.encode(payload),
      );
      
      if (response.statusCode != 200 && response.statusCode != 201) {
        debugPrint('Normal Chat Error Status: ${response.statusCode}');
        debugPrint('Normal Chat Error Body: ${response.body}');
      }
      
      return response;
    } catch (e) {
      debugPrint('Normal Chat Exception: $e');
      rethrow;
    } finally {
      _isLoadingSubject.add(false);
    }
  }

  Future<http.Response> createDiagnostic(Map<String, dynamic> payload) async {
    final url = Uri.parse('$apiBaseUrl/api/diagnostics/');
    final headers = await _getHeaders();
    
    _isLoadingSubject.add(true);
    try {
      final response = await http.post(
        url,
        headers: headers,
        body: json.encode(payload),
      );
      
      if (response.statusCode == 200 || response.statusCode == 201) {
        final body = json.decode(response.body);
        final sessionId = recursiveSearch(body, 'session_id') ?? 
                        recursiveSearch(body, 'id') ?? 
                        recursiveSearch(body, 'uuid');

        if (sessionId != null) {
          await saveSessionId(sessionId.toString());
        }
      } else {
        debugPrint('Create Diagnostic Error Status: ${response.statusCode}');
        debugPrint('Create Diagnostic Error Body: ${response.body}');
      }
      
      return response;
    } catch (e) {
      debugPrint('Create Diagnostic Exception: $e');
      rethrow;
    } finally {
      _isLoadingSubject.add(false);
    }
  }

  Future<http.Response> getDiagnosticDetails(String id) async {
    final url = Uri.parse('$apiBaseUrl/api/diagnostics/$id/');
    final headers = await _getHeaders();
    
    _isLoadingSubject.add(true);
    try {
      final response = await http.get(
        url,
        headers: headers,
      );
      
      if (response.statusCode != 200) {
        debugPrint('Get Diagnostic Details Error Status: ${response.statusCode}');
        debugPrint('Get Diagnostic Details Error Body: ${response.body}');
      }
      
      return response;
    } catch (e) {
      debugPrint('Get Diagnostic Details Exception: $e');
      rethrow;
    } finally {
      _isLoadingSubject.add(false);
    }
  }

  // Updated to return raw bytes using http package for reliability with binary data
  // Updated to match working snippet exactly
  Future<http.Response> exportDiagnosticPdf(String sessionId) async {
    final url = Uri.parse('$apiBaseUrl/api/diagnostics/export/pdf/');
    final headers = await _getHeaders();
    
    _isLoadingSubject.add(true);
    try {
      // Using http.post directly with encoded body as in user's working snippet
      final response = await http.post(
        url,
        headers: headers,
        body: json.encode({'session_id': sessionId}),
      );
      
      if (response.statusCode != 200) {
        debugPrint('Export PDF Error Status: ${response.statusCode}');
        debugPrint('Export PDF Error Body: ${response.body}');
      }
      
      return response;
    } catch (e) {
      debugPrint('Export PDF Exception: $e');
      rethrow;
    } finally {
      _isLoadingSubject.add(false);
    }
  }

  // --- VEHICLES API ---
  Stream<Response> getVehicles() {
    _isLoadingSubject.add(true);
    return Stream.fromFuture(
      get('/api/vehicles/'),
    ).doOnDone(() => _isLoadingSubject.add(false));
  }

  Stream<Response> addVehicle(Map<String, dynamic> payload) {
    _isLoadingSubject.add(true);
    return Stream.fromFuture(
      post('/api/vehicles/', payload),
    ).doOnDone(() => _isLoadingSubject.add(false));
  }

  Stream<Response> updateVehicle(String id, Map<String, dynamic> payload) {
    _isLoadingSubject.add(true);
    // Assuming the backend supports PATCH or PUT for updating a vehicle by ID.
    return Stream.fromFuture(
      patch('/api/vehicles/$id/', payload),
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

  Stream<Response> updateProfileWithImage(FormData formData) {
    _isLoadingSubject.add(true);
    return Stream.fromFuture(
      patch('/api/user/me/', formData),
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
