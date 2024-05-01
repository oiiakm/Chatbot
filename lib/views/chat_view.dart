import 'package:chat/constants/color_constants.dart';
import 'package:chat/views/background_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:chat/controller/chat_controller.dart';

class ChatView extends StatelessWidget {
  final ChatController viewModel = Get.put(ChatController());
  final ScrollController _scrollController = ScrollController();

  ChatView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        title: const Text(
          'Let \'s chat !',
          style: TextStyle(
            color: ColorConstants.appBarColor,
            fontSize: 30,
            fontStyle: FontStyle.italic,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Stack(
        children: [
          BackgroundView(),
          _buildChatContent(),
        ],
      ),
    );
  }

  Widget _buildChatContent() {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              controller: _scrollController,
              physics: const AlwaysScrollableScrollPhysics(),
              child: Obx(
                () {
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    _scrollController.animateTo(
                      _scrollController.position.maxScrollExtent,
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeOut,
                    );
                  });
                  return Column(
                    children: viewModel.messages.map((message) {
                      if (message.text == 'Thinking...') {
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: Align(
                            alignment: message.sender == 'User'
                                ? Alignment.centerRight
                                : Alignment.centerLeft,
                            child: Text(
                              message.text,
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                fontStyle: FontStyle.italic,
                                color: Colors.grey[600],
                              ),
                            ),
                          ),
                        );
                      } else {
                        IconData iconData = message.sender == 'User'
                            ? Icons.person
                            : Icons.chat_bubble;
                        Color iconColor = message.sender == 'User'
                            ? ColorConstants.userMessageColor
                            : ColorConstants.aiMessageColor;
                        List<Color> gradientColors = message.sender == 'User'
                            ? [
                                ColorConstants.userMessageBackgroundColorStart,
                                ColorConstants.userMessageBackgroundColorEnd,
                              ]
                            : [
                                ColorConstants.aiMessageBackgroundColorStart,
                                ColorConstants.aiMessageBackgroundColorEnd,
                              ];

                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: Row(
                            mainAxisAlignment: message.sender == 'User'
                                ? MainAxisAlignment.end
                                : MainAxisAlignment.start,
                            children: [
                              if (message.sender != 'User')
                                Padding(
                                  padding: const EdgeInsets.only(right: 8.0),
                                  child: CircleAvatar(
                                    backgroundColor: Colors.white,
                                    child: Icon(
                                      iconData,
                                      color: iconColor,
                                    ),
                                  ),
                                ),
                              Expanded(
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.only(
                                      topLeft: const Radius.circular(20),
                                      topRight: const Radius.circular(20),
                                      bottomLeft: Radius.circular(
                                          message.sender == 'User' ? 20 : 0),
                                      bottomRight: Radius.circular(
                                          message.sender == 'User' ? 0 : 20),
                                    ),
                                    gradient: LinearGradient(
                                      colors: gradientColors,
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                    ),
                                  ),
                                  child: ListTile(
                                    title: Text(
                                      message.text,
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.white,
                                      ),
                                    ),
                                    subtitle: Text(
                                      message.sender,
                                      style: const TextStyle(
                                        fontStyle: FontStyle.italic,
                                        color: Colors.white70,
                                      ),
                                    ),
                                    contentPadding: const EdgeInsets.symmetric(
                                        horizontal: 16.0),
                                  ),
                                ),
                              ),
                              if (message.sender == 'User')
                                Padding(
                                  padding: const EdgeInsets.only(left: 8.0),
                                  child: CircleAvatar(
                                    backgroundColor: Colors.white,
                                    child: Icon(
                                      iconData,
                                      color: iconColor,
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        );
                      }
                    }).toList(),
                  );
                },
              ),
            ),
          ),
          const SizedBox(height: 16),
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(30.0),
              gradient: const LinearGradient(
                colors: [
                  ColorConstants.userMessageColor,
                  ColorConstants.aiMessageColor
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: viewModel.textEditingController,
                      style: const TextStyle(color: Colors.white),
                      decoration: const InputDecoration(
                        hintText: 'Type your message...',
                        hintStyle: TextStyle(color: Colors.white70),
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.send),
                    color: Colors.white,
                    onPressed: () {
                      viewModel.sendMessage();
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
