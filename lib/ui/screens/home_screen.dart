import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../services/file_service.dart';
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Document Processor'),
        actions: [
          IconButton(
            icon: const Icon(Icons.account_circle),
            onPressed: () {
              // Placeholder for authentication
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
            },
          ),
        ],
      ),
      body: Row(
        children: [
          // Sidebar for tools
          Container(
            width: 250,
            padding: const EdgeInsets.all(8.0),
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
                    child: Text('Upload a document to get started'),
                  )
                : DocumentViewer(
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
}
