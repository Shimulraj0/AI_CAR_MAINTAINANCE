import 'package:get/get.dart';

class ApiService extends GetConnect {
  @override
  void onInit() {
    // Base URL for API requests
    httpClient.baseUrl = 'https://api.yourbackend.com';

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

  // Example GET request
  Future<Response> getData(String endpoint) => get(endpoint);

  // Example POST request
  Future<Response> postData(String endpoint, dynamic data) =>
      post(endpoint, data);
}
