<?php

namespace App\Http\Controllers;

use App\Models\Song;
use App\Models\History;
use App\Models\Comment;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;

class SongController extends Controller
{
    public function index(Request $request)
    {
        $query = Song::query();

        if ($request->has('q')) {
            $q = $request->q;
            $query->where('title', 'like', "%{$q}%")
                  ->orWhere('artist', 'like', "%{$q}%");
        }

        $songs = $query->latest()->get();

        return view('songs.index', compact('songs'));
    }

    public function show(Song $song)
    {
        return view('songs.show', compact('song'));
    }

    public function recordPlay(Song $song)
    {
        $song->increment('plays');

        if (Auth::check()) {
            $history = History::where('user_id', Auth::id())
                              ->where('song_id', $song->id)
                              ->first();

            if ($history) {
                $history->update(['played_at' => now()]);
            } else {
                History::create([
                    'user_id' => Auth::id(),
                    'song_id' => $song->id,
                    'played_at' => now(),
                ]);
            }
        }

        return response()->json(['success' => true]);
    }

    public function like(Request $request, Song $song)
    {
        $user = Auth::user();

        if ($user->likedSongs()->where('song_id', $song->id)->exists()) {
            $user->likedSongs()->detach($song->id);
            $song->decrement('likes');
            $status = 'unliked';
        } else {
            $user->likedSongs()->attach($song->id);
            $song->increment('likes');
            $status = 'liked';
        }

        if ($request->wantsJson()) {
            return response()->json([
                'success' => true,
                'status' => $status,
                'likes' => $song->likes,
                'message' => $status === 'liked' ? 'Disukai!' : 'Batal menyukai!'
            ]);
        }

        return back()->with('success', $status === 'liked' ? 'Disukai!' : 'Batal menyukai!');
    }

    public function storeComment(Request $request, Song $song)
    {
        $request->validate([
            'content' => 'required|string|max:500',
            'parent_id' => 'nullable|exists:comments,id'
        ]);

        Comment::create([
            'user_id' => Auth::id(),
            'song_id' => $song->id,
            'content' => $request->content,
            'parent_id' => $request->parent_id
        ]);

        return back()->with('success', 'Komentar berhasil ditambahkan!');
    }

    public function destroyComment(Comment $comment)
    {
        if (Auth::user()->role !== 'admin') {
            abort(403, 'Unauthorized action.');
        }

        $comment->delete();

        return back()->with('success', 'Komentar berhasil dihapus!');
    }
    
    public function stream(Song $song)
    {
        // Close the session to prevent blocking other requests while streaming
        session_write_close();

        $path = public_path($song->file_path);

        if (!file_exists($path)) {
            abort(404);
        }

        $fileSize = filesize($path);
        $length = $fileSize;
        $start = 0;
        $end = $fileSize - 1;

        $headers = [
            'Content-Type' => 'audio/mpeg',
            'Accept-Ranges' => 'bytes',
        ];

        if (isset($_SERVER['HTTP_RANGE'])) {
            $c_start = $start;
            $c_end = $end;

            list(, $range) = explode('=', $_SERVER['HTTP_RANGE'], 2);
            if (strpos($range, ',') !== false) {
                $headers['Content-Range'] = "bytes $start-$end/$fileSize";
                return response()->file($path, $headers);
            }

            if ($range == '-') {
                $c_start = $fileSize - substr($range, 1);
            } else {
                $range = explode('-', $range);
                $c_start = $range[0];
                $c_end = (isset($range[1]) && is_numeric($range[1])) ? $range[1] : $end;
            }

            $c_end = ($c_end > $end) ? $end : $c_end;
            if ($c_start > $c_end || $c_start > $fileSize - 1 || $c_end >= $fileSize) {
                return response('', 416);
            }

            $start = $c_start;
            $end = $c_end;
            $length = $end - $start + 1;

            $headers['Content-Length'] = $length;
            $headers['Content-Range'] = "bytes $start-$end/$fileSize";

            $stream = fopen($path, 'rb');
            fseek($stream, $start);
            $content = fread($stream, $length);
            fclose($stream);

            return response($content, 206, $headers);
        }

        $headers['Content-Length'] = $length;
        return response()->file($path, $headers);
    }
}
