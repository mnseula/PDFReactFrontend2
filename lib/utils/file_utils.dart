import 'package:flutter/material.dart';
import 'dart:html' as html;

String formatFileSize(int bytes) {
  if (bytes <= 0) return "0 B";
  const suffixes = ["B", "KB", "MB", "GB", "TB"];
  final i = (log(bytes) / log(1024)).floor();
  return "${(bytes / pow(1024, i)).toStringAsFixed(2)} ${suffixes[i]}";
}

Future<html.File?> pickFile(List<String> allowedExtensions) async {
  final input = html.FileUploadInputElement()
    ..accept = allowedExtensions.join(',');
  input.click();

  await input.onChange.first;
  if (input.files!.isEmpty) return null;
  return input.files!.first;
}
