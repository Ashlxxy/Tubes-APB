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
    List<Song> songs = songsList.map((i) => Song.fromJson(i)).toList();

    return Playlist(
      id: json['id'] ?? 0,
      userId: json['user_id'] ?? 0,
      name: json['name'] ?? 'Untitled Playlist',
      songs: songs,
    );
  }
}
