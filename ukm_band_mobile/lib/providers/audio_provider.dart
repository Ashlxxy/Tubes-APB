import 'package:flutter/foundation.dart';
import 'package:audioplayers/audioplayers.dart';
import '../models/song.dart';

class AudioProvider with ChangeNotifier {
  final AudioPlayer _audioPlayer = AudioPlayer();
  Song? _currentSong;
  bool _isPlaying = false;
  Duration _duration = Duration.zero;
  Duration _position = Duration.zero;

  AudioProvider() {
    _audioPlayer.onPlayerStateChanged.listen((state) {
      _isPlaying = state == PlayerState.playing;
      notifyListeners();
    });

    _audioPlayer.onDurationChanged.listen((newDuration) {
      _duration = newDuration;
      notifyListeners();
    });

    _audioPlayer.onPositionChanged.listen((newPosition) {
      _position = newPosition;
      notifyListeners();
    });
  }

  Song? get currentSong => _currentSong;
  bool get isPlaying => _isPlaying;
  Duration get duration => _duration;
  Duration get position => _position;

  void playSong(Song song) async {
    // Assets paths in DB were stored as "assets/songs/Lust.wav".
    // Audioplayers AssetSource removes 'assets/' prefix if you use AssetSource, it assumes the file is inside 'assets/'.
    // Let's sanitize the path: remove leading 'assets/' if present because AssetSource prepends it.
    String sourcePath = song.filePath;
    if (sourcePath.startsWith('assets/')) {
      sourcePath = sourcePath.substring(7); 
    }
    
    // Stop currently playing
    await _audioPlayer.stop();
    
    _currentSong = song;
    notifyListeners();

    try {
      await _audioPlayer.play(AssetSource(sourcePath));
    } catch (e) {
      print('Error playing audio: $e');
    }
  }

  void pause() async {
    await _audioPlayer.pause();
  }

  void resume() async {
    await _audioPlayer.resume();
  }

  void seek(Duration pos) async {
    await _audioPlayer.seek(pos);
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }
}
