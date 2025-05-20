import 'package:flutter/material.dart';
import 'package:document_processor/models/document_model.dart';

class ProcessingForm extends StatelessWidget {
  final Document document;
  final String selectedTool;
  final VoidCallback onProcessingStart;

  const ProcessingForm({
    Key? key,
    required this.document,
    required this.selectedTool,
    required this.onProcessingStart,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text('Processing options for $selectedTool'),
            ElevatedButton(
              onPressed: onProcessingStart,
              child: const Text('Start Processing'),
            ),
          ],
        ),
      ),
    );
  }
}