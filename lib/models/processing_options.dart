class ProcessingOptions {
  final String operation;
  final Map<String, dynamic> parameters;

  ProcessingOptions({
    required this.operation,
    required this.parameters,
  });

  Map<String, dynamic> toJson() {
    return {
      'operation': operation,
      'parameters': parameters,
    };
  }
}

class PdfRedactOptions {
  final List<RectangleArea> areas;
  final String? overlayText;
  final String? color;

  PdfRedactOptions({
    required this.areas,
    this.overlayText,
    this.color,
  });

  Map<String, dynamic> toJson() {
    return {
      'areas': areas.map((area) => area.toJson()).toList(),
      'overlayText': overlayText,
      'color': color,
    };
  }
}

class RectangleArea {
  final double x1;
  final double y1;
  final double x2;
  final double y2;
  final int? pageNumber;

  RectangleArea({
    required this.x1,
    required this.y1,
    required this.x2,
    required this.y2,
    this.pageNumber,
  });

  Map<String, dynamic> toJson() {
    return {
      'x1': x1,
      'y1': y1,
      'x2': x2,
      'y2': y2,
      'pageNumber': pageNumber,
    };
  }
}

class WatermarkOptions {
  final String text;
  final double opacity;
  final double fontSize;
  final double angle;
  final String? color;
  final int? pageNumber;

  WatermarkOptions({
    required this.text,
    required this.opacity,
    required this.fontSize,
    required this.angle,
    this.color,
    this.pageNumber,
  });

  Map<String, dynamic> toJson() {
    return {
      'text': text,
      'opacity': opacity,
      'fontSize': fontSize,
      'angle': angle,
      'color': color,
      'pageNumber': pageNumber,
    };
  }
}

class AnnotationOptions {
  final AnnotationType type;
  final RectangleArea area;
  final String? text;
  final String? color;
  final int? pageNumber;
  final String? signatureImage; // base64 encoded image for signature

  AnnotationOptions({
    required this.type,
    required this.area,
    this.text,
    this.color,
    this.pageNumber,
    this.signatureImage,
  });

  Map<String, dynamic> toJson() {
    return {
      'type': type.toString().split('.').last,
      'area': area.toJson(),
      'text': text,
      'color': color,
      'pageNumber': pageNumber,
      'signatureImage': signatureImage,
    };
  }
}

enum AnnotationType {
  highlight,
  text,
  redact,
  signature,
}
