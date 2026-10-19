import '../../domain/entities/library_loan.dart';

class LibraryLoanModel {
  final String code;
  final String title;
  final String location;
  final String dueDate;
  final String fine;

  const LibraryLoanModel({
    required this.code,
    required this.title,
    required this.location,
    required this.dueDate,
    required this.fine,
  });

  LibraryLoan toEntity() => LibraryLoan(
    code: code,
    title: title,
    location: location,
    dueDate: dueDate,
    fine: fine,
  );
}
