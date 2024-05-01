import 'package:chat/views/chat_view.dart';
import 'package:get/get.dart';

class AppRoutes {
  static final List<GetPage> pages = [
    GetPage(name: '/', page: () => ChatView()),
  ];
}
