class SiraException implements Exception {
  final String message;
  final String? code;

  SiraException(this.message, {this.code});

  @override
  String toString() {
    return message;
  }
}
