class SongComment {
  final int id;
  final int userId;
  final int songId;
  final int? parentId;
  final String userName;
  final String content;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final List<SongComment> replies;

  const SongComment({
    required this.id,
    required this.userId,
    required this.songId,
    required this.parentId,
    required this.userName,
    required this.content,
    required this.createdAt,
    required this.updatedAt,
    this.replies = const [],
  });

  factory SongComment.fromJson(Map<String, dynamic> json) {
    final rawReplies = json['replies'] as List<dynamic>? ?? [];

    return SongComment(
      id: json['id'] ?? 0,
      userId: json['user_id'] ?? 0,
      songId: json['song_id'] ?? 0,
      parentId: json['parent_id'],
      userName: json['user_name']?.toString().trim().isNotEmpty == true
          ? json['user_name'].toString()
          : 'Anggota UKM',
      content: json['content']?.toString() ?? '',
      createdAt: json['created_at'] != null
          ? DateTime.tryParse(json['created_at'].toString())
          : null,
      updatedAt: json['updated_at'] != null
          ? DateTime.tryParse(json['updated_at'].toString())
          : null,
      replies: rawReplies
          .map((item) => SongComment.fromJson(item as Map<String, dynamic>))
          .toList(),
    );
  }
}
