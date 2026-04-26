<!DOCTYPE html>
<html lang="id">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Masuk & Daftar — UKM Band</title>
    <link rel="icon" type="image/png" href="{{ asset('assets/img/logo.png') }}">
    <!-- Bootstrap & Icons -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;600;700&display=swap" rel="stylesheet">
    
    <!-- App Styles -->
    <link rel="stylesheet" href="{{ asset('css/style.css') }}">
    <!-- Animation Styles -->
    <link rel="stylesheet" href="{{ asset('css/auth-animated.css') }}">
    <style>
        /* Carousel styling to fit overlay */
        .carousel, .carousel-inner, .carousel-item {
            height: 100%;
        }
        .carousel-item img {
            object-fit: cover;
            height: 100%;
            width: 100%;
            filter: brightness(0.6); /* Darken image for text readability */
        }
        .carousel-caption {
            top: 50%;
            transform: translateY(-50%);
            bottom: auto;
        }
        .overlay {
            background: none !important; /* Override gradient to show carousel */
            background-color: #121212 !important;
        }
    </style>
</head>
<body class="auth-body">

    <div class="container-auth {{ session('register_active') || $errors->has('name') || old('name') ? 'active' : '' }}">
        
        <!-- Login Form -->
        <div class="form-box Login">
            <div class="w-100">
                <div class="text-center mb-4">
                    <img src="{{ asset('assets/img/logo.png') }}" alt="Logo" width="50" class="mb-2 rounded-circle">
                    <h2 class="fw-bold text-accent">Selamat Datang Kembali</h2>
                    <p class="text-dark-300 small">Masuk untuk menikmati playlist kamu</p>
                </div>
                <form action="{{ route('login') }}" method="POST">
                    @csrf
                    <div class="mb-3">
                        <label class="form-label text-dark-200">Email</label>
                        <input type="email" class="form-control form-control-dark" name="email" value="{{ old('email') }}" required placeholder="name@example.com">
                        @error('email')
                            <span class="text-danger small mt-1">{{ $message }}</span>
                        @enderror
                    </div>

                    <div class="mb-3">
                        <label class="form-label text-dark-200">Password</label>
                        <input type="password" class="form-control form-control-dark" name="password" required placeholder="••••••••">
                        @error('password')
                            <span class="text-danger small mt-1">{{ $message }}</span>
                        @enderror
                    </div>

                    <div class="d-grid mt-4">
                        <button type="submit" class="btn btn-accent btn-lg">Masuk</button>
                    </div>
                    <div class="text-center mt-3">
                        <a href="{{ route('home') }}" class="link-accent small">Kembali mendengarkan lagu</a>
                    </div>
                </form>
            </div>
        </div>

        <!-- Register Form -->
        <div class="form-box Register">
            <div class="w-100">
                <div class="text-center mb-4">
                    <img src="{{ asset('assets/img/logo.png') }}" alt="Logo" width="50" class="mb-2 rounded-circle">
                    <h2 class="fw-bold text-accent">Selamat Datang</h2>
                    <p class="text-dark-300 small">Daftar untuk mendengarkan lagu favorit kamu</p>
                </div>
                <form action="{{ route('register') }}" method="POST">
                    @csrf
                    <div class="mb-3">
                        <label class="form-label text-dark-200">Nama Lengkap</label>
                        <input type="text" class="form-control form-control-dark" name="name" value="{{ old('name') }}" required placeholder="UKM Band">
                        @error('name')
                            <span class="text-danger small mt-1">{{ $message }}</span>
                        @enderror
                    </div>

                    <div class="mb-3">
                        <label class="form-label text-dark-200">Email</label>
                        <input type="email" class="form-control form-control-dark" name="email" value="{{ old('email') }}" required placeholder="name@example.com">
                        @error('email')
                            <span class="text-danger small mt-1">{{ $message }}</span>
                        @enderror
                    </div>

                    <div class="mb-3">
                        <label class="form-label text-dark-200">Password</label>
                        <input type="password" class="form-control form-control-dark" name="password" required>
                        @error('password')
                            <span class="text-danger small mt-1">{{ $message }}</span>
                        @enderror
                    </div>

                    <div class="mb-3">
                        <label class="form-label text-dark-200">Konfirmasi Password</label>
                        <input type="password" class="form-control form-control-dark" name="password_confirmation" required>
                    </div>

                    <div class="d-grid mt-4">
                        <button type="submit" class="btn btn-accent btn-lg">Daftar</button>
                    </div>
                    <div class="text-center mt-3">
                        <a href="{{ route('home') }}" class="link-accent small">Kembali mendengarkan lagu</a>
                    </div>
                </form>
            </div>
        </div>

        <!-- Overlay Container -->
        <div class="overlay-container">
            <div class="overlay">
                <!-- Carousel Background -->
                <div id="authCarousel" class="carousel slide carousel-fade h-100 w-100 position-absolute top-0 start-0" data-bs-ride="carousel" style="z-index: -1;">
                    <div class="carousel-inner h-100">
                        <div class="carousel-item active h-100">
                            <img src="{{ asset('assets/img/1.png') }}" class="d-block w-100 h-100" alt="Image 1">
                        </div>
                        <div class="carousel-item h-100">
                            <img src="{{ asset('assets/img/2.png') }}" class="d-block w-100 h-100" alt="Image 2">
                        </div>
                        <div class="carousel-item h-100">
                            <img src="{{ asset('assets/img/3.png') }}" class="d-block w-100 h-100" alt="Image 3">
                        </div>
                        <div class="carousel-item h-100">
                            <img src="{{ asset('assets/img/4.png') }}" class="d-block w-100 h-100" alt="Image 4">
                        </div>
                        <div class="carousel-item h-100">
                            <img src="{{ asset('assets/img/5.png') }}" class="d-block w-100 h-100" alt="Image 5">
                        </div>
                    </div>
                </div>

                <!-- Overlay Panels (Text & Buttons) -->
                <div class="overlay-panel overlay-left">
                    <h2 class="fw-bold mb-3">Sudah punya akun?</h2>
                    <p class="mb-4">Masuk kembali untuk mengakses playlist dan lagu favoritmu</p>
                    <button class="btn btn-outline-accent-white btn-lg SignInLink">Masuk di sini</button>
                </div>
                <div class="overlay-panel overlay-right">
                    <h2 class="fw-bold mb-3">Belum punya akun?</h2>
                    <p class="mb-4">Daftar sekarang untuk mulai mendengarkan lagu-lagu UKM Band</p>
                    <button class="btn btn-outline-accent-white btn-lg SignUpLink">Daftar sekarang</button>
                </div>
            </div>
        </div>

    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
    <script src="{{ asset('js/auth-animated.js') }}"></script>

</body>
</html>
