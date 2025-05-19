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

  factory Document.fromJson(Map<String, dynamic> json) {
    return Document(
      id: json['id'],
      name: json['name'],
      path: json['path'],
      size: json['size'],
      uploadDate: DateTime.parse(json['uploadDate']),
      thumbnailUrl: json['thumbnailUrl'],
      type: DocumentType.values.firstWhere(
        (e) => e.toString() == 'DocumentType.${json['type']}',
        orElse: () => DocumentType.other,
      ),
    );
  }
}

enum DocumentType {
  pdf,
  word,
  powerpoint,
  excel,
  image,
  other,
}
