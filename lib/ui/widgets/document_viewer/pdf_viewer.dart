import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:document_processor/models/document_model.dart';
import 'package:document_processor/models/annotation_options.dart';
import 'package:document_processor/ui/widgets/canvas_overlay.dart';
import 'package:document_processor/ui/widgets/drawing_pad.dart';

// At the top of the file, after imports
import 'package:document_processor/models/geometry/rectangle_area.dart';

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
            // Change the onAreaSelected callback to:
            onAreaSelected: (RectangleArea area) {  // Explicit type
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
          if (_signatureImage != null && _selectedAreas.isNotEmpty)
            Positioned(
              left: _selectedAreas.last.x1,
              top: _selectedAreas.last.y1,
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
    if (_selectedAreas.isEmpty && _signatureImage == null) return;

    final annotation = AnnotationOptions(
      type: AnnotationType.signature,
      signatureData: _signatureImage,
      area: _selectedAreas.isNotEmpty ? _selectedAreas.last : null,
    );
    
    final processedDocument = Document(
      id: widget.document.id,
      name: widget.document.name,
      path: widget.document.path,
      size: widget.document.size,
      uploadDate: widget.document.uploadDate,
      thumbnailUrl: widget.document.thumbnailUrl,
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