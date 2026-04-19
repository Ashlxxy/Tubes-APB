<?php

namespace App\Http\Controllers;

use App\Models\Playlist;
use App\Models\Song;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;

class PlaylistController extends Controller
{
    public function index()
    {
        $playlists = Auth::user()->playlists()->with('songs')->get();
        return view('playlists.index', compact('playlists'));
    }

    public function store(Request $request)
    {
        $request->validate(['name' => 'required']);
        $playlist = Auth::user()->playlists()->create(['name' => $request->name]);
        
        if ($request->wantsJson()) {
            return response()->json([
                'success' => true,
                'message' => 'Playlist berhasil dibuat.',
                'playlist' => $playlist
            ]);
        }

        return back()->with('success', 'Playlist berhasil dibuat.');
    }

    public function update(Request $request, Playlist $playlist)
    {
        if ($playlist->user_id !== Auth::id()) abort(403);
        
        if ($request->has('song_id')) {
            $songExists = $playlist->songs()->where('song_id', $request->song_id)->exists();
            
            if ($songExists) {
                // Song exists - remove it
                $playlist->songs()->detach($request->song_id);
                if ($request->wantsJson()) {
                    return response()->json([
                        'success' => true, 
                        'action' => 'removed',
                        'message' => 'Lagu dihapus dari playlist.'
                    ]);
                }
                return back()->with('success', 'Lagu dihapus dari playlist.');
            } else {
                // Song doesn't exist - add it
                $playlist->songs()->attach($request->song_id);
                if ($request->wantsJson()) {
                    return response()->json([
                        'success' => true, 
                        'action' => 'added',
                        'message' => 'Lagu berhasil ditambahkan ke playlist.'
                    ]);
                }
                return back()->with('success', 'Lagu berhasil ditambahkan ke playlist.');
            }
        }
        
        if ($request->has('remove_song_id')) {
            $playlist->songs()->detach($request->remove_song_id);
             if ($request->wantsJson()) {
                return response()->json(['success' => true, 'message' => 'Lagu dihapus dari playlist.']);
            }
            return back()->with('success', 'Lagu dihapus dari playlist.');
        }

        $playlist->update($request->only('name'));
        if ($request->wantsJson()) {
            return response()->json(['success' => true, 'message' => 'Playlist diperbarui.']);
        }
        return back()->with('success', 'Playlist diperbarui.');
    }

    public function destroy(Playlist $playlist)
    {
        if ($playlist->user_id !== Auth::id()) abort(403);
        $playlist->delete();
        return back()->with('success', 'Playlist berhasil dihapus.');
    }
}
