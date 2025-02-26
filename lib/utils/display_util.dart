class DisplayUtil {
  static double getLetterSpacing({required px, required percent}) {
    return px * (percent / 100);
  }
}
