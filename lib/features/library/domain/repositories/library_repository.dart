import '../../../../core/error/result.dart';
import '../entities/library_account.dart';

abstract interface class LibraryRepository {
  Future<Result<LibraryAccount>> getAccount();
}
