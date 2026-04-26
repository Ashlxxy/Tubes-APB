@extends('layouts.app')

@section('title', 'Edit Lagu — UKM Band')

@section('content')
<div class="container d-flex justify-content-center py-5">
    <div class="card-dark p-4 rounded-4 shadow-lg w-100" style="max-width: 600px;">
        <h3 class="mb-4 fw-bold">Edit Lagu</h3>
        <form action="{{ route('admin.songs.update', $song->id) }}" method="POST" enctype="multipart/form-data">
            @csrf
            @method('PUT')
            <div class="mb-3">
                <label class="form-label text-dark-200">Judul Lagu</label>
                <input type="text" name="title" class="form-control form-control-dark" value="{{ $song->title }}" required>
            </div>
            <div class="mb-3">
                <label class="form-label text-dark-200">Artis</label>
                <input type="text" name="artist" class="form-control form-control-dark" value="{{ $song->artist }}" required>
            </div>
            <div class="mb-3">
                <label class="form-label text-dark-200">Deskripsi</label>
                <textarea name="description" class="form-control form-control-dark" rows="3">{{ $song->description }}</textarea>
            </div>
            <div class="mb-3">
                <label class="form-label text-dark-200">Ganti Cover (Opsional)</label>
                <input type="file" name="cover" class="form-control form-control-dark" accept="image/*">
                <small class="text-dark-300">Biarkan kosong jika tidak ingin mengubah cover.</small>
            </div>
            <div class="d-flex justify-content-end gap-2 mt-4">
                <a href="{{ route('admin.dashboard') }}" class="btn btn-outline-secondary">Batal</a>
                <button type="submit" class="btn btn-accent">Update Lagu</button>
            </div>
        </form>
    </div>
</div>
@endsection
