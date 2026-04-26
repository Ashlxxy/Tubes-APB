<?php

namespace App\Http\Controllers;

use App\Models\History;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;

class HistoryController extends Controller
{
    public function index()
    {
        $history = Auth::user()->history()->with('song')->latest('played_at')->take(100)->get();
        return view('history.index', compact('history'));
    }
}
