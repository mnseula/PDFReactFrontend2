import 'dart:html' as html;
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:universal_html/html.dart' as universal_html;
import '../models/document_model.dart';

class FileService {
  Future<html.File?> pickFile(List<String> allowedExtensions) async {
    final input = html.FileUploadInputElement()
      ..accept = allowedExtensions.join(',');
    input.click();

    await input.onChange.first;
    if (input.files!.isEmpty) return null;
    return input.files!.first;
  }

  Future<Uint8List> readFile(html.File file) async {
    final reader = html.FileReader();
    reader.readAsArrayBuffer(file);
    await reader.onLoad.first;
    return reader.result as Uint8List;
  }

  void downloadFile(Uint8List bytes, String fileName) {
    final blob = html.Blob([bytes]);
    final url = html.Url.createObjectUrlFromBlob(blob);
    final anchor = html.AnchorElement(href: url)
      ..target = 'blank'
      ..download = fileName
      ..click();
    html.Url.revokeObjectUrl(url);
  }

  void viewFileInNewTab(Uint8List bytes, String fileName) {
    final blob = html.Blob([bytes]);
    final url = html.Url.createObjectUrlFromBlob(blob);
    universal_html.window.open(url, '_blank');
    // Note: We can't revoke the URL immediately as it's used in a new tab
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
        return DocumentType.other;
    }
  }
}
