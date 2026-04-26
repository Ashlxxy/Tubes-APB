<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\History;
use App\Models\Song;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;

class HistoryController extends Controller
{
    public function index(Request $request): JsonResponse
    {
        $history = $request->user()
            ->history()
            ->with('song')
            ->latest('played_at')
            ->take(100)
            ->get();

        $likedSongIds = $request->user()->likedSongs()->pluck('songs.id')->all();

        return response()->json([
            'success' => true,
            'data' => $history->map(function (History $entry) use ($likedSongIds) {
                return [
                    'id' => $entry->id,
                    'user_id' => $entry->user_id,
                    'song_id' => $entry->song_id,
                    'played_at' => $entry->played_at,
                    'song' => $entry->song ? $this->songPayload($entry->song, $likedSongIds) : null,
                ];
            })->values(),
        ]);
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
