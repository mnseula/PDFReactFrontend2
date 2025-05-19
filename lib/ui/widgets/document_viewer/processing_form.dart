import 'package:flutter/material.dart';
import '../../models/processing_options.dart';

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
  final Map<String, dynamic> _formValues = {};
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
                    ? const CircularProgressIndicator()
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
          children: [
            TextFormField(
              decoration: const InputDecoration(
                labelText: 'Watermark Text',
              ),
              onSaved: (value) => _formValues['text'] = value,
              validator: (value) =>
                  value?.isEmpty ?? true ? 'Required field' : null,
            ),
            const SizedBox(height: 8),
            Slider(
              value: _formValues['opacity'] ?? 0.5,
              min: 0.1,
              max: 1.0,
              divisions: 9,
              label: 'Opacity: ${(_formValues['opacity'] ?? 0.5).toStringAsFixed(1)}',
              onChanged: (value) {
                setState(() {
                  _formValues['opacity'] = value;
                });
              },
            ),
            const SizedBox(height: 8),
            Slider(
              value: _formValues['fontSize'] ?? 24,
              min: 8,
              max: 72,
              divisions: 16,
              label: 'Font Size: ${(_formValues['fontSize'] ?? 24).round()}',
              onChanged: (value) {
                setState(() {
                  _formValues['fontSize'] = value;
                });
              },
            ),
            const SizedBox(height: 8),
            Slider(
              value: _formValues['angle'] ?? 45,
              min: 0,
              max: 360,
              divisions: 36,
              label: 'Angle: ${(_formValues['angle'] ?? 45).round()}°',
              onChanged: (value) {
                setState(() {
                  _formValues['angle'] = value;
                });
              },
            ),
          ],
        );
      case 'redact':
        return Column(
          children: [
            TextFormField(
              decoration: const InputDecoration(
                labelText: 'Overlay Text (optional)',
              ),
              onSaved: (value) => _formValues['overlayText'] = value,
            ),
            const SizedBox(height: 8),
            DropdownButtonFormField<String>(
              decoration: const InputDecoration(
                labelText: 'Redaction Color',
              ),
              items: ['Black', 'Red', 'Blue']
                  .map((color) => DropdownMenuItem(
                        value: color.toLowerCase(),
                        child: Text(color),
                      ))
                  .toList(),
              onChanged: (value) => _formValues['color'] = value,
            ),
          ],
        );
      // Add cases for other tools
      default:
        return const Text('No options available for this tool');
    }
  }

  Future<void> _processDocument() async {
    if (_formKey.currentState?.validate() ?? false) {
      _formKey.currentState?.save();
      setState(() {
        _isProcessing = true;
      });

      try {
        // Here you would call the API service to process the document
        // For now, we'll just simulate a delay
        await Future.delayed(const Duration(seconds: 2));

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Document processed successfully')),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error processing document: $e')),
        );
      } finally {
        setState(() {
          _isProcessing = false;
        });
      }
    }
  }
}
