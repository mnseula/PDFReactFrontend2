import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import '../../models/processing_options.dart';
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
  Uint8List? _signatureImage;
  int? _currentPageNumber;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        SfPdfViewer.network(
          widget.document.path,
          controller: _pdfViewerController,
          onPageChanged: (PdfPageChangedDetails details) {
            setState(() {
              _currentPageNumber = details.newPageNumber;
            });
          },
        ),
        if (_isDrawing || _currentAnnotationType != null)
          Positioned.fill(
            child: CanvasOverlay(
              onAreaSelected: (area) {
                setState(() {
                  _selectedAreas.add(RectangleArea(
                    x1: area.x1,
                    y1: area.y1,
                    x2: area.x2,
                    y2: area.y2,
                    pageNumber: _currentPageNumber,
                  ));
                });
                
                // If we're adding a signature and have an area selected
                if (_currentAnnotationType == 'signature' && 
                    _selectedAreas.isNotEmpty && 
                    _signatureImage != null) {
                  _addSignatureToPdf();
                }
              },
              selectedAreas: _selectedAreas,
              onClearSelection: () {
                setState(() {
                  _selectedAreas.clear();
                });
              },
            ),
          ),
        if (_currentAnnotationType == 'signature' && _signatureImage == null)
          Positioned(
            bottom: 20,
            right: 20,
            child: DrawingPad(
              onSignatureComplete: (signatureImage) {
                setState(() {
                  _signatureImage = signatureImage;
                });
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Signature captured. Now select where to place it.'),
                  ),
                );
              },
            ),
          ),
      ],
    );
  }

  Future<void> _addSignatureToPdf() async {
    if (_selectedAreas.isEmpty || _signatureImage == null) return;

    try {
      // Show loading indicator
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Row(
            children: [
              CircularProgressIndicator(),
              SizedBox(width: 10),
              Text('Adding signature to document...'),
            ],
          ),
        ),
      );

      // Create annotation options
      final annotation = AnnotationOptions(
        type: AnnotationType.signature,
        area: _selectedAreas.last,
        signatureImage: base64Encode(_signatureImage!),
      );

      // Here you would typically call your API to add the signature
      // For example:
      // final processedDoc = await ApiService().processDocument(
      //   widget.document.id,
      //   ProcessingOptions(
      //     operation: 'annotate',
      //     parameters: annotation.toJson(),
      //   ),
      // );
      // widget.onDocumentProcessed(processedDoc);

      // Simulate API call delay
      await Future.delayed(const Duration(seconds: 2));

      // Reset signature state
      setState(() {
        _signatureImage = null;
        _selectedAreas.clear();
        _currentAnnotationType = null;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Signature added successfully')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to add signature: $e')),
      );
    }
  }

  // Call this method when the "Signature" tool is selected from the toolbar
  void startSignatureProcess() {
    setState(() {
      _currentAnnotationType = 'signature';
      _isDrawing = true;
    });
  }
}
