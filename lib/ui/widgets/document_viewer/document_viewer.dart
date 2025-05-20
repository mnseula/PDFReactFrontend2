import 'package:flutter/material.dart';
import '../../models/document_model.dart'; // Assuming this path is correct
// Import the specific state class for the GlobalKey using a relative path
import 'pdf_viewer.dart'; // Assuming PdfViewerState is defined here

class DocumentViewer extends StatefulWidget {
  final Document document; // Assuming Document is defined in document_model.dart
  final Function(Document) onDocumentProcessed;
  // The key is typically passed down from the parent, not declared here
  // final GlobalKey<PdfViewerState>? key; // Removed this line

  const DocumentViewer({
    super.key, // Use super.key instead of this.key
    required this.document,
    required this.onDocumentProcessed,
  }); // Removed key from constructor body

  @override
  State<DocumentViewer> createState() => _DocumentViewerState();
}

class _DocumentViewerState extends State<DocumentViewer> {
  // Corrected the GlobalKey type to reference the specific state class
  final GlobalKey<PdfViewerState> _currentViewerKey = GlobalKey<PdfViewerState>();

  @override
  Widget build(BuildContext context) {
    // This widget acts as a router to different viewers based on document type
    switch (widget.document.type) {
      case DocumentType.pdf: // Assuming DocumentType is an enum in document_model.dart
        return PdfViewer(
          key: _currentViewerKey, // Pass the specific key to the PdfViewer
          document: widget.document,
          onDocumentProcessed: widget.onDocumentProcessed,
        );
      case DocumentType.word:
      case DocumentType.powerpoint:
      case DocumentType.excel:
        // Placeholder for other document types
        return Center(child: Text('Viewer for ${widget.document.type.toString().split('.').last} files not implemented yet.'));
      case DocumentType.image:
        // Placeholder for image viewer
         return Center(child: Text('Viewer for images not implemented yet.'));
      default:
        return Center(child: Text('Unsupported document type: ${widget.document.type}'));
    }
  }
}
