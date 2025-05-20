import 'package:flutter/material.dart';
import '../../../models/document_model.dart';

class ProcessingForm extends StatelessWidget {
  final Document document;
  
  const ProcessingForm({
    super.key,
    required this.document,
  });

  @override
  Widget build(BuildContext context) {
    return const Card(
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Text('Processing options will go here'),
      ),
    );
  }
}