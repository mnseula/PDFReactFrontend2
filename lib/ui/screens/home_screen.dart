import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/file_service.dart';
import '../models/document_model.dart';
import '../widgets/upload_widget.dart';
import '../widgets/tool_selector.dart';
import '../widgets/document_viewer/document_viewer.dart';
import '../widgets/processing_form.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Document? _currentDocument;
  String? _selectedTool;
  final GlobalKey<DocumentViewerState> _documentViewerKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Document Processor'),
        actions: [
          IconButton(
            icon: const Icon(Icons.account_circle),
            onPressed: _showAuthDialog,
          ),
        ],
      ),
      body: Row(
        children: [
          // Sidebar for tools
          Container(
            width: 250,
            padding: const EdgeInsets.all(8.0),
            decoration: BoxDecoration(
              border: Border.right: BorderSide(color: Theme.of(context).dividerColor),
            ),
            child: Column(
              children: [
                const UploadWidget(),
                const SizedBox(height: 16),
                ToolSelector(
                  onToolSelected: (tool) {
                    setState(() {
                      _selectedTool = tool;
                    });
                  },
                  onSignatureSelected: () {
                    _documentViewerKey.currentState?.startSignatureProcess();
                  },
                ),
                if (_selectedTool != null) ...[
                  const SizedBox(height: 16),
                  ProcessingForm(
                    tool: _selectedTool!,
                    document: _currentDocument,
                  ),
                ],
              ],
            ),
          ),
          // Main content area
          Expanded(
            child: _currentDocument == null
                ? const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.upload_file, size: 64, color: Colors.grey),
                        SizedBox(height: 16),
                        Text(
                          'Upload a document to get started',
                          style: TextStyle(fontSize: 18, color: Colors.grey),
                        ),
                      ],
                    ),
                  )
                : DocumentViewer(
                    key: _documentViewerKey,
                    document: _currentDocument!,
                    onDocumentProcessed: (newDocument) {
                      setState(() {
                        _currentDocument = newDocument;
                      });
                    },
                  ),
          ),
        ],
      ),
    );
  }

  void _showAuthDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Authentication'),
        content: const Text('Authentication will be implemented later.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  // Call this when a file is uploaded
  void _handleFileUpload(Document document) {
    setState(() {
      _currentDocument = document;
      _selectedTool = null; // Reset selected tool when new document is uploaded
    });
  }
}
