import '../../domain/entities/library_loan_record.dart';

class LibraryLoanRecordModel {
  final String code;
  final String title;
  final String location;
  final String date;

  const LibraryLoanRecordModel({
    required this.code,
    required this.title,
    required this.location,
    required this.date,
  });

  LibraryLoanRecord toEntity() => LibraryLoanRecord(
    code: code,
    title: title,
    location: location,
    date: date,
  );
}
