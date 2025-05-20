import 'package:flutter/foundation.dart';

class Document {
  final String id;
  final String name;
  final String path;
  final int size;
  final DateTime uploadDate;
  final String? thumbnailUrl;
  final DocumentType type;

  Document({
    required this.id,
    required this.name,
    required this.path,
    required this.size,
    required this.uploadDate,
    this.thumbnailUrl,
    required this.type,
  });
}

enum DocumentType {
  pdf,
  word,
  excel,
  powerpoint,
  image,
  unknown,
}
