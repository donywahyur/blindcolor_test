import 'dart:ui';

import 'package:get/get.dart';

class DrawingController extends GetxController {
  List<Offset> _points = [];

  @override
  void onInit() {
    clearPoints();
    super.onInit();
  }

  void addPoint(Offset point) {
    _points.add(point);
    update();
  }

  void clearPoints() {
    _points.clear();
    update();
  }

  List<Offset> get points => _points;
}
