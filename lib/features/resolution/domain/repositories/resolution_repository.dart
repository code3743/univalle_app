import '../../../../core/error/result.dart';
import '../entities/curriculum.dart';

abstract interface class ResolutionRepository {
  Future<Result<Curriculum>> getCurriculum({required String username});
}
