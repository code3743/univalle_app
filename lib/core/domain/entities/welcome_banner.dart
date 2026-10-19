class WelcomeBanner {
  final bool enabled;
  final String title;
  final String description;
  final String? imageUrl;
  final String? linkUrl;

  const WelcomeBanner({
    required this.enabled,
    required this.title,
    required this.description,
    this.imageUrl,
    this.linkUrl,
  });
}
