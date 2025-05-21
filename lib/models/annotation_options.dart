// lib/models/annotation_options.dart
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