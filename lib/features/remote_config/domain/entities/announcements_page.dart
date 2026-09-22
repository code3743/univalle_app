import 'announcement.dart';

class AnnouncementsPage {
  final List<Announcement> items;
  final int page;
  final int limit;
  final int total;

  const AnnouncementsPage({
    required this.items,
    required this.page,
    required this.limit,
    required this.total,
  });

  bool get hasMore => page * limit < total;
}
