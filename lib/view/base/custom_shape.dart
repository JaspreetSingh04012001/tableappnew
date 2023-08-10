import 'package:flutter/material.dart';

class CurvedPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    var paint = Paint()
      ..shader = const LinearGradient(
        colors: [
          Color(0xFFFF6F70),
          Color(0xFFFBB35F)
        ],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ).createShader(
        Rect.fromLTRB(0, 0, size.width, size.height),
      )
      ..strokeWidth = 15;

    var path = Path();

    path.moveTo(0, size.height * 0.7);
    path.quadraticBezierTo(size.width * 0.0, size.height * 0.5, size.width * 0.0, size.height * 0.8);
    path.quadraticBezierTo(size.width * 0.08, size.height * 0.6, size.width * 0.2, size.height * 0.7);
    path.quadraticBezierTo(size.width * 0.45, size.height * 1, size.width * 0.60, size.height * 0.8);
    path.quadraticBezierTo(size.width * 0.70, size.height * 0.7, size.width * 0.80, size.height * 0.75);
    path.quadraticBezierTo(size.width * 0.70, size.height * 0.85, size.width * 0.80, size.height * 0.75);
    path.quadraticBezierTo(size.width * 0.82, size.height * 0.756, size.width * 0.9, size.height * 0.85);
    path.quadraticBezierTo(size.width * .95, size.height * 0.88, size.width * 1, size.height * 0.85);

    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.lineTo(0, size.height);

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}