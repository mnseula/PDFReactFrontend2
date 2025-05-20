import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import 'dart:typed_data';
import 'dart:convert';
import '../../../models/document_model.dart';
import '../../../models/processing_options.dart';
import '../canvas_overlay.dart';
import '../drawing_pad.dart';

class PdfViewer extends StatefulWidget {
  final Document document;
  final Function(Document) onDocumentProcessed;

  const PdfViewer({
    Key? key,
    required this.document,
    required this.onDocumentProcessed,
  }) : super(key: key);

  @override
  PdfViewerState createState() => PdfViewerState();
}

class PdfViewerState extends State<PdfViewer> {
  List<RectangleArea> _selectedAreas = [];
  Uint8List? _signatureImage;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          SfPdfViewer.network(
            widget.document.url,
          ),
          CanvasOverlay(
            onAreaSelected: (area) {
              setState(() {
                _selectedAreas.add(area);
              });
            },
            onClearSelection: () {
              setState(() {
                _selectedAreas.clear();
              });
            },
          ),
          if (_signatureImage != null)
            Image.memory(
              _signatureImage!,
              width: 100,
              height: 100,
            ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Implement annotation logic
          final annotation = AnnotationOptions(
            type: AnnotationType.signature,
            signatureData: _signatureImage,
            area: _selectedAreas.isNotEmpty ? _selectedAreas.last : null,
          );
          print('Annotation: $annotation');
        },
        child: const Icon(Icons.add),
      ),
      bottomSheet: DrawingPad(
        onSignatureComplete: (signature) {
          setState(() {
            _signatureImage = signature;
          });
        },
      ),
    );
  }
}
