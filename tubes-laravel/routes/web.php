<?php

use App\Http\Controllers\AuthController;
use App\Http\Controllers\HomeController;
use App\Http\Controllers\SongController;
use App\Http\Controllers\PlaylistController;
use App\Http\Controllers\HistoryController;
use App\Http\Controllers\FeedbackController;
use App\Http\Controllers\AdminSongController;
use Illuminate\Support\Facades\Route;

Route::get('/', [HomeController::class, 'index'])->name('home');

// Auth
Route::get('/login', [AuthController::class, 'showLogin'])->name('login');
Route::post('/login', [AuthController::class, 'login']);
Route::get('/register', [AuthController::class, 'showRegister'])->name('register');
Route::post('/register', [AuthController::class, 'register']);
Route::post('/logout', [AuthController::class, 'logout'])->name('logout');

// Public Songs
Route::get('/songs', [SongController::class, 'index'])->name('songs.index');
Route::get('/songs/{song}', [SongController::class, 'show'])->name('songs.show');
Route::get('/songs/{song}/stream', [SongController::class, 'stream'])->name('songs.stream');

// User Protected
Route::middleware(['auth'])->group(function () {
    Route::post('/songs/{song}/record-play', [SongController::class, 'recordPlay'])->name('songs.recordPlay');
    Route::post('/songs/{song}/like', [SongController::class, 'like'])->name('songs.like');
    Route::post('/songs/{song}/comments', [SongController::class, 'storeComment'])->name('songs.comments.store');
    Route::delete('/comments/{comment}', [SongController::class, 'destroyComment'])->name('comments.destroy');
    Route::resource('playlists', PlaylistController::class);
    Route::get('/history', [HistoryController::class, 'index'])->name('history.index');
    Route::resource('feedback', FeedbackController::class)->only(['index', 'store']);
});

// Admin Protected
Route::middleware(['auth', 'admin'])->prefix('admin')->name('admin.')->group(function () {
    Route::get('/', [AdminSongController::class, 'dashboard'])->name('dashboard');
    Route::resource('songs', AdminSongController::class);
    Route::get('/feedback', [FeedbackController::class, 'adminIndex'])->name('feedback.index');
});
