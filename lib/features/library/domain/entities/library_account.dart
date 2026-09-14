import 'library_loan_record.dart';

class LibraryAccount {
  final String currentFine;
  final List<LibraryLoanRecord> currentLoans;
  final List<LibraryLoanRecord> history;

  const LibraryAccount({
    required this.currentFine,
    required this.currentLoans,
    required this.history,
  });
}
