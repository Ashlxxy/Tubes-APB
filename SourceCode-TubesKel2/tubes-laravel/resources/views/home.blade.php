@extends('layouts.app')

@section('content')
  <header class="hero container-xxl py-5">
    <div class="row align-items-center g-4">
      <div class="col-lg-7 fade-in">
        <h1 class="display-5 fw-bold lh-1">Temukan dan dengarkan<br><span class="text-accent">UKM Band Universitas Telkom</span></h1>
        <p class="lead text-dark-200 mt-3">Dengarkan lagu, baca deskripsi, simpan ke playlist, dan beri apresiasi.</p>
        <div class="d-flex gap-2 mt-2">
          <a class="btn btn-accent" href="{{ route('songs.index') }}">Lihat Semua Lagu</a>
          <a class="btn btn-outline-accent" href="#popular"><i class="bi bi-fire me-1"></i>Populer</a>
        </div>
      </div>
      <div class="col-lg-5 fade-in" style="animation-delay: 0.2s;">
        @if(isset($latestSong) && $latestSong)
        <a href="{{ route('songs.show', $latestSong->id) }}" class="hero-card p-3 rounded-4 bg-dark-900 border border-dark-700 hover-scale d-block text-decoration-none text-reset">
          <div class="ratio ratio-16x9 rounded-3 bg-dark-800 overflow-hidden">
              <img src="{{ asset($latestSong->cover_path) }}" alt="{{ $latestSong->title }}" class="w-100 h-100 object-fit-cover">
          </div>
          <div class="mt-3">
            <div class="badge bg-accent-soft">Terbaru</div>
            <h4 class="mt-2">{{ $latestSong->title }}</h4>
            <div class="text-dark-200">{{ $latestSong->artist }}</div>
          </div>
        </a>
        @endif
      </div>
    </div>
  </header>

  <main class="container-xxl pb-5">
    <section id="popular" class="mt-4 fade-in" style="animation-delay: 0.4s;">
      <div class="d-flex justify-content-between align-items-end mb-2">
        <h3 class="mb-0">Paling Populer</h3>
        <small class="text-dark-300"><i>Berdasarkan Pemutaran & Like</i></small>
      </div>
      <div class="row g-3">
          @forelse($popularSongs as $song)
          <div class="col-6 col-sm-4 col-md-3 col-lg-2">
            <a href="{{ route('songs.show', $song->id) }}" class="card song p-2 h-100 hover-scale text-decoration-none text-reset d-block">
              <img src="{{ asset($song->cover_path) }}" class="cover w-100 mb-2 rounded" alt="{{ $song->title }}">
              <div class="d-flex flex-column">
                <div class="fw-semibold text-truncate">{{ $song->title }}</div>
                <div class="small text-dark-300 text-truncate">{{ $song->artist }}</div>
                <div class="mt-2 d-flex align-items-center gap-2">
                  <span class="badge badge-soft"><i class="bi bi-play-fill"></i> {{ $song->plays }}</span>
                  <span class="badge bg-accent-soft"><i class="bi bi-heart-fill"></i> {{ $song->likes }}</span>
                </div>
              </div>
            </a>
          </div>
          @empty
          <div class="col-12 text-center text-dark-300 py-5">
              Belum ada lagu yang diunggah.
          </div>
          @endforelse
      </div>
    </section>

    <section id="descriptions" class="mt-5 fade-in" style="animation-delay: 0.6s;">
      <h3 class="mb-4">Deskripsi Lagu</h3>
      <div class="row g-4" id="description-container">
          @forelse($allSongs as $index => $song)
          <div class="col-md-6 col-lg-4 description-item {{ $index >= 6 ? 'd-none' : '' }}">
            <div class="card song p-3 h-100">
              <div class="d-flex align-items-start gap-3">
                <img src="{{ asset($song->cover_path) }}" width="96" height="96" class="rounded-3 object-fit-cover" alt="{{ $song->title }}">
                <div class="flex-fill">
                  <div class="fw-semibold">{{ $song->title }}</div>
                  <div class="small text-dark-200 mb-2">{{ $song->artist }}</div>
                  
                  <div class="description-text">
                      <p class="small text-dark-200 mb-0">{{ $song->description }}</p>
                  </div>
                </div>
              </div>
            </div>
          </div>
          @empty
          <div class="col-12 text-center text-dark-300">
              Belum ada deskripsi lagu.
          </div>
          @endforelse
      </div>
      
      @if($allSongs->count() > 6)
      <div class="text-center mt-4">
          <button id="view-all-descriptions-btn" class="btn btn-outline-accent rounded-pill px-4" onclick="toggleAllDescriptions()">
              Lihat Selengkapnya <i class="bi bi-chevron-down"></i>
          </button>
      </div>
      @endif

      <!-- Spacer to prevent content from being hidden behind the player -->

    </section>
  </main>

<script>
    function toggleAllDescriptions() {
        const hiddenItems = document.querySelectorAll('.description-item.d-none');
        const btn = document.getElementById('view-all-descriptions-btn');
        
        if (hiddenItems.length > 0) {
            hiddenItems.forEach(item => {
                item.classList.remove('d-none');
                item.classList.add('d-block-forced');
            });
            btn.innerHTML = 'Sembunyikan <i class="bi bi-chevron-up"></i>';
        } else {
            const forcedItems = document.querySelectorAll('.description-item.d-block-forced');
            forcedItems.forEach(item => {
                item.classList.add('d-none');
                item.classList.remove('d-block-forced');
            });
            btn.innerHTML = 'Lihat Selengkapnya <i class="bi bi-chevron-down"></i>';
        }
    }
</script>
@endsection
