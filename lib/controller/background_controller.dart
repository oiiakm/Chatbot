import 'dart:math';
import 'package:chat/models/background_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class BackgroundController extends GetxController
    with GetTickerProviderStateMixin {
  late AnimationController _controller;
  late List<CircleModel> _circles;

  @override
  void onInit() {
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 10),
    );

    _initializeCircles();

    _controller.addListener(() {
      _updateCirclePositions();
    });

    _controller.repeat(reverse: true);

    super.onInit();
  }

  @override
  void onClose() {
    _controller.dispose();
    super.onClose();
  }

  void _initializeCircles() {
    _circles = List.generate(100, (index) {
      return CircleModel(
        position: Offset(
          Random().nextDouble() * Get.width,
          Random().nextDouble() * Get.height,
        ),
        velocity: Offset(
          Random().nextDouble() * 2 - 1,
          Random().nextDouble() * 2 - 1,
        ),
        radius: Random().nextDouble() * 10 + 5,
        color: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.blue.withOpacity(0.8),
            const Color.fromARGB(255, 99, 106, 112).withOpacity(0.3),
          ],
        ),
      );
    });
  }

  void _updateCirclePositions() {
    for (var circle in _circles) {
      circle.position += circle.velocity * _controller.value;

      if (circle.position.dx < 0 || circle.position.dx > Get.width) {
        circle.position =
            Offset(Random().nextDouble() * Get.width, circle.position.dy);
      }
      if (circle.position.dy < 0 || circle.position.dy > Get.height) {
        circle.position =
            Offset(circle.position.dx, Random().nextDouble() * Get.height);
      }
    }
    update();
  }

  List<CircleModel> get circles => _circles;
}
