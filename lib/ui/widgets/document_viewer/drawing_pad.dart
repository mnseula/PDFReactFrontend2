import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class DrawingPad extends StatefulWidget {
  final Function(Uint8List) onSignatureComplete;

  const DrawingPad({
    super.key,
    required this.onSignatureComplete,
  });

  @override
  State<DrawingPad> createState() => _DrawingPadState();
}

class _DrawingPadState extends State<DrawingPad> {
  List<Offset> _points = [];
  final GlobalKey _canvasKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 300,
          height: 200,
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey),
            color: Colors.white,
          ),
          child: GestureDetector(
            onPanStart: (details) {
              setState(() {
                _points = [];
                _points.add(details.localPosition);
              });
            },
            onPanUpdate: (details) {
              setState(() {
                _points.add(details.localPosition);
              });
            },
            onPanEnd: (details) {
              _captureSignature();
            },
            child: RepaintBoundary(
              key: _canvasKey,
              child: CustomPaint(
                painter: _SignaturePainter(_points),
                size: Size.infinite,
              ),
            ),
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            TextButton(
              onPressed: () {
                setState(() {
                  _points = [];
                });
              },
              child: const Text('Clear'),
            ),
            TextButton(
              onPressed: _captureSignature,
              child: const Text('Done'),
            ),
          ],
        ),
      ],
    );
  }

  Future<void> _captureSignature() async {
    try {
      final boundary = _canvasKey.currentContext?.findRenderObject()
          as RenderRepaintBoundary?;
      if (boundary == null) return;

      final image = await boundary.toImage();
      final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
      if (byteData == null) return;

      final pngBytes = byteData.buffer.asUint8List();
      widget.onSignatureComplete(pngBytes);
    } catch (e) {
      print('Error capturing signature: $e');
    }
  }
}

class _SignaturePainter extends CustomPainter {
  final List<Offset> points;

  _SignaturePainter(this.points);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.black
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 3.0;

    for (int i = 0; i < points.length - 1; i++) {
      if (points[i] != null && points[i + 1] != null) {
        canvas.drawLine(points[i], points[i + 1], paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
