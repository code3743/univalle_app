import 'package:univalle_app/features/program_resolution/domain/datasource/resolution_datasource.dart';
import 'package:univalle_app/features/program_resolution/domain/entities/subject_cycle.dart';
import 'package:univalle_app/features/program_resolution/domain/repositories/resolution_repository.dart';

class SiraResolutionRepositoryImpl implements ResolutionRepository {
  final ResolutionDataSource _dataSource;

  SiraResolutionRepositoryImpl(this._dataSource);

  @override
  Future<List<SubjectCycle>> getResolution(
      String token, String studentId, String programId) {
    return _dataSource.getResolution(token, studentId, programId);
  }
}
