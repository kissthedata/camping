class DisplayUtil {
  static double getLetterSpacing({required px, required double percent}) {
    return px * (percent / 100);
  }
}
