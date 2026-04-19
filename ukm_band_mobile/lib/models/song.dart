class Song {
  final int id;
  final String title;
  final String artist;
  final String description;
  final String coverPath;
  final String filePath;
  final String? coverUrl;
  final String? audioUrl;
  final String? streamUrl;
  final int plays;
  final int likes;
  final bool isLiked;

  Song({
    required this.id,
    required this.title,
    required this.artist,
    required this.description,
    required this.coverPath,
    required this.filePath,
    this.coverUrl,
    this.audioUrl,
    this.streamUrl,
    required this.plays,
    required this.likes,
    this.isLiked = false,
  });

  factory Song.fromJson(Map<String, dynamic> json) {
    return Song(
      id: json['id'] ?? 0,
      title: json['title'] ?? 'Unknown',
      artist: json['artist'] ?? 'Unknown Artist',
      description: json['description'] ?? '',
      coverPath: json['cover_path'] ?? '',
      filePath: json['file_path'] ?? '',
      coverUrl: json['cover_url'],
      audioUrl: json['audio_url'],
      streamUrl: json['stream_url'],
      plays: json['plays'] ?? 0,
      likes: json['likes'] ?? 0,
      isLiked: json['is_liked'] ?? false,
    );
  }

  String get displayCover {
    if (coverUrl != null && coverUrl!.isNotEmpty) {
      return coverUrl!;
    }
    return coverPath;
  }

  String get playbackUrl {
    if (streamUrl != null && streamUrl!.isNotEmpty) {
      return streamUrl!;
    }
    if (audioUrl != null && audioUrl!.isNotEmpty) {
      return audioUrl!;
    }
    return filePath;
  }

  bool get isRemoteCover => displayCover.startsWith('http');

  Song copyWith({
    int? likes,
    bool? isLiked,
  }) {
    return Song(
      id: id,
      title: title,
      artist: artist,
      description: description,
      coverPath: coverPath,
      filePath: filePath,
      coverUrl: coverUrl,
      audioUrl: audioUrl,
      streamUrl: streamUrl,
      plays: plays,
      likes: likes ?? this.likes,
      isLiked: isLiked ?? this.isLiked,
    );
  }
}
