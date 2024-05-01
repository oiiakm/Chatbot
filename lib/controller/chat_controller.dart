import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:chat/constants/api_key.dart';
import 'package:chat/models/chat_model.dart';

class ChatController extends GetxController {
  final TextEditingController textEditingController = TextEditingController();
  final RxList<ChatModel> messages = <ChatModel>[].obs;

  Future<void> sendMessage() async {
    final message = textEditingController.text;
    if (message.isNotEmpty) {
      messages.add(ChatModel(text: message, sender: "User"));
      messages.add(ChatModel(text: 'Thinking...', sender: "AI"));
      textEditingController.clear();

      try {
        final response = await http.post(
          Uri.parse('https://api.openai.com/v1/chat/completions'),
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $apiKey',
          },
          body: jsonEncode({
            "model": "gpt-3.5-turbo",
            "messages": [
              {"role": "user", "content": message}
            ],
            "temperature": 0.3
          }),
        );

        switch (response.statusCode) {
          case 200:
            final data = jsonDecode(response.body);
            final aiResponse = data['choices'][0]['message']['content'].trim();
            messages.removeWhere((element) => element.text == 'Thinking...');
            messages.add(ChatModel(text: aiResponse, sender: "AI"));
            break;
          default:
            const errorMessage = 'Failed to fetch response from server';

            displayErrorMessage('Error', errorMessage);
            print(errorMessage);
            break;
        }
      } catch (e) {
        const errorMessage = 'Please check your internet connection';
        displayErrorMessage('Network Error', errorMessage);
        print(errorMessage);
      }
    }
  }

  void displayErrorMessage(String errorName, String errorMessage) {
    Get.snackbar(
      errorName,
      errorMessage,
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.red,
      colorText: Colors.white,
      borderRadius: 10.0,
      margin: const EdgeInsets.all(10.0),
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 15.0),
      animationDuration: const Duration(milliseconds: 400),
      snackStyle: SnackStyle.FLOATING,
      duration: const Duration(seconds: 4),
      isDismissible: true,
      forwardAnimationCurve: Curves.easeOutBack,
      reverseAnimationCurve: Curves.easeInBack,
      mainButton: TextButton(
        onPressed: () {
          Get.back();
        },
        child: const Text(
          'OK',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
