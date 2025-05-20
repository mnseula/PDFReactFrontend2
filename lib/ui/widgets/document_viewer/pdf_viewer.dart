import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import 'dart:typed_data';
import 'dart:ui' as ui;  // Add this import for ImageByteFormat
import 'package:document_processor/models/document_model.dart';
import 'package:document_processor/models/processing_options.dart';
import 'package:document_processor/ui/widgets/canvas_overlay.dart';
import 'package:document_processor/ui/widgets/drawing_pad.dart';

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
  final PdfViewerController _pdfViewerController = PdfViewerController();
  List<RectangleArea> _selectedAreas = [];
  Uint8List? _signatureImage;
  bool _isDrawingMode = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.document.name),
        actions: [
          IconButton(
            icon: const Icon(Icons.undo),
            onPressed: _selectedAreas.isEmpty ? null : _undoLastSelection,
          ),
          IconButton(
            icon: Icon(Icons.draw, 
              color: _isDrawingMode ? Colors.blue : null
            ),
            onPressed: _toggleDrawingMode,
          ),
        ],
      ),
      body: Stack(
        children: [
          SfPdfViewer.network(
            widget.document.path,
            controller: _pdfViewerController,
            enableTextSelection: !_isDrawingMode,
          ),
          if (!_isDrawingMode)
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
            Positioned(
              left: _selectedAreas.lastOrNull?.x1 ?? 0,
              top: _selectedAreas.lastOrNull?.y1 ?? 0,
              child: Image.memory(
                _signatureImage!,
                width: 100,
                height: 50,
              ),
            ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _processAnnotations,
        child: const Icon(Icons.save),
      ),
      bottomSheet: _isDrawingMode ? DrawingPad(
        onSignatureComplete: (signature) {
          setState(() {
            _signatureImage = signature;
            _isDrawingMode = false;
          });
        },
      ) : null,
    );
  }

  void _undoLastSelection() {
    setState(() {
      _selectedAreas.removeLast();
    });
  }

  void _toggleDrawingMode() {
    setState(() {
      _isDrawingMode = !_isDrawingMode;
    });
  }

  void _processAnnotations() {
    final annotation = AnnotationOptions(
      type: AnnotationType.signature,
      signatureData: _signatureImage,
      area: _selectedAreas.isNotEmpty ? _selectedAreas.last : null,
    );
    
    final processedDocument = Document(
      name: widget.document.name,
      url: widget.document.url,
      type: widget.document.type,
      annotations: [...?widget.document.annotations, annotation],
    );
    
    widget.onDocumentProcessed(processedDocument);
  }

  @override
  void dispose() {
    _pdfViewerController.dispose();
    super.dispose();
  }
}
