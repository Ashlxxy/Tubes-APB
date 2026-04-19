import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/history_entry.dart';
import '../models/playlist.dart';
import '../services/api_service.dart';

class LibraryScreen extends StatefulWidget {
  const LibraryScreen({super.key});

  @override
  State<LibraryScreen> createState() => _LibraryScreenState();
}

class _LibraryScreenState extends State<LibraryScreen> {
  late Future<_LibraryData> _libraryFuture;

  @override
  void initState() {
    super.initState();
    _libraryFuture = _loadLibraryData();
  }

  Future<_LibraryData> _loadLibraryData() async {
    final api = context.read<ApiService>();
    final playlists = await api.fetchPlaylists();
    final history = await api.fetchHistory();
    return _LibraryData(playlists: playlists, history: history);
  }

  Widget _buildCover(String source, {double size = 52}) {
    final fallback = Container(
      width: size,
      height: size,
      color: Colors.grey.shade800,
      child: const Icon(Icons.music_note, color: Colors.white),
    );

    if (source.startsWith('http://') || source.startsWith('https://')) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(6),
        child: Image.network(
          source,
          width: size,
          height: size,
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
          width: size,
          height: size,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) => fallback,
        ),
      );
    }

    return fallback;
  }

  String _formatPlayedAt(DateTime? time) {
    if (time == null) {
      return '-';
    }

    final twoDigitDay = time.day.toString().padLeft(2, '0');
    final twoDigitMonth = time.month.toString().padLeft(2, '0');
    final twoDigitHour = time.hour.toString().padLeft(2, '0');
    final twoDigitMinute = time.minute.toString().padLeft(2, '0');

    return '$twoDigitDay/$twoDigitMonth ${time.year} $twoDigitHour:$twoDigitMinute';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      body: SafeArea(
        child: FutureBuilder<_LibraryData>(
          future: _libraryFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            if (snapshot.hasError) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text(
                        'Gagal memuat pustaka.',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        snapshot.error.toString(),
                        textAlign: TextAlign.center,
                        style: const TextStyle(color: Colors.grey),
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: () {
                          setState(() {
                            _libraryFuture = _loadLibraryData();
                          });
                        },
                        child: const Text('Coba Lagi'),
                      ),
                    ],
                  ),
                ),
              );
            }

            final data = snapshot.data ?? const _LibraryData(playlists: [], history: []);

            return ListView(
              padding: const EdgeInsets.only(left: 16, right: 16, top: 12, bottom: 96),
              children: [
                const Text(
                  'Perpustakaan Anda',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 20),
                const Text(
                  'Playlist Saya',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                if (data.playlists.isEmpty)
                  const Text(
                    'Belum ada playlist.',
                    style: TextStyle(color: Colors.grey),
                  )
                else
                  ...data.playlists.map((playlist) {
                    final source = playlist.songs.isNotEmpty
                        ? playlist.songs.first.displayCover
                        : 'assets/img/default-cover.jpg';

                    return ListTile(
                      contentPadding: EdgeInsets.zero,
                      leading: _buildCover(source),
                      title: Text(
                        playlist.name,
                        style: const TextStyle(fontWeight: FontWeight.w600),
                      ),
                      subtitle: Text('${playlist.songs.length} lagu'),
                    );
                  }),
                const SizedBox(height: 20),
                const Text(
                  'Baru Diputar',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                if (data.history.isEmpty)
                  const Text(
                    'Riwayat pemutaran masih kosong.',
                    style: TextStyle(color: Colors.grey),
                  )
                else
                  ...data.history.where((entry) => entry.song != null).map((entry) {
                    final song = entry.song!;
                    return ListTile(
                      contentPadding: EdgeInsets.zero,
                      leading: _buildCover(song.displayCover),
                      title: Text(
                        song.title,
                        style: const TextStyle(fontWeight: FontWeight.w600),
                      ),
                      subtitle: Text('${song.artist} • ${_formatPlayedAt(entry.playedAt)}'),
                    );
                  }),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _LibraryData {
  final List<Playlist> playlists;
  final List<HistoryEntry> history;

  const _LibraryData({
    required this.playlists,
    required this.history,
  });
}
