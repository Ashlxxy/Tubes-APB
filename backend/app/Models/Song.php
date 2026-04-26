<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Factories\HasFactory;

class Song extends Model
{
    use HasFactory;

    protected $fillable = [
        'title', 'artist', 'description', 'cover_path', 'file_path', 'plays', 'likes'
    ];

    public function playlists()
    {
        return $this->belongsToMany(Playlist::class, 'playlist_song');
    }

    public function histories()
    {
        return $this->hasMany(History::class);
    }

    public function likedByUsers()
    {
        return $this->belongsToMany(User::class, 'song_user_likes')->withTimestamps();
    }

    public function comments()
    {
        return $this->hasMany(Comment::class)->latest();
    }
}
