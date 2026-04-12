<?php

namespace Database\Seeders;

use App\Models\User;
use App\Models\Song;
use Illuminate\Database\Seeder;
use Illuminate\Support\Facades\Hash;

class DatabaseSeeder extends Seeder
{
    public function run(): void
    {
        // Create Admin
        User::create([
            'name' => 'Administrator',
            'email' => 'admin@ukmband.telkom',
            'password' => Hash::make('admin123'),
            'role' => 'admin',
        ]);

        // Create User
        User::create([
            'name' => 'User Demo',
            'email' => 'user@example.com',
            'password' => Hash::make('password'),
            'role' => 'user',
        ]);

        // Seed Songs
        $songs = [
            [
                'title' => 'Prisoner',
                'artist' => "Secrets",
                'description' => "Lagu ini menggambarkan perasaan terkurung oleh pikiran dan rahasia yang selama ini dipendam. Nuansanya emosional dan reflektif, cocok untuk pendengar yang sedang merasa terikat oleh sesuatu yang sulit diungkapkan.",
                'cover_path' => 'assets/img/c5.jpg',
                'file_path' => 'assets/songs/Prisoner.wav',
                'plays' => 120,
                'likes' => 45,
            ],
            [
                'title' => 'Strangled',
                'artist' => 'Dystopia',
                'description' => "Sebuah lagu bernuansa intens tentang tekanan, kekacauan, dan rasa tercekik oleh keadaan. Menyampaikan atmosfir dunia yang tidak ideal dan penuh ketegangan, sekaligus menggambarkan perjuangan batin seseorang.",
                'cover_path' => 'assets/img/c3.jpg',
                'file_path' => 'assets/songs/Strangled.wav',
                'plays' => 200,
                'likes' => 90,
            ],
            [
                'title' => 'New World',
                'artist' => 'The Overtrain',
                'description' => "Lagu ini bercerita tentang perjalanan menuju perubahan dan awal yang baru. Ada semangat, harapan, dan dorongan untuk meninggalkan masa lalu. Cocok untuk pendengar yang sedang memasuki fase baru dalam hidup.",
                'cover_path' => 'assets/img/c7.jpg',
                'file_path' => 'assets/songs/NewWorld.wav',
                'plays' => 180,
                'likes' => 75,
            ],
            [
                'title' => 'Langit Kelabu',
                'artist' => 'The Harper',
                'description' => "Lagu ini membawa suasana sendu dan melankolis, seperti langit mendung yang mencerminkan hati. Menggambarkan momen kesedihan, kehilangan, atau perasaan yang sulit disampaikan. Cocok untuk merenung dan melepas emosi.",
                'cover_path' => 'assets/img/c6.jpg',
                'file_path' => 'assets/songs/Langit Kelabu.wav',
                'plays' => 110,
                'likes' => 55,
            ],
            [
                'title' => 'Form',
                'artist' => 'Coral',
                'description' => "Sebuah lagu reflektif tentang pencarian jati diri dan proses perubahan dalam hidup. Nuansanya abstrak namun menenangkan, mengajak pendengar untuk memahami bentuk dan arah baru dalam perjalanan mereka.",
                'cover_path' => 'assets/img/c2.jpg',
                'file_path' => 'assets/songs/coral_form.wav',
                'plays' => 85,
                'likes' => 30,
            ],
            [
                'title' => 'Au Revoir',
                'artist' => 'Elisya',
                'description' => "Lagu ini menggambarkan perpisahan yang lembut namun penuh makna. Ada kesedihan, keikhlasan, dan harapan yang terselip dalam setiap kata. Cocok untuk pendengar yang sedang merelakan atau menutup bab lama dalam hidup.",
                'cover_path' => 'assets/img/c4.jpg',
                'file_path' => 'assets/songs/revoir.wav',
                'plays' => 150,
                'likes' => 60,
            ],
            [
                'title' => 'Lust',
                'artist' => "Bachelor's Thrill",
                'description' => "Lagu penuh energi tentang hasrat, ketertarikan, dan dorongan emosi yang kuat. Menggambarkan sisi menggoda dan impulsif dari hubungan atau perasaan. Intens namun tetap menyenangkan untuk dinikmati.",
                'cover_path' => 'assets/img/c1.jpg',
                'file_path' => 'assets/songs/Lust.wav',
                'plays' => 120,
                'likes' => 45,
            ],
        ];

        foreach ($songs as $song) {
            Song::create($song);
        }
    }
}
