import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'routes/app_pages.dart';
import 'services/api_service.dart';

void main() {
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
      // GETPAGES DEFINITION (Centralized Routing)
      getPages: AppPages.routes,
    );
  }
}
