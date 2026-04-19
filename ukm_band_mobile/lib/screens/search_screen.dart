import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/song.dart';
import '../providers/audio_provider.dart';
import '../providers/music_provider.dart';
import '../services/api_service.dart';
import '../theme/app_theme.dart';
import '../widgets/song_artwork.dart';
import 'song_detail_screen.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _searchController.addListener(() => setState(() {}));
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<MusicProvider>().load();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _playSong(Song song, List<Song> queue) async {
    final apiService = context.read<ApiService>();
    final audioProvider = context.read<AudioProvider>();

    try {
      await apiService.recordPlay(song.id);
    } catch (_) {
      // Playback should continue even when tracking fails.
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

  @override
  Widget build(BuildContext context) {
    final query = _searchController.text.trim().toLowerCase();

    return Consumer<MusicProvider>(
      builder: (context, music, _) {
        final filtered = music.songs.where((song) {
          if (query.isEmpty) {
            return true;
          }
          return song.title.toLowerCase().contains(query) ||
              song.artist.toLowerCase().contains(query);
        }).toList();

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
                  Text(
                    'Cari',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const SizedBox(height: 6),
                  const Text(
                    'Temukan lagu, artis, dan cerita UKM Band.',
                    style: TextStyle(color: AppColors.muted),
                  ),
                  const SizedBox(height: 18),
                  TextField(
                    controller: _searchController,
                    textInputAction: TextInputAction.search,
                    decoration: InputDecoration(
                      hintText: 'Cari lagu atau artis',
                      prefixIcon: const Icon(Icons.search_rounded),
                      suffixIcon: query.isEmpty
                          ? null
                          : IconButton(
                              tooltip: 'Bersihkan pencarian',
                              onPressed: _searchController.clear,
                              icon: const Icon(Icons.close_rounded),
                            ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  if (music.isLoading && !music.hasLoaded)
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 42),
                      child: Center(child: CircularProgressIndicator()),
                    )
                  else if (music.errorMessage != null && music.songs.isEmpty)
                    _SearchEmptyState(
                      icon: Icons.wifi_off_rounded,
                      title: 'Gagal memuat lagu',
                      message: music.errorMessage!,
                    )
                  else if (filtered.isEmpty)
                    _SearchEmptyState(
                      icon: Icons.search_off_rounded,
                      title: 'Lagu tidak ditemukan',
                      message:
                          'Coba cari judul atau nama artis dengan kata lain.',
                    )
                  else ...[
                    Text(
                      query.isEmpty
                          ? 'Semua Lagu'
                          : 'Hasil pencarian (${filtered.length})',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const SizedBox(height: 12),
                    ...filtered.map(
                      (song) => Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: _SearchSongTile(
                          song: song,
                          onOpen: () => _openSong(song, filtered),
                          onPlay: () => _playSong(song, filtered),
                          onLike: () => _toggleLike(song),
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

class _SearchSongTile extends StatelessWidget {
  final Song song;
  final VoidCallback onOpen;
  final VoidCallback onPlay;
  final VoidCallback onLike;

  const _SearchSongTile({
    required this.song,
    required this.onOpen,
    required this.onPlay,
    required this.onLike,
  });

  @override
  Widget build(BuildContext context) {
    return AppGlassCard(
      padding: const EdgeInsets.all(12),
      onTap: onOpen,
      child: Row(
        children: [
          SongArtwork(
            source: song.displayCover,
            size: 62,
            borderRadius: BorderRadius.circular(18),
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
                  song.artist,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(color: AppColors.muted, fontSize: 12),
                ),
                const SizedBox(height: 6),
                Text(
                  '${song.plays} plays | ${song.likes} likes',
                  style: const TextStyle(color: AppColors.muted, fontSize: 11),
                ),
              ],
            ),
          ),
          IconButton(
            tooltip: song.isLiked ? 'Batal like' : 'Like',
            onPressed: onLike,
            icon: Icon(
              song.isLiked
                  ? Icons.favorite_rounded
                  : Icons.favorite_border_rounded,
              color: song.isLiked ? AppColors.accentHot : AppColors.muted,
            ),
          ),
          IconButton.filled(
            tooltip: 'Putar lagu',
            onPressed: onPlay,
            icon: const Icon(Icons.play_arrow_rounded),
          ),
        ],
      ),
    );
  }
}

class _SearchEmptyState extends StatelessWidget {
  final IconData icon;
  final String title;
  final String message;

  const _SearchEmptyState({
    required this.icon,
    required this.title,
    required this.message,
  });

  @override
  Widget build(BuildContext context) {
    return AppGlassCard(
      child: Column(
        children: [
          Icon(icon, color: AppColors.accentHot, size: 34),
          const SizedBox(height: 12),
          Text(title, style: const TextStyle(fontWeight: FontWeight.w900)),
          const SizedBox(height: 6),
          Text(
            message,
            textAlign: TextAlign.center,
            style: const TextStyle(color: AppColors.muted),
          ),
        ],
      ),
    );
  }
}
