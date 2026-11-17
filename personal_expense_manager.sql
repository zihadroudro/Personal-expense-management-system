-- ==============================================================
-- Personal Expense & Budget Manager (CSE470 Software Engineering)
-- Complete Database Export for XAMPP (phpMyAdmin / MariaDB / MySQL)
-- Database Name: personal_expense_manager
-- ==============================================================

SET FOREIGN_KEY_CHECKS = 0;
SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `personal_expense_manager`
--
CREATE DATABASE IF NOT EXISTS `personal_expense_manager` DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE `personal_expense_manager`;

-- --------------------------------------------------------
-- Table structure for table `users`
-- --------------------------------------------------------
DROP TABLE IF EXISTS `users`;
CREATE TABLE `users` (
  `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT,
  `name` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `email` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `email_verified_at` timestamp NULL DEFAULT NULL,
  `password` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `remember_token` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `users_email_unique` (`email`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------
-- Table structure for table `password_reset_tokens`
-- --------------------------------------------------------
DROP TABLE IF EXISTS `password_reset_tokens`;
CREATE TABLE `password_reset_tokens` (
  `email` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `token` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`email`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------
-- Table structure for table `sessions`
-- --------------------------------------------------------
DROP TABLE IF EXISTS `sessions`;
CREATE TABLE `sessions` (
  `id` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `user_id` bigint(20) UNSIGNED DEFAULT NULL,
  `ip_address` varchar(45) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `user_agent` text COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `payload` longtext COLLATE utf8mb4_unicode_ci NOT NULL,
  `last_activity` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `sessions_user_id_index` (`user_id`),
  KEY `sessions_last_activity_index` (`last_activity`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------
-- Table structure for table `categories`
-- --------------------------------------------------------
DROP TABLE IF EXISTS `categories`;
CREATE TABLE `categories` (
  `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT,
  `user_id` bigint(20) UNSIGNED DEFAULT NULL,
  `name` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  `type` enum('income','expense') COLLATE utf8mb4_unicode_ci NOT NULL,
  `description` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `categories_user_id_type_index` (`user_id`,`type`),
  KEY `categories_name_index` (`name`),
  CONSTRAINT `categories_user_id_foreign` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------
-- Table structure for table `transactions`
-- --------------------------------------------------------
DROP TABLE IF EXISTS `transactions`;
CREATE TABLE `transactions` (
  `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT,
  `user_id` bigint(20) UNSIGNED NOT NULL,
  `category_id` bigint(20) UNSIGNED NOT NULL,
  `type` enum('income','expense') COLLATE utf8mb4_unicode_ci NOT NULL,
  `amount` decimal(12,2) NOT NULL,
  `transaction_date` date NOT NULL,
  `description` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `transactions_user_id_transaction_date_index` (`user_id`,`transaction_date`),
  KEY `transactions_user_id_type_index` (`user_id`,`type`),
  KEY `transactions_category_id_transaction_date_index` (`category_id`,`transaction_date`),
  CONSTRAINT `transactions_user_id_foreign` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE,
  CONSTRAINT `transactions_category_id_foreign` FOREIGN KEY (`category_id`) REFERENCES `categories` (`id`) ON DELETE RESTRICT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------
-- Table structure for table `budgets`
-- --------------------------------------------------------
DROP TABLE IF EXISTS `budgets`;
CREATE TABLE `budgets` (
  `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT,
  `user_id` bigint(20) UNSIGNED NOT NULL,
  `category_id` bigint(20) UNSIGNED NOT NULL,
  `amount` decimal(12,2) NOT NULL,
  `month` tinyint(3) UNSIGNED NOT NULL,
  `year` smallint(5) UNSIGNED NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `budgets_user_id_category_id_month_year_unique` (`user_id`,`category_id`,`month`,`year`),
  KEY `budgets_user_id_year_month_index` (`user_id`,`year`,`month`),
  CONSTRAINT `budgets_user_id_foreign` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE,
  CONSTRAINT `budgets_category_id_foreign` FOREIGN KEY (`category_id`) REFERENCES `categories` (`id`) ON DELETE RESTRICT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------
-- Table structure for table `cache`
-- --------------------------------------------------------
DROP TABLE IF EXISTS `cache`;
CREATE TABLE `cache` (
  `key` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `value` mediumtext COLLATE utf8mb4_unicode_ci NOT NULL,
  `expiration` int(11) NOT NULL,
  PRIMARY KEY (`key`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------
-- Table structure for table `cache_locks`
-- --------------------------------------------------------
DROP TABLE IF EXISTS `cache_locks`;
CREATE TABLE `cache_locks` (
  `key` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `owner` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `expiration` int(11) NOT NULL,
  PRIMARY KEY (`key`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------
-- Table structure for table `jobs`
-- --------------------------------------------------------
DROP TABLE IF EXISTS `jobs`;
CREATE TABLE `jobs` (
  `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT,
  `queue` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `payload` longtext COLLATE utf8mb4_unicode_ci NOT NULL,
  `attempts` tinyint(3) UNSIGNED NOT NULL,
  `reserved_at` int(10) UNSIGNED DEFAULT NULL,
  `available_at` int(10) UNSIGNED NOT NULL,
  `created_at` int(10) UNSIGNED NOT NULL,
  PRIMARY KEY (`id`),
  KEY `jobs_queue_index` (`queue`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------
-- Table structure for table `job_batches`
-- --------------------------------------------------------
DROP TABLE IF EXISTS `job_batches`;
CREATE TABLE `job_batches` (
  `id` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `name` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `total_jobs` int(11) NOT NULL,
  `pending_jobs` int(11) NOT NULL,
  `failed_jobs` int(11) NOT NULL,
  `failed_job_ids` longtext COLLATE utf8mb4_unicode_ci NOT NULL,
  `options` mediumtext COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `cancelled_at` int(11) DEFAULT NULL,
  `created_at` int(11) NOT NULL,
  `finished_at` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------
-- Table structure for table `failed_jobs`
-- --------------------------------------------------------
DROP TABLE IF EXISTS `failed_jobs`;
CREATE TABLE `failed_jobs` (
  `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT,
  `uuid` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `connection` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `queue` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `payload` longtext COLLATE utf8mb4_unicode_ci NOT NULL,
  `exception` longtext COLLATE utf8mb4_unicode_ci NOT NULL,
  `failed_at` timestamp NOT NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`id`),
  UNIQUE KEY `failed_jobs_uuid_unique` (`uuid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------
-- Table structure for table `migrations`
-- --------------------------------------------------------
DROP TABLE IF EXISTS `migrations`;
CREATE TABLE `migrations` (
  `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT,
  `migration` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `batch` int(11) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ==============================================================
-- DUMPING DATA
-- ==============================================================

--
-- Dumping data for table `migrations`
--
INSERT INTO `migrations` (`id`, `migration`, `batch`) VALUES
(1, '0001_01_01_000000_create_users_table', 1),
(2, '0001_01_01_000001_create_cache_table', 1),
(3, '0001_01_01_000002_create_jobs_table', 1),
(4, '2026_10_18_000001_create_categories_table', 1),
(5, '2026_10_18_000002_create_transactions_table', 1),
(6, '2026_10_18_000003_create_budgets_table', 1);

--
-- Dumping data for table `users`
-- (Demo credentials: demo@example.com / password123)
--
INSERT INTO `users` (`id`, `name`, `email`, `email_verified_at`, `password`, `remember_token`, `created_at`, `updated_at`) VALUES
(1, 'Alex Mercer', 'demo@example.com', '2026-10-01 10:00:00', '$2y$10$nEcnq1N8PYrFEttErYfRruS6M.SyqFZCXS8T0EC.5ljWhAsUvf/mu', NULL, '2026-10-01 10:00:00', '2026-10-01 10:00:00'),
(2, 'Jane Doe', 'jane@example.com', '2026-10-05 11:30:00', '$2y$10$nEcnq1N8PYrFEttErYfRruS6M.SyqFZCXS8T0EC.5ljWhAsUvf/mu', NULL, '2026-10-05 11:30:00', '2026-10-05 11:30:00');

--
-- Dumping data for table `categories`
-- (IDs 1-14: System-provided default categories; IDs 15-16: Custom user categories)
--
INSERT INTO `categories` (`id`, `user_id`, `name`, `type`, `description`, `created_at`, `updated_at`) VALUES
(1, NULL, 'Salary', 'income', 'Regular employment income and wages', '2026-10-01 00:00:00', '2026-10-01 00:00:00'),
(2, NULL, 'Freelance & Contracting', 'income', 'Freelance projects, gigs, and consulting', '2026-10-01 00:00:00', '2026-10-01 00:00:00'),
(3, NULL, 'Investments & Dividends', 'income', 'Interest, capital gains, and investment returns', '2026-10-01 00:00:00', '2026-10-01 00:00:00'),
(4, NULL, 'Business Revenue', 'income', 'Profits from business operations or side ventures', '2026-10-01 00:00:00', '2026-10-01 00:00:00'),
(5, NULL, 'Other Income', 'income', 'Gifts, bonuses, refunds, and miscellaneous income', '2026-10-01 00:00:00', '2026-10-01 00:00:00'),
(6, NULL, 'Food & Dining', 'expense', 'Groceries, restaurants, takeout, and cafes', '2026-10-01 00:00:00', '2026-10-01 00:00:00'),
(7, NULL, 'Housing & Rent', 'expense', 'Rent, mortgage, and home maintenance', '2026-10-01 00:00:00', '2026-10-01 00:00:00'),
(8, NULL, 'Utilities & Bills', 'expense', 'Electricity, water, gas, internet, and phone bills', '2026-10-01 00:00:00', '2026-10-01 00:00:00'),
(9, NULL, 'Transportation', 'expense', 'Public transit, fuel, vehicle repairs, and rideshare', '2026-10-01 00:00:00', '2026-10-01 00:00:00'),
(10, NULL, 'Healthcare & Medical', 'expense', 'Doctor visits, pharmacy, insurance, and medical supplies', '2026-10-01 00:00:00', '2026-10-01 00:00:00'),
(11, NULL, 'Entertainment & Leisure', 'expense', 'Streaming subscriptions, events, movies, and hobbies', '2026-10-01 00:00:00', '2026-10-01 00:00:00'),
(12, NULL, 'Education & Books', 'expense', 'Tuition, courses, textbooks, and learning materials', '2026-10-01 00:00:00', '2026-10-01 00:00:00'),
(13, NULL, 'Shopping & Personal', 'expense', 'Clothing, gadgets, personal care, and electronics', '2026-10-01 00:00:00', '2026-10-01 00:00:00'),
(14, NULL, 'Miscellaneous Expense', 'expense', 'Uncategorized, emergency, and one-off spending', '2026-10-01 00:00:00', '2026-10-01 00:00:00'),
(15, 1, 'Gym & Fitness', 'expense', 'Fitness club, gym memberships, and workout gear', '2026-10-02 09:00:00', '2026-10-02 09:00:00'),
(16, 1, 'Crypto Staking', 'income', 'Staking rewards and DeFi yield earnings', '2026-10-02 09:15:00', '2026-10-02 09:15:00');

--
-- Dumping data for table `transactions`
--
INSERT INTO `transactions` (`id`, `user_id`, `category_id`, `type`, `amount`, `transaction_date`, `description`, `created_at`, `updated_at`) VALUES
-- Current Month (November 2026) Incomes
(1, 1, 1, 'income', 3800.00, '2026-11-01', 'Monthly tech corporate salary', '2026-11-01 09:00:00', '2026-11-01 09:00:00'),
(2, 1, 2, 'income', 750.00, '2026-11-12', 'Mobile app UI design milestone 1', '2026-11-12 14:30:00', '2026-11-12 14:30:00'),
(3, 1, 16, 'income', 95.00, '2026-11-18', 'Monthly ETH staking yield reward', '2026-11-18 10:15:00', '2026-11-18 10:15:00'),

-- Current Month (November 2026) Expenses
(4, 1, 7, 'expense', 1200.00, '2026-11-02', 'Monthly apartment rent payment', '2026-11-02 08:30:00', '2026-11-02 08:30:00'),
(5, 1, 15, 'expense', 55.00, '2026-11-03', 'CrossFit gym monthly pass', '2026-11-03 11:00:00', '2026-11-03 11:00:00'),
(6, 1, 8, 'expense', 110.00, '2026-11-05', 'Electricity & Water municipal bill', '2026-11-05 16:45:00', '2026-11-05 16:45:00'),
(7, 1, 8, 'expense', 70.00, '2026-11-06', 'Gigabit fiber optic home broadband', '2026-11-06 17:00:00', '2026-11-06 17:00:00'),
(8, 1, 6, 'expense', 145.50, '2026-11-08', 'Weekly organic groceries at Whole Foods', '2026-11-08 18:20:00', '2026-11-08 18:20:00'),
(9, 1, 9, 'expense', 85.00, '2026-11-10', 'Monthly public transit subway pass', '2026-11-10 09:15:00', '2026-11-10 09:15:00'),
(10, 1, 6, 'expense', 48.00, '2026-11-14', 'Weekend dinner with team', '2026-11-14 20:30:00', '2026-11-14 20:30:00'),
(11, 1, 11, 'expense', 24.99, '2026-11-15', 'Netflix 4K & Spotify Family subscription', '2026-11-15 12:00:00', '2026-11-15 12:00:00'),
(12, 1, 9, 'expense', 45.00, '2026-11-19', 'Weekend rideshare trips', '2026-11-19 22:15:00', '2026-11-19 22:15:00'),

-- Previous Month (October 2026) Historical Incomes & Expenses
(13, 1, 1, 'income', 3800.00, '2026-10-01', 'Monthly tech corporate salary (October)', '2026-10-01 09:00:00', '2026-10-01 09:00:00'),
(14, 1, 2, 'income', 600.00, '2026-10-15', 'Freelance consulting payment', '2026-10-15 15:00:00', '2026-10-15 15:00:00'),
(15, 1, 7, 'expense', 1200.00, '2026-10-02', 'October apartment rent payment', '2026-10-02 08:30:00', '2026-10-02 08:30:00'),
(16, 1, 8, 'expense', 165.00, '2026-10-06', 'October utilities & wifi', '2026-10-06 14:00:00', '2026-10-06 14:00:00'),
(17, 1, 6, 'expense', 210.00, '2026-10-12', 'October groceries & meal deliveries', '2026-10-12 19:00:00', '2026-10-12 19:00:00'),
(18, 1, 9, 'expense', 90.00, '2026-10-16', 'October public transportation & cabs', '2026-10-16 11:30:00', '2026-10-16 11:30:00'),
(19, 1, 11, 'expense', 35.00, '2026-10-22', 'Cinema ticket & weekend snacks', '2026-10-22 21:00:00', '2026-10-22 21:00:00');

--
-- Dumping data for table `budgets`
-- (Demonstrating all three business status conditions:
--  - Food & Dining: $193.50 of $350.00 (55.3%) -> Within Budget [Green]
--  - Utilities & Bills: $180.00 of $200.00 (90.0%) -> Near Limit [Yellow]
--  - Transportation: $130.00 of $100.00 (130.0%) -> Over Budget [Red]
--  - Housing & Rent: $1200.00 of $1300.00 (92.3%) -> Near Limit [Yellow]
--  - Entertainment & Leisure: $24.99 of $60.00 (41.6%) -> Within Budget [Green])
--
INSERT INTO `budgets` (`id`, `user_id`, `category_id`, `amount`, `month`, `year`, `created_at`, `updated_at`) VALUES
-- November 2026 (Month 11)
(1, 1, 6, 350.00, 11, 2026, '2026-11-01 00:00:00', '2026-11-01 00:00:00'),
(2, 1, 8, 200.00, 11, 2026, '2026-11-01 00:00:00', '2026-11-01 00:00:00'),
(3, 1, 9, 100.00, 11, 2026, '2026-11-01 00:00:00', '2026-11-01 00:00:00'),
(4, 1, 7, 1300.00, 11, 2026, '2026-11-01 00:00:00', '2026-11-01 00:00:00'),
(5, 1, 11, 60.00, 11, 2026, '2026-11-01 00:00:00', '2026-11-01 00:00:00'),

-- October 2026 (Month 10)
(6, 1, 6, 350.00, 10, 2026, '2026-10-01 00:00:00', '2026-10-01 00:00:00'),
(7, 1, 8, 200.00, 10, 2026, '2026-10-01 00:00:00', '2026-10-01 00:00:00'),
(8, 1, 9, 100.00, 10, 2026, '2026-10-01 00:00:00', '2026-10-01 00:00:00'),
(9, 1, 7, 1300.00, 10, 2026, '2026-10-01 00:00:00', '2026-10-01 00:00:00');

SET FOREIGN_KEY_CHECKS = 1;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
