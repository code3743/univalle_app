import '../../domain/entities/announcement.dart';
import '../../domain/entities/announcements_page.dart';

class AnnouncementModel {
  final int id;
  final String title;
  final String description;
  final String? imageUrl;

  const AnnouncementModel({
    required this.id,
    required this.title,
    required this.description,
    this.imageUrl,
  });

  factory AnnouncementModel.fromJson(Map<String, dynamic> json) {
    return AnnouncementModel(
      id: json['id'] as int,
      title: json['title'] as String,
      description: json['description'] as String,
      imageUrl: json['imageUrl'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'description': description,
    'imageUrl': imageUrl,
  };

  Announcement toEntity() => Announcement(
    id: id,
    title: title,
    description: description,
    imageUrl: imageUrl,
  );
}

class AnnouncementsPageModel {
  final List<AnnouncementModel> items;
  final int page;
  final int limit;
  final int total;

  const AnnouncementsPageModel({
    required this.items,
    required this.page,
    required this.limit,
    required this.total,
  });

  factory AnnouncementsPageModel.fromJson(Map<String, dynamic> json) {
    return AnnouncementsPageModel(
      items: (json['items'] as List<dynamic>)
          .map(
            (item) => AnnouncementModel.fromJson(item as Map<String, dynamic>),
          )
          .toList(),
      page: json['page'] as int,
      limit: json['limit'] as int,
      total: json['total'] as int,
    );
  }

  AnnouncementsPage toEntity() => AnnouncementsPage(
    items: items.map((item) => item.toEntity()).toList(),
    page: page,
    limit: limit,
    total: total,
  );
}
