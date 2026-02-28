import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'routes/app_pages.dart';
import 'services/api_service.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  // 1. Handle asynchronous errors globally
  PlatformDispatcher.instance.onError = (error, stack) {
    debugPrint('Async Error Caught: $error');
    // We can also send this to Crashlytics later
    return true;
  };

  // 2. Handle Flutter framework errors globally
  FlutterError.onError = (FlutterErrorDetails details) {
    debugPrint('Flutter Error Caught: ${details.exception}');
    FlutterError.presentError(details);
  };

  // 3. Prevent Grey Screen of Death visually
  ErrorWidget.builder = (FlutterErrorDetails details) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.error_outline,
                color: Colors.redAccent,
                size: 48,
              ),
              const SizedBox(height: 16),
              const Text(
                "We encountered a slight issue loading this section.",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16, color: Colors.black54),
              ),
              const SizedBox(height: 12),
              Text(
                details.exceptionAsString(),
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 10, color: Colors.grey),
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  };

  // Initialize Services (e.g., ApiService) before running the app
  // This is where you would also initialize Firebase, LocalStorage, etc.
  Get.put(ApiService());

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Auto Intel',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      // INITIAL ROUTE DEFINITION
      initialRoute: AppPages.initial,
      // DEFAULT TRANSITION
      defaultTransition: Transition.rightToLeftWithFade,
      transitionDuration: const Duration(milliseconds: 300),
      // GETPAGES DEFINITION (Centralized Routing)
      getPages: AppPages.routes,
    );
  }
}
