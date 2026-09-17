class NewsArticle {
  final String title;
  final String summary;
  final String sourceUrl;
  final String? imageUrl;
  final String? category;

  const NewsArticle({
    required this.title,
    required this.summary,
    required this.sourceUrl,
    this.imageUrl,
    this.category,
  });
}
