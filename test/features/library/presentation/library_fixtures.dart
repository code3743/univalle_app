import 'package:mocktail/mocktail.dart';
import 'package:univalle_app/features/library/domain/entities/library_account.dart';
import 'package:univalle_app/features/library/domain/entities/library_loan.dart';
import 'package:univalle_app/features/library/domain/entities/library_loan_record.dart';
import 'package:univalle_app/features/library/domain/repositories/library_repository.dart';

class MockLibraryRepository extends Mock implements LibraryRepository {}

LibraryLoan loan({
  String code = 'B1',
  String title = 'Cálculo de una variable',
  String fine = '0',
  String dueDate = '2026-03-01',
}) => LibraryLoan(
  code: code,
  title: title,
  location: 'Sala general',
  dueDate: dueDate,
  fine: fine,
);

const record = LibraryLoanRecord(
  code: 'H1',
  title: 'Álgebra lineal',
  location: 'Sala general',
  date: '2025-10-10',
);

LibraryAccount account({
  String currentFine = r'$0',
  List<LibraryLoan>? loans,
  List<LibraryLoanRecord> history = const [],
}) => LibraryAccount(
  currentFine: currentFine,
  currentLoans: loans ?? [loan()],
  history: history,
);
