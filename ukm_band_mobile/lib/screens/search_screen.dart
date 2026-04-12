import 'package:flutter/material.dart';

class SearchScreen extends StatelessWidget {
  const SearchScreen({super.key});

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
                  width: 70, height: 70, color: Colors.grey.withOpacity(0.5),
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
    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.only(left: 16, right: 16, top: 16, bottom: 80),
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
                      errorBuilder: (c, e, s) => const Icon(Icons.person, color: Colors.white, size: 24),
                    ),
                  ),
                  const SizedBox(width: 12),
                  const Text(
                    'Search',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
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
                child: const Row(
                  children: [
                    SizedBox(width: 12),
                    Icon(Icons.search, color: Colors.black54, size: 28),
                    SizedBox(width: 12),
                    Text(
                      'What do you want to listen to?',
                      style: TextStyle(
                        color: Colors.black54,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              const Text(
                'Start browsing',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
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
                   _buildCategoryCard('Music', const Color(0xFFDC148C), 'assets/img/c1.jpg'),
                   _buildCategoryCard('Podcasts', const Color(0xFF006450), 'assets/img/c2.jpg'),
                   _buildCategoryCard('Live Events', const Color(0xFF8400E7), 'assets/img/c3.jpg'),
                   _buildCategoryCard('K-Pop ON!', const Color(0xFF148A08), 'assets/img/c4.jpg'),
                   _buildCategoryCard('New Releases', const Color(0xFFE8115B), 'assets/img/c5.jpg'),
                   _buildCategoryCard('Pop', const Color(0xFF509BF5), 'assets/img/c6.jpg'),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
