abstract final class NameFormatter {
  static String firstName(String fullName) {
    final trimmed = fullName.trim();
    if (trimmed.isEmpty) return trimmed;
    final firstWord = trimmed.split(RegExp(r'\s+')).first;
    return '${firstWord[0].toUpperCase()}${firstWord.substring(1).toLowerCase()}';
  }

  static String initial(String name, {String fallback = '?'}) {
    final trimmed = name.trim();
    return trimmed.isEmpty ? fallback : trimmed[0].toUpperCase();
  }
}
