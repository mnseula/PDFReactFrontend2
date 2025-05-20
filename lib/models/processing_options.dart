class ProcessingOptions {
  final String operation;
  final Map<String, dynamic> parameters;

  ProcessingOptions({
    required this.operation,
    required this.parameters,
  });
}

class RectangleArea {
  final double x1, y1, x2, y2;
  final int? pageNumber;
  
  RectangleArea({
    required this.x1,
    required this.y1,
    required this.x2,
    required this.y2,
    this.pageNumber,
  });
}
