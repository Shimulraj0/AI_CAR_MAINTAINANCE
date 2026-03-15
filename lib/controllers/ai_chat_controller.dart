import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:async';
import 'dart:convert';
import '../services/api_service.dart';

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
      debugPrint('AiChatController: Sending message to API: $userText');
      final response = await _apiService.normalChat({'message': userText});
      
      debugPrint('AiChatController: API Response Status: ${response.statusCode}');
      debugPrint('AiChatController: API Response Body: ${response.body}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = json.decode(response.body);
        final aiText = data['ai_response'] ?? data['response'] ?? data['reply'] ?? data['message'] ?? "I'm sorry, I couldn't process that.";
        
        debugPrint('AiChatController: Extracted AI Text: $aiText');

        // Handle options if present in the response
        List<String>? options;
        if (data['options'] != null && data['options'] is List) {
          options = List<String>.from(data['options']);
          debugPrint('AiChatController: Suggestions found: ${options.length}');
        }

        final newMessage = ChatMessage(text: aiText, isUser: false, options: options);
        messages.add(newMessage);
        debugPrint('AiChatController: Added AI message to list. New list length: ${messages.length}');
      } else {
        debugPrint('AiChatController: API Error ${response.statusCode}');
        messages.add(ChatMessage(
          text: "Sorry, I'm having trouble connecting to the service. Please try again later.",
          isUser: false,
        ));
      }
    } catch (e) {
      debugPrint('Chat error: $e');
      messages.add(ChatMessage(
        text: "An error occurred. Please check your connection.",
        isUser: false,
      ));
    } finally {
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
