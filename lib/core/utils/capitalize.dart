extension StringExtension on String {
  String capitalize() {
    return split(' ').map((e) {
      if (e.length < 3) return e.toLowerCase();
      return '${e[0].toUpperCase()}${e.substring(1).toLowerCase()}';
    }).join(' ');
  }
}
