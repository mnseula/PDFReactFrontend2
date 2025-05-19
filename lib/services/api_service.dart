import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:path/path.dart' as path;
import '../config/api_config.dart';
import '../models/document_model.dart';
import '../models/processing_options.dart';

class ApiService {
  final String baseUrl;
  final http.Client client;

  ApiService({required this.client, this.baseUrl = ApiConfig.baseUrl});

  Future<Document> uploadFile(File file) async {
    final uri = Uri.parse('$baseUrl/upload');
    final request = http.MultipartRequest('POST', uri);
    final fileStream = http.ByteStream(file.openRead());
    final fileLength = await file.length();

    final multipartFile = http.MultipartFile(
      'file',
      fileStream,
      fileLength,
      filename: path.basename(file.path),
    );

    request.files.add(multipartFile);

    final response = await request.send();
    final responseString = await response.stream.bytesToString();

    if (response.statusCode == 200) {
      return Document.fromJson(json.decode(responseString));
    } else {
      throw Exception('Failed to upload file: ${response.statusCode}');
    }
  }

  Future<Document> processDocument(
    String documentId,
    ProcessingOptions options,
  ) async {
    final uri = Uri.parse('$baseUrl/process/$documentId');
    final response = await client.post(
      uri,
      headers: {'Content-Type': 'application/json'},
      body: json.encode(options.toJson()),
    );

    if (response.statusCode == 200) {
      return Document.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to process document: ${response.statusCode}');
    }
  }

  Future<Document> convertDocument(
    String documentId,
    String targetFormat,
  ) async {
    String endpoint;
    switch (targetFormat.toLowerCase()) {
      case 'word':
        endpoint = ApiConfig.pdfToWord;
        break;
      case 'powerpoint':
        endpoint = ApiConfig.pdfToPowerpoint;
        break;
      case 'excel':
        endpoint = ApiConfig.pdfToExcel;
        break;
      case 'pdf':
        // Check original format to determine conversion endpoint
        // This would require additional logic to determine original format
        endpoint = ApiConfig.wordToPdf; // Default, should be adjusted
        break;
      case 'jpg':
        endpoint = ApiConfig.pdfToJpg;
        break;
      default:
        throw Exception('Unsupported target format: $targetFormat');
    }

    final uri = Uri.parse('$baseUrl$endpoint');
    final response = await client.post(
      uri,
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'documentId': documentId}),
    );

    if (response.statusCode == 200) {
      return Document.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to convert document: ${response.statusCode}');
    }
  }

  Future<String> downloadDocument(String documentId) async {
    final uri = Uri.parse('$baseUrl/download/$documentId');
    final response = await client.get(uri);

    if (response.statusCode == 200) {
      return response.body;
    } else {
      throw Exception('Failed to download document: ${response.statusCode}');
    }
  }
}
