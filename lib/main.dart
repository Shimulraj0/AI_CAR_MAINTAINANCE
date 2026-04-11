import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'routes/app_pages.dart';
import 'services/api_service.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

import 'services/push_notification_service.dart';
import 'services/iap_service.dart';
import 'utils/responsive_helper.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    if (Firebase.apps.isEmpty) {
      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );
    }
  } catch (e) {
    if (!e.toString().contains('duplicate-app')) {
      rethrow;
    }
  }

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
    return Material(
      type: MaterialType.transparency,
      child: Directionality(
        textDirection: TextDirection.ltr,
        child: Container(
          color: Colors.white,
          child: Center(
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
                  Flexible(
                    child: SingleChildScrollView(
                      child: Text(
                        details.exceptionAsString(),
                        textAlign: TextAlign.center,
                        style: const TextStyle(fontSize: 10, color: Colors.grey),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  };

  // Initialize Services (e.g., ApiService) before running the app
  // This is where you would also initialize Firebase, LocalStorage, etc.
  await Get.putAsync(() => ApiService().init());
  await Get.putAsync<IAPService>(() async => Get.put(IAPService()));

  // Initialize Push Notifications in the background so it doesn't block UI load
  final pushNotificationService = PushNotificationService();
  pushNotificationService.initialize().catchError((e) {
    debugPrint("Push notification initialization error: $e");
  });

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return GetMaterialApp(
          title: 'Auto Intel',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
            useMaterial3: true,
          ),
          builder: (context, child) {
            // Initialize ResponsiveHelper here or in a wrapper
            ResponsiveHelper.init(context);
            return MediaQuery(
              data: MediaQuery.of(context).copyWith(
                textScaler: TextScaler.linear(
                  MediaQuery.of(context).textScaler.scale(1.0).clamp(0.8, 1.2),
                ),
              ),
              child: child!,
            );
          },
          // INITIAL ROUTE DEFINITION
          initialRoute: AppPages.initial,
          // DEFAULT TRANSITION
          defaultTransition: Transition.rightToLeftWithFade,
          transitionDuration: const Duration(milliseconds: 300),
          // GETPAGES DEFINITION (Centralized Routing)
          getPages: AppPages.routes,
        );
      },
    );
  }
}
