import 'dart:html' as html;
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:universal_html/html.dart' as universal_html;
import 'package:document_processor/models/document_model.dart';

class FileService {
  static const int maxFileSizeMb = 10;

  Future<html.File?> pickFile(List<String> allowedExtensions) async {
    try {
      final input = html.FileUploadInputElement()
        ..accept = allowedExtensions.map((e) => '.$e').join(',');
      input.click();

      final event = await input.onChange.first;
      if (input.files?.isEmpty ?? true) return null;

      final file = input.files!.first;
      if (!_isValidFileSize(file)) {
        throw Exception('File size exceeds $maxFileSizeMb MB limit');
      }

      if (!_isValidFileType(file.name, allowedExtensions)) {
        throw Exception('Invalid file type. Allowed: ${allowedExtensions.join(", ")}');
      }

      return file;
    } catch (e) {
      debugPrint('Error picking file: $e');
      rethrow;
    }
  }

  Future<Uint8List> readFile(html.File file) async {
    try {
      final reader = html.FileReader();
      reader.readAsArrayBuffer(file);
      await reader.onLoad.first;
      return reader.result as Uint8List;
    } catch (e) {
      debugPrint('Error reading file: $e');
      rethrow;
    }
  }

  void downloadFile(Uint8List bytes, String fileName) {
    try {
      final blob = html.Blob([bytes]);
      final url = html.Url.createObjectUrlFromBlob(blob);
      final anchor = html.AnchorElement(href: url)
        ..target = 'blank'
        ..download = fileName
        ..click();
      html.Url.revokeObjectUrl(url);
    } catch (e) {
      debugPrint('Error downloading file: $e');
      rethrow;
    }
  }

  void viewFileInNewTab(Uint8List bytes, String fileName) {
    try {
      final blob = html.Blob([bytes]);
      final url = html.Url.createObjectUrlFromBlob(blob);
      universal_html.window.open(url, '_blank');
      // URL revocation handled by browser when tab closes
    } catch (e) {
      debugPrint('Error viewing file: $e');
      rethrow;
    }
  }

  String getFileExtension(String fileName) {
    return fileName.split('.').last.toLowerCase();
  }

  DocumentType determineDocumentType(String fileName) {
    final extension = getFileExtension(fileName);
    switch (extension) {
      case 'pdf':
        return DocumentType.pdf;
      case 'doc':
      case 'docx':
        return DocumentType.word;
      case 'ppt':
      case 'pptx':
        return DocumentType.powerpoint;
      case 'xls':
      case 'xlsx':
        return DocumentType.excel;
      case 'jpg':
      case 'jpeg':
      case 'png':
        return DocumentType.image;
      default:
        return DocumentType.unknown;
    }
  }

  bool _isValidFileSize(html.File file) {
    final sizeInMb = file.size / (1024 * 1024);
    return sizeInMb <= maxFileSizeMb;
  }

  bool _isValidFileType(String fileName, List<String> allowedExtensions) {
    final extension = getFileExtension(fileName);
    return allowedExtensions.contains(extension.toLowerCase());
  }
}
