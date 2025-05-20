import 'package:flutter/material.dart';
import 'package:document_processor/models/document_model.dart';

class OfficeViewer extends StatelessWidget {
  final Document document;
  final Function(Document) onDocumentProcessed;

  const OfficeViewer({
    super.key,
    required this.document,
    required this.onDocumentProcessed,
  });

  IconData _getFileIcon() {
    switch (document.type) {
      case DocumentType.word:
        return Icons.description;
      case DocumentType.excel:
        return Icons.table_chart;
      case DocumentType.powerpoint:
        return Icons.slideshow;
      default:
        return Icons.insert_drive_file;
    }
  }

  String _getFileTypeString() {
    return document.type.toString().split('.').last.toUpperCase();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(_getFileIcon(), size: 64, color: Theme.of(context).primaryColor),
          const SizedBox(height: 16),
          Text(
            '${_getFileTypeString()} preview not available in web version',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 16),
          Text(
            'File: ${document.name}',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: () => onDocumentProcessed(document),
            icon: const Icon(Icons.download),
            label: const Text('Download File'),
          ),
        ],
      ),
    );
  }
}
