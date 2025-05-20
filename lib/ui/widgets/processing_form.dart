import 'package:flutter/material.dart';
import '../../../models/document_model.dart';

class ProcessingForm extends StatelessWidget {
  final Document document;
  final String selectedTool;
  
  const ProcessingForm({
    super.key,
    required this.document,
    required this.selectedTool,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Text('Processing options for $selectedTool'),
      ),
    );
  }
}