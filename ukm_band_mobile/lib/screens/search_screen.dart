import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/song.dart';
import '../providers/audio_provider.dart';
import '../providers/music_provider.dart';
import '../services/api_service.dart';
import '../theme/app_theme.dart';
import '../widgets/song_artwork.dart';
import 'song_detail_screen.dart';

enum _SearchMode { suggested, popular, liked }

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  static const int _previewLimit = 8;
  static const int _resultLimit = 40;

  final TextEditingController _searchController = TextEditingController();
  _SearchMode _mode = _SearchMode.suggested;

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

  List<Song> _filterSongs(List<Song> songs, String query) {
    final matchesQuery = query.isEmpty
        ? List<Song>.of(songs)
        : songs.where((song) {
            return song.title.toLowerCase().contains(query) ||
                song.artist.toLowerCase().contains(query);
          }).toList();
    final limit = query.isEmpty ? _previewLimit : _resultLimit;

    if (_mode == _SearchMode.liked) {
      return matchesQuery.where((song) => song.isLiked).take(limit).toList();
    }

    if (_mode == _SearchMode.popular || query.isEmpty) {
      _sortByScore(matchesQuery);
      return matchesQuery.take(limit).toList();
    }

    return matchesQuery.take(limit).toList();
  }

  int _matchCount(List<Song> songs, String query) {
    final matchesQuery = query.isEmpty
        ? songs
        : songs.where((song) {
            return song.title.toLowerCase().contains(query) ||
                song.artist.toLowerCase().contains(query);
          });

    if (_mode == _SearchMode.liked) {
      return matchesQuery.where((song) => song.isLiked).length;
    }

    return matchesQuery.length;
  }

  void _sortByScore(List<Song> songs) {
    songs.sort((a, b) {
      final aScore = (a.plays * 2) + a.likes;
      final bScore = (b.plays * 2) + b.likes;
      return bScore.compareTo(aScore);
    });
  }

  Future<void> _playSong(Song song, List<Song> queue) async {
    final apiService = context.read<ApiService>();
    final audioProvider = context.read<AudioProvider>();

    if (audioProvider.willStartNewPlayback(song)) {
      try {
        await apiService.recordPlay(song.id);
      } catch (_) {
        // Playback should continue even when tracking fails.
      }
    }

    if (!mounted) {
      return;
    }

    await audioProvider.playOrToggleSong(song, queue: queue);
  }

  void _openSong(Song song, List<Song> queue) {
    Navigator.of(context).push(songDetailRoute(song: song, queue: queue));
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
        final filtered = _filterSongs(music.songs, query);
        final matchCount = _matchCount(music.songs, query);
        final likedCount = music.songs.where((song) => song.isLiked).length;

        return Scaffold(
          backgroundColor: AppColors.ink,
          body: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF30080E), AppColors.ink, Color(0xFF061118)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                stops: [0, 0.48, 1],
              ),
            ),
            child: SafeArea(
              child: RefreshIndicator(
                onRefresh: () => context.read<MusicProvider>().refresh(),
                child: ListView(
                  physics: const AlwaysScrollableScrollPhysics(
                    parent: BouncingScrollPhysics(),
                  ),
                  padding: const EdgeInsets.fromLTRB(18, 18, 18, 118),
                  children: [
                    _SearchHero(
                      resultCount: matchCount,
                      totalCount: music.songs.length,
                      query: query,
                    ),
                    const SizedBox(height: 18),
                    _SearchField(
                      controller: _searchController,
                      hasQuery: query.isNotEmpty,
                    ),
                    const SizedBox(height: 14),
                    _SearchFilterBar(
                      selected: _mode,
                      totalCount: music.songs.length,
                      likedCount: likedCount,
                      onChanged: (mode) => setState(() => _mode = mode),
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
                        icon: _mode == _SearchMode.liked
                            ? Icons.favorite_border_rounded
                            : Icons.search_off_rounded,
                        title: _mode == _SearchMode.liked
                            ? 'Belum ada lagu disukai'
                            : 'Lagu tidak ditemukan',
                        message: _mode == _SearchMode.liked
                            ? 'Tekan tombol hati pada lagu untuk menyimpannya di filter ini.'
                            : 'Coba cari judul atau nama artis dengan kata lain.',
                      )
                    else ...[
                      _ResultsHeader(
                        visibleCount: filtered.length,
                        totalCount: matchCount,
                        mode: _mode,
                        hasQuery: query.isNotEmpty,
                      ),
                      const SizedBox(height: 12),
                      ...filtered.asMap().entries.map(
                        (entry) => _StaggeredReveal(
                          index: entry.key,
                          child: Padding(
                            padding: const EdgeInsets.only(bottom: 10),
                            child: _SearchSongTile(
                              song: entry.value,
                              rank: entry.key + 1,
                              onOpen: () => _openSong(entry.value, filtered),
                              onPlay: () => _playSong(entry.value, filtered),
                              onLike: () => _toggleLike(entry.value),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class _SearchHero extends StatelessWidget {
  final int resultCount;
  final int totalCount;
  final String query;

  const _SearchHero({
    required this.resultCount,
    required this.totalCount,
    required this.query,
  });

  @override
  Widget build(BuildContext context) {
    final title = query.isEmpty ? 'Cari Musik' : 'Ketemu $resultCount Track';

    return AppGlassCard(
      padding: EdgeInsets.zero,
      child: Container(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
          gradient: LinearGradient(
            colors: [
              AppColors.accent.withValues(alpha: 0.18),
              AppColors.card.withValues(alpha: 0.64),
              const Color(0xFF071018).withValues(alpha: 0.78),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.08),
                      borderRadius: BorderRadius.circular(999),
                      border: Border.all(color: AppColors.line),
                    ),
                    child: const Text(
                      'DISCOVERY MODE',
                      style: TextStyle(
                        color: AppColors.accentHot,
                        fontWeight: FontWeight.w900,
                        fontSize: 10,
                        letterSpacing: 1.1,
                      ),
                    ),
                  ),
                  const SizedBox(height: 18),
                  Text(
                    title,
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.w900,
                      height: 1.02,
                    ),
                  ),
                  const SizedBox(height: 7),
                  Text(
                    query.isEmpty
                        ? 'Preview dibatasi supaya cepat. Ketik judul atau artis untuk hasil lebih spesifik.'
                        : 'Hasil dibatasi ke track teratas supaya tetap ringan dan mudah dipilih.',
                    style: const TextStyle(color: AppColors.muted, height: 1.4),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    '$totalCount lagu tersedia',
                    style: const TextStyle(
                      color: AppColors.cream,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 14),
            const _SearchOrb(),
          ],
        ),
      ),
    );
  }
}

class _SearchOrb extends StatelessWidget {
  const _SearchOrb();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 96,
      height: 112,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            width: 82,
            height: 82,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.cardSoft,
              boxShadow: [
                BoxShadow(
                  color: AppColors.accent.withValues(alpha: 0.32),
                  blurRadius: 30,
                  spreadRadius: 3,
                ),
              ],
            ),
          ),
          Container(
            width: 50,
            height: 50,
            decoration: const BoxDecoration(
              color: AppColors.accent,
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.search_rounded, color: Colors.white),
          ),
          Positioned(
            right: 0,
            top: 14,
            child: Container(
              width: 36,
              height: 52,
              decoration: BoxDecoration(
                color: AppColors.cream,
                borderRadius: BorderRadius.circular(18),
              ),
              child: const Icon(Icons.graphic_eq_rounded, color: Colors.black),
            ),
          ),
        ],
      ),
    );
  }
}

class _SearchField extends StatelessWidget {
  final TextEditingController controller;
  final bool hasQuery;

  const _SearchField({required this.controller, required this.hasQuery});

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      textInputAction: TextInputAction.search,
      decoration: InputDecoration(
        hintText: 'Cari lagu atau artis',
        prefixIcon: const Icon(Icons.search_rounded),
        suffixIcon: hasQuery
            ? IconButton(
                tooltip: 'Bersihkan pencarian',
                onPressed: controller.clear,
                icon: const Icon(Icons.close_rounded),
              )
            : const Icon(Icons.keyboard_voice_rounded, color: AppColors.muted),
      ),
    );
  }
}

class _SearchFilterBar extends StatelessWidget {
  final _SearchMode selected;
  final int totalCount;
  final int likedCount;
  final ValueChanged<_SearchMode> onChanged;

  const _SearchFilterBar({
    required this.selected,
    required this.totalCount,
    required this.likedCount,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      physics: const BouncingScrollPhysics(),
      child: Row(
        children: [
          _SearchChip(
            label: 'Rekomendasi',
            count: totalCount,
            icon: Icons.auto_awesome_rounded,
            active: selected == _SearchMode.suggested,
            onTap: () => onChanged(_SearchMode.suggested),
          ),
          const SizedBox(width: 10),
          _SearchChip(
            label: 'Populer',
            count: totalCount,
            icon: Icons.local_fire_department_rounded,
            active: selected == _SearchMode.popular,
            onTap: () => onChanged(_SearchMode.popular),
          ),
          const SizedBox(width: 10),
          _SearchChip(
            label: 'Disukai',
            count: likedCount,
            icon: Icons.favorite_rounded,
            active: selected == _SearchMode.liked,
            onTap: () => onChanged(_SearchMode.liked),
          ),
        ],
      ),
    );
  }
}

class _SearchChip extends StatelessWidget {
  final String label;
  final int count;
  final IconData icon;
  final bool active;
  final VoidCallback onTap;

  const _SearchChip({
    required this.label,
    required this.count,
    required this.icon,
    required this.active,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(999),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        curve: Curves.easeOutCubic,
        padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 10),
        decoration: BoxDecoration(
          color: active
              ? AppColors.accent.withValues(alpha: 0.22)
              : AppColors.card.withValues(alpha: 0.78),
          borderRadius: BorderRadius.circular(999),
          border: Border.all(
            color: active ? AppColors.accentHot : AppColors.line,
          ),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              size: 17,
              color: active ? AppColors.accentHot : AppColors.muted,
            ),
            const SizedBox(width: 7),
            Text(
              '$label $count',
              style: TextStyle(
                color: active ? AppColors.cream : AppColors.muted,
                fontWeight: FontWeight.w900,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ResultsHeader extends StatelessWidget {
  final int visibleCount;
  final int totalCount;
  final _SearchMode mode;
  final bool hasQuery;

  const _ResultsHeader({
    required this.visibleCount,
    required this.totalCount,
    required this.mode,
    required this.hasQuery,
  });

  @override
  Widget build(BuildContext context) {
    final title = switch (mode) {
      _SearchMode.suggested => hasQuery ? 'Hasil Teratas' : 'Rekomendasi',
      _SearchMode.popular => 'Paling Hidup',
      _SearchMode.liked => 'Lagu Disukai',
    };
    final countLabel = totalCount > visibleCount
        ? '$visibleCount dari $totalCount'
        : '$visibleCount track';

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
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          decoration: BoxDecoration(
            color: AppColors.card.withValues(alpha: 0.78),
            borderRadius: BorderRadius.circular(999),
            border: Border.all(color: AppColors.line),
          ),
          child: Text(
            countLabel,
            style: const TextStyle(
              color: AppColors.muted,
              fontWeight: FontWeight.w800,
              fontSize: 12,
            ),
          ),
        ),
      ],
    );
  }
}

class _StaggeredReveal extends StatelessWidget {
  final int index;
  final Widget child;

  const _StaggeredReveal({required this.index, required this.child});

  @override
  Widget build(BuildContext context) {
    final clampedIndex = index.clamp(0, 8).toInt();

    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: 1),
      duration: Duration(milliseconds: 260 + (clampedIndex * 35)),
      curve: Curves.easeOutCubic,
      builder: (context, value, child) {
        return Opacity(
          opacity: value,
          child: Transform.translate(
            offset: Offset(0, (1 - value) * 14),
            child: child,
          ),
        );
      },
      child: child,
    );
  }
}

class _SearchSongTile extends StatelessWidget {
  final Song song;
  final int rank;
  final VoidCallback onOpen;
  final VoidCallback onPlay;
  final VoidCallback onLike;

  const _SearchSongTile({
    required this.song,
    required this.rank,
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
          Stack(
            clipBehavior: Clip.none,
            children: [
              SongArtwork(
                source: song.displayCover,
                size: 64,
                borderRadius: BorderRadius.circular(18),
              ),
              Positioned(
                left: -5,
                top: -5,
                child: Container(
                  width: 24,
                  height: 24,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: AppColors.accentHot,
                    borderRadius: BorderRadius.circular(9),
                    border: Border.all(color: AppColors.ink, width: 2),
                  ),
                  child: Text(
                    '$rank',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ),
              ),
              Positioned(
                right: -4,
                bottom: -4,
                child: Container(
                  width: 28,
                  height: 28,
                  decoration: BoxDecoration(
                    color: AppColors.ink.withValues(alpha: 0.88),
                    shape: BoxShape.circle,
                    border: Border.all(color: AppColors.line),
                  ),
                  child: const Icon(
                    Icons.play_arrow_rounded,
                    color: AppColors.cream,
                    size: 18,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(width: 13),
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
                const SizedBox(height: 8),
                Wrap(
                  spacing: 7,
                  runSpacing: 7,
                  children: [
                    _SongMetaPill(
                      icon: Icons.play_arrow_rounded,
                      label: '${song.plays}',
                    ),
                    _SongMetaPill(
                      icon: Icons.favorite_rounded,
                      label: '${song.likes}',
                      active: song.isLiked,
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Column(
            children: [
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
        ],
      ),
    );
  }
}

class _SongMetaPill extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool active;

  const _SongMetaPill({
    required this.icon,
    required this.label,
    this.active = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
      decoration: BoxDecoration(
        color: active
            ? AppColors.accent.withValues(alpha: 0.16)
            : AppColors.cardSoft.withValues(alpha: 0.8),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 13,
            color: active ? AppColors.accentHot : AppColors.muted,
          ),
          const SizedBox(width: 4),
          Text(
            label,
            style: const TextStyle(
              color: AppColors.muted,
              fontSize: 10,
              fontWeight: FontWeight.w800,
            ),
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
