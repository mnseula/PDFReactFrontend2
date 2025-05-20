import 'package:flutter/material.dart';
import '../../models/processing_options.dart';

class CanvasOverlay extends StatefulWidget {
  final Function(RectangleArea) onAreaSelected;
  final VoidCallback onClearSelection;

  const CanvasOverlay({
    Key? key,
    required this.onAreaSelected,
    required this.onClearSelection,
  }) : super(key: key);

  @override
  _CanvasOverlayState createState() => _CanvasOverlayState();
}

class _CanvasOverlayState extends State<CanvasOverlay> {
  List<RectangleArea> _selectedAreas = [];

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onPanDown: (details) {
        // Handle pan start
      },
      onPanUpdate: (details) {
        // Handle pan update
      },
      onPanEnd: (details) {
        // Handle pan end
      },
      child: CustomPaint(
        painter: AreasPainter(_selectedAreas),
        child: Container(
          color: Colors.transparent,
        ),
      ),
    );
  }
}

class AreasPainter extends CustomPainter {
  final List<RectangleArea> areas;

  AreasPainter(this.areas);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.blue.withOpacity(0.3)
      ..style = PaintingStyle.fill;

    for (final area in areas) {
      canvas.drawRect(
        Rect.fromPoints(
          Offset(area.x1, area.y1),
          Offset(area.x2, area.y2),
        ),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(AreasPainter oldDelegate) => true;
}