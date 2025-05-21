// lib/models/annotation_options.dart
import 'dart:typed_data';
import 'package:flutter/material.dart';

enum AnnotationType {
  signature,
  highlight,
  redaction,
}

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

class AnnotationOptions {
  final AnnotationType type;
  final Uint8List? signatureData;
  final RectangleArea? area;

  const AnnotationOptions({
    required this.type,
    this.signatureData,
    this.area,
  });

  Map<String, dynamic> toJson() => {
    'type': type.toString(),
    'signatureData': signatureData,
    'area': area,
  };
}