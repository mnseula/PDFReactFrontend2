class CoordinateUtils {
  static List<double> normalizeCoordinates(
    double x1,
    double y1,
    double x2,
    double y2,
    double containerWidth,
    double containerHeight,
  ) {
    // Convert screen coordinates to PDF points (1/72 inch)
    // This is a simplified version - you'll need to adjust based on your PDF viewer
    final normalizedX1 = (x1 / containerWidth) * 612; // Assuming standard letter size
    final normalizedY1 = (y1 / containerHeight) * 792;
    final normalizedX2 = (x2 / containerWidth) * 612;
    final normalizedY2 = (y2 / containerHeight) * 792;

    return [normalizedX1, normalizedY1, normalizedX2, normalizedY2];
  }
}
