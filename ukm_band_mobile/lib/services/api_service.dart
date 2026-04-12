import '../models/song.dart';
import '../models/playlist.dart';

class ApiService {
  // Use 10.0.2.2 for Android emulator to access localhost
  static const String baseUrl = 'http://10.0.2.2:8000/api';

  Future<List<Song>> fetchSongs() async {
    // Returning mock data for UI display since Laravel API server cannot be started currently.
    await Future.delayed(const Duration(milliseconds: 500));
    return [
      Song(
        id: 1,
        title: 'Lust',
        artist: 'Bachelor\'s Thrill',
        description: '',
        coverPath: 'assets/img/c1.jpg',
        filePath: 'assets/songs/Lust.wav',
        plays: 168,
        likes: 48,
      ),
      Song(
        id: 2,
        title: 'FormE',
        artist: 'Coral',
        description: '',
        coverPath: 'assets/img/c2.jpg',
        filePath: 'assets/songs/coral_form.wav',
        plays: 124,
        likes: 31,
      ),
      Song(
        id: 3,
        title: 'Strangled',
        artist: 'Dystopia',
        description: '',
        coverPath: 'assets/img/c3.jpg',
        filePath: 'assets/songs/Strangled.wav',
        plays: 209,
        likes: 91,
      ),
      Song(
        id: 4,
        title: 'Revoir',
        artist: 'Elisya_au',
        description: '',
        coverPath: 'assets/img/c4.jpg',
        filePath: 'assets/songs/revoir.wav',
        plays: 166,
        likes: 61,
      ),
    ];
  }

  Future<List<Playlist>> fetchPlaylists() async {
    await Future.delayed(const Duration(milliseconds: 500));
    return [
      Playlist(id: 1, userId: 1, name: 'Buat Galau'),
      Playlist(id: 2, userId: 1, name: 'Aduduh'),
      Playlist(id: 3, userId: 1, name: 'test'),
      Playlist(id: 4, userId: 1, name: 'Top Hits'),
      Playlist(id: 5, userId: 1, name: 'My Liked Songs'),
      Playlist(id: 6, userId: 1, name: 'Indie Vibes'),
    ];
  }
}
