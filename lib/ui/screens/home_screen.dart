import 'package:flutter/material.dart';
import '../../services/file_service.dart';
import '../../models/document_model.dart';
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
  String? _selectedTool; // e.g., 'sign', 'redact', 'annotate'
  bool _isProcessing = false;

  void _handleFileUpload(Document document) {
    setState(() {
      _currentDocument = document;
      _selectedTool = null; // Reset tool selection on new upload
      _isProcessing = false; // Reset processing state
    });
    // Optionally navigate or update UI to show the document viewer
  }

  void _handleToolSelected(String tool) {
    setState(() {
      _selectedTool = tool;
      _isProcessing = false; // Reset processing state
    });
    // Logic to activate specific tool UI/behavior
  }

  void _handleProcessingStart() {
    setState(() {
      _isProcessing = true;
    });
    // Logic to show processing indicator
  }

  void _handleProcessingComplete(Document processedDocument) {
    setState(() {
      _currentDocument = processedDocument; // Update with the processed document
      _isProcessing = false;
      _selectedTool = null; // Reset tool after processing
    });
    // Logic to hide processing indicator and show updated document
  }

  void _handleProcessingCancel() {
    setState(() {
      _isProcessing = false;
      // Optionally reset selected areas or other tool-specific state
    });
    // Logic to hide processing indicator
  }

  Widget _buildLeftPanel(BuildContext context) {
    return Container(
      width: 300, // Example width, adjust as needed
      decoration: BoxDecoration(
        // Corrected Border syntax here:
        border: Border(right: BorderSide(color: Theme.of(context).dividerColor)),
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              'Document Tools',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Assuming UploadWidget is a StatelessWidget or StatefulWidget
                  // and the constructor call is correct once the file is found.
                  const UploadWidget(), // Assuming this widget handles file picking and calls _handleFileUpload
                  const SizedBox(height: 24),
                  if (_currentDocument != null) ...[
                    ToolSelector( // Assuming ToolSelector is a StatelessWidget or StatefulWidget
                      onToolSelected: _handleToolSelected,
                      selectedTool: _selectedTool,
                    ),
                    const SizedBox(height: 24),
                    if (_selectedTool != null && !_isProcessing)
                      ProcessingForm( // Assuming ProcessingForm is a StatelessWidget or StatefulWidget
                        document: _currentDocument!,
                        selectedTool: _selectedTool!,
                        onProcessingStart: _handleProcessingStart,
                        onProcessingComplete: _handleProcessingComplete,
                        onProcessingCancel: _handleProcessingCancel,
                      ),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRightPanel(BuildContext context) {
    return Expanded(
      child: _currentDocument == null
          ? Center(
              child: Text(
                'Upload a document to get started',
                style: Theme.of(context).textTheme.titleMedium,
              ),
            )
          : DocumentViewer( // Assuming DocumentViewer is a StatelessWidget or StatefulWidget
              document: _currentDocument!,
              onDocumentProcessed: _handleProcessingComplete, // Pass the complete handler
            ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Document Processor'),
      ),
      body: Row(
        children: [
          _buildLeftPanel(context),
          _buildRightPanel(context),
        ],
      ),
    );
  }
}
