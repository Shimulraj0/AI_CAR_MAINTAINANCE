import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import '../../controllers/ai_chat_controller.dart';
import '../../controllers/home_controller.dart';
import '../../utils/responsive_helper.dart';

class AiChatView extends GetView<AiChatController> {
  const AiChatView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        title: const Text(
          'Chat Bot',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontFamily: 'Archivo',
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
        backgroundColor: const Color(0xFF2B63A8),
        elevation: 0,
        systemOverlayStyle: const SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.light,
        ),
        toolbarHeight: kToolbarHeight,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Get.back(),
        ),
        actions: [
          PopupMenuButton<String>(
            onSelected: (value) {
              if (value == 'clear') {
                controller.clearChat();
              }
            },
            icon: const Icon(Icons.more_horiz, color: Colors.white),
            itemBuilder: (BuildContext context) => [
              const PopupMenuItem<String>(
                value: 'clear',
                child: Row(
                  children: [
                    Icon(
                      Icons.delete_outline,
                      color: Color(0xFFEF4444),
                      size: 18,
                    ),
                    SizedBox(width: 8),
                    Text(
                      'Clear Chat',
                      style: TextStyle(
                        color: Color(0xFFEF4444),
                        fontSize: 14,
                        fontFamily: 'Inter',
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: Obx(
              () => ListView.separated(
                controller: controller.scrollController,
                padding: EdgeInsets.symmetric(
                  horizontal: context.w(24),
                  vertical: context.h(16),
                ),
                itemCount:
                    controller.messages.length +
                    (controller.isLoading.value ? 1 : 0),
                separatorBuilder: (context, index) =>
                    const SizedBox(height: 16),
                itemBuilder: (context, index) {
                  if (index == controller.messages.length) {
                    return _buildTypingIndicator(context);
                  }
                  final message = controller.messages[index];
                  if (message.isUser) {
                    return _buildUserMessage(context, text: message.text);
                  } else {
                    return _buildAiMessage(
                      context,
                      text: message.text,
                      options: message.options,
                    );
                  }
                },
              ),
            ),
          ),
          _buildMessageInput(context),
        ],
      ),
    );
  }

  Widget _buildTypingIndicator(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: const BoxDecoration(shape: BoxShape.circle),
          clipBehavior: Clip.antiAlias,
          child: Image.asset('assets/images/TM 2.png', fit: BoxFit.cover),
        ),
        const SizedBox(width: 12),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: const BoxDecoration(
            color: Color(0x33BBDCFF),
            borderRadius: BorderRadius.only(
              topRight: Radius.circular(12),
              bottomLeft: Radius.circular(12),
              bottomRight: Radius.circular(12),
            ),
          ),
          child: const Text(
            "typing...",
            style: TextStyle(
              color: Color(0xFF383838),
              fontSize: 12,
              fontStyle: FontStyle.italic,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildAiMessage(BuildContext context, {required String text, List<String>? options}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: context.w(40),
          height: context.w(40),
          decoration: const BoxDecoration(shape: BoxShape.circle),
          clipBehavior: Clip.antiAlias,
          child: Image.asset('assets/images/TM 2.png', fit: BoxFit.cover),
        ),
        SizedBox(width: context.w(12)),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Color(0x33BBDCFF),
                      Color(0x33BBDCFF),
                    ], // Simulated gradient
                  ),
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(12),
                    bottomLeft: Radius.circular(12),
                    bottomRight: Radius.circular(12),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      text,
                      style: const TextStyle(
                        color: Color(0xFF383838),
                        fontSize: 12,
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w400,
                        height: 1.50,
                      ),
                    ),
                    if (options != null) ...[
                      const SizedBox(height: 12),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: options
                            .map(
                              (opt) => GestureDetector(
                                onTap: () => controller.sendMessage(opt),
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 6,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Text(
                                    opt,
                                    style: const TextStyle(
                                      color: Color(0xFF2F5EA8),
                                      fontSize: 12,
                                      fontFamily: 'Inter',
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                ),
                              ),
                            )
                            .toList(),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildUserMessage(BuildContext context, {required String text}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Container(
            padding: EdgeInsets.all(context.w(12)),
            decoration: const BoxDecoration(
              color: Color(0xFF366FB5),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(12),
                bottomLeft: Radius.circular(12),
                bottomRight: Radius.circular(12),
              ),
            ),
            child: Text(
              text,
              style: const TextStyle(
                color: Color(0xFFFFF5F5),
                fontSize: 14,
                fontFamily: 'Inter',
                fontWeight: FontWeight.w300,
                height: 1.4,
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Container(
          width: context.w(40),
          height: context.w(40),
          clipBehavior: Clip.antiAlias,
          decoration: const BoxDecoration(shape: BoxShape.circle),
          child: GetX<HomeController>(
            builder: (homeController) {
              final imageUrl = homeController.userProfileImage.value;
              if (imageUrl.isNotEmpty) {
                if (imageUrl.startsWith('http')) {
                  return Image.network(
                    imageUrl,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => Image.asset(
                      'assets/images/chatuser.png',
                      fit: BoxFit.cover,
                    ),
                  );
                } else if (imageUrl.startsWith('assets/')) {
                  return Image.asset(imageUrl, fit: BoxFit.cover);
                }
              }
              return Image.asset(
                'assets/images/chatuser.png',
                fit: BoxFit.cover,
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildMessageInput(BuildContext context) {
    return SafeArea(
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: context.w(24), vertical: context.h(16)),
        color: const Color(0xFFF8FAFC),
        child: Row(
          children: [
            Expanded(
              child: Container(
                height: 48,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  color: const Color(0xFFE7F1FC),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: Colors.black.withValues(alpha: 0.1),
                  ),
                ),
                child: TextField(
                  controller: controller.textController,
                  onSubmitted: (value) => controller.sendMessage(value),
                  textInputAction: TextInputAction.send,
                  decoration: const InputDecoration(
                    hintText: 'write your message',
                    hintStyle: TextStyle(
                      color: Color(0xFF949CA9),
                      fontSize: 12,
                      fontFamily: 'Inter',
                    ),
                    border: InputBorder.none,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            GestureDetector(
              onTap: () =>
                  controller.sendMessage(controller.textController.text),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: const Color(0xFF2B63A8),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Center(
                  widthFactor: 1,
                  heightFactor: 1,
                  child: Icon(
                    Icons.send_rounded,
                    color: Colors.white,
                    size: 18,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
