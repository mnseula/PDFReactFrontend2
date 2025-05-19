import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import '../../models/document_model.dart';

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
      ),
      body: PDFView(
        filePath: document.path,
        enableSwipe: true,
        swipeHorizontal: false,
        autoSpacing: true,
        pageFling: true,
        onError: (error) {
          print(error.toString());
        },
        onPageError: (page, error) {
          print('$page: ${error.toString()}');
        },
      ),
    );
  }
}
