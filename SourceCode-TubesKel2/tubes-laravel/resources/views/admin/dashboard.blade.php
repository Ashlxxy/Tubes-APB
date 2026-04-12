@extends('layouts.app')

@section('title', 'Admin Dashboard — UKM Band')

@section('content')
<div class="container-xxl py-4 fade-in">
    <div class="d-flex justify-content-between align-items-center mb-4">
        <h3>Manajemen Lagu</h3>
        <a href="{{ route('admin.songs.create') }}" class="btn btn-accent"><i class="bi bi-plus-lg"></i> Tambah Lagu</a>
    </div>

    <div class="card-dark rounded-4 overflow-hidden">
        <div class="table-responsive">
            <table class="table table-dark table-hover mb-0 align-middle">
                <thead>
                    <tr>
                        <th class="ps-4">#</th>
                        <th>Cover</th>
                        <th>Judul</th>
                        <th>Artis</th>
                        <th>Plays</th>
                        <th>Likes</th>
                        <th class="text-end pe-4">Aksi</th>
                    </tr>
                </thead>
                <tbody>
                    @forelse($songs as $index => $song)
                    <tr>
                        <td class="ps-4">{{ $index + 1 }}</td>
                        <td><img src="{{ asset($song->cover_path) }}" width="48" class="rounded"></td>
                        <td><a href="{{ route('songs.show', $song->id) }}" class="link-accent fw-semibold">{{ $song->title }}</a></td>
                        <td>{{ $song->artist }}</td>
                        <td>{{ $song->plays }}</td>
                        <td>{{ $song->likes }}</td>
                        <td class="text-end pe-4">
                            <div class="btn-group btn-group-sm">
                                <a href="{{ route('admin.songs.edit', $song->id) }}" class="btn btn-outline-accent"><i class="bi bi-pencil"></i></a>
                                <button type="button" class="btn btn-outline-danger" data-bs-toggle="modal" data-bs-target="#deleteSongModal{{ $song->id }}"><i class="bi bi-trash"></i></button>


                            <!-- Delete Modal -->
                            <div class="modal fade" id="deleteSongModal{{ $song->id }}" tabindex="-1" aria-hidden="true">
                                <div class="modal-dialog modal-dialog-centered">
                                    <div class="modal-content card-dark">
                                        <div class="modal-header border-dark-700">
                                            <h5 class="modal-title text-danger"><i class="bi bi-exclamation-triangle-fill me-2"></i>Hapus Lagu?</h5>
                                            <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal" aria-label="Close"></button>
                                        </div>
                                        <div class="modal-body text-start text-wrap" style="white-space: normal;">
                                            <p class="mb-0 text-dark-200">Apakah Anda yakin ingin menghapus lagu <strong>"{{ $song->title }}"</strong> by <strong>{{ $song->artist }}</strong>? Tindakan ini tidak dapat dibatalkan.</p>
                                        </div>
                                        <div class="modal-footer border-dark-700">
                                            <button type="button" class="btn btn-dark" data-bs-dismiss="modal">Batal</button>
                                            <form action="{{ route('admin.songs.destroy', $song->id) }}" method="POST">
                                                @csrf
                                                @method('DELETE')
                                                <button type="submit" class="btn btn-danger">Ya, Hapus</button>
                                            </form>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </td>
                    </tr>
                    @empty
                    <tr>
                        <td colspan="7" class="text-center py-4 text-dark-300">Belum ada lagu.</td>
                    </tr>
                    @endforelse
                </tbody>
            </table>
        </div>
    </div>

    <div class="mt-5">
        <h4 class="mb-3 text-start">Feedback Pengguna</h4>
        <div class="card-dark rounded-4 overflow-hidden">
            <div class="list-group list-group-flush">
                @forelse($feedbacks as $feedback)
                <div class="list-group-item bg-dark-900 border-dark-700 p-4">
                    <div class="d-flex justify-content-between align-items-center mb-1">
                        <h5 class="mb-0 text-white fw-bold">{{ $feedback->name }}</h5>
                        <small class="text-dark-300">{{ $feedback->created_at->format('d M Y, H:i A') }}</small>
                    </div>
                    <div class="small text-dark-300 mb-2">{{ $feedback->email }}</div>
                    <p class="mb-0 text-white">{{ $feedback->message }}</p>
                </div>
                @empty
                <div class="text-center text-dark-300 py-4">Belum ada feedback.</div>
                @endforelse
            </div>
        </div>
    </div>
</div>
@endsection
