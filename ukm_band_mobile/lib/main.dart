import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/auth_provider.dart';
import 'providers/music_provider.dart';
import 'screens/main_shell.dart';
import 'screens/welcome_screen.dart';
import 'services/api_service.dart';
import 'providers/audio_provider.dart';
import 'theme/app_theme.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        Provider<ApiService>(create: (_) => ApiService()),
        ChangeNotifierProvider<AuthProvider>(
          create: (context) {
            final authProvider = AuthProvider(context.read<ApiService>());
            authProvider.initialize();
            return authProvider;
          },
        ),
        ChangeNotifierProvider<MusicProvider>(
          create: (context) => MusicProvider(context.read<ApiService>()),
        ),
        ChangeNotifierProxyProvider<MusicProvider, AudioProvider>(
          create: (_) => AudioProvider(),
          update: (_, music, audio) {
            audio ??= AudioProvider();
            audio.onSongPlayed = music.recordPlay;
            return audio;
          },
        ),
      ],
      child: const UKMBandApp(),
    ),
  );
}

class UKMBandApp extends StatelessWidget {
  const UKMBandApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'UKM Band Telkom',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.dark(),
      home: const AuthGate(),
    );
  }
}

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(
      builder: (context, auth, _) {
        if (!auth.isInitialized) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        if (auth.isAuthenticated) {
          return const MainShell();
        }

        return const WelcomeScreen();
      },
    );
  }
}
