import 'package:flutter/material.dart';
import '../../models/processing_options.dart';

class CanvasOverlay extends StatelessWidget {
  final Function(RectangleArea) onAreaSelected;
  final List<RectangleArea> selectedAreas;
  
  const CanvasOverlay({
    super.key,
    required this.onAreaSelected,
    required this.selectedAreas,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onPanStart: (details) {
        // Handle pan start
      },
      onPanUpdate: (details) {
        // Handle pan update
      },
      onPanEnd: (details) {
        // Handle pan end
      },
      child: CustomPaint(
        painter: AreasPainter(selectedAreas),
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