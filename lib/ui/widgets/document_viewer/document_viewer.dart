import 'package:flutter/material.dart';
import '../../models/document_model.dart';
import 'pdf_viewer.dart';
import 'office_viewer.dart';

class DocumentViewer extends StatefulWidget {
  final Document document;
  final Function(Document) onDocumentProcessed;
  final GlobalKey<DocumentViewerState>? key;

  const DocumentViewer({
    this.key,
    required this.document,
    required this.onDocumentProcessed,
  }) : super(key: key);

  @override
  DocumentViewerState createState() => DocumentViewerState();
}

class DocumentViewerState extends State<DocumentViewer> {
  final GlobalKey _currentViewerKey = GlobalKey();

  void startSignatureProcess() {
    if (_currentViewerKey.currentState is PdfViewerState) {
      (_currentViewerKey.currentState as PdfViewerState).startSignatureProcess();
    }
    // Add similar handling for other viewer types if needed
  }

  @override
  Widget build(BuildContext context) {
    switch (widget.document.type) {
      case DocumentType.pdf:
        return PdfViewer(
          key: _currentViewerKey,
          document: widget.document,
          onDocumentProcessed: widget.onDocumentProcessed,
        );
      case DocumentType.word:
      case DocumentType.powerpoint:
      case DocumentType.excel:
        return OfficeViewer(
          key: _currentViewerKey,
          document: widget.document,
          onDocumentProcessed: widget.onDocumentProcessed,
        );
      case DocumentType.image:
        return Center(
          child: Image.network(widget.document.path),
        );
      default:
        return const Center(
          child: Text('Unsupported document type'),
        );
    }
  }
}
