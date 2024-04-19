import 'package:flutter/material.dart';
import 'package:flutter_drawing_app/pages/drawing/utils/drawing_point.dart';

class DrawingListener extends ValueNotifier<DrawingValueModel> {
  DrawingListener(super.value);

  final List<Color> colorList = [
    Colors.black,
    Colors.green,
    Colors.red,
    Colors.orange,
    Colors.grey,
    Colors.blue,
    Colors.yellow,
    Colors.teal,
    Colors.amber,
    Colors.lime,
    Colors.indigo,
    Colors.cyan,
    Colors.brown,
    Colors.pink,
  ];

  void updateIndex(int index) {
    value.selectedIndex = index;
    value.selectedColor = colorList[index];
    notifyListeners();
  }

  void updateStrokeWidth(double width) {
    value.strokeWidth = width;
    notifyListeners();
  }

  void updateDrawingPoint(DrawingPoint? drawingPoint) {
    value.drawingPoints.add(drawingPoint);
    notifyListeners();
  }

  void setEraser() {
    value.selectedColor = Colors.white;
    notifyListeners();
  }

  void clearDrawingPoint() {
    value.drawingPoints.clear();
    notifyListeners();
  }

  // void unDoDrawing() {
  //   log(value.drawingPoints.length.toString());
  //   value.drawingPoints.removeLast();
  //   value.drawingPoints.removeLast();
  //   log(value.drawingPoints.length.toString());
  //   value.drawingPoints.removeLast();
  //   log(value.drawingPoints.length.toString());
  //   notifyListeners();
  // }
}

class DrawingValueModel {
  int selectedIndex;
  double strokeWidth;
  Color selectedColor;
  List<DrawingPoint?> drawingPoints;

  DrawingValueModel({
    required this.selectedIndex,
    required this.selectedColor,
    required this.strokeWidth,
    required this.drawingPoints,
  });
}
