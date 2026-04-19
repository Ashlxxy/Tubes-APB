<?php

namespace App\Http\Controllers;

use App\Models\Song;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Storage;

class AdminSongController extends Controller
{
    public function dashboard()
    {
        $songs = Song::all();
        $feedbacks = \App\Models\Feedback::latest()->get();
        return view('admin.dashboard', compact('songs', 'feedbacks'));
    }

    public function index()
    {
        $songs = Song::all();
        return view('admin.songs.index', compact('songs'));
    }

    public function create()
    {
        return view('admin.songs.create');
    }

    public function store(Request $request)
    {
        $request->validate([
            'title' => 'required',
            'artist' => 'required',
            'file' => 'required|file|mimes:mp3,wav,ogg',
            'cover' => 'nullable|image|mimes:jpeg,png,jpg,gif',
        ]);

        $song = new Song();
        $song->title = $request->title;
        $song->artist = $request->artist;
        $song->description = $request->description;

        if ($request->hasFile('file')) {
            $path = $request->file('file')->store('songs', 'public');
            $song->file_path = 'storage/' . $path;
        }

        if ($request->hasFile('cover')) {
            $path = $request->file('cover')->store('covers', 'public');
            $song->cover_path = 'storage/' . $path;
        } else {
            $song->cover_path = 'assets/img/default-cover.jpg';
        }

        $song->save();

        return redirect()->route('admin.dashboard')->with('success', 'Lagu berhasil ditambahkan.');
    }

    public function edit(Song $song)
    {
        return view('admin.songs.edit', compact('song'));
    }

    public function update(Request $request, Song $song)
    {
        $request->validate([
            'title' => 'required',
            'artist' => 'required',
        ]);

        $song->title = $request->title;
        $song->artist = $request->artist;
        $song->description = $request->description;

        if ($request->hasFile('cover')) {
            $path = $request->file('cover')->store('covers', 'public');
            $song->cover_path = 'storage/' . $path;
        }

        $song->save();

        return redirect()->route('admin.dashboard')->with('success', 'Lagu berhasil diupdate.');
    }

    public function destroy(Song $song)
    {
        $song->delete();
        return redirect()->route('admin.dashboard')->with('success', 'Lagu berhasil dihapus.');
    }
}
