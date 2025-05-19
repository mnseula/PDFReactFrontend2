import 'package:flutter/material.dart';
import '../../models/document_model.dart';
import 'pdf_viewer.dart';
import 'office_viewer.dart';

class DocumentViewer extends StatelessWidget {
  final Document document;
  final Function(Document) onDocumentProcessed;

  const DocumentViewer({
    super.key,
    required this.document,
    required this.onDocumentProcessed,
  });

  @override
  Widget build(BuildContext context) {
    switch (document.type) {
      case DocumentType.pdf:
        return PdfViewer(
          document: document,
          onDocumentProcessed: onDocumentProcessed,
        );
      case DocumentType.word:
      case DocumentType.powerpoint:
      case DocumentType.excel:
        return OfficeViewer(
          document: document,
          onDocumentProcessed: onDocumentProcessed,
        );
      case DocumentType.image:
        return Center(
          child: Image.network(document.path),
        );
      default:
        return const Center(
          child: Text('Unsupported document type'),
        );
    }
  }
}
