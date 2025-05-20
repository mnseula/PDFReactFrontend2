import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class ToolSelector extends StatelessWidget {
  final Function(String) onToolSelected;
  final VoidCallback? onSignatureSelected;

  const ToolSelector({
    super.key,
    required this.onToolSelected,
    this.onSignatureSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Text(
          'PDF Tools',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8.0,
          runSpacing: 8.0,
          children: [
            _buildToolButton('Compress', Icons.compress, 'compress'),
            _buildToolButton('Crop', Icons.crop, 'crop'),
            _buildToolButton('Redact', Icons.block, 'redact'),
            _buildToolButton('Watermark', Icons.text_fields, 'watermark'),
            _buildToolButton('Annotate', Icons.edit, 'annotate'),
            _buildToolButton('Edit Text', Icons.find_replace, 'edit'),
            _buildToolButton('OCR', Icons.text_snippet, 'ocr'),
            _buildSignatureButton(),
          ],
        ),
        const SizedBox(height: 16),
        const Text(
          'Conversion Tools',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8.0,
          runSpacing: 8.0,
          children: [
            _buildToolButton('To Word', Icons.description, 'to-word'),
            _buildToolButton('To PowerPoint', Icons.slideshow, 'to-powerpoint'),
            _buildToolButton('To Excel', Icons.table_chart, 'to-excel'),
            _buildToolButton('To PDF', Icons.picture_as_pdf, 'to-pdf'),
            _buildToolButton('To JPG', Icons.image, 'to-jpg'),
          ],
        ),
      ],
    );
  }

  Widget _buildToolButton(String label, IconData icon, String tool) {
    return Tooltip(
      message: label,
      child: ElevatedButton.icon(
        icon: Icon(icon),
        label: Text(label),
        onPressed: () => onToolSelected(tool),
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        ),
      ),
    );
  }

  Widget _buildSignatureButton() {
    return Tooltip(
      message: 'Signature',
      child: ElevatedButton.icon(
        icon: const Icon(Icons.edit),
        label: const Text('Signature'),
        onPressed: () {
          onToolSelected('signature');
          onSignatureSelected?.call();
        },
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        ),
      ),
    );
  }
}
