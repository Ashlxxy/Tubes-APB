@extends('layouts.app')

@section('title', 'Riwayat Pemutaran — UKM Band')

@section('content')
<div class="container-xxl py-4 fade-in">
    <h3 class="mb-4">Riwayat Pemutaran</h3>
    <div class="list-group list-group-flush rounded-4 overflow-hidden">
        @forelse($history as $item)
        <a href="{{ route('songs.show', $item->song->id) }}" class="list-group-item list-group-item-action bg-dark-900 border-dark-700 d-flex justify-content-between align-items-center p-3">
            <div class="d-flex align-items-center gap-3">
                <img src="{{ asset($item->song->cover_path) }}" width="48" height="48" class="rounded object-fit-cover">
                <div>
                    <div class="fw-bold text-white">{{ $item->song->title }}</div>
                    <div class="small text-dark-300">{{ $item->song->artist }}</div>
                </div>
            </div>
            <small class="text-dark-300">{{ $item->played_at }}</small>
        </a>
        @empty
        <div class="text-center text-dark-300 py-5">Belum ada riwayat pemutaran.</div>
        @endforelse
    </div>
</div>
@endsection
