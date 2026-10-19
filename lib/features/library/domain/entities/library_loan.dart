class LibraryLoan {
  final String code;
  final String title;
  final String location;
  final String dueDate;
  final String fine;

  const LibraryLoan({
    required this.code,
    required this.title,
    required this.location,
    required this.dueDate,
    required this.fine,
  });

  bool get hasFine => (double.tryParse(fine) ?? 0) > 0;

  LibraryLoan copyWith({String? dueDate}) => LibraryLoan(
    code: code,
    title: title,
    location: location,
    dueDate: dueDate ?? this.dueDate,
    fine: fine,
  );
}
