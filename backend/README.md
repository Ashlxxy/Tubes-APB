# UKM Band Backend

Laravel backend/API for the UKM Band mobile application.

## Local Setup

```bash
cd backend
composer install
cp .env.example .env
php artisan key:generate
php artisan migrate --seed
php artisan serve
```

The API runs at `http://127.0.0.1:8000/api` by default. The Flutter app uses `http://10.0.2.2:8000/api` on Android emulator, which maps to the host machine.

## Demo Database

The SQL dump is stored at:

```text
database/dumps/Database-TubesKel2.sql
```

Import it with:

```bash
mysql -u [your_username] -p [your_database_name] < database/dumps/Database-TubesKel2.sql
```

## Main API Areas

- Authentication: register, login, logout, current user
- Songs: list, detail, stream, record play, like, comments
- Playlists: list, create, rename, delete
- History: recently played songs
