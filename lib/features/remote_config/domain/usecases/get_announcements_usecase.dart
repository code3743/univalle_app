import '../../../../core/error/result.dart';
import '../entities/announcements_page.dart';
import '../repositories/remote_config_repository.dart';

class GetAnnouncementsUseCase {
  final RemoteConfigRepository _repository;
  const GetAnnouncementsUseCase(this._repository);

  Future<Result<AnnouncementsPage>> call({required int page}) =>
      _repository.getAnnouncements(page: page);
}
