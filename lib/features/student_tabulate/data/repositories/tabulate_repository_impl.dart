import '../../../../core/constants/sira_constants.dart';
import '../../../../core/error/exception_mapper.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/error/result.dart';
import '../../domain/entities/tabulate.dart';
import '../../domain/repositories/tabulate_repository.dart';
import '../datasources/sira_tabulate_remote_datasource.dart';

class TabulateRepositoryImpl implements TabulateRepository {
  final SiraTabulateRemoteDataSource _remote;
  const TabulateRepositoryImpl(this._remote);

  @override
  Future<Result<Tabulate>> getTabulate({required String username}) async {
    try {
      final html = await _remote.fetchTabulate(username: username);
      return Ok(
        Tabulate(html: html, baseUrl: Uri.parse(SiraConstants.baseUrl)),
      );
    } on AppException catch (e) {
      return Err(mapExceptionToFailure(e));
    }
  }
}
