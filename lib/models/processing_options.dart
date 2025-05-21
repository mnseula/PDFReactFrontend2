import 'dart:typed_data';
import 'package:document_processor/models/geometry/rectangle_area.dart';
// Replace any existing RectangleArea definition with the imported one
// Keep all other code that uses RectangleArea

enum AnnotationType {
  signature,
  text,
  highlight,
  underline
}

class AnnotationOptions {
  final AnnotationType type;
  final Uint8List? signatureData;
  final String? text;
  final RectangleArea? area;

  const AnnotationOptions({
    required this.type,
    this.signatureData,
    this.text,
    this.area,
  });
}

class RectangleArea {
  final double x1, y1, x2, y2;
  final int? pageNumber;

  const RectangleArea({
    required this.x1,
    required this.y1,
    required this.x2,
    required this.y2,
    this.pageNumber,
  });
}
