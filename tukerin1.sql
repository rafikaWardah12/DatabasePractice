-- --------------------------------------------------------
-- Host:                         127.0.0.1
-- Server version:               8.0.30 - MySQL Community Server - GPL
-- Server OS:                    Win64
-- HeidiSQL Version:             12.1.0.6537
-- --------------------------------------------------------

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET NAMES utf8 */;
/*!50503 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

-- Dumping structure for table tukerin.bids
DROP TABLE IF EXISTS `bids`;
CREATE TABLE IF NOT EXISTS `bids` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `user_id` bigint unsigned NOT NULL COMMENT 'User yang mengajukan tawaran',
  `product_id` bigint unsigned NOT NULL COMMENT 'Barang yang ingin dibarter',
  `user_pemilik` bigint unsigned NOT NULL,
  `product_barter` bigint unsigned NOT NULL COMMENT 'Barang yang dipilih user',
  `harga_tambah` int DEFAULT NULL,
  `status` tinyint(1) NOT NULL DEFAULT '0' COMMENT '0 = Menunggu, 1 = Barter, 2 = Tidak disetujui',
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `bids_user_pemilik_foreign` (`user_pemilik`),
  CONSTRAINT `bids_user_pemilik_foreign` FOREIGN KEY (`user_pemilik`) REFERENCES `users` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Dumping data for table tukerin.bids: ~0 rows (approximately)

-- Dumping structure for table tukerin.categories
DROP TABLE IF EXISTS `categories`;
CREATE TABLE IF NOT EXISTS `categories` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Dumping data for table tukerin.categories: ~3 rows (approximately)
REPLACE INTO `categories` (`id`, `name`, `created_at`, `updated_at`) VALUES
	(1, 'komputer', '2023-07-11 19:19:04', '2023-07-11 19:19:04'),
	(2, 'otomotif', '2023-07-11 19:19:04', '2023-07-11 19:19:04'),
	(3, 'pakaian', '2023-07-11 19:19:04', '2023-07-11 19:19:04');

-- Dumping structure for table tukerin.deposits
DROP TABLE IF EXISTS `deposits`;
CREATE TABLE IF NOT EXISTS `deposits` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `user_id` bigint unsigned NOT NULL,
  `nominal` int NOT NULL,
  `status` tinyint(1) NOT NULL DEFAULT '0' COMMENT '0 = Belum disetujui, 1 = Sudah disetujui ',
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Dumping data for table tukerin.deposits: ~0 rows (approximately)

-- Dumping structure for table tukerin.failed_jobs
DROP TABLE IF EXISTS `failed_jobs`;
CREATE TABLE IF NOT EXISTS `failed_jobs` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `uuid` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `connection` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `queue` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `payload` longtext COLLATE utf8mb4_unicode_ci NOT NULL,
  `exception` longtext COLLATE utf8mb4_unicode_ci NOT NULL,
  `failed_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `failed_jobs_uuid_unique` (`uuid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Dumping data for table tukerin.failed_jobs: ~0 rows (approximately)

-- Dumping structure for function tukerin.getBarangYangTelahDibarter
DROP FUNCTION IF EXISTS `getBarangYangTelahDibarter`;
DELIMITER //
CREATE FUNCTION `getBarangYangTelahDibarter`(user_id BIGINT) RETURNS bigint
    DETERMINISTIC
BEGIN
    DECLARE produkYangTelahDibarter BIGINT(20);
    
    SELECT COUNT(*) INTO produkYangTelahDibarter
    FROM users u
    LEFT JOIN products p ON u.id = p.user_id
    WHERE p.user_id = user_id  AND p.status_barter = 1;
    
    RETURN produkYangTelahDibarter;
END//
DELIMITER ;

-- Dumping structure for function tukerin.getProduk
DROP FUNCTION IF EXISTS `getProduk`;
DELIMITER //
CREATE FUNCTION `getProduk`(user_id BIGINT) RETURNS bigint
    DETERMINISTIC
BEGIN
    DECLARE produkUser BIGINT;
    SELECT COUNT(*) INTO produkUser
    FROM products p
    INNER JOIN bids b ON b.product_id = p.id
    WHERE b.user_id = user_id;
    RETURN produkUser;
END//
DELIMITER ;

-- Dumping structure for function tukerin.getProdukDitawarkan
DROP FUNCTION IF EXISTS `getProdukDitawarkan`;
DELIMITER //
CREATE FUNCTION `getProdukDitawarkan`(user_id BIGINT) RETURNS bigint
    DETERMINISTIC
BEGIN
    DECLARE produkDitawarkan BIGINT(20);
    
    SELECT COUNT(*) INTO produkDitawarkan
    FROM users u
    LEFT JOIN products p ON u.id = p.user_id
    WHERE p.user_id = user_id AND p.status_barter=0;
    
    RETURN produkDitawarkan;
END//
DELIMITER ;

-- Dumping structure for view tukerin.history_user
DROP VIEW IF EXISTS `history_user`;
-- Creating temporary table to overcome VIEW dependency errors
CREATE TABLE `history_user` (
	`userId` BIGINT(20) UNSIGNED NOT NULL COMMENT 'User yang mengajukan tawaran',
	`nama` VARCHAR(255) NULL COLLATE 'utf8mb4_unicode_ci',
	`status` TINYINT(1) NOT NULL COMMENT '0 = Menunggu, 1 = Barter, 2 = Tidak disetujui',
	`barangDipesan` TEXT NULL COLLATE 'utf8mb4_unicode_ci',
	`jumlahBarangYangDiajukan` DECIMAL(23,0) NULL,
	`jumlahBarangDisetujui` DECIMAL(23,0) NULL,
	`jumlahBarangDitolak` DECIMAL(23,0) NULL
) ENGINE=MyISAM;

-- Dumping structure for view tukerin.jumlah_barang_status_user
DROP VIEW IF EXISTS `jumlah_barang_status_user`;
-- Creating temporary table to overcome VIEW dependency errors
CREATE TABLE `jumlah_barang_status_user` (
	`user_id` BIGINT(20) UNSIGNED NOT NULL,
	`namaPemilik` VARCHAR(255) NOT NULL COLLATE 'utf8mb4_unicode_ci',
	`namaProduk` VARCHAR(255) NULL COLLATE 'utf8mb4_unicode_ci',
	`statusProduk` VARCHAR(13) NOT NULL COLLATE 'utf8mb4_0900_ai_ci'
) ENGINE=MyISAM;

-- Dumping structure for table tukerin.laporans
DROP TABLE IF EXISTS `laporans`;
CREATE TABLE IF NOT EXISTS `laporans` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `bid_id` bigint unsigned NOT NULL,
  `user_yang_dilaporkan` bigint unsigned NOT NULL,
  `user_id` bigint unsigned NOT NULL,
  `alasan` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Dumping data for table tukerin.laporans: ~0 rows (approximately)

-- Dumping structure for table tukerin.migrations
DROP TABLE IF EXISTS `migrations`;
CREATE TABLE IF NOT EXISTS `migrations` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `migration` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `batch` int NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=23 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Dumping data for table tukerin.migrations: ~11 rows (approximately)
REPLACE INTO `migrations` (`id`, `migration`, `batch`) VALUES
	(12, '2014_10_12_000000_create_users_table', 1),
	(13, '2014_10_12_100000_create_password_reset_tokens_table', 1),
	(14, '2014_10_12_100000_create_password_resets_table', 1),
	(15, '2019_08_19_000000_create_failed_jobs_table', 1),
	(16, '2019_12_14_000001_create_personal_access_tokens_table', 1),
	(17, '2023_06_27_155720_create_products_table', 1),
	(18, '2023_06_27_160306_create_categories_table', 1),
	(19, '2023_06_27_161424_create_bids_table', 1),
	(20, '2023_06_29_025230_create_laporans_table', 1),
	(21, '2023_07_04_002752_create_summary_reports_table', 1),
	(22, '2023_07_05_043638_create_deposits_table', 1);

-- Dumping structure for table tukerin.password_resets
DROP TABLE IF EXISTS `password_resets`;
CREATE TABLE IF NOT EXISTS `password_resets` (
  `email` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `token` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  KEY `password_resets_email_index` (`email`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Dumping data for table tukerin.password_resets: ~0 rows (approximately)

-- Dumping structure for table tukerin.password_reset_tokens
DROP TABLE IF EXISTS `password_reset_tokens`;
CREATE TABLE IF NOT EXISTS `password_reset_tokens` (
  `email` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `token` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`email`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Dumping data for table tukerin.password_reset_tokens: ~0 rows (approximately)

-- Dumping structure for table tukerin.personal_access_tokens
DROP TABLE IF EXISTS `personal_access_tokens`;
CREATE TABLE IF NOT EXISTS `personal_access_tokens` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `tokenable_type` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `tokenable_id` bigint unsigned NOT NULL,
  `name` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `token` varchar(64) COLLATE utf8mb4_unicode_ci NOT NULL,
  `abilities` text COLLATE utf8mb4_unicode_ci,
  `last_used_at` timestamp NULL DEFAULT NULL,
  `expires_at` timestamp NULL DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `personal_access_tokens_token_unique` (`token`),
  KEY `personal_access_tokens_tokenable_type_tokenable_id_index` (`tokenable_type`,`tokenable_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Dumping data for table tukerin.personal_access_tokens: ~0 rows (approximately)

-- Dumping structure for table tukerin.products
DROP TABLE IF EXISTS `products`;
CREATE TABLE IF NOT EXISTS `products` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `user_id` bigint unsigned NOT NULL,
  `category_id` bigint unsigned NOT NULL,
  `name` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `price` int NOT NULL,
  `description` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `image` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `rating` tinyint DEFAULT NULL,
  `status_barter` tinyint(1) NOT NULL DEFAULT '0' COMMENT '0 = barang tersedia/dptdibarter',
  `ajukan_iklan` tinyint(1) NOT NULL DEFAULT '0',
  `status_iklan` tinyint(1) NOT NULL DEFAULT '0',
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Dumping data for table tukerin.products: ~4 rows (approximately)
REPLACE INTO `products` (`id`, `user_id`, `category_id`, `name`, `price`, `description`, `image`, `rating`, `status_barter`, `ajukan_iklan`, `status_iklan`, `created_at`, `updated_at`) VALUES
	(1, 1, 1, 'Laptop MacBook Pro 13" Display, i5', 10000000, 'Elegan, Kuat, Portabel, Canggih, Produktif, Tangguh', NULL, NULL, 0, 1, 1, '2023-07-11 19:19:04', '2023-07-11 19:19:04'),
	(2, 1, 1, 'UltraBook Pro X', 15000000, 'Laptop ultraportabel dengan performa tinggi dan desain premium untuk kebutuhan komputasi yang efisien dan stylish', NULL, NULL, 0, 0, 0, '2023-07-11 19:19:04', '2023-07-11 19:19:04'),
	(3, 2, 2, 'TurboDrive X', 12500000, 'Sistem turbocharger inovatif yang meningkatkan tenaga mesin dan efisiensi bahan bakar untuk performa maksimal di jalan', NULL, NULL, 0, 1, 1, '2023-07-11 19:19:04', '2023-07-11 19:19:04'),
	(4, 2, 2, 'SpeedMaximizer Ultra', 13700000, 'Tuning kit yang mengoptimalkan sistem pembakaran, pengaturan transmisi, dan aerodinamika kendaraan untuk mencapai kecepatan maksimal dengan keamanan yang terjamin', NULL, NULL, 0, 0, 0, '2023-07-11 19:19:04', '2023-07-11 19:19:04');

-- Dumping structure for table tukerin.summary_reports
DROP TABLE IF EXISTS `summary_reports`;
CREATE TABLE IF NOT EXISTS `summary_reports` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `user_id` bigint unsigned NOT NULL,
  `product_id` bigint unsigned NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Dumping data for table tukerin.summary_reports: ~0 rows (approximately)

-- Dumping structure for table tukerin.users
DROP TABLE IF EXISTS `users`;
CREATE TABLE IF NOT EXISTS `users` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `email` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `password` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `name` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `jenis_kelamin` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'L/P',
  `tanggal_lahir` date DEFAULT NULL,
  `alamat` text COLLATE utf8mb4_unicode_ci,
  `picture` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `rate` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `role` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'user',
  `remember_token` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `users_email_unique` (`email`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Dumping data for table tukerin.users: ~4 rows (approximately)
REPLACE INTO `users` (`id`, `email`, `password`, `name`, `jenis_kelamin`, `tanggal_lahir`, `alamat`, `picture`, `rate`, `role`, `remember_token`, `created_at`, `updated_at`) VALUES
	(1, 'user@test.com', '$2y$10$p.AT9DGZ73/CSR8h4I4FPOMf/f7ZbxcbB/rm4ePnc7Uy/t7kz4R.2', 'Rafika', 'P', NULL, 'Jalan Sudirman No. 123, Jakarta Pusat, DKI Jakarta, Indonesia', NULL, NULL, 'user', NULL, '2023-07-11 19:19:03', '2023-07-11 19:19:03'),
	(2, 'user2@test.com', '$2y$10$lORq0aRaSabk3dkHNnHSd.TE3L4qbllLCm27p0pKT1ZquFSpHICmy', 'Nia', 'P', NULL, 'Jalan Ahmad Yani No. 456, Surabaya, Jawa Timur, Indonesia', NULL, NULL, 'user', NULL, '2023-07-11 19:19:03', '2023-07-11 19:19:03'),
	(3, 'user3@test.com', '$2y$10$hjTIex/3Jhc0oxUag94l1.1/QXa42FP55uItJ6G..zKPc2A8cQSHi', 'Leo', 'L', NULL, NULL, NULL, NULL, 'user', NULL, '2023-07-11 19:19:03', '2023-07-11 19:19:03'),
	(4, 'admin@test.com', '$2y$10$Jpnb2LeBqa8sXS0bHBml5OTM6Y1w1C3QzKQwWACVYZUrnXSHbu266', 'Admin', 'P', NULL, NULL, NULL, NULL, 'admin', NULL, '2023-07-11 19:19:04', '2023-07-11 19:19:04');

-- Dumping structure for view tukerin.view_daftar_barang_iklan
DROP VIEW IF EXISTS `view_daftar_barang_iklan`;
-- Creating temporary table to overcome VIEW dependency errors
CREATE TABLE `view_daftar_barang_iklan` (
	`namaPemilik` VARCHAR(255) NULL COLLATE 'utf8mb4_unicode_ci',
	`idBarang` BIGINT(20) UNSIGNED NOT NULL,
	`name` VARCHAR(255) NOT NULL COLLATE 'utf8mb4_unicode_ci',
	`description` TEXT NOT NULL COLLATE 'utf8mb4_unicode_ci'
) ENGINE=MyISAM;

-- Dumping structure for view tukerin.history_user
DROP VIEW IF EXISTS `history_user`;
-- Removing temporary table and create final VIEW structure
DROP TABLE IF EXISTS `history_user`;
CREATE ALGORITHM=UNDEFINED SQL SECURITY DEFINER VIEW `history_user` AS select `b`.`user_id` AS `userId`,`u`.`name` AS `nama`,`b`.`status` AS `status`,group_concat(`p`.`name` order by `p`.`name` ASC separator ', ') AS `barangDipesan`,sum((case when (`b`.`status` = '0') then 1 else 0 end)) AS `jumlahBarangYangDiajukan`,sum((case when (`b`.`status` = '1') then 1 else 0 end)) AS `jumlahBarangDisetujui`,sum((case when (`b`.`status` = '2') then 1 else 0 end)) AS `jumlahBarangDitolak` from ((`bids` `b` left join `products` `p` on((`b`.`product_id` = `p`.`id`))) left join `users` `u` on((`p`.`user_id` = `u`.`id`))) group by `b`.`user_id`,`u`.`name`;

-- Dumping structure for view tukerin.jumlah_barang_status_user
DROP VIEW IF EXISTS `jumlah_barang_status_user`;
-- Removing temporary table and create final VIEW structure
DROP TABLE IF EXISTS `jumlah_barang_status_user`;
CREATE ALGORITHM=UNDEFINED SQL SECURITY DEFINER VIEW `jumlah_barang_status_user` AS select `u`.`id` AS `user_id`,`u`.`name` AS `namaPemilik`,`p`.`name` AS `namaProduk`,(case when (`p`.`status_barter` = 1) then 'telahDibarter' else 'belumDibarter' end) AS `statusProduk` from (`users` `u` left join `products` `p` on((`u`.`id` = `p`.`user_id`))) group by `u`.`id`,`p`.`id`,`p`.`status_barter`;

-- Dumping structure for view tukerin.view_daftar_barang_iklan
DROP VIEW IF EXISTS `view_daftar_barang_iklan`;
-- Removing temporary table and create final VIEW structure
DROP TABLE IF EXISTS `view_daftar_barang_iklan`;
CREATE ALGORITHM=UNDEFINED SQL SECURITY DEFINER VIEW `view_daftar_barang_iklan` AS select `u`.`name` AS `namaPemilik`,`p`.`id` AS `idBarang`,`p`.`name` AS `name`,`p`.`description` AS `description` from (`products` `p` left join `users` `u` on((`p`.`user_id` = `u`.`id`))) where (`p`.`status_iklan` = 1);

/*!40103 SET TIME_ZONE=IFNULL(@OLD_TIME_ZONE, 'system') */;
/*!40101 SET SQL_MODE=IFNULL(@OLD_SQL_MODE, '') */;
/*!40014 SET FOREIGN_KEY_CHECKS=IFNULL(@OLD_FOREIGN_KEY_CHECKS, 1) */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40111 SET SQL_NOTES=IFNULL(@OLD_SQL_NOTES, 1) */;
