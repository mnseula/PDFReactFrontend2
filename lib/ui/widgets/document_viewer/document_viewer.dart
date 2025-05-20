import 'package:flutter/material.dart';
import 'package:document_processor/models/document_model.dart';
import 'package:document_processor/ui/widgets/document_viewer/pdf_viewer.dart';

class DocumentViewer extends StatefulWidget {
  final Document document;
  final Function(Document) onDocumentProcessed;

  const DocumentViewer({
    super.key,
    required this.document,
    required this.onDocumentProcessed,
  });

  @override
  State<DocumentViewer> createState() => _DocumentViewerState();
}

class _DocumentViewerState extends State<DocumentViewer> {
  final GlobalKey<PdfViewerState> _currentViewerKey = GlobalKey<PdfViewerState>();

  @override
  Widget build(BuildContext context) {
    return _buildViewer();
  }

  Widget _buildViewer() {
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
        return _buildPlaceholderViewer('${widget.document.type.toString().split('.').last}');
      case DocumentType.image:
        return _buildImageViewer();
      default:
        return _buildUnsupportedViewer();
    }
  }

  Widget _buildPlaceholderViewer(String type) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.file_present, size: 48, color: Colors.grey),
          const SizedBox(height: 16),
          Text('Viewer for $type files not implemented yet'),
        ],
      ),
    );
  }

  Widget _buildImageViewer() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.image, size: 48, color: Colors.grey),
          const SizedBox(height: 16),
          const Text('Image viewer coming soon'),
        ],
      ),
    );
  }

  Widget _buildUnsupportedViewer() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.error_outline, size: 48, color: Colors.red),
          const SizedBox(height: 16),
          Text('Unsupported document type: ${widget.document.type}'),
        ],
      ),
    );
  }
}
