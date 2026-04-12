# UKM Band - Aplikasi Musik 

Aplikasi pemutar musik berbasis web yang modern dan dinamis untuk UKM Band Universitas Telkom. Dibangun menggunakan framework **Laravel 10**, aplikasi ini menawarkan pengalaman mendengarkan musik yang interaktif dengan fitur manajemen playlist, like, komentar, dan dashboard admin yang lengkap.

![Dashboard Preview](https://cdn.discordapp.com/attachments/989113082393542668/1444958213232529438/image.png?ex=692e99b4&is=692d4834&hm=110891551047b478bb46990d9c7cc5beb34609f226eb6541daa7ba3756fbee9d&)

## 🚀 Fitur Utama

### 🎵 Fitur Pengguna (User)
*   **Autentikasi Aman**: Sistem login dan register yang aman.
*   **Jelajah Musik**: Temukan lagu terbaru dan populer di halaman utama.
*   **Pemutar Musik Modern**:
    *   Streaming audio tanpa putus.
    *   Fitur seeking (geser durasi) yang responsif.
    *   Kontrol play/pause, next/prev.
*   **Manajemen Playlist**:
    *   Buat playlist pribadi tanpa batas.
    *   Tambahkan lagu ke playlist dengan mudah.
    *   Kelola isi playlist.
*   **Interaksi Sosial**:
    *   **Like**: Simpan lagu favorit Anda.
    *   **Komentar**: Berdiskusi dengan pengguna lain di halaman lagu.
*   **Riwayat Pemutaran**: Akses kembali lagu yang baru saja didengarkan.
*   **Feedback**: Kirim masukan langsung ke pengelola aplikasi.

### 🛡️ Fitur Admin
*   **Dashboard Informatif**: Ringkasan statistik dan daftar lagu.
*   **Manajemen Lagu (CRUD)**:
    *   Upload file audio (MP3) dan cover art.
    *   Edit metadata lagu (Judul, Artis, Deskripsi).
    *   Hapus lagu.
*   **Pusat Feedback**: Baca dan kelola masukan dari pengguna.

---

## 🛠️ Detail Teknis & Teknologi

Aplikasi ini dibangun dengan stack teknologi modern untuk memastikan performa dan kemudahan pengembangan.

### Backend
*   **Framework**: Laravel 10 (PHP 8.2+)
*   **Database**:
    *   *Development*: SQLite (Zero-config)
    *   *Production*: MySQL / MariaDB
*   **Storage**: Local Storage (Symlink)

### Frontend
*   **Templating**: Blade Template Engine
*   **CSS Framework**: Bootstrap 5 (Customized)
*   **Icons**: Bootstrap Icons
*   **JavaScript**: Vanilla JS (untuk Audio Player & Interaksi)

### Struktur Folder Penting
*   `app/Models`: Definisi model database (User, Song, Playlist, Feedback, Comment).
*   `app/Http/Controllers`: Logika bisnis aplikasi (SongController, PlaylistController, AdminSongController).
*   `resources/views`: Tampilan antarmuka pengguna.
*   `database/migrations`: Skema struktur database.
*   `public`: Aset statis (CSS, JS, Gambar, Uploads).

---

## 💻 Instalasi Lokal (Development)

Ikuti langkah ini untuk menjalankan aplikasi di komputer Anda.

### Prasyarat
*   PHP >= 8.1
*   Composer

### Langkah-langkah
1.  **Clone Repository**
    ```bash
    git clone https://github.com/Ashlxxy/Tubes-Kelompok2-WebProPBO.git
    cd tubes-laravel
    ```

2.  **Install Dependensi**
    ```bash
    composer install
    ```

3.  **Setup Environment**
    ```bash
    cp .env.example .env
    php artisan key:generate
    ```

4.  **Setup Database**
    ```bash
    php artisan migrate --seed
    ```
    *Command ini akan membuat database SQLite dan mengisi data dummy.*

5.  **Link Storage**
    ```bash
    php artisan storage:link
    ```

6.  **Jalankan Server**
    ```bash
    php artisan serve
    ```
    Buka `http://127.0.0.1:8000` di browser.

> **Catatan:** Jika mengalami error upload file besar, jalankan server dengan:
> `php -d upload_max_filesize=100M -d post_max_size=100M -S 127.0.0.1:8000 -t public`

---

## 🔑 Akun Demo

| Role | Email | Password |
| :--- | :--- | :--- |
| **Admin** | `admin@ukmband.telkom` | `admin123` |
| **User** | `user@example.com` | `password` |


