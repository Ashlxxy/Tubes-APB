import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/playlist.dart';
import '../models/song.dart';
import '../models/song_comment.dart';
import '../providers/audio_provider.dart';
import '../providers/auth_provider.dart';
import '../providers/music_provider.dart';
import '../services/api_service.dart';
import '../theme/app_theme.dart';
import '../widgets/song_artwork.dart';

class SongDetailScreen extends StatefulWidget {
  final Song song;
  final List<Song> queue;

  const SongDetailScreen({
    super.key,
    required this.song,
    this.queue = const [],
  });

  @override
  State<SongDetailScreen> createState() => _SongDetailScreenState();
}

class _SongDetailScreenState extends State<SongDetailScreen> {
  final _commentController = TextEditingController();
  final _commentFocus = FocusNode();
  late Future<List<SongComment>> _commentsFuture;
  int? _replyTo;
  String? _replyToName;
  bool _isPosting = false;

  @override
  void initState() {
    super.initState();
    _commentsFuture = _loadComments();
  }

  @override
  void dispose() {
    _commentController.dispose();
    _commentFocus.dispose();
    super.dispose();
  }

  Future<List<SongComment>> _loadComments() {
    return context.read<ApiService>().fetchComments(widget.song.id);
  }

  Song _currentSong(MusicProvider music) {
    for (final song in music.songs) {
      if (song.id == widget.song.id) {
        return song;
      }
    }
    return widget.song;
  }

  Future<void> _play(Song song, List<Song> queue) async {
    final api = context.read<ApiService>();
    final audio = context.read<AudioProvider>();

    try {
      await api.recordPlay(song.id);
    } catch (_) {
      // Playback must not depend on analytics/history tracking.
    }

    if (!mounted) {
      return;
    }

    await audio.playSong(song, queue: queue.isEmpty ? [song] : queue);
  }

  Future<void> _toggleLike(Song song) async {
    try {
      await context.read<MusicProvider>().toggleLike(song);
    } catch (error) {
      if (!mounted) {
        return;
      }
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Gagal memperbarui like: $error')));
    }
  }

  Future<void> _postComment() async {
    final content = _commentController.text.trim();
    if (content.isEmpty || _isPosting) {
      return;
    }

    setState(() => _isPosting = true);

    try {
      await context.read<ApiService>().storeComment(
        songId: widget.song.id,
        content: content,
        parentId: _replyTo,
      );
      _commentController.clear();
      _replyTo = null;
      _replyToName = null;
      _commentsFuture = _loadComments();
      if (!mounted) {
        return;
      }
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Komentar terkirim.')));
    } catch (error) {
      if (!mounted) {
        return;
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal mengirim komentar: $error')),
      );
    } finally {
      if (mounted) {
        setState(() => _isPosting = false);
      }
    }
  }

  Future<void> _deleteComment(SongComment comment) async {
    try {
      await context.read<ApiService>().deleteComment(comment.id);
      setState(() {
        _commentsFuture = _loadComments();
      });
    } catch (error) {
      if (!mounted) {
        return;
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal menghapus komentar: $error')),
      );
    }
  }

  void _reply(SongComment comment) {
    setState(() {
      _replyTo = comment.id;
      _replyToName = comment.userName;
    });
    _commentFocus.requestFocus();
  }

  void _cancelReply() {
    setState(() {
      _replyTo = null;
      _replyToName = null;
    });
  }

  Future<void> _showPlaylistSheet(Song song) async {
    final nameController = TextEditingController();
    final musicProvider = context.read<MusicProvider>();
    var busyPlaylistId = 0;
    var isCreating = false;

    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (sheetContext) {
        return StatefulBuilder(
          builder: (context, setSheetState) {
            final music = context.watch<MusicProvider>();
            final bottomInset = MediaQuery.of(context).viewInsets.bottom;

            Future<void> toggle(Playlist playlist) async {
              if (busyPlaylistId != 0 || isCreating) {
                return;
              }

              setSheetState(() => busyPlaylistId = playlist.id);
              try {
                await musicProvider.toggleSongInPlaylist(playlist, song);
              } catch (error) {
                if (mounted) {
                  ScaffoldMessenger.of(this.context).showSnackBar(
                    SnackBar(content: Text('Gagal mengubah playlist: $error')),
                  );
                }
              } finally {
                if (sheetContext.mounted) {
                  setSheetState(() => busyPlaylistId = 0);
                }
              }
            }

            Future<void> create() async {
              final name = nameController.text.trim();
              if (name.isEmpty) {
                return;
              }

              setSheetState(() => isCreating = true);
              try {
                await musicProvider.createPlaylist(name, seedSong: song);
                nameController.clear();
              } catch (error) {
                if (mounted) {
                  ScaffoldMessenger.of(this.context).showSnackBar(
                    SnackBar(content: Text('Gagal membuat playlist: $error')),
                  );
                }
              } finally {
                if (sheetContext.mounted) {
                  setSheetState(() => isCreating = false);
                }
              }
            }

            return Padding(
              padding: EdgeInsets.only(bottom: bottomInset),
              child: Container(
                constraints: BoxConstraints(
                  maxHeight: MediaQuery.of(context).size.height * 0.84,
                ),
                padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
                decoration: const BoxDecoration(
                  color: AppColors.stage,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Container(
                        width: 44,
                        height: 4,
                        decoration: BoxDecoration(
                          color: AppColors.line,
                          borderRadius: BorderRadius.circular(999),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      'Tambahkan ke Playlist',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      song.title,
                      style: const TextStyle(color: AppColors.muted),
                    ),
                    const SizedBox(height: 18),
                    Flexible(
                      child: music.playlists.isEmpty
                          ? const Center(
                              child: Padding(
                                padding: EdgeInsets.symmetric(vertical: 28),
                                child: Text(
                                  'Belum ada playlist. Buat playlist pertama untuk menyimpan lagu ini.',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(color: AppColors.muted),
                                ),
                              ),
                            )
                          : ListView.separated(
                              shrinkWrap: true,
                              itemCount: music.playlists.length,
                              separatorBuilder: (context, index) =>
                                  const SizedBox(height: 10),
                              itemBuilder: (context, index) {
                                final playlist = music.playlists[index];
                                final inPlaylist = music.playlistContainsSong(
                                  playlist,
                                  song,
                                );
                                final busy = busyPlaylistId == playlist.id;

                                return AppGlassCard(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 14,
                                    vertical: 12,
                                  ),
                                  onTap: busy ? null : () => toggle(playlist),
                                  child: Row(
                                    children: [
                                      Container(
                                        width: 46,
                                        height: 46,
                                        decoration: BoxDecoration(
                                          color: AppColors.cardSoft,
                                          borderRadius: BorderRadius.circular(
                                            14,
                                          ),
                                        ),
                                        child: Icon(
                                          inPlaylist
                                              ? Icons.check_rounded
                                              : Icons.playlist_add_rounded,
                                          color: inPlaylist
                                              ? AppColors.success
                                              : AppColors.accentHot,
                                        ),
                                      ),
                                      const SizedBox(width: 12),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              playlist.name,
                                              style: const TextStyle(
                                                fontWeight: FontWeight.w800,
                                              ),
                                            ),
                                            Text(
                                              '${playlist.songs.length} lagu',
                                              style: const TextStyle(
                                                color: AppColors.muted,
                                                fontSize: 12,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      if (busy)
                                        const SizedBox(
                                          width: 20,
                                          height: 20,
                                          child: CircularProgressIndicator(
                                            strokeWidth: 2,
                                          ),
                                        )
                                      else
                                        Text(
                                          inPlaylist ? 'Sudah ada' : 'Tambah',
                                          style: TextStyle(
                                            color: inPlaylist
                                                ? AppColors.success
                                                : AppColors.accentHot,
                                            fontWeight: FontWeight.w800,
                                          ),
                                        ),
                                    ],
                                  ),
                                );
                              },
                            ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: nameController,
                            textInputAction: TextInputAction.done,
                            onSubmitted: (_) => create(),
                            decoration: const InputDecoration(
                              hintText: 'Nama playlist baru',
                              prefixIcon: Icon(Icons.queue_music_rounded),
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        FilledButton(
                          onPressed: isCreating ? null : create,
                          child: isCreating
                              ? const SizedBox(
                                  width: 18,
                                  height: 18,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                  ),
                                )
                              : const Icon(Icons.add_rounded),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );

    await Future<void>.delayed(const Duration(milliseconds: 350));
    nameController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer2<MusicProvider, AudioProvider>(
      builder: (context, music, audio, _) {
        final song = _currentSong(music);
        final queue = widget.queue.isEmpty ? music.songs : widget.queue;
        final isCurrent = audio.currentSong?.id == song.id;

        return Scaffold(
          backgroundColor: AppColors.ink,
          body: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF4A0E17), AppColors.ink],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: SafeArea(
              child: CustomScrollView(
                physics: const BouncingScrollPhysics(),
                slivers: [
                  SliverAppBar(
                    pinned: true,
                    backgroundColor: Colors.transparent,
                    title: const Text('Detail Lagu'),
                    actions: [
                      IconButton(
                        tooltip: 'Playlist',
                        onPressed: () => _showPlaylistSheet(song),
                        icon: const Icon(Icons.playlist_add_rounded),
                      ),
                    ],
                  ),
                  SliverPadding(
                    padding: const EdgeInsets.fromLTRB(20, 12, 20, 120),
                    sliver: SliverList(
                      delegate: SliverChildListDelegate([
                        SongArtwork(
                          source: song.displayCover,
                          size: MediaQuery.of(context).size.width - 40,
                          borderRadius: BorderRadius.circular(34),
                        ),
                        const SizedBox(height: 24),
                        Text(
                          song.title,
                          style: Theme.of(context).textTheme.headlineMedium
                              ?.copyWith(
                                fontWeight: FontWeight.w900,
                                height: 1.05,
                              ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          song.artist,
                          style: const TextStyle(
                            color: AppColors.accentHot,
                            fontWeight: FontWeight.w800,
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(height: 18),
                        Row(
                          children: [
                            _MetricChip(
                              icon: Icons.play_arrow_rounded,
                              label: '${song.plays} plays',
                            ),
                            const SizedBox(width: 10),
                            _MetricChip(
                              icon: song.isLiked
                                  ? Icons.favorite_rounded
                                  : Icons.favorite_border_rounded,
                              label: '${song.likes} likes',
                              active: song.isLiked,
                            ),
                          ],
                        ),
                        const SizedBox(height: 22),
                        Row(
                          children: [
                            Expanded(
                              child: FilledButton.icon(
                                onPressed: () => _play(song, queue),
                                icon: Icon(
                                  isCurrent && audio.isPlaying
                                      ? Icons.pause_rounded
                                      : Icons.play_arrow_rounded,
                                ),
                                label: Text(
                                  isCurrent && audio.isPlaying
                                      ? 'Sedang Diputar'
                                      : 'Putar Sekarang',
                                ),
                              ),
                            ),
                            const SizedBox(width: 10),
                            _RoundActionButton(
                              label: song.isLiked ? 'Unlike' : 'Like',
                              icon: song.isLiked
                                  ? Icons.favorite_rounded
                                  : Icons.favorite_border_rounded,
                              active: song.isLiked,
                              onTap: () => _toggleLike(song),
                            ),
                            const SizedBox(width: 10),
                            _RoundActionButton(
                              label: 'Playlist',
                              icon: Icons.playlist_add_rounded,
                              onTap: () => _showPlaylistSheet(song),
                            ),
                          ],
                        ),
                        if (audio.playbackError != null && isCurrent) ...[
                          const SizedBox(height: 12),
                          Text(
                            audio.playbackError!,
                            style: const TextStyle(color: AppColors.accentHot),
                          ),
                        ],
                        const SizedBox(height: 26),
                        AppGlassCard(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Deskripsi Lagu',
                                style: TextStyle(
                                  fontWeight: FontWeight.w900,
                                  fontSize: 18,
                                ),
                              ),
                              const SizedBox(height: 10),
                              Text(
                                song.description.isEmpty
                                    ? 'Belum ada deskripsi untuk lagu ini.'
                                    : song.description,
                                style: const TextStyle(
                                  color: AppColors.muted,
                                  height: 1.55,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 28),
                        Text(
                          'Komentar',
                          style: Theme.of(context).textTheme.titleLarge
                              ?.copyWith(fontWeight: FontWeight.w900),
                        ),
                        const SizedBox(height: 12),
                        _CommentComposer(
                          controller: _commentController,
                          focusNode: _commentFocus,
                          replyToName: _replyToName,
                          isPosting: _isPosting,
                          onCancelReply: _cancelReply,
                          onSubmit: _postComment,
                        ),
                        const SizedBox(height: 18),
                        FutureBuilder<List<SongComment>>(
                          future: _commentsFuture,
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return const Padding(
                                padding: EdgeInsets.symmetric(vertical: 28),
                                child: Center(
                                  child: CircularProgressIndicator(),
                                ),
                              );
                            }

                            if (snapshot.hasError) {
                              return AppGlassCard(
                                child: Column(
                                  children: [
                                    const Icon(
                                      Icons.error_outline_rounded,
                                      color: AppColors.accentHot,
                                    ),
                                    const SizedBox(height: 10),
                                    Text(
                                      snapshot.error.toString(),
                                      textAlign: TextAlign.center,
                                    ),
                                    const SizedBox(height: 12),
                                    OutlinedButton(
                                      onPressed: () {
                                        setState(() {
                                          _commentsFuture = _loadComments();
                                        });
                                      },
                                      child: const Text('Muat ulang'),
                                    ),
                                  ],
                                ),
                              );
                            }

                            final comments = snapshot.data ?? [];
                            if (comments.isEmpty) {
                              return const AppGlassCard(
                                child: Text(
                                  'Belum ada komentar. Jadilah yang pertama.',
                                  style: TextStyle(color: AppColors.muted),
                                ),
                              );
                            }

                            final user = context.watch<AuthProvider>().user;
                            return Column(
                              children: comments
                                  .map(
                                    (comment) => Padding(
                                      padding: const EdgeInsets.only(
                                        bottom: 12.0,
                                      ),
                                      child: _CommentCard(
                                        comment: comment,
                                        currentUserId: user?.id,
                                        isAdmin: user?.role == 'admin',
                                        onReply: _reply,
                                        onDelete: _deleteComment,
                                      ),
                                    ),
                                  )
                                  .toList(),
                            );
                          },
                        ),
                      ]),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class _MetricChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool active;

  const _MetricChip({
    required this.icon,
    required this.label,
    this.active = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: active
            ? AppColors.accent.withValues(alpha: 0.18)
            : AppColors.card.withValues(alpha: 0.78),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(
          color: active ? AppColors.accentHot : AppColors.line,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 17,
            color: active ? AppColors.accentHot : AppColors.muted,
          ),
          const SizedBox(width: 6),
          Text(
            label,
            style: TextStyle(
              color: active ? AppColors.cream : AppColors.muted,
              fontWeight: FontWeight.w700,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}

class _RoundActionButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final VoidCallback onTap;
  final bool active;

  const _RoundActionButton({
    required this.label,
    required this.icon,
    required this.onTap,
    this.active = false,
  });

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: label,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(18),
        child: Container(
          width: 52,
          height: 52,
          decoration: BoxDecoration(
            color: active ? AppColors.accent : AppColors.card,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(
              color: active ? AppColors.accentHot : AppColors.line,
            ),
          ),
          child: Icon(icon, color: active ? Colors.white : AppColors.cream),
        ),
      ),
    );
  }
}

class _CommentComposer extends StatelessWidget {
  final TextEditingController controller;
  final FocusNode focusNode;
  final String? replyToName;
  final bool isPosting;
  final VoidCallback onCancelReply;
  final VoidCallback onSubmit;

  const _CommentComposer({
    required this.controller,
    required this.focusNode,
    required this.replyToName,
    required this.isPosting,
    required this.onCancelReply,
    required this.onSubmit,
  });

  @override
  Widget build(BuildContext context) {
    return AppGlassCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (replyToName != null) ...[
            Row(
              children: [
                Expanded(
                  child: Text(
                    'Membalas $replyToName',
                    style: const TextStyle(
                      color: AppColors.accentHot,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
                TextButton(
                  onPressed: onCancelReply,
                  child: const Text('Batal'),
                ),
              ],
            ),
            const SizedBox(height: 8),
          ],
          TextField(
            controller: controller,
            focusNode: focusNode,
            minLines: 1,
            maxLines: 4,
            textInputAction: TextInputAction.newline,
            decoration: const InputDecoration(
              hintText: 'Tulis komentar...',
              prefixIcon: Icon(Icons.mode_comment_outlined),
            ),
          ),
          const SizedBox(height: 12),
          Align(
            alignment: Alignment.centerRight,
            child: FilledButton.icon(
              onPressed: isPosting ? null : onSubmit,
              icon: isPosting
                  ? const SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Icon(Icons.send_rounded),
              label: Text(isPosting ? 'Mengirim...' : 'Kirim'),
            ),
          ),
        ],
      ),
    );
  }
}

class _CommentCard extends StatelessWidget {
  final SongComment comment;
  final int? currentUserId;
  final bool isAdmin;
  final ValueChanged<SongComment> onReply;
  final ValueChanged<SongComment> onDelete;

  const _CommentCard({
    required this.comment,
    required this.currentUserId,
    required this.isAdmin,
    required this.onReply,
    required this.onDelete,
  });

  bool get _canManage => isAdmin || currentUserId == comment.userId;

  @override
  Widget build(BuildContext context) {
    return AppGlassCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CircleAvatar(
                backgroundColor: AppColors.accent.withValues(alpha: 0.22),
                foregroundColor: AppColors.cream,
                child: Text(
                  comment.userName.isEmpty
                      ? 'U'
                      : comment.userName.characters.first.toUpperCase(),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      comment.userName,
                      style: const TextStyle(fontWeight: FontWeight.w900),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      _formatTime(comment.createdAt),
                      style: const TextStyle(
                        color: AppColors.muted,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
              if (_canManage)
                IconButton(
                  tooltip: 'Hapus komentar',
                  onPressed: () => onDelete(comment),
                  icon: const Icon(
                    Icons.delete_outline_rounded,
                    color: AppColors.accentHot,
                  ),
                ),
            ],
          ),
          const SizedBox(height: 12),
          Text(comment.content, style: const TextStyle(height: 1.45)),
          const SizedBox(height: 6),
          TextButton.icon(
            onPressed: () => onReply(comment),
            icon: const Icon(Icons.reply_rounded, size: 18),
            label: const Text('Balas'),
          ),
          if (comment.replies.isNotEmpty) ...[
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.only(left: 14),
              decoration: const BoxDecoration(
                border: Border(left: BorderSide(color: AppColors.line)),
              ),
              child: Column(
                children: comment.replies.map((reply) {
                  final canManageReply =
                      isAdmin || currentUserId == reply.userId;
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CircleAvatar(
                          radius: 15,
                          backgroundColor: AppColors.cardSoft,
                          foregroundColor: AppColors.cream,
                          child: Text(
                            reply.userName.isEmpty
                                ? 'U'
                                : reply.userName.characters.first.toUpperCase(),
                            style: const TextStyle(fontSize: 12),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                reply.userName,
                                style: const TextStyle(
                                  fontWeight: FontWeight.w800,
                                  fontSize: 13,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                reply.content,
                                style: const TextStyle(
                                  color: AppColors.muted,
                                  height: 1.35,
                                ),
                              ),
                            ],
                          ),
                        ),
                        if (canManageReply)
                          IconButton(
                            tooltip: 'Hapus balasan',
                            onPressed: () => onDelete(reply),
                            icon: const Icon(
                              Icons.close_rounded,
                              color: AppColors.muted,
                            ),
                          ),
                      ],
                    ),
                  );
                }).toList(),
              ),
            ),
          ],
        ],
      ),
    );
  }

  String _formatTime(DateTime? time) {
    if (time == null) {
      return 'Baru saja';
    }

    final diff = DateTime.now().difference(time);
    if (diff.inMinutes < 1) {
      return 'Baru saja';
    }
    if (diff.inHours < 1) {
      return '${diff.inMinutes} menit lalu';
    }
    if (diff.inDays < 1) {
      return '${diff.inHours} jam lalu';
    }
    if (diff.inDays < 7) {
      return '${diff.inDays} hari lalu';
    }

    final day = time.day.toString().padLeft(2, '0');
    final month = time.month.toString().padLeft(2, '0');
    return '$day/$month/${time.year}';
  }
}
