import '../../domain/entities/welcome_banner.dart';

class WelcomeBannerModel {
  final bool enabled;
  final String title;
  final String description;
  final String? imageUrl;
  final String? linkUrl;

  const WelcomeBannerModel({
    required this.enabled,
    required this.title,
    required this.description,
    this.imageUrl,
    this.linkUrl,
  });

  factory WelcomeBannerModel.fromJson(Map<String, dynamic> json) {
    return WelcomeBannerModel(
      enabled: json['enabled'] as bool,
      title: json['title'] as String,
      description: json['description'] as String,
      imageUrl: json['imageUrl'] as String?,
      linkUrl: json['linkUrl'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
    'enabled': enabled,
    'title': title,
    'description': description,
    'imageUrl': imageUrl,
    'linkUrl': linkUrl,
  };

  WelcomeBanner toEntity() => WelcomeBanner(
    enabled: enabled,
    title: title,
    description: description,
    imageUrl: imageUrl,
    linkUrl: linkUrl,
  );
}
