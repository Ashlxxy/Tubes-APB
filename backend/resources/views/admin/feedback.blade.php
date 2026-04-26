@extends('layouts.app')

@section('title', 'Feedback Masuk — UKM Band')

@section('content')
<div class="container-xxl py-4 fade-in">
    <div class="d-flex justify-content-between align-items-center mb-4">
        <h3>Feedback Masuk</h3>
        <a href="{{ route('admin.dashboard') }}" class="btn btn-outline-secondary"><i class="bi bi-arrow-left"></i> Kembali</a>
    </div>

    <div class="list-group list-group-flush rounded-4 overflow-hidden">
        @forelse($feedbacks as $feedback)
        <div class="list-group-item list-group-item-dark p-4">
            <div class="d-flex justify-content-between mb-2">
                <h5 class="mb-0">{{ $feedback->name }}</h5>
                <small class="text-dark-300 timeago" data-timestamp="{{ $feedback->created_at->toIso8601String() }}">{{ $feedback->created_at->diffForHumans() }}</small>
            </div>
            <div class="small text-accent mb-2">{{ $feedback->email }}</div>
            <p class="mb-0 text-dark-200">{{ $feedback->message }}</p>
        </div>
        @empty
        <div class="text-center text-dark-300 py-5">Belum ada feedback masuk.</div>
        @endforelse
    </div>
</div>

<script>
    function updateTimeago() {
        document.querySelectorAll('.timeago').forEach(el => {
            const timestamp = new Date(el.getAttribute('data-timestamp'));
            const now = new Date();
            const diffInSeconds = Math.floor((now - timestamp) / 1000);
            
            let timeString = '';
            if (diffInSeconds < 60) {
                timeString = 'Baru saja';
            } else if (diffInSeconds < 3600) {
                const mins = Math.floor(diffInSeconds / 60);
                timeString = `${mins} menit yang lalu`;
            } else if (diffInSeconds < 86400) {
                const hours = Math.floor(diffInSeconds / 3600);
                timeString = `${hours} jam yang lalu`;
            } else {
                const days = Math.floor(diffInSeconds / 86400);
                if (days < 7) {
                    timeString = `${days} hari yang lalu`;
                } else {
                    timeString = timestamp.toLocaleDateString('id-ID', { day: 'numeric', month: 'short', year: 'numeric', hour: '2-digit', minute: '2-digit' });
                }
            }
            
            el.innerText = timeString;
        });
    }

    setInterval(updateTimeago, 60000);
</script>
@endsection
