lib/models/processing_options.dart
import 'dart:typed_data';

enum AnnotationType {
  signature,
  text,
  highlight,
  underline
}

class RectangleArea {
  final double x1, y1, x2, y2;
  final int? pageNumber;
  
  RectangleArea({
    required this.x1,
    required this.y1,
    required this.x2, 
    required this.y2,
    this.pageNumber
  });
}
