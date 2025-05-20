import 'package:flutter/material.dart';
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

  void _handleFileUpload(Document document) {
    setState(() {
      _currentDocument = document;
    });
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
            const UploadWidget(),
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
