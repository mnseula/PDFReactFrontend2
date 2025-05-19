import 'package:flutter/material.dart';
import '../../../models/document_model.dart';

class OfficeViewer extends StatelessWidget {
  final Document document;
  final Function(Document) onDocumentProcessed;

  const OfficeViewer({
    super.key,
    required this.document,
    required this.onDocumentProcessed,
  });

  @override
  Widget build(BuildContext context) {
    // For web, we can use an iframe or display a message
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.insert_drive_file, size: 64),
          const SizedBox(height: 16),
          Text(
            'Office file preview not available in web version',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 16),
          Text(
            'File: ${document.name}',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ],
      ),
    );
  }
}
