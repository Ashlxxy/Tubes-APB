@extends('layouts.app')

@section('title', 'Daftar Lagu — UKM Band')

@section('content')
<div class="container-xxl py-4">
    <div class="d-flex justify-content-between align-items-center mb-4">
        <h3 class="mb-0">
            @if(request('q'))
                <i class="bi bi-search me-2"></i>Hasil Pencarian "{{ request('q') }}" ({{ $songs->count() }} hasil)
            @else
                Semua Lagu
            @endif
        </h3>
        @if(request('q'))
            <a href="{{ route('songs.index') }}" class="btn btn-outline-accent">
                <i class="bi bi-collection-play me-1"></i> Lihat Semua
            </a>
        @endif
    </div>

    <div class="row g-3">
        @forelse($songs as $song)
        <div class="col-6 col-sm-4 col-md-3 col-lg-2 fade-in">
            <a href="{{ route('songs.show', $song->id) }}" class="card song p-2 h-100 hover-scale text-decoration-none text-reset d-block">
                <img src="{{ asset($song->cover_path) }}" class="cover w-100 mb-2 rounded" alt="{{ $song->title }}">
                <div class="d-flex flex-column">
                    <div class="fw-semibold text-truncate">{{ $song->title }}</div>
                    <div class="small text-dark-300 text-truncate">{{ $song->artist }}</div>
                    <div class="mt-2 d-flex align-items-center gap-2">
                        <span class="badge badge-soft"><i class="bi bi-play-fill"></i> {{ $song->plays }}</span>
                        @auth
                            <span class="badge {{ Auth::user()->likedSongs->contains($song->id) ? 'bg-accent' : 'bg-accent-soft' }}">
                                <i class="bi {{ Auth::user()->likedSongs->contains($song->id) ? 'bi-heart-fill' : 'bi-heart' }}"></i> {{ $song->likes }}
                            </span>
                        @else
                            <span class="badge bg-accent-soft"><i class="bi bi-heart-fill"></i> {{ $song->likes }}</span>
                        @endauth
                    </div>
                </div>
            </a>
        </div>
        @empty
        <div class="col-12 text-center text-dark-300 py-5">
            Tidak ada lagu ditemukan.
        </div>
        @endforelse
    </div>
</div>
@endsection
