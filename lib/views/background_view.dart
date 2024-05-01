import 'package:chat/controller/background_controller.dart';
import 'package:chat/models/background_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class BackgroundView extends StatelessWidget {
  final BackgroundController controller = Get.put(BackgroundController());

  BackgroundView({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<BackgroundController>(
      builder: (_) {
        return CustomPaint(
          painter: RandomMovingCirclesPainter(controller.circles),
          size: MediaQuery.of(context).size,
        );
      },
    );
  }
}

class RandomMovingCirclesPainter extends CustomPainter {
  final List<CircleModel> circles;

  RandomMovingCirclesPainter(this.circles);

  @override
  void paint(Canvas canvas, Size size) {
    for (var circle in circles) {
      final paint = Paint()
        ..shader = circle.color.createShader(
            Rect.fromCircle(center: circle.position, radius: circle.radius))
        ..style = PaintingStyle.fill;

      canvas.drawCircle(circle.position, circle.radius, paint);
    }
  }

  @override
  bool shouldRepaint(RandomMovingCirclesPainter oldDelegate) {
    return true;
  }
}
