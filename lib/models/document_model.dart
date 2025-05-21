import 'package:flutter/foundation.dart';
import 'dart:typed_data';
import 'package:document_processor/models/annotation_options.dart';

enum DocumentType {
  pdf,
  word,
  excel,
  powerpoint,
  image,
  unknown,
}

class Document {
  final String id;
  final String name;
  final String path;
  final int size;
  final DateTime uploadDate;
  final String? thumbnailUrl;
  final DocumentType type;
  final List<AnnotationOptions>? annotations;

  const Document({
    required this.id,
    required this.name,
    required this.path,
    required this.size,
    required this.uploadDate,
    this.thumbnailUrl,
    required this.type,
    this.annotations,
  });

  factory Document.fromJson(Map<String, dynamic> json) {
    return Document(
      id: json['id'] as String,
      name: json['name'] as String,
      path: json['path'] as String,
      size: json['size'] as int,
      uploadDate: DateTime.parse(json['uploadDate'] as String),
      thumbnailUrl: json['thumbnailUrl'] as String?,
      type: DocumentType.values.firstWhere(
        (e) => e.toString() == 'DocumentType.${json['type']}',
        orElse: () => DocumentType.unknown,
      ),
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'path': path,
    'size': size,
    'uploadDate': uploadDate.toIso8601String(),
    'thumbnailUrl': thumbnailUrl,
    'type': type.toString().split('.').last,
  };

  Document copyWith({
    String? id,
    String? name,
    String? path,
    int? size,
    DateTime? uploadDate,
    String? thumbnailUrl,
    DocumentType? type,
    List<AnnotationOptions>? annotations,
  }) {
    return Document(
      id: id ?? this.id,
      name: name ?? this.name,
      path: path ?? this.path,
      size: size ?? this.size,
      uploadDate: uploadDate ?? this.uploadDate,
      thumbnailUrl: thumbnailUrl ?? this.thumbnailUrl,
      type: type ?? this.type,
      annotations: annotations ?? this.annotations,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Document &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          name == other.name &&
          path == other.path &&
          size == other.size &&
          uploadDate == other.uploadDate &&
          thumbnailUrl == other.thumbnailUrl &&
          type == other.type;

  @override
  int get hashCode => Object.hash(
    id,
    name,
    path,
    size,
    uploadDate,
    thumbnailUrl,
    type,
  );

  @override
  String toString() => 'Document(id: $id, name: $name, type: $type)';
}
