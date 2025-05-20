import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:document_processor/services/file_service.dart';
import 'package:document_processor/models/document_model.dart';

class UploadWidget extends StatelessWidget {
  const UploadWidget({super.key});

  static const _supportedFormats = [
    '.pdf',
    '.doc',
    '.docx',
    '.ppt',
    '.pptx',
    '.xls',
    '.xlsx',
    '.jpg',
    '.jpeg',
    '.png'
  ];

  @override
  Widget build(BuildContext context) {
    final fileService = Provider.of<FileService>(context, listen: false);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Upload Document',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text('Supported formats: PDF, DOCX, PPTX, XLSX, JPG, PNG'),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              icon: const Icon(Icons.upload_file),
              label: const Text('Select File'),
              onPressed: () => _handleFileSelection(context, fileService),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _handleFileSelection(
    BuildContext context, 
    FileService fileService,
  ) async {
    try {
      final file = await fileService.pickFile(_supportedFormats);
      if (file != null && context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Selected file: ${file.name}')),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error selecting file: $e')),
        );
      }
    }
  }
}
