-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: localhost
-- Generation Time: Dec 30, 2025 at 06:23 AM
-- Server version: 10.4.32-MariaDB
-- PHP Version: 8.2.12

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `ukm_band`
--

-- --------------------------------------------------------

--
-- Table structure for table `cache`
--

CREATE TABLE `cache` (
  `key` varchar(255) NOT NULL,
  `value` mediumtext NOT NULL,
  `expiration` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `cache_locks`
--

CREATE TABLE `cache_locks` (
  `key` varchar(255) NOT NULL,
  `owner` varchar(255) NOT NULL,
  `expiration` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `comments`
--

CREATE TABLE `comments` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `user_id` bigint(20) UNSIGNED NOT NULL,
  `song_id` bigint(20) UNSIGNED NOT NULL,
  `content` text NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `parent_id` bigint(20) UNSIGNED DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `comments`
--

INSERT INTO `comments` (`id`, `user_id`, `song_id`, `content`, `created_at`, `updated_at`, `parent_id`) VALUES
(1, 1, 1, 'hello', '2025-12-01 00:55:48', '2025-12-01 00:55:48', NULL),
(2, 1, 4, 'hi', '2025-12-01 00:56:08', '2025-12-01 00:56:08', NULL),
(3, 3, 2, 'Cyrus disini', '2025-12-01 07:40:16', '2025-12-01 07:40:16', NULL),
(4, 3, 1, 'yes yes', '2025-12-01 07:55:18', '2025-12-01 07:55:18', NULL),
(5, 1, 7, 'hello', '2025-12-08 08:48:11', '2025-12-08 08:48:11', NULL),
(6, 1, 7, 'hello', '2025-12-08 08:48:16', '2025-12-08 08:48:16', 5),
(12, 1, 2, 'Nilai a amiin', '2025-12-15 20:48:57', '2025-12-15 20:48:57', NULL),
(13, 1, 2, 'iya nilai a kok', '2025-12-15 20:49:10', '2025-12-15 20:49:10', 12),
(14, 6, 1, 'hello', '2025-12-22 08:30:16', '2025-12-22 08:30:16', NULL);

-- --------------------------------------------------------

--
-- Table structure for table `failed_jobs`
--

CREATE TABLE `failed_jobs` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `uuid` varchar(255) NOT NULL,
  `connection` text NOT NULL,
  `queue` text NOT NULL,
  `payload` longtext NOT NULL,
  `exception` longtext NOT NULL,
  `failed_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `feedbacks`
--

CREATE TABLE `feedbacks` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `name` varchar(255) NOT NULL,
  `email` varchar(255) NOT NULL,
  `message` text NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `feedbacks`
--

INSERT INTO `feedbacks` (`id`, `name`, `email`, `message`, `created_at`, `updated_at`) VALUES
(1, 'Faisal Ihsan', 'cyshe@proton.me', 'HELLO ADMIN', '2025-12-01 07:37:48', '2025-12-01 07:37:48'),
(2, 'Administrator', 'admin@ukmband.telkom', 'Nilai A ya kak', '2025-12-15 20:46:29', '2025-12-15 20:46:29');

-- --------------------------------------------------------

--
-- Table structure for table `histories`
--

CREATE TABLE `histories` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `user_id` bigint(20) UNSIGNED NOT NULL,
  `song_id` bigint(20) UNSIGNED NOT NULL,
  `played_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `histories`
--

INSERT INTO `histories` (`id`, `user_id`, `song_id`, `played_at`, `created_at`, `updated_at`) VALUES
(1, 1, 1, '2025-12-22 08:03:48', '2025-12-01 00:54:47', '2025-12-22 08:03:48'),
(2, 1, 1, '2025-12-01 00:54:49', '2025-12-01 00:54:49', '2025-12-01 00:54:49'),
(3, 1, 1, '2025-12-01 00:55:48', '2025-12-01 00:55:48', '2025-12-01 00:55:48'),
(4, 1, 4, '2025-12-15 20:43:13', '2025-12-01 00:56:04', '2025-12-15 20:43:13'),
(5, 1, 4, '2025-12-01 00:56:08', '2025-12-01 00:56:08', '2025-12-01 00:56:08'),
(6, 3, 7, '2025-12-01 07:36:54', '2025-12-01 07:36:54', '2025-12-01 07:36:54'),
(7, 3, 7, '2025-12-01 07:37:21', '2025-12-01 07:37:21', '2025-12-01 07:37:21'),
(8, 3, 7, '2025-12-01 07:37:34', '2025-12-01 07:37:34', '2025-12-01 07:37:34'),
(9, 3, 1, '2025-12-01 07:38:07', '2025-12-01 07:38:07', '2025-12-01 07:38:07'),
(10, 3, 1, '2025-12-01 07:38:13', '2025-12-01 07:38:13', '2025-12-01 07:38:13'),
(11, 3, 2, '2025-12-01 07:38:56', '2025-12-01 07:38:56', '2025-12-01 07:38:56'),
(12, 3, 1, '2025-12-01 07:39:02', '2025-12-01 07:39:02', '2025-12-01 07:39:02'),
(13, 3, 1, '2025-12-01 07:39:05', '2025-12-01 07:39:05', '2025-12-01 07:39:05'),
(14, 3, 1, '2025-12-01 07:39:07', '2025-12-01 07:39:07', '2025-12-01 07:39:07'),
(15, 3, 2, '2025-12-01 07:40:09', '2025-12-01 07:40:09', '2025-12-01 07:40:09'),
(16, 3, 2, '2025-12-01 07:40:16', '2025-12-01 07:40:16', '2025-12-01 07:40:16'),
(17, 3, 2, '2025-12-01 07:40:22', '2025-12-01 07:40:22', '2025-12-01 07:40:22'),
(18, 3, 2, '2025-12-01 07:40:27', '2025-12-01 07:40:27', '2025-12-01 07:40:27'),
(19, 3, 2, '2025-12-01 07:40:28', '2025-12-01 07:40:28', '2025-12-01 07:40:28'),
(20, 3, 2, '2025-12-01 07:40:31', '2025-12-01 07:40:31', '2025-12-01 07:40:31'),
(21, 3, 2, '2025-12-01 07:40:38', '2025-12-01 07:40:38', '2025-12-01 07:40:38'),
(22, 1, 3, '2025-12-08 11:40:00', '2025-12-01 07:41:49', '2025-12-08 11:40:00'),
(23, 1, 3, '2025-12-01 07:41:51', '2025-12-01 07:41:51', '2025-12-01 07:41:51'),
(24, 1, 2, '2025-12-15 20:43:17', '2025-12-01 07:42:12', '2025-12-15 20:43:17'),
(25, 3, 1, '2025-12-01 07:55:13', '2025-12-01 07:55:13', '2025-12-01 07:55:13'),
(26, 3, 1, '2025-12-01 07:55:19', '2025-12-01 07:55:19', '2025-12-01 07:55:19'),
(27, 3, 1, '2025-12-01 07:55:43', '2025-12-01 07:55:43', '2025-12-01 07:55:43'),
(28, 3, 1, '2025-12-01 07:55:45', '2025-12-01 07:55:45', '2025-12-01 07:55:45'),
(29, 3, 2, '2025-12-01 07:55:53', '2025-12-01 07:55:53', '2025-12-01 07:55:53'),
(30, 4, 2, '2025-12-08 03:23:06', '2025-12-08 03:22:52', '2025-12-08 03:23:06'),
(31, 4, 3, '2025-12-08 03:23:01', '2025-12-08 03:23:01', '2025-12-08 03:23:01'),
(32, 2, 7, '2025-12-08 04:24:55', '2025-12-08 04:24:55', '2025-12-08 04:24:55'),
(33, 1, 7, '2025-12-22 08:11:02', '2025-12-08 08:45:27', '2025-12-22 08:11:02'),
(34, 2, 4, '2025-12-08 08:45:34', '2025-12-08 08:45:34', '2025-12-08 08:45:34'),
(35, 1, 6, '2025-12-08 11:29:05', '2025-12-08 10:42:33', '2025-12-08 11:29:05'),
(36, 1, 5, '2025-12-15 20:43:16', '2025-12-08 10:55:55', '2025-12-15 20:43:16'),
(37, 5, 4, '2025-12-15 20:53:34', '2025-12-15 20:53:13', '2025-12-15 20:53:34'),
(38, 6, 7, '2025-12-22 09:28:58', '2025-12-22 08:12:36', '2025-12-22 09:28:58'),
(39, 6, 6, '2025-12-22 09:28:46', '2025-12-22 08:12:48', '2025-12-22 09:28:46'),
(40, 6, 5, '2025-12-22 08:12:55', '2025-12-22 08:12:55', '2025-12-22 08:12:55'),
(41, 6, 1, '2025-12-22 10:49:36', '2025-12-22 08:15:44', '2025-12-22 10:49:36'),
(42, 6, 2, '2025-12-22 09:21:32', '2025-12-22 09:21:32', '2025-12-22 09:21:32'),
(43, 6, 3, '2025-12-22 09:21:46', '2025-12-22 09:21:46', '2025-12-22 09:21:46'),
(44, 6, 4, '2025-12-22 09:21:54', '2025-12-22 09:21:54', '2025-12-22 09:21:54');

-- --------------------------------------------------------

--
-- Table structure for table `jobs`
--

CREATE TABLE `jobs` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `queue` varchar(255) NOT NULL,
  `payload` longtext NOT NULL,
  `attempts` tinyint(3) UNSIGNED NOT NULL,
  `reserved_at` int(10) UNSIGNED DEFAULT NULL,
  `available_at` int(10) UNSIGNED NOT NULL,
  `created_at` int(10) UNSIGNED NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `job_batches`
--

CREATE TABLE `job_batches` (
  `id` varchar(255) NOT NULL,
  `name` varchar(255) NOT NULL,
  `total_jobs` int(11) NOT NULL,
  `pending_jobs` int(11) NOT NULL,
  `failed_jobs` int(11) NOT NULL,
  `failed_job_ids` longtext NOT NULL,
  `options` mediumtext DEFAULT NULL,
  `cancelled_at` int(11) DEFAULT NULL,
  `created_at` int(11) NOT NULL,
  `finished_at` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `migrations`
--

CREATE TABLE `migrations` (
  `id` int(10) UNSIGNED NOT NULL,
  `migration` varchar(255) NOT NULL,
  `batch` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `migrations`
--

INSERT INTO `migrations` (`id`, `migration`, `batch`) VALUES
(1, '0001_01_01_000000_create_users_table', 1),
(2, '0001_01_01_000001_create_cache_table', 1),
(3, '0001_01_01_000002_create_jobs_table', 1),
(4, '2025_11_27_165909_add_role_to_users_table', 1),
(5, '2025_11_27_165909_create_feedbacks_table', 1),
(6, '2025_11_27_165910_create_songs_table', 1),
(7, '2025_11_27_165911_create_playlists_table', 1),
(8, '2025_11_27_165912_create_playlist_song_table', 1),
(9, '2025_11_27_165913_create_histories_table', 1),
(10, '2025_11_27_172151_create_song_user_likes_table', 1),
(11, '2025_11_27_173217_create_comments_table', 1),
(12, '2025_12_08_153955_add_parent_id_to_comments_table', 2);

-- --------------------------------------------------------

--
-- Table structure for table `password_reset_tokens`
--

CREATE TABLE `password_reset_tokens` (
  `email` varchar(255) NOT NULL,
  `token` varchar(255) NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `playlists`
--

CREATE TABLE `playlists` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `user_id` bigint(20) UNSIGNED NOT NULL,
  `name` varchar(255) NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `playlists`
--

INSERT INTO `playlists` (`id`, `user_id`, `name`, `created_at`, `updated_at`) VALUES
(1, 3, 'Buat Galau', '2025-12-01 07:37:59', '2025-12-01 07:37:59'),
(2, 3, 'Aduduh', '2025-12-01 07:38:27', '2025-12-01 07:38:27'),
(4, 1, 'test', '2025-12-08 09:30:20', '2025-12-08 09:30:20'),
(5, 1, 'Galau', '2025-12-08 11:00:40', '2025-12-08 11:00:40'),
(6, 1, 'yesyes', '2025-12-08 11:48:52', '2025-12-08 11:48:52'),
(8, 1, 'test', '2025-12-22 08:11:21', '2025-12-22 08:11:21'),
(10, 6, 'test', '2025-12-22 09:30:49', '2025-12-22 09:30:49');

-- --------------------------------------------------------

--
-- Table structure for table `playlist_song`
--

CREATE TABLE `playlist_song` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `playlist_id` bigint(20) UNSIGNED NOT NULL,
  `song_id` bigint(20) UNSIGNED NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `playlist_song`
--

INSERT INTO `playlist_song` (`id`, `playlist_id`, `song_id`, `created_at`, `updated_at`) VALUES
(1, 1, 1, NULL, NULL),
(2, 2, 1, NULL, NULL),
(4, 2, 2, NULL, NULL),
(5, 4, 2, NULL, NULL),
(6, 4, 5, NULL, NULL),
(7, 4, 4, NULL, NULL),
(9, 4, 7, NULL, NULL),
(10, 5, 7, NULL, NULL),
(11, 6, 7, NULL, NULL),
(12, 8, 7, NULL, NULL);

-- --------------------------------------------------------

--
-- Table structure for table `sessions`
--

CREATE TABLE `sessions` (
  `id` varchar(255) NOT NULL,
  `user_id` bigint(20) UNSIGNED DEFAULT NULL,
  `ip_address` varchar(45) DEFAULT NULL,
  `user_agent` text DEFAULT NULL,
  `payload` longtext NOT NULL,
  `last_activity` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `sessions`
--

INSERT INTO `sessions` (`id`, `user_id`, `ip_address`, `user_agent`, `payload`, `last_activity`) VALUES
('cmT7dMjcRL6JIaC5AQ1qHc9ZihwJoTlTRyUo3gc6', 6, '127.0.0.1', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36', 'YTo0OntzOjY6Il90b2tlbiI7czo0MDoiTkpGUHk2aHp3Z1VtM2xUVENqTHVPNFJIdnhhQ2Fyak1QdDl0Z2dtZCI7czo2OiJfZmxhc2giO2E6Mjp7czozOiJvbGQiO2E6MDp7fXM6MzoibmV3IjthOjA6e319czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6Mjk6Imh0dHA6Ly8xMjcuMC4wLjE6ODAwMC9zb25ncy8xIjtzOjU6InJvdXRlIjtzOjEwOiJzb25ncy5zaG93Ijt9czo1MDoibG9naW5fd2ViXzU5YmEzNmFkZGMyYjJmOTQwMTU4MGYwMTRjN2Y1OGVhNGUzMDk4OWQiO2k6Njt9', 1766425776),
('HMMYMABpkiNXz51XOBGFCrUXkniFUw1inNbRVtjs', NULL, '127.0.0.1', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoidFdUN0VwM0lrZmEzZUtJcGp0cGs5T3FrTU5ralJsOFJUTzJnaGJ1NCI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6Mjk6Imh0dHA6Ly8xMjcuMC4wLjE6ODAwMC9zb25ncy83IjtzOjU6InJvdXRlIjtzOjEwOiJzb25ncy5zaG93Ijt9czo2OiJfZmxhc2giO2E6Mjp7czozOiJvbGQiO2E6MDp7fXM6MzoibmV3IjthOjA6e319fQ==', 1766417209),
('TMBDk2NxiYbh4ES8f7M0IMjf5b0lgDsJUtbisSXV', 1, '127.0.0.1', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36', 'YTo0OntzOjY6Il90b2tlbiI7czo0MDoiTUdTVzg5UXBKWDFxa1hkNmxQTkdUVGExaHc5dEVCUWdRUm1PVzVlbiI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6Mjk6Imh0dHA6Ly8xMjcuMC4wLjE6ODAwMC9zb25ncy83IjtzOjU6InJvdXRlIjtzOjEwOiJzb25ncy5zaG93Ijt9czo2OiJfZmxhc2giO2E6Mjp7czozOiJvbGQiO2E6MDp7fXM6MzoibmV3IjthOjA6e319czo1MDoibG9naW5fd2ViXzU5YmEzNmFkZGMyYjJmOTQwMTU4MGYwMTRjN2Y1OGVhNGUzMDk4OWQiO2k6MTt9', 1766455280),
('xVn4vTCUkscXQL5HasAiZYFX0UvEuFTcyTOYm5V1', NULL, '127.0.0.1', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36', 'YTo0OntzOjY6Il90b2tlbiI7czo0MDoiSlNENGxiOWt1UnU4cVJNWW9FeURxcmpFSjlIRkszSWxpNFJCVW9TQyI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6Mjc6Imh0dHA6Ly8xMjcuMC4wLjE6ODAwMC9sb2dpbiI7czo1OiJyb3V0ZSI7czo1OiJsb2dpbiI7fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fXM6MzoidXJsIjthOjE6e3M6ODoiaW50ZW5kZWQiO3M6Mjk6Imh0dHA6Ly8xMjcuMC4wLjE6ODAwMC9zb25ncy8xIjt9fQ==', 1766417905);

-- --------------------------------------------------------

--
-- Table structure for table `songs`
--

CREATE TABLE `songs` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `title` varchar(255) NOT NULL,
  `artist` varchar(255) NOT NULL,
  `description` text DEFAULT NULL,
  `cover_path` varchar(255) DEFAULT NULL,
  `file_path` varchar(255) NOT NULL,
  `plays` int(11) NOT NULL DEFAULT 0,
  `likes` int(11) NOT NULL DEFAULT 0,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `songs`
--

INSERT INTO `songs` (`id`, `title`, `artist`, `description`, `cover_path`, `file_path`, `plays`, `likes`, `created_at`, `updated_at`) VALUES
(1, 'Lust', 'Bachelor\'s Thrill', 'Lagu penuh energi tentang hasrat, ketertarikan, dan dorongan emosi yang kuat. Menggambarkan sisi menggoda dan impulsif dari hubungan atau perasaan. Intens namun tetap menyenangkan untuk dinikmati.', 'assets/img/c1.jpg', 'assets/songs/Lust.wav', 168, 48, '2025-12-01 00:40:48', '2025-12-22 10:49:36'),
(2, 'FormE', 'Coral', 'Sebuah lagu reflektif tentang pencarian jati diri dan proses perubahan dalam hidup. Nuansanya abstrak namun menenangkan, mengajak pendengar untuk memahami bentuk dan arah baru dalam perjalanan mereka.', 'assets/img/c2.jpg', 'assets/songs/coral_form.wav', 124, 31, '2025-12-01 00:40:48', '2025-12-22 09:21:32'),
(3, 'Strangled', 'Dystopia', 'Sebuah lagu bernuansa intens tentang tekanan, kekacauan, dan rasa tercekik oleh keadaan. Menyampaikan atmosfir dunia yang tidak ideal dan penuh ketegangan, sekaligus menggambarkan perjuangan batin seseorang.', 'assets/img/c3.jpg', 'assets/songs/Strangled.wav', 209, 91, '2025-12-01 00:40:48', '2025-12-22 09:21:46'),
(4, 'Revoir', 'Elisya_au', 'Balada melankolis tentang perpisahan dan kenangan yang tak terlupakan.', 'assets/img/c4.jpg', 'assets/songs/revoir.wav', 166, 61, '2025-12-01 00:40:48', '2025-12-22 09:21:54'),
(5, 'Prisoner', 'Secrets', 'Lagu ini menggambarkan perasaan terkurung oleh pikiran dan rahasia yang selama ini dipendam. Nuansanya emosional dan reflektif, cocok untuk pendengar yang sedang merasa terikat oleh sesuatu yang sulit diungkapkan.', 'assets/img/c5.jpg', 'assets/songs/Prisoner.wav', 112, 40, '2025-12-01 00:40:48', '2025-12-22 08:12:55'),
(6, 'Langit Kelabu', 'The Harper', 'Lagu ini membawa suasana sendu dan melankolis, seperti langit mendung yang mencerminkan hati. Menggambarkan momen kesedihan, kehilangan, atau perasaan yang sulit disampaikan. Cocok untuk merenung dan melepas emosi.', 'assets/img/c6.jpg', 'assets/songs/Langit Kelabu.wav', 120, 55, '2025-12-01 00:40:48', '2025-12-22 09:28:46'),
(7, 'The Overtrain - New World', 'The Overtrain', 'Irama cepat dengan semangat membangun dunia baru yang lebih baik.', 'assets/img/c7.jpg', 'assets/songs/NewWorld.wav', 208, 77, '2025-12-01 00:40:48', '2025-12-22 09:28:58');

-- --------------------------------------------------------

--
-- Table structure for table `song_user_likes`
--

CREATE TABLE `song_user_likes` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `user_id` bigint(20) UNSIGNED NOT NULL,
  `song_id` bigint(20) UNSIGNED NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `song_user_likes`
--

INSERT INTO `song_user_likes` (`id`, `user_id`, `song_id`, `created_at`, `updated_at`) VALUES
(2, 3, 7, '2025-12-01 07:37:21', '2025-12-01 07:37:21'),
(3, 1, 3, '2025-12-01 07:41:50', '2025-12-01 07:41:50'),
(5, 1, 2, '2025-12-08 12:19:38', '2025-12-08 12:19:38'),
(6, 1, 1, '2025-12-15 20:42:12', '2025-12-15 20:42:12'),
(7, 5, 4, '2025-12-15 20:53:20', '2025-12-15 20:53:20'),
(8, 5, 1, '2025-12-15 20:53:45', '2025-12-15 20:53:45'),
(23, 1, 7, '2025-12-22 08:11:10', '2025-12-22 08:11:10'),
(27, 6, 1, '2025-12-22 09:30:46', '2025-12-22 09:30:46');

-- --------------------------------------------------------

--
-- Table structure for table `users`
--

CREATE TABLE `users` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `name` varchar(255) NOT NULL,
  `email` varchar(255) NOT NULL,
  `role` varchar(255) NOT NULL DEFAULT 'user',
  `email_verified_at` timestamp NULL DEFAULT NULL,
  `password` varchar(255) NOT NULL,
  `remember_token` varchar(100) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `users`
--

INSERT INTO `users` (`id`, `name`, `email`, `role`, `email_verified_at`, `password`, `remember_token`, `created_at`, `updated_at`) VALUES
(1, 'Administrator', 'admin@ukmband.telkom', 'admin', NULL, '$2y$12$4Td.VTpzXkrrDrk70Jcm.u2glG5Pf3bhPHuNazU3P2rFP8KC8IB4W', NULL, '2025-12-01 00:40:48', '2025-12-01 00:40:48'),
(2, 'User Demo', 'user@example.com', 'user', NULL, '$2y$12$noHBEdqgxEX6wyFlilAc5.f81HsEUsIPtWqI3WElkuCqU7t.BxUKW', NULL, '2025-12-01 00:40:48', '2025-12-01 00:40:48'),
(3, 'Faisal Ihsan', 'cyshe@proton.me', 'user', NULL, '$2y$12$IFYk3ghYwPi6chfwGZW0.O/clj5Eh/SdBc2/lUKz8Hqm.Fz8RsRWu', NULL, '2025-12-01 07:36:37', '2025-12-01 07:36:37'),
(4, 'Faisal Ihsan', 'faisal@gmail.com', 'user', NULL, '$2y$12$eJlQKfFLYKUfEve1pebRUOhrBIeovF5q1U2W/Y4zrm6OYZO9HTtCC', NULL, '2025-12-08 03:22:40', '2025-12-08 03:22:40'),
(5, 'Nilai A Aja Ya', 'aya@gmail.com', 'user', NULL, '$2y$12$tnPTEsVMmceEtSCsoeogNO8k/XO1voTh4Tce.BzkW6Rc2cwyiuToC', NULL, '2025-12-15 20:50:32', '2025-12-15 20:50:32'),
(6, 'Faisal', 'sal@gmail.com', 'user', NULL, '$2y$12$cpsVkhK4hyiUhY9n4ntXU.ZA4iv15emD/.xQJJSqGfIMHMxRH4yu2', NULL, '2025-12-22 08:11:55', '2025-12-22 08:11:55');

--
-- Indexes for dumped tables
--

--
-- Indexes for table `cache`
--
ALTER TABLE `cache`
  ADD PRIMARY KEY (`key`);

--
-- Indexes for table `cache_locks`
--
ALTER TABLE `cache_locks`
  ADD PRIMARY KEY (`key`);

--
-- Indexes for table `comments`
--
ALTER TABLE `comments`
  ADD PRIMARY KEY (`id`),
  ADD KEY `comments_user_id_foreign` (`user_id`),
  ADD KEY `comments_song_id_foreign` (`song_id`),
  ADD KEY `comments_parent_id_foreign` (`parent_id`);

--
-- Indexes for table `failed_jobs`
--
ALTER TABLE `failed_jobs`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `failed_jobs_uuid_unique` (`uuid`);

--
-- Indexes for table `feedbacks`
--
ALTER TABLE `feedbacks`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `histories`
--
ALTER TABLE `histories`
  ADD PRIMARY KEY (`id`),
  ADD KEY `histories_user_id_foreign` (`user_id`),
  ADD KEY `histories_song_id_foreign` (`song_id`);

--
-- Indexes for table `jobs`
--
ALTER TABLE `jobs`
  ADD PRIMARY KEY (`id`),
  ADD KEY `jobs_queue_index` (`queue`);

--
-- Indexes for table `job_batches`
--
ALTER TABLE `job_batches`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `migrations`
--
ALTER TABLE `migrations`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `password_reset_tokens`
--
ALTER TABLE `password_reset_tokens`
  ADD PRIMARY KEY (`email`);

--
-- Indexes for table `playlists`
--
ALTER TABLE `playlists`
  ADD PRIMARY KEY (`id`),
  ADD KEY `playlists_user_id_foreign` (`user_id`);

--
-- Indexes for table `playlist_song`
--
ALTER TABLE `playlist_song`
  ADD PRIMARY KEY (`id`),
  ADD KEY `playlist_song_playlist_id_foreign` (`playlist_id`),
  ADD KEY `playlist_song_song_id_foreign` (`song_id`);

--
-- Indexes for table `sessions`
--
ALTER TABLE `sessions`
  ADD PRIMARY KEY (`id`),
  ADD KEY `sessions_user_id_index` (`user_id`),
  ADD KEY `sessions_last_activity_index` (`last_activity`);

--
-- Indexes for table `songs`
--
ALTER TABLE `songs`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `song_user_likes`
--
ALTER TABLE `song_user_likes`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `song_user_likes_user_id_song_id_unique` (`user_id`,`song_id`),
  ADD KEY `song_user_likes_song_id_foreign` (`song_id`);

--
-- Indexes for table `users`
--
ALTER TABLE `users`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `users_email_unique` (`email`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `comments`
--
ALTER TABLE `comments`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=16;

--
-- AUTO_INCREMENT for table `failed_jobs`
--
ALTER TABLE `failed_jobs`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `feedbacks`
--
ALTER TABLE `feedbacks`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT for table `histories`
--
ALTER TABLE `histories`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=45;

--
-- AUTO_INCREMENT for table `jobs`
--
ALTER TABLE `jobs`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `migrations`
--
ALTER TABLE `migrations`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=13;

--
-- AUTO_INCREMENT for table `playlists`
--
ALTER TABLE `playlists`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=11;

--
-- AUTO_INCREMENT for table `playlist_song`
--
ALTER TABLE `playlist_song`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=23;

--
-- AUTO_INCREMENT for table `songs`
--
ALTER TABLE `songs`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=8;

--
-- AUTO_INCREMENT for table `song_user_likes`
--
ALTER TABLE `song_user_likes`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=28;

--
-- AUTO_INCREMENT for table `users`
--
ALTER TABLE `users`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `comments`
--
ALTER TABLE `comments`
  ADD CONSTRAINT `comments_parent_id_foreign` FOREIGN KEY (`parent_id`) REFERENCES `comments` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `comments_song_id_foreign` FOREIGN KEY (`song_id`) REFERENCES `songs` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `comments_user_id_foreign` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `histories`
--
ALTER TABLE `histories`
  ADD CONSTRAINT `histories_song_id_foreign` FOREIGN KEY (`song_id`) REFERENCES `songs` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `histories_user_id_foreign` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `playlists`
--
ALTER TABLE `playlists`
  ADD CONSTRAINT `playlists_user_id_foreign` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `playlist_song`
--
ALTER TABLE `playlist_song`
  ADD CONSTRAINT `playlist_song_playlist_id_foreign` FOREIGN KEY (`playlist_id`) REFERENCES `playlists` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `playlist_song_song_id_foreign` FOREIGN KEY (`song_id`) REFERENCES `songs` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `song_user_likes`
--
ALTER TABLE `song_user_likes`
  ADD CONSTRAINT `song_user_likes_song_id_foreign` FOREIGN KEY (`song_id`) REFERENCES `songs` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `song_user_likes_user_id_foreign` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
