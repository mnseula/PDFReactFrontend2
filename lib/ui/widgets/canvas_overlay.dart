import 'package:flutter/material.dart';
import '../../models/processing_options.dart';

class CanvasOverlay extends StatelessWidget {
  final Function(RectangleArea) onAreaSelected;
  
  const CanvasOverlay({
    super.key,
    required this.onAreaSelected,
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
      child: Container(
        color: Colors.transparent,
      ),
    );
  }
}