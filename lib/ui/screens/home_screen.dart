import 'package:flutter/material.dart';
import 'dart:typed_data';
import '../services/file_service.dart';
import '../models/document_model.dart';
import '../widgets/upload_widget.dart';
import '../widgets/tool_selector.dart';
import '../widgets/document_viewer/document_viewer.dart';
import '../widgets/processing_form.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Document? _currentDocument;
  String? _selectedTool;
  Uint8List? _signatureImage;

  final FileService _fileService = FileService();

  Future<void> _handleFileUpload() async {
    File? file = await _fileService.pickDocument();
    if (file != null) {
      // Determine document type based on extension
      DocumentType type = DocumentType.unknown;
      if (file.path.endsWith('.pdf')) {
        type = DocumentType.pdf;
      } else if (file.path.endsWith('.doc') || file.path.endsWith('.docx')) {
        type = DocumentType.word;
      } else if (file.path.endsWith('.xls') || file.path.endsWith('.xlsx')) {
        type = DocumentType.excel;
      } else if (file.path.endsWith('.ppt') || file.path.endsWith('.pptx')) {
        type = DocumentType.powerpoint;
      } else if (file.path.endsWith('.jpg') || file.path.endsWith('.jpeg') || file.path.endsWith('.png')) {
        type = DocumentType.image;
      }

      // Create a Document object
      Document document = Document(
        name: file.path.split('/').last,
        url: file.path, // For web, this might need to be a URL
        type: type,
      );

      setState(() {
        _currentDocument = document;
      });
    }
  }


  void _handleToolSelected(String tool) {
    setState(() {
      _selectedTool = tool;
    });
  }

  void _handleProcessingStart() {
    // Implement processing start logic
  }

  void _handleSignatureComplete(Uint8List signature) {
    setState(() {
      _signatureImage = signature;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Document Processor'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            UploadWidget(onPressed: _handleFileUpload),
            if (_currentDocument != null)
              ToolSelector(
                onToolSelected: _handleToolSelected,
                selectedTool: _selectedTool ?? '',
              ),
            if (_currentDocument != null && _selectedTool != null)
              ProcessingForm(
                document: _currentDocument!,
                selectedTool: _selectedTool!,
                onProcessingStart: _handleProcessingStart,
              ),
            if (_currentDocument != null)
              Expanded(
                child: DocumentViewer(
                  document: _currentDocument!,
                  onDocumentProcessed: (Document processedDocument) {
                    // Handle processed document
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }
}
