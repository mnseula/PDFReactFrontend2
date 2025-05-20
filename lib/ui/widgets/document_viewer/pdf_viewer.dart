import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import '../../models/document_model.dart';
import '../../models/processing_options.dart';
import '../canvas_overlay.dart';
import '../drawing_pad.dart';

class PdfViewer extends StatefulWidget {
  final Document document;
  final Function(Document) onDocumentProcessed;
  final GlobalKey<PdfViewerState>? key;

  const PdfViewer({
    this.key,
    required this.document,
    required this.onDocumentProcessed,
  }) : super(key: key);

  @override
  PdfViewerState createState() => PdfViewerState();
}

class PdfViewerState extends State<PdfViewer> {
  final PdfViewerController _pdfViewerController = PdfViewerController();
  List<RectangleArea> _selectedAreas = [];
  bool _isDrawing = false;
  String? _currentAnnotationType;
  Uint8List? _signatureImage;
  int? _currentPageNumber;

  void startSignatureProcess() {
    setState(() {
      _currentAnnotationType = 'signature';
      _isDrawing = true;
      _signatureImage = null;
      _selectedAreas.clear();
    });
  }

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
                    duration: Duration(seconds: 2),
                  ),
                );
              },
              onCancel: () {
                setState(() {
                  _currentAnnotationType = null;
                  _isDrawing = false;
                });
              },
            ),
          ),
      ],
    );
  }

  Future<void> _addSignatureToPdf() async {
    if (_selectedAreas.isEmpty || _signatureImage == null) return;

    final scaffoldMessenger = ScaffoldMessenger.of(context);
    scaffoldMessenger.showSnackBar(
      const SnackBar(
        content: Row(
          children: [
            CircularProgressIndicator(),
            SizedBox(width: 10),
            Text('Adding signature to document...'),
          ],
        ),
        duration: Duration(seconds: 2),
      ),
    );

    try {
      // Create annotation options
      final annotation = AnnotationOptions(
        type: AnnotationType.signature,
        area: _selectedAreas.last,
        signatureImage: base64Encode(_signatureImage!),
      );

      // In a real app, you would call your API here:
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
        _isDrawing = false;
      });

      scaffoldMessenger.showSnackBar(
        const SnackBar(
          content: Text('Signature added successfully'),
          duration: Duration(seconds: 2),
        ),
      );
    } catch (e) {
      scaffoldMessenger.showSnackBar(
        SnackBar(
          content: Text('Failed to add signature: $e'),
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }
}
