import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/song.dart';
import '../providers/audio_provider.dart';
import '../services/api_service.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  late Future<List<Song>> _songsFuture;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _songsFuture = context.read<ApiService>().fetchSongs();
    _searchController.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Widget _buildCover(String source) {
    final fallback = Container(
      width: 56,
      height: 56,
      color: Colors.grey.shade800,
      child: const Icon(Icons.music_note, color: Colors.white),
    );

    if (source.startsWith('http://') || source.startsWith('https://')) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(6),
        child: Image.network(
          source,
          width: 56,
          height: 56,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) => fallback,
        ),
      );
    }

    if (source.isNotEmpty) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(6),
        child: Image.asset(
          source,
          width: 56,
          height: 56,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) => fallback,
        ),
      );
    }

    return fallback;
  }

  Widget _buildCategoryCard(String title, Color color, String imagePath) {
    return Container(
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(4),
      ),
      clipBehavior: Clip.hardEdge,
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Text(
              title,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ),
          Positioned(
            right: -15,
            bottom: -5,
            child: Transform.rotate(
              angle: 0.4,
              child: Image.asset(
                imagePath,
                width: 70,
                height: 70,
                fit: BoxFit.cover,
                errorBuilder: (c, e, s) => Container(
                  width: 70,
                  height: 70,
                  color: Colors.grey.withValues(alpha: 0.5),
                  child: const Icon(Icons.music_note, color: Colors.black26),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final query = _searchController.text.trim().toLowerCase();

    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.only(
            left: 16,
            right: 16,
            top: 16,
            bottom: 80,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: Image.asset(
                      'assets/img/default-cover.jpg',
                      width: 32,
                      height: 32,
                      fit: BoxFit.cover,
                      errorBuilder: (c, e, s) => const Icon(
                        Icons.person,
                        color: Colors.white,
                        size: 24,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  const Text(
                    'Cari',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  const Spacer(),
                  const Icon(Icons.camera_alt_outlined, size: 28),
                ],
              ),
              const SizedBox(height: 20),
              Container(
                height: 48,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Row(
                  children: [
                    const SizedBox(width: 12),
                    const Icon(Icons.search, color: Colors.black54, size: 28),
                    const SizedBox(width: 12),
                    Expanded(
                      child: TextField(
                        controller: _searchController,
                        style: const TextStyle(color: Colors.black87),
                        decoration: const InputDecoration(
                          hintText: 'Cari lagu atau artis',
                          hintStyle: TextStyle(color: Colors.black54),
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                    if (_searchController.text.isNotEmpty)
                      IconButton(
                        onPressed: () {
                          _searchController.clear();
                        },
                        icon: const Icon(Icons.close, color: Colors.black54),
                      ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              FutureBuilder<List<Song>>(
                future: _songsFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (snapshot.hasError) {
                    return Text(
                      snapshot.error.toString(),
                      style: const TextStyle(color: Colors.redAccent),
                    );
                  }

                  final songs = snapshot.data ?? [];
                  final filtered = songs.where((song) {
                    if (query.isEmpty) {
                      return true;
                    }
                    return song.title.toLowerCase().contains(query) ||
                        song.artist.toLowerCase().contains(query);
                  }).toList();

                  if (query.isNotEmpty) {
                    if (filtered.isEmpty) {
                      return const Text(
                        'Lagu tidak ditemukan.',
                        style: TextStyle(color: Colors.grey),
                      );
                    }

                    return ListView.separated(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: filtered.length,
                      separatorBuilder: (context, index) =>
                          const Divider(height: 1),
                      itemBuilder: (context, index) {
                        final song = filtered[index];
                        return ListTile(
                          contentPadding: EdgeInsets.zero,
                          leading: _buildCover(song.displayCover),
                          title: Text(song.title),
                          subtitle: Text(song.artist),
                          onTap: () async {
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

                            await audioProvider.playSong(song, queue: filtered);
                          },
                        );
                      },
                    );
                  }

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Start browsing',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),
                      GridView.count(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        crossAxisCount: 2,
                        childAspectRatio: 1.6,
                        crossAxisSpacing: 16,
                        mainAxisSpacing: 16,
                        children: [
                          _buildCategoryCard(
                            'Music',
                            const Color(0xFFDC148C),
                            'assets/img/c1.jpg',
                          ),
                          _buildCategoryCard(
                            'Podcasts',
                            const Color(0xFF006450),
                            'assets/img/c2.jpg',
                          ),
                          _buildCategoryCard(
                            'Live Events',
                            const Color(0xFF8400E7),
                            'assets/img/c3.jpg',
                          ),
                          _buildCategoryCard(
                            'K-Pop ON!',
                            const Color(0xFF148A08),
                            'assets/img/c4.jpg',
                          ),
                          _buildCategoryCard(
                            'New Releases',
                            const Color(0xFFE8115B),
                            'assets/img/c5.jpg',
                          ),
                          _buildCategoryCard(
                            'Pop',
                            const Color(0xFF509BF5),
                            'assets/img/c6.jpg',
                          ),
                        ],
                      ),
                    ],
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
