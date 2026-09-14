import '../../domain/entities/library_account.dart';
import 'library_loan_record_model.dart';

class LibraryAccountModel {
  final String currentFine;
  final List<LibraryLoanRecordModel> currentLoans;
  final List<LibraryLoanRecordModel> history;

  const LibraryAccountModel({
    required this.currentFine,
    required this.currentLoans,
    required this.history,
  });

  LibraryAccount toEntity() => LibraryAccount(
    currentFine: currentFine,
    currentLoans: currentLoans.map((record) => record.toEntity()).toList(),
    history: history.map((record) => record.toEntity()).toList(),
  );
}
