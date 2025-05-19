import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../services/file_service.dart';
import '../../models/document_model.dart';

class UploadWidget extends StatelessWidget {
  const UploadWidget({super.key});

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
              onPressed: () async {
                try {
                  final file = await fileService.pickFile([
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
                  ]);
                  if (file != null) {
                    // Here you would typically upload the file to your backend
                    // For now, we'll just show a success message
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Selected file: ${file.name}')),
                    );
                  }
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Error selecting file: $e')),
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
