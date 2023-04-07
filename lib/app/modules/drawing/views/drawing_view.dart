import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/drawing_controller.dart';

class DrawingView extends GetView<DrawingController> {
  const DrawingView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        onPanUpdate: (DragUpdateDetails details) {
          RenderBox box = context.findRenderObject() as RenderBox;
          Offset point = box.globalToLocal(details.globalPosition);
          controller.addPoint(point);
        },
        onPanEnd: (DragEndDetails details) {
          // controller.addPoint(null);
        },
        child: CustomPaint(
          painter: _DrawingPainter(controller.points),
          child: Container(),
        ),
      ),
    );
  }
}

class _DrawingPainter extends CustomPainter {
  final List<Offset> points;

  _DrawingPainter(this.points);

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = Colors.black
      ..strokeWidth = 5.0;

    for (int i = 0; i < points.length - 1; i++) {
      canvas.drawLine(points[i], points[i + 1], paint);
    }
  }

  @override
  bool shouldRepaint(_DrawingPainter oldDelegate) {
    return true;
  }
}
