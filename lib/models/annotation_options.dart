// lib/models/annotation_options.dart
import 'dart:typed_data';
import 'package:document_processor/models/geometry/rectangle_area.dart';
// Remove the RectangleArea class from this file
// Keep the rest of the file exactly as is

class RectangleArea {
  final double x1;
  final double y1;
  final double x2;
  final double y2;

  const RectangleArea({
    required this.x1,
    required this.y1,
    required this.x2,
    required this.y2,
  });
}

enum AnnotationType {
  signature,
  highlight,
  redaction,
}

class AnnotationOptions {
  final AnnotationType type;
  final Uint8List? signatureData;
  final RectangleArea? area;

  const AnnotationOptions({
    required this.type,
    this.signatureData,
    this.area,
  });
}