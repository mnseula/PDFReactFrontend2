import 'package:flutter/material.dart';
import 'dart:typed_data';
import 'dart:io';
import 'package:document_processor/services/file_service.dart';
import 'package:document_processor/models/document_model.dart';
import 'package:document_processor/ui/widgets/upload_widget.dart';
import 'package:document_processor/ui/widgets/tool_selector.dart';
import 'package:document_processor/ui/widgets/document_viewer/document_viewer.dart';
import 'package:document_processor/ui/widgets/processing_form.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Document? _currentDocument;
  String? _selectedTool;
  Uint8List? _signatureImage;

  final FileService _fileService = FileService();

  Future<void> _handleFileUpload() async {
    final file = await _fileService.pickDocument();
    if (file != null) {
      final type = _getDocumentType(file.path);
      final document = Document(
        id: DateTime.now().millisecondsSinceEpoch.toString(), // Add required id
        name: file.name,
        path: file.path,
        size: 0, // Add required size
        uploadDate: DateTime.now(), // Add required uploadDate
        type: type,
      );

      setState(() {
        _currentDocument = document;
      });
    }
  }

  DocumentType _getDocumentType(String path) {
    if (path.endsWith('.pdf')) return DocumentType.pdf;
    if (path.endsWith('.doc') || path.endsWith('.docx')) return DocumentType.word;
    if (path.endsWith('.xls') || path.endsWith('.xlsx')) return DocumentType.excel;
    if (path.endsWith('.ppt') || path.endsWith('.pptx')) return DocumentType.powerpoint;
    if (path.endsWith('.jpg') || path.endsWith('.jpeg') || path.endsWith('.png')) return DocumentType.image;
    return DocumentType.unknown;
  }

  void _handleToolSelected(String tool) {
    setState(() {
      _selectedTool = tool;
    });
  }

  void _handleProcessingStart() {
    // TODO: Implement processing start logic
  }

  void _handleSignatureComplete(Uint8List signature) {
    setState(() {
      _signatureImage = signature;
    });
  }

  @override
  Widget build(BuildContext context) {
    // TODO: Implement build method
    return const Placeholder();
  }
}

class FileService {
  Future<File?> pickDocument() async {
    return pickFile(['pdf', 'doc', 'docx', 'xls', 'xlsx', 'ppt', 'pptx']);
  }

  Future<File?> pickFile(List<String> allowedExtensions) async {
    // TODO: Implement file picking logic
    return null;
  }
}
