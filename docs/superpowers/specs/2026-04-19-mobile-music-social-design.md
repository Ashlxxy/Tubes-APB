# Mobile Music Social Design

## Context

The Laravel web app in `SourceCode-TubesKel2/tubes-laravel` is the visual and behavioral reference. The mobile app in `ukm_band_mobile` is the primary deliverable. The goal is to keep the web app's dark Spotify-like Telkom-red music layout while making the Flutter app fully usable on phones.

## Assumptions

- Recommended path is accepted without waiting for additional decisions.
- Laravel remains the API/reference layer and Flutter is the mobile client.
- The mobile app should work with bundled assets first when possible, then fall back to public Laravel URLs.
- Authenticated API features are required for playlists, likes, comments, and history.
- Sleek remote generation is skipped because `SLEEK_API_KEY` is not available in the environment.

## Design Direction

The mobile aesthetic is a dark "studio deck" with Telkom red accents, warm cream text, glassy dark cards, bold cover art, and persistent playback controls. It preserves the Laravel hierarchy: hero/latest song, popular songs, song descriptions, playlist management, and song detail pages with likes/comments.

## UX Requirements

- Music playback must start from home, search, library, and detail screens.
- Playback must prefer playable local/public audio sources over protected stream endpoints.
- A persistent mini-player must expose play/pause, previous/next, seek progress, and playback errors.
- Playlists must be visible, creatable, renameable, deletable, playable, and able to add/remove songs.
- Likes must be visible and togglable from song cards, search rows, and detail screens.
- Comments must be readable and postable from song detail screens, including replies and deletion for owners/admins.
- Touch targets should be at least 44dp, actions should have visible feedback, and content must avoid being hidden by the mini-player or bottom navigation.

## Implementation Plan

- Add a `MusicProvider` as the shared source of truth for songs, playlists, history, and optimistic like state.
- Extend `ApiService` with playlist CRUD/toggle methods and typed comment models.
- Add `SongComment` and playlist/song copy helpers for safe state replacement.
- Replace duplicated artwork loading with reusable `SongArtwork` and `AppGlassCard` widgets.
- Add `SongDetailScreen` for play, like, playlist, description, comments, replies, and delete actions.
- Refactor home/search/library screens to use `MusicProvider` and preserve state through `IndexedStack`.
- Update global dark theme tokens and Material 3 component styling.
- Validate with `flutter pub get`, `dart format`, `flutter analyze`, `flutter test`, and Android debug build.

## Enhanced Mobile Prompt

A mobile-first UKM Band music streaming app with a dark Telkom-red studio deck aesthetic, built around fast playback, playlist ownership, likes, and comments.

**DESIGN SYSTEM (REQUIRED):**
- Platform: Mobile, Android-first Flutter app
- Theme: Dark, immersive, music-first, social, glassy studio cards
- Background: Stage Black (#090A0D) with Telkom Red gradient haze (#4A0E17)
- Primary Accent: Telkom Red (#E50914) for play, like, and primary actions
- Hot Accent: Signal Red (#FF4D57) for active states and feedback
- Surface: Charcoal Card (#191B22) for song cards, playlist cards, comments, and mini-player
- Surface Raised: Soft Charcoal (#22242C) for inputs and nested rows
- Text Primary: Warm Cream (#FFF4E8)
- Text Secondary: Muted Silver (#ADB0BB)
- Interaction: Minimum 44dp touch targets, visible pressed feedback, bottom sheets for playlist and comment actions

**Screen Structure:**
1. **Welcome/Auth:** Bold logo, dark gradient, primary login/register actions, validated forms.
2. **Home:** Greeting, latest song hero, user's playlists, popular songs, latest songs, song descriptions.
3. **Search:** Mobile search field, filtered song list, play and like actions.
4. **Library:** Playlist CRUD, play playlist, remove songs, recent history.
5. **Song Detail:** Cover art, play CTA, like, add to playlist, description, comment composer, replies.
6. **Persistent Player:** Mini-player above bottom navigation with queue controls and seek progress.

## Self Review

- No unresolved placeholders remain.
- Scope is focused on the mobile music/social feature set.
- Architecture keeps UI, state, API, and reusable widgets separated.
- Error paths are explicit for API failures and playback failures.
