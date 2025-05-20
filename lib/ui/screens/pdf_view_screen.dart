import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import 'package:document_processor/models/document_model.dart';

class PdfViewScreen extends StatelessWidget {
  final Document document;
  final Function(Document) onDocumentProcessed;

  const PdfViewScreen({
    super.key,
    required this.document,
    required this.onDocumentProcessed,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(document.name),
        actions: [
          IconButton(
            icon: const Icon(Icons.check),
            onPressed: () => onDocumentProcessed(document),
          ),
        ],
      ),
      body: SfPdfViewer.network(
        document.url,
        onDocumentLoadFailed: (PdfDocumentLoadFailedDetails details) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error: ${details.error}')),
          );
        },
        enableDoubleTapZooming: true,
        enableTextSelection: true,
        pageSpacing: 4,
      ),
    );
  }
}
