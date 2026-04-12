import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/song.dart';
import '../models/playlist.dart';
import '../services/api_service.dart';
import '../providers/audio_provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late Future<List<Song>> _songsFuture;
  late Future<List<Playlist>> _playlistsFuture;

  @override
  void initState() {
    super.initState();
    final api = Provider.of<ApiService>(context, listen: false);
    _songsFuture = api.fetchSongs();
    _playlistsFuture = api.fetchPlaylists();
  }

  String getGreeting() {
    var hour = DateTime.now().hour;
    if (hour < 12) return 'Good Morning';
    if (hour < 17) return 'Good Afternoon';
    return 'Good Evening';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFF4A0E17), // Dark Telkom Red tint
              Color(0xFF121212),
            ],
            begin: Alignment.topLeft,
            end: FractionalOffset(0.0, 0.3),
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.only(left: 16, right: 16, top: 16, bottom: 100),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      getGreeting(),
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Row(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.notifications_none),
                          onPressed: () {},
                        ),
                        const SizedBox(width: 8),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(16),
                          child: Image.asset(
                            'assets/img/default-cover.jpg',
                            width: 32,
                            height: 32,
                            fit: BoxFit.cover,
                            errorBuilder: (c, e, s) => const Icon(Icons.person, color: Colors.white, size: 20),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                
                // Playlists Grid (like Spotify Top 6)
                FutureBuilder<List<Playlist>>(
                  future: _playlistsFuture,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    final playlists = snapshot.data ?? [];
                    if (playlists.isEmpty) {
                      return const SizedBox();
                    }
                    return GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        childAspectRatio: 3,
                        crossAxisSpacing: 8,
                        mainAxisSpacing: 8,
                      ),
                      itemCount: playlists.length > 6 ? 6 : playlists.length,
                      itemBuilder: (context, index) {
                        return Container(
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Row(
                            children: [
                              ClipRRect(
                                borderRadius: const BorderRadius.horizontal(left: Radius.circular(4)),
                                child: Image.asset(
                                  'assets/img/c${(index % 7) + 1}.jpg', // Cycles through c1 to c7
                                  width: 56,
                                  height: 56,
                                  fit: BoxFit.cover,
                                  errorBuilder: (c, e, s) => Container(
                                    width: 56, 
                                    color: Colors.grey, 
                                    child: const Center(child: Icon(Icons.music_note, color: Colors.white))
                                  ),
                                ),
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  playlists[index].name,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 13,
                                  ),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    );
                  },
                ),
                
                const SizedBox(height: 32),
                
                // Recent Songs
                const Text(
                  'Recently Added Songs',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                
                FutureBuilder<List<Song>>(
                  future: _songsFuture,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    final songs = snapshot.data ?? [];
                    if (songs.isEmpty) {
                      return const Text('No songs found, please start the Laravel backend.');
                    }
                    return SizedBox(
                      height: 230,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        physics: const BouncingScrollPhysics(),
                        itemCount: songs.length,
                        itemBuilder: (context, index) {
                          final song = songs[index];
                          return GestureDetector(
                            onTap: () {
                              Provider.of<AudioProvider>(context, listen: false).playSong(song);
                            },
                            child: Container(
                              width: 140,
                              margin: const EdgeInsets.only(right: 16),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // Image
                                  Container(
                                    width: 140,
                                    height: 140,
                                    color: Colors.grey[800],
                                    child: Image.asset(
                                      song.coverPath,
                                      fit: BoxFit.cover,
                                      errorBuilder: (context, error, stackTrace) {
                                        return const Icon(Icons.music_note, size: 50, color: Colors.grey);
                                      },
                                    ),
                                  ),
                                const SizedBox(height: 8),
                                Text(
                                  song.title,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  song.artist,
                                  style: const TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
