<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\Playlist;
use App\Models\Song;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;

class PlaylistController extends Controller
{
    public function index(Request $request): JsonResponse
    {
        $playlists = $request->user()->playlists()->with('songs')->latest()->get();
        $likedSongIds = $request->user()->likedSongs()->pluck('songs.id')->all();

        return response()->json([
            'success' => true,
            'data' => $playlists
                ->map(fn (Playlist $playlist) => $this->playlistPayload($playlist, $likedSongIds))
                ->values(),
        ]);
    }

    public function store(Request $request): JsonResponse
    {
        $validated = $request->validate([
            'name' => ['required', 'string', 'max:255'],
        ]);

        $playlist = $request->user()->playlists()->create([
            'name' => $validated['name'],
        ]);

        return response()->json([
            'success' => true,
            'message' => 'Playlist berhasil dibuat.',
            'data' => $this->playlistPayload($playlist),
        ], 201);
    }

    public function update(Request $request, Playlist $playlist): JsonResponse
    {
        if ($playlist->user_id !== $request->user()->id) {
            return response()->json([
                'success' => false,
                'message' => 'Tidak diizinkan mengubah playlist ini.',
            ], 403);
        }

        $validated = $request->validate([
            'name' => ['nullable', 'string', 'max:255'],
            'song_id' => ['nullable', 'integer', 'exists:songs,id'],
            'remove_song_id' => ['nullable', 'integer', 'exists:songs,id'],
        ]);

        $message = 'Playlist diperbarui.';

        if (array_key_exists('song_id', $validated) && $validated['song_id'] !== null) {
            $songId = $validated['song_id'];
            $alreadyExists = $playlist->songs()->where('song_id', $songId)->exists();

            if ($alreadyExists) {
                $playlist->songs()->detach($songId);
                $message = 'Lagu dihapus dari playlist.';
            } else {
                $playlist->songs()->attach($songId);
                $message = 'Lagu berhasil ditambahkan ke playlist.';
            }
        }

        if (array_key_exists('remove_song_id', $validated) && $validated['remove_song_id'] !== null) {
            $playlist->songs()->detach($validated['remove_song_id']);
            $message = 'Lagu dihapus dari playlist.';
        }

        if (array_key_exists('name', $validated) && $validated['name'] !== null) {
            $playlist->update(['name' => $validated['name']]);
            $message = 'Nama playlist diperbarui.';
        }

        $playlist->load('songs');
        $likedSongIds = $request->user()->likedSongs()->pluck('songs.id')->all();

        return response()->json([
            'success' => true,
            'message' => $message,
            'data' => $this->playlistPayload($playlist, $likedSongIds),
        ]);
    }

    public function destroy(Request $request, Playlist $playlist): JsonResponse
    {
        if ($playlist->user_id !== $request->user()->id) {
            return response()->json([
                'success' => false,
                'message' => 'Tidak diizinkan menghapus playlist ini.',
            ], 403);
        }

        $playlist->delete();

        return response()->json([
            'success' => true,
            'message' => 'Playlist berhasil dihapus.',
        ]);
    }

    private function playlistPayload(Playlist $playlist, array $likedSongIds = []): array
    {
        return [
            'id' => $playlist->id,
            'user_id' => $playlist->user_id,
            'name' => $playlist->name,
            'songs' => $playlist->relationLoaded('songs')
                ? $playlist->songs->map(fn (Song $song) => $this->songPayload($song, $likedSongIds))->values()
                : [],
            'created_at' => $playlist->created_at,
            'updated_at' => $playlist->updated_at,
        ];
    }

    private function songPayload(Song $song, array $likedSongIds = []): array
    {
        return [
            'id' => $song->id,
            'title' => $song->title,
            'artist' => $song->artist,
            'description' => $song->description,
            'cover_path' => $song->cover_path,
            'file_path' => $song->file_path,
            'cover_url' => $this->absoluteUrl($song->cover_path),
            'audio_url' => $this->absoluteUrl($song->file_path),
            'stream_url' => route('api.songs.stream', ['song' => $song->id]),
            'plays' => $song->plays,
            'likes' => $song->likes,
            'is_liked' => in_array($song->id, $likedSongIds, true),
            'created_at' => $song->created_at,
            'updated_at' => $song->updated_at,
        ];
    }

    private function absoluteUrl(?string $path): ?string
    {
        if (!$path) {
            return null;
        }

        if (str_starts_with($path, 'http://') || str_starts_with($path, 'https://')) {
            return $path;
        }

        return url(ltrim($path, '/'));
    }
}
