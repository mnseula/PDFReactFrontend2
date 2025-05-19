import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import '../../../models/document_model.dart';
import '../canvas_overlay.dart';
import '../drawing_pad.dart';

class PdfViewer extends StatefulWidget {
  final Document document;
  final Function(Document) onDocumentProcessed;

  const PdfViewer({
    super.key,
    required this.document,
    required this.onDocumentProcessed,
  });

  @override
  State<PdfViewer> createState() => _PdfViewerState();
}

class _PdfViewerState extends State<PdfViewer> {
  final PdfViewerController _pdfViewerController = PdfViewerController();
  List<RectangleArea> _selectedAreas = [];
  bool _isDrawing = false;
  String? _currentAnnotationType;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        SfPdfViewer.network(
          widget.document.path,
          controller: _pdfViewerController,
        ),
        if (_isDrawing || _currentAnnotationType != null)
          Positioned.fill(
            child: CanvasOverlay(
              onAreaSelected: (area) {
                setState(() {
                  _selectedAreas.add(area);
                });
              },
              selectedAreas: _selectedAreas,
              onClearSelection: () {
                setState(() {
                  _selectedAreas.clear();
                });
              },
            ),
          ),
        if (_currentAnnotationType == 'signature')
          Positioned(
            bottom: 20,
            right: 20,
            child: DrawingPad(
              onSignatureComplete: (signatureImage) {
                // Handle signature placement
                // This would involve adding the signature to the selected area
              },
            ),
          ),
      ],
    );
  }
}
