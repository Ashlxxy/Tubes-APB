@extends('layouts.app')

@section('title', 'Tambah Lagu — UKM Band')

@section('content')
<div class="container d-flex justify-content-center py-5">
    <div class="card-dark p-4 rounded-4 shadow-lg w-100" style="max-width: 600px;">
        <h3 class="mb-4 fw-bold">Tambah Lagu Baru</h3>
        <form action="{{ route('admin.songs.store') }}" method="POST" enctype="multipart/form-data">
            @csrf
            <div class="mb-3">
                <label class="form-label text-dark-200">Judul Lagu</label>
                <input type="text" name="title" class="form-control form-control-dark" required>
            </div>
            <div class="mb-3">
                <label class="form-label text-dark-200">Artis</label>
                <input type="text" name="artist" class="form-control form-control-dark" required>
            </div>
            <div class="mb-3">
                <label class="form-label text-dark-200">Deskripsi</label>
                <textarea name="description" class="form-control form-control-dark" rows="3"></textarea>
            </div>
            <div class="mb-3">
                <label class="form-label text-dark-200">Cover Image</label>
                <input type="file" name="cover" class="form-control form-control-dark" accept="image/*">
            </div>
            <div class="mb-3">
                <label class="form-label text-dark-200">File Audio</label>
                <input type="file" name="file" class="form-control form-control-dark" accept="audio/*" required>
            </div>
            <div class="d-flex justify-content-end gap-2 mt-4">
                <a href="{{ route('admin.dashboard') }}" class="btn btn-outline-secondary">Batal</a>
                <button type="submit" class="btn btn-accent">Simpan Lagu</button>
            </div>
        </form>
    </div>
</div>
@endsection
