class Announcement {
  final int id;
  final String title;
  final String description;
  final String? imageUrl;

  const Announcement({
    required this.id,
    required this.title,
    required this.description,
    this.imageUrl,
  });
}
