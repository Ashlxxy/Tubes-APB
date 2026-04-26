@extends('layouts.app')

@section('title', 'Akses Ditolak — UKM Band')

@section('content')
<div class="container-xxl py-5 fade-in text-center">
    <div class="py-5">
        <h1 class="display-1 fw-bold text-accent mb-4">403</h1>
        <h2 class="mb-4">Akses Ditolak</h2>
        <p class="lead text-dark-200 mb-5">Maaf, Anda tidak memiliki izin untuk mengakses halaman ini.</p>
        <a href="{{ route('home') }}" class="btn btn-accent btn-lg px-5 rounded-pill"><i class="bi bi-house-door me-2"></i> Kembali ke Beranda</a>
    </div>
</div>
@endsection
