import 'package:mocktail/mocktail.dart';
import 'package:univalle_app/features/remote_config/domain/entities/announcement.dart';
import 'package:univalle_app/features/remote_config/domain/entities/announcements_page.dart';
import 'package:univalle_app/features/remote_config/domain/repositories/remote_config_repository.dart';

class MockRemoteConfigRepository extends Mock
    implements RemoteConfigRepository {}

Announcement announcement(int id, {String? imageUrl}) => Announcement(
  id: id,
  title: 'Título $id',
  description: 'Descripción $id',
  imageUrl: imageUrl,
);

AnnouncementsPage announcementsPage(
  List<Announcement> items, {
  int page = 1,
  int limit = 10,
  int? total,
}) => AnnouncementsPage(
  items: items,
  page: page,
  limit: limit,
  total: total ?? items.length,
);
