import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:async';

class ChatMessage {
  final String text;
  final bool isUser;
  final List<String>? options;

  ChatMessage({required this.text, required this.isUser, this.options});
}

class AiChatController extends GetxController {
  final textController = TextEditingController();
  final scrollController = ScrollController();

  // Observable list of messages
  final messages = <ChatMessage>[].obs;

  @override
  void onInit() {
    super.onInit();
    // Load initial context or history
    messages.addAll([
      ChatMessage(
        text:
            "Hello! I'm your Autointel AI assistant. How can I help you with your vehicle today?",
        isUser: false,
      ),
      ChatMessage(
        text:
            "My check engine light just turned on while driving, and I'm noticing slight vibrations when the car is idling. What could be causing this, and is it safe to continue driving?",
        isUser: true,
      ),
      ChatMessage(
        text:
            "Based on the P0133 code, I'd recommend checking the sensor wiring first. It's often just a loose connection. Would you like a cost estimate for a replacement sensor?",
        isUser: false,
        options: ['Estimate Cost', 'Find Mechanic', 'How to check wiring?'],
      ),
      ChatMessage(text: "Estimate Cost", isUser: true),
      ChatMessage(
        text:
            "The average cost for an O2 Sensor replacement is between \$150 and \$250. This includes parts (\$80-\$150) and labor (\$70-\$100).",
        isUser: false,
      ),
    ]);
  }

  @override
  void onClose() {
    textController.dispose();
    scrollController.dispose();
    super.onClose();
  }

  void sendMessage(String text) {
    if (text.trim().isEmpty) return;

    // Add user message
    messages.add(ChatMessage(text: text, isUser: true));

    // Clear the text field
    textController.clear();

    _scrollToBottom();

    // Simulate AI typing delay and generate a generic response
    Future.delayed(const Duration(seconds: 1), () {
      _generateAiResponse(text);
    });
  }

  void _generateAiResponse(String userText) {
    // Basic hardcoded logic, can be replaced by real API call later
    String aiResponse =
        "I'm looking into that for you. Based on typical vehicle data, you might want to schedule an inspection soon.";

    if (userText.toLowerCase().contains("oil")) {
      aiResponse =
          "For an oil change, I recommend doing it every 5,000 miles or 6 months, depending on the oil type. Do you want to schedule a service?";
    } else if (userText.toLowerCase().contains("brakes")) {
      aiResponse =
          "Brake issues can be serious. If you hear squeaking or feel vibrations, get them checked immediately. An inspection usually costs around \$50.";
    }

    messages.add(ChatMessage(text: aiResponse, isUser: false));
    _scrollToBottom();
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
