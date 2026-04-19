import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ukm_band_mobile/providers/music_provider.dart';
import 'package:ukm_band_mobile/screens/library_screen.dart';
import 'package:ukm_band_mobile/services/api_service.dart';
import 'package:ukm_band_mobile/theme/app_theme.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('creating playlist from library sheet does not throw', (
    tester,
  ) async {
    SharedPreferences.setMockInitialValues({});
    final apiService = ApiService();
    await apiService.register(
      name: 'Playlist Tester',
      email: 'playlist@example.com',
      password: 'password123',
      passwordConfirmation: 'password123',
    );

    await tester.pumpWidget(
      MultiProvider(
        providers: [
          Provider<ApiService>.value(value: apiService),
          ChangeNotifierProvider<MusicProvider>(
            create: (_) => MusicProvider(apiService),
          ),
        ],
        child: MaterialApp(theme: AppTheme.dark(), home: const LibraryScreen()),
      ),
    );

    await tester.pumpAndSettle();
    await tester.tap(find.byTooltip('Buat playlist'));
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextField).last, 'Set Lokal');
    await tester.tap(find.text('Buat').last);
    await tester.pumpAndSettle();

    expect(tester.takeException(), isNull);
    expect(find.text('Set Lokal'), findsOneWidget);
  });
}
