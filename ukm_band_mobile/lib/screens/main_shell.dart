import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'home_screen.dart';
import 'search_screen.dart';
import 'library_screen.dart';
import '../providers/audio_provider.dart';

class MainShell extends StatefulWidget {
  const MainShell({super.key});

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  int _selectedIndex = 0;

  static const List<Widget> _pages = <Widget>[
    HomeScreen(),
    SearchScreen(),
    LibraryScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  Widget _buildCover(String source) {
    if (source.startsWith('http://') || source.startsWith('https://')) {
      return Image.network(
        source,
        width: 40,
        height: 40,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) =>
            const Icon(Icons.music_note),
      );
    }

    if (source.isNotEmpty) {
      return Image.asset(
        source,
        width: 40,
        height: 40,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) =>
            const Icon(Icons.music_note),
      );
    }

    return const Icon(Icons.music_note);
  }

  @override
  Widget build(BuildContext context) {
    final audioProvider = Provider.of<AudioProvider>(context);
    final song = audioProvider.currentSong;

    return Scaffold(
      body: Stack(
        children: [
          _pages[_selectedIndex],

          if (song != null)
            Positioned(
              bottom: 0,
              left: 8,
              right: 8,
              child: GestureDetector(
                onTap: () {
                  // Maximize player logically, but for now just kept simple
                },
                child: Container(
                  height: 82,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFF2E2E2E),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(4),
                            child: _buildCover(song.displayCover),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  song.title,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 13,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                Text(
                                  song.artist,
                                  style: const TextStyle(
                                    color: Colors.grey,
                                    fontSize: 11,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          ),
                          IconButton(
                            icon: const Icon(
                              Icons.skip_previous,
                              color: Colors.white,
                              size: 22,
                            ),
                            onPressed: audioProvider.canPlayPrevious
                                ? () {
                                    audioProvider.playPrevious();
                                  }
                                : null,
                          ),
                          IconButton(
                            icon: Icon(
                              audioProvider.isPlaying
                                  ? Icons.pause
                                  : Icons.play_arrow,
                              color: Colors.white,
                              size: 28,
                            ),
                            onPressed: () {
                              if (audioProvider.isPlaying) {
                                audioProvider.pause();
                              } else {
                                audioProvider.resume();
                              }
                            },
                          ),
                          IconButton(
                            icon: const Icon(
                              Icons.skip_next,
                              color: Colors.white,
                              size: 22,
                            ),
                            onPressed: audioProvider.canPlayNext
                                ? () {
                                    audioProvider.playNext();
                                  }
                                : null,
                          ),
                        ],
                      ),
                      SliderTheme(
                        data: SliderTheme.of(context).copyWith(
                          thumbShape: const RoundSliderThumbShape(
                            enabledThumbRadius: 6,
                          ),
                          trackHeight: 2,
                        ),
                        child: Slider(
                          min: 0,
                          max: audioProvider.duration.inMilliseconds > 0
                              ? audioProvider.duration.inMilliseconds.toDouble()
                              : 1,
                          value: audioProvider.position.inMilliseconds
                              .clamp(
                                0,
                                audioProvider.duration.inMilliseconds > 0
                                    ? audioProvider.duration.inMilliseconds
                                    : 1,
                              )
                              .toDouble(),
                          onChanged: (value) {
                            audioProvider.seek(
                              Duration(milliseconds: value.toInt()),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home_filled),
            label: 'Beranda',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Cari'),
          BottomNavigationBarItem(
            icon: Icon(Icons.my_library_music),
            label: 'Pustaka',
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        type: BottomNavigationBarType.fixed,
        selectedFontSize: 12,
        unselectedFontSize: 12,
      ),
    );
  }
}
