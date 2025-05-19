class ApiConfig {
  static const String baseUrl = 'https://ftp.mikkul.com';
  
  // PDF Modification
  static const String compressPdf = '/pdf/compress';
  static const String cropPdf = '/pdf/crop';
  static const String redactPdf = '/pdf/redact';
  static const String watermarkPdf = '/pdf/watermark';
  static const String annotatePdf = '/pdf/annotate';
  static const String editPdf = '/pdf/edit';
  static const String ocrPdf = '/pdf/ocr';
  
  // PDF Conversion to Office
  static const String pdfToWord = '/pdf/to-word';
  static const String pdfToPowerpoint = '/pdf/to-powerpoint';
  static const String pdfToExcel = '/pdf/to-excel';
  
  // Office Conversion to PDF
  static const String wordToPdf = '/word/to-pdf';
  static const String powerpointToPdf = '/powerpoint/to-pdf';
  static const String excelToPdf = '/excel/to-pdf';
  
  // Image & PDF Conversion
  static const String imageToPdf = '/image/to-pdf';
  static const String pdfToJpg = '/pdf/to-jpg';
  
  // PDF Utility
  static const String readPdf = '/pdf/read';
}
