import 'song.dart';

class HistoryEntry {
  final int id;
  final int userId;
  final int songId;
  final DateTime? playedAt;
  final Song? song;

  const HistoryEntry({
    required this.id,
    required this.userId,
    required this.songId,
    required this.playedAt,
    required this.song,
  });

  factory HistoryEntry.fromJson(Map<String, dynamic> json) {
    return HistoryEntry(
      id: json['id'] ?? 0,
      userId: json['user_id'] ?? 0,
      songId: json['song_id'] ?? 0,
      playedAt: json['played_at'] != null
          ? DateTime.tryParse(json['played_at'].toString())
          : null,
      song: json['song'] != null ? Song.fromJson(json['song']) : null,
    );
  }
}
