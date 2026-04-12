@extends('layouts.app')

@section('title', $song->title . ' — UKM Band')

@section('content')
<div class="container-xxl py-5 fade-in">
    <div class="row g-4">
        <div class="col-lg-4">
            <img src="{{ asset($song->cover_path) }}" class="w-100 rounded-4 shadow-lg" alt="{{ $song->title }}">
        </div>
        <div class="col-lg-8">
            <div class="card-dark p-4 rounded-4 border-dark-700 h-100 d-flex flex-column justify-content-center">
                <div class="d-flex align-items-start justify-content-between flex-wrap gap-2">
                    <div>
                        <h1 class="display-6 fw-bold mb-1">{{ $song->title }}</h1>
                        <h4 class="text-accent mb-0">{{ $song->artist }}</h4>
                    </div>
                    <div class="d-flex gap-2">
                        <form id="like-form-{{ $song->id }}" action="{{ route('songs.like', $song->id) }}" method="POST" onsubmit="handleLike(event, {{ $song->id }})">
                            @csrf
                            @auth
                                @if(Auth::user()->likedSongs->contains($song->id))
                                    <button type="submit" class="btn btn-accent btn-lg" id="like-btn-{{ $song->id }}"><i class="bi bi-heart-fill"></i> <span id="like-count-{{ $song->id }}">{{ $song->likes }}</span></button>
                                @else
                                    <button type="submit" class="btn btn-outline-accent btn-lg" id="like-btn-{{ $song->id }}"><i class="bi bi-heart"></i> <span id="like-count-{{ $song->id }}">{{ $song->likes }}</span></button>
                                @endif
                            @else
                                <a href="{{ route('login') }}" class="btn btn-outline-accent btn-lg"><i class="bi bi-heart"></i> {{ $song->likes }}</a>
                            @endauth
                        </form>
                        @auth
                        <button class="btn btn-outline-accent btn-lg" data-bs-toggle="modal" data-bs-target="#playlistModal"><i class="bi bi-plus-circle"></i> Playlist</button>
                        @endauth
                    </div>
                </div>

                <p class="mt-4 text-dark-200 lead">{{ $song->description }}</p>
                
                <div class="mt-auto pt-5">
                    <button class="btn btn-accent btn-lg px-4 rounded-pill" onclick="playSong({{ $song->id }})">
                        <i class="bi bi-play-fill me-1"></i> Putar Sekarang
                    </button>
                </div>

                <!-- Hidden audio for fallback or if needed, but we use global player now -->
                {{-- <div class="mt-auto pt-4">
                    <audio controls class="w-100 custom-audio">
                        <source src="{{ route('songs.stream', $song->id) }}" type="audio/mpeg">
                        Browser Anda tidak mendukung elemen audio.
                    </audio>
                </div> --}}
            </div>
        </div>
    </div>

    <!-- Comments Section -->
    <div class="row mt-5">
        <div class="col-lg-8 offset-lg-4">
            <h4 class="mb-3">Komentar <!-- Admin Delete Active --></h4>
            
            @auth
            <form action="{{ route('songs.comments.store', $song->id) }}" method="POST" class="mb-4">
                @csrf
                <div class="input-group">
                    <input type="text" name="content" class="form-control form-control-dark" placeholder="Tulis komentar..." required>
                    <button class="btn btn-accent" type="submit"><i class="bi bi-send"></i></button>
                </div>
            </form>
            @else
            <div class="alert alert-dark mb-4">
                Silakan <a href="{{ route('login') }}" class="link-accent">Login</a> atau <a href="{{ route('register') }}" class="link-accent">Register</a> untuk menulis komentar.
            </div>
            @endauth

            <div class="list-group list-group-flush rounded-3 overflow-hidden" id="commentList">
                @forelse($song->comments->where('parent_id', null) as $comment)
                    <!-- Parent Comment -->
                    <div class="list-group-item bg-dark-900 border-dark-700 p-3">
                        <div class="d-flex justify-content-between align-items-center mb-1">
                            <span class="fw-bold text-white">{{ $comment->user->name }}</span>
                            <div class="d-flex align-items-center gap-2">
                                <small class="text-dark-300">{{ $comment->created_at->diffForHumans() }}</small>
                                @auth
                                    @if(Auth::user()->role === 'admin')
                                        <form id="delete-form-{{ $comment->id }}" action="{{ route('comments.destroy', $comment->id) }}" method="POST" class="d-inline">
                                            @csrf
                                            @method('DELETE')
                                            <button type="button" class="btn btn-sm btn-outline-danger p-0 px-1 border-0" title="Hapus Komentar" onclick="showDeleteModal('{{ route('comments.destroy', $comment->id) }}')">
                                                <i class="bi bi-trash"></i>
                                            </button>
                                        </form>
                                    @endif
                                @endauth
                            </div>
                        </div>
                        <p class="mb-2 text-white">{{ $comment->content }}</p>
                        
                        @auth
                            <button class="btn btn-sm btn-link link-accent text-decoration-none p-0 mb-2" onclick="toggleReplyForm({{ $comment->id }})">
                                <i class="bi bi-reply-fill"></i> Balas
                            </button>
                            
                            <!-- Reply Form -->
                            <form action="{{ route('songs.comments.store', $song->id) }}" method="POST" class="mb-3 d-none" id="replyForm-{{ $comment->id }}">
                                @csrf
                                <input type="hidden" name="parent_id" value="{{ $comment->id }}">
                                <div class="input-group input-group-sm">
                                    <input type="text" name="content" class="form-control form-control-dark" placeholder="Tulis balasan..." required>
                                    <button class="btn btn-accent" type="submit"><i class="bi bi-send"></i></button>
                                </div>
                            </form>
                        @endauth

                        <!-- Replies -->
                        @if($comment->replies->count() > 0)
                            <div class="ms-4 border-start border-dark-700 ps-3 mt-2">
                                @foreach($comment->replies as $reply)
                                    <div class="mb-3">
                                        <div class="d-flex justify-content-between align-items-center mb-1">
                                            <span class="fw-bold text-white small">{{ $reply->user->name }}</span>
                                            <div class="d-flex align-items-center gap-2">
                                                <small class="text-dark-300" style="font-size: 0.75rem;">{{ $reply->created_at->diffForHumans() }}</small>
                                                @auth
                                                    @if(Auth::user()->role === 'admin')
                                                        <form id="delete-form-reply-{{ $reply->id }}" action="{{ route('comments.destroy', $reply->id) }}" method="POST" class="d-inline">
                                                            @csrf
                                                            @method('DELETE')
                                                            <button type="button" class="btn btn-sm btn-outline-danger p-0 px-1 border-0" title="Hapus Balasan" style="font-size: 0.75rem;" onclick="showDeleteModal('{{ route('comments.destroy', $reply->id) }}')">
                                                                <i class="bi bi-trash"></i>
                                                            </button>
                                                        </form>
                                                    @endif
                                                @endauth
                                            </div>
                                        </div>
                                        <p class="mb-0 text-dark-200 small">{{ $reply->content }}</p>
                                    </div>
                                @endforeach
                            </div>
                        @endif
                    </div>
                @empty
                    <div class="text-dark-300 py-3 text-center">Belum ada komentar. Jadilah yang pertama!</div>
                @endforelse
            </div>

            <script>
                function toggleReplyForm(commentId) {
                    const form = document.getElementById(`replyForm-${commentId}`);
                    form.classList.toggle('d-none');
                }

                function handleLike(event, songId) {
                    event.preventDefault();
                    const form = document.getElementById(`like-form-${songId}`);
                    const btn = document.getElementById(`like-btn-${songId}`);
                    const countSpan = document.getElementById(`like-count-${songId}`);
                    
                    fetch(form.action, {
                        method: 'POST',
                        body: new FormData(form),
                        headers: {
                            'X-Requested-With': 'XMLHttpRequest',
                            'Accept': 'application/json'
                        }
                    })
                    .then(response => response.json())
                    .then(data => {
                        if (data.success) {
                            countSpan.innerText = data.likes;
                            if (data.status === 'liked') {
                                btn.classList.remove('btn-outline-accent');
                                btn.classList.add('btn-accent');
                                btn.innerHTML = `<i class="bi bi-heart-fill"></i> <span id="like-count-${songId}">${data.likes}</span>`;
                            } else {
                                btn.classList.remove('btn-accent');
                                btn.classList.add('btn-outline-accent');
                                btn.innerHTML = `<i class="bi bi-heart"></i> <span id="like-count-${songId}">${data.likes}</span>`;
                            }
                        }
                    })
                    .catch(error => console.error('Error:', error));
                }

                function showToast(message, isSuccess = true) {
                    const existingToast = document.getElementById('dynamic-toast');
                    if (existingToast) existingToast.remove();

                    const toastHtml = `
                        <div id="dynamic-toast" class="position-fixed bottom-0 end-0 p-3" style="z-index: 9999;">
                            <div class="toast show align-items-center text-white ${isSuccess ? 'bg-success' : 'bg-danger'} border-0" role="alert">
                                <div class="d-flex">
                                    <div class="toast-body">
                                        <i class="bi ${isSuccess ? 'bi-check-circle' : 'bi-x-circle'} me-2"></i>${message}
                                    </div>
                                    <button type="button" class="btn-close btn-close-white me-2 m-auto" onclick="this.closest('#dynamic-toast').remove()"></button>
                                </div>
                            </div>
                        </div>
                    `;
                    document.body.insertAdjacentHTML('beforeend', toastHtml);
                    
                    setTimeout(() => {
                        const toast = document.getElementById('dynamic-toast');
                        if (toast) toast.remove();
                    }, 3000);
                }

                function handlePlaylistSubmit(event, playlistId) {
                    event.preventDefault();
                    const form = event.target;
                    const btn = document.getElementById(`playlist-btn-${playlistId}`);
                    
                    fetch(form.action, {
                        method: 'POST',
                        body: new FormData(form),
                        headers: {
                            'X-Requested-With': 'XMLHttpRequest',
                            'Accept': 'application/json'
                        }
                    })
                    .then(response => response.json())
                    .then(data => {
                        if (data.success) {
                            const badge = btn.querySelector('.badge');
                            if (data.action === 'added') {
                                badge.className = 'badge bg-success';
                                badge.innerHTML = '<i class="bi bi-check"></i> Sudah Ada';
                            } else if (data.action === 'removed') {
                                badge.className = 'badge bg-dark-700';
                                badge.innerHTML = '<i class="bi bi-plus"></i> Tambah';
                            }
                            showToast(data.message, true);
                        } else {
                            showToast(data.message, false);
                        }
                    })
                    .catch(error => {
                        console.error('Error:', error);
                        showToast('Terjadi kesalahan.', false);
                    });
                }

                function handleCreatePlaylist(event) {
                    event.preventDefault();
                    const form = event.target;
                    
                    fetch(form.action, {
                        method: 'POST',
                        body: new FormData(form),
                        headers: {
                            'X-Requested-With': 'XMLHttpRequest',
                            'Accept': 'application/json'
                        }
                    })
                    .then(response => response.json())
                    .then(data => {
                        if (data.success && data.playlist) {
                             let container = document.getElementById('playlist-list-container');
                             let emptyContainer = document.getElementById('empty-playlist-container');
                             
                             if (emptyContainer && !emptyContainer.classList.contains('d-none')) {
                                 emptyContainer.classList.add('d-none');
                                 container.classList.remove('d-none');
                             }

                             const listGroup = document.getElementById('playlist-list-group');
                             const newPlaylistHtml = `
                                <form action="/playlists/${data.playlist.id}" method="POST" onsubmit="handlePlaylistSubmit(event, ${data.playlist.id})">
                                    @csrf
                                    @method('PUT')
                                    <input type="hidden" name="song_id" value="{{ $song->id }}">
                                    <button type="submit" id="playlist-btn-${data.playlist.id}" class="list-group-item list-group-item-action bg-dark-900 border-dark-700 d-flex justify-content-between align-items-center p-3">
                                        <span class="fw-medium text-white">${data.playlist.name}</span>
                                        <span class="badge bg-dark-700"><i class="bi bi-plus"></i> Tambah</span>
                                    </button>
                                </form>
                             `;
                             listGroup.insertAdjacentHTML('beforeend', newPlaylistHtml);
                             
                             form.reset();
                             
                             showToast(data.message, true);
                        } else {
                            showToast(data.message || 'Gagal membuat playlist.', false);
                        }
                    })
                    .catch(error => {
                        console.error('Error:', error);
                        showToast('Terjadi kesalahan.', false);
                    });
                }
            </script>
        </div>
    </div>
</div>

<!-- Spacer to prevent content from being hidden behind the player -->
<div style="height: 120px;"></div>

<!-- Playlist Modal -->
@auth
<div class="modal fade" id="playlistModal" tabindex="-1" aria-hidden="true">
    <div class="modal-dialog modal-dialog-centered">
        <div class="modal-content card-dark">
            <div class="modal-header border-dark-700">
                <h5 class="modal-title"><i class="bi bi-music-note-list me-2"></i>Tambahkan ke Playlist</h5>
                <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <div class="modal-body">
                @if(Auth::user()->playlists->isEmpty())
                    <div id="empty-playlist-container" class="text-center py-4">
                        <i class="bi bi-music-player display-4 text-dark-300 mb-3 d-block"></i>
                        <p class="text-dark-200 mb-3">Anda belum memiliki playlist.</p>
                        <form action="{{ route('playlists.store') }}" method="POST" onsubmit="handleCreatePlaylist(event)">
                            @csrf
                            <input type="hidden" name="song_id" value="{{ $song->id }}">
                            <div class="input-group">
                                <input type="text" name="name" class="form-control form-control-dark" placeholder="Nama Playlist Baru..." required>
                                <button class="btn btn-accent">Buat</button>
                            </div>
                        </form>
                    </div>
                    <div id="playlist-list-container" class="d-none">
                         <p class="text-dark-300 mb-3 small">Pilih playlist untuk menambahkan lagu ini:</p>
                        <div class="list-group list-group-flush rounded-3 overflow-hidden" id="playlist-list-group">
                             <!-- Playlists will be injected here -->
                        </div>
                         <div class="mt-4 pt-3 border-top border-dark-700">
                            <p class="text-dark-300 mb-2 small">Atau buat playlist baru:</p>
                            <form action="{{ route('playlists.store') }}" method="POST" onsubmit="handleCreatePlaylist(event)">
                                @csrf
                                <input type="hidden" name="song_id" value="{{ $song->id }}">
                                <div class="input-group">
                                    <input type="text" name="name" class="form-control form-control-dark" placeholder="Nama Playlist Baru..." required>
                                    <button class="btn btn-accent">Buat</button>
                                </div>
                            </form>
                        </div>
                    </div>
                @else
                    <div id="playlist-list-container">
                        <p class="text-dark-300 mb-3 small">Pilih playlist untuk menambahkan lagu ini:</p>
                        <div class="list-group list-group-flush rounded-3 overflow-hidden" id="playlist-list-group">
                            @foreach(Auth::user()->playlists as $playlist)
                                <form action="{{ route('playlists.update', $playlist->id) }}" method="POST" onsubmit="handlePlaylistSubmit(event, {{ $playlist->id }})">
                                    @csrf
                                    @method('PUT')
                                    <input type="hidden" name="song_id" value="{{ $song->id }}">
                                    <button type="submit" id="playlist-btn-{{ $playlist->id }}" class="list-group-item list-group-item-action bg-dark-900 border-dark-700 d-flex justify-content-between align-items-center p-3">
                                        <span class="fw-medium text-white">{{ $playlist->name }}</span>
                                        @if($playlist->songs->contains($song->id))
                                            <span class="badge bg-success"><i class="bi bi-check"></i> Sudah Ada</span>
                                        @else
                                            <span class="badge bg-dark-700"><i class="bi bi-plus"></i> Tambah</span>
                                        @endif
                                    </button>
                                </form>
                            @endforeach
                        </div>
                        <div class="mt-4 pt-3 border-top border-dark-700">
                            <p class="text-dark-300 mb-2 small">Atau buat playlist baru:</p>
                            <form action="{{ route('playlists.store') }}" method="POST" onsubmit="handleCreatePlaylist(event)">
                                @csrf
                                <input type="hidden" name="song_id" value="{{ $song->id }}">
                                <div class="input-group">
                                    <input type="text" name="name" class="form-control form-control-dark" placeholder="Nama Playlist Baru..." required>
                                    <button class="btn btn-accent">Buat</button>
                                </div>
                            </form>
                        </div>
                    </div>
                @endif
            </div>
        </div>
    </div>
</div>
@endauth

<!-- Delete Confirmation Modal -->
@auth
@if(Auth::user()->role === 'admin')
<div class="modal fade" id="deleteCommentModal" tabindex="-1" aria-hidden="true">
    <div class="modal-dialog modal-dialog-centered modal-sm">
        <div class="modal-content card-dark border-danger">
            <div class="modal-header border-dark-700">
                <h5 class="modal-title text-danger"><i class="bi bi-exclamation-triangle-fill me-2"></i>Konfirmasi Hapus</h5>
                <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <div class="modal-body text-center py-4">
                <i class="bi bi-trash display-4 text-danger mb-3 d-block"></i>
                <p class="text-white mb-0">Apakah Anda yakin ingin menghapus komentar ini?</p>
                <p class="text-dark-300 small">Tindakan ini tidak dapat dibatalkan.</p>
            </div>
            <div class="modal-footer border-dark-700 justify-content-center">
                <button type="button" class="btn btn-outline-secondary" data-bs-dismiss="modal">Batal</button>
                <form id="deleteCommentForm" method="POST">
                    @csrf
                    @method('DELETE')
                    <button type="submit" class="btn btn-danger"><i class="bi bi-trash me-1"></i>Hapus</button>
                </form>
            </div>
        </div>
    </div>
</div>

<script>
    function showDeleteModal(actionUrl) {
        document.getElementById('deleteCommentForm').action = actionUrl;
        new bootstrap.Modal(document.getElementById('deleteCommentModal')).show();
    }
</script>
@endif
@endauth
@endsection
