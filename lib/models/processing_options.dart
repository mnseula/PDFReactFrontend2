lib/models/processing_options.dart
import 'dart:typed_data';

class ProcessingOptions {
  final String operation;
  final Map<String, dynamic> parameters;
  
  ProcessingOptions({required this.operation, required this.parameters});
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

enum AnnotationType {
  signature,
  text,
  highlight,
  underline
}

class AnnotationOptions {
  final String type;
  final RectangleArea area;
  final String? signatureImage; // Base64
  
  AnnotationOptions({
    required this.type,
    required this.area,
    this.signatureImage
  });
}
