import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:path/path.dart' as path;
import 'package:document_processor/config/api_config.dart';
import 'package:document_processor/models/document_model.dart';
import 'package:document_processor/models/processing_options.dart';

class ApiService {
  final String baseUrl;
  final http.Client client;
  final Duration timeout;

  ApiService({
    required this.client, 
    this.baseUrl = ApiConfig.baseUrl,
    this.timeout = const Duration(seconds: 30),
  });

  Future<Document> uploadFile(File file) async {
    try {
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

      final streamedResponse = await request.send().timeout(timeout);
      final response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 200) {
        return Document.fromJson(json.decode(response.body));
      } else {
        throw HttpException('Upload failed with status: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('File upload failed: $e');
    }
  }

  Future<Document> processDocument(
    String documentId,
    ProcessingOptions options,
  ) async {
    try {
      final uri = Uri.parse('$baseUrl/process/$documentId');
      final response = await client.post(
        uri,
        headers: {'Content-Type': 'application/json'},
        body: json.encode(options.toJson()),
      ).timeout(timeout);

      if (response.statusCode == 200) {
        return Document.fromJson(json.decode(response.body));
      } else {
        throw HttpException('Processing failed with status: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Document processing failed: $e');
    }
  }

  Future<Document> convertDocument(
    String documentId,
    String targetFormat,
  ) async {
    try {
      final endpoint = _getConversionEndpoint(targetFormat);
      final uri = Uri.parse('$baseUrl$endpoint/$documentId');
      
      final response = await client.post(
        uri,
        headers: {'Content-Type': 'application/json'},
      ).timeout(timeout);

      if (response.statusCode == 200) {
        return Document.fromJson(json.decode(response.body));
      } else {
        throw HttpException('Conversion failed with status: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Document conversion failed: $e');
    }
  }

  String _getConversionEndpoint(String targetFormat) {
    switch (targetFormat.toLowerCase()) {
      case 'word':
        return ApiConfig.pdfToWord;
      case 'powerpoint':
        return ApiConfig.pdfToPowerpoint;
      case 'excel':
        return ApiConfig.pdfToExcel;
      case 'jpg':
        return ApiConfig.pdfToJpg;
      default:
        throw ArgumentError('Unsupported conversion format: $targetFormat');
    }
  }

  void dispose() {
    client.close();
  }
}
