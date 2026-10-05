import 'library_loan.dart';
import 'library_loan_record.dart';

class LibraryAccount {
  final String currentFine;
  final List<LibraryLoan> currentLoans;
  final List<LibraryLoanRecord> history;

  const LibraryAccount({
    required this.currentFine,
    required this.currentLoans,
    required this.history,
  });
}
