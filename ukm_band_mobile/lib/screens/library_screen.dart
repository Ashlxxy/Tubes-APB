import 'package:flutter/material.dart';

class LibraryScreen extends StatelessWidget {
  const LibraryScreen({super.key});

  Widget _buildChip(String label) {
    return Container(
      margin: const EdgeInsets.only(right: 8),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey.shade700),
      ),
      child: Text(
        label,
        style: const TextStyle(fontSize: 13, color: Colors.white),
      ),
    );
  }

  Widget _buildLibraryItem(String title, String subtitle, String imagePath, {bool isCircle = false, bool isGradient = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Container(
            width: double.infinity,
            decoration: BoxDecoration(
              shape: isCircle ? BoxShape.circle : BoxShape.rectangle,
              borderRadius: isCircle ? null : BorderRadius.circular(8),
              gradient: isGradient ? const LinearGradient(
                colors: [Color(0xFF450af5), Color(0xFFc4efd9)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ) : null,
              color: Colors.grey[800],
            ),
            child: ClipRRect(
              borderRadius: isCircle ? BorderRadius.circular(100) : BorderRadius.circular(8),
              child: isGradient 
                ? const Icon(Icons.favorite, color: Colors.white, size: 40)
                : Image.asset(
                    imagePath,
                    fit: BoxFit.cover,
                    errorBuilder: (c, e, s) => const Icon(Icons.music_note, color: Colors.grey, size: 40),
                  ),
            ),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        const SizedBox(height: 2),
        Row(
          children: [
            if (isGradient) const Icon(Icons.push_pin, color: Colors.green, size: 12),
            if (isGradient) const SizedBox(width: 4),
            Expanded(
              child: Text(
                subtitle,
                style: const TextStyle(color: Colors.grey, fontSize: 12),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
              child: Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: Image.asset(
                      'assets/img/default-cover.jpg',
                      width: 32,
                      height: 32,
                      fit: BoxFit.cover,
                      errorBuilder: (c, e, s) => const Icon(Icons.person, color: Colors.white, size: 24),
                    ),
                  ),
                  const SizedBox(width: 12),
                  const Text(
                    'Your Library',
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                  const Spacer(),
                  const Icon(Icons.search, size: 28),
                  const SizedBox(width: 16),
                  const Icon(Icons.add, size: 28),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                physics: const BouncingScrollPhysics(),
                child: Row(
                  children: [
                    _buildChip('Playlists'),
                    _buildChip('Podcasts'),
                    _buildChip('Artists'),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 12),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Icon(Icons.swap_vert, size: 18),
                      SizedBox(width: 8),
                      Text('Recents', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                    ],
                  ),
                  Icon(Icons.grid_view, size: 18),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: GridView.count(
                padding: const EdgeInsets.only(left: 16, right: 16, bottom: 80),
                crossAxisCount: 3,
                childAspectRatio: 0.75,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                physics: const BouncingScrollPhysics(),
                children: [
                  _buildLibraryItem('Liked Songs', 'Playlist • 13 s...', '', isGradient: true),
                  _buildLibraryItem('Bruno Mars', 'Artist', 'assets/img/c1.jpg', isCircle: true),
                  _buildLibraryItem('New Episodes', 'Updated Jan 11...', 'assets/img/c2.jpg'),
                  _buildLibraryItem('CANDYRELLA', 'Playlist • Ashlxy', 'assets/img/c3.jpg'),
                  _buildLibraryItem('Rintik Sedu', 'Podcast • Rintiks...', 'assets/img/c4.jpg'),
                  _buildLibraryItem('MENDOAN', 'Podcast • DONO...', 'assets/img/c5.jpg'),
                  _buildLibraryItem('PODCAST ANCUR', 'Podcast • Patra, ...', 'assets/img/c6.jpg'),
                  _buildLibraryItem('Satu Persen', 'Podcast', 'assets/img/c7.jpg'),
                  _buildLibraryItem('VINIAR', 'Podcast • VOLIX.', 'assets/img/c1.jpg'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
