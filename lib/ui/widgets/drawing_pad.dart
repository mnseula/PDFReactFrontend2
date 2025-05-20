import 'dart:ui';
import 'package:flutter/material.dart';

class DrawingPad extends StatefulWidget {
  final Function(Uint8List) onSignatureComplete;
  
  const DrawingPad({super.key, required this.onSignatureComplete});

  @override
  State<DrawingPad> createState() => _DrawingPadState();
}

class _DrawingPadState extends State<DrawingPad> {
  List<Offset> _points = [];
  
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onPanUpdate: (details) {
        setState(() => _points.add(details.localPosition));
      },
      onPanEnd: (_) => _captureSignature(),
      child: CustomPaint(
        painter: _SignaturePainter(_points),
        size: Size.infinite,
      ),
    );
  }
  
  Future<void> _captureSignature() async {
    // Implement image capture logic
  }
}

class _SignaturePainter extends CustomPainter {
  final List<Offset> points;
  
  _SignaturePainter(this.points);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.black
      ..strokeWidth = 3.0;
    
    for (int i = 0; i < points.length - 1; i++) {
      canvas.drawLine(points[i], points[i+1], paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
