import 'package:get/get.dart';
import 'package:rxdart/rxdart.dart';

class ApiService extends GetConnect {
  // Example: Using RxDart's BehaviorSubject to track global loading state
  final BehaviorSubject<bool> _isLoadingSubject = BehaviorSubject<bool>.seeded(
    false,
  );

  // Expose stream for listeners
  Stream<bool> get isLoadingStream => _isLoadingSubject.stream;

  @override
  void onInit() {
    // Base URL for API requests
    httpClient.baseUrl = 'http://10.10.7.120:8000';

    // Default timeouts
    httpClient.timeout = const Duration(seconds: 30);

    // Request modifier (Interceptors)
    httpClient.addRequestModifier<dynamic>((request) {
      request.headers['Authorization'] = 'Bearer YOUR_TOKEN'; // Example
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
