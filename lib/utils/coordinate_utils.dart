class CoordinateUtils {
  static List<double> normalizeCoordinates(
    double x1, double y1, 
    double x2, double y2,
    double containerWidth, 
    double containerHeight
  ) {
    return [
      (x1 / containerWidth) * 612,  // PDF points (72 DPI)
      (y1 / containerHeight) * 792,
      (x2 / containerWidth) * 612,
      (y2 / containerHeight) * 792
    ];
  }
}
