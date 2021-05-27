class Anime {
  Anime({
    required this.id,
    required this.title,
    this.alternativeTitles,
  });
  final int id;
  final String title;
  final List<String>? alternativeTitles;
}
