<?php

namespace App\Http\Controllers;

use App\Models\Song;
use Illuminate\Http\Request;

class HomeController extends Controller
{
    public function index()
    {
        $latestSong = Song::latest()->first();
        $popularSongs = Song::orderByRaw('plays + likes DESC')->take(6)->get();
        $allSongs = Song::latest()->get();
        
        return view('home', compact('latestSong', 'popularSongs', 'allSongs'));
    }
}
