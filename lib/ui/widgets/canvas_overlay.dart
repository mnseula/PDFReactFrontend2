import 'package:flutter/material.dart';
import 'package:document_processor/models/processing_options.dart';

class CanvasOverlay extends StatefulWidget {
  final Function(RectangleArea) onAreaSelected;
  final VoidCallback onClearSelection;

  const CanvasOverlay({
    Key? key,
    required this.onAreaSelected,
    required this.onClearSelection,
  }) : super(key: key);

  @override
  State<CanvasOverlay> createState() => _CanvasOverlayState();
}

class _CanvasOverlayState extends State<CanvasOverlay> {
  final List<RectangleArea> _selectedAreas = [];
  Offset? _startPoint;
  Offset? _currentPoint;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onPanDown: (details) {
        setState(() {
          _startPoint = details.localPosition;
          _currentPoint = _startPoint;
        });
      },
      onPanUpdate: (details) {
        setState(() {
          _currentPoint = details.localPosition;
        });
      },
      onPanEnd: (details) {
        if (_startPoint != null && _currentPoint != null) {
          final area = RectangleArea(
            x1: _startPoint!.dx,
            y1: _startPoint!.dy,
            x2: _currentPoint!.dx,
            y2: _currentPoint!.dy,
          );
          widget.onAreaSelected(area);
          _selectedAreas.add(area);
        }
        setState(() {
          _startPoint = null;
          _currentPoint = null;
        });
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