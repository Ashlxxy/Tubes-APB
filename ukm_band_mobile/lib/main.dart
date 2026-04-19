import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/auth_provider.dart';
import 'screens/main_shell.dart';
import 'screens/welcome_screen.dart';
import 'services/api_service.dart';
import 'providers/audio_provider.dart';

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
        ChangeNotifierProvider<AudioProvider>(create: (_) => AudioProvider()),
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
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF121212),
        primaryColor: const Color(0xFFE50914), // Telkom Red Accent
        colorScheme: const ColorScheme.dark(
          primary: Color(0xFFE50914),
          secondary: Color(0xFFE50914),
        ),
        bottomNavigationBarTheme: const BottomNavigationBarThemeData(
          backgroundColor: Color(0xFF282828),
          selectedItemColor: Colors.white,
          unselectedItemColor: Colors.grey,
        ),
      ),
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
