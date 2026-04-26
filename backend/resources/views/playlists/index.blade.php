@extends('layouts.app')

@section('title', 'Playlist Saya — UKM Band')

@section('content')
<div class="container-xxl py-4 fade-in">
    <div class="d-flex justify-content-between align-items-center mb-4">
        <h3>Playlist Saya</h3>
        <button class="btn btn-accent" data-bs-toggle="modal" data-bs-target="#createPlaylistModal"><i class="bi bi-plus-lg"></i> Buat Playlist</button>
    </div>

    <div class="row g-4">
        @forelse($playlists as $playlist)
        <div class="col-12">
            <div class="card-dark p-4 rounded-4 border-dark-700">
                <div class="d-flex justify-content-between align-items-center mb-4 border-bottom border-dark-700 pb-3">
                    <div class="d-flex align-items-center gap-3">
                        <div class="bg-dark-800 rounded p-3 d-flex align-items-center justify-content-center" style="width: 64px; height: 64px;">
                            <i class="bi bi-music-note-list fs-2 text-accent"></i>
                        </div>
                        <div>
                            <h4 class="mb-0 fw-bold">{{ $playlist->name }}</h4>
                            <small class="text-dark-300">{{ $playlist->songs->count() }} Lagu</small>
                        </div>
                        <button class="btn btn-sm btn-link text-dark-300" data-bs-toggle="modal" data-bs-target="#editPlaylistModal{{ $playlist->id }}">
                            <i class="bi bi-pencil"></i>
                        </button>
                    </div>
                    
                    <div class="d-flex gap-2">
                        @if($playlist->songs->count() > 0)
                        <button class="btn btn-accent" onclick='playPlaylist(@json($playlist->songs))'>
                            <i class="bi bi-play-fill"></i> Putar Playlist
                        </button>
                        @endif
                        <button class="btn btn-danger" data-bs-toggle="modal" data-bs-target="#deletePlaylistModal{{ $playlist->id }}">
                            <i class="bi bi-trash"></i> Hapus Playlist
                        </button>
                    </div>
                </div>

                <div class="list-group list-group-flush rounded-3 overflow-hidden" data-songs="{{ json_encode($playlist->songs) }}">
                    @forelse($playlist->songs as $song)
                    <a href="{{ route('songs.show', $song->id) }}" class="list-group-item list-group-item-action bg-dark-900 border-dark-700 p-3 d-flex justify-content-between align-items-center group-hover container-action text-decoration-none">
                        <div class="d-flex align-items-center gap-3">
                            <img src="{{ asset($song->cover_path) }}" class="rounded object-fit-cover" width="48" height="48">
                            <div>
                                <div class="fw-medium text-white">{{ $song->title }}</div>
                                <div class="small text-dark-300">{{ $song->artist }}</div>
                            </div>
                        </div>
                        
                        <div class="d-flex align-items-center gap-2">
                             <button class="btn btn-sm btn-outline-accent btn-icon rounded-circle" onclick="event.preventDefault(); event.stopPropagation(); var songs = JSON.parse(this.closest('.list-group').dataset.songs); setQueue(songs); playSong({{ $song->id }})">
                                <i class="bi bi-play-fill text-xl"></i>
                            </button>

                            <form action="{{ route('playlists.update', $playlist->id) }}" method="POST" onclick="event.preventDefault(); event.stopPropagation(); this.submit();">
                                @csrf
                                @method('PUT')
                                <input type="hidden" name="remove_song_id" value="{{ $song->id }}">
                                <button type="submit" class="btn btn-sm btn-outline-danger btn-icon rounded-circle" title="Hapus dari playlist">
                                    <i class="bi bi-x-lg"></i>
                                </button>
                            </form>
                        </div>
                    </a>
                    @empty
                    <div class="text-center py-5 text-dark-300 border border-dashed border-dark-700 rounded-3">
                        <i class="bi bi-music-note-beamed fs-1 mb-3 d-block opacity-50"></i>
                        <p class="mb-0">Playlist ini masih kosong.</p>
                        <small>Tambahkan lagu dari halaman Detail Lagu.</small>
                    </div>
                    @endforelse
                </div>
            </div>
        </div>

        <!-- Edit Modal -->
        <div class="modal fade" id="editPlaylistModal{{ $playlist->id }}" tabindex="-1" aria-hidden="true">
            <div class="modal-dialog modal-dialog-centered">
                <div class="modal-content card-dark">
                    <div class="modal-header border-dark-700">
                        <h5 class="modal-title">Ubah Nama Playlist</h5>
                        <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal"></button>
                    </div>
                    <form action="{{ route('playlists.update', $playlist->id) }}" method="POST">
                        @csrf
                        @method('PUT')
                        <div class="modal-body">
                            <input type="text" name="name" class="form-control form-control-dark" value="{{ $playlist->name }}" required>
                        </div>
                        <div class="modal-footer border-dark-700">
                            <button type="submit" class="btn btn-accent">Simpan</button>
                        </div>
                    </form>
                </div>
            </div>
        </div>

        <!-- Delete Modal -->
        <div class="modal fade" id="deletePlaylistModal{{ $playlist->id }}" tabindex="-1" aria-hidden="true">
            <div class="modal-dialog modal-dialog-centered">
                <div class="modal-content card-dark">
                    <div class="modal-header border-dark-700">
                        <h5 class="modal-title">Hapus Playlist?</h5>
                        <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal"></button>
                    </div>
                    <div class="modal-body text-dark-200">
                        Apakah Anda yakin ingin menghapus playlist <strong>{{ $playlist->name }}</strong>? Tindakan ini tidak dapat dibatalkan.
                    </div>
                    <div class="modal-footer border-dark-700">
                        <button type="button" class="btn btn-outline-secondary" data-bs-dismiss="modal">Batal</button>
                        <form action="{{ route('playlists.destroy', $playlist->id) }}" method="POST">
                            @csrf
                            @method('DELETE')
                            <button type="submit" class="btn btn-danger">Hapus</button>
                        </form>
                    </div>
                </div>
            </div>
        </div>

        @empty
        <div class="col-12 text-center text-dark-300 py-5">
            Belum ada playlist, buat playlist sekarang!
        </div>
        @endforelse
    </div>
</div>

<!-- Create Modal -->
<div class="modal fade" id="createPlaylistModal" tabindex="-1" aria-hidden="true">
    <div class="modal-dialog modal-dialog-centered">
        <div class="modal-content card-dark">
            <div class="modal-header border-dark-700">
                <h5 class="modal-title">Buat Playlist Baru</h5>
                <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal"></button>
            </div>
            <form action="{{ route('playlists.store') }}" method="POST">
                @csrf
                <div class="modal-body">
                    <input type="text" name="name" class="form-control form-control-dark" placeholder="Nama Playlist" required>
                </div>
                <div class="modal-footer border-dark-700">
                    <button type="submit" class="btn btn-accent">Buat</button>
                </div>
            </form>
        </div>
    </div>
</div>
@endsection
