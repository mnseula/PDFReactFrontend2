import 'package:flutter/material.dart';
import 'package:document_processor/models/processing_options.dart';

class CanvasOverlay extends StatefulWidget {
  final Function(RectangleArea) onAreaSelected;
  final List<RectangleArea> selectedAreas;
  final VoidCallback onClearSelection;

  const CanvasOverlay({
    super.key,
    required this.onAreaSelected,
    required this.selectedAreas,
    required this.onClearSelection,
  });

  @override
  State<CanvasOverlay> createState() => _CanvasOverlayState();
}

class _CanvasOverlayState extends State<CanvasOverlay> {
  Offset? _startPoint;
  Offset? _endPoint;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onPanStart: (details) {
        setState(() {
          _startPoint = details.localPosition;
          _endPoint = details.localPosition;
        });
      },
      onPanUpdate: (details) {
        setState(() {
          _endPoint = details.localPosition;
        });
      },
      onPanEnd: (details) {
        if (_startPoint != null && _endPoint != null) {
          final rect = _normalizeRect(_startPoint!, _endPoint!);
          widget.onAreaSelected(RectangleArea(
            x1: rect.left,
            y1: rect.top,
            x2: rect.right,
            y2: rect.bottom,
          ));
        }
        setState(() {
          _startPoint = null;
          _endPoint = null;
        });
      },
      child: CustomPaint(
        painter: _CanvasPainter(
          startPoint: _startPoint,
          endPoint: _endPoint,
          selectedAreas: widget.selectedAreas,
        ),
        child: Container(),
      ),
    );
  }

  Rect _normalizeRect(Offset start, Offset end) {
    return Rect.fromPoints(
      Offset(
        start.dx < end.dx ? start.dx : end.dx,
        start.dy < end.dy ? start.dy : end.dy,
      ),
      Offset(
        start.dx > end.dx ? start.dx : end.dx,
        start.dy > end.dy ? start.dy : end.dy,
      ),
    );
  }
}

class _CanvasPainter extends CustomPainter {
  final Offset? startPoint;
  final Offset? endPoint;
  final List<RectangleArea> selectedAreas;

  _CanvasPainter({
    this.startPoint,
    this.endPoint,
    required this.selectedAreas,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.blue.withOpacity(0.3)
      ..style = PaintingStyle.fill;

    // Draw existing selections
    for (final area in selectedAreas) {
      canvas.drawRect(
        Rect.fromPoints(
          Offset(area.x1, area.y1),
          Offset(area.x2, area.y2),
        ),
        paint,
      );
    }

    // Draw current selection
    if (startPoint != null && endPoint != null) {
      canvas.drawRect(
        _normalizeRect(startPoint!, endPoint!),
        paint..color = Colors.blue.withOpacity(0.5),
      );
    }
  }

  Rect _normalizeRect(Offset start, Offset end) {
    return Rect.fromPoints(
      Offset(
        start.dx < end.dx ? start.dx : end.dx,
        start.dy < end.dy ? start.dy : end.dy,
      ),
      Offset(
        start.dx > end.dx ? start.dx : end.dx,
        start.dy > end.dy ? start.dy : end.dy,
      ),
    );
  }

  @override
  bool shouldRepaint(_CanvasPainter oldDelegate) =>
      startPoint != oldDelegate.startPoint ||
      endPoint != oldDelegate.endPoint ||
      selectedAreas != oldDelegate.selectedAreas;
}
