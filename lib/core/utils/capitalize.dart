extension StringExtension on String {
  String capitalize() {
    if (length < 3) return this;
    return split(' ')
        .map((e) => '${e.toUpperCase()}${e.substring(1).toLowerCase()}')
        .join(' ');
  }
}
