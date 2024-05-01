import 'package:flutter/material.dart';

//circle for background
class CircleModel {
  Offset position;
  Offset velocity;
  double radius;
  Gradient color;

  CircleModel({
    required this.position,
    required this.velocity,
    required this.radius,
    required this.color,
  });
}
