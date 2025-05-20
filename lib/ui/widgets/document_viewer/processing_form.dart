import 'package:flutter/material.dart';
import 'package:document_processor/models/processing_options.dart';
import 'package:document_processor/models/document_model.dart';

class ProcessingForm extends StatefulWidget {
  final String tool;
  final Document? document;

  const ProcessingForm({
    super.key,
    required this.tool,
    this.document,
  });

  @override
  State<ProcessingForm> createState() => _ProcessingFormState();
}

class _ProcessingFormState extends State<ProcessingForm> {
  final _formKey = GlobalKey<FormState>();
  final Map<String, dynamic> _formValues = {
    'opacity': 0.5,
    'scale': 1.0,
    'rotation': 0.0,
  };
  bool _isProcessing = false;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                '${widget.tool.toUpperCase()} Options',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 16),
              _buildFormFields(),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: _isProcessing ? null : _processDocument,
                child: _isProcessing
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Text('Process Document'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFormFields() {
    switch (widget.tool) {
      case 'watermark':
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextFormField(
              decoration: const InputDecoration(
                labelText: 'Watermark Text',
                hintText: 'Enter text to watermark',
              ),
              onSaved: (value) => _formValues['text'] = value,
              validator: (value) =>
                  value?.isEmpty ?? true ? 'Required field' : null,
            ),
            const SizedBox(height: 16),
            const Text('Opacity'),
            Slider(
              value: _formValues['opacity'] ?? 0.5,
              min: 0.1,
              max: 1.0,
              divisions: 9,
              label: '${(_formValues['opacity'] * 100).round()}%',
              onChanged: (value) {
                setState(() {
                  _formValues['opacity'] = value;
                });
              },
            ),
            const SizedBox(height: 16),
            const Text('Scale'),
            Slider(
              value: _formValues['scale'] ?? 1.0,
              min: 0.5,
              max: 2.0,
              divisions: 15,
              label: '${_formValues['scale']}x',
              onChanged: (value) {
                setState(() {
                  _formValues['scale'] = value;
                });
              },
            ),
            const SizedBox(height: 16),
            const Text('Rotation'),
            Slider(
              value: _formValues['rotation'] ?? 0.0,
              min: -180,
              max: 180,
              divisions: 36,
              label: '${_formValues['rotation']}°',
              onChanged: (value) {
                setState(() {
                  _formValues['rotation'] = value;
                });
              },
            ),
          ],
        );
      default:
        return const Center(
          child: Text('No options available for this tool'),
        );
    }
  }

  Future<void> _processDocument() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isProcessing = true;
    });

    try {
      _formKey.currentState!.save();
      // TODO: Implement document processing
      await Future.delayed(const Duration(seconds: 1)); // Simulate processing
    } finally {
      if (mounted) {
        setState(() {
          _isProcessing = false;
        });
      }
    }
  }
}
