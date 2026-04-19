import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ukm_band_mobile/models/song.dart';
import 'package:ukm_band_mobile/services/api_service.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('prefers bundled audio asset before public and protected URLs', () {
    final song = Song(
      id: 1,
      title: 'Lust',
      artist: 'UKM Band',
      description: 'Demo',
      coverPath: 'assets/img/default-cover.jpg',
      filePath: 'assets/songs/Lust.wav',
      audioUrl: 'http://10.0.2.2:8000/assets/songs/Lust.wav',
      streamUrl: 'http://10.0.2.2:8000/api/songs/1/stream',
      plays: 0,
      likes: 0,
    );

    expect(song.playbackUrl, 'assets/songs/Lust.wav');
    expect(song.playbackCandidates, [
      'assets/songs/Lust.wav',
      'http://10.0.2.2:8000/assets/songs/Lust.wav',
      'http://10.0.2.2:8000/api/songs/1/stream',
    ]);
  });

  test('bundled song assets are valid wav files', () {
    for (final path in [
      'assets/songs/Prisoner.wav',
      'assets/songs/Strangled.wav',
      'assets/songs/NewWorld.wav',
      'assets/songs/Langit Kelabu.wav',
      'assets/songs/coral_form.wav',
      'assets/songs/revoir.wav',
      'assets/songs/Lust.wav',
    ]) {
      final bytes = File(path).readAsBytesSync();
      final riff = String.fromCharCodes(bytes.take(4));
      final wave = String.fromCharCodes(bytes.skip(8).take(4));

      expect(riff, 'RIFF', reason: '$path must be a real RIFF audio file');
      expect(wave, 'WAVE', reason: '$path must be a real WAVE audio file');
    }
  });

  test(
    'local-first mode supports auth, playlist, likes, and comments',
    () async {
      SharedPreferences.setMockInitialValues({});
      final apiService = ApiService();

      final auth = await apiService.register(
        name: 'Tester Lokal',
        email: 'tester@example.com',
        password: 'password123',
        passwordConfirmation: 'password123',
      );

      expect(auth.token, startsWith('local:'));
      expect(auth.user.email, 'tester@example.com');

      final songs = await apiService.fetchSongs();
      expect(songs, isNotEmpty);
      expect(songs.first.filePath, startsWith('assets/songs/'));

      final playlist = await apiService.createPlaylist('Latihan Lokal');
      final updatedPlaylist = await apiService.togglePlaylistSong(
        playlistId: playlist.id,
        songId: songs.first.id,
      );

      expect(updatedPlaylist.songs, hasLength(1));
      expect(updatedPlaylist.songs.first.id, songs.first.id);

      final like = await apiService.toggleLike(songs.first.id);
      expect(like.status, 'liked');
      expect(like.likes, greaterThan(songs.first.likes));

      final comment = await apiService.storeComment(
        songId: songs.first.id,
        content: 'Mantap untuk latihan lokal.',
      );
      final comments = await apiService.fetchComments(songs.first.id);

      expect(comment.content, 'Mantap untuk latihan lokal.');
      expect(comments.map((item) => item.id), contains(comment.id));
    },
  );
}
