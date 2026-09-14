import 'package:flutter_test/flutter_test.dart';
import 'package:univalle_app/features/library/data/models/library_account_model.dart';
import 'package:univalle_app/features/library/data/models/library_loan_record_model.dart';

void main() {
  test('toEntity maps every field, including nested loan records', () {
    const model = LibraryAccountModel(
      currentFine: r'$5.000',
      currentLoans: [
        LibraryLoanRecordModel(
          code: '1',
          title: 'Clean Code',
          location: 'Sala general',
          date: '05/03/2026',
        ),
      ],
      history: [],
    );

    final entity = model.toEntity();

    expect(entity.currentFine, r'$5.000');
    expect(entity.currentLoans, hasLength(1));
    expect(entity.currentLoans.single.title, 'Clean Code');
    expect(entity.history, isEmpty);
  });
}
