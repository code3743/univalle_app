abstract final class NameFormatter {
  static String firstName(String fullName) {
    final trimmed = fullName.trim();
    if (trimmed.isEmpty) return trimmed;
    final firstWord = trimmed.split(RegExp(r'\s+')).first;
    return '${firstWord[0].toUpperCase()}${firstWord.substring(1).toLowerCase()}';
  }
}
