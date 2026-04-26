@extends('layouts.app')

@section('title', 'Register — UKM Band')

@section('content')
<div class="container d-flex justify-content-center align-items-center min-vh-100" style="margin-top: -60px;">
    <div class="auth-card card-dark p-4 rounded-4 shadow-lg fade-in">
        <h3 class="text-center mb-4 fw-bold">Register</h3>
        <form action="{{ route('register') }}" method="POST">
            @csrf
            <div class="mb-3">
                <label for="name" class="form-label text-dark-200">Full Name</label>
                <input type="text" class="form-control form-control-dark" id="name" name="name" required autofocus>
            </div>
            <div class="mb-3">
                <label for="email" class="form-label text-dark-200">Email Address</label>
                <input type="email" class="form-control form-control-dark" id="email" name="email" required>
            </div>
            <div class="mb-3">
                <label for="password" class="form-label text-dark-200">Password</label>
                <input type="password" class="form-control form-control-dark" id="password" name="password" required>
            </div>
            <div class="mb-3">
                <label for="password_confirmation" class="form-label text-dark-200">Confirm Password</label>
                <input type="password" class="form-control form-control-dark" id="password_confirmation" name="password_confirmation" required>
            </div>
            <div class="d-grid mt-4">
                <button type="submit" class="btn btn-accent">Register</button>
            </div>
            <div class="text-center mt-3 small text-dark-300">
                Sudah punya akun? <a href="{{ route('login') }}" class="link-accent">Login di sini</a>
            </div>
        </form>
    </div>
</div>
@endsection
