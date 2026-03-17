import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:async';
import '../services/api_service.dart';
import 'home_controller.dart';

class ChatMessage {
  final String text;
  final bool isUser;
  final List<String>? options;

  ChatMessage({required this.text, required this.isUser, this.options});
}

class AiChatController extends GetxController {
  final ApiService _apiService = Get.find<ApiService>();
  final textController = TextEditingController();
  final scrollController = ScrollController();

  // Observable list of messages
  final messages = <ChatMessage>[].obs;
  final isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    // Load initial welcome message
    messages.add(
      ChatMessage(
        text: "Hello! I'm your Autointel Assistant. How can I help you with your vehicle today?",
        isUser: false,
      ),
    );
  }

  @override
  void onClose() {
    textController.dispose();
    scrollController.dispose();
    super.onClose();
  }

  Future<void> sendMessage(String text) async {
    if (text.trim().isEmpty || isLoading.value) return;

    final userText = text.trim();
    // Add user message
    messages.add(ChatMessage(text: userText, isUser: true));

    // Clear the text field
    textController.clear();
    _scrollToBottom();

    isLoading.value = true;

    try {
      // Include active vehicle context if available
      final Map<String, dynamic> payload = {'message': userText};
      if (Get.isRegistered<HomeController>()) {
        final activeVehicle = Get.find<HomeController>().activeVehicleId.value;
        if (activeVehicle.isNotEmpty) {
          payload['vehicle'] = activeVehicle;
        }
      }

      debugPrint('AiChatController: Sending payload: $payload');

      _apiService.normalChat(payload).listen(
        (response) {
          if (response.statusCode == 200 || response.statusCode == 201) {
            final data = response.body;
            final aiText = _apiService.parseAiResponse(data);

            if (aiText.isEmpty) {
              messages.add(ChatMessage(
                text: "I'm sorry, I couldn't process that response.",
                isUser: false,
              ));
            } else {
              // Handle options if present in the response
              List<String>? options;
              if (data is Map &&
                  data['options'] != null &&
                  data['options'] is List) {
                options = List<String>.from(data['options']);
              }

              messages.add(
                ChatMessage(text: aiText, isUser: false, options: options),
              );
            }
          } else {
            debugPrint('AiChatController: API Error ${response.statusCode}');
            messages.add(
              ChatMessage(
                text:
                    "Sorry, I'm having trouble connecting to the service. Please try again later.",
                isUser: false,
              ),
            );
          }
          isLoading.value = false;
          _scrollToBottom();
        },
        onError: (error) {
          debugPrint('Chat error: $error');
          messages.add(
            ChatMessage(
              text: "An error occurred. Please check your connection.",
              isUser: false,
            ),
          );
          isLoading.value = false;
          _scrollToBottom();
        },
      );
    } catch (e) {
      debugPrint('Chat exception: $e');
      isLoading.value = false;
      _scrollToBottom();
    }
  }

  void clearChat() {
    messages.clear();
    // Re-add initial welcome message
    messages.add(
      ChatMessage(
        text: "Hello! I'm your Autointel Assistant. How can I help you with your vehicle today?",
        isUser: false,
      ),
    );
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (scrollController.hasClients) {
        scrollController.animateTo(
          scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }
}
