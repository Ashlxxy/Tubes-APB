import 'song.dart';

class Playlist {
  final int id;
  final int userId;
  final String name;
  final List<Song> songs;

  Playlist({
    required this.id,
    required this.userId,
    required this.name,
    this.songs = const [],
  });

  factory Playlist.fromJson(Map<String, dynamic> json) {
    var songsList = json['songs'] as List? ?? [];
    List<Song> songs = songsList
        .map((item) => Song.fromJson(item as Map<String, dynamic>))
        .toList();

    return Playlist(
      id: json['id'] ?? 0,
      userId: json['user_id'] ?? 0,
      name: json['name'] ?? 'Untitled Playlist',
      songs: songs,
    );
  }

  Playlist copyWith({int? id, int? userId, String? name, List<Song>? songs}) {
    return Playlist(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      name: name ?? this.name,
      songs: songs ?? this.songs,
    );
  }
}
