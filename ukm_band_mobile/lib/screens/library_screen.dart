import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/history_entry.dart';
import '../models/playlist.dart';
import '../models/song.dart';
import '../providers/audio_provider.dart';
import '../providers/music_provider.dart';
import '../services/api_service.dart';
import '../theme/app_theme.dart';
import '../widgets/song_artwork.dart';
import 'song_detail_screen.dart';

class LibraryScreen extends StatefulWidget {
  const LibraryScreen({super.key});

  @override
  State<LibraryScreen> createState() => _LibraryScreenState();
}

class _LibraryScreenState extends State<LibraryScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<MusicProvider>().load();
    });
  }

  Future<void> _playSong(Song song, List<Song> queue) async {
    final apiService = context.read<ApiService>();
    final audioProvider = context.read<AudioProvider>();

    try {
      await apiService.recordPlay(song.id);
    } catch (_) {
      // History tracking should not block playback.
    }

    if (!mounted) {
      return;
    }

    await audioProvider.playSong(song, queue: queue);
  }

  void _openSong(Song song, List<Song> queue) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => SongDetailScreen(song: song, queue: queue),
      ),
    );
  }

  Future<void> _showCreatePlaylistSheet() async {
    final musicProvider = context.read<MusicProvider>();

    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) {
        return _CreatePlaylistSheet(
          musicProvider: musicProvider,
          onError: (message) {
            if (!mounted) {
              return;
            }
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(message)));
          },
        );
      },
    );
  }

  Future<void> _renamePlaylist(Playlist playlist) async {
    final controller = TextEditingController(text: playlist.name);

    final newName = await showDialog<String>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Ubah Nama Playlist'),
          content: TextField(
            controller: controller,
            autofocus: true,
            decoration: const InputDecoration(labelText: 'Nama playlist'),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Batal'),
            ),
            FilledButton(
              onPressed: () => Navigator.pop(context, controller.text.trim()),
              child: const Text('Simpan'),
            ),
          ],
        );
      },
    );

    controller.dispose();

    if (newName == null || newName.isEmpty || newName == playlist.name) {
      return;
    }

    if (!mounted) {
      return;
    }

    final musicProvider = context.read<MusicProvider>();
    final messenger = ScaffoldMessenger.of(context);

    try {
      await musicProvider.renamePlaylist(playlist, newName);
    } catch (error) {
      messenger.showSnackBar(
        SnackBar(content: Text('Gagal mengubah playlist: $error')),
      );
    }
  }

  Future<void> _deletePlaylist(Playlist playlist) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Hapus playlist?'),
          content: Text('Playlist "${playlist.name}" akan dihapus permanen.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Batal'),
            ),
            FilledButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text('Hapus'),
            ),
          ],
        );
      },
    );

    if (confirmed != true) {
      return;
    }

    if (!mounted) {
      return;
    }

    final musicProvider = context.read<MusicProvider>();
    final messenger = ScaffoldMessenger.of(context);

    try {
      await musicProvider.deletePlaylist(playlist);
    } catch (error) {
      messenger.showSnackBar(
        SnackBar(content: Text('Gagal menghapus playlist: $error')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<MusicProvider>(
      builder: (context, music, _) {
        return Scaffold(
          backgroundColor: AppColors.ink,
          body: SafeArea(
            child: RefreshIndicator(
              onRefresh: () => context.read<MusicProvider>().refresh(),
              child: ListView(
                physics: const AlwaysScrollableScrollPhysics(
                  parent: BouncingScrollPhysics(),
                ),
                padding: const EdgeInsets.fromLTRB(18, 18, 18, 118),
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Perpustakaan Anda',
                              style: Theme.of(context).textTheme.headlineSmall
                                  ?.copyWith(fontWeight: FontWeight.w900),
                            ),
                            const SizedBox(height: 5),
                            const Text(
                              'Playlist, riwayat, dan lagu yang sering kamu putar.',
                              style: TextStyle(color: AppColors.muted),
                            ),
                          ],
                        ),
                      ),
                      IconButton.filled(
                        tooltip: 'Buat playlist',
                        onPressed: _showCreatePlaylistSheet,
                        icon: const Icon(Icons.add_rounded),
                      ),
                    ],
                  ),
                  const SizedBox(height: 22),
                  if (music.isLoading && !music.hasLoaded)
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 42),
                      child: Center(child: CircularProgressIndicator()),
                    )
                  else if (music.errorMessage != null &&
                      music.playlists.isEmpty &&
                      music.history.isEmpty)
                    AppGlassCard(
                      child: Column(
                        children: [
                          const Icon(
                            Icons.wifi_off_rounded,
                            color: AppColors.accentHot,
                          ),
                          const SizedBox(height: 12),
                          Text(
                            music.errorMessage!,
                            textAlign: TextAlign.center,
                            style: const TextStyle(color: AppColors.muted),
                          ),
                          const SizedBox(height: 16),
                          FilledButton.icon(
                            onPressed: () =>
                                context.read<MusicProvider>().refresh(),
                            icon: const Icon(Icons.refresh_rounded),
                            label: const Text('Coba Lagi'),
                          ),
                        ],
                      ),
                    )
                  else ...[
                    _LibrarySectionTitle(
                      title: 'Playlist Saya',
                      actionLabel: 'Buat',
                      onAction: _showCreatePlaylistSheet,
                    ),
                    const SizedBox(height: 12),
                    if (music.playlists.isEmpty)
                      _EmptyLibraryCard(onCreate: _showCreatePlaylistSheet)
                    else
                      ...music.playlists.map(
                        (playlist) => Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: _PlaylistCard(
                            playlist: playlist,
                            onPlay: playlist.songs.isEmpty
                                ? null
                                : () => _playSong(
                                    playlist.songs.first,
                                    playlist.songs,
                                  ),
                            onRename: () => _renamePlaylist(playlist),
                            onDelete: () => _deletePlaylist(playlist),
                            onOpenSong: (song) =>
                                _openSong(song, playlist.songs),
                            onPlaySong: (song) =>
                                _playSong(song, playlist.songs),
                            onRemoveSong: (song) async {
                              final musicProvider = context
                                  .read<MusicProvider>();
                              final messenger = ScaffoldMessenger.of(context);
                              try {
                                await musicProvider.removeSongFromPlaylist(
                                  playlist,
                                  song,
                                );
                              } catch (error) {
                                messenger.showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      'Gagal menghapus lagu: $error',
                                    ),
                                  ),
                                );
                              }
                            },
                          ),
                        ),
                      ),
                    const SizedBox(height: 24),
                    const _LibrarySectionTitle(title: 'Baru Diputar'),
                    const SizedBox(height: 12),
                    if (music.history.isEmpty)
                      const AppGlassCard(
                        child: Text(
                          'Riwayat pemutaran masih kosong.',
                          style: TextStyle(color: AppColors.muted),
                        ),
                      )
                    else
                      ...music.history
                          .where((entry) => entry.song != null)
                          .take(20)
                          .map(
                            (entry) => Padding(
                              padding: const EdgeInsets.only(bottom: 10),
                              child: _HistoryTile(
                                entry: entry,
                                onOpen: () => _openSong(
                                  entry.song!,
                                  music.history
                                      .where((item) => item.song != null)
                                      .map((item) => item.song!)
                                      .toList(),
                                ),
                                onPlay: () => _playSong(
                                  entry.song!,
                                  music.history
                                      .where((item) => item.song != null)
                                      .map((item) => item.song!)
                                      .toList(),
                                ),
                              ),
                            ),
                          ),
                  ],
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class _CreatePlaylistSheet extends StatefulWidget {
  final MusicProvider musicProvider;
  final ValueChanged<String> onError;

  const _CreatePlaylistSheet({
    required this.musicProvider,
    required this.onError,
  });

  @override
  State<_CreatePlaylistSheet> createState() => _CreatePlaylistSheetState();
}

class _CreatePlaylistSheetState extends State<_CreatePlaylistSheet> {
  final _controller = TextEditingController();
  bool _isSaving = false;

  Future<void> _submit() async {
    final name = _controller.text.trim();
    if (name.isEmpty || _isSaving) {
      return;
    }

    setState(() => _isSaving = true);
    var shouldResetSaving = true;

    try {
      await widget.musicProvider.createPlaylist(name);
      shouldResetSaving = false;
      if (mounted) {
        Navigator.of(context).pop();
      }
    } catch (error) {
      widget.onError('Gagal membuat playlist: $error');
    } finally {
      if (shouldResetSaving && mounted) {
        setState(() => _isSaving = false);
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Container(
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
        decoration: const BoxDecoration(
          color: AppColors.stage,
          borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
        ),
        child: SafeArea(
          top: false,
          child: SingleChildScrollView(
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
                const SizedBox(height: 22),
                Text(
                  'Buat Playlist Baru',
                  style: Theme.of(
                    context,
                  ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w900),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: _controller,
                  autofocus: true,
                  textInputAction: TextInputAction.done,
                  onSubmitted: (_) => _submit(),
                  decoration: const InputDecoration(
                    labelText: 'Nama playlist',
                    prefixIcon: Icon(Icons.queue_music_rounded),
                  ),
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: FilledButton.icon(
                    onPressed: _isSaving ? null : _submit,
                    icon: _isSaving
                        ? const SizedBox(
                            width: 16,
                            height: 16,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Icon(Icons.add_rounded),
                    label: Text(_isSaving ? 'Menyimpan...' : 'Buat'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _PlaylistCard extends StatelessWidget {
  final Playlist playlist;
  final VoidCallback? onPlay;
  final VoidCallback onRename;
  final VoidCallback onDelete;
  final ValueChanged<Song> onOpenSong;
  final ValueChanged<Song> onPlaySong;
  final ValueChanged<Song> onRemoveSong;

  const _PlaylistCard({
    required this.playlist,
    required this.onPlay,
    required this.onRename,
    required this.onDelete,
    required this.onOpenSong,
    required this.onPlaySong,
    required this.onRemoveSong,
  });

  @override
  Widget build(BuildContext context) {
    return AppGlassCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 58,
                height: 58,
                decoration: BoxDecoration(
                  color: AppColors.accent.withValues(alpha: 0.16),
                  borderRadius: BorderRadius.circular(18),
                ),
                child: const Icon(
                  Icons.queue_music_rounded,
                  color: AppColors.accentHot,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      playlist.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontWeight: FontWeight.w900,
                        fontSize: 17,
                      ),
                    ),
                    Text(
                      '${playlist.songs.length} lagu',
                      style: const TextStyle(color: AppColors.muted),
                    ),
                  ],
                ),
              ),
              IconButton(
                tooltip: 'Ubah nama',
                onPressed: onRename,
                icon: const Icon(Icons.edit_outlined),
              ),
              IconButton(
                tooltip: 'Hapus playlist',
                onPressed: onDelete,
                icon: const Icon(
                  Icons.delete_outline_rounded,
                  color: AppColors.accentHot,
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          SizedBox(
            width: double.infinity,
            child: FilledButton.icon(
              onPressed: onPlay,
              icon: const Icon(Icons.play_arrow_rounded),
              label: const Text('Putar Playlist'),
            ),
          ),
          const SizedBox(height: 12),
          if (playlist.songs.isEmpty)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.cardSoft,
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: AppColors.line),
              ),
              child: const Text(
                'Playlist ini masih kosong. Tambahkan lagu dari halaman detail lagu.',
                style: TextStyle(color: AppColors.muted),
              ),
            )
          else
            ...playlist.songs.map(
              (song) => Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: _PlaylistSongTile(
                  song: song,
                  onOpen: () => onOpenSong(song),
                  onPlay: () => onPlaySong(song),
                  onRemove: () => onRemoveSong(song),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _PlaylistSongTile extends StatelessWidget {
  final Song song;
  final VoidCallback onOpen;
  final VoidCallback onPlay;
  final VoidCallback onRemove;

  const _PlaylistSongTile({
    required this.song,
    required this.onOpen,
    required this.onPlay,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onOpen,
      borderRadius: BorderRadius.circular(18),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 6),
        child: Row(
          children: [
            SongArtwork(
              source: song.displayCover,
              size: 50,
              borderRadius: BorderRadius.circular(14),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    song.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontWeight: FontWeight.w800),
                  ),
                  Text(
                    song.artist,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: AppColors.muted,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
            IconButton(
              tooltip: 'Putar lagu',
              onPressed: onPlay,
              icon: const Icon(Icons.play_arrow_rounded),
            ),
            IconButton(
              tooltip: 'Hapus dari playlist',
              onPressed: onRemove,
              icon: const Icon(Icons.close_rounded),
            ),
          ],
        ),
      ),
    );
  }
}

class _HistoryTile extends StatelessWidget {
  final HistoryEntry entry;
  final VoidCallback onOpen;
  final VoidCallback onPlay;

  const _HistoryTile({
    required this.entry,
    required this.onOpen,
    required this.onPlay,
  });

  @override
  Widget build(BuildContext context) {
    final song = entry.song!;

    return AppGlassCard(
      padding: const EdgeInsets.all(12),
      onTap: onOpen,
      child: Row(
        children: [
          SongArtwork(
            source: song.displayCover,
            size: 56,
            borderRadius: BorderRadius.circular(16),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  song.title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontWeight: FontWeight.w900),
                ),
                const SizedBox(height: 3),
                Text(
                  '${song.artist} | ${_formatPlayedAt(entry.playedAt)}',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(color: AppColors.muted, fontSize: 12),
                ),
              ],
            ),
          ),
          IconButton.filledTonal(
            tooltip: 'Putar lagi',
            onPressed: onPlay,
            icon: const Icon(Icons.replay_rounded),
          ),
        ],
      ),
    );
  }

  String _formatPlayedAt(DateTime? time) {
    if (time == null) {
      return '-';
    }

    final day = time.day.toString().padLeft(2, '0');
    final month = time.month.toString().padLeft(2, '0');
    final hour = time.hour.toString().padLeft(2, '0');
    final minute = time.minute.toString().padLeft(2, '0');

    return '$day/$month/${time.year} $hour:$minute';
  }
}

class _EmptyLibraryCard extends StatelessWidget {
  final VoidCallback onCreate;

  const _EmptyLibraryCard({required this.onCreate});

  @override
  Widget build(BuildContext context) {
    return AppGlassCard(
      child: Column(
        children: [
          const Icon(
            Icons.queue_music_outlined,
            color: AppColors.accentHot,
            size: 38,
          ),
          const SizedBox(height: 12),
          const Text(
            'Belum ada playlist.',
            style: TextStyle(fontWeight: FontWeight.w900),
          ),
          const SizedBox(height: 6),
          const Text(
            'Buat playlist untuk menyimpan lagu favorit dan memutarnya sebagai antrean.',
            textAlign: TextAlign.center,
            style: TextStyle(color: AppColors.muted),
          ),
          const SizedBox(height: 16),
          FilledButton.icon(
            onPressed: onCreate,
            icon: const Icon(Icons.add_rounded),
            label: const Text('Buat Playlist'),
          ),
        ],
      ),
    );
  }
}

class _LibrarySectionTitle extends StatelessWidget {
  final String title;
  final String? actionLabel;
  final VoidCallback? onAction;

  const _LibrarySectionTitle({
    required this.title,
    this.actionLabel,
    this.onAction,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            title,
            style: Theme.of(
              context,
            ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w900),
          ),
        ),
        if (actionLabel != null && onAction != null)
          TextButton.icon(
            onPressed: onAction,
            icon: const Icon(Icons.add_rounded),
            label: Text(actionLabel!),
          ),
      ],
    );
  }
}
