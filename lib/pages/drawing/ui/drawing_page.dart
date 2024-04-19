import 'dart:developer';
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_drawing_app/pages/drawing/listener/drawing_listener.dart';
import 'package:flutter_drawing_app/pages/drawing/utils/drawing_point.dart';

class DrawingPage extends StatelessWidget {
  const DrawingPage({super.key});

  // final List<Color> colorList = [
  // Color selectedColor = Colors.black;

  // int selectedIndex = 0;
  @override
  Widget build(BuildContext context) {
    DrawingValueModel drawingValueModel = DrawingValueModel(
      selectedIndex: 0,
      selectedColor: Colors.black,
      strokeWidth: 5,
      drawingPoints: [],
    );
    DrawingListener drawingListener = DrawingListener(drawingValueModel);
    // Paint paint = Paint()
    //   ..color = drawingListener.value.selectedColor
    //   ..isAntiAlias = true
    //   ..strokeWidth = drawingListener.value.strokeWidth
    //   ..strokeCap = StrokeCap.round;
    return Scaffold(
      body: ValueListenableBuilder(
          valueListenable: drawingListener,
          builder: (context, data, child) {
            Paint paint = Paint()
              ..color = data.selectedColor
              ..isAntiAlias = true
              ..strokeWidth = data.strokeWidth
              ..strokeCap = StrokeCap.round;
            return Stack(
              children: [
                GestureDetector(
                  onPanStart: (details) {
                    drawingListener.updateDrawingPoint(
                      DrawingPoint(offset: details.localPosition, paint: paint),
                    );
                  },
                  onPanUpdate: (details) {
                    drawingListener.updateDrawingPoint(
                      DrawingPoint(offset: details.localPosition, paint: paint),
                    );
                  },
                  onPanEnd: (details) {
                    drawingListener.updateDrawingPoint(
                      null,
                    );
                  },
                  child: CustomPaint(
                    painter: DrawingPainter(drawingPoints: data.drawingPoints),
                    size: Size(
                      MediaQuery.sizeOf(context).width - 50,
                      MediaQuery.sizeOf(context).height,
                    ),
                  ),
                ),
                Positioned(
                  left: 0,
                  top: 0,
                  bottom: 0,
                  child: Container(
                    color: Colors.grey.shade300,
                    height: MediaQuery.sizeOf(context).height,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SingleChildScrollView(
                          child: Column(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: List.generate(
                              drawingListener.colorList.length,
                              (index) => GestureDetector(
                                onTap: () {
                                  drawingListener.updateIndex(index);
                                },
                                child: Container(
                                  margin: const EdgeInsets.only(
                                    left: 8,
                                    right: 5,
                                    top: 5,
                                    bottom: 5,
                                  ),
                                  height: data.selectedIndex == index ? 40 : 35,
                                  width: data.selectedIndex == index ? 40 : 35,
                                  decoration: BoxDecoration(
                                    color: drawingListener.colorList[index],
                                    borderRadius: BorderRadius.circular(50),
                                    border: Border.all(
                                      color: Colors.white,
                                      width:
                                          data.selectedIndex == index ? 5 : 0,
                                      strokeAlign:
                                          BorderSide.strokeAlignOutside,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 300,
                          child: RotatedBox(
                            quarterTurns: 3,
                            child: Slider(
                              value: data.strokeWidth,
                              onChanged: (value) {
                                drawingListener.updateStrokeWidth(value);
                              },
                              thumbColor: Colors.red,
                              activeColor: Colors.green,
                              inactiveColor: Colors.black,
                              min: 5,
                              max: 30,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Positioned(
                  top: 30,
                  right: 30,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          drawingListener.clearDrawingPoint();
                        },
                        style: ButtonStyle(
                          backgroundColor:
                              MaterialStatePropertyAll(Colors.orange[100]),
                        ),
                        child: const Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.clear_rounded),
                            SizedBox(width: 10),
                            Text('Clear paint'),
                          ],
                        ),
                      ),
                      IconButton.filled(
                        onPressed: () {
                          drawingListener.setEraser();
                        },
                        icon: const Icon(Icons.cleaning_services_sharp),
                      ),
                    ],
                  ),
                ),
              ],
            );
          }),
    );
  }
}

class DrawingPainter extends CustomPainter {
  final List<DrawingPoint?> drawingPoints;
  List<Offset> offsets = [];

  DrawingPainter({required this.drawingPoints});

  @override
  void paint(Canvas canvas, Size size) {
    try {
      for (var i = 0; i < drawingPoints.length - 1; i++) {
        if (drawingPoints[i] != null && drawingPoints[i + 1] != null) {
          canvas.drawLine(drawingPoints[i]!.offset,
              drawingPoints[i + 1]!.offset, drawingPoints[i]!.paint);
        } else if (drawingPoints[i] != null && drawingPoints[i + 1] == null) {
          offsets.clear();
          offsets.add(drawingPoints[i]!.offset);
          canvas.drawPoints(PointMode.points, offsets, drawingPoints[i]!.paint);
        }
      }
    } catch (e) {
      log(e.toString());
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
