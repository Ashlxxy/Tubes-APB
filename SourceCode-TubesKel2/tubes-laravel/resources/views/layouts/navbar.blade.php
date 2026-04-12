<nav class="navbar navbar-expand-lg navbar-dark bg-dark-900 fixed-top border-bottom border-dark-700">
    <div class="container-fluid px-3">
      <a class="navbar-brand fw-bold d-flex align-items-center gap-2" href="{{ route('home') }}">
        <img src="{{ asset('assets/img/logo.png') }}" alt="Logo UKM Band" width="40" height="40" class="rounded-circle">
        <span>UKM Band</span>
      </a>
      <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navMain">
        <span class="navbar-toggler-icon"></span>
      </button>
      <div class="collapse navbar-collapse" id="navMain">
        <form class="ms-lg-3 my-2 my-lg-0 d-flex flex-grow-1" action="{{ route('songs.index') }}" method="GET">
          <span class="input-group">
            <span class="input-group-text bg-dark-800 border-dark-700 text-dark-100"><i class="bi bi-search"></i></span>
            <input class="form-control form-control-dark" name="q" type="search" placeholder="Cari judul lagu atau nama band..." aria-label="Search" value="{{ request('q') }}">
          </span>
        </form>
        <ul class="navbar-nav ms-lg-3 align-items-lg-center">
          <li class="nav-item"><a class="nav-link" href="{{ route('songs.index') }}"><i class="bi bi-collection-play me-1"></i>Daftar Lagu</a></li>
          @auth
            <li class="nav-item"><a class="nav-link" href="{{ route('playlists.index') }}"><i class="bi bi-music-note-list me-1"></i>Playlist</a></li>
            <li class="nav-item"><a class="nav-link" href="{{ route('feedback.index') }}"><i class="bi bi-chat-left-text me-1"></i>Hubungi Kami</a></li>
            <li class="nav-item dropdown ms-lg-2">
                <a class="nav-link btn btn-outline-accent px-3 py-1 rounded-pill dropdown-toggle" href="#" data-bs-toggle="dropdown">
                <i class="bi bi-person-circle me-1"></i><span>{{ Auth::user()->name }}</span>
                </a>
                <ul class="dropdown-menu dropdown-menu-end dropdown-dark">
                <li><a class="dropdown-item" href="{{ route('history.index') }}"><i class="bi bi-clock-history me-2"></i>Riwayat</a></li>
                @if(Auth::user()->role === 'admin')
                    <li><a class="dropdown-item" href="{{ route('admin.dashboard') }}"><i class="bi bi-shield-lock me-2"></i>Admin</a></li>
                @endif
                <li><hr class="dropdown-divider"></li>
                <li>
                    <form action="{{ route('logout') }}" method="POST">
                        @csrf
                        <button type="submit" class="dropdown-item text-danger"><i class="bi bi-box-arrow-right me-2"></i>Logout</button>
                    </form>
                </li>
                </ul>
            </li>
          @else
            <li class="nav-item ms-lg-2 mt-2 mt-lg-0">
                <a href="{{ route('login') }}" class="btn btn-outline-accent btn-sm w-100 w-lg-auto">Login</a>
            </li>
            <li class="nav-item ms-lg-2 mt-2 mt-lg-0">
                <a href="{{ route('register') }}" class="btn btn-accent btn-sm w-100 w-lg-auto">Register</a>
            </li>
          @endauth
        </ul>
      </div>
    </div>
  </nav>
