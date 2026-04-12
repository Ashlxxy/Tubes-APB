class Song {
  final int id;
  final String title;
  final String artist;
  final String description;
  final String coverPath;
  final String filePath;
  final int plays;
  final int likes;

  Song({
    required this.id,
    required this.title,
    required this.artist,
    required this.description,
    required this.coverPath,
    required this.filePath,
    required this.plays,
    required this.likes,
  });

  factory Song.fromJson(Map<String, dynamic> json) {
    return Song(
      id: json['id'] ?? 0,
      title: json['title'] ?? 'Unknown',
      artist: json['artist'] ?? 'Unknown Artist',
      description: json['description'] ?? '',
      coverPath: json['cover_path'] ?? '',
      filePath: json['file_path'] ?? '',
      plays: json['plays'] ?? 0,
      likes: json['likes'] ?? 0,
    );
  }

  // Helper method to get the full image URL assuming Laravel backend is at 10.0.2.2:8000
  String get coverUrl {
    if (coverPath.startsWith('http')) return coverPath;
    return 'http://10.0.2.2:8000/$coverPath';
  }

  String get audioUrl {
    if (filePath.startsWith('http')) return filePath;
    return 'http://10.0.2.2:8000/$filePath';
  }
}
