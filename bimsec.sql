-- phpMyAdmin SQL Dump
-- version 5.2.3
-- https://www.phpmyadmin.net/
--
-- Hôte : db:3306
-- Généré le : mer. 25 fév. 2026 à 13:17
-- Version du serveur : 10.11.15-MariaDB-ubu2204
-- Version de PHP : 8.3.29

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Base de données : `bim`
--

-- --------------------------------------------------------

--
-- Structure de la table `bonus`
--

CREATE TABLE `bonus` (
  `bonusId` int(11) NOT NULL,
  `bonusAccount` varchar(255) DEFAULT NULL,
  `userId` int(11) DEFAULT NULL,
  `companyId` int(11) NOT NULL,
  `createdAt` datetime NOT NULL,
  `updatedAt` datetime NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Structure de la table `branchTracks`
--

CREATE TABLE `branchTracks` (
  `branchTrackId` int(11) NOT NULL,
  `branchTrackName` varchar(255) NOT NULL,
  `branchTrackEmail` varchar(255) NOT NULL,
  `commerceId` int(11) DEFAULT NULL,
  `imageUrl` varchar(500) DEFAULT NULL,
  `createdAt` datetime NOT NULL,
  `updatedAt` datetime NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Structure de la table `branch_tracks`
--

CREATE TABLE `branch_tracks` (
  `branchTrackId` int(11) NOT NULL,
  `branchTrackName` varchar(255) NOT NULL,
  `branchTrackEmail` varchar(255) NOT NULL,
  `commerceId` int(11) DEFAULT NULL,
  `imageUrl` varchar(500) DEFAULT NULL,
  `createdAt` datetime NOT NULL,
  `updatedAt` datetime NOT NULL,
  `userId` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Structure de la table `businessCategories`
--

CREATE TABLE `businessCategories` (
  `businessId` int(11) NOT NULL,
  `name` varchar(255) NOT NULL,
  `description` text DEFAULT NULL,
  `logo` varchar(255) DEFAULT NULL,
  `imageUrl` varchar(255) DEFAULT NULL,
  `createdAt` datetime NOT NULL,
  `updatedAt` datetime NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Déchargement des données de la table `businessCategories`
--

INSERT INTO `businessCategories` (`businessId`, `name`, `description`, `logo`, `imageUrl`, `createdAt`, `updatedAt`) VALUES
(1, 'BIM Santé', 'Services médicaux, cliniques et pharmacies.', 'https://masmara-dimajelo.org/wp-content/uploads/2026/02/HEALTH.png', NULL, '2026-02-12 06:33:55', '2026-02-12 06:33:55'),
(2, 'BIM Transport', 'Bus, taxis et livraison.', 'https://masmara-dimajelo.org/wp-content/uploads/2026/02/transport.png', NULL, '2026-02-12 06:33:55', '2026-02-12 06:33:55'),
(3, 'BIM Énergies', 'Électricité, solaire et solutions énergétiques.', 'https://masmara-dimajelo.org/wp-content/uploads/2026/02/energy.png', NULL, '2026-02-12 06:33:55', '2026-02-12 06:33:55'),
(4, 'BIM Carburant', 'Stations-service et distribution de carburant.', 'http://masmara-dimajelo.org/wp-content/uploads/2026/02/oil.png', NULL, '2026-02-12 06:33:55', '2026-02-12 06:33:55'),
(5, 'BIM Hôtellerie', 'Hôtels, lodges et maisons d’hôtes.', 'http://masmara-dimajelo.org/wp-content/uploads/2026/02/hotel-resto.png', NULL, '2026-02-12 06:33:55', '2026-02-12 06:33:55'),
(6, 'BIM Gaz', 'Distribution et vente de gaz domestique et industriel.', 'http://masmara-dimajelo.org/wp-content/uploads/2026/02/SALES-2.png', NULL, '2026-02-12 06:33:55', '2026-02-12 06:33:55'),
(7, 'BIM Éducation', 'Écoles et formations.', 'http://masmara-dimajelo.org/wp-content/uploads/2026/02/SALES-2.png', NULL, '2026-02-12 06:33:55', '2026-02-12 06:33:55'),
(8, 'BIM Commerce', 'Boutiques et supermarchés.', 'http://masmara-dimajelo.org/wp-content/uploads/2026/02/MARKET.png', NULL, '2026-02-12 06:33:55', '2026-02-12 06:33:55'),
(9, 'BIM Agriculture', 'Production agricole.', 'http://masmara-dimajelo.org/wp-content/uploads/2026/02/SALES-2.png', NULL, '2026-02-12 06:33:55', '2026-02-12 06:33:55'),
(10, 'BIM Télécoms', 'Internet et téléphonie.', 'http://masmara-dimajelo.org/wp-content/uploads/2026/02/SALES-2.png', NULL, '2026-02-12 06:33:55', '2026-02-12 06:33:55'),
(11, 'BIM Finance', 'Paiements et crédits.', 'https://cdn-icons-png.flaticon.com/512/3135/3135679.png', NULL, '2026-02-12 06:33:55', '2026-02-12 06:33:55'),
(12, 'BIM Immobilier', 'Location et vente.', 'http://masmara-dimajelo.org/wp-content/uploads/2026/02/SALES-2.png', NULL, '2026-02-12 06:33:55', '2026-02-12 06:33:55'),
(13, 'BIM Marketing', 'Publicité digitale.', 'http://masmara-dimajelo.org/wp-content/uploads/2026/02/SALES-2.png', NULL, '2026-02-12 06:33:55', '2026-02-12 06:33:55');

-- --------------------------------------------------------

--
-- Structure de la table `categories`
--

CREATE TABLE `categories` (
  `categoryId` int(11) NOT NULL,
  `name` varchar(150) NOT NULL,
  `description` text NOT NULL,
  `commerceId` int(11) DEFAULT NULL,
  `branchTrackId` int(11) DEFAULT NULL,
  `createdAt` datetime NOT NULL,
  `updatedAt` datetime NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Structure de la table `client_tracks`
--

CREATE TABLE `client_tracks` (
  `clientTrackId` int(11) NOT NULL,
  `name` varchar(150) NOT NULL,
  `email` varchar(255) NOT NULL,
  `description` text NOT NULL,
  `imageUrl` varchar(500) DEFAULT NULL,
  `commerceId` int(11) DEFAULT NULL,
  `branchTrackId` int(11) DEFAULT NULL,
  `createdAt` datetime NOT NULL,
  `updatedAt` datetime NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Structure de la table `commerces`
--

CREATE TABLE `commerces` (
  `commerceId` int(11) NOT NULL,
  `commerceName` varchar(150) NOT NULL,
  `commerceEmail` varchar(255) NOT NULL,
  `userId` int(11) DEFAULT NULL,
  `imageUrl` varchar(500) DEFAULT NULL,
  `createdAt` datetime NOT NULL,
  `updatedAt` datetime NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Structure de la table `companies`
--

CREATE TABLE `companies` (
  `companyId` int(11) NOT NULL,
  `name` varchar(150) NOT NULL,
  `description` text DEFAULT NULL,
  `logo` varchar(255) DEFAULT NULL,
  `location` varchar(255) DEFAULT NULL,
  `email` varchar(255) NOT NULL,
  `branchTrackId` int(11) DEFAULT NULL,
  `businessId` int(11) DEFAULT NULL,
  `imageUrl` varchar(500) DEFAULT NULL,
  `createdAt` datetime NOT NULL,
  `updatedAt` datetime NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Déchargement des données de la table `companies`
--

INSERT INTO `companies` (`companyId`, `name`, `description`, `logo`, `location`, `email`, `branchTrackId`, `businessId`, `imageUrl`, `createdAt`, `updatedAt`) VALUES
(8, 'POLYCLINIQUE CITADELLE', 'Nous sommes une clinique médicale attachée au Centre Interdisciplinaire de Recherche Translationnelle en Médecine et Sciences de la Santé', 'https://cirtmss.org/wp-content/uploads/2025/09/WhatsApp-Image-2025-08-23-at-12.52.09-1.jpeg', 'Bunia', 'contact@cirtmss.org', NULL, 1, NULL, '2026-02-12 08:27:04', '2026-02-12 08:27:04'),
(9, 'STATION XXXL', 'Nous sommes une station-service moderne offrant un approvisionnement fiable en carburant, des services d’entretien de véhicules, et un accueil chaleureux pour garantir la satisfaction de nos clients à chaque visite.', 'https://cdn-icons-png.flaticon.com/512/2554/2554991.png', 'Bunia', 'contact@stationxxl.org', NULL, 4, NULL, '2026-02-12 08:27:04', '2026-02-12 08:27:04'),
(10, 'STATION DIEU MERCI', 'Nous sommes une station-service moderne offrant un approvisionnement fiable en carburant, des services d’entretien de véhicules, et un accueil chaleureux pour garantir la satisfaction de nos clients à chaque visite.', 'https://cdn-icons-png.flaticon.com/512/2554/2554991.png', 'Bunia', 'contact@station.org', NULL, 4, NULL, '2026-02-12 08:27:04', '2026-02-12 08:27:04'),
(11, 'ETS DON DE DIEU', 'Nous opérons dans le secteur de l’énergie, fournissant des solutions fiables et durables en électricité, carburants et services énergétiques pour répondre aux besoins industriels et domestiques.', 'https://cdn-icons-png.flaticon.com/512/6008/6008277.png', 'Bunia', 'contact@estd.org', NULL, 3, NULL, '2026-02-12 08:27:04', '2026-02-12 08:27:04'),
(12, 'ETS KATAMLPG', 'Nous opérons dans le secteur de l’énergie, fournissant des solutions fiables et durables en électricité, carburants et services énergétiques pour répondre aux besoins industriels et domestiques.', 'https://cdn-icons-png.flaticon.com/512/6008/6008277.png', 'Bunia', 'contact@dunqlkssj.org', NULL, 3, NULL, '2026-02-12 08:27:04', '2026-02-12 08:27:04'),
(13, 'HÔTEL LA CASA SIR HENRY ', 'Réservez votre chambre d’hôtel ou appartement grâce à BIM NEXT et obtenez une remise conséquente', 'https://static.wixstatic.com/media/f7b637_0d11a778646849d58dea597fd225617d~mv2.jpeg/v1/fill/w_88,h_88,al_c,q_80,usm_0.66_1.00_0.01,enc_avif,quality_auto/f7b637_0d11a778646849d58dea597fd225617d~mv2.jpeg', 'Av. RTK a face du marché MONUC Q/ Lumumba, C/ Mbunya,Ville de Bunia,Pronvince de l\'Ituri, République Démocratique du Congo', 'contact@lacasadesirhenry.com', NULL, 5, NULL, '2026-02-12 08:27:04', '2026-02-12 08:27:04'),
(14, 'HÔTEL DE LA PROVINCE  ', 'Réservez votre chambre d’hôtel ou appartement grâce à BIM NEXT et obtenez une remise conséquente', 'https://cdn-icons-png.flaticon.com/512/235/235889.png', 'Av. RTK a face du marché MONUC Q/ Lumumba, C/ Mbunya,Ville de Bunia,Pronvince de l\'Ituri, République Démocratique du Congo', 'contact@province.com', NULL, 5, NULL, '2026-02-12 08:27:04', '2026-02-12 08:27:04');

-- --------------------------------------------------------

--
-- Structure de la table `currencies`
--

CREATE TABLE `currencies` (
  `currencyId` int(11) NOT NULL,
  `code` varchar(10) NOT NULL,
  `name` varchar(100) NOT NULL,
  `description` text DEFAULT NULL,
  `symbol` varchar(10) DEFAULT NULL,
  `rate` float DEFAULT NULL,
  `createdAt` datetime NOT NULL,
  `updatedAt` datetime NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Déchargement des données de la table `currencies`
--

INSERT INTO `currencies` (`currencyId`, `code`, `name`, `description`, `symbol`, `rate`, `createdAt`, `updatedAt`) VALUES
(1, 'Ecoins', 'Franc BIM NEXT', 'Devise officielle de BIM NEXT', 'EC', 1, '2026-02-12 09:03:42', '2026-02-12 09:03:42');

-- --------------------------------------------------------

--
-- Structure de la table `expe_tracks`
--

CREATE TABLE `expe_tracks` (
  `expeTrackId` int(11) NOT NULL,
  `reference` varchar(100) NOT NULL COMMENT 'Numéro unique de la fiche d’expédition',
  `shipmentDate` datetime NOT NULL COMMENT 'Date d’expédition',
  `expectedArrivalDate` datetime DEFAULT NULL COMMENT 'Date d’arrivée prévue',
  `origin` varchar(150) NOT NULL COMMENT 'Lieu de départ',
  `destination` varchar(150) NOT NULL COMMENT 'Lieu de destination',
  `carrierName` varchar(150) DEFAULT NULL COMMENT 'Nom du transporteur',
  `vehiclePlate` varchar(50) DEFAULT NULL COMMENT 'Plaque du véhicule',
  `totalPackages` int(11) NOT NULL COMMENT 'Nombre total de colis',
  `totalWeight` decimal(10,2) DEFAULT NULL COMMENT 'Poids total expédié',
  `status` enum('EN_ATTENTE','EXPEDIE','RECU_PARTIEL','RECU_COMPLET','LITIGE') NOT NULL DEFAULT 'EN_ATTENTE',
  `remarks` text DEFAULT NULL COMMENT 'Observations à l’expédition',
  `commerceId` int(11) NOT NULL,
  `branchTrackId` int(11) DEFAULT NULL,
  `imageUrl` varchar(500) DEFAULT NULL,
  `createdAt` datetime NOT NULL,
  `updatedAt` datetime NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Structure de la table `feedback_tracks`
--

CREATE TABLE `feedback_tracks` (
  `feedBackTrackId` int(11) NOT NULL,
  `name` varchar(150) NOT NULL,
  `email` varchar(255) DEFAULT NULL,
  `description` text NOT NULL,
  `imageUrl` varchar(500) DEFAULT NULL,
  `commerceId` int(11) DEFAULT NULL,
  `branchTrackId` int(11) DEFAULT NULL,
  `createdAt` datetime NOT NULL,
  `updatedAt` datetime NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Structure de la table `histories`
--

CREATE TABLE `histories` (
  `historyId` int(11) NOT NULL,
  `type` varchar(100) NOT NULL,
  `amount` float DEFAULT NULL,
  `action` varchar(150) DEFAULT NULL,
  `description` text DEFAULT NULL,
  `status` enum('réussi','échoué','en attente') NOT NULL DEFAULT 'réussi',
  `date` datetime NOT NULL,
  `userId` int(11) DEFAULT NULL,
  `createdAt` datetime NOT NULL,
  `updatedAt` datetime NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Déchargement des données de la table `histories`
--

INSERT INTO `histories` (`historyId`, `type`, `amount`, `action`, `description`, `status`, `date`, `userId`, `createdAt`, `updatedAt`) VALUES
(1, 'create', NULL, 'Création create ❌', 'Échec lors de création create.', 'réussi', '2026-02-12 06:27:01', NULL, '2026-02-12 06:27:01', '2026-02-12 06:27:01'),
(2, 'create', NULL, 'Création create ❌', 'Échec lors de création create.', 'réussi', '2026-02-12 06:32:45', NULL, '2026-02-12 06:32:45', '2026-02-12 06:32:45'),
(3, 'create', NULL, 'Création create ✅', 'Création create effectuée avec succès.', 'réussi', '2026-02-12 06:33:55', NULL, '2026-02-12 06:33:55', '2026-02-12 06:33:55'),
(4, 'sector', NULL, 'Consultation sector ✅', 'Consultation sector effectuée avec succès.', 'réussi', '2026-02-12 07:49:04', NULL, '2026-02-12 07:49:04', '2026-02-12 07:49:04'),
(5, 'create', NULL, 'Création create ❌', 'Échec lors de création create.', 'réussi', '2026-02-12 08:14:22', NULL, '2026-02-12 08:14:22', '2026-02-12 08:14:22'),
(6, 'create', NULL, 'Création create ❌', 'Échec lors de création create.', 'réussi', '2026-02-12 08:21:38', NULL, '2026-02-12 08:21:38', '2026-02-12 08:21:38'),
(7, 'create', NULL, 'Création create ✅', 'Création create effectuée avec succès.', 'réussi', '2026-02-12 08:27:04', NULL, '2026-02-12 08:27:04', '2026-02-12 08:27:04'),
(8, 'sector', NULL, 'Consultation sector ✅', 'Consultation sector effectuée avec succès.', 'réussi', '2026-02-12 08:27:19', NULL, '2026-02-12 08:27:19', '2026-02-12 08:27:19'),
(9, 'sector', NULL, 'Consultation sector ✅', 'Consultation sector effectuée avec succès.', 'réussi', '2026-02-12 08:27:28', NULL, '2026-02-12 08:27:28', '2026-02-12 08:27:28'),
(10, 'sector', NULL, 'Consultation sector ✅', 'Consultation sector effectuée avec succès.', 'réussi', '2026-02-12 08:34:10', NULL, '2026-02-12 08:34:10', '2026-02-12 08:34:10'),
(11, 'company', NULL, 'Consultation company ❌', 'Échec lors de consultation company.', 'réussi', '2026-02-12 08:38:52', NULL, '2026-02-12 08:38:52', '2026-02-12 08:38:52'),
(12, '1', NULL, 'Consultation 1 ✅', 'Consultation 1 effectuée avec succès.', 'réussi', '2026-02-12 08:40:00', NULL, '2026-02-12 08:40:00', '2026-02-12 08:40:00'),
(13, 'company', NULL, 'Consultation company ❌', 'Échec lors de consultation company.', 'réussi', '2026-02-12 08:40:12', NULL, '2026-02-12 08:40:12', '2026-02-12 08:40:12'),
(14, 'sector', NULL, 'Consultation sector ✅', 'Consultation sector effectuée avec succès.', 'réussi', '2026-02-12 08:40:22', NULL, '2026-02-12 08:40:22', '2026-02-12 08:40:22'),
(15, 'company', NULL, 'Consultation company ❌', 'Échec lors de consultation company.', 'réussi', '2026-02-12 08:42:09', NULL, '2026-02-12 08:42:09', '2026-02-12 08:42:09'),
(16, 'company', NULL, 'Consultation company ❌', 'Échec lors de consultation company.', 'réussi', '2026-02-12 08:44:56', NULL, '2026-02-12 08:44:56', '2026-02-12 08:44:56'),
(17, 'company', NULL, 'Consultation company ✅', 'Consultation company effectuée avec succès.', 'réussi', '2026-02-12 08:47:09', NULL, '2026-02-12 08:47:09', '2026-02-12 08:47:09'),
(18, 'create', NULL, 'Création create ✅', 'Création create effectuée avec succès.', 'réussi', '2026-02-12 09:03:42', NULL, '2026-02-12 09:03:42', '2026-02-12 09:03:42'),
(19, 'create', NULL, 'Création create ❌', 'Échec lors de création create.', 'réussi', '2026-02-12 09:21:58', NULL, '2026-02-12 09:21:58', '2026-02-12 09:21:58'),
(20, 'create', NULL, 'Création create ✅', 'Création create effectuée avec succès.', 'réussi', '2026-02-12 09:23:45', NULL, '2026-02-12 09:23:45', '2026-02-12 09:23:45'),
(21, 'company', NULL, 'Consultation company ✅', 'Consultation company effectuée avec succès.', 'réussi', '2026-02-12 09:41:02', NULL, '2026-02-12 09:41:02', '2026-02-12 09:41:02'),
(22, 'company', NULL, 'Consultation company ✅', 'Consultation company effectuée avec succès.', 'réussi', '2026-02-12 18:28:35', NULL, '2026-02-12 18:28:35', '2026-02-12 18:28:35'),
(23, 'create', NULL, 'Création create ❌', 'Échec lors de création create.', 'réussi', '2026-02-12 18:44:14', NULL, '2026-02-12 18:44:14', '2026-02-12 18:44:14'),
(24, 'create', NULL, 'Création create ✅', 'Création create effectuée avec succès.', 'réussi', '2026-02-12 18:45:05', NULL, '2026-02-12 18:45:05', '2026-02-12 18:45:05'),
(25, 'create', NULL, 'Création create ✅', 'Création create effectuée avec succès.', 'réussi', '2026-02-12 18:52:54', NULL, '2026-02-12 18:52:54', '2026-02-12 18:52:54'),
(26, 'create', NULL, 'Création create ✅', 'Création create effectuée avec succès.', 'réussi', '2026-02-12 19:00:08', NULL, '2026-02-12 19:00:08', '2026-02-12 19:00:08'),
(27, 'create', NULL, 'Création create ✅', 'Création create effectuée avec succès.', 'réussi', '2026-02-12 19:00:39', NULL, '2026-02-12 19:00:39', '2026-02-12 19:00:39'),
(28, '1', NULL, 'Consultation 1 ✅', 'Consultation 1 effectuée avec succès.', 'réussi', '2026-02-15 07:32:00', NULL, '2026-02-15 07:32:00', '2026-02-15 07:32:00'),
(29, 'createrecharge', NULL, 'Création createrecharge ✅', 'Création createrecharge effectuée avec succès.', 'réussi', '2026-02-15 07:35:37', NULL, '2026-02-15 07:35:37', '2026-02-15 07:35:37'),
(30, 'recharge', NULL, 'Création recharge ✅', 'Création recharge effectuée avec succès.', 'réussi', '2026-02-15 07:35:37', NULL, '2026-02-15 07:35:37', '2026-02-15 07:35:37'),
(31, '1', NULL, 'Consultation 1 ✅', 'Consultation 1 effectuée avec succès.', 'réussi', '2026-02-15 07:35:46', NULL, '2026-02-15 07:35:46', '2026-02-15 07:35:46'),
(32, 'notification_track?userId=1&search=&page=1&pageSize=20', NULL, 'Consultation notification_track?userId=1&search=&page=1&pageSize=20 ✅', 'Consultation notification_track?userId=1&search=&page=1&pageSize=20 effectuée avec succès.', 'réussi', '2026-02-15 07:36:42', NULL, '2026-02-15 07:36:42', '2026-02-15 07:36:42'),
(33, 'sector', NULL, 'Consultation sector ✅', 'Consultation sector effectuée avec succès.', 'réussi', '2026-02-15 07:38:13', NULL, '2026-02-15 07:38:13', '2026-02-15 07:38:13'),
(34, 'retrait', NULL, 'Création retrait ❌', 'Échec lors de création retrait.', 'réussi', '2026-02-15 07:39:37', NULL, '2026-02-15 07:39:37', '2026-02-15 07:39:37'),
(35, 'retrait', NULL, 'Création retrait ❌', 'Échec lors de création retrait.', 'réussi', '2026-02-15 07:51:11', NULL, '2026-02-15 07:51:11', '2026-02-15 07:51:11'),
(39, 'retrait', NULL, 'Création retrait ❌', 'Échec lors de création retrait.', 'réussi', '2026-02-15 07:55:41', NULL, '2026-02-15 07:55:41', '2026-02-15 07:55:41'),
(40, 'Retrait', 10, NULL, 'Retrait effectué', 'réussi', '2026-02-15 07:56:23', NULL, '2026-02-15 07:56:23', '2026-02-15 07:56:23'),
(41, 'Retrait', 10, NULL, 'Retrait client reçu', 'réussi', '2026-02-15 07:56:23', NULL, '2026-02-15 07:56:23', '2026-02-15 07:56:23'),
(42, 'Retrait', 0.2, NULL, 'Frais retrait reçu', 'réussi', '2026-02-15 07:56:23', NULL, '2026-02-15 07:56:23', '2026-02-15 07:56:23'),
(43, 'retrait', NULL, 'Création retrait ✅', 'Création retrait effectuée avec succès.', 'réussi', '2026-02-15 07:56:26', NULL, '2026-02-15 07:56:26', '2026-02-15 07:56:26'),
(44, '1', NULL, 'Consultation 1 ✅', 'Consultation 1 effectuée avec succès.', 'réussi', '2026-02-15 07:56:34', NULL, '2026-02-15 07:56:34', '2026-02-15 07:56:34'),
(45, 'Retrait', 9, NULL, 'Retrait effectué', 'réussi', '2026-02-15 08:08:22', NULL, '2026-02-15 08:08:22', '2026-02-15 08:08:22'),
(46, 'Retrait', 9, NULL, 'Retrait client reçu', 'réussi', '2026-02-15 08:08:22', NULL, '2026-02-15 08:08:22', '2026-02-15 08:08:22'),
(47, 'Retrait', 0.26865, NULL, 'Frais retrait reçu', 'réussi', '2026-02-15 08:08:22', NULL, '2026-02-15 08:08:22', '2026-02-15 08:08:22'),
(48, 'retrait', NULL, 'Création retrait ✅', 'Création retrait effectuée avec succès.', 'réussi', '2026-02-15 08:08:24', NULL, '2026-02-15 08:08:24', '2026-02-15 08:08:24'),
(49, '1', NULL, 'Consultation 1 ✅', 'Consultation 1 effectuée avec succès.', 'réussi', '2026-02-15 08:08:32', NULL, '2026-02-15 08:08:32', '2026-02-15 08:08:32'),
(50, 'Retrait', 20, NULL, 'Retrait effectué', 'réussi', '2026-02-15 08:19:42', NULL, '2026-02-15 08:19:42', '2026-02-15 08:19:42'),
(51, 'Retrait', 20, NULL, 'Retrait client reçu', 'réussi', '2026-02-15 08:19:42', NULL, '2026-02-15 08:19:42', '2026-02-15 08:19:42'),
(52, 'Retrait', 0.597, NULL, 'Frais retrait reçu', 'réussi', '2026-02-15 08:19:42', NULL, '2026-02-15 08:19:42', '2026-02-15 08:19:42'),
(53, 'retrait', NULL, 'Création retrait ✅', 'Création retrait effectuée avec succès.', 'réussi', '2026-02-15 08:19:45', NULL, '2026-02-15 08:19:45', '2026-02-15 08:19:45'),
(54, '1', NULL, 'Consultation 1 ✅', 'Consultation 1 effectuée avec succès.', 'réussi', '2026-02-15 08:19:49', NULL, '2026-02-15 08:19:49', '2026-02-15 08:19:49'),
(55, 'retrait', NULL, 'Création retrait ❌', 'Échec lors de création retrait.', 'réussi', '2026-02-15 08:26:30', NULL, '2026-02-15 08:26:30', '2026-02-15 08:26:30'),
(56, 'retrait', NULL, 'Création retrait ❌', 'Échec lors de création retrait.', 'réussi', '2026-02-15 08:26:47', NULL, '2026-02-15 08:26:47', '2026-02-15 08:26:47'),
(57, '1', NULL, 'Consultation 1 ✅', 'Consultation 1 effectuée avec succès.', 'réussi', '2026-02-15 08:31:47', NULL, '2026-02-15 08:31:47', '2026-02-15 08:31:47'),
(58, 'users?search=&page=1&pageSize=20&paginate=true', NULL, 'Consultation users?search=&page=1&pageSize=20&paginate=true ✅', 'Consultation users?search=&page=1&pageSize=20&paginate=true effectuée avec succès.', 'réussi', '2026-02-15 08:36:13', NULL, '2026-02-15 08:36:13', '2026-02-15 08:36:13'),
(59, 'users?search=john&page=1&pageSize=20&paginate=true', NULL, 'Consultation users?search=john&page=1&pageSize=20&paginate=true ✅', 'Consultation users?search=john&page=1&pageSize=20&paginate=true effectuée avec succès.', 'réussi', '2026-02-15 08:36:36', NULL, '2026-02-15 08:36:36', '2026-02-15 08:36:36'),
(60, 'users?search=joh&page=1&pageSize=20&paginate=true', NULL, 'Consultation users?search=joh&page=1&pageSize=20&paginate=true ✅', 'Consultation users?search=joh&page=1&pageSize=20&paginate=true effectuée avec succès.', 'réussi', '2026-02-15 08:36:51', NULL, '2026-02-15 08:36:51', '2026-02-15 08:36:51'),
(61, 'users?search=john&page=1&pageSize=20&paginate=true', NULL, 'Consultation users?search=john&page=1&pageSize=20&paginate=true ❌', 'Échec lors de consultation users?search=john&page=1&pagesize=20&paginate=true.', 'réussi', '2026-02-15 08:36:51', NULL, '2026-02-15 08:36:51', '2026-02-15 08:36:51'),
(62, 'users?search=jo&page=1&pageSize=20&paginate=true', NULL, 'Consultation users?search=jo&page=1&pageSize=20&paginate=true ✅', 'Consultation users?search=jo&page=1&pageSize=20&paginate=true effectuée avec succès.', 'réussi', '2026-02-15 08:36:51', NULL, '2026-02-15 08:36:51', '2026-02-15 08:36:51'),
(63, 'users?search=jo&page=1&pageSize=20&paginate=true', NULL, 'Consultation users?search=jo&page=1&pageSize=20&paginate=true ❌', 'Échec lors de consultation users?search=jo&page=1&pagesize=20&paginate=true.', 'réussi', '2026-02-15 08:36:51', NULL, '2026-02-15 08:36:51', '2026-02-15 08:36:51'),
(64, 'users?search=j&page=1&pageSize=20&paginate=true', NULL, 'Consultation users?search=j&page=1&pageSize=20&paginate=true ✅', 'Consultation users?search=j&page=1&pageSize=20&paginate=true effectuée avec succès.', 'réussi', '2026-02-15 08:36:51', NULL, '2026-02-15 08:36:52', '2026-02-15 08:36:52'),
(65, 'users?search=j&page=1&pageSize=20&paginate=true', NULL, 'Consultation users?search=j&page=1&pageSize=20&paginate=true ❌', 'Échec lors de consultation users?search=j&page=1&pagesize=20&paginate=true.', 'réussi', '2026-02-15 08:36:52', NULL, '2026-02-15 08:36:52', '2026-02-15 08:36:52'),
(66, 'users?search=user_9gqpq&page=1&pageSize=20&paginate=true', NULL, 'Consultation users?search=user_9gqpq&page=1&pageSize=20&paginate=true ✅', 'Consultation users?search=user_9gqpq&page=1&pageSize=20&paginate=true effectuée avec succès.', 'réussi', '2026-02-15 08:36:55', NULL, '2026-02-15 08:36:55', '2026-02-15 08:36:55'),
(67, 'Transfert', 5, NULL, 'Transfert avec frais', 'réussi', '2026-02-15 08:37:03', NULL, '2026-02-15 08:37:03', '2026-02-15 08:37:03'),
(68, 'transfert', NULL, 'Création transfert ✅', 'Création transfert effectuée avec succès.', 'réussi', '2026-02-15 08:37:03', NULL, '2026-02-15 08:37:03', '2026-02-15 08:37:03'),
(69, '1', NULL, 'Consultation 1 ✅', 'Consultation 1 effectuée avec succès.', 'réussi', '2026-02-15 08:37:10', NULL, '2026-02-15 08:37:10', '2026-02-15 08:37:10'),
(70, 'create', NULL, 'Création create ❌', 'Échec lors de création create.', 'réussi', '2026-02-15 08:38:29', NULL, '2026-02-15 08:38:29', '2026-02-15 08:38:29'),
(71, 'create', NULL, 'Création create ❌', 'Échec lors de création create.', 'réussi', '2026-02-15 08:38:41', NULL, '2026-02-15 08:38:41', '2026-02-15 08:38:41'),
(72, 'create', NULL, 'Création create ❌', 'Échec lors de création create.', 'réussi', '2026-02-15 08:45:20', NULL, '2026-02-15 08:45:20', '2026-02-15 08:45:20'),
(73, 'create', NULL, 'Création create ❌', 'Échec lors de création create.', 'réussi', '2026-02-15 08:46:50', NULL, '2026-02-15 08:46:50', '2026-02-15 08:46:50'),
(74, 'create', NULL, 'Création create ❌', 'Échec lors de création create.', 'réussi', '2026-02-15 08:48:57', NULL, '2026-02-15 08:48:57', '2026-02-15 08:48:57'),
(75, 'create', NULL, 'Création create ✅', 'Création create effectuée avec succès.', 'réussi', '2026-02-15 08:49:14', NULL, '2026-02-15 08:49:14', '2026-02-15 08:49:14'),
(76, '1', NULL, 'Consultation 1 ❌', 'Échec lors de consultation 1.', 'réussi', '2026-02-15 08:49:18', NULL, '2026-02-15 08:49:18', '2026-02-15 08:49:18'),
(77, 'notification_track?userId=1&search=&page=1&pageSize=20', NULL, 'Consultation notification_track?userId=1&search=&page=1&pageSize=20 ✅', 'Consultation notification_track?userId=1&search=&page=1&pageSize=20 effectuée avec succès.', 'réussi', '2026-02-15 08:49:21', NULL, '2026-02-15 08:49:21', '2026-02-15 08:49:21'),
(78, '1', NULL, 'Consultation 1 ✅', 'Consultation 1 effectuée avec succès.', 'réussi', '2026-02-15 09:35:22', NULL, '2026-02-15 09:35:22', '2026-02-15 09:35:22'),
(79, 'sector?page=1&pageSize=10', NULL, 'Consultation sector?page=1&pageSize=10 ✅', 'Consultation sector?page=1&pageSize=10 effectuée avec succès.', 'réussi', '2026-02-15 09:35:30', NULL, '2026-02-15 09:35:30', '2026-02-15 09:35:30'),
(80, 'sector?page=1&pageSize=10&search=', NULL, 'Consultation sector?page=1&pageSize=10&search= ✅', 'Consultation sector?page=1&pageSize=10&search= effectuée avec succès.', 'réussi', '2026-02-15 09:37:33', NULL, '2026-02-15 09:37:33', '2026-02-15 09:37:33'),
(81, 'sector?page=1&pageSize=10&search=J', NULL, 'Consultation sector?page=1&pageSize=10&search=J ✅', 'Consultation sector?page=1&pageSize=10&search=J effectuée avec succès.', 'réussi', '2026-02-15 09:38:51', NULL, '2026-02-15 09:38:51', '2026-02-15 09:38:51'),
(82, 'sector?page=1&pageSize=10&search=S', NULL, 'Consultation sector?page=1&pageSize=10&search=S ✅', 'Consultation sector?page=1&pageSize=10&search=S effectuée avec succès.', 'réussi', '2026-02-15 09:38:53', NULL, '2026-02-15 09:38:53', '2026-02-15 09:38:53'),
(83, 'sector?page=1&pageSize=10&search=Se', NULL, 'Consultation sector?page=1&pageSize=10&search=Se ✅', 'Consultation sector?page=1&pageSize=10&search=Se effectuée avec succès.', 'réussi', '2026-02-15 09:38:54', NULL, '2026-02-15 09:38:54', '2026-02-15 09:38:54'),
(84, 'sector?page=1&pageSize=10&search=B', NULL, 'Consultation sector?page=1&pageSize=10&search=B ✅', 'Consultation sector?page=1&pageSize=10&search=B effectuée avec succès.', 'réussi', '2026-02-15 09:38:55', NULL, '2026-02-15 09:38:55', '2026-02-15 09:38:55'),
(85, 'sector?page=1&pageSize=10&search=Bi', NULL, 'Consultation sector?page=1&pageSize=10&search=Bi ✅', 'Consultation sector?page=1&pageSize=10&search=Bi effectuée avec succès.', 'réussi', '2026-02-15 09:38:56', NULL, '2026-02-15 09:38:56', '2026-02-15 09:38:56'),
(86, 'sector?page=1&pageSize=10&search=Bim', NULL, 'Consultation sector?page=1&pageSize=10&search=Bim ✅', 'Consultation sector?page=1&pageSize=10&search=Bim effectuée avec succès.', 'réussi', '2026-02-15 09:38:56', NULL, '2026-02-15 09:38:56', '2026-02-15 09:38:56'),
(87, 'sector?page=1&pageSize=10&search=Bims', NULL, 'Consultation sector?page=1&pageSize=10&search=Bims ✅', 'Consultation sector?page=1&pageSize=10&search=Bims effectuée avec succès.', 'réussi', '2026-02-15 09:38:57', NULL, '2026-02-15 09:38:57', '2026-02-15 09:38:57'),
(88, 'sector?page=1&pageSize=10&search=Bims%E2%80%99', NULL, 'Consultation sector?page=1&pageSize=10&search=Bims%E2%80%99 ✅', 'Consultation sector?page=1&pageSize=10&search=Bims%E2%80%99 effectuée avec succès.', 'réussi', '2026-02-15 09:38:57', NULL, '2026-02-15 09:38:57', '2026-02-15 09:38:57'),
(89, 'sector?page=1&pageSize=10&search=D', NULL, 'Consultation sector?page=1&pageSize=10&search=D ✅', 'Consultation sector?page=1&pageSize=10&search=D effectuée avec succès.', 'réussi', '2026-02-15 09:39:00', NULL, '2026-02-15 09:39:00', '2026-02-15 09:39:00'),
(90, 'sector?page=1&pageSize=10&search=Dj', NULL, 'Consultation sector?page=1&pageSize=10&search=Dj ✅', 'Consultation sector?page=1&pageSize=10&search=Dj effectuée avec succès.', 'réussi', '2026-02-15 09:39:00', NULL, '2026-02-15 09:39:00', '2026-02-15 09:39:00'),
(91, 'sector?page=1&pageSize=10&search=Djs', NULL, 'Consultation sector?page=1&pageSize=10&search=Djs ✅', 'Consultation sector?page=1&pageSize=10&search=Djs effectuée avec succès.', 'réussi', '2026-02-15 09:39:00', NULL, '2026-02-15 09:39:00', '2026-02-15 09:39:00'),
(92, 'sector?page=1&pageSize=10&search=Sa', NULL, 'Consultation sector?page=1&pageSize=10&search=Sa ✅', 'Consultation sector?page=1&pageSize=10&search=Sa effectuée avec succès.', 'réussi', '2026-02-15 09:39:04', NULL, '2026-02-15 09:39:04', '2026-02-15 09:39:04'),
(93, 'sector?page=1&pageSize=10&search=San', NULL, 'Consultation sector?page=1&pageSize=10&search=San ✅', 'Consultation sector?page=1&pageSize=10&search=San effectuée avec succès.', 'réussi', '2026-02-15 09:39:04', NULL, '2026-02-15 09:39:04', '2026-02-15 09:39:04'),
(94, 'sector?page=1&pageSize=10&search=Sant', NULL, 'Consultation sector?page=1&pageSize=10&search=Sant ✅', 'Consultation sector?page=1&pageSize=10&search=Sant effectuée avec succès.', 'réussi', '2026-02-15 09:39:05', NULL, '2026-02-15 09:39:05', '2026-02-15 09:39:05'),
(95, 'sector?page=1&pageSize=10&search=C', NULL, 'Consultation sector?page=1&pageSize=10&search=C ✅', 'Consultation sector?page=1&pageSize=10&search=C effectuée avec succès.', 'réussi', '2026-02-15 09:43:29', NULL, '2026-02-15 09:43:29', '2026-02-15 09:43:29'),
(96, 'sector?page=1&pageSize=10&search=Cv', NULL, 'Consultation sector?page=1&pageSize=10&search=Cv ✅', 'Consultation sector?page=1&pageSize=10&search=Cv effectuée avec succès.', 'réussi', '2026-02-15 09:43:29', NULL, '2026-02-15 09:43:29', '2026-02-15 09:43:29'),
(97, 'sector?page=1&pageSize=10&search=Cvv', NULL, 'Consultation sector?page=1&pageSize=10&search=Cvv ✅', 'Consultation sector?page=1&pageSize=10&search=Cvv effectuée avec succès.', 'réussi', '2026-02-15 09:43:29', NULL, '2026-02-15 09:43:29', '2026-02-15 09:43:29'),
(98, 'sector?page=1&pageSize=10&search=Cvvs', NULL, 'Consultation sector?page=1&pageSize=10&search=Cvvs ✅', 'Consultation sector?page=1&pageSize=10&search=Cvvs effectuée avec succès.', 'réussi', '2026-02-15 09:43:30', NULL, '2026-02-15 09:43:30', '2026-02-15 09:43:30'),
(99, 'sector?page=1&pageSize=10&search=Cf', NULL, 'Consultation sector?page=1&pageSize=10&search=Cf ✅', 'Consultation sector?page=1&pageSize=10&search=Cf effectuée avec succès.', 'réussi', '2026-02-15 09:43:32', NULL, '2026-02-15 09:43:32', '2026-02-15 09:43:32'),
(100, 'sector?page=1&pageSize=10&search=Cfb', NULL, 'Consultation sector?page=1&pageSize=10&search=Cfb ✅', 'Consultation sector?page=1&pageSize=10&search=Cfb effectuée avec succès.', 'réussi', '2026-02-15 09:43:32', NULL, '2026-02-15 09:43:32', '2026-02-15 09:43:32'),
(101, 'sector?page=1&pageSize=10&search=C', NULL, 'Consultation sector?page=1&pageSize=10&search=C ❌', 'Échec lors de consultation sector?page=1&pagesize=10&search=c.', 'réussi', '2026-02-15 09:45:25', NULL, '2026-02-15 09:45:25', '2026-02-15 09:45:25'),
(102, 'sector?page=1&pageSize=10&search=Cc', NULL, 'Consultation sector?page=1&pageSize=10&search=Cc ✅', 'Consultation sector?page=1&pageSize=10&search=Cc effectuée avec succès.', 'réussi', '2026-02-15 09:45:26', NULL, '2026-02-15 09:45:26', '2026-02-15 09:45:26'),
(103, 'sector?page=1&pageSize=10&search=Cc%E2%80%99', NULL, 'Consultation sector?page=1&pageSize=10&search=Cc%E2%80%99 ✅', 'Consultation sector?page=1&pageSize=10&search=Cc%E2%80%99 effectuée avec succès.', 'réussi', '2026-02-15 09:45:28', NULL, '2026-02-15 09:45:28', '2026-02-15 09:45:28'),
(104, 'sector?page=1&pageSize=10&search=Cc%E2%80%99v', NULL, 'Consultation sector?page=1&pageSize=10&search=Cc%E2%80%99v ✅', 'Consultation sector?page=1&pageSize=10&search=Cc%E2%80%99v effectuée avec succès.', 'réussi', '2026-02-15 09:45:28', NULL, '2026-02-15 09:45:28', '2026-02-15 09:45:28'),
(105, 'sector?page=1&pageSize=10&search=D', NULL, 'Consultation sector?page=1&pageSize=10&search=D ❌', 'Échec lors de consultation sector?page=1&pagesize=10&search=d.', 'réussi', '2026-02-15 09:45:38', NULL, '2026-02-15 09:45:38', '2026-02-15 09:45:38'),
(106, 'sector?page=1&pageSize=10&search=Dw', NULL, 'Consultation sector?page=1&pageSize=10&search=Dw ✅', 'Consultation sector?page=1&pageSize=10&search=Dw effectuée avec succès.', 'réussi', '2026-02-15 09:45:39', NULL, '2026-02-15 09:45:39', '2026-02-15 09:45:39'),
(107, 'sector?page=1&pageSize=10&search=De', NULL, 'Consultation sector?page=1&pageSize=10&search=De ✅', 'Consultation sector?page=1&pageSize=10&search=De effectuée avec succès.', 'réussi', '2026-02-15 09:45:40', NULL, '2026-02-15 09:45:40', '2026-02-15 09:45:40'),
(108, '1', NULL, 'Consultation 1 ❌', 'Échec lors de consultation 1.', 'réussi', '2026-02-15 09:46:44', NULL, '2026-02-15 09:46:44', '2026-02-15 09:46:44'),
(109, 'sector?page=1&pageSize=15&search=', NULL, 'Consultation sector?page=1&pageSize=15&search= ✅', 'Consultation sector?page=1&pageSize=15&search= effectuée avec succès.', 'réussi', '2026-02-15 09:47:20', NULL, '2026-02-15 09:47:20', '2026-02-15 09:47:20'),
(110, '1', NULL, 'Consultation 1 ❌', 'Échec lors de consultation 1.', 'réussi', '2026-02-15 09:48:36', NULL, '2026-02-15 09:48:36', '2026-02-15 09:48:36'),
(111, '1', NULL, 'Consultation 1 ✅', 'Consultation 1 effectuée avec succès.', 'réussi', '2026-02-15 09:53:17', NULL, '2026-02-15 09:53:17', '2026-02-15 09:53:17'),
(112, 'connexion', NULL, 'Échec de la connexion ❌', 'Une tentative de connexion a été détectée, mais elle a échoué.', 'réussi', '2026-02-15 09:53:37', NULL, '2026-02-15 09:53:37', '2026-02-15 09:53:37'),
(113, 'create', NULL, 'Création create ✅', 'Création create effectuée avec succès.', 'réussi', '2026-02-15 09:53:37', NULL, '2026-02-15 09:53:37', '2026-02-15 09:53:37'),
(114, 'create', NULL, 'Création create ✅', 'Création create effectuée avec succès.', 'réussi', '2026-02-15 09:53:37', NULL, '2026-02-15 09:53:37', '2026-02-15 09:53:37'),
(115, 'sector?page=1&pageSize=10&search=', NULL, 'Consultation sector?page=1&pageSize=10&search= ❌', 'Échec lors de consultation sector?page=1&pagesize=10&search=.', 'réussi', '2026-02-15 09:54:00', NULL, '2026-02-15 09:54:00', '2026-02-15 09:54:00'),
(116, '1', NULL, 'Consultation 1 ✅', 'Consultation 1 effectuée avec succès.', 'réussi', '2026-02-15 09:55:38', NULL, '2026-02-15 09:55:38', '2026-02-15 09:55:38'),
(117, 'sector?page=1&pageSize=10&search=', NULL, 'Consultation sector?page=1&pageSize=10&search= ❌', 'Échec lors de consultation sector?page=1&pagesize=10&search=.', 'réussi', '2026-02-15 09:56:01', NULL, '2026-02-15 09:56:01', '2026-02-15 09:56:01'),
(118, 'sector?page=1&pageSize=10&search=&paginate=true', NULL, 'Consultation sector?page=1&pageSize=10&search=&paginate=true ✅', 'Consultation sector?page=1&pageSize=10&search=&paginate=true effectuée avec succès.', 'réussi', '2026-02-15 09:58:26', NULL, '2026-02-15 09:58:26', '2026-02-15 09:58:26'),
(119, 'sector?page=2&pageSize=10&search=&paginate=true', NULL, 'Consultation sector?page=2&pageSize=10&search=&paginate=true ✅', 'Consultation sector?page=2&pageSize=10&search=&paginate=true effectuée avec succès.', 'réussi', '2026-02-15 09:58:32', NULL, '2026-02-15 09:58:32', '2026-02-15 09:58:32'),
(120, 'sector?page=1&pageSize=10&search=&paginate=true', NULL, 'Consultation sector?page=1&pageSize=10&search=&paginate=true ❌', 'Échec lors de consultation sector?page=1&pagesize=10&search=&paginate=true.', 'réussi', '2026-02-15 09:59:55', NULL, '2026-02-15 09:59:55', '2026-02-15 09:59:55'),
(121, '1', NULL, 'Consultation 1 ✅', 'Consultation 1 effectuée avec succès.', 'réussi', '2026-02-15 10:00:11', NULL, '2026-02-15 10:00:11', '2026-02-15 10:00:11'),
(122, 'sector?page=1&pageSize=10&search=&paginate=true', NULL, 'Consultation sector?page=1&pageSize=10&search=&paginate=true ❌', 'Échec lors de consultation sector?page=1&pagesize=10&search=&paginate=true.', 'réussi', '2026-02-15 10:00:36', NULL, '2026-02-15 10:00:36', '2026-02-15 10:00:36'),
(123, 'sector?page=2&pageSize=10&search=&paginate=true', NULL, 'Consultation sector?page=2&pageSize=10&search=&paginate=true ❌', 'Échec lors de consultation sector?page=2&pagesize=10&search=&paginate=true.', 'réussi', '2026-02-15 10:00:40', NULL, '2026-02-15 10:00:40', '2026-02-15 10:00:40'),
(124, 'sector?page=2&pageSize=10&search=N&paginate=true', NULL, 'Consultation sector?page=2&pageSize=10&search=N&paginate=true ✅', 'Consultation sector?page=2&pageSize=10&search=N&paginate=true effectuée avec succès.', 'réussi', '2026-02-15 10:00:50', NULL, '2026-02-15 10:00:50', '2026-02-15 10:00:50'),
(125, 'sector?page=1&pageSize=10&search=N&paginate=true', NULL, 'Consultation sector?page=1&pageSize=10&search=N&paginate=true ✅', 'Consultation sector?page=1&pageSize=10&search=N&paginate=true effectuée avec succès.', 'réussi', '2026-02-15 10:00:50', NULL, '2026-02-15 10:00:50', '2026-02-15 10:00:50'),
(126, 'sector?page=1&pageSize=10&search=Ns&paginate=true', NULL, 'Consultation sector?page=1&pageSize=10&search=Ns&paginate=true ✅', 'Consultation sector?page=1&pageSize=10&search=Ns&paginate=true effectuée avec succès.', 'réussi', '2026-02-15 10:00:51', NULL, '2026-02-15 10:00:51', '2026-02-15 10:00:51'),
(127, 'sector?page=1&pageSize=10&search=Js&paginate=true', NULL, 'Consultation sector?page=1&pageSize=10&search=Js&paginate=true ✅', 'Consultation sector?page=1&pageSize=10&search=Js&paginate=true effectuée avec succès.', 'réussi', '2026-02-15 10:00:53', NULL, '2026-02-15 10:00:53', '2026-02-15 10:00:53'),
(128, '1', NULL, 'Consultation 1 ✅', 'Consultation 1 effectuée avec succès.', 'réussi', '2026-02-15 11:41:01', NULL, '2026-02-15 11:41:01', '2026-02-15 11:41:01'),
(129, 'sector?page=1&pageSize=10&search=&paginate=true', NULL, 'Consultation sector?page=1&pageSize=10&search=&paginate=true ❌', 'Échec lors de consultation sector?page=1&pagesize=10&search=&paginate=true.', 'réussi', '2026-02-15 11:41:09', NULL, '2026-02-15 11:41:09', '2026-02-15 11:41:09'),
(130, '1', NULL, 'Consultation 1 ❌', 'Échec lors de consultation 1.', 'réussi', '2026-02-15 11:54:02', NULL, '2026-02-15 11:54:02', '2026-02-15 11:54:02'),
(131, 'sector?page=1&pageSize=10&search=&paginate=true', NULL, 'Consultation sector?page=1&pageSize=10&search=&paginate=true ❌', 'Échec lors de consultation sector?page=1&pagesize=10&search=&paginate=true.', 'réussi', '2026-02-15 11:54:44', NULL, '2026-02-15 11:54:44', '2026-02-15 11:54:44'),
(132, '1', NULL, 'Consultation 1 ✅', 'Consultation 1 effectuée avec succès.', 'réussi', '2026-02-15 12:01:04', NULL, '2026-02-15 12:01:04', '2026-02-15 12:01:04'),
(133, 'sector?page=1&pageSize=10&search=&paginate=true', NULL, 'Consultation sector?page=1&pageSize=10&search=&paginate=true ❌', 'Échec lors de consultation sector?page=1&pagesize=10&search=&paginate=true.', 'réussi', '2026-02-15 12:01:29', NULL, '2026-02-15 12:01:29', '2026-02-15 12:01:29'),
(134, 'sector?page=1&pageSize=10&search=&paginate=true', NULL, 'Consultation sector?page=1&pageSize=10&search=&paginate=true ❌', 'Échec lors de consultation sector?page=1&pagesize=10&search=&paginate=true.', 'réussi', '2026-02-15 12:03:38', NULL, '2026-02-15 12:03:38', '2026-02-15 12:03:38'),
(135, 'sector?page=1&pageSize=10&search=&paginate=true', NULL, 'Consultation sector?page=1&pageSize=10&search=&paginate=true ❌', 'Échec lors de consultation sector?page=1&pagesize=10&search=&paginate=true.', 'réussi', '2026-02-15 12:03:41', NULL, '2026-02-15 12:03:41', '2026-02-15 12:03:41'),
(136, '1', NULL, 'Consultation 1 ✅', 'Consultation 1 effectuée avec succès.', 'réussi', '2026-02-15 12:05:45', NULL, '2026-02-15 12:05:45', '2026-02-15 12:05:45'),
(137, 'sector?page=1&pageSize=10&search=&paginate=true', NULL, 'Consultation sector?page=1&pageSize=10&search=&paginate=true ❌', 'Échec lors de consultation sector?page=1&pagesize=10&search=&paginate=true.', 'réussi', '2026-02-15 12:06:45', NULL, '2026-02-15 12:06:45', '2026-02-15 12:06:45'),
(138, 'sector?page=2&pageSize=10&search=&paginate=true', NULL, 'Consultation sector?page=2&pageSize=10&search=&paginate=true ❌', 'Échec lors de consultation sector?page=2&pagesize=10&search=&paginate=true.', 'réussi', '2026-02-15 12:07:04', NULL, '2026-02-15 12:07:04', '2026-02-15 12:07:04'),
(139, '1', NULL, 'Consultation 1 ✅', 'Consultation 1 effectuée avec succès.', 'réussi', '2026-02-15 12:07:16', NULL, '2026-02-15 12:07:16', '2026-02-15 12:07:16'),
(140, 'sector?page=1&pageSize=10&search=&paginate=true', NULL, 'Consultation sector?page=1&pageSize=10&search=&paginate=true ❌', 'Échec lors de consultation sector?page=1&pagesize=10&search=&paginate=true.', 'réussi', '2026-02-15 12:11:33', NULL, '2026-02-15 12:11:33', '2026-02-15 12:11:33'),
(141, '1', NULL, 'Consultation 1 ❌', 'Échec lors de consultation 1.', 'réussi', '2026-02-15 12:13:12', NULL, '2026-02-15 12:13:12', '2026-02-15 12:13:12'),
(142, 'sector?page=1&pageSize=10&search=&paginate=true', NULL, 'Consultation sector?page=1&pageSize=10&search=&paginate=true ❌', 'Échec lors de consultation sector?page=1&pagesize=10&search=&paginate=true.', 'réussi', '2026-02-15 12:14:07', NULL, '2026-02-15 12:14:07', '2026-02-15 12:14:07'),
(143, 'sector?page=2&pageSize=10&search=&paginate=true', NULL, 'Consultation sector?page=2&pageSize=10&search=&paginate=true ❌', 'Échec lors de consultation sector?page=2&pagesize=10&search=&paginate=true.', 'réussi', '2026-02-15 12:15:35', NULL, '2026-02-15 12:15:35', '2026-02-15 12:15:35'),
(144, 'sector?page=1&pageSize=10&search=&paginate=true', NULL, 'Consultation sector?page=1&pageSize=10&search=&paginate=true ❌', 'Échec lors de consultation sector?page=1&pagesize=10&search=&paginate=true.', 'réussi', '2026-02-15 12:17:36', NULL, '2026-02-15 12:17:36', '2026-02-15 12:17:36'),
(145, 'sector?page=2&pageSize=10&search=&paginate=true', NULL, 'Consultation sector?page=2&pageSize=10&search=&paginate=true ❌', 'Échec lors de consultation sector?page=2&pagesize=10&search=&paginate=true.', 'réussi', '2026-02-15 12:19:54', NULL, '2026-02-15 12:19:54', '2026-02-15 12:19:54'),
(146, '1', NULL, 'Consultation 1 ✅', 'Consultation 1 effectuée avec succès.', 'réussi', '2026-02-15 12:23:52', NULL, '2026-02-15 12:23:52', '2026-02-15 12:23:52'),
(147, 'sector?page=1&pageSize=10&search=&paginate=true', NULL, 'Consultation sector?page=1&pageSize=10&search=&paginate=true ❌', 'Échec lors de consultation sector?page=1&pagesize=10&search=&paginate=true.', 'réussi', '2026-02-15 12:24:59', NULL, '2026-02-15 12:24:59', '2026-02-15 12:24:59'),
(148, 'sector?page=1&pageSize=10&search=&paginate=true', NULL, 'Consultation sector?page=1&pageSize=10&search=&paginate=true ❌', 'Échec lors de consultation sector?page=1&pagesize=10&search=&paginate=true.', 'réussi', '2026-02-15 12:32:48', NULL, '2026-02-15 12:32:48', '2026-02-15 12:32:48'),
(149, '1', NULL, 'Consultation 1 ✅', 'Consultation 1 effectuée avec succès.', 'réussi', '2026-02-15 12:34:34', NULL, '2026-02-15 12:34:34', '2026-02-15 12:34:34'),
(150, 'sector?page=1&pageSize=10&search=&paginate=true', NULL, 'Consultation sector?page=1&pageSize=10&search=&paginate=true ❌', 'Échec lors de consultation sector?page=1&pagesize=10&search=&paginate=true.', 'réussi', '2026-02-15 12:35:08', NULL, '2026-02-15 12:35:08', '2026-02-15 12:35:08'),
(151, '1', NULL, 'Consultation 1 ✅', 'Consultation 1 effectuée avec succès.', 'réussi', '2026-02-15 12:44:21', NULL, '2026-02-15 12:44:21', '2026-02-15 12:44:21'),
(152, 'connexion', NULL, 'Échec de la connexion ❌', 'Une tentative de connexion a été détectée, mais elle a échoué.', 'réussi', '2026-02-15 12:45:41', NULL, '2026-02-15 12:45:41', '2026-02-15 12:45:41'),
(153, 'create', NULL, 'Création create ✅', 'Création create effectuée avec succès.', 'réussi', '2026-02-15 12:45:41', NULL, '2026-02-15 12:45:41', '2026-02-15 12:45:41'),
(154, 'create', NULL, 'Création create ✅', 'Création create effectuée avec succès.', 'réussi', '2026-02-15 12:45:41', NULL, '2026-02-15 12:45:41', '2026-02-15 12:45:41'),
(155, 'sector?page=1&pageSize=10&search=&paginate=true', NULL, 'Consultation sector?page=1&pageSize=10&search=&paginate=true ❌', 'Échec lors de consultation sector?page=1&pagesize=10&search=&paginate=true.', 'réussi', '2026-02-15 12:46:03', NULL, '2026-02-15 12:46:03', '2026-02-15 12:46:03'),
(156, 'sector?page=2&pageSize=10&search=&paginate=true', NULL, 'Consultation sector?page=2&pageSize=10&search=&paginate=true ❌', 'Échec lors de consultation sector?page=2&pagesize=10&search=&paginate=true.', 'réussi', '2026-02-15 12:50:30', NULL, '2026-02-15 12:50:30', '2026-02-15 12:50:30'),
(157, '1', NULL, 'Consultation 1 ✅', 'Consultation 1 effectuée avec succès.', 'réussi', '2026-02-15 12:57:30', NULL, '2026-02-15 12:57:30', '2026-02-15 12:57:30'),
(158, 'sector?page=1&pageSize=10&search=&paginate=true', NULL, 'Consultation sector?page=1&pageSize=10&search=&paginate=true ❌', 'Échec lors de consultation sector?page=1&pagesize=10&search=&paginate=true.', 'réussi', '2026-02-15 12:58:07', NULL, '2026-02-15 12:58:07', '2026-02-15 12:58:07'),
(159, 'sector?page=2&pageSize=10&search=&paginate=true', NULL, 'Consultation sector?page=2&pageSize=10&search=&paginate=true ❌', 'Échec lors de consultation sector?page=2&pagesize=10&search=&paginate=true.', 'réussi', '2026-02-15 13:00:54', NULL, '2026-02-15 13:00:54', '2026-02-15 13:00:54'),
(160, 'profile', NULL, 'Mise à jour profile ✅', 'Mise à jour profile effectuée avec succès.', 'réussi', '2026-02-15 13:08:36', NULL, '2026-02-15 13:08:36', '2026-02-15 13:08:36'),
(161, '1', NULL, 'Consultation 1 ✅', 'Consultation 1 effectuée avec succès.', 'réussi', '2026-02-15 13:08:36', NULL, '2026-02-15 13:08:36', '2026-02-15 13:08:36'),
(162, '1', NULL, 'Consultation 1 ❌', 'Échec lors de consultation 1.', 'réussi', '2026-02-15 13:16:06', NULL, '2026-02-15 13:16:06', '2026-02-15 13:16:06'),
(163, '2', NULL, 'Consultation 2 ❌', 'Échec lors de consultation 2.', 'réussi', '2026-02-15 13:16:14', NULL, '2026-02-15 13:16:14', '2026-02-15 13:16:14'),
(164, '2', NULL, 'Consultation 2 ❌', 'Échec lors de consultation 2.', 'réussi', '2026-02-15 13:21:23', NULL, '2026-02-15 13:21:23', '2026-02-15 13:21:23'),
(165, '1', NULL, 'Consultation 1 ❌', 'Échec lors de consultation 1.', 'réussi', '2026-02-15 13:21:32', NULL, '2026-02-15 13:21:32', '2026-02-15 13:21:32'),
(166, 'company', NULL, 'Consultation company ✅', 'Consultation company effectuée avec succès.', 'réussi', '2026-02-15 13:21:39', NULL, '2026-02-15 13:21:39', '2026-02-15 13:21:39'),
(167, '8', NULL, 'Consultation 8 ✅', 'Consultation 8 effectuée avec succès.', 'réussi', '2026-02-15 13:21:53', NULL, '2026-02-15 13:21:53', '2026-02-15 13:21:53'),
(168, '1', NULL, 'Consultation 1 ✅', 'Consultation 1 effectuée avec succès.', 'réussi', '2026-02-15 13:26:28', NULL, '2026-02-15 13:26:28', '2026-02-15 13:26:28'),
(169, 'sector?page=1&pageSize=10&search=&paginate=true', NULL, 'Consultation sector?page=1&pageSize=10&search=&paginate=true ❌', 'Échec lors de consultation sector?page=1&pagesize=10&search=&paginate=true.', 'réussi', '2026-02-15 13:27:24', NULL, '2026-02-15 13:27:24', '2026-02-15 13:27:24'),
(170, '8', NULL, 'Consultation 8 ✅', 'Consultation 8 effectuée avec succès.', 'réussi', '2026-02-15 13:28:23', NULL, '2026-02-15 13:28:23', '2026-02-15 13:28:23'),
(171, '8', NULL, 'Consultation 8 ❌', 'Échec lors de consultation 8.', 'réussi', '2026-02-15 13:40:35', NULL, '2026-02-15 13:40:35', '2026-02-15 13:40:35'),
(172, '8', NULL, 'Consultation 8 ❌', 'Échec lors de consultation 8.', 'réussi', '2026-02-15 13:43:14', NULL, '2026-02-15 13:43:14', '2026-02-15 13:43:14'),
(173, 'product', NULL, 'Consultation product ✅', 'Consultation product effectuée avec succès.', 'réussi', '2026-02-15 13:49:02', NULL, '2026-02-15 13:49:02', '2026-02-15 13:49:02'),
(174, 'sector?page=2&pageSize=10&search=&paginate=true', NULL, 'Consultation sector?page=2&pageSize=10&search=&paginate=true ❌', 'Échec lors de consultation sector?page=2&pagesize=10&search=&paginate=true.', 'réussi', '2026-02-15 13:56:34', NULL, '2026-02-15 13:56:34', '2026-02-15 13:56:34'),
(175, 'product?companyId=8', NULL, 'Consultation product?companyId=8 ✅', 'Consultation product?companyId=8 effectuée avec succès.', 'réussi', '2026-02-15 13:58:46', NULL, '2026-02-15 13:58:46', '2026-02-15 13:58:46'),
(176, 'product?companyId=8', NULL, 'Consultation product?companyId=8 ✅', 'Consultation product?companyId=8 effectuée avec succès.', 'réussi', '2026-02-15 13:59:50', NULL, '2026-02-15 13:59:50', '2026-02-15 13:59:50'),
(177, '1', NULL, 'Consultation 1 ✅', 'Consultation 1 effectuée avec succès.', 'réussi', '2026-02-15 14:22:11', NULL, '2026-02-15 14:22:11', '2026-02-15 14:22:11'),
(178, 'sector?page=1&pageSize=10&search=&paginate=true', NULL, 'Consultation sector?page=1&pageSize=10&search=&paginate=true ❌', 'Échec lors de consultation sector?page=1&pagesize=10&search=&paginate=true.', 'réussi', '2026-02-15 14:22:41', NULL, '2026-02-15 14:22:41', '2026-02-15 14:22:41'),
(179, '1', NULL, 'Consultation 1 ✅', 'Consultation 1 effectuée avec succès.', 'réussi', '2026-02-15 14:24:23', NULL, '2026-02-15 14:24:23', '2026-02-15 14:24:23'),
(180, 'sector?page=1&pageSize=10&search=&paginate=true', NULL, 'Consultation sector?page=1&pageSize=10&search=&paginate=true ❌', 'Échec lors de consultation sector?page=1&pagesize=10&search=&paginate=true.', 'réussi', '2026-02-15 14:24:50', NULL, '2026-02-15 14:24:50', '2026-02-15 14:24:50'),
(181, 'product?page=1&pageSize=10&search=&paginate=true', NULL, 'Consultation product?page=1&pageSize=10&search=&paginate=true ✅', 'Consultation product?page=1&pageSize=10&search=&paginate=true effectuée avec succès.', 'réussi', '2026-02-15 14:24:53', NULL, '2026-02-15 14:24:53', '2026-02-15 14:24:53'),
(182, 'product?page=2&pageSize=10&search=&paginate=true', NULL, 'Consultation product?page=2&pageSize=10&search=&paginate=true ✅', 'Consultation product?page=2&pageSize=10&search=&paginate=true effectuée avec succès.', 'réussi', '2026-02-15 14:24:59', NULL, '2026-02-15 14:24:59', '2026-02-15 14:24:59'),
(183, 'product?page=1&pageSize=10&search=&paginate=true&companyId=8', NULL, 'Consultation product?page=1&pageSize=10&search=&paginate=true&companyId=8 ✅', 'Consultation product?page=1&pageSize=10&search=&paginate=true&companyId=8 effectuée avec succès.', 'réussi', '2026-02-15 14:30:57', NULL, '2026-02-15 14:30:57', '2026-02-15 14:30:57'),
(184, 'product?page=1&pageSize=10&search=&paginate=true&companyId=8', NULL, 'Consultation product?page=1&pageSize=10&search=&paginate=true&companyId=8 ❌', 'Échec lors de consultation product?page=1&pagesize=10&search=&paginate=true&companyid=8.', 'réussi', '2026-02-15 14:32:10', NULL, '2026-02-15 14:32:10', '2026-02-15 14:32:10'),
(185, '1', NULL, 'Consultation 1 ✅', 'Consultation 1 effectuée avec succès.', 'réussi', '2026-02-15 14:40:24', NULL, '2026-02-15 14:40:24', '2026-02-15 14:40:24'),
(186, 'sector?page=1&pageSize=10&search=&paginate=true', NULL, 'Consultation sector?page=1&pageSize=10&search=&paginate=true ❌', 'Échec lors de consultation sector?page=1&pagesize=10&search=&paginate=true.', 'réussi', '2026-02-15 14:41:03', NULL, '2026-02-15 14:41:03', '2026-02-15 14:41:03'),
(187, 'product?page=1&pageSize=10&search=&paginate=true&companyId=8', NULL, 'Consultation product?page=1&pageSize=10&search=&paginate=true&companyId=8 ❌', 'Échec lors de consultation product?page=1&pagesize=10&search=&paginate=true&companyid=8.', 'réussi', '2026-02-15 14:41:13', NULL, '2026-02-15 14:41:13', '2026-02-15 14:41:13'),
(188, 'product?page=1&pageSize=10&search=B&paginate=true&companyId=8', NULL, 'Consultation product?page=1&pageSize=10&search=B&paginate=true&companyId=8 ✅', 'Consultation product?page=1&pageSize=10&search=B&paginate=true&companyId=8 effectuée avec succès.', 'réussi', '2026-02-15 14:42:01', NULL, '2026-02-15 14:42:01', '2026-02-15 14:42:01'),
(189, 'product?page=1&pageSize=10&search=Bi&paginate=true&companyId=8', NULL, 'Consultation product?page=1&pageSize=10&search=Bi&paginate=true&companyId=8 ✅', 'Consultation product?page=1&pageSize=10&search=Bi&paginate=true&companyId=8 effectuée avec succès.', 'réussi', '2026-02-15 14:42:01', NULL, '2026-02-15 14:42:01', '2026-02-15 14:42:01'),
(190, 'product?page=1&pageSize=10&search=Bim&paginate=true&companyId=8', NULL, 'Consultation product?page=1&pageSize=10&search=Bim&paginate=true&companyId=8 ✅', 'Consultation product?page=1&pageSize=10&search=Bim&paginate=true&companyId=8 effectuée avec succès.', 'réussi', '2026-02-15 14:42:02', NULL, '2026-02-15 14:42:02', '2026-02-15 14:42:02'),
(191, 'product?page=1&pageSize=10&search=D&paginate=true&companyId=8', NULL, 'Consultation product?page=1&pageSize=10&search=D&paginate=true&companyId=8 ✅', 'Consultation product?page=1&pageSize=10&search=D&paginate=true&companyId=8 effectuée avec succès.', 'réussi', '2026-02-15 14:42:04', NULL, '2026-02-15 14:42:04', '2026-02-15 14:42:04'),
(192, 'product?page=1&pageSize=10&search=Dl&paginate=true&companyId=8', NULL, 'Consultation product?page=1&pageSize=10&search=Dl&paginate=true&companyId=8 ✅', 'Consultation product?page=1&pageSize=10&search=Dl&paginate=true&companyId=8 effectuée avec succès.', 'réussi', '2026-02-15 14:42:04', NULL, '2026-02-15 14:42:04', '2026-02-15 14:42:04'),
(193, 'product?page=1&pageSize=10&search=Dld&paginate=true&companyId=8', NULL, 'Consultation product?page=1&pageSize=10&search=Dld&paginate=true&companyId=8 ✅', 'Consultation product?page=1&pageSize=10&search=Dld&paginate=true&companyId=8 effectuée avec succès.', 'réussi', '2026-02-15 14:42:04', NULL, '2026-02-15 14:42:04', '2026-02-15 14:42:04'),
(194, 'product?page=1&pageSize=10&search=&paginate=true&companyId=8', NULL, 'Consultation product?page=1&pageSize=10&search=&paginate=true&companyId=8 ❌', 'Échec lors de consultation product?page=1&pagesize=10&search=&paginate=true&companyid=8.', 'réussi', '2026-02-15 14:47:31', NULL, '2026-02-15 14:47:31', '2026-02-15 14:47:31'),
(195, 'product?page=1&pageSize=10&search=H&paginate=true&companyId=8', NULL, 'Consultation product?page=1&pageSize=10&search=H&paginate=true&companyId=8 ✅', 'Consultation product?page=1&pageSize=10&search=H&paginate=true&companyId=8 effectuée avec succès.', 'réussi', '2026-02-15 14:47:36', NULL, '2026-02-15 14:47:36', '2026-02-15 14:47:36'),
(196, 'product?page=1&pageSize=10&search=Hh&paginate=true&companyId=8', NULL, 'Consultation product?page=1&pageSize=10&search=Hh&paginate=true&companyId=8 ✅', 'Consultation product?page=1&pageSize=10&search=Hh&paginate=true&companyId=8 effectuée avec succès.', 'réussi', '2026-02-15 14:47:36', NULL, '2026-02-15 14:47:36', '2026-02-15 14:47:36'),
(197, 'product?page=1&pageSize=10&search=S&paginate=true&companyId=8', NULL, 'Consultation product?page=1&pageSize=10&search=S&paginate=true&companyId=8 ✅', 'Consultation product?page=1&pageSize=10&search=S&paginate=true&companyId=8 effectuée avec succès.', 'réussi', '2026-02-15 14:48:16', NULL, '2026-02-15 14:48:16', '2026-02-15 14:48:16'),
(198, 'product?page=1&pageSize=10&search=Sk&paginate=true&companyId=8', NULL, 'Consultation product?page=1&pageSize=10&search=Sk&paginate=true&companyId=8 ✅', 'Consultation product?page=1&pageSize=10&search=Sk&paginate=true&companyId=8 effectuée avec succès.', 'réussi', '2026-02-15 14:48:16', NULL, '2026-02-15 14:48:16', '2026-02-15 14:48:16'),
(199, 'product?page=1&pageSize=10&search=Bw&paginate=true&companyId=8', NULL, 'Consultation product?page=1&pageSize=10&search=Bw&paginate=true&companyId=8 ✅', 'Consultation product?page=1&pageSize=10&search=Bw&paginate=true&companyId=8 effectuée avec succès.', 'réussi', '2026-02-15 14:49:01', NULL, '2026-02-15 14:49:01', '2026-02-15 14:49:01'),
(200, 'product?page=1&pageSize=10&search=B&paginate=true&companyId=8', NULL, 'Consultation product?page=1&pageSize=10&search=B&paginate=true&companyId=8 ❌', 'Échec lors de consultation product?page=1&pagesize=10&search=b&paginate=true&companyid=8.', 'réussi', '2026-02-15 14:49:01', NULL, '2026-02-15 14:49:01', '2026-02-15 14:49:01'),
(201, 'product', NULL, 'Consultation product ✅', 'Consultation product effectuée avec succès.', 'réussi', '2026-02-15 14:51:36', NULL, '2026-02-15 14:51:36', '2026-02-15 14:51:36'),
(202, 'product?companyId=8', NULL, 'Consultation product?companyId=8 ✅', 'Consultation product?companyId=8 effectuée avec succès.', 'réussi', '2026-02-15 14:52:00', NULL, '2026-02-15 14:52:00', '2026-02-15 14:52:00'),
(203, '1', NULL, 'Consultation 1 ✅', 'Consultation 1 effectuée avec succès.', 'réussi', '2026-02-15 14:54:06', NULL, '2026-02-15 14:54:06', '2026-02-15 14:54:06'),
(204, 'product?companyId=8', NULL, 'Consultation product?companyId=8 ✅', 'Consultation product?companyId=8 effectuée avec succès.', 'réussi', '2026-02-15 14:54:41', NULL, '2026-02-15 14:54:41', '2026-02-15 14:54:41'),
(205, 'sector?page=2&pageSize=10&search=&paginate=true', NULL, 'Consultation sector?page=2&pageSize=10&search=&paginate=true ❌', 'Échec lors de consultation sector?page=2&pagesize=10&search=&paginate=true.', 'réussi', '2026-02-15 14:55:50', NULL, '2026-02-15 14:55:50', '2026-02-15 14:55:50'),
(206, '1', NULL, 'Consultation 1 ❌', 'Échec lors de consultation 1.', 'réussi', '2026-02-15 14:56:07', NULL, '2026-02-15 14:56:07', '2026-02-15 14:56:07'),
(207, 'notification_track?userId=1&search=&page=1&pageSize=20', NULL, 'Consultation notification_track?userId=1&search=&page=1&pageSize=20 ✅', 'Consultation notification_track?userId=1&search=&page=1&pageSize=20 effectuée avec succès.', 'réussi', '2026-02-15 14:56:41', NULL, '2026-02-15 14:56:41', '2026-02-15 14:56:41'),
(208, 'sector?page=1&pageSize=10&search=&paginate=true', NULL, 'Consultation sector?page=1&pageSize=10&search=&paginate=true ❌', 'Échec lors de consultation sector?page=1&pagesize=10&search=&paginate=true.', 'réussi', '2026-02-15 14:56:54', NULL, '2026-02-15 14:56:54', '2026-02-15 14:56:54'),
(209, 'product?page=1&pageSize=10&search=&paginate=true&companyId=8', NULL, 'Consultation product?page=1&pageSize=10&search=&paginate=true&companyId=8 ✅', 'Consultation product?page=1&pageSize=10&search=&paginate=true&companyId=8 effectuée avec succès.', 'réussi', '2026-02-15 14:57:00', NULL, '2026-02-15 14:57:00', '2026-02-15 14:57:00'),
(210, 'product?page=1&pageSize=10&search=&paginate=true&companyId=8', NULL, 'Consultation product?page=1&pageSize=10&search=&paginate=true&companyId=8 ✅', 'Consultation product?page=1&pageSize=10&search=&paginate=true&companyId=8 effectuée avec succès.', 'réussi', '2026-02-15 15:04:09', NULL, '2026-02-15 15:04:09', '2026-02-15 15:04:09'),
(211, 'product?page=1&pageSize=10&search=&paginate=true&companyId=8', NULL, 'Consultation product?page=1&pageSize=10&search=&paginate=true&companyId=8 ❌', 'Échec lors de consultation product?page=1&pagesize=10&search=&paginate=true&companyid=8.', 'réussi', '2026-02-15 15:04:10', NULL, '2026-02-15 15:04:10', '2026-02-15 15:04:10'),
(212, 'product?page=1&pageSize=10&search=&paginate=true&companyId=8', NULL, 'Consultation product?page=1&pageSize=10&search=&paginate=true&companyId=8 ❌', 'Échec lors de consultation product?page=1&pagesize=10&search=&paginate=true&companyid=8.', 'réussi', '2026-02-15 15:04:18', NULL, '2026-02-15 15:04:18', '2026-02-15 15:04:18'),
(213, 'product?page=1&pageSize=10&search=&paginate=true&companyId=8', NULL, 'Consultation product?page=1&pageSize=10&search=&paginate=true&companyId=8 ❌', 'Échec lors de consultation product?page=1&pagesize=10&search=&paginate=true&companyid=8.', 'réussi', '2026-02-15 15:04:20', NULL, '2026-02-15 15:04:20', '2026-02-15 15:04:20'),
(214, 'product?page=1&pageSize=10&search=&paginate=true&companyId=8', NULL, 'Consultation product?page=1&pageSize=10&search=&paginate=true&companyId=8 ❌', 'Échec lors de consultation product?page=1&pagesize=10&search=&paginate=true&companyid=8.', 'réussi', '2026-02-15 15:04:21', NULL, '2026-02-15 15:04:21', '2026-02-15 15:04:21'),
(215, 'product?page=1&pageSize=10&search=&paginate=true&companyId=8', NULL, 'Consultation product?page=1&pageSize=10&search=&paginate=true&companyId=8 ❌', 'Échec lors de consultation product?page=1&pagesize=10&search=&paginate=true&companyid=8.', 'réussi', '2026-02-15 15:05:07', NULL, '2026-02-15 15:05:07', '2026-02-15 15:05:07'),
(216, 'product?page=1&pageSize=10&search=&paginate=true&companyId=8', NULL, 'Consultation product?page=1&pageSize=10&search=&paginate=true&companyId=8 ❌', 'Échec lors de consultation product?page=1&pagesize=10&search=&paginate=true&companyid=8.', 'réussi', '2026-02-15 15:05:08', NULL, '2026-02-15 15:05:08', '2026-02-15 15:05:08'),
(217, 'product?page=1&pageSize=10&search=&paginate=true&companyId=8', NULL, 'Consultation product?page=1&pageSize=10&search=&paginate=true&companyId=8 ❌', 'Échec lors de consultation product?page=1&pagesize=10&search=&paginate=true&companyid=8.', 'réussi', '2026-02-15 15:05:09', NULL, '2026-02-15 15:05:09', '2026-02-15 15:05:09'),
(218, 'product?page=1&pageSize=10&search=&paginate=true&companyId=8', NULL, 'Consultation product?page=1&pageSize=10&search=&paginate=true&companyId=8 ❌', 'Échec lors de consultation product?page=1&pagesize=10&search=&paginate=true&companyid=8.', 'réussi', '2026-02-15 15:11:40', NULL, '2026-02-15 15:11:40', '2026-02-15 15:11:40');
INSERT INTO `histories` (`historyId`, `type`, `amount`, `action`, `description`, `status`, `date`, `userId`, `createdAt`, `updatedAt`) VALUES
(219, 'product?page=1&pageSize=10&search=&paginate=true&companyId=8', NULL, 'Consultation product?page=1&pageSize=10&search=&paginate=true&companyId=8 ❌', 'Échec lors de consultation product?page=1&pagesize=10&search=&paginate=true&companyid=8.', 'réussi', '2026-02-15 15:11:42', NULL, '2026-02-15 15:11:42', '2026-02-15 15:11:42'),
(220, '1', NULL, 'Consultation 1 ✅', 'Consultation 1 effectuée avec succès.', 'réussi', '2026-02-15 15:41:37', NULL, '2026-02-15 15:41:37', '2026-02-15 15:41:37'),
(221, 'sector?page=1&pageSize=10&search=&paginate=true', NULL, 'Consultation sector?page=1&pageSize=10&search=&paginate=true ❌', 'Échec lors de consultation sector?page=1&pagesize=10&search=&paginate=true.', 'réussi', '2026-02-15 15:42:14', NULL, '2026-02-15 15:42:14', '2026-02-15 15:42:14'),
(222, 'product?page=1&pageSize=10&search=&paginate=true&companyId=8', NULL, 'Consultation product?page=1&pageSize=10&search=&paginate=true&companyId=8 ❌', 'Échec lors de consultation product?page=1&pagesize=10&search=&paginate=true&companyid=8.', 'réussi', '2026-02-15 15:42:20', NULL, '2026-02-15 15:42:20', '2026-02-15 15:42:20'),
(223, 'paiement', NULL, 'Création paiement ❌', 'Échec lors de création paiement.', 'réussi', '2026-02-15 15:42:38', NULL, '2026-02-15 15:42:38', '2026-02-15 15:42:38'),
(224, 'paiement', NULL, 'Création paiement ❌', 'Échec lors de création paiement.', 'réussi', '2026-02-15 15:44:41', NULL, '2026-02-15 15:44:41', '2026-02-15 15:44:41'),
(225, 'paiement', NULL, 'Création paiement ❌', 'Échec lors de création paiement.', 'réussi', '2026-02-15 15:45:53', NULL, '2026-02-15 15:45:53', '2026-02-15 15:45:53'),
(226, '1', NULL, 'Consultation 1 ✅', 'Consultation 1 effectuée avec succès.', 'réussi', '2026-02-15 15:47:06', NULL, '2026-02-15 15:47:06', '2026-02-15 15:47:06'),
(227, '1', NULL, 'Consultation 1 ✅', 'Consultation 1 effectuée avec succès.', 'réussi', '2026-02-15 15:47:37', NULL, '2026-02-15 15:47:37', '2026-02-15 15:47:37'),
(228, 'sector?page=1&pageSize=10&search=&paginate=true', NULL, 'Consultation sector?page=1&pageSize=10&search=&paginate=true ❌', 'Échec lors de consultation sector?page=1&pagesize=10&search=&paginate=true.', 'réussi', '2026-02-15 15:47:39', NULL, '2026-02-15 15:47:39', '2026-02-15 15:47:39'),
(229, 'product?page=1&pageSize=10&search=&paginate=true&companyId=8', NULL, 'Consultation product?page=1&pageSize=10&search=&paginate=true&companyId=8 ❌', 'Échec lors de consultation product?page=1&pagesize=10&search=&paginate=true&companyid=8.', 'réussi', '2026-02-15 15:47:41', NULL, '2026-02-15 15:47:41', '2026-02-15 15:47:41'),
(230, 'paiement', NULL, 'Création paiement ❌', 'Échec lors de création paiement.', 'réussi', '2026-02-15 15:47:50', NULL, '2026-02-15 15:47:50', '2026-02-15 15:47:50'),
(231, 'paiement', NULL, 'Création paiement ❌', 'Échec lors de création paiement.', 'réussi', '2026-02-15 15:49:34', NULL, '2026-02-15 15:49:34', '2026-02-15 15:49:34'),
(232, '1', NULL, 'Consultation 1 ✅', 'Consultation 1 effectuée avec succès.', 'réussi', '2026-02-15 15:55:39', NULL, '2026-02-15 15:55:39', '2026-02-15 15:55:39'),
(233, 'sector?page=1&pageSize=10&search=&paginate=true', NULL, 'Consultation sector?page=1&pageSize=10&search=&paginate=true ❌', 'Échec lors de consultation sector?page=1&pagesize=10&search=&paginate=true.', 'réussi', '2026-02-15 15:56:17', NULL, '2026-02-15 15:56:17', '2026-02-15 15:56:17'),
(234, 'product?page=1&pageSize=10&search=&paginate=true&companyId=8', NULL, 'Consultation product?page=1&pageSize=10&search=&paginate=true&companyId=8 ❌', 'Échec lors de consultation product?page=1&pagesize=10&search=&paginate=true&companyid=8.', 'réussi', '2026-02-15 15:56:26', NULL, '2026-02-15 15:56:26', '2026-02-15 15:56:26'),
(235, 'Paiement', 100, NULL, 'Paiement commande ORD-1771170994610', 'réussi', '2026-02-15 15:56:34', NULL, '2026-02-15 15:56:34', '2026-02-15 15:56:34'),
(236, 'Paiement', 100, NULL, 'Réception paiement commande ORD-1771170994610', 'réussi', '2026-02-15 15:56:34', NULL, '2026-02-15 15:56:34', '2026-02-15 15:56:34'),
(237, 'paiement', NULL, 'Création paiement ✅', 'Création paiement effectuée avec succès.', 'réussi', '2026-02-15 15:56:38', NULL, '2026-02-15 15:56:38', '2026-02-15 15:56:38'),
(238, '1', NULL, 'Consultation 1 ✅', 'Consultation 1 effectuée avec succès.', 'réussi', '2026-02-15 15:58:27', NULL, '2026-02-15 15:58:27', '2026-02-15 15:58:27'),
(239, 'connexion', NULL, 'Échec de la connexion ❌', 'Une tentative de connexion a été détectée, mais elle a échoué.', 'réussi', '2026-02-15 16:00:15', NULL, '2026-02-15 16:00:15', '2026-02-15 16:00:15'),
(240, 'create', NULL, 'Création create ✅', 'Création create effectuée avec succès.', 'réussi', '2026-02-15 16:00:15', NULL, '2026-02-15 16:00:15', '2026-02-15 16:00:15'),
(241, 'create', NULL, 'Création create ✅', 'Création create effectuée avec succès.', 'réussi', '2026-02-15 16:00:15', NULL, '2026-02-15 16:00:15', '2026-02-15 16:00:15'),
(242, 'sector?page=1&pageSize=10&search=&paginate=true', NULL, 'Consultation sector?page=1&pageSize=10&search=&paginate=true ❌', 'Échec lors de consultation sector?page=1&pagesize=10&search=&paginate=true.', 'réussi', '2026-02-15 16:00:49', NULL, '2026-02-15 16:00:49', '2026-02-15 16:00:49'),
(243, 'product?page=1&pageSize=10&search=&paginate=true&companyId=8', NULL, 'Consultation product?page=1&pageSize=10&search=&paginate=true&companyId=8 ❌', 'Échec lors de consultation product?page=1&pagesize=10&search=&paginate=true&companyid=8.', 'réussi', '2026-02-15 16:00:52', NULL, '2026-02-15 16:00:52', '2026-02-15 16:00:52'),
(244, 'Paiement', 100, NULL, 'Paiement commande ORD-1771171272432', 'réussi', '2026-02-15 16:01:12', NULL, '2026-02-15 16:01:12', '2026-02-15 16:01:12'),
(245, 'Paiement', 100, NULL, 'Réception paiement commande ORD-1771171272432', 'réussi', '2026-02-15 16:01:12', NULL, '2026-02-15 16:01:12', '2026-02-15 16:01:12'),
(246, 'paiement', NULL, 'Création paiement ✅', 'Création paiement effectuée avec succès.', 'réussi', '2026-02-15 16:01:15', NULL, '2026-02-15 16:01:15', '2026-02-15 16:01:15'),
(247, '1', NULL, 'Consultation 1 ✅', 'Consultation 1 effectuée avec succès.', 'réussi', '2026-02-15 16:02:46', NULL, '2026-02-15 16:02:46', '2026-02-15 16:02:46'),
(248, '1', NULL, 'Consultation 1 ✅', 'Consultation 1 effectuée avec succès.', 'réussi', '2026-02-15 16:03:13', NULL, '2026-02-15 16:03:13', '2026-02-15 16:03:13'),
(249, 'sector?page=1&pageSize=10&search=&paginate=true', NULL, 'Consultation sector?page=1&pageSize=10&search=&paginate=true ❌', 'Échec lors de consultation sector?page=1&pagesize=10&search=&paginate=true.', 'réussi', '2026-02-15 16:03:15', NULL, '2026-02-15 16:03:15', '2026-02-15 16:03:15'),
(250, 'product?page=1&pageSize=10&search=&paginate=true&companyId=8', NULL, 'Consultation product?page=1&pageSize=10&search=&paginate=true&companyId=8 ❌', 'Échec lors de consultation product?page=1&pagesize=10&search=&paginate=true&companyid=8.', 'réussi', '2026-02-15 16:03:18', NULL, '2026-02-15 16:03:18', '2026-02-15 16:03:18'),
(251, 'Paiement', 100, NULL, 'Paiement commande ORD-1771171402442', 'réussi', '2026-02-15 16:03:22', NULL, '2026-02-15 16:03:22', '2026-02-15 16:03:22'),
(252, 'Paiement', 100, NULL, 'Réception paiement commande ORD-1771171402442', 'réussi', '2026-02-15 16:03:22', NULL, '2026-02-15 16:03:22', '2026-02-15 16:03:22'),
(253, 'paiement', NULL, 'Création paiement ✅', 'Création paiement effectuée avec succès.', 'réussi', '2026-02-15 16:03:26', NULL, '2026-02-15 16:03:26', '2026-02-15 16:03:26'),
(254, '1', NULL, 'Consultation 1 ✅', 'Consultation 1 effectuée avec succès.', 'réussi', '2026-02-15 16:04:04', NULL, '2026-02-15 16:04:04', '2026-02-15 16:04:04'),
(255, 'Paiement', 100, NULL, 'Paiement commande ORD-1771171454531', 'réussi', '2026-02-15 16:04:14', NULL, '2026-02-15 16:04:14', '2026-02-15 16:04:14'),
(256, 'Paiement', 100, NULL, 'Réception paiement commande ORD-1771171454531', 'réussi', '2026-02-15 16:04:14', NULL, '2026-02-15 16:04:14', '2026-02-15 16:04:14'),
(257, 'paiement', NULL, 'Création paiement ✅', 'Création paiement effectuée avec succès.', 'réussi', '2026-02-15 16:04:17', NULL, '2026-02-15 16:04:17', '2026-02-15 16:04:17'),
(258, '1', NULL, 'Consultation 1 ✅', 'Consultation 1 effectuée avec succès.', 'réussi', '2026-02-15 16:05:19', NULL, '2026-02-15 16:05:19', '2026-02-15 16:05:19'),
(259, 'sector?page=1&pageSize=10&search=&paginate=true', NULL, 'Consultation sector?page=1&pageSize=10&search=&paginate=true ❌', 'Échec lors de consultation sector?page=1&pagesize=10&search=&paginate=true.', 'réussi', '2026-02-15 16:05:51', NULL, '2026-02-15 16:05:51', '2026-02-15 16:05:51'),
(260, 'product?page=1&pageSize=10&search=&paginate=true&companyId=8', NULL, 'Consultation product?page=1&pageSize=10&search=&paginate=true&companyId=8 ❌', 'Échec lors de consultation product?page=1&pagesize=10&search=&paginate=true&companyid=8.', 'réussi', '2026-02-15 16:05:54', NULL, '2026-02-15 16:05:54', '2026-02-15 16:05:54'),
(261, 'Paiement', 100, NULL, 'Paiement commande ORD-1771171557310', 'réussi', '2026-02-15 16:05:57', NULL, '2026-02-15 16:05:57', '2026-02-15 16:05:57'),
(262, 'Paiement', 100, NULL, 'Réception paiement commande ORD-1771171557310', 'réussi', '2026-02-15 16:05:57', NULL, '2026-02-15 16:05:57', '2026-02-15 16:05:57'),
(263, 'paiement', NULL, 'Création paiement ✅', 'Création paiement effectuée avec succès.', 'réussi', '2026-02-15 16:06:01', NULL, '2026-02-15 16:06:01', '2026-02-15 16:06:01'),
(264, '1', NULL, 'Consultation 1 ✅', 'Consultation 1 effectuée avec succès.', 'réussi', '2026-02-15 16:06:05', NULL, '2026-02-15 16:06:05', '2026-02-15 16:06:05'),
(265, 'notification_track?userId=1&search=&page=1&pageSize=20', NULL, 'Consultation notification_track?userId=1&search=&page=1&pageSize=20 ✅', 'Consultation notification_track?userId=1&search=&page=1&pageSize=20 effectuée avec succès.', 'réussi', '2026-02-15 16:06:08', NULL, '2026-02-15 16:06:08', '2026-02-15 16:06:08'),
(266, 'paiement', NULL, 'Création paiement ❌', 'Échec lors de création paiement.', 'réussi', '2026-02-15 16:06:21', NULL, '2026-02-15 16:06:21', '2026-02-15 16:06:21'),
(267, '1', NULL, 'Consultation 1 ❌', 'Échec lors de consultation 1.', 'réussi', '2026-02-15 16:09:41', NULL, '2026-02-15 16:09:41', '2026-02-15 16:09:41'),
(268, 'sector?page=1&pageSize=10&search=&paginate=true', NULL, 'Consultation sector?page=1&pageSize=10&search=&paginate=true ❌', 'Échec lors de consultation sector?page=1&pagesize=10&search=&paginate=true.', 'réussi', '2026-02-15 16:10:18', NULL, '2026-02-15 16:10:18', '2026-02-15 16:10:18'),
(269, 'product?page=1&pageSize=10&search=&paginate=true&companyId=8', NULL, 'Consultation product?page=1&pageSize=10&search=&paginate=true&companyId=8 ❌', 'Échec lors de consultation product?page=1&pagesize=10&search=&paginate=true&companyid=8.', 'réussi', '2026-02-15 16:10:20', NULL, '2026-02-15 16:10:20', '2026-02-15 16:10:20'),
(270, 'Paiement', 100, NULL, 'Paiement commande ORD-1771171824276', 'réussi', '2026-02-15 16:10:24', NULL, '2026-02-15 16:10:24', '2026-02-15 16:10:24'),
(271, 'Paiement', 100, NULL, 'Réception paiement commande ORD-1771171824276', 'réussi', '2026-02-15 16:10:24', NULL, '2026-02-15 16:10:24', '2026-02-15 16:10:24'),
(272, 'paiement', NULL, 'Création paiement ✅', 'Création paiement effectuée avec succès.', 'réussi', '2026-02-15 16:10:28', NULL, '2026-02-15 16:10:28', '2026-02-15 16:10:28'),
(273, '1', NULL, 'Consultation 1 ✅', 'Consultation 1 effectuée avec succès.', 'réussi', '2026-02-15 16:10:32', NULL, '2026-02-15 16:10:32', '2026-02-15 16:10:32'),
(274, 'paiement', NULL, 'Création paiement ❌', 'Échec lors de création paiement.', 'réussi', '2026-02-15 16:10:41', NULL, '2026-02-15 16:10:41', '2026-02-15 16:10:41'),
(275, '1', NULL, 'Consultation 1 ❌', 'Échec lors de consultation 1.', 'réussi', '2026-02-15 16:12:43', NULL, '2026-02-15 16:12:43', '2026-02-15 16:12:43'),
(276, 'connexion', NULL, 'Échec de la connexion ❌', 'Une tentative de connexion a été détectée, mais elle a échoué.', 'réussi', '2026-02-15 16:16:52', NULL, '2026-02-15 16:16:52', '2026-02-15 16:16:52'),
(277, 'create', NULL, 'Création create ✅', 'Création create effectuée avec succès.', 'réussi', '2026-02-15 16:16:52', NULL, '2026-02-15 16:16:52', '2026-02-15 16:16:52'),
(278, 'create', NULL, 'Création create ✅', 'Création create effectuée avec succès.', 'réussi', '2026-02-15 16:16:52', NULL, '2026-02-15 16:16:52', '2026-02-15 16:16:52'),
(279, '1', NULL, 'Consultation 1 ✅', 'Consultation 1 effectuée avec succès.', 'réussi', '2026-02-15 16:17:08', NULL, '2026-02-15 16:17:08', '2026-02-15 16:17:08'),
(280, 'sector?page=1&pageSize=10&search=&paginate=true', NULL, 'Consultation sector?page=1&pageSize=10&search=&paginate=true ❌', 'Échec lors de consultation sector?page=1&pagesize=10&search=&paginate=true.', 'réussi', '2026-02-15 16:17:11', NULL, '2026-02-15 16:17:11', '2026-02-15 16:17:11'),
(281, 'product?page=1&pageSize=10&search=&paginate=true&companyId=8', NULL, 'Consultation product?page=1&pageSize=10&search=&paginate=true&companyId=8 ❌', 'Échec lors de consultation product?page=1&pagesize=10&search=&paginate=true&companyid=8.', 'réussi', '2026-02-15 16:17:14', NULL, '2026-02-15 16:17:14', '2026-02-15 16:17:14'),
(282, 'Paiement', 100, NULL, 'Paiement commande ORD-1771172244260', 'réussi', '2026-02-15 16:17:24', NULL, '2026-02-15 16:17:24', '2026-02-15 16:17:24'),
(283, 'Paiement', 100, NULL, 'Réception paiement commande ORD-1771172244260', 'réussi', '2026-02-15 16:17:24', NULL, '2026-02-15 16:17:24', '2026-02-15 16:17:24'),
(284, 'paiement', NULL, 'Création paiement ✅', 'Création paiement effectuée avec succès.', 'réussi', '2026-02-15 16:17:27', NULL, '2026-02-15 16:17:27', '2026-02-15 16:17:27'),
(285, '1', NULL, 'Consultation 1 ✅', 'Consultation 1 effectuée avec succès.', 'réussi', '2026-02-15 16:17:31', NULL, '2026-02-15 16:17:31', '2026-02-15 16:17:31'),
(286, '1', NULL, 'Consultation 1 ✅', 'Consultation 1 effectuée avec succès.', 'réussi', '2026-02-15 16:18:40', NULL, '2026-02-15 16:18:40', '2026-02-15 16:18:40'),
(287, '1', NULL, 'Consultation 1 ✅', 'Consultation 1 effectuée avec succès.', 'réussi', '2026-02-15 16:19:06', NULL, '2026-02-15 16:19:06', '2026-02-15 16:19:06'),
(288, 'sector?page=1&pageSize=10&search=&paginate=true', NULL, 'Consultation sector?page=1&pageSize=10&search=&paginate=true ❌', 'Échec lors de consultation sector?page=1&pagesize=10&search=&paginate=true.', 'réussi', '2026-02-15 16:19:08', NULL, '2026-02-15 16:19:08', '2026-02-15 16:19:08'),
(289, 'product?page=1&pageSize=10&search=&paginate=true&companyId=8', NULL, 'Consultation product?page=1&pageSize=10&search=&paginate=true&companyId=8 ❌', 'Échec lors de consultation product?page=1&pagesize=10&search=&paginate=true&companyid=8.', 'réussi', '2026-02-15 16:19:11', NULL, '2026-02-15 16:19:11', '2026-02-15 16:19:11'),
(290, 'product?page=1&pageSize=10&search=&paginate=true&companyId=8', NULL, 'Consultation product?page=1&pageSize=10&search=&paginate=true&companyId=8 ❌', 'Échec lors de consultation product?page=1&pagesize=10&search=&paginate=true&companyid=8.', 'réussi', '2026-02-15 16:19:17', NULL, '2026-02-15 16:19:17', '2026-02-15 16:19:17'),
(291, 'Paiement', 100, NULL, 'Paiement commande ORD-1771172373660', 'réussi', '2026-02-15 16:19:33', NULL, '2026-02-15 16:19:33', '2026-02-15 16:19:33'),
(292, 'Paiement', 100, NULL, 'Réception paiement commande ORD-1771172373660', 'réussi', '2026-02-15 16:19:33', NULL, '2026-02-15 16:19:33', '2026-02-15 16:19:33'),
(293, 'paiement', NULL, 'Création paiement ✅', 'Création paiement effectuée avec succès.', 'réussi', '2026-02-15 16:19:37', NULL, '2026-02-15 16:19:37', '2026-02-15 16:19:37'),
(294, '1', NULL, 'Consultation 1 ✅', 'Consultation 1 effectuée avec succès.', 'réussi', '2026-02-15 16:19:42', NULL, '2026-02-15 16:19:42', '2026-02-15 16:19:42'),
(295, '1', NULL, 'Consultation 1 ❌', 'Échec lors de consultation 1.', 'réussi', '2026-02-15 16:23:08', NULL, '2026-02-15 16:23:08', '2026-02-15 16:23:08'),
(296, 'connexion', NULL, 'Échec de la connexion ❌', 'Une tentative de connexion a été détectée, mais elle a échoué.', 'réussi', '2026-02-15 16:24:19', NULL, '2026-02-15 16:24:19', '2026-02-15 16:24:19'),
(297, 'create', NULL, 'Création create ✅', 'Création create effectuée avec succès.', 'réussi', '2026-02-15 16:24:19', NULL, '2026-02-15 16:24:19', '2026-02-15 16:24:19'),
(298, 'create', NULL, 'Création create ✅', 'Création create effectuée avec succès.', 'réussi', '2026-02-15 16:24:19', NULL, '2026-02-15 16:24:19', '2026-02-15 16:24:19'),
(299, 'sector?page=1&pageSize=10&search=&paginate=true', NULL, 'Consultation sector?page=1&pageSize=10&search=&paginate=true ❌', 'Échec lors de consultation sector?page=1&pagesize=10&search=&paginate=true.', 'réussi', '2026-02-15 16:24:39', NULL, '2026-02-15 16:24:39', '2026-02-15 16:24:39'),
(300, 'product?page=1&pageSize=10&search=&paginate=true&companyId=8', NULL, 'Consultation product?page=1&pageSize=10&search=&paginate=true&companyId=8 ❌', 'Échec lors de consultation product?page=1&pagesize=10&search=&paginate=true&companyid=8.', 'réussi', '2026-02-15 16:24:42', NULL, '2026-02-15 16:24:42', '2026-02-15 16:24:42'),
(301, 'Paiement', 100, NULL, 'Paiement commande ORD-1771172696166', 'réussi', '2026-02-15 16:24:56', NULL, '2026-02-15 16:24:56', '2026-02-15 16:24:56'),
(302, 'Paiement', 100, NULL, 'Réception paiement commande ORD-1771172696166', 'réussi', '2026-02-15 16:24:56', NULL, '2026-02-15 16:24:56', '2026-02-15 16:24:56'),
(303, 'paiement', NULL, 'Création paiement ✅', 'Création paiement effectuée avec succès.', 'réussi', '2026-02-15 16:25:00', NULL, '2026-02-15 16:25:00', '2026-02-15 16:25:00'),
(304, '1', NULL, 'Consultation 1 ✅', 'Consultation 1 effectuée avec succès.', 'réussi', '2026-02-15 16:25:06', NULL, '2026-02-15 16:25:06', '2026-02-15 16:25:06'),
(305, 'paiement', NULL, 'Création paiement ❌', 'Échec lors de création paiement.', 'réussi', '2026-02-15 16:30:33', NULL, '2026-02-15 16:30:33', '2026-02-15 16:30:33'),
(306, 'paiement', NULL, 'Création paiement ❌', 'Échec lors de création paiement.', 'réussi', '2026-02-15 16:30:36', NULL, '2026-02-15 16:30:36', '2026-02-15 16:30:36'),
(307, 'paiement', NULL, 'Création paiement ❌', 'Échec lors de création paiement.', 'réussi', '2026-02-15 16:31:34', NULL, '2026-02-15 16:31:34', '2026-02-15 16:31:34'),
(308, 'paiement', NULL, 'Création paiement ❌', 'Échec lors de création paiement.', 'réussi', '2026-02-15 16:31:36', NULL, '2026-02-15 16:31:36', '2026-02-15 16:31:36'),
(309, 'paiement', NULL, 'Création paiement ❌', 'Échec lors de création paiement.', 'réussi', '2026-02-15 16:31:39', NULL, '2026-02-15 16:31:39', '2026-02-15 16:31:39'),
(310, 'paiement', NULL, 'Création paiement ❌', 'Échec lors de création paiement.', 'réussi', '2026-02-15 16:32:19', NULL, '2026-02-15 16:32:19', '2026-02-15 16:32:19'),
(311, 'paiement', NULL, 'Création paiement ❌', 'Échec lors de création paiement.', 'réussi', '2026-02-15 16:32:22', NULL, '2026-02-15 16:32:22', '2026-02-15 16:32:22'),
(312, 'paiement', NULL, 'Création paiement ❌', 'Échec lors de création paiement.', 'réussi', '2026-02-15 16:32:23', NULL, '2026-02-15 16:32:23', '2026-02-15 16:32:23'),
(313, 'paiement', NULL, 'Création paiement ❌', 'Échec lors de création paiement.', 'réussi', '2026-02-15 16:32:26', NULL, '2026-02-15 16:32:26', '2026-02-15 16:32:26'),
(314, 'notification_track?userId=1&search=&page=1&pageSize=20', NULL, 'Consultation notification_track?userId=1&search=&page=1&pageSize=20 ✅', 'Consultation notification_track?userId=1&search=&page=1&pageSize=20 effectuée avec succès.', 'réussi', '2026-02-15 16:33:41', NULL, '2026-02-15 16:33:41', '2026-02-15 16:33:41'),
(315, '1', NULL, 'Consultation 1 ❌', 'Échec lors de consultation 1.', 'réussi', '2026-02-15 16:34:54', NULL, '2026-02-15 16:34:54', '2026-02-15 16:34:54'),
(316, 'sector?page=1&pageSize=10&search=&paginate=true', NULL, 'Consultation sector?page=1&pageSize=10&search=&paginate=true ❌', 'Échec lors de consultation sector?page=1&pagesize=10&search=&paginate=true.', 'réussi', '2026-02-15 16:35:59', NULL, '2026-02-15 16:35:59', '2026-02-15 16:35:59'),
(317, 'product?page=1&pageSize=10&search=&paginate=true&companyId=8', NULL, 'Consultation product?page=1&pageSize=10&search=&paginate=true&companyId=8 ❌', 'Échec lors de consultation product?page=1&pagesize=10&search=&paginate=true&companyid=8.', 'réussi', '2026-02-15 16:36:01', NULL, '2026-02-15 16:36:01', '2026-02-15 16:36:01'),
(318, 'paiement', NULL, 'Création paiement ❌', 'Échec lors de création paiement.', 'réussi', '2026-02-15 16:36:10', NULL, '2026-02-15 16:36:10', '2026-02-15 16:36:10'),
(319, 'product?page=1&pageSize=10&search=D&paginate=true&companyId=8', NULL, 'Consultation product?page=1&pageSize=10&search=D&paginate=true&companyId=8 ✅', 'Consultation product?page=1&pageSize=10&search=D&paginate=true&companyId=8 effectuée avec succès.', 'réussi', '2026-02-15 16:38:28', NULL, '2026-02-15 16:38:28', '2026-02-15 16:38:28'),
(320, 'product?page=1&pageSize=10&search=Df&paginate=true&companyId=8', NULL, 'Consultation product?page=1&pageSize=10&search=Df&paginate=true&companyId=8 ✅', 'Consultation product?page=1&pageSize=10&search=Df&paginate=true&companyId=8 effectuée avec succès.', 'réussi', '2026-02-15 16:38:29', NULL, '2026-02-15 16:38:29', '2026-02-15 16:38:29'),
(321, 'product?page=1&pageSize=10&search=D&paginate=true&companyId=8', NULL, 'Consultation product?page=1&pageSize=10&search=D&paginate=true&companyId=8 ❌', 'Échec lors de consultation product?page=1&pagesize=10&search=d&paginate=true&companyid=8.', 'réussi', '2026-02-15 16:41:29', NULL, '2026-02-15 16:41:29', '2026-02-15 16:41:29'),
(322, 'product?page=1&pageSize=10&search=&paginate=true&companyId=8', NULL, 'Consultation product?page=1&pageSize=10&search=&paginate=true&companyId=8 ❌', 'Échec lors de consultation product?page=1&pagesize=10&search=&paginate=true&companyid=8.', 'réussi', '2026-02-15 16:41:29', NULL, '2026-02-15 16:41:29', '2026-02-15 16:41:29'),
(323, 'notification_track?userId=1&search=&page=1&pageSize=20', NULL, 'Consultation notification_track?userId=1&search=&page=1&pageSize=20 ✅', 'Consultation notification_track?userId=1&search=&page=1&pageSize=20 effectuée avec succès.', 'réussi', '2026-02-15 16:41:46', NULL, '2026-02-15 16:41:46', '2026-02-15 16:41:46'),
(324, '1', NULL, 'Consultation 1 ✅', 'Consultation 1 effectuée avec succès.', 'réussi', '2026-02-15 16:43:06', NULL, '2026-02-15 16:43:06', '2026-02-15 16:43:06'),
(325, 'sector?page=1&pageSize=10&search=&paginate=true', NULL, 'Consultation sector?page=1&pageSize=10&search=&paginate=true ❌', 'Échec lors de consultation sector?page=1&pagesize=10&search=&paginate=true.', 'réussi', '2026-02-15 16:44:41', NULL, '2026-02-15 16:44:41', '2026-02-15 16:44:41'),
(326, '1', NULL, 'Consultation 1 ✅', 'Consultation 1 effectuée avec succès.', 'réussi', '2026-02-15 16:45:08', NULL, '2026-02-15 16:45:08', '2026-02-15 16:45:08'),
(327, 'sector?page=1&pageSize=10&search=&paginate=true', NULL, 'Consultation sector?page=1&pageSize=10&search=&paginate=true ❌', 'Échec lors de consultation sector?page=1&pagesize=10&search=&paginate=true.', 'réussi', '2026-02-15 16:45:48', NULL, '2026-02-15 16:45:48', '2026-02-15 16:45:48'),
(328, '1', NULL, 'Consultation 1 ✅', 'Consultation 1 effectuée avec succès.', 'réussi', '2026-02-15 16:48:21', NULL, '2026-02-15 16:48:21', '2026-02-15 16:48:21'),
(329, 'sector?page=1&pageSize=10&search=&paginate=true', NULL, 'Consultation sector?page=1&pageSize=10&search=&paginate=true ❌', 'Échec lors de consultation sector?page=1&pagesize=10&search=&paginate=true.', 'réussi', '2026-02-15 16:48:58', NULL, '2026-02-15 16:48:58', '2026-02-15 16:48:58'),
(330, 'product?page=1&pageSize=10&search=&paginate=true&companyId=13', NULL, 'Consultation product?page=1&pageSize=10&search=&paginate=true&companyId=13 ✅', 'Consultation product?page=1&pageSize=10&search=&paginate=true&companyId=13 effectuée avec succès.', 'réussi', '2026-02-15 16:50:33', NULL, '2026-02-15 16:50:33', '2026-02-15 16:50:33'),
(331, 'product?page=1&pageSize=10&search=&paginate=true&companyId=14', NULL, 'Consultation product?page=1&pageSize=10&search=&paginate=true&companyId=14 ✅', 'Consultation product?page=1&pageSize=10&search=&paginate=true&companyId=14 effectuée avec succès.', 'réussi', '2026-02-15 16:51:22', NULL, '2026-02-15 16:51:22', '2026-02-15 16:51:22'),
(332, 'product?page=1&pageSize=10&search=&paginate=true&companyId=8', NULL, 'Consultation product?page=1&pageSize=10&search=&paginate=true&companyId=8 ❌', 'Échec lors de consultation product?page=1&pagesize=10&search=&paginate=true&companyid=8.', 'réussi', '2026-02-15 16:51:55', NULL, '2026-02-15 16:51:55', '2026-02-15 16:51:55'),
(333, 'product?page=1&pageSize=10&search=&paginate=true&companyId=14', NULL, 'Consultation product?page=1&pageSize=10&search=&paginate=true&companyId=14 ❌', 'Échec lors de consultation product?page=1&pagesize=10&search=&paginate=true&companyid=14.', 'réussi', '2026-02-15 16:52:33', NULL, '2026-02-15 16:52:33', '2026-02-15 16:52:33'),
(334, 'product?page=1&pageSize=10&search=J&paginate=true&companyId=13', NULL, 'Consultation product?page=1&pageSize=10&search=J&paginate=true&companyId=13 ✅', 'Consultation product?page=1&pageSize=10&search=J&paginate=true&companyId=13 effectuée avec succès.', 'réussi', '2026-02-15 16:52:38', NULL, '2026-02-15 16:52:38', '2026-02-15 16:52:38'),
(335, 'product?page=1&pageSize=10&search=Jj&paginate=true&companyId=13', NULL, 'Consultation product?page=1&pageSize=10&search=Jj&paginate=true&companyId=13 ✅', 'Consultation product?page=1&pageSize=10&search=Jj&paginate=true&companyId=13 effectuée avec succès.', 'réussi', '2026-02-15 16:52:38', NULL, '2026-02-15 16:52:38', '2026-02-15 16:52:38'),
(336, 'notification_track?userId=1&search=&page=1&pageSize=20', NULL, 'Consultation notification_track?userId=1&search=&page=1&pageSize=20 ✅', 'Consultation notification_track?userId=1&search=&page=1&pageSize=20 effectuée avec succès.', 'réussi', '2026-02-15 16:52:53', NULL, '2026-02-15 16:52:53', '2026-02-15 16:52:53'),
(337, 'Paiement', 80, NULL, 'Paiement commande ORD-1771174416878', 'réussi', '2026-02-15 16:53:36', NULL, '2026-02-15 16:53:36', '2026-02-15 16:53:36'),
(338, 'Paiement', 80, NULL, 'Réception paiement commande ORD-1771174416878', 'réussi', '2026-02-15 16:53:36', NULL, '2026-02-15 16:53:36', '2026-02-15 16:53:36'),
(339, 'paiement', NULL, 'Création paiement ✅', 'Création paiement effectuée avec succès.', 'réussi', '2026-02-15 16:53:39', NULL, '2026-02-15 16:53:39', '2026-02-15 16:53:39'),
(340, '1', NULL, 'Consultation 1 ✅', 'Consultation 1 effectuée avec succès.', 'réussi', '2026-02-15 16:53:42', NULL, '2026-02-15 16:53:42', '2026-02-15 16:53:42'),
(341, 'product?page=1&pageSize=10&search=&paginate=true&companyId=8', NULL, 'Consultation product?page=1&pageSize=10&search=&paginate=true&companyId=8 ❌', 'Échec lors de consultation product?page=1&pagesize=10&search=&paginate=true&companyid=8.', 'réussi', '2026-02-15 16:54:53', NULL, '2026-02-15 16:54:53', '2026-02-15 16:54:53'),
(342, '1', NULL, 'Consultation 1 ❌', 'Échec lors de consultation 1.', 'réussi', '2026-02-15 16:56:01', NULL, '2026-02-15 16:56:01', '2026-02-15 16:56:01'),
(343, 'sector?page=1&pageSize=10&search=&paginate=true', NULL, 'Consultation sector?page=1&pageSize=10&search=&paginate=true ❌', 'Échec lors de consultation sector?page=1&pagesize=10&search=&paginate=true.', 'réussi', '2026-02-15 16:56:28', NULL, '2026-02-15 16:56:28', '2026-02-15 16:56:28'),
(344, 'product?page=1&pageSize=10&search=&paginate=true&companyId=8', NULL, 'Consultation product?page=1&pageSize=10&search=&paginate=true&companyId=8 ❌', 'Échec lors de consultation product?page=1&pagesize=10&search=&paginate=true&companyid=8.', 'réussi', '2026-02-15 16:56:31', NULL, '2026-02-15 16:56:31', '2026-02-15 16:56:31'),
(345, '1', NULL, 'Consultation 1 ✅', 'Consultation 1 effectuée avec succès.', 'réussi', '2026-02-15 16:56:58', NULL, '2026-02-15 16:56:58', '2026-02-15 16:56:58'),
(346, 'sector?page=1&pageSize=10&search=&paginate=true', NULL, 'Consultation sector?page=1&pageSize=10&search=&paginate=true ❌', 'Échec lors de consultation sector?page=1&pagesize=10&search=&paginate=true.', 'réussi', '2026-02-15 16:57:27', NULL, '2026-02-15 16:57:27', '2026-02-15 16:57:27'),
(347, 'product?page=1&pageSize=10&search=&paginate=true&companyId=11', NULL, 'Consultation product?page=1&pageSize=10&search=&paginate=true&companyId=11 ✅', 'Consultation product?page=1&pageSize=10&search=&paginate=true&companyId=11 effectuée avec succès.', 'réussi', '2026-02-15 16:57:31', NULL, '2026-02-15 16:57:31', '2026-02-15 16:57:31'),
(348, 'product?page=1&pageSize=10&search=&paginate=true&companyId=13', NULL, 'Consultation product?page=1&pageSize=10&search=&paginate=true&companyId=13 ❌', 'Échec lors de consultation product?page=1&pagesize=10&search=&paginate=true&companyid=13.', 'réussi', '2026-02-15 16:57:50', NULL, '2026-02-15 16:57:50', '2026-02-15 16:57:50'),
(349, 'sector?page=2&pageSize=10&search=&paginate=true', NULL, 'Consultation sector?page=2&pageSize=10&search=&paginate=true ❌', 'Échec lors de consultation sector?page=2&pagesize=10&search=&paginate=true.', 'réussi', '2026-02-15 16:58:23', NULL, '2026-02-15 16:58:23', '2026-02-15 16:58:23'),
(350, '1', NULL, 'Consultation 1 ✅', 'Consultation 1 effectuée avec succès.', 'réussi', '2026-02-15 17:00:26', NULL, '2026-02-15 17:00:26', '2026-02-15 17:00:26'),
(351, '1', NULL, 'Consultation 1 ❌', 'Échec lors de consultation 1.', 'réussi', '2026-02-15 17:00:35', NULL, '2026-02-15 17:00:35', '2026-02-15 17:00:35'),
(352, 'sector?page=1&pageSize=10&search=&paginate=true', NULL, 'Consultation sector?page=1&pageSize=10&search=&paginate=true ❌', 'Échec lors de consultation sector?page=1&pagesize=10&search=&paginate=true.', 'réussi', '2026-02-15 17:01:18', NULL, '2026-02-15 17:01:18', '2026-02-15 17:01:18'),
(353, 'product?page=1&pageSize=10&search=&paginate=true&companyId=8', NULL, 'Consultation product?page=1&pageSize=10&search=&paginate=true&companyId=8 ❌', 'Échec lors de consultation product?page=1&pagesize=10&search=&paginate=true&companyid=8.', 'réussi', '2026-02-15 17:01:21', NULL, '2026-02-15 17:01:21', '2026-02-15 17:01:21'),
(354, 'product?page=1&pageSize=10&search=&paginate=true&companyId=11', NULL, 'Consultation product?page=1&pageSize=10&search=&paginate=true&companyId=11 ❌', 'Échec lors de consultation product?page=1&pagesize=10&search=&paginate=true&companyid=11.', 'réussi', '2026-02-15 17:01:31', NULL, '2026-02-15 17:01:31', '2026-02-15 17:01:31'),
(355, 'product?page=1&pageSize=10&search=&paginate=true&companyId=9', NULL, 'Consultation product?page=1&pageSize=10&search=&paginate=true&companyId=9 ✅', 'Consultation product?page=1&pageSize=10&search=&paginate=true&companyId=9 effectuée avec succès.', 'réussi', '2026-02-15 17:01:38', NULL, '2026-02-15 17:01:38', '2026-02-15 17:01:38'),
(356, 'product?page=1&pageSize=10&search=&paginate=true&companyId=10', NULL, 'Consultation product?page=1&pageSize=10&search=&paginate=true&companyId=10 ✅', 'Consultation product?page=1&pageSize=10&search=&paginate=true&companyId=10 effectuée avec succès.', 'réussi', '2026-02-15 17:01:59', NULL, '2026-02-15 17:01:59', '2026-02-15 17:01:59'),
(357, 'sector?page=2&pageSize=10&search=&paginate=true', NULL, 'Consultation sector?page=2&pageSize=10&search=&paginate=true ❌', 'Échec lors de consultation sector?page=2&pagesize=10&search=&paginate=true.', 'réussi', '2026-02-15 17:03:11', NULL, '2026-02-15 17:03:11', '2026-02-15 17:03:11'),
(358, 'sector?page=1&pageSize=10&search=&paginate=true', NULL, 'Consultation sector?page=1&pageSize=10&search=&paginate=true ❌', 'Échec lors de consultation sector?page=1&pagesize=10&search=&paginate=true.', 'réussi', '2026-02-15 17:07:05', NULL, '2026-02-15 17:07:05', '2026-02-15 17:07:05'),
(359, 'sector?page=1&pageSize=10&search=&paginate=false', NULL, 'Consultation sector?page=1&pageSize=10&search=&paginate=false ✅', 'Consultation sector?page=1&pageSize=10&search=&paginate=false effectuée avec succès.', 'réussi', '2026-02-15 17:08:59', NULL, '2026-02-15 17:08:59', '2026-02-15 17:08:59'),
(360, 'sector?page=1&pageSize=20&search=&paginate=false', NULL, 'Consultation sector?page=1&pageSize=20&search=&paginate=false ✅', 'Consultation sector?page=1&pageSize=20&search=&paginate=false effectuée avec succès.', 'réussi', '2026-02-15 17:11:55', NULL, '2026-02-15 17:11:55', '2026-02-15 17:11:55'),
(361, '1', NULL, 'Consultation 1 ✅', 'Consultation 1 effectuée avec succès.', 'réussi', '2026-02-15 17:16:20', NULL, '2026-02-15 17:16:20', '2026-02-15 17:16:20'),
(362, 'product?page=1&pageSize=10&search=&paginate=true&companyId=9', NULL, 'Consultation product?page=1&pageSize=10&search=&paginate=true&companyId=9 ❌', 'Échec lors de consultation product?page=1&pagesize=10&search=&paginate=true&companyid=9.', 'réussi', '2026-02-15 17:17:03', NULL, '2026-02-15 17:17:03', '2026-02-15 17:17:03'),
(363, 'product?page=1&pageSize=10&search=&paginate=true&companyId=10', NULL, 'Consultation product?page=1&pageSize=10&search=&paginate=true&companyId=10 ❌', 'Échec lors de consultation product?page=1&pagesize=10&search=&paginate=true&companyid=10.', 'réussi', '2026-02-15 17:17:18', NULL, '2026-02-15 17:17:18', '2026-02-15 17:17:18'),
(364, 'notification_track?userId=1&search=&page=1&pageSize=20', NULL, 'Consultation notification_track?userId=1&search=&page=1&pageSize=20 ✅', 'Consultation notification_track?userId=1&search=&page=1&pageSize=20 effectuée avec succès.', 'réussi', '2026-02-15 17:17:23', NULL, '2026-02-15 17:17:23', '2026-02-15 17:17:23'),
(365, 'sector?page=2&pageSize=10&search=&paginate=true', NULL, 'Consultation sector?page=2&pageSize=10&search=&paginate=true ❌', 'Échec lors de consultation sector?page=2&pagesize=10&search=&paginate=true.', 'réussi', '2026-02-15 17:17:32', NULL, '2026-02-15 17:17:32', '2026-02-15 17:17:32'),
(366, 'notification_track?userId=1&search=&page=1&pageSize=20', NULL, 'Consultation notification_track?userId=1&search=&page=1&pageSize=20 ✅', 'Consultation notification_track?userId=1&search=&page=1&pageSize=20 effectuée avec succès.', 'réussi', '2026-02-15 17:18:48', NULL, '2026-02-15 17:18:48', '2026-02-15 17:18:48'),
(367, 'notification_track?userId=1&search=&page=1&pageSize=20', NULL, 'Consultation notification_track?userId=1&search=&page=1&pageSize=20 ✅', 'Consultation notification_track?userId=1&search=&page=1&pageSize=20 effectuée avec succès.', 'réussi', '2026-02-15 17:20:25', NULL, '2026-02-15 17:20:25', '2026-02-15 17:20:25'),
(368, 'product?page=1&pageSize=10&search=&paginate=true&companyId=8', NULL, 'Consultation product?page=1&pageSize=10&search=&paginate=true&companyId=8 ❌', 'Échec lors de consultation product?page=1&pagesize=10&search=&paginate=true&companyid=8.', 'réussi', '2026-02-15 17:22:20', NULL, '2026-02-15 17:22:20', '2026-02-15 17:22:20'),
(369, '1', NULL, 'Consultation 1 ❌', 'Échec lors de consultation 1.', 'réussi', '2026-02-15 17:22:27', NULL, '2026-02-15 17:22:27', '2026-02-15 17:22:27'),
(370, '1', NULL, 'Consultation 1 ❌', 'Échec lors de consultation 1.', 'réussi', '2026-02-15 17:25:43', NULL, '2026-02-15 17:25:43', '2026-02-15 17:25:43'),
(371, '1', NULL, 'Consultation 1 ❌', 'Échec lors de consultation 1.', 'réussi', '2026-02-15 17:26:36', NULL, '2026-02-15 17:26:36', '2026-02-15 17:26:36'),
(372, '1', NULL, 'Consultation 1 ❌', 'Échec lors de consultation 1.', 'réussi', '2026-02-15 17:27:51', NULL, '2026-02-15 17:27:51', '2026-02-15 17:27:51'),
(373, '1', NULL, 'Consultation 1 ❌', 'Échec lors de consultation 1.', 'réussi', '2026-02-15 17:29:02', NULL, '2026-02-15 17:29:02', '2026-02-15 17:29:02'),
(374, '1', NULL, 'Consultation 1 ❌', 'Échec lors de consultation 1.', 'réussi', '2026-02-15 17:29:46', NULL, '2026-02-15 17:29:46', '2026-02-15 17:29:46'),
(375, 'notification_track?userId=1&search=&page=1&pageSize=20', NULL, 'Consultation notification_track?userId=1&search=&page=1&pageSize=20 ✅', 'Consultation notification_track?userId=1&search=&page=1&pageSize=20 effectuée avec succès.', 'réussi', '2026-02-15 17:29:50', NULL, '2026-02-15 17:29:50', '2026-02-15 17:29:50'),
(376, 'users?search=&page=1&pageSize=20&paginate=true', NULL, 'Consultation users?search=&page=1&pageSize=20&paginate=true ✅', 'Consultation users?search=&page=1&pageSize=20&paginate=true effectuée avec succès.', 'réussi', '2026-02-15 17:29:57', NULL, '2026-02-15 17:29:57', '2026-02-15 17:29:57'),
(377, 'product?page=1&pageSize=10&search=&paginate=true&companyId=8', NULL, 'Consultation product?page=1&pageSize=10&search=&paginate=true&companyId=8 ❌', 'Échec lors de consultation product?page=1&pagesize=10&search=&paginate=true&companyid=8.', 'réussi', '2026-02-15 17:30:09', NULL, '2026-02-15 17:30:09', '2026-02-15 17:30:09'),
(378, 'paiement', NULL, 'Création paiement ❌', 'Échec lors de création paiement.', 'réussi', '2026-02-15 17:30:20', NULL, '2026-02-15 17:30:20', '2026-02-15 17:30:20'),
(379, 'product?page=1&pageSize=10&search=&paginate=true&companyId=11', NULL, 'Consultation product?page=1&pageSize=10&search=&paginate=true&companyId=11 ❌', 'Échec lors de consultation product?page=1&pagesize=10&search=&paginate=true&companyid=11.', 'réussi', '2026-02-15 17:30:31', NULL, '2026-02-15 17:30:31', '2026-02-15 17:30:31'),
(380, 'product?page=1&pageSize=10&search=&paginate=true&companyId=12', NULL, 'Consultation product?page=1&pageSize=10&search=&paginate=true&companyId=12 ✅', 'Consultation product?page=1&pageSize=10&search=&paginate=true&companyId=12 effectuée avec succès.', 'réussi', '2026-02-15 17:30:37', NULL, '2026-02-15 17:30:37', '2026-02-15 17:30:37'),
(381, 'product?page=1&pageSize=10&search=&paginate=true&companyId=9', NULL, 'Consultation product?page=1&pageSize=10&search=&paginate=true&companyId=9 ❌', 'Échec lors de consultation product?page=1&pagesize=10&search=&paginate=true&companyid=9.', 'réussi', '2026-02-15 17:30:42', NULL, '2026-02-15 17:30:42', '2026-02-15 17:30:42'),
(382, 'product?page=1&pageSize=10&search=&paginate=true&companyId=8', NULL, 'Consultation product?page=1&pageSize=10&search=&paginate=true&companyId=8 ❌', 'Échec lors de consultation product?page=1&pagesize=10&search=&paginate=true&companyid=8.', 'réussi', '2026-02-15 17:34:25', NULL, '2026-02-15 17:34:25', '2026-02-15 17:34:25'),
(383, 'notification_track?userId=1&search=&page=1&pageSize=20', NULL, 'Consultation notification_track?userId=1&search=&page=1&pageSize=20 ✅', 'Consultation notification_track?userId=1&search=&page=1&pageSize=20 effectuée avec succès.', 'réussi', '2026-02-15 17:34:31', NULL, '2026-02-15 17:34:31', '2026-02-15 17:34:31'),
(384, 'sector?page=1&pageSize=20&search=&paginate=false', NULL, 'Consultation sector?page=1&pageSize=20&search=&paginate=false ❌', 'Échec lors de consultation sector?page=1&pagesize=20&search=&paginate=false.', 'réussi', '2026-02-15 17:54:24', NULL, '2026-02-15 17:54:24', '2026-02-15 17:54:24'),
(385, '1', NULL, 'Consultation 1 ❌', 'Échec lors de consultation 1.', 'réussi', '2026-02-15 17:54:24', NULL, '2026-02-15 17:54:24', '2026-02-15 17:54:24'),
(386, '4', NULL, 'Consultation 4 ✅', 'Consultation 4 effectuée avec succès.', 'réussi', '2026-02-15 17:56:32', NULL, '2026-02-15 17:56:32', '2026-02-15 17:56:32'),
(387, 'createrecharge', NULL, 'Création createrecharge ✅', 'Création createrecharge effectuée avec succès.', 'réussi', '2026-02-15 17:57:43', NULL, '2026-02-15 17:57:43', '2026-02-15 17:57:43'),
(388, 'recharge', NULL, 'Création recharge ✅', 'Création recharge effectuée avec succès.', 'réussi', '2026-02-15 17:57:43', NULL, '2026-02-15 17:57:43', '2026-02-15 17:57:43'),
(389, '4', NULL, 'Consultation 4 ✅', 'Consultation 4 effectuée avec succès.', 'réussi', '2026-02-15 17:57:54', NULL, '2026-02-15 17:57:54', '2026-02-15 17:57:54'),
(390, 'profile', NULL, 'Mise à jour profile ✅', 'Mise à jour profile effectuée avec succès.', 'réussi', '2026-02-15 17:58:20', NULL, '2026-02-15 17:58:20', '2026-02-15 17:58:20'),
(391, '4', NULL, 'Consultation 4 ✅', 'Consultation 4 effectuée avec succès.', 'réussi', '2026-02-15 17:58:20', NULL, '2026-02-15 17:58:20', '2026-02-15 17:58:20'),
(392, 'MODIFICATION_PROFIL', NULL, 'Profil modifié ✅', 'Votre profil a été mis à jour avec succès.', 'réussi', '2026-02-15 17:58:20', NULL, '2026-02-15 17:58:20', '2026-02-15 17:58:20'),
(393, 'create', NULL, 'Création create ✅', 'Création create effectuée avec succès.', 'réussi', '2026-02-15 17:58:20', NULL, '2026-02-15 17:58:20', '2026-02-15 17:58:20'),
(394, 'create', NULL, 'Création create ✅', 'Création create effectuée avec succès.', 'réussi', '2026-02-15 17:58:20', NULL, '2026-02-15 17:58:20', '2026-02-15 17:58:20'),
(395, 'notification_track?userId=4&search=&page=1&pageSize=20', NULL, 'Consultation notification_track?userId=4&search=&page=1&pageSize=20 ✅', 'Consultation notification_track?userId=4&search=&page=1&pageSize=20 effectuée avec succès.', 'réussi', '2026-02-15 17:58:30', NULL, '2026-02-15 17:58:30', '2026-02-15 17:58:30'),
(396, '2', NULL, 'Consultation 2 ✅', 'Consultation 2 effectuée avec succès.', 'réussi', '2026-02-15 17:59:55', NULL, '2026-02-15 17:59:55', '2026-02-15 17:59:55'),
(397, '2', NULL, 'Consultation 2 ❌', 'Échec lors de consultation 2.', 'réussi', '2026-02-15 18:00:01', NULL, '2026-02-15 18:00:01', '2026-02-15 18:00:01'),
(398, 'notification_track?userId=2&search=&page=1&pageSize=20', NULL, 'Consultation notification_track?userId=2&search=&page=1&pageSize=20 ✅', 'Consultation notification_track?userId=2&search=&page=1&pageSize=20 effectuée avec succès.', 'réussi', '2026-02-15 18:00:06', NULL, '2026-02-15 18:00:06', '2026-02-15 18:00:06'),
(399, 'sector?page=1&pageSize=20&search=&paginate=false', NULL, 'Consultation sector?page=1&pageSize=20&search=&paginate=false ✅', 'Consultation sector?page=1&pageSize=20&search=&paginate=false effectuée avec succès.', 'réussi', '2026-02-15 18:04:39', NULL, '2026-02-15 18:04:39', '2026-02-15 18:04:39'),
(400, '1', NULL, 'Consultation 1 ✅', 'Consultation 1 effectuée avec succès.', 'réussi', '2026-02-15 18:04:39', NULL, '2026-02-15 18:04:39', '2026-02-15 18:04:39'),
(401, '1', NULL, 'Consultation 1 ❌', 'Échec lors de consultation 1.', 'réussi', '2026-02-15 18:04:42', NULL, '2026-02-15 18:04:42', '2026-02-15 18:04:42'),
(402, 'users?search=&page=1&pageSize=20&paginate=true', NULL, 'Consultation users?search=&page=1&pageSize=20&paginate=true ✅', 'Consultation users?search=&page=1&pageSize=20&paginate=true effectuée avec succès.', 'réussi', '2026-02-15 18:05:08', NULL, '2026-02-15 18:05:08', '2026-02-15 18:05:08'),
(403, 'users?search=Leader+Mushio&page=1&pageSize=20&paginate=true', NULL, 'Consultation users?search=Leader+Mushio&page=1&pageSize=20&paginate=true ✅', 'Consultation users?search=Leader+Mushio&page=1&pageSize=20&paginate=true effectuée avec succès.', 'réussi', '2026-02-15 18:05:10', NULL, '2026-02-15 18:05:10', '2026-02-15 18:05:10'),
(404, 'users?search=Malo&page=1&pageSize=20&paginate=true', NULL, 'Consultation users?search=Malo&page=1&pageSize=20&paginate=true ✅', 'Consultation users?search=Malo&page=1&pageSize=20&paginate=true effectuée avec succès.', 'réussi', '2026-02-15 18:05:16', NULL, '2026-02-15 18:05:16', '2026-02-15 18:05:16'),
(405, 'Transfert', 20, NULL, 'Transfert avec frais', 'réussi', '2026-02-15 18:05:22', NULL, '2026-02-15 18:05:22', '2026-02-15 18:05:22'),
(406, 'transfert', NULL, 'Création transfert ✅', 'Création transfert effectuée avec succès.', 'réussi', '2026-02-15 18:05:22', NULL, '2026-02-15 18:05:22', '2026-02-15 18:05:22'),
(407, '1', NULL, 'Consultation 1 ✅', 'Consultation 1 effectuée avec succès.', 'réussi', '2026-02-15 18:05:29', NULL, '2026-02-15 18:05:29', '2026-02-15 18:05:29'),
(408, '2', NULL, 'Consultation 2 ✅', 'Consultation 2 effectuée avec succès.', 'réussi', '2026-02-15 18:06:17', NULL, '2026-02-15 18:06:17', '2026-02-15 18:06:17'),
(409, '2', NULL, 'Consultation 2 ❌', 'Échec lors de consultation 2.', 'réussi', '2026-02-15 18:06:21', NULL, '2026-02-15 18:06:21', '2026-02-15 18:06:21'),
(410, 'createrecharge', NULL, 'Création createrecharge ✅', 'Création createrecharge effectuée avec succès.', 'réussi', '2026-02-15 18:07:21', NULL, '2026-02-15 18:07:21', '2026-02-15 18:07:21'),
(411, 'recharge', NULL, 'Création recharge ✅', 'Création recharge effectuée avec succès.', 'réussi', '2026-02-15 18:07:21', NULL, '2026-02-15 18:07:21', '2026-02-15 18:07:21'),
(412, '2', NULL, 'Consultation 2 ✅', 'Consultation 2 effectuée avec succès.', 'réussi', '2026-02-15 18:07:25', NULL, '2026-02-15 18:07:25', '2026-02-15 18:07:25'),
(413, '1', NULL, 'Consultation 1 ✅', 'Consultation 1 effectuée avec succès.', 'réussi', '2026-02-15 18:08:25', NULL, '2026-02-15 18:08:25', '2026-02-15 18:08:25'),
(414, '1', NULL, 'Consultation 1 ❌', 'Échec lors de consultation 1.', 'réussi', '2026-02-15 18:08:29', NULL, '2026-02-15 18:08:29', '2026-02-15 18:08:29'),
(415, 'retrait', NULL, 'Création retrait ❌', 'Échec lors de création retrait.', 'réussi', '2026-02-15 18:08:41', NULL, '2026-02-15 18:08:41', '2026-02-15 18:08:41'),
(416, 'retrait', NULL, 'Création retrait ❌', 'Échec lors de création retrait.', 'réussi', '2026-02-15 18:09:05', NULL, '2026-02-15 18:09:05', '2026-02-15 18:09:05'),
(417, '5', NULL, 'Consultation 5 ✅', 'Consultation 5 effectuée avec succès.', 'réussi', '2026-02-15 18:13:24', NULL, '2026-02-15 18:13:24', '2026-02-15 18:13:24'),
(418, 'createrecharge', NULL, 'Création createrecharge ✅', 'Création createrecharge effectuée avec succès.', 'réussi', '2026-02-15 18:13:47', NULL, '2026-02-15 18:13:47', '2026-02-15 18:13:47'),
(419, 'recharge', NULL, 'Création recharge ✅', 'Création recharge effectuée avec succès.', 'réussi', '2026-02-15 18:13:48', NULL, '2026-02-15 18:13:48', '2026-02-15 18:13:48'),
(420, '5', NULL, 'Consultation 5 ✅', 'Consultation 5 effectuée avec succès.', 'réussi', '2026-02-15 18:13:54', NULL, '2026-02-15 18:13:54', '2026-02-15 18:13:54'),
(421, 'Retrait', 100, NULL, 'Retrait effectué', 'réussi', '2026-02-15 18:14:15', NULL, '2026-02-15 18:14:15', '2026-02-15 18:14:15'),
(422, 'Retrait', 100, NULL, 'Retrait client reçu', 'réussi', '2026-02-15 18:14:15', NULL, '2026-02-15 18:14:15', '2026-02-15 18:14:15'),
(423, 'Retrait', 2.985, NULL, 'Frais retrait reçu', 'réussi', '2026-02-15 18:14:15', NULL, '2026-02-15 18:14:15', '2026-02-15 18:14:15'),
(424, 'retrait', NULL, 'Création retrait ✅', 'Création retrait effectuée avec succès.', 'réussi', '2026-02-15 18:14:19', NULL, '2026-02-15 18:14:19', '2026-02-15 18:14:19'),
(425, '5', NULL, 'Consultation 5 ✅', 'Consultation 5 effectuée avec succès.', 'réussi', '2026-02-15 18:14:22', NULL, '2026-02-15 18:14:22', '2026-02-15 18:14:22'),
(426, 'Retrait', 50, NULL, 'Retrait effectué', 'réussi', '2026-02-15 18:15:46', NULL, '2026-02-15 18:15:46', '2026-02-15 18:15:46'),
(427, 'Retrait', 50, NULL, 'Retrait client reçu', 'réussi', '2026-02-15 18:15:46', NULL, '2026-02-15 18:15:46', '2026-02-15 18:15:46'),
(428, 'Retrait', 1.4925, NULL, 'Frais retrait reçu', 'réussi', '2026-02-15 18:15:46', NULL, '2026-02-15 18:15:46', '2026-02-15 18:15:46'),
(429, 'retrait', NULL, 'Création retrait ✅', 'Création retrait effectuée avec succès.', 'réussi', '2026-02-15 18:15:49', NULL, '2026-02-15 18:15:49', '2026-02-15 18:15:49'),
(430, '5', NULL, 'Consultation 5 ✅', 'Consultation 5 effectuée avec succès.', 'réussi', '2026-02-15 18:15:52', NULL, '2026-02-15 18:15:52', '2026-02-15 18:15:52'),
(431, 'Retrait', 100, NULL, 'Retrait effectué', 'réussi', '2026-02-15 18:16:03', NULL, '2026-02-15 18:16:03', '2026-02-15 18:16:03'),
(432, 'Retrait', 100, NULL, 'Retrait client reçu', 'réussi', '2026-02-15 18:16:03', NULL, '2026-02-15 18:16:03', '2026-02-15 18:16:03'),
(433, 'Retrait', 2.985, NULL, 'Frais retrait reçu', 'réussi', '2026-02-15 18:16:03', NULL, '2026-02-15 18:16:03', '2026-02-15 18:16:03'),
(434, 'retrait', NULL, 'Création retrait ✅', 'Création retrait effectuée avec succès.', 'réussi', '2026-02-15 18:16:08', NULL, '2026-02-15 18:16:08', '2026-02-15 18:16:08'),
(435, '5', NULL, 'Consultation 5 ✅', 'Consultation 5 effectuée avec succès.', 'réussi', '2026-02-15 18:16:11', NULL, '2026-02-15 18:16:11', '2026-02-15 18:16:11'),
(436, 'retrait', NULL, 'Création retrait ❌', 'Échec lors de création retrait.', 'réussi', '2026-02-15 18:16:21', NULL, '2026-02-15 18:16:21', '2026-02-15 18:16:21'),
(437, 'notification_track?userId=5&search=&page=1&pageSize=20', NULL, 'Consultation notification_track?userId=5&search=&page=1&pageSize=20 ✅', 'Consultation notification_track?userId=5&search=&page=1&pageSize=20 effectuée avec succès.', 'réussi', '2026-02-15 18:16:31', NULL, '2026-02-15 18:16:31', '2026-02-15 18:16:31'),
(438, 'users?search=&page=1&pageSize=20&paginate=true', NULL, 'Consultation users?search=&page=1&pageSize=20&paginate=true ✅', 'Consultation users?search=&page=1&pageSize=20&paginate=true effectuée avec succès.', 'réussi', '2026-02-15 18:17:12', NULL, '2026-02-15 18:17:12', '2026-02-15 18:17:12'),
(439, 'users?search=Leader+Mushio&page=1&pageSize=20&paginate=true', NULL, 'Consultation users?search=Leader+Mushio&page=1&pageSize=20&paginate=true ✅', 'Consultation users?search=Leader+Mushio&page=1&pageSize=20&paginate=true effectuée avec succès.', 'réussi', '2026-02-15 18:17:24', NULL, '2026-02-15 18:17:24', '2026-02-15 18:17:24'),
(440, 'Transfert', 100, NULL, 'Transfert avec frais', 'réussi', '2026-02-15 18:17:29', NULL, '2026-02-15 18:17:29', '2026-02-15 18:17:29'),
(441, 'transfert', NULL, 'Création transfert ✅', 'Création transfert effectuée avec succès.', 'réussi', '2026-02-15 18:17:29', NULL, '2026-02-15 18:17:29', '2026-02-15 18:17:29'),
(442, '5', NULL, 'Consultation 5 ✅', 'Consultation 5 effectuée avec succès.', 'réussi', '2026-02-15 18:17:32', NULL, '2026-02-15 18:17:32', '2026-02-15 18:17:32'),
(443, 'users?search=Malo&page=1&pageSize=20&paginate=true', NULL, 'Consultation users?search=Malo&page=1&pageSize=20&paginate=true ✅', 'Consultation users?search=Malo&page=1&pageSize=20&paginate=true effectuée avec succès.', 'réussi', '2026-02-15 18:18:03', NULL, '2026-02-15 18:18:03', '2026-02-15 18:18:03'),
(444, 'Transfert', 50, NULL, 'Transfert avec frais', 'réussi', '2026-02-15 18:18:07', NULL, '2026-02-15 18:18:07', '2026-02-15 18:18:07'),
(445, 'transfert', NULL, 'Création transfert ✅', 'Création transfert effectuée avec succès.', 'réussi', '2026-02-15 18:18:07', NULL, '2026-02-15 18:18:07', '2026-02-15 18:18:07');
INSERT INTO `histories` (`historyId`, `type`, `amount`, `action`, `description`, `status`, `date`, `userId`, `createdAt`, `updatedAt`) VALUES
(446, '5', NULL, 'Consultation 5 ✅', 'Consultation 5 effectuée avec succès.', 'réussi', '2026-02-15 18:18:10', NULL, '2026-02-15 18:18:10', '2026-02-15 18:18:10'),
(447, 'sector?page=1&pageSize=10&search=&paginate=true', NULL, 'Consultation sector?page=1&pageSize=10&search=&paginate=true ❌', 'Échec lors de consultation sector?page=1&pagesize=10&search=&paginate=true.', 'réussi', '2026-02-15 18:19:02', NULL, '2026-02-15 18:19:02', '2026-02-15 18:19:02'),
(448, 'product?page=1&pageSize=10&search=&paginate=true&companyId=8', NULL, 'Consultation product?page=1&pageSize=10&search=&paginate=true&companyId=8 ❌', 'Échec lors de consultation product?page=1&pagesize=10&search=&paginate=true&companyid=8.', 'réussi', '2026-02-15 18:19:11', NULL, '2026-02-15 18:19:11', '2026-02-15 18:19:11'),
(449, 'Paiement', 100, NULL, 'Paiement commande ORD-1771179602282', 'réussi', '2026-02-15 18:20:02', NULL, '2026-02-15 18:20:02', '2026-02-15 18:20:02'),
(450, 'Paiement', 100, NULL, 'Réception paiement commande ORD-1771179602282', 'réussi', '2026-02-15 18:20:02', NULL, '2026-02-15 18:20:02', '2026-02-15 18:20:02'),
(451, 'paiement', NULL, 'Création paiement ✅', 'Création paiement effectuée avec succès.', 'réussi', '2026-02-15 18:20:06', NULL, '2026-02-15 18:20:06', '2026-02-15 18:20:06'),
(452, '5', NULL, 'Consultation 5 ✅', 'Consultation 5 effectuée avec succès.', 'réussi', '2026-02-15 18:20:11', NULL, '2026-02-15 18:20:11', '2026-02-15 18:20:11'),
(453, 'product?page=1&pageSize=10&search=&paginate=true&companyId=13', NULL, 'Consultation product?page=1&pageSize=10&search=&paginate=true&companyId=13 ✅', 'Consultation product?page=1&pageSize=10&search=&paginate=true&companyId=13 effectuée avec succès.', 'réussi', '2026-02-15 18:22:13', NULL, '2026-02-15 18:22:13', '2026-02-15 18:22:13'),
(454, 'Paiement', 80, NULL, 'Paiement commande ORD-1771179749270', 'réussi', '2026-02-15 18:22:29', NULL, '2026-02-15 18:22:29', '2026-02-15 18:22:29'),
(455, 'Paiement', 80, NULL, 'Réception paiement commande ORD-1771179749270', 'réussi', '2026-02-15 18:22:29', NULL, '2026-02-15 18:22:29', '2026-02-15 18:22:29'),
(456, 'paiement', NULL, 'Création paiement ✅', 'Création paiement effectuée avec succès.', 'réussi', '2026-02-15 18:22:33', NULL, '2026-02-15 18:22:33', '2026-02-15 18:22:33'),
(457, '5', NULL, 'Consultation 5 ✅', 'Consultation 5 effectuée avec succès.', 'réussi', '2026-02-15 18:22:41', NULL, '2026-02-15 18:22:41', '2026-02-15 18:22:41'),
(458, 'notification_track?userId=5&search=&page=1&pageSize=20', NULL, 'Consultation notification_track?userId=5&search=&page=1&pageSize=20 ✅', 'Consultation notification_track?userId=5&search=&page=1&pageSize=20 effectuée avec succès.', 'réussi', '2026-02-15 18:22:50', NULL, '2026-02-15 18:22:50', '2026-02-15 18:22:50'),
(459, '5', NULL, 'Consultation 5 ❌', 'Échec lors de consultation 5.', 'réussi', '2026-02-15 18:23:12', NULL, '2026-02-15 18:23:12', '2026-02-15 18:23:12'),
(460, 'product?page=1&pageSize=10&search=&paginate=true&companyId=12', NULL, 'Consultation product?page=1&pageSize=10&search=&paginate=true&companyId=12 ❌', 'Échec lors de consultation product?page=1&pagesize=10&search=&paginate=true&companyid=12.', 'réussi', '2026-02-15 18:23:41', NULL, '2026-02-15 18:23:41', '2026-02-15 18:23:41'),
(461, 'product?page=1&pageSize=10&search=&paginate=true&companyId=11', NULL, 'Consultation product?page=1&pageSize=10&search=&paginate=true&companyId=11 ❌', 'Échec lors de consultation product?page=1&pagesize=10&search=&paginate=true&companyid=11.', 'réussi', '2026-02-15 18:23:51', NULL, '2026-02-15 18:23:51', '2026-02-15 18:23:51'),
(462, 'product?page=1&pageSize=10&search=&paginate=true&companyId=9', NULL, 'Consultation product?page=1&pageSize=10&search=&paginate=true&companyId=9 ❌', 'Échec lors de consultation product?page=1&pagesize=10&search=&paginate=true&companyid=9.', 'réussi', '2026-02-15 18:24:26', NULL, '2026-02-15 18:24:26', '2026-02-15 18:24:26'),
(463, 'Paiement', 30, NULL, 'Paiement commande ORD-1771179901635', 'réussi', '2026-02-15 18:25:01', NULL, '2026-02-15 18:25:01', '2026-02-15 18:25:01'),
(464, 'Paiement', 30, NULL, 'Réception paiement commande ORD-1771179901635', 'réussi', '2026-02-15 18:25:01', NULL, '2026-02-15 18:25:01', '2026-02-15 18:25:01'),
(465, 'paiement', NULL, 'Création paiement ✅', 'Création paiement effectuée avec succès.', 'réussi', '2026-02-15 18:25:06', NULL, '2026-02-15 18:25:06', '2026-02-15 18:25:06'),
(466, '5', NULL, 'Consultation 5 ✅', 'Consultation 5 effectuée avec succès.', 'réussi', '2026-02-15 18:25:13', NULL, '2026-02-15 18:25:13', '2026-02-15 18:25:13'),
(467, '5', NULL, 'Consultation 5 ✅', 'Consultation 5 effectuée avec succès.', 'réussi', '2026-02-16 18:33:33', NULL, '2026-02-16 18:33:33', '2026-02-16 18:33:33'),
(468, '1', NULL, 'Consultation 1 ✅', 'Consultation 1 effectuée avec succès.', 'réussi', '2026-02-16 18:34:01', NULL, '2026-02-16 18:34:01', '2026-02-16 18:34:01'),
(469, '1', NULL, 'Consultation 1 ❌', 'Échec lors de consultation 1.', 'réussi', '2026-02-16 18:34:09', NULL, '2026-02-16 18:34:09', '2026-02-16 18:34:09'),
(470, 'sector?page=1&pageSize=10&search=&paginate=true', NULL, 'Consultation sector?page=1&pageSize=10&search=&paginate=true ❌', 'Échec lors de consultation sector?page=1&pagesize=10&search=&paginate=true.', 'réussi', '2026-02-16 18:34:21', NULL, '2026-02-16 18:34:21', '2026-02-16 18:34:21'),
(471, '1', NULL, 'Consultation 1 ❌', 'Échec lors de consultation 1.', 'réussi', '2026-02-16 18:34:24', NULL, '2026-02-16 18:34:24', '2026-02-16 18:34:24'),
(472, 'sector?page=1&pageSize=20&search=&paginate=false', NULL, 'Consultation sector?page=1&pageSize=20&search=&paginate=false ✅', 'Consultation sector?page=1&pageSize=20&search=&paginate=false effectuée avec succès.', 'réussi', '2026-02-16 18:34:38', NULL, '2026-02-16 18:34:38', '2026-02-16 18:34:38'),
(473, '1', NULL, 'Consultation 1 ❌', 'Échec lors de consultation 1.', 'réussi', '2026-02-16 18:34:38', NULL, '2026-02-16 18:34:38', '2026-02-16 18:34:38'),
(474, 'product?page=1&pageSize=10&search=&paginate=true&companyId=11', NULL, 'Consultation product?page=1&pageSize=10&search=&paginate=true&companyId=11 ❌', 'Échec lors de consultation product?page=1&pagesize=10&search=&paginate=true&companyid=11.', 'réussi', '2026-02-16 18:35:23', NULL, '2026-02-16 18:35:23', '2026-02-16 18:35:23'),
(475, 'product?page=1&pageSize=10&search=&paginate=true&companyId=12', NULL, 'Consultation product?page=1&pageSize=10&search=&paginate=true&companyId=12 ❌', 'Échec lors de consultation product?page=1&pagesize=10&search=&paginate=true&companyid=12.', 'réussi', '2026-02-16 18:35:25', NULL, '2026-02-16 18:35:25', '2026-02-16 18:35:25'),
(476, 'sector?page=1&pageSize=10&search=&paginate=true', NULL, 'Consultation sector?page=1&pageSize=10&search=&paginate=true ❌', 'Échec lors de consultation sector?page=1&pagesize=10&search=&paginate=true.', 'réussi', '2026-02-16 18:35:41', NULL, '2026-02-16 18:35:41', '2026-02-16 18:35:41'),
(477, 'sector?page=2&pageSize=10&search=&paginate=true', NULL, 'Consultation sector?page=2&pageSize=10&search=&paginate=true ❌', 'Échec lors de consultation sector?page=2&pagesize=10&search=&paginate=true.', 'réussi', '2026-02-16 18:36:14', NULL, '2026-02-16 18:36:14', '2026-02-16 18:36:14'),
(478, 'notification_track?userId=1&search=&page=1&pageSize=20', NULL, 'Consultation notification_track?userId=1&search=&page=1&pageSize=20 ✅', 'Consultation notification_track?userId=1&search=&page=1&pageSize=20 effectuée avec succès.', 'réussi', '2026-02-16 18:38:40', NULL, '2026-02-16 18:38:40', '2026-02-16 18:38:40'),
(479, 'company', NULL, 'Consultation company ✅', 'Consultation company effectuée avec succès.', 'réussi', '2026-02-16 18:54:18', NULL, '2026-02-16 18:54:18', '2026-02-16 18:54:18'),
(480, 'transaction', NULL, 'Consultation des transactions 📄', 'La liste de vos transactions a été consultée avec succès.', 'réussi', '2026-02-16 18:54:36', NULL, '2026-02-16 18:54:36', '2026-02-16 18:54:36'),
(481, 'tsx', NULL, 'Consultation tsx ✅', 'Consultation tsx effectuée avec succès.', 'réussi', '2026-02-16 18:54:36', NULL, '2026-02-16 18:54:36', '2026-02-16 18:54:36'),
(482, 'tsx', NULL, 'Consultation tsx ❌', 'Échec lors de consultation tsx.', 'réussi', '2026-02-16 19:00:42', NULL, '2026-02-16 19:00:42', '2026-02-16 19:00:42'),
(483, 'transaction', NULL, 'Consultation des transactions 📄', 'La liste de vos transactions a été consultée avec succès.', 'réussi', '2026-02-16 19:03:57', NULL, '2026-02-16 19:03:57', '2026-02-16 19:03:57'),
(484, 'tsx', NULL, 'Consultation tsx ✅', 'Consultation tsx effectuée avec succès.', 'réussi', '2026-02-16 19:03:57', NULL, '2026-02-16 19:03:57', '2026-02-16 19:03:57'),
(485, '1', NULL, 'Consultation 1 ✅', 'Consultation 1 effectuée avec succès.', 'réussi', '2026-02-16 19:05:41', NULL, '2026-02-16 19:05:41', '2026-02-16 19:05:41'),
(486, '1', NULL, 'Consultation 1 ❌', 'Échec lors de consultation 1.', 'réussi', '2026-02-16 19:08:57', NULL, '2026-02-16 19:08:57', '2026-02-16 19:08:57'),
(487, '1', NULL, 'Consultation 1 ❌', 'Échec lors de consultation 1.', 'réussi', '2026-02-16 19:09:01', NULL, '2026-02-16 19:09:01', '2026-02-16 19:09:01'),
(488, '1', NULL, 'Consultation 1 ❌', 'Échec lors de consultation 1.', 'réussi', '2026-02-16 19:09:02', NULL, '2026-02-16 19:09:02', '2026-02-16 19:09:02'),
(489, 'transaction', NULL, 'Consultation des transactions 📄', 'La liste de vos transactions a été consultée avec succès.', 'réussi', '2026-02-16 19:11:08', 1, '2026-02-16 19:11:08', '2026-02-16 19:11:08'),
(490, 'tsx?id=1', NULL, 'Consultation tsx?id=1 ✅', 'Consultation tsx?id=1 effectuée avec succès.', 'réussi', '2026-02-16 19:11:08', NULL, '2026-02-16 19:11:08', '2026-02-16 19:11:08'),
(491, 'sector?page=1&pageSize=20&search=&paginate=false', NULL, 'Consultation sector?page=1&pageSize=20&search=&paginate=false ❌', 'Échec lors de consultation sector?page=1&pagesize=20&search=&paginate=false.', 'réussi', '2026-02-16 19:14:51', NULL, '2026-02-16 19:14:51', '2026-02-16 19:14:51'),
(492, '1', NULL, 'Consultation 1 ❌', 'Échec lors de consultation 1.', 'réussi', '2026-02-16 19:14:51', NULL, '2026-02-16 19:14:51', '2026-02-16 19:14:51'),
(493, 'tsx?id=1', NULL, 'Consultation tsx?id=1 ✅', 'Consultation tsx?id=1 effectuée avec succès.', 'réussi', '2026-02-16 19:14:54', NULL, '2026-02-16 19:14:54', '2026-02-16 19:14:54'),
(494, 'transaction', NULL, 'Consultation des transactions 📄', 'La liste de vos transactions a été consultée avec succès.', 'réussi', '2026-02-16 19:14:54', 1, '2026-02-16 19:14:54', '2026-02-16 19:14:54'),
(495, 'tsx?id=1', NULL, 'Consultation tsx?id=1 ❌', 'Échec lors de consultation tsx?id=1.', 'réussi', '2026-02-16 19:15:04', NULL, '2026-02-16 19:15:04', '2026-02-16 19:15:04'),
(496, 'transaction', NULL, 'Consultation des transactions 📄', 'La liste de vos transactions a été consultée avec succès.', 'réussi', '2026-02-16 19:15:04', 1, '2026-02-16 19:15:04', '2026-02-16 19:15:04'),
(497, 'notification_track?userId=1&search=&page=1&pageSize=20', NULL, 'Consultation notification_track?userId=1&search=&page=1&pageSize=20 ✅', 'Consultation notification_track?userId=1&search=&page=1&pageSize=20 effectuée avec succès.', 'réussi', '2026-02-16 19:16:26', NULL, '2026-02-16 19:16:26', '2026-02-16 19:16:26'),
(498, 'transaction', NULL, 'Consultation des transactions 📄', 'La liste de vos transactions a été consultée avec succès.', 'réussi', '2026-02-16 19:17:19', NULL, '2026-02-16 19:17:19', '2026-02-16 19:17:19'),
(499, 'tsx', NULL, 'Consultation tsx ✅', 'Consultation tsx effectuée avec succès.', 'réussi', '2026-02-16 19:17:19', NULL, '2026-02-16 19:17:19', '2026-02-16 19:17:19'),
(500, 'transaction', NULL, 'Consultation des transactions 📄', 'La liste de vos transactions a été consultée avec succès.', 'réussi', '2026-02-16 19:32:17', 1, '2026-02-16 19:32:17', '2026-02-16 19:32:17'),
(501, 'tsx?id=1', NULL, 'Consultation tsx?id=1 ❌', 'Échec lors de consultation tsx?id=1.', 'réussi', '2026-02-16 19:32:17', NULL, '2026-02-16 19:32:17', '2026-02-16 19:32:17'),
(502, 'transaction', NULL, 'Consultation des transactions 📄', 'La liste de vos transactions a été consultée avec succès.', 'réussi', '2026-02-16 19:32:54', 1, '2026-02-16 19:32:54', '2026-02-16 19:32:54'),
(503, 'tsx?id=1', NULL, 'Consultation tsx?id=1 ❌', 'Échec lors de consultation tsx?id=1.', 'réussi', '2026-02-16 19:32:54', NULL, '2026-02-16 19:32:54', '2026-02-16 19:32:54'),
(504, 'sector?page=1&pageSize=10&search=&paginate=true', NULL, 'Consultation sector?page=1&pageSize=10&search=&paginate=true ❌', 'Échec lors de consultation sector?page=1&pagesize=10&search=&paginate=true.', 'réussi', '2026-02-16 19:33:41', NULL, '2026-02-16 19:33:42', '2026-02-16 19:33:42'),
(505, 'tsx?id=1&page=1&pageSize=10&paginate=true', NULL, 'Consultation tsx?id=1&page=1&pageSize=10&paginate=true ✅', 'Consultation tsx?id=1&page=1&pageSize=10&paginate=true effectuée avec succès.', 'réussi', '2026-02-16 19:34:57', NULL, '2026-02-16 19:34:57', '2026-02-16 19:34:57'),
(506, 'sector?page=2&pageSize=10&search=&paginate=true', NULL, 'Consultation sector?page=2&pageSize=10&search=&paginate=true ❌', 'Échec lors de consultation sector?page=2&pagesize=10&search=&paginate=true.', 'réussi', '2026-02-16 19:39:33', NULL, '2026-02-16 19:39:33', '2026-02-16 19:39:33'),
(507, 'tsx?page=1&pageSize=1000&paginate=true', NULL, 'Consultation tsx?page=1&pageSize=1000&paginate=true ✅', 'Consultation tsx?page=1&pageSize=1000&paginate=true effectuée avec succès.', 'réussi', '2026-02-16 19:42:30', NULL, '2026-02-16 19:42:30', '2026-02-16 19:42:30'),
(508, 'sector?page=1&pageSize=10&search=&paginate=true', NULL, 'Consultation sector?page=1&pageSize=10&search=&paginate=true ❌', 'Échec lors de consultation sector?page=1&pagesize=10&search=&paginate=true.', 'réussi', '2026-02-16 19:57:53', NULL, '2026-02-16 19:57:53', '2026-02-16 19:57:53'),
(509, 'tsx?id=1&page=1&pageSize=10&paginate=true', NULL, 'Consultation tsx?id=1&page=1&pageSize=10&paginate=true ❌', 'Échec lors de consultation tsx?id=1&page=1&pagesize=10&paginate=true.', 'réussi', '2026-02-16 19:57:56', NULL, '2026-02-16 19:57:56', '2026-02-16 19:57:56'),
(510, '1', NULL, 'Consultation 1 ❌', 'Échec lors de consultation 1.', 'réussi', '2026-02-16 19:58:31', NULL, '2026-02-16 19:58:31', '2026-02-16 19:58:31'),
(511, 'tsx?page=1&pageSize=1000&paginate=true', NULL, 'Consultation tsx?page=1&pageSize=1000&paginate=true ❌', 'Échec lors de consultation tsx?page=1&pagesize=1000&paginate=true.', 'réussi', '2026-02-16 20:06:47', NULL, '2026-02-16 20:06:47', '2026-02-16 20:06:47'),
(512, 'tsx?page=1&pageSize=1000&paginate=true', NULL, 'Consultation tsx?page=1&pageSize=1000&paginate=true ❌', 'Échec lors de consultation tsx?page=1&pagesize=1000&paginate=true.', 'réussi', '2026-02-16 20:06:48', NULL, '2026-02-16 20:06:48', '2026-02-16 20:06:48'),
(513, 'tsx?page=1&pageSize=1000&paginate=true', NULL, 'Consultation tsx?page=1&pageSize=1000&paginate=true ❌', 'Échec lors de consultation tsx?page=1&pagesize=1000&paginate=true.', 'réussi', '2026-02-16 20:07:10', NULL, '2026-02-16 20:07:10', '2026-02-16 20:07:10'),
(514, 'tsx?page=1&pageSize=1000&paginate=true', NULL, 'Consultation tsx?page=1&pageSize=1000&paginate=true ❌', 'Échec lors de consultation tsx?page=1&pagesize=1000&paginate=true.', 'réussi', '2026-02-16 20:07:11', NULL, '2026-02-16 20:07:11', '2026-02-16 20:07:11'),
(515, 'tsx?page=1&pageSize=1000&paginate=true', NULL, 'Consultation tsx?page=1&pageSize=1000&paginate=true ❌', 'Échec lors de consultation tsx?page=1&pagesize=1000&paginate=true.', 'réussi', '2026-02-16 20:07:37', NULL, '2026-02-16 20:07:37', '2026-02-16 20:07:37'),
(516, 'tsx?page=1&pageSize=1000&paginate=true', NULL, 'Consultation tsx?page=1&pageSize=1000&paginate=true ❌', 'Échec lors de consultation tsx?page=1&pagesize=1000&paginate=true.', 'réussi', '2026-02-16 20:17:22', NULL, '2026-02-16 20:17:22', '2026-02-16 20:17:22'),
(517, 'notification_track?userId=1&search=&page=1&pageSize=20', NULL, 'Consultation notification_track?userId=1&search=&page=1&pageSize=20 ✅', 'Consultation notification_track?userId=1&search=&page=1&pageSize=20 effectuée avec succès.', 'réussi', '2026-02-16 20:21:49', NULL, '2026-02-16 20:21:49', '2026-02-16 20:21:49'),
(518, 'sector?page=2&pageSize=10&search=&paginate=true', NULL, 'Consultation sector?page=2&pageSize=10&search=&paginate=true ❌', 'Échec lors de consultation sector?page=2&pagesize=10&search=&paginate=true.', 'réussi', '2026-02-16 20:24:56', NULL, '2026-02-16 20:24:56', '2026-02-16 20:24:56'),
(519, 'sector?page=1&pageSize=20&search=&paginate=false', NULL, 'Consultation sector?page=1&pageSize=20&search=&paginate=false ✅', 'Consultation sector?page=1&pageSize=20&search=&paginate=false effectuée avec succès.', 'réussi', '2026-02-19 05:17:33', NULL, '2026-02-19 05:17:33', '2026-02-19 05:17:33'),
(520, '1', NULL, 'Consultation 1 ✅', 'Consultation 1 effectuée avec succès.', 'réussi', '2026-02-19 05:17:33', NULL, '2026-02-19 05:17:33', '2026-02-19 05:17:33'),
(521, 'sector?page=1&pageSize=10&search=&paginate=true', NULL, 'Consultation sector?page=1&pageSize=10&search=&paginate=true ❌', 'Échec lors de consultation sector?page=1&pagesize=10&search=&paginate=true.', 'réussi', '2026-02-19 05:19:31', NULL, '2026-02-19 05:19:31', '2026-02-19 05:19:31'),
(522, 'tsx?id=1&page=1&pageSize=10&paginate=true', NULL, 'Consultation tsx?id=1&page=1&pageSize=10&paginate=true ❌', 'Échec lors de consultation tsx?id=1&page=1&pagesize=10&paginate=true.', 'réussi', '2026-02-19 05:21:21', NULL, '2026-02-19 05:21:21', '2026-02-19 05:21:21'),
(523, 'tsx?page=1&pageSize=1000&paginate=true', NULL, 'Consultation tsx?page=1&pageSize=1000&paginate=true ❌', 'Échec lors de consultation tsx?page=1&pagesize=1000&paginate=true.', 'réussi', '2026-02-19 05:21:22', NULL, '2026-02-19 05:21:22', '2026-02-19 05:21:22'),
(524, 'sector?page=2&pageSize=10&search=&paginate=true', NULL, 'Consultation sector?page=2&pageSize=10&search=&paginate=true ❌', 'Échec lors de consultation sector?page=2&pagesize=10&search=&paginate=true.', 'réussi', '2026-02-19 05:22:25', NULL, '2026-02-19 05:22:25', '2026-02-19 05:22:25'),
(525, 'users?search=&page=1&pageSize=20&paginate=true', NULL, 'Consultation users?search=&page=1&pageSize=20&paginate=true ✅', 'Consultation users?search=&page=1&pageSize=20&paginate=true effectuée avec succès.', 'réussi', '2026-02-19 05:23:38', NULL, '2026-02-19 05:23:38', '2026-02-19 05:23:38'),
(526, 'sector?page=1&pageSize=10&search=&paginate=true', NULL, 'Consultation sector?page=1&pageSize=10&search=&paginate=true ❌', 'Échec lors de consultation sector?page=1&pagesize=10&search=&paginate=true.', 'réussi', '2026-02-19 05:24:51', NULL, '2026-02-19 05:24:51', '2026-02-19 05:24:51'),
(527, 'sector?page=2&pageSize=10&search=&paginate=true', NULL, 'Consultation sector?page=2&pageSize=10&search=&paginate=true ❌', 'Échec lors de consultation sector?page=2&pagesize=10&search=&paginate=true.', 'réussi', '2026-02-19 05:37:10', NULL, '2026-02-19 05:37:10', '2026-02-19 05:37:10'),
(528, 'sector?page=1&pageSize=20&search=&paginate=false', NULL, 'Consultation sector?page=1&pageSize=20&search=&paginate=false ❌', 'Échec lors de consultation sector?page=1&pagesize=20&search=&paginate=false.', 'réussi', '2026-02-19 05:54:54', NULL, '2026-02-19 05:54:54', '2026-02-19 05:54:54'),
(529, '1', NULL, 'Consultation 1 ❌', 'Échec lors de consultation 1.', 'réussi', '2026-02-19 05:54:54', NULL, '2026-02-19 05:54:54', '2026-02-19 05:54:54'),
(530, 'createrecharge', NULL, 'Création createrecharge ✅', 'Création createrecharge effectuée avec succès.', 'réussi', '2026-02-19 05:56:09', NULL, '2026-02-19 05:56:09', '2026-02-19 05:56:09'),
(531, 'recharge', NULL, 'Création recharge ✅', 'Création recharge effectuée avec succès.', 'réussi', '2026-02-19 05:56:09', NULL, '2026-02-19 05:56:09', '2026-02-19 05:56:09'),
(532, 'notification_track?userId=1&search=&page=1&pageSize=20', NULL, 'Consultation notification_track?userId=1&search=&page=1&pageSize=20 ✅', 'Consultation notification_track?userId=1&search=&page=1&pageSize=20 effectuée avec succès.', 'réussi', '2026-02-19 05:56:12', NULL, '2026-02-19 05:56:12', '2026-02-19 05:56:12'),
(533, '1', NULL, 'Consultation 1 ✅', 'Consultation 1 effectuée avec succès.', 'réussi', '2026-02-19 05:56:16', NULL, '2026-02-19 05:56:16', '2026-02-19 05:56:16'),
(534, 'users?search=&page=1&pageSize=20&paginate=true', NULL, 'Consultation users?search=&page=1&pageSize=20&paginate=true ✅', 'Consultation users?search=&page=1&pageSize=20&paginate=true effectuée avec succès.', 'réussi', '2026-02-19 05:56:24', NULL, '2026-02-19 05:56:24', '2026-02-19 05:56:24'),
(535, 'sector?page=1&pageSize=10&search=&paginate=true', NULL, 'Consultation sector?page=1&pageSize=10&search=&paginate=true ❌', 'Échec lors de consultation sector?page=1&pagesize=10&search=&paginate=true.', 'réussi', '2026-02-19 05:56:26', NULL, '2026-02-19 05:56:26', '2026-02-19 05:56:26'),
(536, 'product?page=1&pageSize=10&search=&paginate=true&companyId=8', NULL, 'Consultation product?page=1&pageSize=10&search=&paginate=true&companyId=8 ❌', 'Échec lors de consultation product?page=1&pagesize=10&search=&paginate=true&companyid=8.', 'réussi', '2026-02-19 05:56:29', NULL, '2026-02-19 05:56:29', '2026-02-19 05:56:29'),
(537, 'Paiement', 100, NULL, 'Paiement commande ORD-1771480593517', 'réussi', '2026-02-19 05:56:33', NULL, '2026-02-19 05:56:33', '2026-02-19 05:56:33'),
(538, 'Paiement', 100, NULL, 'Réception paiement commande ORD-1771480593517', 'réussi', '2026-02-19 05:56:33', NULL, '2026-02-19 05:56:33', '2026-02-19 05:56:33'),
(539, 'paiement', NULL, 'Création paiement ✅', 'Création paiement effectuée avec succès.', 'réussi', '2026-02-19 05:56:36', NULL, '2026-02-19 05:56:36', '2026-02-19 05:56:36'),
(540, '1', NULL, 'Consultation 1 ✅', 'Consultation 1 effectuée avec succès.', 'réussi', '2026-02-19 05:56:39', NULL, '2026-02-19 05:56:39', '2026-02-19 05:56:39'),
(541, 'tsx?id=1&page=1&pageSize=10&paginate=true', NULL, 'Consultation tsx?id=1&page=1&pageSize=10&paginate=true ❌', 'Échec lors de consultation tsx?id=1&page=1&pagesize=10&paginate=true.', 'réussi', '2026-02-19 06:02:37', NULL, '2026-02-19 06:02:37', '2026-02-19 06:02:37'),
(542, 'tsx?page=1&pageSize=1000&paginate=true', NULL, 'Consultation tsx?page=1&pageSize=1000&paginate=true ❌', 'Échec lors de consultation tsx?page=1&pagesize=1000&paginate=true.', 'réussi', '2026-02-19 06:02:42', NULL, '2026-02-19 06:02:42', '2026-02-19 06:02:42'),
(543, 'notification_track?userId=1&search=&page=1&pageSize=20', NULL, 'Consultation notification_track?userId=1&search=&page=1&pageSize=20 ✅', 'Consultation notification_track?userId=1&search=&page=1&pageSize=20 effectuée avec succès.', 'réussi', '2026-02-19 06:03:23', NULL, '2026-02-19 06:03:23', '2026-02-19 06:03:23'),
(544, 'profile', NULL, 'Mise à jour profile ✅', 'Mise à jour profile effectuée avec succès.', 'réussi', '2026-02-19 06:14:16', NULL, '2026-02-19 06:14:16', '2026-02-19 06:14:16'),
(545, '1', NULL, 'Consultation 1 ✅', 'Consultation 1 effectuée avec succès.', 'réussi', '2026-02-19 06:14:16', NULL, '2026-02-19 06:14:16', '2026-02-19 06:14:16'),
(546, 'MODIFICATION_PROFIL', NULL, 'Profil modifié ✅', 'Votre profil a été mis à jour avec succès.', 'réussi', '2026-02-19 06:14:16', NULL, '2026-02-19 06:14:16', '2026-02-19 06:14:16'),
(547, 'create', NULL, 'Création create ✅', 'Création create effectuée avec succès.', 'réussi', '2026-02-19 06:14:16', NULL, '2026-02-19 06:14:16', '2026-02-19 06:14:16'),
(548, 'create', NULL, 'Création create ✅', 'Création create effectuée avec succès.', 'réussi', '2026-02-19 06:14:16', NULL, '2026-02-19 06:14:16', '2026-02-19 06:14:16'),
(549, 'createrecharge', NULL, 'Création createrecharge ❌', 'Échec lors de création createrecharge.', 'réussi', '2026-02-19 06:18:07', NULL, '2026-02-19 06:18:07', '2026-02-19 06:18:07'),
(550, 'createrecharge', NULL, 'Création createrecharge ❌', 'Échec lors de création createrecharge.', 'réussi', '2026-02-19 06:18:51', NULL, '2026-02-19 06:18:51', '2026-02-19 06:18:51'),
(551, '1', NULL, 'Consultation 1 ✅', 'Consultation 1 effectuée avec succès.', 'réussi', '2026-02-19 06:33:15', NULL, '2026-02-19 06:33:15', '2026-02-19 06:33:15'),
(552, '1', NULL, 'Consultation 1 ❌', 'Échec lors de consultation 1.', 'réussi', '2026-02-19 06:33:18', NULL, '2026-02-19 06:33:18', '2026-02-19 06:33:18'),
(553, '1', NULL, 'Consultation 1 ❌', 'Échec lors de consultation 1.', 'réussi', '2026-02-19 06:33:19', NULL, '2026-02-19 06:33:19', '2026-02-19 06:33:19'),
(554, 'users?search=&page=1&pageSize=20&paginate=true', NULL, 'Consultation users?search=&page=1&pageSize=20&paginate=true ✅', 'Consultation users?search=&page=1&pageSize=20&paginate=true effectuée avec succès.', 'réussi', '2026-02-19 06:33:23', NULL, '2026-02-19 06:33:23', '2026-02-19 06:33:23'),
(555, '1', NULL, 'Consultation 1 ✅', 'Consultation 1 effectuée avec succès.', 'réussi', '2026-02-20 04:12:21', NULL, '2026-02-20 04:12:21', '2026-02-20 04:12:21'),
(556, 'sector?page=1&pageSize=10&search=&paginate=true', NULL, 'Consultation sector?page=1&pageSize=10&search=&paginate=true ❌', 'Échec lors de consultation sector?page=1&pagesize=10&search=&paginate=true.', 'réussi', '2026-02-20 04:15:35', NULL, '2026-02-20 04:15:35', '2026-02-20 04:15:35'),
(557, '1', NULL, 'Consultation 1 ✅', 'Consultation 1 effectuée avec succès.', 'réussi', '2026-02-20 04:15:38', NULL, '2026-02-20 04:15:38', '2026-02-20 04:15:38'),
(558, 'tsx?page=1&pageSize=1000&paginate=true', NULL, 'Consultation tsx?page=1&pageSize=1000&paginate=true ❌', 'Échec lors de consultation tsx?page=1&pagesize=1000&paginate=true.', 'réussi', '2026-02-20 04:15:43', NULL, '2026-02-20 04:15:43', '2026-02-20 04:15:43'),
(559, 'tsx?id=1&page=1&pageSize=10&paginate=true', NULL, 'Consultation tsx?id=1&page=1&pageSize=10&paginate=true ❌', 'Échec lors de consultation tsx?id=1&page=1&pagesize=10&paginate=true.', 'réussi', '2026-02-20 04:15:44', NULL, '2026-02-20 04:15:44', '2026-02-20 04:15:44'),
(560, '1', NULL, 'Consultation 1 ❌', 'Échec lors de consultation 1.', 'réussi', '2026-02-20 04:16:02', NULL, '2026-02-20 04:16:02', '2026-02-20 04:16:02'),
(561, 'sector?page=1&pageSize=20&search=&paginate=false', NULL, 'Consultation sector?page=1&pageSize=20&search=&paginate=false ✅', 'Consultation sector?page=1&pageSize=20&search=&paginate=false effectuée avec succès.', 'réussi', '2026-02-20 04:16:56', NULL, '2026-02-20 04:16:56', '2026-02-20 04:16:56'),
(562, '1', NULL, 'Consultation 1 ❌', 'Échec lors de consultation 1.', 'réussi', '2026-02-20 04:16:56', NULL, '2026-02-20 04:16:56', '2026-02-20 04:16:56'),
(563, 'sector?page=1&pageSize=20&search=&paginate=false', NULL, 'Consultation sector?page=1&pageSize=20&search=&paginate=false ❌', 'Échec lors de consultation sector?page=1&pagesize=20&search=&paginate=false.', 'réussi', '2026-02-20 04:27:08', NULL, '2026-02-20 04:27:08', '2026-02-20 04:27:08'),
(564, '1', NULL, 'Consultation 1 ✅', 'Consultation 1 effectuée avec succès.', 'réussi', '2026-02-20 04:27:08', NULL, '2026-02-20 04:27:08', '2026-02-20 04:27:08'),
(565, 'notification_track?userId=1&search=&page=1&pageSize=20', NULL, 'Consultation notification_track?userId=1&search=&page=1&pageSize=20 ✅', 'Consultation notification_track?userId=1&search=&page=1&pageSize=20 effectuée avec succès.', 'réussi', '2026-02-20 04:28:25', NULL, '2026-02-20 04:28:25', '2026-02-20 04:28:25'),
(566, 'profile', NULL, 'Mise à jour profile ✅', 'Mise à jour profile effectuée avec succès.', 'réussi', '2026-02-20 04:29:25', NULL, '2026-02-20 04:29:25', '2026-02-20 04:29:25'),
(567, '1', NULL, 'Consultation 1 ✅', 'Consultation 1 effectuée avec succès.', 'réussi', '2026-02-20 04:29:25', NULL, '2026-02-20 04:29:25', '2026-02-20 04:29:25'),
(568, 'MODIFICATION_PROFIL', NULL, 'Profil modifié ✅', 'Profil mis à jour.', 'réussi', '2026-02-20 04:29:25', NULL, '2026-02-20 04:29:25', '2026-02-20 04:29:25'),
(569, 'create', NULL, 'Création create ✅', 'Création create effectuée avec succès.', 'réussi', '2026-02-20 04:29:25', NULL, '2026-02-20 04:29:25', '2026-02-20 04:29:25'),
(570, 'create', NULL, 'Création create ✅', 'Création create effectuée avec succès.', 'réussi', '2026-02-20 04:29:25', NULL, '2026-02-20 04:29:25', '2026-02-20 04:29:25'),
(571, 'notification_track?userId=1&search=&page=1&pageSize=20', NULL, 'Consultation notification_track?userId=1&search=&page=1&pageSize=20 ✅', 'Consultation notification_track?userId=1&search=&page=1&pageSize=20 effectuée avec succès.', 'réussi', '2026-02-20 04:32:40', NULL, '2026-02-20 04:32:40', '2026-02-20 04:32:40'),
(572, 'sector?page=1&pageSize=10&search=&paginate=true', NULL, 'Consultation sector?page=1&pageSize=10&search=&paginate=true ❌', 'Échec lors de consultation sector?page=1&pagesize=10&search=&paginate=true.', 'réussi', '2026-02-20 04:33:28', NULL, '2026-02-20 04:33:28', '2026-02-20 04:33:28'),
(573, 'tsx?id=1&page=1&pageSize=10&paginate=true', NULL, 'Consultation tsx?id=1&page=1&pageSize=10&paginate=true ❌', 'Échec lors de consultation tsx?id=1&page=1&pagesize=10&paginate=true.', 'réussi', '2026-02-20 04:33:29', NULL, '2026-02-20 04:33:29', '2026-02-20 04:33:29'),
(574, 'tsx?page=1&pageSize=1000&paginate=true', NULL, 'Consultation tsx?page=1&pageSize=1000&paginate=true ❌', 'Échec lors de consultation tsx?page=1&pagesize=1000&paginate=true.', 'réussi', '2026-02-20 04:33:34', NULL, '2026-02-20 04:33:34', '2026-02-20 04:33:34'),
(575, 'notification_track?userId=1&search=&page=1&pageSize=20', NULL, 'Consultation notification_track?userId=1&search=&page=1&pageSize=20 ✅', 'Consultation notification_track?userId=1&search=&page=1&pageSize=20 effectuée avec succès.', 'réussi', '2026-02-20 04:34:16', NULL, '2026-02-20 04:34:16', '2026-02-20 04:34:16'),
(576, 'notification_track?userId=1&search=Sn&page=1&pageSize=20', NULL, 'Consultation notification_track?userId=1&search=Sn&page=1&pageSize=20 ✅', 'Consultation notification_track?userId=1&search=Sn&page=1&pageSize=20 effectuée avec succès.', 'réussi', '2026-02-20 04:36:38', NULL, '2026-02-20 04:36:38', '2026-02-20 04:36:38'),
(577, 'notification_track?userId=1&search=&page=1&pageSize=20', NULL, 'Consultation notification_track?userId=1&search=&page=1&pageSize=20 ✅', 'Consultation notification_track?userId=1&search=&page=1&pageSize=20 effectuée avec succès.', 'réussi', '2026-02-20 04:36:38', NULL, '2026-02-20 04:36:38', '2026-02-20 04:36:38'),
(578, 'notification_track?userId=1&search=S&page=1&pageSize=20', NULL, 'Consultation notification_track?userId=1&search=S&page=1&pageSize=20 ✅', 'Consultation notification_track?userId=1&search=S&page=1&pageSize=20 effectuée avec succès.', 'réussi', '2026-02-20 04:36:38', NULL, '2026-02-20 04:36:38', '2026-02-20 04:36:38'),
(579, 'notification_track?userId=1&search=Snb&page=1&pageSize=20', NULL, 'Consultation notification_track?userId=1&search=Snb&page=1&pageSize=20 ✅', 'Consultation notification_track?userId=1&search=Snb&page=1&pageSize=20 effectuée avec succès.', 'réussi', '2026-02-20 04:36:39', NULL, '2026-02-20 04:36:39', '2026-02-20 04:36:39'),
(580, 'notification_track?userId=1&search=Snbs&page=1&pageSize=20', NULL, 'Consultation notification_track?userId=1&search=Snbs&page=1&pageSize=20 ✅', 'Consultation notification_track?userId=1&search=Snbs&page=1&pageSize=20 effectuée avec succès.', 'réussi', '2026-02-20 04:36:39', NULL, '2026-02-20 04:36:39', '2026-02-20 04:36:39'),
(581, 'notification_track?userId=1&search=Snbs&page=1&pageSize=20', NULL, 'Consultation notification_track?userId=1&search=Snbs&page=1&pageSize=20 ✅', 'Consultation notification_track?userId=1&search=Snbs&page=1&pageSize=20 effectuée avec succès.', 'réussi', '2026-02-20 04:36:39', NULL, '2026-02-20 04:36:39', '2026-02-20 04:36:39'),
(582, 'notification_track?userId=1&search=Snb&page=1&pageSize=20', NULL, 'Consultation notification_track?userId=1&search=Snb&page=1&pageSize=20 ✅', 'Consultation notification_track?userId=1&search=Snb&page=1&pageSize=20 effectuée avec succès.', 'réussi', '2026-02-20 04:36:39', NULL, '2026-02-20 04:36:39', '2026-02-20 04:36:39'),
(583, 'notification_track?userId=1&search=Sn&page=1&pageSize=20', NULL, 'Consultation notification_track?userId=1&search=Sn&page=1&pageSize=20 ✅', 'Consultation notification_track?userId=1&search=Sn&page=1&pageSize=20 effectuée avec succès.', 'réussi', '2026-02-20 04:36:39', NULL, '2026-02-20 04:36:39', '2026-02-20 04:36:39'),
(584, 'notification_track?userId=1&search=S&page=1&pageSize=20', NULL, 'Consultation notification_track?userId=1&search=S&page=1&pageSize=20 ✅', 'Consultation notification_track?userId=1&search=S&page=1&pageSize=20 effectuée avec succès.', 'réussi', '2026-02-20 04:36:40', NULL, '2026-02-20 04:36:40', '2026-02-20 04:36:40'),
(585, 'notification_track?userId=1&search=&page=1&pageSize=20', NULL, 'Consultation notification_track?userId=1&search=&page=1&pageSize=20 ✅', 'Consultation notification_track?userId=1&search=&page=1&pageSize=20 effectuée avec succès.', 'réussi', '2026-02-20 04:39:12', NULL, '2026-02-20 04:39:12', '2026-02-20 04:39:12'),
(586, '1', NULL, 'Consultation 1 ❌', 'Échec lors de consultation 1.', 'réussi', '2026-02-20 04:41:21', NULL, '2026-02-20 04:41:21', '2026-02-20 04:41:21'),
(587, 'sector?page=1&pageSize=20&search=&paginate=false', NULL, 'Consultation sector?page=1&pageSize=20&search=&paginate=false ❌', 'Échec lors de consultation sector?page=1&pagesize=20&search=&paginate=false.', 'réussi', '2026-02-20 04:41:21', NULL, '2026-02-20 04:41:21', '2026-02-20 04:41:21'),
(588, 'sector?page=1&pageSize=10&search=&paginate=true', NULL, 'Consultation sector?page=1&pageSize=10&search=&paginate=true ❌', 'Échec lors de consultation sector?page=1&pagesize=10&search=&paginate=true.', 'réussi', '2026-02-20 04:42:08', NULL, '2026-02-20 04:42:08', '2026-02-20 04:42:08'),
(589, 'sector?page=2&pageSize=10&search=&paginate=true', NULL, 'Consultation sector?page=2&pageSize=10&search=&paginate=true ❌', 'Échec lors de consultation sector?page=2&pagesize=10&search=&paginate=true.', 'réussi', '2026-02-20 04:42:11', NULL, '2026-02-20 04:42:11', '2026-02-20 04:42:11'),
(590, 'notification_track?userId=1&search=&page=1&pageSize=20', NULL, 'Consultation notification_track?userId=1&search=&page=1&pageSize=20 ✅', 'Consultation notification_track?userId=1&search=&page=1&pageSize=20 effectuée avec succès.', 'réussi', '2026-02-20 04:43:06', NULL, '2026-02-20 04:43:06', '2026-02-20 04:43:06'),
(591, 'product?page=1&pageSize=10&search=&paginate=true&companyId=9', NULL, 'Consultation product?page=1&pageSize=10&search=&paginate=true&companyId=9 ❌', 'Échec lors de consultation product?page=1&pagesize=10&search=&paginate=true&companyid=9.', 'réussi', '2026-02-20 04:43:57', NULL, '2026-02-20 04:43:57', '2026-02-20 04:43:57'),
(592, 'product?page=1&pageSize=10&search=&paginate=true&companyId=8', NULL, 'Consultation product?page=1&pageSize=10&search=&paginate=true&companyId=8 ❌', 'Échec lors de consultation product?page=1&pagesize=10&search=&paginate=true&companyid=8.', 'réussi', '2026-02-20 04:44:02', NULL, '2026-02-20 04:44:02', '2026-02-20 04:44:02'),
(593, 'tsx?id=1&page=1&pageSize=10&paginate=true', NULL, 'Consultation tsx?id=1&page=1&pageSize=10&paginate=true ❌', 'Échec lors de consultation tsx?id=1&page=1&pagesize=10&paginate=true.', 'réussi', '2026-02-20 04:44:47', NULL, '2026-02-20 04:44:47', '2026-02-20 04:44:47'),
(594, 'tsx?page=1&pageSize=1000&paginate=true', NULL, 'Consultation tsx?page=1&pageSize=1000&paginate=true ❌', 'Échec lors de consultation tsx?page=1&pagesize=1000&paginate=true.', 'réussi', '2026-02-20 04:44:47', NULL, '2026-02-20 04:44:47', '2026-02-20 04:44:47'),
(595, 'product?page=1&pageSize=10&search=&paginate=true&companyId=11', NULL, 'Consultation product?page=1&pageSize=10&search=&paginate=true&companyId=11 ❌', 'Échec lors de consultation product?page=1&pagesize=10&search=&paginate=true&companyid=11.', 'réussi', '2026-02-20 04:45:05', NULL, '2026-02-20 04:45:05', '2026-02-20 04:45:05'),
(596, 'notification_track?userId=1&search=&page=1&pageSize=20', NULL, 'Consultation notification_track?userId=1&search=&page=1&pageSize=20 ✅', 'Consultation notification_track?userId=1&search=&page=1&pageSize=20 effectuée avec succès.', 'réussi', '2026-02-20 04:46:06', NULL, '2026-02-20 04:46:06', '2026-02-20 04:46:06'),
(597, 'product?page=1&pageSize=10&search=&paginate=true&companyId=8', NULL, 'Consultation product?page=1&pageSize=10&search=&paginate=true&companyId=8 ❌', 'Échec lors de consultation product?page=1&pagesize=10&search=&paginate=true&companyid=8.', 'réussi', '2026-02-20 04:47:02', NULL, '2026-02-20 04:47:02', '2026-02-20 04:47:02'),
(598, 'product?page=1&pageSize=10&search=&paginate=true&companyId=8', NULL, 'Consultation product?page=1&pageSize=10&search=&paginate=true&companyId=8 ❌', 'Échec lors de consultation product?page=1&pagesize=10&search=&paginate=true&companyid=8.', 'réussi', '2026-02-20 04:49:20', NULL, '2026-02-20 04:49:20', '2026-02-20 04:49:20'),
(599, 'notification_track?userId=1&search=&page=1&pageSize=20', NULL, 'Consultation notification_track?userId=1&search=&page=1&pageSize=20 ✅', 'Consultation notification_track?userId=1&search=&page=1&pageSize=20 effectuée avec succès.', 'réussi', '2026-02-20 04:49:45', NULL, '2026-02-20 04:49:45', '2026-02-20 04:49:45'),
(600, 'product?page=1&pageSize=10&search=&paginate=true&companyId=11', NULL, 'Consultation product?page=1&pageSize=10&search=&paginate=true&companyId=11 ❌', 'Échec lors de consultation product?page=1&pagesize=10&search=&paginate=true&companyid=11.', 'réussi', '2026-02-20 04:51:02', NULL, '2026-02-20 04:51:02', '2026-02-20 04:51:02'),
(601, 'Paiement', 100, NULL, 'Paiement commande ORD-1771563100707', 'réussi', '2026-02-20 04:51:40', NULL, '2026-02-20 04:51:40', '2026-02-20 04:51:40'),
(602, 'Paiement', 100, NULL, 'Réception paiement commande ORD-1771563100707', 'réussi', '2026-02-20 04:51:40', NULL, '2026-02-20 04:51:40', '2026-02-20 04:51:40'),
(603, 'paiement', NULL, 'Création paiement ✅', 'Création paiement effectuée avec succès.', 'réussi', '2026-02-20 04:51:43', NULL, '2026-02-20 04:51:43', '2026-02-20 04:51:43'),
(604, '1', NULL, 'Consultation 1 ✅', 'Consultation 1 effectuée avec succès.', 'réussi', '2026-02-20 04:51:49', NULL, '2026-02-20 04:51:49', '2026-02-20 04:51:49'),
(605, 'sector?page=1&pageSize=10&search=&paginate=true', NULL, 'Consultation sector?page=1&pageSize=10&search=&paginate=true ❌', 'Échec lors de consultation sector?page=1&pagesize=10&search=&paginate=true.', 'réussi', '2026-02-20 04:52:11', NULL, '2026-02-20 04:52:11', '2026-02-20 04:52:11'),
(606, 'product?page=1&pageSize=10&search=&paginate=true&companyId=11', NULL, 'Consultation product?page=1&pageSize=10&search=&paginate=true&companyId=11 ❌', 'Échec lors de consultation product?page=1&pagesize=10&search=&paginate=true&companyid=11.', 'réussi', '2026-02-20 04:52:33', NULL, '2026-02-20 04:52:33', '2026-02-20 04:52:33'),
(607, 'notification_track?userId=1&search=&page=1&pageSize=20', NULL, 'Consultation notification_track?userId=1&search=&page=1&pageSize=20 ✅', 'Consultation notification_track?userId=1&search=&page=1&pageSize=20 effectuée avec succès.', 'réussi', '2026-02-20 05:05:06', NULL, '2026-02-20 05:05:06', '2026-02-20 05:05:06'),
(608, 'notification_track?userId=1&search=&page=1&pageSize=20', NULL, 'Consultation notification_track?userId=1&search=&page=1&pageSize=20 ✅', 'Consultation notification_track?userId=1&search=&page=1&pageSize=20 effectuée avec succès.', 'réussi', '2026-02-20 05:07:27', NULL, '2026-02-20 05:07:27', '2026-02-20 05:07:27'),
(609, 'notification_track?userId=1&search=&page=1&pageSize=20', NULL, 'Consultation notification_track?userId=1&search=&page=1&pageSize=20 ✅', 'Consultation notification_track?userId=1&search=&page=1&pageSize=20 effectuée avec succès.', 'réussi', '2026-02-20 05:10:29', NULL, '2026-02-20 05:10:29', '2026-02-20 05:10:29'),
(610, 'users?search=&page=1&pageSize=20&paginate=true', NULL, 'Consultation users?search=&page=1&pageSize=20&paginate=true ✅', 'Consultation users?search=&page=1&pageSize=20&paginate=true effectuée avec succès.', 'réussi', '2026-02-20 05:13:12', NULL, '2026-02-20 05:13:12', '2026-02-20 05:13:12'),
(611, 'sector?page=1&pageSize=20&search=&paginate=false', NULL, 'Consultation sector?page=1&pageSize=20&search=&paginate=false ❌', 'Échec lors de consultation sector?page=1&pagesize=20&search=&paginate=false.', 'réussi', '2026-02-20 05:14:36', NULL, '2026-02-20 05:14:36', '2026-02-20 05:14:36'),
(612, '1', NULL, 'Consultation 1 ❌', 'Échec lors de consultation 1.', 'réussi', '2026-02-20 05:14:36', NULL, '2026-02-20 05:14:36', '2026-02-20 05:14:36'),
(613, '1', NULL, 'Consultation 1 ✅', 'Consultation 1 effectuée avec succès.', 'réussi', '2026-02-20 05:15:12', NULL, '2026-02-20 05:15:12', '2026-02-20 05:15:12'),
(614, 'sector?page=1&pageSize=20&search=&paginate=false', NULL, 'Consultation sector?page=1&pageSize=20&search=&paginate=false ❌', 'Échec lors de consultation sector?page=1&pagesize=20&search=&paginate=false.', 'réussi', '2026-02-20 05:15:23', NULL, '2026-02-20 05:15:23', '2026-02-20 05:15:23'),
(615, '1', NULL, 'Consultation 1 ❌', 'Échec lors de consultation 1.', 'réussi', '2026-02-20 05:15:23', NULL, '2026-02-20 05:15:23', '2026-02-20 05:15:23'),
(616, 'notification_track?userId=1&search=&page=1&pageSize=20', NULL, 'Consultation notification_track?userId=1&search=&page=1&pageSize=20 ✅', 'Consultation notification_track?userId=1&search=&page=1&pageSize=20 effectuée avec succès.', 'réussi', '2026-02-20 05:16:34', NULL, '2026-02-20 05:16:34', '2026-02-20 05:16:34'),
(617, 'sector?page=1&pageSize=10&search=&paginate=true', NULL, 'Consultation sector?page=1&pageSize=10&search=&paginate=true ❌', 'Échec lors de consultation sector?page=1&pagesize=10&search=&paginate=true.', 'réussi', '2026-02-20 05:17:06', NULL, '2026-02-20 05:17:06', '2026-02-20 05:17:06'),
(618, 'tsx?id=1&page=1&pageSize=10&paginate=true', NULL, 'Consultation tsx?id=1&page=1&pageSize=10&paginate=true ❌', 'Échec lors de consultation tsx?id=1&page=1&pagesize=10&paginate=true.', 'réussi', '2026-02-20 05:17:09', NULL, '2026-02-20 05:17:09', '2026-02-20 05:17:09'),
(619, 'tsx?page=1&pageSize=1000&paginate=true', NULL, 'Consultation tsx?page=1&pageSize=1000&paginate=true ❌', 'Échec lors de consultation tsx?page=1&pagesize=1000&paginate=true.', 'réussi', '2026-02-20 05:17:14', NULL, '2026-02-20 05:17:14', '2026-02-20 05:17:14'),
(620, 'product?page=1&pageSize=10&search=&paginate=true&companyId=8', NULL, 'Consultation product?page=1&pageSize=10&search=&paginate=true&companyId=8 ❌', 'Échec lors de consultation product?page=1&pagesize=10&search=&paginate=true&companyid=8.', 'réussi', '2026-02-20 05:18:11', NULL, '2026-02-20 05:18:11', '2026-02-20 05:18:11'),
(621, 'users?search=&page=1&pageSize=20&paginate=true', NULL, 'Consultation users?search=&page=1&pageSize=20&paginate=true ✅', 'Consultation users?search=&page=1&pageSize=20&paginate=true effectuée avec succès.', 'réussi', '2026-02-20 05:18:28', NULL, '2026-02-20 05:18:28', '2026-02-20 05:18:28'),
(622, 'users?search=john&page=1&pageSize=20&paginate=true', NULL, 'Consultation users?search=john&page=1&pageSize=20&paginate=true ✅', 'Consultation users?search=john&page=1&pageSize=20&paginate=true effectuée avec succès.', 'réussi', '2026-02-20 05:18:36', NULL, '2026-02-20 05:18:36', '2026-02-20 05:18:36'),
(623, 'Transfert', 100, NULL, 'Transfert avec frais', 'réussi', '2026-02-20 05:18:46', NULL, '2026-02-20 05:18:46', '2026-02-20 05:18:46'),
(624, 'transfert', NULL, 'Création transfert ✅', 'Création transfert effectuée avec succès.', 'réussi', '2026-02-20 05:18:46', NULL, '2026-02-20 05:18:46', '2026-02-20 05:18:46'),
(625, '1', NULL, 'Consultation 1 ✅', 'Consultation 1 effectuée avec succès.', 'réussi', '2026-02-20 05:18:52', NULL, '2026-02-20 05:18:52', '2026-02-20 05:18:52'),
(626, 'notification_track?userId=1&search=&page=1&pageSize=20', NULL, 'Consultation notification_track?userId=1&search=&page=1&pageSize=20 ✅', 'Consultation notification_track?userId=1&search=&page=1&pageSize=20 effectuée avec succès.', 'réussi', '2026-02-20 05:18:58', NULL, '2026-02-20 05:18:58', '2026-02-20 05:18:58'),
(627, 'sector?page=1&pageSize=20&search=&paginate=false', NULL, 'Consultation sector?page=1&pageSize=20&search=&paginate=false ❌', 'Échec lors de consultation sector?page=1&pagesize=20&search=&paginate=false.', 'réussi', '2026-02-20 05:24:59', NULL, '2026-02-20 05:24:59', '2026-02-20 05:24:59'),
(628, '1', NULL, 'Consultation 1 ❌', 'Échec lors de consultation 1.', 'réussi', '2026-02-20 05:24:59', NULL, '2026-02-20 05:24:59', '2026-02-20 05:24:59'),
(629, 'connexion', NULL, 'Échec de la connexion ❌', 'Une tentative de connexion a été détectée, mais elle a échoué.', 'réussi', '2026-02-20 05:25:27', NULL, '2026-02-20 05:25:27', '2026-02-20 05:25:27'),
(630, 'create', NULL, 'Création create ✅', 'Création create effectuée avec succès.', 'réussi', '2026-02-20 05:25:27', NULL, '2026-02-20 05:25:27', '2026-02-20 05:25:27'),
(631, 'create', NULL, 'Création create ✅', 'Création create effectuée avec succès.', 'réussi', '2026-02-20 05:25:27', NULL, '2026-02-20 05:25:27', '2026-02-20 05:25:27'),
(632, '1', NULL, 'Consultation 1 ✅', 'Consultation 1 effectuée avec succès.', 'réussi', '2026-02-20 05:26:16', NULL, '2026-02-20 05:26:16', '2026-02-20 05:26:16'),
(633, '1', NULL, 'Consultation 1 ❌', 'Échec lors de consultation 1.', 'réussi', '2026-02-20 05:26:19', NULL, '2026-02-20 05:26:19', '2026-02-20 05:26:19'),
(634, 'sector?page=1&pageSize=20&search=&paginate=false', NULL, 'Consultation sector?page=1&pageSize=20&search=&paginate=false ❌', 'Échec lors de consultation sector?page=1&pagesize=20&search=&paginate=false.', 'réussi', '2026-02-20 05:28:28', NULL, '2026-02-20 05:28:28', '2026-02-20 05:28:28'),
(635, '1', NULL, 'Consultation 1 ❌', 'Échec lors de consultation 1.', 'réussi', '2026-02-20 05:28:28', NULL, '2026-02-20 05:28:28', '2026-02-20 05:28:28'),
(636, 'sector?page=1&pageSize=20&search=&paginate=false', NULL, 'Consultation sector?page=1&pageSize=20&search=&paginate=false ❌', 'Échec lors de consultation sector?page=1&pagesize=20&search=&paginate=false.', 'réussi', '2026-02-20 05:28:57', NULL, '2026-02-20 05:28:57', '2026-02-20 05:28:57'),
(637, '1', NULL, 'Consultation 1 ❌', 'Échec lors de consultation 1.', 'réussi', '2026-02-20 05:28:57', NULL, '2026-02-20 05:28:57', '2026-02-20 05:28:57'),
(638, 'sector?page=1&pageSize=20&search=&paginate=false', NULL, 'Consultation sector?page=1&pageSize=20&search=&paginate=false ❌', 'Échec lors de consultation sector?page=1&pagesize=20&search=&paginate=false.', 'réussi', '2026-02-20 05:29:54', NULL, '2026-02-20 05:29:54', '2026-02-20 05:29:54'),
(639, '1', NULL, 'Consultation 1 ❌', 'Échec lors de consultation 1.', 'réussi', '2026-02-20 05:29:54', NULL, '2026-02-20 05:29:54', '2026-02-20 05:29:54'),
(640, 'sector?page=1&pageSize=20&search=&paginate=false', NULL, 'Consultation sector?page=1&pageSize=20&search=&paginate=false ❌', 'Échec lors de consultation sector?page=1&pagesize=20&search=&paginate=false.', 'réussi', '2026-02-20 05:32:05', NULL, '2026-02-20 05:32:05', '2026-02-20 05:32:05'),
(641, '1', NULL, 'Consultation 1 ✅', 'Consultation 1 effectuée avec succès.', 'réussi', '2026-02-20 05:32:05', NULL, '2026-02-20 05:32:05', '2026-02-20 05:32:05'),
(642, 'connexion', NULL, 'Échec de la connexion ❌', 'Une tentative de connexion a été détectée, mais elle a échoué.', 'réussi', '2026-02-20 05:32:40', NULL, '2026-02-20 05:32:40', '2026-02-20 05:32:40'),
(643, 'create', NULL, 'Création create ✅', 'Création create effectuée avec succès.', 'réussi', '2026-02-20 05:32:40', NULL, '2026-02-20 05:32:40', '2026-02-20 05:32:40'),
(644, 'create', NULL, 'Création create ✅', 'Création create effectuée avec succès.', 'réussi', '2026-02-20 05:32:41', NULL, '2026-02-20 05:32:41', '2026-02-20 05:32:41'),
(645, 'tsx?id=1&page=1&pageSize=10&paginate=true', NULL, 'Consultation tsx?id=1&page=1&pageSize=10&paginate=true ❌', 'Échec lors de consultation tsx?id=1&page=1&pagesize=10&paginate=true.', 'réussi', '2026-02-20 05:33:31', NULL, '2026-02-20 05:33:31', '2026-02-20 05:33:31'),
(646, 'paiement', NULL, 'Création paiement ❌', 'Échec lors de création paiement.', 'réussi', '2026-02-20 05:35:00', NULL, '2026-02-20 05:35:00', '2026-02-20 05:35:00'),
(647, 'paiement', NULL, 'Création paiement ❌', 'Échec lors de création paiement.', 'réussi', '2026-02-20 05:35:06', NULL, '2026-02-20 05:35:06', '2026-02-20 05:35:06'),
(648, 'paiement', NULL, 'Création paiement ❌', 'Échec lors de création paiement.', 'réussi', '2026-02-20 05:36:24', NULL, '2026-02-20 05:36:24', '2026-02-20 05:36:24'),
(649, 'paiement', NULL, 'Création paiement ❌', 'Échec lors de création paiement.', 'réussi', '2026-02-20 05:37:30', NULL, '2026-02-20 05:37:30', '2026-02-20 05:37:30'),
(650, 'Transfert', 100, NULL, 'Transfert avec frais', 'réussi', '2026-02-20 05:45:01', NULL, '2026-02-20 05:45:01', '2026-02-20 05:45:01'),
(651, 'transfert', NULL, 'Création transfert ✅', 'Création transfert effectuée avec succès.', 'réussi', '2026-02-20 05:45:01', NULL, '2026-02-20 05:45:01', '2026-02-20 05:45:01'),
(652, '1', NULL, 'Consultation 1 ✅', 'Consultation 1 effectuée avec succès.', 'réussi', '2026-02-20 05:45:08', NULL, '2026-02-20 05:45:08', '2026-02-20 05:45:08'),
(653, 'notification_track?userId=1&search=&page=1&pageSize=20', NULL, 'Consultation notification_track?userId=1&search=&page=1&pageSize=20 ✅', 'Consultation notification_track?userId=1&search=&page=1&pageSize=20 effectuée avec succès.', 'réussi', '2026-02-20 05:45:13', NULL, '2026-02-20 05:45:13', '2026-02-20 05:45:13'),
(654, 'tsx?page=1&pageSize=1000&paginate=true', NULL, 'Consultation tsx?page=1&pageSize=1000&paginate=true ❌', 'Échec lors de consultation tsx?page=1&pagesize=1000&paginate=true.', 'réussi', '2026-02-20 05:45:58', NULL, '2026-02-20 05:45:58', '2026-02-20 05:45:58'),
(655, 'sector?page=1&pageSize=10&search=&paginate=true', NULL, 'Consultation sector?page=1&pageSize=10&search=&paginate=true ❌', 'Échec lors de consultation sector?page=1&pagesize=10&search=&paginate=true.', 'réussi', '2026-02-20 05:45:59', NULL, '2026-02-20 05:45:59', '2026-02-20 05:45:59'),
(656, '1', NULL, 'Consultation 1 ❌', 'Échec lors de consultation 1.', 'réussi', '2026-02-20 05:46:08', NULL, '2026-02-20 05:46:08', '2026-02-20 05:46:08');
INSERT INTO `histories` (`historyId`, `type`, `amount`, `action`, `description`, `status`, `date`, `userId`, `createdAt`, `updatedAt`) VALUES
(657, '1', NULL, 'Consultation 1 ❌', 'Échec lors de consultation 1.', 'réussi', '2026-02-20 05:54:59', NULL, '2026-02-20 05:54:59', '2026-02-20 05:54:59'),
(658, 'sector?page=1&pageSize=20&search=&paginate=false', NULL, 'Consultation sector?page=1&pageSize=20&search=&paginate=false ❌', 'Échec lors de consultation sector?page=1&pagesize=20&search=&paginate=false.', 'réussi', '2026-02-20 05:54:59', NULL, '2026-02-20 05:54:59', '2026-02-20 05:54:59'),
(659, 'sector?page=1&pageSize=10&search=&paginate=true', NULL, 'Consultation sector?page=1&pageSize=10&search=&paginate=true ❌', 'Échec lors de consultation sector?page=1&pagesize=10&search=&paginate=true.', 'réussi', '2026-02-20 06:00:06', NULL, '2026-02-20 06:00:06', '2026-02-20 06:00:06'),
(660, 'tsx?id=1&page=1&pageSize=10&paginate=true', NULL, 'Consultation tsx?id=1&page=1&pageSize=10&paginate=true ❌', 'Échec lors de consultation tsx?id=1&page=1&pagesize=10&paginate=true.', 'réussi', '2026-02-20 06:00:08', NULL, '2026-02-20 06:00:08', '2026-02-20 06:00:08'),
(661, 'tsx?page=1&pageSize=1000&paginate=true', NULL, 'Consultation tsx?page=1&pageSize=1000&paginate=true ❌', 'Échec lors de consultation tsx?page=1&pagesize=1000&paginate=true.', 'réussi', '2026-02-20 06:00:14', NULL, '2026-02-20 06:00:14', '2026-02-20 06:00:14'),
(662, 'notification_track?userId=1&search=&page=1&pageSize=20', NULL, 'Consultation notification_track?userId=1&search=&page=1&pageSize=20 ✅', 'Consultation notification_track?userId=1&search=&page=1&pageSize=20 effectuée avec succès.', 'réussi', '2026-02-20 06:00:30', NULL, '2026-02-20 06:00:30', '2026-02-20 06:00:30'),
(663, 'product?page=1&pageSize=10&search=&paginate=true&companyId=8', NULL, 'Consultation product?page=1&pageSize=10&search=&paginate=true&companyId=8 ❌', 'Échec lors de consultation product?page=1&pagesize=10&search=&paginate=true&companyid=8.', 'réussi', '2026-02-20 06:02:26', NULL, '2026-02-20 06:02:26', '2026-02-20 06:02:26'),
(664, 'product?page=1&pageSize=10&search=&paginate=true&companyId=9', NULL, 'Consultation product?page=1&pageSize=10&search=&paginate=true&companyId=9 ❌', 'Échec lors de consultation product?page=1&pagesize=10&search=&paginate=true&companyid=9.', 'réussi', '2026-02-20 06:02:36', NULL, '2026-02-20 06:02:36', '2026-02-20 06:02:36'),
(665, 'notification_track?userId=1&search=&page=1&pageSize=20', NULL, 'Consultation notification_track?userId=1&search=&page=1&pageSize=20 ❌', 'Échec lors de consultation notification_track?userid=1&search=&page=1&pagesize=20.', 'réussi', '2026-02-20 06:04:26', NULL, '2026-02-20 06:04:26', '2026-02-20 06:04:26'),
(666, '1', NULL, 'Consultation 1 ✅', 'Consultation 1 effectuée avec succès.', 'réussi', '2026-02-20 06:05:49', NULL, '2026-02-20 06:05:49', '2026-02-20 06:05:49'),
(667, 'sector?page=1&pageSize=20&search=&paginate=false', NULL, 'Consultation sector?page=1&pageSize=20&search=&paginate=false ❌', 'Échec lors de consultation sector?page=1&pagesize=20&search=&paginate=false.', 'réussi', '2026-02-20 06:05:49', NULL, '2026-02-20 06:05:49', '2026-02-20 06:05:49'),
(668, '1', NULL, 'Consultation 1 ❌', 'Échec lors de consultation 1.', 'réussi', '2026-02-20 06:09:50', NULL, '2026-02-20 06:09:50', '2026-02-20 06:09:50'),
(669, 'sector?page=1&pageSize=20&search=&paginate=false', NULL, 'Consultation sector?page=1&pageSize=20&search=&paginate=false ❌', 'Échec lors de consultation sector?page=1&pagesize=20&search=&paginate=false.', 'réussi', '2026-02-20 06:09:50', NULL, '2026-02-20 06:09:50', '2026-02-20 06:09:50'),
(670, 'sector?page=1&pageSize=10&search=&paginate=true', NULL, 'Consultation sector?page=1&pageSize=10&search=&paginate=true ❌', 'Échec lors de consultation sector?page=1&pagesize=10&search=&paginate=true.', 'réussi', '2026-02-20 06:12:38', NULL, '2026-02-20 06:12:38', '2026-02-20 06:12:38'),
(671, 'product?page=1&pageSize=10&search=&paginate=true&companyId=11', NULL, 'Consultation product?page=1&pageSize=10&search=&paginate=true&companyId=11 ❌', 'Échec lors de consultation product?page=1&pagesize=10&search=&paginate=true&companyid=11.', 'réussi', '2026-02-20 06:12:43', NULL, '2026-02-20 06:12:43', '2026-02-20 06:12:43'),
(672, 'tsx?id=1&page=1&pageSize=10&paginate=true', NULL, 'Consultation tsx?id=1&page=1&pageSize=10&paginate=true ❌', 'Échec lors de consultation tsx?id=1&page=1&pagesize=10&paginate=true.', 'réussi', '2026-02-20 06:14:09', NULL, '2026-02-20 06:14:09', '2026-02-20 06:14:09'),
(673, 'tsx?page=1&pageSize=1000&paginate=true', NULL, 'Consultation tsx?page=1&pageSize=1000&paginate=true ❌', 'Échec lors de consultation tsx?page=1&pagesize=1000&paginate=true.', 'réussi', '2026-02-20 06:14:16', NULL, '2026-02-20 06:14:16', '2026-02-20 06:14:16'),
(674, 'product?page=1&pageSize=10&search=&paginate=true&companyId=8', NULL, 'Consultation product?page=1&pageSize=10&search=&paginate=true&companyId=8 ❌', 'Échec lors de consultation product?page=1&pagesize=10&search=&paginate=true&companyid=8.', 'réussi', '2026-02-20 06:18:15', NULL, '2026-02-20 06:18:15', '2026-02-20 06:18:15'),
(675, 'sector?page=2&pageSize=10&search=&paginate=true', NULL, 'Consultation sector?page=2&pageSize=10&search=&paginate=true ❌', 'Échec lors de consultation sector?page=2&pagesize=10&search=&paginate=true.', 'réussi', '2026-02-20 06:18:44', NULL, '2026-02-20 06:18:44', '2026-02-20 06:18:44'),
(676, 'sector?page=1&pageSize=10&search=&paginate=true', NULL, 'Consultation sector?page=1&pageSize=10&search=&paginate=true ❌', 'Échec lors de consultation sector?page=1&pagesize=10&search=&paginate=true.', 'réussi', '2026-02-20 06:19:59', NULL, '2026-02-20 06:19:59', '2026-02-20 06:19:59'),
(677, 'tsx?id=1&page=1&pageSize=10&paginate=true', NULL, 'Consultation tsx?id=1&page=1&pageSize=10&paginate=true ❌', 'Échec lors de consultation tsx?id=1&page=1&pagesize=10&paginate=true.', 'réussi', '2026-02-20 06:19:59', NULL, '2026-02-20 06:19:59', '2026-02-20 06:19:59'),
(678, 'tsx?page=1&pageSize=1000&paginate=true', NULL, 'Consultation tsx?page=1&pageSize=1000&paginate=true ❌', 'Échec lors de consultation tsx?page=1&pagesize=1000&paginate=true.', 'réussi', '2026-02-20 06:20:01', NULL, '2026-02-20 06:20:01', '2026-02-20 06:20:01'),
(679, 'product?page=1&pageSize=10&search=&paginate=true&companyId=11', NULL, 'Consultation product?page=1&pageSize=10&search=&paginate=true&companyId=11 ❌', 'Échec lors de consultation product?page=1&pagesize=10&search=&paginate=true&companyid=11.', 'réussi', '2026-02-20 06:22:55', NULL, '2026-02-20 06:22:55', '2026-02-20 06:22:55'),
(680, 'sector?page=1&pageSize=20&search=&paginate=false', NULL, 'Consultation sector?page=1&pageSize=20&search=&paginate=false ❌', 'Échec lors de consultation sector?page=1&pagesize=20&search=&paginate=false.', 'réussi', '2026-02-20 06:23:07', NULL, '2026-02-20 06:23:07', '2026-02-20 06:23:07'),
(681, '1', NULL, 'Consultation 1 ✅', 'Consultation 1 effectuée avec succès.', 'réussi', '2026-02-20 06:23:07', NULL, '2026-02-20 06:23:07', '2026-02-20 06:23:07'),
(682, 'sector?page=1&pageSize=20&search=&paginate=false', NULL, 'Consultation sector?page=1&pageSize=20&search=&paginate=false ❌', 'Échec lors de consultation sector?page=1&pagesize=20&search=&paginate=false.', 'réussi', '2026-02-20 06:23:29', NULL, '2026-02-20 06:23:29', '2026-02-20 06:23:29'),
(683, '1', NULL, 'Consultation 1 ❌', 'Échec lors de consultation 1.', 'réussi', '2026-02-20 06:23:29', NULL, '2026-02-20 06:23:29', '2026-02-20 06:23:29'),
(684, 'product?page=1&pageSize=10&search=&paginate=true&companyId=11', NULL, 'Consultation product?page=1&pageSize=10&search=&paginate=true&companyId=11 ❌', 'Échec lors de consultation product?page=1&pagesize=10&search=&paginate=true&companyid=11.', 'réussi', '2026-02-20 06:24:09', NULL, '2026-02-20 06:24:09', '2026-02-20 06:24:09'),
(685, 'sector?page=1&pageSize=10&search=&paginate=true', NULL, 'Consultation sector?page=1&pageSize=10&search=&paginate=true ❌', 'Échec lors de consultation sector?page=1&pagesize=10&search=&paginate=true.', 'réussi', '2026-02-20 06:26:02', NULL, '2026-02-20 06:26:02', '2026-02-20 06:26:02'),
(686, 'tsx?id=1&page=1&pageSize=10&paginate=true', NULL, 'Consultation tsx?id=1&page=1&pageSize=10&paginate=true ❌', 'Échec lors de consultation tsx?id=1&page=1&pagesize=10&paginate=true.', 'réussi', '2026-02-20 06:26:16', NULL, '2026-02-20 06:26:16', '2026-02-20 06:26:16'),
(687, 'tsx?page=1&pageSize=1000&paginate=true', NULL, 'Consultation tsx?page=1&pageSize=1000&paginate=true ❌', 'Échec lors de consultation tsx?page=1&pagesize=1000&paginate=true.', 'réussi', '2026-02-20 06:26:25', NULL, '2026-02-20 06:26:25', '2026-02-20 06:26:25'),
(688, 'notification_track?userId=1&search=&page=1&pageSize=20', NULL, 'Consultation notification_track?userId=1&search=&page=1&pageSize=20 ❌', 'Échec lors de consultation notification_track?userid=1&search=&page=1&pagesize=20.', 'réussi', '2026-02-20 06:26:48', NULL, '2026-02-20 06:26:48', '2026-02-20 06:26:48'),
(689, 'product?page=1&pageSize=10&search=&paginate=true&companyId=9', NULL, 'Consultation product?page=1&pageSize=10&search=&paginate=true&companyId=9 ❌', 'Échec lors de consultation product?page=1&pagesize=10&search=&paginate=true&companyid=9.', 'réussi', '2026-02-20 06:27:29', NULL, '2026-02-20 06:27:29', '2026-02-20 06:27:29'),
(690, 'product?page=1&pageSize=10&search=&paginate=true&companyId=10', NULL, 'Consultation product?page=1&pageSize=10&search=&paginate=true&companyId=10 ❌', 'Échec lors de consultation product?page=1&pagesize=10&search=&paginate=true&companyid=10.', 'réussi', '2026-02-20 06:28:12', NULL, '2026-02-20 06:28:12', '2026-02-20 06:28:12'),
(691, 'Paiement', 10, NULL, 'Paiement commande ORD-1771568905511', 'réussi', '2026-02-20 06:28:25', NULL, '2026-02-20 06:28:25', '2026-02-20 06:28:25'),
(692, 'Paiement', 10, NULL, 'Réception paiement commande ORD-1771568905511', 'réussi', '2026-02-20 06:28:25', NULL, '2026-02-20 06:28:25', '2026-02-20 06:28:25'),
(693, 'paiement', NULL, 'Création paiement ✅', 'Création paiement effectuée avec succès.', 'réussi', '2026-02-20 06:28:28', NULL, '2026-02-20 06:28:28', '2026-02-20 06:28:28'),
(694, '1', NULL, 'Consultation 1 ✅', 'Consultation 1 effectuée avec succès.', 'réussi', '2026-02-20 06:28:31', NULL, '2026-02-20 06:28:31', '2026-02-20 06:28:31'),
(695, 'notification_track?userId=1&search=&page=1&pageSize=20', NULL, 'Consultation notification_track?userId=1&search=&page=1&pageSize=20 ✅', 'Consultation notification_track?userId=1&search=&page=1&pageSize=20 effectuée avec succès.', 'réussi', '2026-02-20 06:28:34', NULL, '2026-02-20 06:28:34', '2026-02-20 06:28:34'),
(696, 'users?search=&page=1&pageSize=20&paginate=true', NULL, 'Consultation users?search=&page=1&pageSize=20&paginate=true ✅', 'Consultation users?search=&page=1&pageSize=20&paginate=true effectuée avec succès.', 'réussi', '2026-02-20 06:30:32', NULL, '2026-02-20 06:30:32', '2026-02-20 06:30:32'),
(697, 'product?page=1&pageSize=10&search=&paginate=true&companyId=13', NULL, 'Consultation product?page=1&pageSize=10&search=&paginate=true&companyId=13 ❌', 'Échec lors de consultation product?page=1&pagesize=10&search=&paginate=true&companyid=13.', 'réussi', '2026-02-20 06:31:37', NULL, '2026-02-20 06:31:37', '2026-02-20 06:31:37'),
(698, '1', NULL, 'Consultation 1 ❌', 'Échec lors de consultation 1.', 'réussi', '2026-02-20 06:31:50', NULL, '2026-02-20 06:31:50', '2026-02-20 06:31:50'),
(699, 'product?page=1&pageSize=10&search=&paginate=true&companyId=13', NULL, 'Consultation product?page=1&pageSize=10&search=&paginate=true&companyId=13 ❌', 'Échec lors de consultation product?page=1&pagesize=10&search=&paginate=true&companyid=13.', 'réussi', '2026-02-20 06:37:33', NULL, '2026-02-20 06:37:33', '2026-02-20 06:37:33'),
(700, 'sector?page=1&pageSize=20&search=&paginate=false', NULL, 'Consultation sector?page=1&pageSize=20&search=&paginate=false ❌', 'Échec lors de consultation sector?page=1&pagesize=20&search=&paginate=false.', 'réussi', '2026-02-20 06:38:13', NULL, '2026-02-20 06:38:13', '2026-02-20 06:38:13'),
(701, '1', NULL, 'Consultation 1 ❌', 'Échec lors de consultation 1.', 'réussi', '2026-02-20 06:38:13', NULL, '2026-02-20 06:38:13', '2026-02-20 06:38:13'),
(702, 'sector?page=1&pageSize=20&search=&paginate=false', NULL, 'Consultation sector?page=1&pageSize=20&search=&paginate=false ❌', 'Échec lors de consultation sector?page=1&pagesize=20&search=&paginate=false.', 'réussi', '2026-02-20 06:39:57', NULL, '2026-02-20 06:39:57', '2026-02-20 06:39:57'),
(703, '1', NULL, 'Consultation 1 ✅', 'Consultation 1 effectuée avec succès.', 'réussi', '2026-02-20 06:39:57', NULL, '2026-02-20 06:39:57', '2026-02-20 06:39:57'),
(704, '1', NULL, 'Consultation 1 ❌', 'Échec lors de consultation 1.', 'réussi', '2026-02-20 06:41:04', NULL, '2026-02-20 06:41:04', '2026-02-20 06:41:04'),
(705, 'sector?page=1&pageSize=20&search=&paginate=false', NULL, 'Consultation sector?page=1&pageSize=20&search=&paginate=false ❌', 'Échec lors de consultation sector?page=1&pagesize=20&search=&paginate=false.', 'réussi', '2026-02-20 06:41:04', NULL, '2026-02-20 06:41:04', '2026-02-20 06:41:04'),
(706, 'sector?page=1&pageSize=10&search=&paginate=true', NULL, 'Consultation sector?page=1&pageSize=10&search=&paginate=true ❌', 'Échec lors de consultation sector?page=1&pagesize=10&search=&paginate=true.', 'réussi', '2026-02-20 06:42:45', NULL, '2026-02-20 06:42:45', '2026-02-20 06:42:45'),
(707, 'tsx?id=1&page=1&pageSize=10&paginate=true', NULL, 'Consultation tsx?id=1&page=1&pageSize=10&paginate=true ❌', 'Échec lors de consultation tsx?id=1&page=1&pagesize=10&paginate=true.', 'réussi', '2026-02-20 06:42:45', NULL, '2026-02-20 06:42:45', '2026-02-20 06:42:45'),
(708, 'tsx?page=1&pageSize=1000&paginate=true', NULL, 'Consultation tsx?page=1&pageSize=1000&paginate=true ❌', 'Échec lors de consultation tsx?page=1&pagesize=1000&paginate=true.', 'réussi', '2026-02-20 06:42:46', NULL, '2026-02-20 06:42:46', '2026-02-20 06:42:46'),
(709, 'sector?page=1&pageSize=20&search=&paginate=false', NULL, 'Consultation sector?page=1&pageSize=20&search=&paginate=false ✅', 'Consultation sector?page=1&pageSize=20&search=&paginate=false effectuée avec succès.', 'réussi', '2026-02-20 07:49:54', NULL, '2026-02-20 07:49:54', '2026-02-20 07:49:54'),
(710, '1', NULL, 'Consultation 1 ✅', 'Consultation 1 effectuée avec succès.', 'réussi', '2026-02-20 07:49:54', NULL, '2026-02-20 07:49:54', '2026-02-20 07:49:54'),
(711, 'sector?page=1&pageSize=20&search=&paginate=false', NULL, 'Consultation sector?page=1&pageSize=20&search=&paginate=false ✅', 'Consultation sector?page=1&pageSize=20&search=&paginate=false effectuée avec succès.', 'réussi', '2026-02-20 07:57:34', NULL, '2026-02-20 07:57:34', '2026-02-20 07:57:34'),
(712, '6', NULL, 'Consultation 6 ✅', 'Consultation 6 effectuée avec succès.', 'réussi', '2026-02-20 07:57:34', NULL, '2026-02-20 07:57:34', '2026-02-20 07:57:34'),
(713, '6', NULL, 'Consultation 6 ❌', 'Échec lors de consultation 6.', 'réussi', '2026-02-20 07:57:49', NULL, '2026-02-20 07:57:49', '2026-02-20 07:57:49'),
(714, 'createrecharge', NULL, 'Création createrecharge ❌', 'Échec lors de création createrecharge.', 'réussi', '2026-02-20 08:00:51', NULL, '2026-02-20 08:00:51', '2026-02-20 08:00:51'),
(715, '1', NULL, 'Consultation 1 ❌', 'Échec lors de consultation 1.', 'réussi', '2026-02-20 08:02:55', NULL, '2026-02-20 08:02:55', '2026-02-20 08:02:55'),
(716, 'notification_track?userId=1&search=&page=1&pageSize=20', NULL, 'Consultation notification_track?userId=1&search=&page=1&pageSize=20 ✅', 'Consultation notification_track?userId=1&search=&page=1&pageSize=20 effectuée avec succès.', 'réussi', '2026-02-20 08:03:02', NULL, '2026-02-20 08:03:02', '2026-02-20 08:03:02'),
(717, '1', NULL, 'Consultation 1 ❌', 'Échec lors de consultation 1.', 'réussi', '2026-02-20 08:03:22', NULL, '2026-02-20 08:03:22', '2026-02-20 08:03:22'),
(718, 'notification_track?userId=1&search=&page=1&pageSize=20', NULL, 'Consultation notification_track?userId=1&search=&page=1&pageSize=20 ❌', 'Échec lors de consultation notification_track?userid=1&search=&page=1&pagesize=20.', 'réussi', '2026-02-20 08:04:41', NULL, '2026-02-20 08:04:41', '2026-02-20 08:04:41'),
(719, '1', NULL, 'Consultation 1 ❌', 'Échec lors de consultation 1.', 'réussi', '2026-02-20 08:04:43', NULL, '2026-02-20 08:04:43', '2026-02-20 08:04:43'),
(720, '1', NULL, 'Consultation 1 ❌', 'Échec lors de consultation 1.', 'réussi', '2026-02-20 08:04:44', NULL, '2026-02-20 08:04:44', '2026-02-20 08:04:44'),
(721, '1', NULL, 'Consultation 1 ❌', 'Échec lors de consultation 1.', 'réussi', '2026-02-20 08:04:56', NULL, '2026-02-20 08:04:56', '2026-02-20 08:04:56'),
(722, '1', NULL, 'Consultation 1 ❌', 'Échec lors de consultation 1.', 'réussi', '2026-02-20 08:05:01', NULL, '2026-02-20 08:05:01', '2026-02-20 08:05:01'),
(723, '1', NULL, 'Consultation 1 ❌', 'Échec lors de consultation 1.', 'réussi', '2026-02-20 08:05:13', NULL, '2026-02-20 08:05:13', '2026-02-20 08:05:13'),
(724, '1', NULL, 'Consultation 1 ❌', 'Échec lors de consultation 1.', 'réussi', '2026-02-20 08:06:12', NULL, '2026-02-20 08:06:12', '2026-02-20 08:06:12'),
(725, 'users?search=&page=1&pageSize=20&paginate=true', NULL, 'Consultation users?search=&page=1&pageSize=20&paginate=true ✅', 'Consultation users?search=&page=1&pageSize=20&paginate=true effectuée avec succès.', 'réussi', '2026-02-20 08:06:46', NULL, '2026-02-20 08:06:46', '2026-02-20 08:06:46'),
(726, 'users?search=&page=1&pageSize=20&paginate=true', NULL, 'Consultation users?search=&page=1&pageSize=20&paginate=true ❌', 'Échec lors de consultation users?search=&page=1&pagesize=20&paginate=true.', 'réussi', '2026-02-20 08:07:13', NULL, '2026-02-20 08:07:13', '2026-02-20 08:07:13'),
(727, 'users?search=u&page=1&pageSize=20&paginate=true', NULL, 'Consultation users?search=u&page=1&pageSize=20&paginate=true ✅', 'Consultation users?search=u&page=1&pageSize=20&paginate=true effectuée avec succès.', 'réussi', '2026-02-20 08:07:13', NULL, '2026-02-20 08:07:13', '2026-02-20 08:07:13'),
(728, 'users?search=us&page=1&pageSize=20&paginate=true', NULL, 'Consultation users?search=us&page=1&pageSize=20&paginate=true ✅', 'Consultation users?search=us&page=1&pageSize=20&paginate=true effectuée avec succès.', 'réussi', '2026-02-20 08:07:14', NULL, '2026-02-20 08:07:14', '2026-02-20 08:07:14'),
(729, 'users?search=u&page=1&pageSize=20&paginate=true', NULL, 'Consultation users?search=u&page=1&pageSize=20&paginate=true ❌', 'Échec lors de consultation users?search=u&page=1&pagesize=20&paginate=true.', 'réussi', '2026-02-20 08:07:14', NULL, '2026-02-20 08:07:14', '2026-02-20 08:07:14'),
(730, 'users?search=use&page=1&pageSize=20&paginate=true', NULL, 'Consultation users?search=use&page=1&pageSize=20&paginate=true ✅', 'Consultation users?search=use&page=1&pageSize=20&paginate=true effectuée avec succès.', 'réussi', '2026-02-20 08:07:14', NULL, '2026-02-20 08:07:14', '2026-02-20 08:07:14'),
(731, 'users?search=use&page=1&pageSize=20&paginate=true', NULL, 'Consultation users?search=use&page=1&pageSize=20&paginate=true ❌', 'Échec lors de consultation users?search=use&page=1&pagesize=20&paginate=true.', 'réussi', '2026-02-20 08:07:14', NULL, '2026-02-20 08:07:14', '2026-02-20 08:07:14'),
(732, 'users?search=user&page=1&pageSize=20&paginate=true', NULL, 'Consultation users?search=user&page=1&pageSize=20&paginate=true ✅', 'Consultation users?search=user&page=1&pageSize=20&paginate=true effectuée avec succès.', 'réussi', '2026-02-20 08:07:14', NULL, '2026-02-20 08:07:14', '2026-02-20 08:07:14'),
(733, 'users?search=user_3aunk&page=1&pageSize=20&paginate=true', NULL, 'Consultation users?search=user_3aunk&page=1&pageSize=20&paginate=true ✅', 'Consultation users?search=user_3aunk&page=1&pageSize=20&paginate=true effectuée avec succès.', 'réussi', '2026-02-20 08:07:15', NULL, '2026-02-20 08:07:15', '2026-02-20 08:07:15'),
(734, 'Transfert', 10, NULL, 'Transfert avec frais', 'réussi', '2026-02-20 08:07:27', NULL, '2026-02-20 08:07:27', '2026-02-20 08:07:27'),
(735, 'transfert', NULL, 'Création transfert ✅', 'Création transfert effectuée avec succès.', 'réussi', '2026-02-20 08:07:27', NULL, '2026-02-20 08:07:27', '2026-02-20 08:07:27'),
(736, '1', NULL, 'Consultation 1 ✅', 'Consultation 1 effectuée avec succès.', 'réussi', '2026-02-20 08:07:36', NULL, '2026-02-20 08:07:36', '2026-02-20 08:07:36'),
(737, 'notification_track?userId=1&search=&page=1&pageSize=20', NULL, 'Consultation notification_track?userId=1&search=&page=1&pageSize=20 ✅', 'Consultation notification_track?userId=1&search=&page=1&pageSize=20 effectuée avec succès.', 'réussi', '2026-02-20 08:07:40', NULL, '2026-02-20 08:07:40', '2026-02-20 08:07:40'),
(738, '1', NULL, 'Consultation 1 ❌', 'Échec lors de consultation 1.', 'réussi', '2026-02-20 08:07:53', NULL, '2026-02-20 08:07:53', '2026-02-20 08:07:53'),
(739, '6', NULL, 'Consultation 6 ✅', 'Consultation 6 effectuée avec succès.', 'réussi', '2026-02-20 08:07:57', NULL, '2026-02-20 08:07:57', '2026-02-20 08:07:57'),
(740, '6', NULL, 'Consultation 6 ❌', 'Échec lors de consultation 6.', 'réussi', '2026-02-20 08:08:31', NULL, '2026-02-20 08:08:31', '2026-02-20 08:08:31'),
(741, 'tsx?id=6&page=1&pageSize=10&paginate=true', NULL, 'Consultation tsx?id=6&page=1&pageSize=10&paginate=true ✅', 'Consultation tsx?id=6&page=1&pageSize=10&paginate=true effectuée avec succès.', 'réussi', '2026-02-20 08:09:16', NULL, '2026-02-20 08:09:16', '2026-02-20 08:09:16'),
(742, 'Transfert', 10, NULL, 'Transfert avec frais', 'réussi', '2026-02-20 08:09:26', NULL, '2026-02-20 08:09:26', '2026-02-20 08:09:26'),
(743, 'transfert', NULL, 'Création transfert ✅', 'Création transfert effectuée avec succès.', 'réussi', '2026-02-20 08:09:26', NULL, '2026-02-20 08:09:26', '2026-02-20 08:09:26'),
(744, '1', NULL, 'Consultation 1 ✅', 'Consultation 1 effectuée avec succès.', 'réussi', '2026-02-20 08:09:31', NULL, '2026-02-20 08:09:31', '2026-02-20 08:09:31'),
(745, '6', NULL, 'Consultation 6 ✅', 'Consultation 6 effectuée avec succès.', 'réussi', '2026-02-20 08:09:58', NULL, '2026-02-20 08:09:58', '2026-02-20 08:09:58'),
(746, 'notification_track?userId=1&search=&page=1&pageSize=20', NULL, 'Consultation notification_track?userId=1&search=&page=1&pageSize=20 ✅', 'Consultation notification_track?userId=1&search=&page=1&pageSize=20 effectuée avec succès.', 'réussi', '2026-02-20 08:11:28', NULL, '2026-02-20 08:11:28', '2026-02-20 08:11:28'),
(747, 'sector?page=1&pageSize=10&search=&paginate=true', NULL, 'Consultation sector?page=1&pageSize=10&search=&paginate=true ✅', 'Consultation sector?page=1&pageSize=10&search=&paginate=true effectuée avec succès.', 'réussi', '2026-02-20 08:11:51', NULL, '2026-02-20 08:11:51', '2026-02-20 08:11:51'),
(748, 'sector?page=2&pageSize=10&search=&paginate=true', NULL, 'Consultation sector?page=2&pageSize=10&search=&paginate=true ✅', 'Consultation sector?page=2&pageSize=10&search=&paginate=true effectuée avec succès.', 'réussi', '2026-02-20 08:11:59', NULL, '2026-02-20 08:11:59', '2026-02-20 08:11:59'),
(749, 'product?page=1&pageSize=10&search=&paginate=true&companyId=8', NULL, 'Consultation product?page=1&pageSize=10&search=&paginate=true&companyId=8 ✅', 'Consultation product?page=1&pageSize=10&search=&paginate=true&companyId=8 effectuée avec succès.', 'réussi', '2026-02-20 08:13:21', NULL, '2026-02-20 08:13:21', '2026-02-20 08:13:21'),
(750, 'Paiement', 100, NULL, 'Paiement commande ORD-1771575237091', 'réussi', '2026-02-20 08:13:57', NULL, '2026-02-20 08:13:57', '2026-02-20 08:13:57'),
(751, 'Paiement', 100, NULL, 'Réception paiement commande ORD-1771575237091', 'réussi', '2026-02-20 08:13:57', NULL, '2026-02-20 08:13:57', '2026-02-20 08:13:57'),
(752, 'paiement', NULL, 'Création paiement ✅', 'Création paiement effectuée avec succès.', 'réussi', '2026-02-20 08:14:00', NULL, '2026-02-20 08:14:00', '2026-02-20 08:14:00'),
(753, '1', NULL, 'Consultation 1 ✅', 'Consultation 1 effectuée avec succès.', 'réussi', '2026-02-20 08:14:05', NULL, '2026-02-20 08:14:05', '2026-02-20 08:14:05'),
(754, 'sector?page=1&pageSize=10&search=&paginate=true', NULL, 'Consultation sector?page=1&pageSize=10&search=&paginate=true ❌', 'Échec lors de consultation sector?page=1&pagesize=10&search=&paginate=true.', 'réussi', '2026-02-20 08:14:56', NULL, '2026-02-20 08:14:56', '2026-02-20 08:14:56'),
(755, 'tsx?id=1&page=1&pageSize=10&paginate=true', NULL, 'Consultation tsx?id=1&page=1&pageSize=10&paginate=true ✅', 'Consultation tsx?id=1&page=1&pageSize=10&paginate=true effectuée avec succès.', 'réussi', '2026-02-20 08:14:59', NULL, '2026-02-20 08:14:59', '2026-02-20 08:14:59'),
(756, 'notification_track?userId=1&search=&page=1&pageSize=20', NULL, 'Consultation notification_track?userId=1&search=&page=1&pageSize=20 ✅', 'Consultation notification_track?userId=1&search=&page=1&pageSize=20 effectuée avec succès.', 'réussi', '2026-02-20 08:15:12', NULL, '2026-02-20 08:15:12', '2026-02-20 08:15:12'),
(757, 'product?page=1&pageSize=10&search=&paginate=true&companyId=11', NULL, 'Consultation product?page=1&pageSize=10&search=&paginate=true&companyId=11 ✅', 'Consultation product?page=1&pageSize=10&search=&paginate=true&companyId=11 effectuée avec succès.', 'réussi', '2026-02-20 08:17:16', NULL, '2026-02-20 08:17:16', '2026-02-20 08:17:16'),
(758, 'product?page=1&pageSize=10&search=&paginate=true&companyId=13', NULL, 'Consultation product?page=1&pageSize=10&search=&paginate=true&companyId=13 ✅', 'Consultation product?page=1&pageSize=10&search=&paginate=true&companyId=13 effectuée avec succès.', 'réussi', '2026-02-20 08:17:46', NULL, '2026-02-20 08:17:46', '2026-02-20 08:17:46'),
(759, 'product?page=1&pageSize=10&search=&paginate=true&companyId=9', NULL, 'Consultation product?page=1&pageSize=10&search=&paginate=true&companyId=9 ✅', 'Consultation product?page=1&pageSize=10&search=&paginate=true&companyId=9 effectuée avec succès.', 'réussi', '2026-02-20 08:18:36', NULL, '2026-02-20 08:18:36', '2026-02-20 08:18:36'),
(760, 'tsx?page=1&pageSize=1000&paginate=true', NULL, 'Consultation tsx?page=1&pageSize=1000&paginate=true ✅', 'Consultation tsx?page=1&pageSize=1000&paginate=true effectuée avec succès.', 'réussi', '2026-02-20 08:18:59', NULL, '2026-02-20 08:18:59', '2026-02-20 08:18:59'),
(761, 'tsx?page=1&pageSize=1000&paginate=true', NULL, 'Consultation tsx?page=1&pageSize=1000&paginate=true ❌', 'Échec lors de consultation tsx?page=1&pagesize=1000&paginate=true.', 'réussi', '2026-02-20 08:19:01', NULL, '2026-02-20 08:19:01', '2026-02-20 08:19:01'),
(762, 'notification_track?userId=1&search=&page=1&pageSize=20', NULL, 'Consultation notification_track?userId=1&search=&page=1&pageSize=20 ❌', 'Échec lors de consultation notification_track?userid=1&search=&page=1&pagesize=20.', 'réussi', '2026-02-20 08:19:25', NULL, '2026-02-20 08:19:25', '2026-02-20 08:19:25'),
(763, 'notification_track?userId=1&search=&page=1&pageSize=20', NULL, 'Consultation notification_track?userId=1&search=&page=1&pageSize=20 ❌', 'Échec lors de consultation notification_track?userid=1&search=&page=1&pagesize=20.', 'réussi', '2026-02-20 08:22:09', NULL, '2026-02-20 08:22:09', '2026-02-20 08:22:09'),
(764, 'connexion', NULL, 'Échec de la connexion ❌', 'Une tentative de connexion a été détectée, mais elle a échoué.', 'réussi', '2026-02-20 17:57:33', NULL, '2026-02-20 17:57:33', '2026-02-20 17:57:33'),
(765, 'create', NULL, 'Création create ✅', 'Création create effectuée avec succès.', 'réussi', '2026-02-20 17:57:33', NULL, '2026-02-20 17:57:33', '2026-02-20 17:57:33'),
(766, 'create', NULL, 'Création create ✅', 'Création create effectuée avec succès.', 'réussi', '2026-02-20 17:57:33', NULL, '2026-02-20 17:57:33', '2026-02-20 17:57:33'),
(767, 'sector?page=1&pageSize=20&search=&paginate=false', NULL, 'Consultation sector?page=1&pageSize=20&search=&paginate=false ✅', 'Consultation sector?page=1&pageSize=20&search=&paginate=false effectuée avec succès.', 'réussi', '2026-02-20 18:01:19', NULL, '2026-02-20 18:01:19', '2026-02-20 18:01:19'),
(768, '1', NULL, 'Consultation 1 ✅', 'Consultation 1 effectuée avec succès.', 'réussi', '2026-02-20 18:01:19', NULL, '2026-02-20 18:01:19', '2026-02-20 18:01:19'),
(769, 'sector?page=1&pageSize=10&search=&paginate=true', NULL, 'Consultation sector?page=1&pageSize=10&search=&paginate=true ❌', 'Échec lors de consultation sector?page=1&pagesize=10&search=&paginate=true.', 'réussi', '2026-02-20 18:01:48', NULL, '2026-02-20 18:01:48', '2026-02-20 18:01:48'),
(770, 'sector?page=2&pageSize=10&search=&paginate=true', NULL, 'Consultation sector?page=2&pageSize=10&search=&paginate=true ✅', 'Consultation sector?page=2&pageSize=10&search=&paginate=true effectuée avec succès.', 'réussi', '2026-02-20 18:01:50', NULL, '2026-02-20 18:01:50', '2026-02-20 18:01:50'),
(771, 'tsx?id=1&page=1&pageSize=10&paginate=true', NULL, 'Consultation tsx?id=1&page=1&pageSize=10&paginate=true ❌', 'Échec lors de consultation tsx?id=1&page=1&pagesize=10&paginate=true.', 'réussi', '2026-02-20 18:01:53', NULL, '2026-02-20 18:01:53', '2026-02-20 18:01:53'),
(772, 'tsx?page=1&pageSize=1000&paginate=true', NULL, 'Consultation tsx?page=1&pageSize=1000&paginate=true ❌', 'Échec lors de consultation tsx?page=1&pagesize=1000&paginate=true.', 'réussi', '2026-02-20 18:01:59', NULL, '2026-02-20 18:01:59', '2026-02-20 18:01:59'),
(773, 'sector?page=1&pageSize=20&search=&paginate=false', NULL, 'Consultation sector?page=1&pageSize=20&search=&paginate=false ✅', 'Consultation sector?page=1&pageSize=20&search=&paginate=false effectuée avec succès.', 'réussi', '2026-02-20 18:14:56', NULL, '2026-02-20 18:14:56', '2026-02-20 18:14:56'),
(774, '6', NULL, 'Consultation 6 ✅', 'Consultation 6 effectuée avec succès.', 'réussi', '2026-02-20 18:14:57', NULL, '2026-02-20 18:14:57', '2026-02-20 18:14:57'),
(775, 'notification_track?userId=6&search=&page=1&pageSize=20', NULL, 'Consultation notification_track?userId=6&search=&page=1&pageSize=20 ✅', 'Consultation notification_track?userId=6&search=&page=1&pageSize=20 effectuée avec succès.', 'réussi', '2026-02-20 18:16:22', NULL, '2026-02-20 18:16:22', '2026-02-20 18:16:22'),
(776, 'tsx?id=6&page=1&pageSize=10&paginate=true', NULL, 'Consultation tsx?id=6&page=1&pageSize=10&paginate=true ✅', 'Consultation tsx?id=6&page=1&pageSize=10&paginate=true effectuée avec succès.', 'réussi', '2026-02-20 18:16:31', NULL, '2026-02-20 18:16:31', '2026-02-20 18:16:31'),
(777, 'sector?page=1&pageSize=10&search=&paginate=true', NULL, 'Consultation sector?page=1&pageSize=10&search=&paginate=true ✅', 'Consultation sector?page=1&pageSize=10&search=&paginate=true effectuée avec succès.', 'réussi', '2026-02-20 18:16:41', NULL, '2026-02-20 18:16:41', '2026-02-20 18:16:41'),
(778, 'tsx?page=1&pageSize=1000&paginate=true', NULL, 'Consultation tsx?page=1&pageSize=1000&paginate=true ✅', 'Consultation tsx?page=1&pageSize=1000&paginate=true effectuée avec succès.', 'réussi', '2026-02-20 18:16:44', NULL, '2026-02-20 18:16:44', '2026-02-20 18:16:44'),
(779, 'connexion', NULL, 'Échec de la connexion ❌', 'Une tentative de connexion a été détectée, mais elle a échoué.', 'réussi', '2026-02-20 18:22:25', NULL, '2026-02-20 18:22:25', '2026-02-20 18:22:25'),
(780, 'create', NULL, 'Création create ✅', 'Création create effectuée avec succès.', 'réussi', '2026-02-20 18:22:25', NULL, '2026-02-20 18:22:25', '2026-02-20 18:22:25'),
(781, 'create', NULL, 'Création create ✅', 'Création create effectuée avec succès.', 'réussi', '2026-02-20 18:22:25', NULL, '2026-02-20 18:22:25', '2026-02-20 18:22:25'),
(782, 'sector?page=1&pageSize=20&search=&paginate=false', NULL, 'Consultation sector?page=1&pageSize=20&search=&paginate=false ❌', 'Échec lors de consultation sector?page=1&pagesize=20&search=&paginate=false.', 'réussi', '2026-02-20 18:26:00', NULL, '2026-02-20 18:26:00', '2026-02-20 18:26:00'),
(783, '7', NULL, 'Consultation 7 ✅', 'Consultation 7 effectuée avec succès.', 'réussi', '2026-02-20 18:26:00', NULL, '2026-02-20 18:26:00', '2026-02-20 18:26:00'),
(784, 'notification_track?userId=7&search=&page=1&pageSize=20', NULL, 'Consultation notification_track?userId=7&search=&page=1&pageSize=20 ✅', 'Consultation notification_track?userId=7&search=&page=1&pageSize=20 effectuée avec succès.', 'réussi', '2026-02-20 18:26:47', NULL, '2026-02-20 18:26:47', '2026-02-20 18:26:47'),
(785, 'profile', NULL, 'Mise à jour profile ✅', 'Mise à jour profile effectuée avec succès.', 'réussi', '2026-02-20 18:27:31', NULL, '2026-02-20 18:27:31', '2026-02-20 18:27:31'),
(786, '7', NULL, 'Consultation 7 ✅', 'Consultation 7 effectuée avec succès.', 'réussi', '2026-02-20 18:27:31', NULL, '2026-02-20 18:27:31', '2026-02-20 18:27:31'),
(787, 'profile', NULL, 'Mise à jour profile ✅', 'Mise à jour profile effectuée avec succès.', 'réussi', '2026-02-20 18:27:47', NULL, '2026-02-20 18:27:47', '2026-02-20 18:27:47'),
(788, '7', NULL, 'Consultation 7 ✅', 'Consultation 7 effectuée avec succès.', 'réussi', '2026-02-20 18:27:47', NULL, '2026-02-20 18:27:47', '2026-02-20 18:27:47'),
(789, 'MODIFICATION_PROFIL', NULL, 'Profil modifié ✅', 'Profil mis à jour.', 'réussi', '2026-02-20 18:27:47', NULL, '2026-02-20 18:27:47', '2026-02-20 18:27:47'),
(790, 'create', NULL, 'Création create ✅', 'Création create effectuée avec succès.', 'réussi', '2026-02-20 18:27:47', NULL, '2026-02-20 18:27:47', '2026-02-20 18:27:47'),
(791, 'create', NULL, 'Création create ✅', 'Création create effectuée avec succès.', 'réussi', '2026-02-20 18:27:48', NULL, '2026-02-20 18:27:48', '2026-02-20 18:27:48'),
(792, 'notification_track?userId=7&search=&page=1&pageSize=20', NULL, 'Consultation notification_track?userId=7&search=&page=1&pageSize=20 ✅', 'Consultation notification_track?userId=7&search=&page=1&pageSize=20 effectuée avec succès.', 'réussi', '2026-02-20 18:27:53', NULL, '2026-02-20 18:27:53', '2026-02-20 18:27:53'),
(793, 'sector?page=1&pageSize=10&search=&paginate=true', NULL, 'Consultation sector?page=1&pageSize=10&search=&paginate=true ❌', 'Échec lors de consultation sector?page=1&pagesize=10&search=&paginate=true.', 'réussi', '2026-02-20 18:28:12', NULL, '2026-02-20 18:28:12', '2026-02-20 18:28:12'),
(794, 'sector?page=2&pageSize=10&search=&paginate=true', NULL, 'Consultation sector?page=2&pageSize=10&search=&paginate=true ✅', 'Consultation sector?page=2&pageSize=10&search=&paginate=true effectuée avec succès.', 'réussi', '2026-02-20 18:28:15', NULL, '2026-02-20 18:28:15', '2026-02-20 18:28:15'),
(795, 'tsx?id=7&page=1&pageSize=10&paginate=true', NULL, 'Consultation tsx?id=7&page=1&pageSize=10&paginate=true ✅', 'Consultation tsx?id=7&page=1&pageSize=10&paginate=true effectuée avec succès.', 'réussi', '2026-02-20 18:28:31', NULL, '2026-02-20 18:28:31', '2026-02-20 18:28:31'),
(796, 'tsx?page=1&pageSize=1000&paginate=true', NULL, 'Consultation tsx?page=1&pageSize=1000&paginate=true ❌', 'Échec lors de consultation tsx?page=1&pagesize=1000&paginate=true.', 'réussi', '2026-02-20 18:28:37', NULL, '2026-02-20 18:28:37', '2026-02-20 18:28:37'),
(797, 'notification_track?userId=7&search=&page=1&pageSize=20', NULL, 'Consultation notification_track?userId=7&search=&page=1&pageSize=20 ❌', 'Échec lors de consultation notification_track?userid=7&search=&page=1&pagesize=20.', 'réussi', '2026-02-20 18:30:27', NULL, '2026-02-20 18:30:27', '2026-02-20 18:30:27'),
(798, 'sector?page=1&pageSize=20&search=&paginate=false', NULL, 'Consultation sector?page=1&pageSize=20&search=&paginate=false ✅', 'Consultation sector?page=1&pageSize=20&search=&paginate=false effectuée avec succès.', 'réussi', '2026-02-20 18:36:24', NULL, '2026-02-20 18:36:24', '2026-02-20 18:36:24'),
(799, '1', NULL, 'Consultation 1 ✅', 'Consultation 1 effectuée avec succès.', 'réussi', '2026-02-20 18:36:24', NULL, '2026-02-20 18:36:24', '2026-02-20 18:36:24'),
(800, 'sector?page=1&pageSize=10&search=&paginate=true', NULL, 'Consultation sector?page=1&pageSize=10&search=&paginate=true ❌', 'Échec lors de consultation sector?page=1&pagesize=10&search=&paginate=true.', 'réussi', '2026-02-20 18:37:04', NULL, '2026-02-20 18:37:04', '2026-02-20 18:37:04'),
(801, 'sector?page=2&pageSize=10&search=&paginate=true', NULL, 'Consultation sector?page=2&pageSize=10&search=&paginate=true ❌', 'Échec lors de consultation sector?page=2&pagesize=10&search=&paginate=true.', 'réussi', '2026-02-20 18:37:06', NULL, '2026-02-20 18:37:06', '2026-02-20 18:37:06'),
(802, 'tsx?id=1&page=1&pageSize=10&paginate=true', NULL, 'Consultation tsx?id=1&page=1&pageSize=10&paginate=true ❌', 'Échec lors de consultation tsx?id=1&page=1&pagesize=10&paginate=true.', 'réussi', '2026-02-20 18:37:13', NULL, '2026-02-20 18:37:13', '2026-02-20 18:37:13'),
(803, 'tsx?page=1&pageSize=1000&paginate=true', NULL, 'Consultation tsx?page=1&pageSize=1000&paginate=true ❌', 'Échec lors de consultation tsx?page=1&pagesize=1000&paginate=true.', 'réussi', '2026-02-20 18:37:17', NULL, '2026-02-20 18:37:17', '2026-02-20 18:37:17'),
(804, 'product?page=1&pageSize=10&search=&paginate=true&companyId=8', NULL, 'Consultation product?page=1&pageSize=10&search=&paginate=true&companyId=8 ✅', 'Consultation product?page=1&pageSize=10&search=&paginate=true&companyId=8 effectuée avec succès.', 'réussi', '2026-02-20 18:39:21', NULL, '2026-02-20 18:39:21', '2026-02-20 18:39:21'),
(805, 'product?page=1&pageSize=10&search=&paginate=true&companyId=11', NULL, 'Consultation product?page=1&pageSize=10&search=&paginate=true&companyId=11 ✅', 'Consultation product?page=1&pageSize=10&search=&paginate=true&companyId=11 effectuée avec succès.', 'réussi', '2026-02-20 18:39:29', NULL, '2026-02-20 18:39:29', '2026-02-20 18:39:29'),
(806, 'product?page=1&pageSize=10&search=&paginate=true&companyId=13', NULL, 'Consultation product?page=1&pageSize=10&search=&paginate=true&companyId=13 ✅', 'Consultation product?page=1&pageSize=10&search=&paginate=true&companyId=13 effectuée avec succès.', 'réussi', '2026-02-20 18:39:33', NULL, '2026-02-20 18:39:33', '2026-02-20 18:39:33'),
(807, 'users?search=&page=1&pageSize=20&paginate=true', NULL, 'Consultation users?search=&page=1&pageSize=20&paginate=true ✅', 'Consultation users?search=&page=1&pageSize=20&paginate=true effectuée avec succès.', 'réussi', '2026-02-20 18:39:48', NULL, '2026-02-20 18:39:48', '2026-02-20 18:39:48'),
(808, 'notification_track?userId=1&search=&page=1&pageSize=20', NULL, 'Consultation notification_track?userId=1&search=&page=1&pageSize=20 ✅', 'Consultation notification_track?userId=1&search=&page=1&pageSize=20 effectuée avec succès.', 'réussi', '2026-02-20 18:42:06', NULL, '2026-02-20 18:42:06', '2026-02-20 18:42:06'),
(809, 'notification_track?userId=1&search=&page=1&pageSize=20', NULL, 'Consultation notification_track?userId=1&search=&page=1&pageSize=20 ❌', 'Échec lors de consultation notification_track?userid=1&search=&page=1&pagesize=20.', 'réussi', '2026-02-20 18:46:34', NULL, '2026-02-20 18:46:34', '2026-02-20 18:46:34'),
(810, 'users?search=&page=1&pageSize=20&paginate=true', NULL, 'Consultation users?search=&page=1&pageSize=20&paginate=true ❌', 'Échec lors de consultation users?search=&page=1&pagesize=20&paginate=true.', 'réussi', '2026-02-20 18:46:43', NULL, '2026-02-20 18:46:43', '2026-02-20 18:46:43'),
(811, 'sector?page=1&pageSize=20&search=&paginate=false', NULL, 'Consultation sector?page=1&pageSize=20&search=&paginate=false ❌', 'Échec lors de consultation sector?page=1&pagesize=20&search=&paginate=false.', 'réussi', '2026-02-20 20:27:31', NULL, '2026-02-20 20:27:31', '2026-02-20 20:27:31'),
(812, '6', NULL, 'Consultation 6 ✅', 'Consultation 6 effectuée avec succès.', 'réussi', '2026-02-20 20:27:31', NULL, '2026-02-20 20:27:31', '2026-02-20 20:27:31'),
(813, 'createrecharge', NULL, 'Création createrecharge ❌', 'Échec lors de création createrecharge.', 'réussi', '2026-02-20 20:28:34', NULL, '2026-02-20 20:28:34', '2026-02-20 20:28:34'),
(814, 'createrecharge', NULL, 'Création createrecharge ❌', 'Échec lors de création createrecharge.', 'réussi', '2026-02-20 20:35:57', NULL, '2026-02-20 20:35:57', '2026-02-20 20:35:57'),
(815, 'createrecharge', NULL, 'Création createrecharge ❌', 'Échec lors de création createrecharge.', 'réussi', '2026-02-20 20:37:08', NULL, '2026-02-20 20:37:08', '2026-02-20 20:37:08'),
(816, 'createrecharge', NULL, 'Création createrecharge ❌', 'Échec lors de création createrecharge.', 'réussi', '2026-02-20 20:37:45', NULL, '2026-02-20 20:37:45', '2026-02-20 20:37:45'),
(817, 'createrecharge', NULL, 'Création createrecharge ❌', 'Échec lors de création createrecharge.', 'réussi', '2026-02-20 20:37:52', NULL, '2026-02-20 20:37:52', '2026-02-20 20:37:52'),
(818, 'createrecharge', NULL, 'Création createrecharge ❌', 'Échec lors de création createrecharge.', 'réussi', '2026-02-20 20:37:56', NULL, '2026-02-20 20:37:56', '2026-02-20 20:37:56'),
(819, 'createrecharge', NULL, 'Création createrecharge ❌', 'Échec lors de création createrecharge.', 'réussi', '2026-02-20 20:38:32', NULL, '2026-02-20 20:38:32', '2026-02-20 20:38:32'),
(820, 'createrecharge', NULL, 'Création createrecharge ❌', 'Échec lors de création createrecharge.', 'réussi', '2026-02-20 20:39:16', NULL, '2026-02-20 20:39:16', '2026-02-20 20:39:16'),
(821, '6', NULL, 'Consultation 6 ❌', 'Échec lors de consultation 6.', 'réussi', '2026-02-20 20:39:22', NULL, '2026-02-20 20:39:22', '2026-02-20 20:39:22'),
(822, 'createrecharge', NULL, 'Création createrecharge ✅', 'Création createrecharge effectuée avec succès.', 'réussi', '2026-02-20 20:39:58', NULL, '2026-02-20 20:39:58', '2026-02-20 20:39:58'),
(823, 'recharge', NULL, 'Création recharge ❌', 'Échec lors de création recharge.', 'réussi', '2026-02-20 20:39:58', NULL, '2026-02-20 20:39:58', '2026-02-20 20:39:58'),
(824, 'createrecharge', NULL, 'Création createrecharge ❌', 'Échec lors de création createrecharge.', 'réussi', '2026-02-20 20:48:25', NULL, '2026-02-20 20:48:25', '2026-02-20 20:48:25'),
(825, 'createrecharge', NULL, 'Création createrecharge ❌', 'Échec lors de création createrecharge.', 'réussi', '2026-02-20 20:48:33', NULL, '2026-02-20 20:48:33', '2026-02-20 20:48:33'),
(826, '1', NULL, 'Consultation 1 ✅', 'Consultation 1 effectuée avec succès.', 'réussi', '2026-02-20 20:49:16', NULL, '2026-02-20 20:49:16', '2026-02-20 20:49:16'),
(827, 'createrecharge', NULL, 'Création createrecharge ❌', 'Échec lors de création createrecharge.', 'réussi', '2026-02-20 20:50:03', NULL, '2026-02-20 20:50:03', '2026-02-20 20:50:03'),
(828, 'createrecharge', NULL, 'Création createrecharge ✅', 'Création createrecharge effectuée avec succès.', 'réussi', '2026-02-20 20:54:13', NULL, '2026-02-20 20:54:13', '2026-02-20 20:54:13'),
(829, 'recharge', NULL, 'Création recharge ✅', 'Création recharge effectuée avec succès.', 'réussi', '2026-02-20 20:54:13', NULL, '2026-02-20 20:54:13', '2026-02-20 20:54:13'),
(830, '1', NULL, 'Consultation 1 ✅', 'Consultation 1 effectuée avec succès.', 'réussi', '2026-02-20 20:54:22', NULL, '2026-02-20 20:54:22', '2026-02-20 20:54:22'),
(831, '1', NULL, 'Consultation 1 ❌', 'Échec lors de consultation 1.', 'réussi', '2026-02-20 20:54:24', NULL, '2026-02-20 20:54:24', '2026-02-20 20:54:24'),
(832, '1', NULL, 'Consultation 1 ❌', 'Échec lors de consultation 1.', 'réussi', '2026-02-20 20:54:44', NULL, '2026-02-20 20:54:44', '2026-02-20 20:54:44'),
(833, '1', NULL, 'Consultation 1 ❌', 'Échec lors de consultation 1.', 'réussi', '2026-02-20 20:55:45', NULL, '2026-02-20 20:55:45', '2026-02-20 20:55:45'),
(834, '1', NULL, 'Consultation 1 ❌', 'Échec lors de consultation 1.', 'réussi', '2026-02-20 20:55:46', NULL, '2026-02-20 20:55:46', '2026-02-20 20:55:46'),
(835, '1', NULL, 'Consultation 1 ❌', 'Échec lors de consultation 1.', 'réussi', '2026-02-20 20:57:23', NULL, '2026-02-20 20:57:23', '2026-02-20 20:57:23'),
(836, 'notification_track?userId=1&search=&page=1&pageSize=20', NULL, 'Consultation notification_track?userId=1&search=&page=1&pageSize=20 ✅', 'Consultation notification_track?userId=1&search=&page=1&pageSize=20 effectuée avec succès.', 'réussi', '2026-02-20 20:57:32', NULL, '2026-02-20 20:57:32', '2026-02-20 20:57:32'),
(837, 'tsx?id=1&page=1&pageSize=10&paginate=true', NULL, 'Consultation tsx?id=1&page=1&pageSize=10&paginate=true ❌', 'Échec lors de consultation tsx?id=1&page=1&pagesize=10&paginate=true.', 'réussi', '2026-02-20 21:00:41', NULL, '2026-02-20 21:00:41', '2026-02-20 21:00:41'),
(838, 'transfert', NULL, 'Création transfert ❌', 'Échec lors de création transfert.', 'réussi', '2026-02-20 21:00:57', NULL, '2026-02-20 21:00:57', '2026-02-20 21:00:57'),
(839, 'tsx?id=6&page=1&pageSize=10&paginate=true', NULL, 'Consultation tsx?id=6&page=1&pageSize=10&paginate=true ❌', 'Échec lors de consultation tsx?id=6&page=1&pagesize=10&paginate=true.', 'réussi', '2026-02-20 21:01:21', NULL, '2026-02-20 21:01:21', '2026-02-20 21:01:21'),
(840, 'sector?page=1&pageSize=10&search=&paginate=true', NULL, 'Consultation sector?page=1&pageSize=10&search=&paginate=true ❌', 'Échec lors de consultation sector?page=1&pagesize=10&search=&paginate=true.', 'réussi', '2026-02-20 21:01:27', NULL, '2026-02-20 21:01:27', '2026-02-20 21:01:27'),
(841, 'Transfert', 10, NULL, 'Transfert avec frais', 'réussi', '2026-02-20 21:01:36', NULL, '2026-02-20 21:01:36', '2026-02-20 21:01:36'),
(842, 'transfert', NULL, 'Création transfert ✅', 'Création transfert effectuée avec succès.', 'réussi', '2026-02-20 21:01:36', NULL, '2026-02-20 21:01:36', '2026-02-20 21:01:36'),
(843, '1', NULL, 'Consultation 1 ✅', 'Consultation 1 effectuée avec succès.', 'réussi', '2026-02-20 21:01:41', NULL, '2026-02-20 21:01:41', '2026-02-20 21:01:41'),
(844, '6', NULL, 'Consultation 6 ✅', 'Consultation 6 effectuée avec succès.', 'réussi', '2026-02-20 21:01:44', NULL, '2026-02-20 21:01:44', '2026-02-20 21:01:44'),
(845, 'notification_track?userId=6&search=&page=1&pageSize=20', NULL, 'Consultation notification_track?userId=6&search=&page=1&pageSize=20 ✅', 'Consultation notification_track?userId=6&search=&page=1&pageSize=20 effectuée avec succès.', 'réussi', '2026-02-20 21:01:48', NULL, '2026-02-20 21:01:48', '2026-02-20 21:01:48'),
(846, 'notification_track?userId=1&search=&page=1&pageSize=20', NULL, 'Consultation notification_track?userId=1&search=&page=1&pageSize=20 ✅', 'Consultation notification_track?userId=1&search=&page=1&pageSize=20 effectuée avec succès.', 'réussi', '2026-02-20 21:01:58', NULL, '2026-02-20 21:01:58', '2026-02-20 21:01:58'),
(847, 'transfert', NULL, 'Création transfert ❌', 'Échec lors de création transfert.', 'réussi', '2026-02-20 21:03:59', NULL, '2026-02-20 21:03:59', '2026-02-20 21:03:59'),
(848, 'createrecharge', NULL, 'Création createrecharge ❌', 'Échec lors de création createrecharge.', 'réussi', '2026-02-20 21:04:41', NULL, '2026-02-20 21:04:41', '2026-02-20 21:04:41'),
(849, 'createrecharge', NULL, 'Création createrecharge ❌', 'Échec lors de création createrecharge.', 'réussi', '2026-02-20 21:05:25', NULL, '2026-02-20 21:05:25', '2026-02-20 21:05:25'),
(850, 'createrecharge', NULL, 'Création createrecharge ❌', 'Échec lors de création createrecharge.', 'réussi', '2026-02-20 21:06:11', NULL, '2026-02-20 21:06:11', '2026-02-20 21:06:11'),
(851, 'createrecharge', NULL, 'Création createrecharge ❌', 'Échec lors de création createrecharge.', 'réussi', '2026-02-20 21:06:54', NULL, '2026-02-20 21:06:54', '2026-02-20 21:06:54'),
(852, 'createrecharge', NULL, 'Création createrecharge ❌', 'Échec lors de création createrecharge.', 'réussi', '2026-02-20 21:07:19', NULL, '2026-02-20 21:07:19', '2026-02-20 21:07:19'),
(853, 'createrecharge', NULL, 'Création createrecharge ❌', 'Échec lors de création createrecharge.', 'réussi', '2026-02-20 21:09:04', NULL, '2026-02-20 21:09:04', '2026-02-20 21:09:04'),
(854, 'createrecharge', NULL, 'Création createrecharge ❌', 'Échec lors de création createrecharge.', 'réussi', '2026-02-20 21:10:58', NULL, '2026-02-20 21:10:58', '2026-02-20 21:10:58'),
(855, 'createrecharge', NULL, 'Création createrecharge ✅', 'Création createrecharge effectuée avec succès.', 'réussi', '2026-02-20 21:11:35', NULL, '2026-02-20 21:11:35', '2026-02-20 21:11:35'),
(856, 'recharge', NULL, 'Création recharge ✅', 'Création recharge effectuée avec succès.', 'réussi', '2026-02-20 21:11:35', NULL, '2026-02-20 21:11:35', '2026-02-20 21:11:35'),
(857, '1', NULL, 'Consultation 1 ✅', 'Consultation 1 effectuée avec succès.', 'réussi', '2026-02-20 21:11:51', NULL, '2026-02-20 21:11:51', '2026-02-20 21:11:51'),
(858, '1', NULL, 'Consultation 1 ❌', 'Échec lors de consultation 1.', 'réussi', '2026-02-20 21:11:53', NULL, '2026-02-20 21:11:53', '2026-02-20 21:11:53'),
(859, '1', NULL, 'Consultation 1 ❌', 'Échec lors de consultation 1.', 'réussi', '2026-02-20 21:11:54', NULL, '2026-02-20 21:11:54', '2026-02-20 21:11:54'),
(860, '1', NULL, 'Consultation 1 ❌', 'Échec lors de consultation 1.', 'réussi', '2026-02-20 21:11:57', NULL, '2026-02-20 21:11:57', '2026-02-20 21:11:57'),
(861, '1', NULL, 'Consultation 1 ❌', 'Échec lors de consultation 1.', 'réussi', '2026-02-20 21:12:14', NULL, '2026-02-20 21:12:14', '2026-02-20 21:12:14'),
(862, '1', NULL, 'Consultation 1 ❌', 'Échec lors de consultation 1.', 'réussi', '2026-02-20 21:12:15', NULL, '2026-02-20 21:12:15', '2026-02-20 21:12:15'),
(863, '1', NULL, 'Consultation 1 ❌', 'Échec lors de consultation 1.', 'réussi', '2026-02-20 21:12:16', NULL, '2026-02-20 21:12:16', '2026-02-20 21:12:16'),
(864, '1', NULL, 'Consultation 1 ❌', 'Échec lors de consultation 1.', 'réussi', '2026-02-20 21:13:57', NULL, '2026-02-20 21:13:57', '2026-02-20 21:13:57'),
(865, '1', NULL, 'Consultation 1 ❌', 'Échec lors de consultation 1.', 'réussi', '2026-02-20 21:14:01', NULL, '2026-02-20 21:14:01', '2026-02-20 21:14:01'),
(866, 'tsx?page=1&pageSize=1000&paginate=true', NULL, 'Consultation tsx?page=1&pageSize=1000&paginate=true ❌', 'Échec lors de consultation tsx?page=1&pagesize=1000&paginate=true.', 'réussi', '2026-02-20 21:14:05', NULL, '2026-02-20 21:14:05', '2026-02-20 21:14:05'),
(867, 'tsx?id=1&page=1&pageSize=10&paginate=true', NULL, 'Consultation tsx?id=1&page=1&pageSize=10&paginate=true ❌', 'Échec lors de consultation tsx?id=1&page=1&pagesize=10&paginate=true.', 'réussi', '2026-02-20 21:14:23', NULL, '2026-02-20 21:14:23', '2026-02-20 21:14:23'),
(868, 'tsx?page=1&pageSize=1000&paginate=true', NULL, 'Consultation tsx?page=1&pageSize=1000&paginate=true ❌', 'Échec lors de consultation tsx?page=1&pagesize=1000&paginate=true.', 'réussi', '2026-02-20 21:14:42', NULL, '2026-02-20 21:14:42', '2026-02-20 21:14:42');
INSERT INTO `histories` (`historyId`, `type`, `amount`, `action`, `description`, `status`, `date`, `userId`, `createdAt`, `updatedAt`) VALUES
(869, 'notification_track?userId=1&search=&page=1&pageSize=20', NULL, 'Consultation notification_track?userId=1&search=&page=1&pageSize=20 ✅', 'Consultation notification_track?userId=1&search=&page=1&pageSize=20 effectuée avec succès.', 'réussi', '2026-02-20 21:14:47', NULL, '2026-02-20 21:14:47', '2026-02-20 21:14:47'),
(870, '1', NULL, 'Consultation 1 ❌', 'Échec lors de consultation 1.', 'réussi', '2026-02-20 21:25:30', NULL, '2026-02-20 21:25:30', '2026-02-20 21:25:30'),
(871, 'sector?page=1&pageSize=20&search=&paginate=false', NULL, 'Consultation sector?page=1&pageSize=20&search=&paginate=false ✅', 'Consultation sector?page=1&pageSize=20&search=&paginate=false effectuée avec succès.', 'réussi', '2026-02-20 21:25:30', NULL, '2026-02-20 21:25:30', '2026-02-20 21:25:30'),
(872, 'createrecharge', NULL, 'Création createrecharge ❌', 'Échec lors de création createrecharge.', 'réussi', '2026-02-20 21:25:37', NULL, '2026-02-20 21:25:37', '2026-02-20 21:25:37'),
(873, 'createrecharge', NULL, 'Création createrecharge ❌', 'Échec lors de création createrecharge.', 'réussi', '2026-02-20 21:26:33', NULL, '2026-02-20 21:26:33', '2026-02-20 21:26:33'),
(874, 'createrecharge', NULL, 'Création createrecharge ❌', 'Échec lors de création createrecharge.', 'réussi', '2026-02-20 21:26:52', NULL, '2026-02-20 21:26:52', '2026-02-20 21:26:52'),
(875, 'createrecharge', NULL, 'Création createrecharge ❌', 'Échec lors de création createrecharge.', 'réussi', '2026-02-20 21:28:00', NULL, '2026-02-20 21:28:00', '2026-02-20 21:28:00'),
(876, '1', NULL, 'Consultation 1 ✅', 'Consultation 1 effectuée avec succès.', 'réussi', '2026-02-21 06:27:59', NULL, '2026-02-21 06:27:59', '2026-02-21 06:27:59'),
(877, '1', NULL, 'Consultation 1 ✅', 'Consultation 1 effectuée avec succès.', 'réussi', '2026-02-21 06:28:39', NULL, '2026-02-21 06:28:39', '2026-02-21 06:28:39'),
(878, 'createrecharge', NULL, 'Création createrecharge ❌', 'Échec lors de création createrecharge.', 'réussi', '2026-02-21 06:29:00', NULL, '2026-02-21 06:29:00', '2026-02-21 06:29:00'),
(879, 'createrecharge', NULL, 'Création createrecharge ❌', 'Échec lors de création createrecharge.', 'réussi', '2026-02-21 06:29:18', NULL, '2026-02-21 06:29:18', '2026-02-21 06:29:18'),
(880, 'createrecharge', NULL, 'Création createrecharge ❌', 'Échec lors de création createrecharge.', 'réussi', '2026-02-21 06:29:40', NULL, '2026-02-21 06:29:40', '2026-02-21 06:29:40'),
(881, 'createrecharge', NULL, 'Création createrecharge ❌', 'Échec lors de création createrecharge.', 'réussi', '2026-02-21 06:30:32', NULL, '2026-02-21 06:30:32', '2026-02-21 06:30:32'),
(882, 'createrecharge', NULL, 'Création createrecharge ❌', 'Échec lors de création createrecharge.', 'réussi', '2026-02-21 06:35:16', NULL, '2026-02-21 06:35:16', '2026-02-21 06:35:16'),
(883, 'createrecharge', NULL, 'Création createrecharge ❌', 'Échec lors de création createrecharge.', 'réussi', '2026-02-21 06:36:20', NULL, '2026-02-21 06:36:20', '2026-02-21 06:36:20'),
(884, 'createrecharge', NULL, 'Création createrecharge ❌', 'Échec lors de création createrecharge.', 'réussi', '2026-02-21 06:38:35', NULL, '2026-02-21 06:38:35', '2026-02-21 06:38:35'),
(885, 'createrecharge', NULL, 'Création createrecharge ❌', 'Échec lors de création createrecharge.', 'réussi', '2026-02-21 06:41:38', NULL, '2026-02-21 06:41:38', '2026-02-21 06:41:38'),
(886, 'createrecharge', NULL, 'Création createrecharge ❌', 'Échec lors de création createrecharge.', 'réussi', '2026-02-21 06:53:00', NULL, '2026-02-21 06:53:00', '2026-02-21 06:53:00'),
(887, 'sector?page=1&pageSize=20&search=&paginate=false', NULL, 'Consultation sector?page=1&pageSize=20&search=&paginate=false ❌', 'Échec lors de consultation sector?page=1&pagesize=20&search=&paginate=false.', 'réussi', '2026-02-21 06:54:12', NULL, '2026-02-21 06:54:12', '2026-02-21 06:54:12'),
(888, '6', NULL, 'Consultation 6 ✅', 'Consultation 6 effectuée avec succès.', 'réussi', '2026-02-21 06:54:12', NULL, '2026-02-21 06:54:12', '2026-02-21 06:54:12'),
(889, 'createrecharge', NULL, 'Création createrecharge ❌', 'Échec lors de création createrecharge.', 'réussi', '2026-02-21 06:54:59', NULL, '2026-02-21 06:54:59', '2026-02-21 06:54:59'),
(890, 'createrecharge', NULL, 'Création createrecharge ❌', 'Échec lors de création createrecharge.', 'réussi', '2026-02-21 06:56:21', NULL, '2026-02-21 06:56:21', '2026-02-21 06:56:21'),
(891, 'sector?page=1&pageSize=20&search=&paginate=false', NULL, 'Consultation sector?page=1&pageSize=20&search=&paginate=false ✅', 'Consultation sector?page=1&pageSize=20&search=&paginate=false effectuée avec succès.', 'réussi', '2026-02-21 07:14:57', NULL, '2026-02-21 07:14:57', '2026-02-21 07:14:57'),
(892, '1', NULL, 'Consultation 1 ❌', 'Échec lors de consultation 1.', 'réussi', '2026-02-21 07:14:57', NULL, '2026-02-21 07:14:57', '2026-02-21 07:14:57'),
(893, 'createrecharge', NULL, 'Création createrecharge ❌', 'Échec lors de création createrecharge.', 'réussi', '2026-02-21 07:15:56', NULL, '2026-02-21 07:15:56', '2026-02-21 07:15:56'),
(894, 'createrecharge', NULL, 'Création createrecharge ❌', 'Échec lors de création createrecharge.', 'réussi', '2026-02-21 07:16:07', NULL, '2026-02-21 07:16:07', '2026-02-21 07:16:07'),
(895, 'createrecharge', NULL, 'Création createrecharge ❌', 'Échec lors de création createrecharge.', 'réussi', '2026-02-21 07:16:39', NULL, '2026-02-21 07:16:39', '2026-02-21 07:16:39'),
(896, 'createrecharge', NULL, 'Création createrecharge ❌', 'Échec lors de création createrecharge.', 'réussi', '2026-02-21 07:16:48', NULL, '2026-02-21 07:16:48', '2026-02-21 07:16:48'),
(897, '1', NULL, 'Consultation 1 ✅', 'Consultation 1 effectuée avec succès.', 'réussi', '2026-02-21 07:17:05', NULL, '2026-02-21 07:17:05', '2026-02-21 07:17:05'),
(898, 'createrecharge', NULL, 'Création createrecharge ❌', 'Échec lors de création createrecharge.', 'réussi', '2026-02-21 07:17:19', NULL, '2026-02-21 07:17:19', '2026-02-21 07:17:19'),
(899, 'createrecharge', NULL, 'Création createrecharge ❌', 'Échec lors de création createrecharge.', 'réussi', '2026-02-21 07:18:57', NULL, '2026-02-21 07:18:57', '2026-02-21 07:18:57'),
(900, 'create', NULL, 'Création create ❌', 'Échec lors de création create.', 'réussi', '2026-02-21 07:26:06', NULL, '2026-02-21 07:26:06', '2026-02-21 07:26:06'),
(901, 'create', NULL, 'Création create ❌', 'Échec lors de création create.', 'réussi', '2026-02-21 07:26:15', NULL, '2026-02-21 07:26:15', '2026-02-21 07:26:15'),
(902, 'create', NULL, 'Création create ❌', 'Échec lors de création create.', 'réussi', '2026-02-21 07:26:17', NULL, '2026-02-21 07:26:17', '2026-02-21 07:26:17'),
(903, 'recharge', NULL, 'Création recharge ❌', 'Échec lors de création recharge.', 'réussi', '2026-02-21 07:26:46', NULL, '2026-02-21 07:26:46', '2026-02-21 07:26:46'),
(904, 'recharge', NULL, 'Création recharge ✅', 'Création recharge effectuée avec succès.', 'réussi', '2026-02-21 07:26:54', NULL, '2026-02-21 07:26:54', '2026-02-21 07:26:54'),
(905, '1', NULL, 'Consultation 1 ✅', 'Consultation 1 effectuée avec succès.', 'réussi', '2026-02-21 07:27:07', NULL, '2026-02-21 07:27:07', '2026-02-21 07:27:07'),
(906, 'recharge', NULL, 'Création recharge ✅', 'Création recharge effectuée avec succès.', 'réussi', '2026-02-21 07:49:04', NULL, '2026-02-21 07:49:04', '2026-02-21 07:49:04'),
(907, 'recharge', NULL, 'Création recharge ✅', 'Création recharge effectuée avec succès.', 'réussi', '2026-02-21 07:49:11', NULL, '2026-02-21 07:49:11', '2026-02-21 07:49:11'),
(908, 'recharge', NULL, 'Création recharge ✅', 'Création recharge effectuée avec succès.', 'réussi', '2026-02-21 07:49:16', NULL, '2026-02-21 07:49:16', '2026-02-21 07:49:16'),
(909, '1', NULL, 'Consultation 1 ✅', 'Consultation 1 effectuée avec succès.', 'réussi', '2026-02-21 07:49:19', NULL, '2026-02-21 07:49:19', '2026-02-21 07:49:19'),
(910, 'recharge', NULL, 'Création recharge ✅', 'Création recharge effectuée avec succès.', 'réussi', '2026-02-21 07:52:09', NULL, '2026-02-21 07:52:09', '2026-02-21 07:52:09'),
(911, 'recharge', NULL, 'Création recharge ✅', 'Création recharge effectuée avec succès.', 'réussi', '2026-02-21 07:54:07', NULL, '2026-02-21 07:54:07', '2026-02-21 07:54:07'),
(912, 'recharge', NULL, 'Création recharge ✅', 'Création recharge effectuée avec succès.', 'réussi', '2026-02-21 07:55:39', NULL, '2026-02-21 07:55:39', '2026-02-21 07:55:39'),
(913, 'recharge', NULL, 'Création recharge ❌', 'Échec lors de création recharge.', 'réussi', '2026-02-21 08:18:58', NULL, '2026-02-21 08:18:58', '2026-02-21 08:18:58'),
(914, 'recharge', NULL, 'Création recharge ✅', 'Création recharge effectuée avec succès.', 'réussi', '2026-02-21 08:24:27', NULL, '2026-02-21 08:24:27', '2026-02-21 08:24:27'),
(915, 'recharge', NULL, 'Création recharge ❌', 'Échec lors de création recharge.', 'réussi', '2026-02-21 08:25:47', NULL, '2026-02-21 08:25:47', '2026-02-21 08:25:47'),
(916, 'recharge', NULL, 'Création recharge ✅', 'Création recharge effectuée avec succès.', 'réussi', '2026-02-21 08:29:07', NULL, '2026-02-21 08:29:07', '2026-02-21 08:29:07'),
(917, 'recharge', NULL, 'Création recharge ✅', 'Création recharge effectuée avec succès.', 'réussi', '2026-02-21 08:30:07', NULL, '2026-02-21 08:30:07', '2026-02-21 08:30:07'),
(918, 'recharge', NULL, 'Création recharge ✅', 'Création recharge effectuée avec succès.', 'réussi', '2026-02-21 08:32:53', NULL, '2026-02-21 08:32:53', '2026-02-21 08:32:53'),
(919, 'recharge', NULL, 'Création recharge ✅', 'Création recharge effectuée avec succès.', 'réussi', '2026-02-21 08:33:36', NULL, '2026-02-21 08:33:36', '2026-02-21 08:33:36'),
(920, 'recharge', NULL, 'Création recharge ✅', 'Création recharge effectuée avec succès.', 'réussi', '2026-02-21 08:34:47', NULL, '2026-02-21 08:34:47', '2026-02-21 08:34:47'),
(921, 'transfert', NULL, 'Création transfert ❌', 'Échec lors de création transfert.', 'réussi', '2026-02-21 08:47:07', NULL, '2026-02-21 08:47:07', '2026-02-21 08:47:07'),
(922, 'transfert', NULL, 'Création transfert ❌', 'Échec lors de création transfert.', 'réussi', '2026-02-21 08:47:53', NULL, '2026-02-21 08:47:53', '2026-02-21 08:47:53'),
(923, 'transfert', NULL, 'Création transfert ❌', 'Échec lors de création transfert.', 'réussi', '2026-02-21 08:51:48', NULL, '2026-02-21 08:51:48', '2026-02-21 08:51:48'),
(924, 'Transfert', 10, NULL, 'Transfert à user_7cfxq', 'réussi', '2026-02-21 08:56:03', NULL, '2026-02-21 08:56:03', '2026-02-21 08:56:03'),
(925, 'transfert', NULL, 'Création transfert ✅', 'Création transfert effectuée avec succès.', 'réussi', '2026-02-21 08:56:03', NULL, '2026-02-21 08:56:03', '2026-02-21 08:56:03'),
(926, 'Transfert', 10, NULL, 'Transfert à user_7cfxq', 'réussi', '2026-02-21 08:56:52', NULL, '2026-02-21 08:56:52', '2026-02-21 08:56:52'),
(927, 'transfert', NULL, 'Création transfert ✅', 'Création transfert effectuée avec succès.', 'réussi', '2026-02-21 08:56:52', NULL, '2026-02-21 08:56:52', '2026-02-21 08:56:52'),
(928, 'Transfert', 10, NULL, 'Transfert à user_7cfxq', 'réussi', '2026-02-21 08:59:05', NULL, '2026-02-21 08:59:05', '2026-02-21 08:59:05'),
(929, 'transfert', NULL, 'Création transfert ✅', 'Création transfert effectuée avec succès.', 'réussi', '2026-02-21 08:59:05', NULL, '2026-02-21 08:59:05', '2026-02-21 08:59:05'),
(930, 'sector?page=1&pageSize=20&search=&paginate=false', NULL, 'Consultation sector?page=1&pageSize=20&search=&paginate=false ❌', 'Échec lors de consultation sector?page=1&pagesize=20&search=&paginate=false.', 'réussi', '2026-02-21 09:05:31', NULL, '2026-02-21 09:05:31', '2026-02-21 09:05:31'),
(931, '1', NULL, 'Consultation 1 ✅', 'Consultation 1 effectuée avec succès.', 'réussi', '2026-02-21 09:05:31', NULL, '2026-02-21 09:05:31', '2026-02-21 09:05:31'),
(932, '1', NULL, 'Consultation 1 ✅', 'Consultation 1 effectuée avec succès.', 'réussi', '2026-02-21 09:06:13', NULL, '2026-02-21 09:06:13', '2026-02-21 09:06:13'),
(933, 'tsx?id=1&page=1&pageSize=10&paginate=true', NULL, 'Consultation tsx?id=1&page=1&pageSize=10&paginate=true ❌', 'Échec lors de consultation tsx?id=1&page=1&pagesize=10&paginate=true.', 'réussi', '2026-02-21 09:06:15', NULL, '2026-02-21 09:06:15', '2026-02-21 09:06:15'),
(934, '6', NULL, 'Consultation 6 ✅', 'Consultation 6 effectuée avec succès.', 'réussi', '2026-02-21 09:07:52', NULL, '2026-02-21 09:07:52', '2026-02-21 09:07:52'),
(935, 'transfert', NULL, 'Création transfert ❌', 'Échec lors de création transfert.', 'réussi', '2026-02-21 09:08:10', NULL, '2026-02-21 09:08:10', '2026-02-21 09:08:10'),
(936, '6', NULL, 'Consultation 6 ❌', 'Échec lors de consultation 6.', 'réussi', '2026-02-21 09:08:19', NULL, '2026-02-21 09:08:19', '2026-02-21 09:08:19'),
(937, 'Transfert', 10, NULL, 'Transfert à user_3aunk', 'réussi', '2026-02-21 09:08:58', NULL, '2026-02-21 09:08:58', '2026-02-21 09:08:58'),
(938, 'transfert', NULL, 'Création transfert ✅', 'Création transfert effectuée avec succès.', 'réussi', '2026-02-21 09:08:59', NULL, '2026-02-21 09:08:59', '2026-02-21 09:08:59'),
(939, '6', NULL, 'Consultation 6 ✅', 'Consultation 6 effectuée avec succès.', 'réussi', '2026-02-21 09:09:04', NULL, '2026-02-21 09:09:04', '2026-02-21 09:09:04'),
(940, 'createrecharge', NULL, 'Création createrecharge ✅', 'Création createrecharge effectuée avec succès.', 'réussi', '2026-02-21 09:11:29', NULL, '2026-02-21 09:11:29', '2026-02-21 09:11:29'),
(941, 'recharge', NULL, 'Création recharge ✅', 'Création recharge effectuée avec succès.', 'réussi', '2026-02-21 09:11:32', NULL, '2026-02-21 09:11:32', '2026-02-21 09:11:32'),
(942, '6', NULL, 'Consultation 6 ✅', 'Consultation 6 effectuée avec succès.', 'réussi', '2026-02-21 09:11:52', NULL, '2026-02-21 09:11:52', '2026-02-21 09:11:52'),
(943, 'profile', NULL, 'Mise à jour profile ✅', 'Mise à jour profile effectuée avec succès.', 'réussi', '2026-02-21 09:19:42', NULL, '2026-02-21 09:19:42', '2026-02-21 09:19:42'),
(944, 'MODIFICATION_PROFIL', NULL, 'Profil modifié ✅', 'Profil mis à jour.', 'réussi', '2026-02-21 09:19:42', NULL, '2026-02-21 09:19:42', '2026-02-21 09:19:42'),
(945, '6', NULL, 'Consultation 6 ✅', 'Consultation 6 effectuée avec succès.', 'réussi', '2026-02-21 09:19:42', NULL, '2026-02-21 09:19:42', '2026-02-21 09:19:42'),
(946, 'create', NULL, 'Création create ✅', 'Création create effectuée avec succès.', 'réussi', '2026-02-21 09:19:42', NULL, '2026-02-21 09:19:42', '2026-02-21 09:19:42'),
(947, 'create', NULL, 'Création create ✅', 'Création create effectuée avec succès.', 'réussi', '2026-02-21 09:19:43', NULL, '2026-02-21 09:19:43', '2026-02-21 09:19:43'),
(948, '6', NULL, 'Consultation 6 ❌', 'Échec lors de consultation 6.', 'réussi', '2026-02-21 09:19:50', NULL, '2026-02-21 09:19:50', '2026-02-21 09:19:50'),
(949, 'sector?page=1&pageSize=20&search=&paginate=false', NULL, 'Consultation sector?page=1&pageSize=20&search=&paginate=false ❌', 'Échec lors de consultation sector?page=1&pagesize=20&search=&paginate=false.', 'réussi', '2026-02-21 09:21:17', NULL, '2026-02-21 09:21:17', '2026-02-21 09:21:17'),
(950, '6', NULL, 'Consultation 6 ✅', 'Consultation 6 effectuée avec succès.', 'réussi', '2026-02-21 09:21:17', NULL, '2026-02-21 09:21:17', '2026-02-21 09:21:17'),
(951, 'createrecharge', NULL, 'Création createrecharge ✅', 'Création createrecharge effectuée avec succès.', 'réussi', '2026-02-21 09:22:27', NULL, '2026-02-21 09:22:27', '2026-02-21 09:22:27'),
(952, 'recharge', NULL, 'Création recharge ✅', 'Création recharge effectuée avec succès.', 'réussi', '2026-02-21 09:22:30', NULL, '2026-02-21 09:22:30', '2026-02-21 09:22:30'),
(953, '6', NULL, 'Consultation 6 ✅', 'Consultation 6 effectuée avec succès.', 'réussi', '2026-02-21 09:22:40', NULL, '2026-02-21 09:22:40', '2026-02-21 09:22:40'),
(954, 'sector?page=1&pageSize=20&search=&paginate=false', NULL, 'Consultation sector?page=1&pageSize=20&search=&paginate=false ❌', 'Échec lors de consultation sector?page=1&pagesize=20&search=&paginate=false.', 'réussi', '2026-02-21 09:27:11', NULL, '2026-02-21 09:27:11', '2026-02-21 09:27:11'),
(955, '1', NULL, 'Consultation 1 ❌', 'Échec lors de consultation 1.', 'réussi', '2026-02-21 09:27:11', NULL, '2026-02-21 09:27:11', '2026-02-21 09:27:11'),
(956, 'connexion', NULL, 'Échec de la connexion ❌', 'Une tentative de connexion a été détectée, mais elle a échoué.', 'réussi', '2026-02-21 09:27:54', NULL, '2026-02-21 09:27:54', '2026-02-21 09:27:54'),
(957, 'create', NULL, 'Création create ✅', 'Création create effectuée avec succès.', 'réussi', '2026-02-21 09:27:54', NULL, '2026-02-21 09:27:54', '2026-02-21 09:27:54'),
(958, 'create', NULL, 'Création create ✅', 'Création create effectuée avec succès.', 'réussi', '2026-02-21 09:27:54', NULL, '2026-02-21 09:27:54', '2026-02-21 09:27:54'),
(959, 'tsx?id=6&page=1&pageSize=10&paginate=true', NULL, 'Consultation tsx?id=6&page=1&pageSize=10&paginate=true ❌', 'Échec lors de consultation tsx?id=6&page=1&pagesize=10&paginate=true.', 'réussi', '2026-02-21 09:28:08', NULL, '2026-02-21 09:28:08', '2026-02-21 09:28:08'),
(960, 'Transfert', 10, NULL, 'Transfert à Jerry', 'réussi', '2026-02-21 09:28:22', NULL, '2026-02-21 09:28:22', '2026-02-21 09:28:22'),
(961, 'transfert', NULL, 'Création transfert ✅', 'Création transfert effectuée avec succès.', 'réussi', '2026-02-21 09:28:22', NULL, '2026-02-21 09:28:22', '2026-02-21 09:28:22'),
(962, '1', NULL, 'Consultation 1 ✅', 'Consultation 1 effectuée avec succès.', 'réussi', '2026-02-21 09:28:35', NULL, '2026-02-21 09:28:35', '2026-02-21 09:28:35'),
(963, '6', NULL, 'Consultation 6 ✅', 'Consultation 6 effectuée avec succès.', 'réussi', '2026-02-21 09:28:52', NULL, '2026-02-21 09:28:52', '2026-02-21 09:28:52'),
(964, 'sector?page=1&pageSize=10&search=&paginate=true', NULL, 'Consultation sector?page=1&pageSize=10&search=&paginate=true ❌', 'Échec lors de consultation sector?page=1&pagesize=10&search=&paginate=true.', 'réussi', '2026-02-21 09:30:02', NULL, '2026-02-21 09:30:02', '2026-02-21 09:30:02'),
(965, 'users?search=&page=1&pageSize=20&paginate=true', NULL, 'Consultation users?search=&page=1&pageSize=20&paginate=true ✅', 'Consultation users?search=&page=1&pageSize=20&paginate=true effectuée avec succès.', 'réussi', '2026-02-21 09:30:04', NULL, '2026-02-21 09:30:04', '2026-02-21 09:30:04'),
(966, '6', NULL, 'Consultation 6 ❌', 'Échec lors de consultation 6.', 'réussi', '2026-02-21 09:37:21', NULL, '2026-02-21 09:37:21', '2026-02-21 09:37:21'),
(967, 'Retrait', 10, NULL, 'Retrait effectué', 'réussi', '2026-02-21 09:37:56', NULL, '2026-02-21 09:37:56', '2026-02-21 09:37:56'),
(968, 'Retrait', 10, NULL, 'Retrait client reçu', 'réussi', '2026-02-21 09:37:56', NULL, '2026-02-21 09:37:56', '2026-02-21 09:37:56'),
(969, 'Retrait', 0.2985, NULL, 'Frais retrait reçu', 'réussi', '2026-02-21 09:37:56', NULL, '2026-02-21 09:37:56', '2026-02-21 09:37:56'),
(970, 'retrait', NULL, 'Création retrait ✅', 'Création retrait effectuée avec succès.', 'réussi', '2026-02-21 09:37:58', NULL, '2026-02-21 09:37:58', '2026-02-21 09:37:58'),
(971, '6', NULL, 'Consultation 6 ✅', 'Consultation 6 effectuée avec succès.', 'réussi', '2026-02-21 09:38:05', NULL, '2026-02-21 09:38:05', '2026-02-21 09:38:05'),
(972, 'notification_track?userId=6&search=&page=1&pageSize=20', NULL, 'Consultation notification_track?userId=6&search=&page=1&pageSize=20 ✅', 'Consultation notification_track?userId=6&search=&page=1&pageSize=20 effectuée avec succès.', 'réussi', '2026-02-21 09:38:08', NULL, '2026-02-21 09:38:08', '2026-02-21 09:38:08'),
(973, '6', NULL, 'Consultation 6 ❌', 'Échec lors de consultation 6.', 'réussi', '2026-02-21 09:40:08', NULL, '2026-02-21 09:40:08', '2026-02-21 09:40:08'),
(974, 'Retrait', 5, NULL, 'Retrait effectué', 'réussi', '2026-02-21 09:40:41', NULL, '2026-02-21 09:40:41', '2026-02-21 09:40:41'),
(975, 'Retrait', 5, NULL, 'Retrait client reçu', 'réussi', '2026-02-21 09:40:41', NULL, '2026-02-21 09:40:41', '2026-02-21 09:40:41'),
(976, 'Retrait', 0.14925, NULL, 'Frais retrait reçu', 'réussi', '2026-02-21 09:40:41', NULL, '2026-02-21 09:40:41', '2026-02-21 09:40:41'),
(977, 'retrait', NULL, 'Création retrait ✅', 'Création retrait effectuée avec succès.', 'réussi', '2026-02-21 09:40:44', NULL, '2026-02-21 09:40:44', '2026-02-21 09:40:44'),
(978, 'notification_track?userId=6&search=&page=1&pageSize=20', NULL, 'Consultation notification_track?userId=6&search=&page=1&pageSize=20 ✅', 'Consultation notification_track?userId=6&search=&page=1&pageSize=20 effectuée avec succès.', 'réussi', '2026-02-21 09:40:52', NULL, '2026-02-21 09:40:52', '2026-02-21 09:40:52'),
(979, '6', NULL, 'Consultation 6 ✅', 'Consultation 6 effectuée avec succès.', 'réussi', '2026-02-21 09:41:06', NULL, '2026-02-21 09:41:06', '2026-02-21 09:41:06'),
(980, 'Retrait', 20, NULL, 'Retrait effectué', 'réussi', '2026-02-21 09:56:15', NULL, '2026-02-21 09:56:15', '2026-02-21 09:56:15'),
(981, 'Retrait', 20, NULL, 'Retrait client reçu', 'réussi', '2026-02-21 09:56:15', NULL, '2026-02-21 09:56:15', '2026-02-21 09:56:15'),
(982, 'Retrait', 0.597, NULL, 'Frais retrait reçu', 'réussi', '2026-02-21 09:56:15', NULL, '2026-02-21 09:56:15', '2026-02-21 09:56:15'),
(983, 'retrait', NULL, 'Création retrait ✅', 'Création retrait effectuée avec succès.', 'réussi', '2026-02-21 09:56:18', NULL, '2026-02-21 09:56:18', '2026-02-21 09:56:18'),
(984, '6', NULL, 'Consultation 6 ✅', 'Consultation 6 effectuée avec succès.', 'réussi', '2026-02-21 09:56:25', NULL, '2026-02-21 09:56:25', '2026-02-21 09:56:25'),
(985, 'notification_track?userId=6&search=&page=1&pageSize=20', NULL, 'Consultation notification_track?userId=6&search=&page=1&pageSize=20 ✅', 'Consultation notification_track?userId=6&search=&page=1&pageSize=20 effectuée avec succès.', 'réussi', '2026-02-21 09:56:27', NULL, '2026-02-21 09:56:27', '2026-02-21 09:56:27'),
(986, 'users?search=&page=1&pageSize=20&paginate=true', NULL, 'Consultation users?search=&page=1&pageSize=20&paginate=true ✅', 'Consultation users?search=&page=1&pageSize=20&paginate=true effectuée avec succès.', 'réussi', '2026-02-21 09:57:38', NULL, '2026-02-21 09:57:38', '2026-02-21 09:57:38'),
(987, 'users?search=Leader+Mushio&page=1&pageSize=20&paginate=true', NULL, 'Consultation users?search=Leader+Mushio&page=1&pageSize=20&paginate=true ✅', 'Consultation users?search=Leader+Mushio&page=1&pageSize=20&paginate=true effectuée avec succès.', 'réussi', '2026-02-21 09:57:46', NULL, '2026-02-21 09:57:46', '2026-02-21 09:57:46'),
(988, 'Transfert', 2, NULL, 'Transfert à Leader Mushio', 'réussi', '2026-02-21 09:57:59', NULL, '2026-02-21 09:57:59', '2026-02-21 09:57:59'),
(989, 'transfert', NULL, 'Création transfert ✅', 'Création transfert effectuée avec succès.', 'réussi', '2026-02-21 09:57:59', NULL, '2026-02-21 09:57:59', '2026-02-21 09:57:59'),
(990, '6', NULL, 'Consultation 6 ✅', 'Consultation 6 effectuée avec succès.', 'réussi', '2026-02-21 09:58:06', NULL, '2026-02-21 09:58:06', '2026-02-21 09:58:06'),
(991, '6', NULL, 'Consultation 6 ❌', 'Échec lors de consultation 6.', 'réussi', '2026-02-21 09:58:24', NULL, '2026-02-21 09:58:24', '2026-02-21 09:58:24'),
(992, '6', NULL, 'Consultation 6 ❌', 'Échec lors de consultation 6.', 'réussi', '2026-02-21 09:59:29', NULL, '2026-02-21 09:59:29', '2026-02-21 09:59:29'),
(993, '6', NULL, 'Consultation 6 ❌', 'Échec lors de consultation 6.', 'réussi', '2026-02-21 09:59:32', NULL, '2026-02-21 09:59:32', '2026-02-21 09:59:32'),
(994, 'product?page=1&pageSize=10&search=&paginate=true&companyId=8', NULL, 'Consultation product?page=1&pageSize=10&search=&paginate=true&companyId=8 ✅', 'Consultation product?page=1&pageSize=10&search=&paginate=true&companyId=8 effectuée avec succès.', 'réussi', '2026-02-21 09:59:45', NULL, '2026-02-21 09:59:45', '2026-02-21 09:59:45'),
(995, 'paiement', NULL, 'Création paiement ❌', 'Échec lors de création paiement.', 'réussi', '2026-02-21 09:59:54', NULL, '2026-02-21 09:59:54', '2026-02-21 09:59:54'),
(996, 'notification_track?userId=6&search=&page=1&pageSize=20', NULL, 'Consultation notification_track?userId=6&search=&page=1&pageSize=20 ✅', 'Consultation notification_track?userId=6&search=&page=1&pageSize=20 effectuée avec succès.', 'réussi', '2026-02-21 10:00:26', NULL, '2026-02-21 10:00:26', '2026-02-21 10:00:26'),
(997, 'notification_track?paginate=true&userId=6', NULL, 'Consultation notification_track?paginate=true&userId=6 ✅', 'Consultation notification_track?paginate=true&userId=6 effectuée avec succès.', 'réussi', '2026-02-21 10:04:59', NULL, '2026-02-21 10:04:59', '2026-02-21 10:04:59'),
(998, 'notification_track?paginate=true&userId=6', NULL, 'Consultation notification_track?paginate=true&userId=6 ❌', 'Échec lors de consultation notification_track?paginate=true&userid=6.', 'réussi', '2026-02-21 10:10:00', NULL, '2026-02-21 10:10:00', '2026-02-21 10:10:00'),
(999, 'notification_track?paginate=true&userId=6', NULL, 'Consultation notification_track?paginate=true&userId=6 ✅', 'Consultation notification_track?paginate=true&userId=6 effectuée avec succès.', 'réussi', '2026-02-21 10:11:12', NULL, '2026-02-21 10:11:12', '2026-02-21 10:11:12'),
(1000, '6', NULL, 'Consultation 6 ❌', 'Échec lors de consultation 6.', 'réussi', '2026-02-21 10:11:27', NULL, '2026-02-21 10:11:27', '2026-02-21 10:11:27'),
(1001, 'notification_track?userId=6&search=&page=1&pageSize=20', NULL, 'Consultation notification_track?userId=6&search=&page=1&pageSize=20 ✅', 'Consultation notification_track?userId=6&search=&page=1&pageSize=20 effectuée avec succès.', 'réussi', '2026-02-21 10:15:02', NULL, '2026-02-21 10:15:02', '2026-02-21 10:15:02'),
(1002, 'notification_track?userId=6&search=&page=1&pageSize=20', NULL, 'Consultation notification_track?userId=6&search=&page=1&pageSize=20 ❌', 'Échec lors de consultation notification_track?userid=6&search=&page=1&pagesize=20.', 'réussi', '2026-02-21 10:16:40', NULL, '2026-02-21 10:16:40', '2026-02-21 10:16:40'),
(1003, 'notification_track?userId=6&search=&page=1&pageSize=20', NULL, 'Consultation notification_track?userId=6&search=&page=1&pageSize=20 ❌', 'Échec lors de consultation notification_track?userid=6&search=&page=1&pagesize=20.', 'réussi', '2026-02-21 10:16:43', NULL, '2026-02-21 10:16:43', '2026-02-21 10:16:43'),
(1004, 'notification_track?userId=6&search=&page=1&pageSize=20', NULL, 'Consultation notification_track?userId=6&search=&page=1&pageSize=20 ❌', 'Échec lors de consultation notification_track?userid=6&search=&page=1&pagesize=20.', 'réussi', '2026-02-21 10:16:48', NULL, '2026-02-21 10:16:48', '2026-02-21 10:16:48'),
(1005, 'sector?page=1&pageSize=20&search=&paginate=false', NULL, 'Consultation sector?page=1&pageSize=20&search=&paginate=false ❌', 'Échec lors de consultation sector?page=1&pagesize=20&search=&paginate=false.', 'réussi', '2026-02-21 10:17:20', NULL, '2026-02-21 10:17:20', '2026-02-21 10:17:20'),
(1006, '1', NULL, 'Consultation 1 ✅', 'Consultation 1 effectuée avec succès.', 'réussi', '2026-02-21 10:17:20', NULL, '2026-02-21 10:17:20', '2026-02-21 10:17:20'),
(1007, 'sector?page=1&pageSize=10&search=&paginate=true', NULL, 'Consultation sector?page=1&pageSize=10&search=&paginate=true ❌', 'Échec lors de consultation sector?page=1&pagesize=10&search=&paginate=true.', 'réussi', '2026-02-21 10:18:05', NULL, '2026-02-21 10:18:05', '2026-02-21 10:18:05'),
(1008, 'tsx?id=1&page=1&pageSize=10&paginate=true', NULL, 'Consultation tsx?id=1&page=1&pageSize=10&paginate=true ❌', 'Échec lors de consultation tsx?id=1&page=1&pagesize=10&paginate=true.', 'réussi', '2026-02-21 10:18:05', NULL, '2026-02-21 10:18:05', '2026-02-21 10:18:05'),
(1009, 'notification_track?userId=1&search=&page=1&pageSize=20', NULL, 'Consultation notification_track?userId=1&search=&page=1&pageSize=20 ✅', 'Consultation notification_track?userId=1&search=&page=1&pageSize=20 effectuée avec succès.', 'réussi', '2026-02-21 10:18:08', NULL, '2026-02-21 10:18:08', '2026-02-21 10:18:08'),
(1010, 'notification_track?userId=1&search=&page=1&pageSize=20', NULL, 'Consultation notification_track?userId=1&search=&page=1&pageSize=20 ❌', 'Échec lors de consultation notification_track?userid=1&search=&page=1&pagesize=20.', 'réussi', '2026-02-21 10:19:50', NULL, '2026-02-21 10:19:50', '2026-02-21 10:19:50'),
(1011, 'notification_track?userId=1&search=&page=1&pageSize=20', NULL, 'Consultation notification_track?userId=1&search=&page=1&pageSize=20 ❌', 'Échec lors de consultation notification_track?userid=1&search=&page=1&pagesize=20.', 'réussi', '2026-02-21 10:19:56', NULL, '2026-02-21 10:19:56', '2026-02-21 10:19:56'),
(1012, 'sector?page=1&pageSize=20&search=&paginate=false', NULL, 'Consultation sector?page=1&pageSize=20&search=&paginate=false ❌', 'Échec lors de consultation sector?page=1&pagesize=20&search=&paginate=false.', 'réussi', '2026-02-21 10:20:12', NULL, '2026-02-21 10:20:12', '2026-02-21 10:20:12'),
(1013, '1', NULL, 'Consultation 1 ✅', 'Consultation 1 effectuée avec succès.', 'réussi', '2026-02-21 10:20:12', NULL, '2026-02-21 10:20:12', '2026-02-21 10:20:12'),
(1014, 'notification_track?userId=1&search=&page=1&pageSize=20', NULL, 'Consultation notification_track?userId=1&search=&page=1&pageSize=20 ❌', 'Échec lors de consultation notification_track?userid=1&search=&page=1&pagesize=20.', 'réussi', '2026-02-21 10:20:51', NULL, '2026-02-21 10:20:51', '2026-02-21 10:20:51'),
(1015, 'notification_track?userId=1&search=&page=1&pageSize=20', NULL, 'Consultation notification_track?userId=1&search=&page=1&pageSize=20 ❌', 'Échec lors de consultation notification_track?userid=1&search=&page=1&pagesize=20.', 'réussi', '2026-02-21 10:21:01', NULL, '2026-02-21 10:21:01', '2026-02-21 10:21:01'),
(1016, 'notification_track?userId=1&search=&page=1&pageSize=20', NULL, 'Consultation notification_track?userId=1&search=&page=1&pageSize=20 ❌', 'Échec lors de consultation notification_track?userid=1&search=&page=1&pagesize=20.', 'réussi', '2026-02-21 10:21:03', NULL, '2026-02-21 10:21:03', '2026-02-21 10:21:03'),
(1017, 'notification_track?userId=1&search=&page=1&pageSize=20', NULL, 'Consultation notification_track?userId=1&search=&page=1&pageSize=20 ❌', 'Échec lors de consultation notification_track?userid=1&search=&page=1&pagesize=20.', 'réussi', '2026-02-21 10:21:04', NULL, '2026-02-21 10:21:04', '2026-02-21 10:21:04'),
(1018, 'notification_track?userId=1&search=&page=1&pageSize=20', NULL, 'Consultation notification_track?userId=1&search=&page=1&pageSize=20 ❌', 'Échec lors de consultation notification_track?userid=1&search=&page=1&pagesize=20.', 'réussi', '2026-02-21 10:21:05', NULL, '2026-02-21 10:21:05', '2026-02-21 10:21:05'),
(1019, 'notification_track?userId=1&search=&page=1&pageSize=20', NULL, 'Consultation notification_track?userId=1&search=&page=1&pageSize=20 ❌', 'Échec lors de consultation notification_track?userid=1&search=&page=1&pagesize=20.', 'réussi', '2026-02-21 10:21:07', NULL, '2026-02-21 10:21:07', '2026-02-21 10:21:07'),
(1020, 'notification_track?userId=1&search=&page=1&pageSize=20&paginate=true', NULL, 'Consultation notification_track?userId=1&search=&page=1&pageSize=20&paginate=true ✅', 'Consultation notification_track?userId=1&search=&page=1&pageSize=20&paginate=true effectuée avec succès.', 'réussi', '2026-02-21 10:22:25', NULL, '2026-02-21 10:22:25', '2026-02-21 10:22:25'),
(1021, 'notification_track?userId=1&search=&page=1&pageSize=20&paginate=true', NULL, 'Consultation notification_track?userId=1&search=&page=1&pageSize=20&paginate=true ❌', 'Échec lors de consultation notification_track?userid=1&search=&page=1&pagesize=20&paginate=true.', 'réussi', '2026-02-21 10:22:28', NULL, '2026-02-21 10:22:28', '2026-02-21 10:22:28'),
(1022, 'notification_track?paginate=true&userId=6&search=', NULL, 'Consultation notification_track?paginate=true&userId=6&search= ✅', 'Consultation notification_track?paginate=true&userId=6&search= effectuée avec succès.', 'réussi', '2026-02-21 10:23:42', NULL, '2026-02-21 10:23:42', '2026-02-21 10:23:42'),
(1023, 'notification_track?userId=1&search=&page=1&pageSize=20&paginate=true', NULL, 'Consultation notification_track?userId=1&search=&page=1&pageSize=20&paginate=true ❌', 'Échec lors de consultation notification_track?userid=1&search=&page=1&pagesize=20&paginate=true.', 'réussi', '2026-02-21 10:23:53', NULL, '2026-02-21 10:23:53', '2026-02-21 10:23:53'),
(1024, 'notification_track?userId=1&search=&page=1&pageSize=20&paginate=true', NULL, 'Consultation notification_track?userId=1&search=&page=1&pageSize=20&paginate=true ❌', 'Échec lors de consultation notification_track?userid=1&search=&page=1&pagesize=20&paginate=true.', 'réussi', '2026-02-21 10:23:54', NULL, '2026-02-21 10:23:54', '2026-02-21 10:23:54'),
(1025, 'notification_track?userId=1&search=F&page=1&pageSize=20&paginate=true', NULL, 'Consultation notification_track?userId=1&search=F&page=1&pageSize=20&paginate=true ✅', 'Consultation notification_track?userId=1&search=F&page=1&pageSize=20&paginate=true effectuée avec succès.', 'réussi', '2026-02-21 10:24:45', NULL, '2026-02-21 10:24:45', '2026-02-21 10:24:45'),
(1026, 'notification_track?userId=1&search=Fg&page=1&pageSize=20&paginate=true', NULL, 'Consultation notification_track?userId=1&search=Fg&page=1&pageSize=20&paginate=true ✅', 'Consultation notification_track?userId=1&search=Fg&page=1&pageSize=20&paginate=true effectuée avec succès.', 'réussi', '2026-02-21 10:24:45', NULL, '2026-02-21 10:24:45', '2026-02-21 10:24:45'),
(1027, 'notification_track?userId=1&search=D&page=1&pageSize=20&paginate=true', NULL, 'Consultation notification_track?userId=1&search=D&page=1&pageSize=20&paginate=true ✅', 'Consultation notification_track?userId=1&search=D&page=1&pageSize=20&paginate=true effectuée avec succès.', 'réussi', '2026-02-21 10:24:49', NULL, '2026-02-21 10:24:49', '2026-02-21 10:24:49'),
(1028, 'notification_track?userId=1&search=J&page=1&pageSize=20&paginate=true', NULL, 'Consultation notification_track?userId=1&search=J&page=1&pageSize=20&paginate=true ✅', 'Consultation notification_track?userId=1&search=J&page=1&pageSize=20&paginate=true effectuée avec succès.', 'réussi', '2026-02-21 10:24:51', NULL, '2026-02-21 10:24:51', '2026-02-21 10:24:51'),
(1029, 'notification_track?userId=1&search=Jj&page=1&pageSize=20&paginate=true', NULL, 'Consultation notification_track?userId=1&search=Jj&page=1&pageSize=20&paginate=true ✅', 'Consultation notification_track?userId=1&search=Jj&page=1&pageSize=20&paginate=true effectuée avec succès.', 'réussi', '2026-02-21 10:24:51', NULL, '2026-02-21 10:24:51', '2026-02-21 10:24:51'),
(1030, 'notification_track?userId=1&search=Jjs&page=1&pageSize=20&paginate=true', NULL, 'Consultation notification_track?userId=1&search=Jjs&page=1&pageSize=20&paginate=true ✅', 'Consultation notification_track?userId=1&search=Jjs&page=1&pageSize=20&paginate=true effectuée avec succès.', 'réussi', '2026-02-21 10:24:52', NULL, '2026-02-21 10:24:52', '2026-02-21 10:24:52'),
(1031, 'notification_track?userId=1&search=&page=1&pageSize=20&paginate=true', NULL, 'Consultation notification_track?userId=1&search=&page=1&pageSize=20&paginate=true ❌', 'Échec lors de consultation notification_track?userid=1&search=&page=1&pagesize=20&paginate=true.', 'réussi', '2026-02-21 10:25:54', NULL, '2026-02-21 10:25:54', '2026-02-21 10:25:54'),
(1032, 'sector?page=1&pageSize=20&search=&paginate=false', NULL, 'Consultation sector?page=1&pageSize=20&search=&paginate=false ❌', 'Échec lors de consultation sector?page=1&pagesize=20&search=&paginate=false.', 'réussi', '2026-02-21 10:26:23', NULL, '2026-02-21 10:26:23', '2026-02-21 10:26:23'),
(1033, '1', NULL, 'Consultation 1 ✅', 'Consultation 1 effectuée avec succès.', 'réussi', '2026-02-21 10:26:23', NULL, '2026-02-21 10:26:23', '2026-02-21 10:26:23'),
(1034, 'notification_track?userId=1&search=&page=1&pageSize=20&paginate=true', NULL, 'Consultation notification_track?userId=1&search=&page=1&pageSize=20&paginate=true ❌', 'Échec lors de consultation notification_track?userid=1&search=&page=1&pagesize=20&paginate=true.', 'réussi', '2026-02-21 10:26:47', NULL, '2026-02-21 10:26:47', '2026-02-21 10:26:47'),
(1035, 'notification_track?userId=1&search=&page=1&pageSize=20&paginate=true', NULL, 'Consultation notification_track?userId=1&search=&page=1&pageSize=20&paginate=true ❌', 'Échec lors de consultation notification_track?userid=1&search=&page=1&pagesize=20&paginate=true.', 'réussi', '2026-02-21 10:26:52', NULL, '2026-02-21 10:26:52', '2026-02-21 10:26:52'),
(1036, '1', NULL, 'Consultation 1 ✅', 'Consultation 1 effectuée avec succès.', 'réussi', '2026-02-21 10:26:59', NULL, '2026-02-21 10:26:59', '2026-02-21 10:26:59'),
(1037, 'notification_track?userId=1&search=&page=1&pageSize=20&paginate=true', NULL, 'Consultation notification_track?userId=1&search=&page=1&pageSize=20&paginate=true ❌', 'Échec lors de consultation notification_track?userid=1&search=&page=1&pagesize=20&paginate=true.', 'réussi', '2026-02-21 10:27:02', NULL, '2026-02-21 10:27:02', '2026-02-21 10:27:02'),
(1038, 'sector?page=1&pageSize=20&search=&paginate=false', NULL, 'Consultation sector?page=1&pageSize=20&search=&paginate=false ❌', 'Échec lors de consultation sector?page=1&pagesize=20&search=&paginate=false.', 'réussi', '2026-02-21 10:27:46', NULL, '2026-02-21 10:27:46', '2026-02-21 10:27:46'),
(1039, '6', NULL, 'Consultation 6 ✅', 'Consultation 6 effectuée avec succès.', 'réussi', '2026-02-21 10:27:46', NULL, '2026-02-21 10:27:46', '2026-02-21 10:27:46'),
(1040, 'notification_track?userId=6&search=&page=1&pageSize=20&paginate=true', NULL, 'Consultation notification_track?userId=6&search=&page=1&pageSize=20&paginate=true ✅', 'Consultation notification_track?userId=6&search=&page=1&pageSize=20&paginate=true effectuée avec succès.', 'réussi', '2026-02-21 10:27:49', NULL, '2026-02-21 10:27:49', '2026-02-21 10:27:49'),
(1041, 'notification_track?userId=6&search=&page=1&pageSize=20&paginate=true', NULL, 'Consultation notification_track?userId=6&search=&page=1&pageSize=20&paginate=true ❌', 'Échec lors de consultation notification_track?userid=6&search=&page=1&pagesize=20&paginate=true.', 'réussi', '2026-02-21 10:27:57', NULL, '2026-02-21 10:27:57', '2026-02-21 10:27:57'),
(1042, 'notification_track?userId=1&search=&page=1&pageSize=20&paginate=true', NULL, 'Consultation notification_track?userId=1&search=&page=1&pageSize=20&paginate=true ❌', 'Échec lors de consultation notification_track?userid=1&search=&page=1&pagesize=20&paginate=true.', 'réussi', '2026-02-21 10:29:48', NULL, '2026-02-21 10:29:48', '2026-02-21 10:29:48'),
(1043, 'notification_track?userId=1&search=&page=1&pageSize=20&paginate=true', NULL, 'Consultation notification_track?userId=1&search=&page=1&pageSize=20&paginate=true ❌', 'Échec lors de consultation notification_track?userid=1&search=&page=1&pagesize=20&paginate=true.', 'réussi', '2026-02-21 10:29:49', NULL, '2026-02-21 10:29:49', '2026-02-21 10:29:49'),
(1044, 'notification_track?userId=6&search=&page=1&pageSize=20&paginate=true', NULL, 'Consultation notification_track?userId=6&search=&page=1&pageSize=20&paginate=true ❌', 'Échec lors de consultation notification_track?userid=6&search=&page=1&pagesize=20&paginate=true.', 'réussi', '2026-02-21 10:29:54', NULL, '2026-02-21 10:29:54', '2026-02-21 10:29:54'),
(1045, 'notification_track?userId=1&search=&page=1&pageSize=20&paginate=true', NULL, 'Consultation notification_track?userId=1&search=&page=1&pageSize=20&paginate=true ❌', 'Échec lors de consultation notification_track?userid=1&search=&page=1&pagesize=20&paginate=true.', 'réussi', '2026-02-21 10:30:37', NULL, '2026-02-21 10:30:37', '2026-02-21 10:30:37'),
(1046, 'product?page=1&pageSize=10&search=&paginate=true&companyId=8', NULL, 'Consultation product?page=1&pageSize=10&search=&paginate=true&companyId=8 ❌', 'Échec lors de consultation product?page=1&pagesize=10&search=&paginate=true&companyid=8.', 'réussi', '2026-02-21 10:31:10', NULL, '2026-02-21 10:31:10', '2026-02-21 10:31:10'),
(1047, 'product?page=1&pageSize=10&search=&paginate=true&companyId=13', NULL, 'Consultation product?page=1&pageSize=10&search=&paginate=true&companyId=13 ❌', 'Échec lors de consultation product?page=1&pagesize=10&search=&paginate=true&companyid=13.', 'réussi', '2026-02-21 10:31:48', NULL, '2026-02-21 10:31:48', '2026-02-21 10:31:48'),
(1048, 'product?page=1&pageSize=10&search=&paginate=true&companyId=14', NULL, 'Consultation product?page=1&pageSize=10&search=&paginate=true&companyId=14 ✅', 'Consultation product?page=1&pageSize=10&search=&paginate=true&companyId=14 effectuée avec succès.', 'réussi', '2026-02-21 10:31:53', NULL, '2026-02-21 10:31:53', '2026-02-21 10:31:53'),
(1049, 'product?page=1&pageSize=10&search=&paginate=true&companyId=9', NULL, 'Consultation product?page=1&pageSize=10&search=&paginate=true&companyId=9 ✅', 'Consultation product?page=1&pageSize=10&search=&paginate=true&companyId=9 effectuée avec succès.', 'réussi', '2026-02-21 10:31:58', NULL, '2026-02-21 10:31:58', '2026-02-21 10:31:58'),
(1050, 'sector?page=1&pageSize=10&search=&paginate=true', NULL, 'Consultation sector?page=1&pageSize=10&search=&paginate=true ❌', 'Échec lors de consultation sector?page=1&pagesize=10&search=&paginate=true.', 'réussi', '2026-02-21 10:32:08', NULL, '2026-02-21 10:32:08', '2026-02-21 10:32:08'),
(1051, 'product?page=1&pageSize=10&search=&paginate=true&companyId=11', NULL, 'Consultation product?page=1&pageSize=10&search=&paginate=true&companyId=11 ❌', 'Échec lors de consultation product?page=1&pagesize=10&search=&paginate=true&companyid=11.', 'réussi', '2026-02-21 10:32:25', NULL, '2026-02-21 10:32:25', '2026-02-21 10:32:25'),
(1052, 'tsx?id=1&page=1&pageSize=10&paginate=true', NULL, 'Consultation tsx?id=1&page=1&pageSize=10&paginate=true ❌', 'Échec lors de consultation tsx?id=1&page=1&pagesize=10&paginate=true.', 'réussi', '2026-02-21 10:32:37', NULL, '2026-02-21 10:32:37', '2026-02-21 10:32:37'),
(1053, 'tsx?page=1&pageSize=1000&paginate=true', NULL, 'Consultation tsx?page=1&pageSize=1000&paginate=true ✅', 'Consultation tsx?page=1&pageSize=1000&paginate=true effectuée avec succès.', 'réussi', '2026-02-21 10:32:38', NULL, '2026-02-21 10:32:38', '2026-02-21 10:32:38'),
(1054, '1', NULL, 'Consultation 1 ❌', 'Échec lors de consultation 1.', 'réussi', '2026-02-21 10:32:43', NULL, '2026-02-21 10:32:43', '2026-02-21 10:32:43'),
(1055, '1', NULL, 'Consultation 1 ❌', 'Échec lors de consultation 1.', 'réussi', '2026-02-21 10:32:44', NULL, '2026-02-21 10:32:44', '2026-02-21 10:32:44'),
(1056, 'notification_track?userId=1&search=&page=1&pageSize=20&paginate=true', NULL, 'Consultation notification_track?userId=1&search=&page=1&pageSize=20&paginate=true ❌', 'Échec lors de consultation notification_track?userid=1&search=&page=1&pagesize=20&paginate=true.', 'réussi', '2026-02-21 10:32:45', NULL, '2026-02-21 10:32:45', '2026-02-21 10:32:45'),
(1057, 'notification_track?userId=1&search=&page=1&pageSize=20&paginate=true', NULL, 'Consultation notification_track?userId=1&search=&page=1&pageSize=20&paginate=true ❌', 'Échec lors de consultation notification_track?userid=1&search=&page=1&pagesize=20&paginate=true.', 'réussi', '2026-02-21 10:32:57', NULL, '2026-02-21 10:32:57', '2026-02-21 10:32:57'),
(1058, 'notification_track?userId=1&search=&page=1&pageSize=20&paginate=true', NULL, 'Consultation notification_track?userId=1&search=&page=1&pageSize=20&paginate=true ❌', 'Échec lors de consultation notification_track?userid=1&search=&page=1&pagesize=20&paginate=true.', 'réussi', '2026-02-21 10:33:30', NULL, '2026-02-21 10:33:30', '2026-02-21 10:33:30'),
(1059, 'users?search=&page=1&pageSize=20&paginate=true', NULL, 'Consultation users?search=&page=1&pageSize=20&paginate=true ✅', 'Consultation users?search=&page=1&pageSize=20&paginate=true effectuée avec succès.', 'réussi', '2026-02-21 10:33:38', NULL, '2026-02-21 10:33:38', '2026-02-21 10:33:38'),
(1060, 'users?search=john&page=1&pageSize=20&paginate=true', NULL, 'Consultation users?search=john&page=1&pageSize=20&paginate=true ✅', 'Consultation users?search=john&page=1&pageSize=20&paginate=true effectuée avec succès.', 'réussi', '2026-02-21 10:33:42', NULL, '2026-02-21 10:33:42', '2026-02-21 10:33:42'),
(1061, 'Transfert', 10, NULL, 'Transfert à john', 'réussi', '2026-02-21 10:33:56', NULL, '2026-02-21 10:33:56', '2026-02-21 10:33:56'),
(1062, 'transfert', NULL, 'Création transfert ✅', 'Création transfert effectuée avec succès.', 'réussi', '2026-02-21 10:33:56', NULL, '2026-02-21 10:33:56', '2026-02-21 10:33:56'),
(1063, '1', NULL, 'Consultation 1 ✅', 'Consultation 1 effectuée avec succès.', 'réussi', '2026-02-21 10:33:59', NULL, '2026-02-21 10:33:59', '2026-02-21 10:33:59'),
(1064, 'notification_track?userId=1&search=&page=1&pageSize=20&paginate=true', NULL, 'Consultation notification_track?userId=1&search=&page=1&pageSize=20&paginate=true ❌', 'Échec lors de consultation notification_track?userid=1&search=&page=1&pagesize=20&paginate=true.', 'réussi', '2026-02-21 10:34:02', NULL, '2026-02-21 10:34:02', '2026-02-21 10:34:02'),
(1065, 'notification_track?userId=1&search=&page=1&pageSize=20&paginate=true', NULL, 'Consultation notification_track?userId=1&search=&page=1&pageSize=20&paginate=true ❌', 'Échec lors de consultation notification_track?userid=1&search=&page=1&pagesize=20&paginate=true.', 'réussi', '2026-02-21 10:34:04', NULL, '2026-02-21 10:34:04', '2026-02-21 10:34:04'),
(1066, 'notification_track?userId=1&search=&page=1&pageSize=20&paginate=true', NULL, 'Consultation notification_track?userId=1&search=&page=1&pageSize=20&paginate=true ❌', 'Échec lors de consultation notification_track?userid=1&search=&page=1&pagesize=20&paginate=true.', 'réussi', '2026-02-21 10:34:06', NULL, '2026-02-21 10:34:06', '2026-02-21 10:34:06'),
(1067, 'notification_track?userId=1&search=&page=1&pageSize=20&paginate=true', NULL, 'Consultation notification_track?userId=1&search=&page=1&pageSize=20&paginate=true ❌', 'Échec lors de consultation notification_track?userid=1&search=&page=1&pagesize=20&paginate=true.', 'réussi', '2026-02-21 10:34:07', NULL, '2026-02-21 10:34:07', '2026-02-21 10:34:07'),
(1068, 'notification_track?userId=1&search=&page=1&pageSize=20&paginate=true', NULL, 'Consultation notification_track?userId=1&search=&page=1&pageSize=20&paginate=true ❌', 'Échec lors de consultation notification_track?userid=1&search=&page=1&pagesize=20&paginate=true.', 'réussi', '2026-02-21 10:34:13', NULL, '2026-02-21 10:34:13', '2026-02-21 10:34:13'),
(1069, 'notification_track?paginate=true&userId=1&search=', NULL, 'Consultation notification_track?paginate=true&userId=1&search= ✅', 'Consultation notification_track?paginate=true&userId=1&search= effectuée avec succès.', 'réussi', '2026-02-21 10:34:39', NULL, '2026-02-21 10:34:39', '2026-02-21 10:34:39'),
(1070, 'notification_track?userId=1&search=&page=1&pageSize=20&paginate=true', NULL, 'Consultation notification_track?userId=1&search=&page=1&pageSize=20&paginate=true ❌', 'Échec lors de consultation notification_track?userid=1&search=&page=1&pagesize=20&paginate=true.', 'réussi', '2026-02-21 10:35:40', NULL, '2026-02-21 10:35:40', '2026-02-21 10:35:40'),
(1071, 'notification_track?userId=1&search=&page=1&pageSize=20&paginate=true', NULL, 'Consultation notification_track?userId=1&search=&page=1&pageSize=20&paginate=true ❌', 'Échec lors de consultation notification_track?userid=1&search=&page=1&pagesize=20&paginate=true.', 'réussi', '2026-02-21 10:39:25', NULL, '2026-02-21 10:39:25', '2026-02-21 10:39:25'),
(1072, 'tsx?page=1&pageSize=1000&paginate=true', NULL, 'Consultation tsx?page=1&pageSize=1000&paginate=true ✅', 'Consultation tsx?page=1&pageSize=1000&paginate=true effectuée avec succès.', 'réussi', '2026-02-21 10:44:19', NULL, '2026-02-21 10:44:19', '2026-02-21 10:44:19'),
(1073, 'notification_track?userId=1&search=&page=1&pageSize=20&paginate=true', NULL, 'Consultation notification_track?userId=1&search=&page=1&pageSize=20&paginate=true ❌', 'Échec lors de consultation notification_track?userid=1&search=&page=1&pagesize=20&paginate=true.', 'réussi', '2026-02-21 10:50:26', NULL, '2026-02-21 10:50:26', '2026-02-21 10:50:26'),
(1074, '1', NULL, 'Consultation 1 ❌', 'Échec lors de consultation 1.', 'réussi', '2026-02-21 10:50:44', NULL, '2026-02-21 10:50:44', '2026-02-21 10:50:44'),
(1075, 'notification_track?userId=1&search=&page=1&pageSize=20&paginate=true', NULL, 'Consultation notification_track?userId=1&search=&page=1&pageSize=20&paginate=true ❌', 'Échec lors de consultation notification_track?userid=1&search=&page=1&pagesize=20&paginate=true.', 'réussi', '2026-02-21 10:50:49', NULL, '2026-02-21 10:50:49', '2026-02-21 10:50:49'),
(1076, '7', NULL, 'Consultation 7 ✅', 'Consultation 7 effectuée avec succès.', 'réussi', '2026-02-21 10:53:39', NULL, '2026-02-21 10:53:39', '2026-02-21 10:53:39'),
(1077, 'notification_track?userId=7&search=&page=1&pageSize=20&paginate=true', NULL, 'Consultation notification_track?userId=7&search=&page=1&pageSize=20&paginate=true ✅', 'Consultation notification_track?userId=7&search=&page=1&pageSize=20&paginate=true effectuée avec succès.', 'réussi', '2026-02-21 10:53:46', NULL, '2026-02-21 10:53:46', '2026-02-21 10:53:46'),
(1078, 'users?search=&page=1&pageSize=20&paginate=true', NULL, 'Consultation users?search=&page=1&pageSize=20&paginate=true ✅', 'Consultation users?search=&page=1&pageSize=20&paginate=true effectuée avec succès.', 'réussi', '2026-02-21 10:53:55', NULL, '2026-02-21 10:53:55', '2026-02-21 10:53:55'),
(1079, 'users?search=user_4ekko&page=1&pageSize=20&paginate=true', NULL, 'Consultation users?search=user_4ekko&page=1&pageSize=20&paginate=true ✅', 'Consultation users?search=user_4ekko&page=1&pageSize=20&paginate=true effectuée avec succès.', 'réussi', '2026-02-21 10:54:03', NULL, '2026-02-21 10:54:03', '2026-02-21 10:54:03'),
(1080, 'Transfert', 10, NULL, 'Transfert à user_4ekko', 'réussi', '2026-02-21 10:54:16', NULL, '2026-02-21 10:54:16', '2026-02-21 10:54:16'),
(1081, 'transfert', NULL, 'Création transfert ✅', 'Création transfert effectuée avec succès.', 'réussi', '2026-02-21 10:54:16', NULL, '2026-02-21 10:54:16', '2026-02-21 10:54:16'),
(1082, '7', NULL, 'Consultation 7 ✅', 'Consultation 7 effectuée avec succès.', 'réussi', '2026-02-21 10:54:21', NULL, '2026-02-21 10:54:21', '2026-02-21 10:54:21');
INSERT INTO `histories` (`historyId`, `type`, `amount`, `action`, `description`, `status`, `date`, `userId`, `createdAt`, `updatedAt`) VALUES
(1083, 'notification_track?userId=7&search=&page=1&pageSize=20&paginate=true', NULL, 'Consultation notification_track?userId=7&search=&page=1&pageSize=20&paginate=true ❌', 'Échec lors de consultation notification_track?userid=7&search=&page=1&pagesize=20&paginate=true.', 'réussi', '2026-02-21 10:54:25', NULL, '2026-02-21 10:54:25', '2026-02-21 10:54:25'),
(1084, 'notification_track?userId=7&search=&page=1&pageSize=20&paginate=true', NULL, 'Consultation notification_track?userId=7&search=&page=1&pageSize=20&paginate=true ❌', 'Échec lors de consultation notification_track?userid=7&search=&page=1&pagesize=20&paginate=true.', 'réussi', '2026-02-21 10:54:27', NULL, '2026-02-21 10:54:27', '2026-02-21 10:54:27'),
(1085, 'notification_track?userId=7&search=&page=1&pageSize=20&paginate=true', NULL, 'Consultation notification_track?userId=7&search=&page=1&pageSize=20&paginate=true ❌', 'Échec lors de consultation notification_track?userid=7&search=&page=1&pagesize=20&paginate=true.', 'réussi', '2026-02-21 10:55:45', NULL, '2026-02-21 10:55:45', '2026-02-21 10:55:45'),
(1086, 'product?page=1&pageSize=10&search=&paginate=true&companyId=9', NULL, 'Consultation product?page=1&pageSize=10&search=&paginate=true&companyId=9 ❌', 'Échec lors de consultation product?page=1&pagesize=10&search=&paginate=true&companyid=9.', 'réussi', '2026-02-21 10:56:05', NULL, '2026-02-21 10:56:05', '2026-02-21 10:56:05'),
(1087, 'Paiement', 1, NULL, 'Paiement commande ORD-1771671376699', 'réussi', '2026-02-21 10:56:16', NULL, '2026-02-21 10:56:16', '2026-02-21 10:56:16'),
(1088, 'Paiement', 1, NULL, 'Réception paiement commande ORD-1771671376699', 'réussi', '2026-02-21 10:56:16', NULL, '2026-02-21 10:56:16', '2026-02-21 10:56:16'),
(1089, 'paiement', NULL, 'Création paiement ✅', 'Création paiement effectuée avec succès.', 'réussi', '2026-02-21 10:56:19', NULL, '2026-02-21 10:56:19', '2026-02-21 10:56:19'),
(1090, '7', NULL, 'Consultation 7 ✅', 'Consultation 7 effectuée avec succès.', 'réussi', '2026-02-21 10:56:22', NULL, '2026-02-21 10:56:22', '2026-02-21 10:56:22'),
(1091, 'notification_track?userId=7&search=&page=1&pageSize=20&paginate=true', NULL, 'Consultation notification_track?userId=7&search=&page=1&pageSize=20&paginate=true ❌', 'Échec lors de consultation notification_track?userid=7&search=&page=1&pagesize=20&paginate=true.', 'réussi', '2026-02-21 10:56:26', NULL, '2026-02-21 10:56:26', '2026-02-21 10:56:26'),
(1092, 'notification_track?userId=7&search=&page=1&pageSize=20&paginate=true', NULL, 'Consultation notification_track?userId=7&search=&page=1&pageSize=20&paginate=true ❌', 'Échec lors de consultation notification_track?userid=7&search=&page=1&pagesize=20&paginate=true.', 'réussi', '2026-02-21 10:56:27', NULL, '2026-02-21 10:56:27', '2026-02-21 10:56:27'),
(1093, 'notification_track?userId=7&search=&page=1&pageSize=20&paginate=true', NULL, 'Consultation notification_track?userId=7&search=&page=1&pageSize=20&paginate=true ❌', 'Échec lors de consultation notification_track?userid=7&search=&page=1&pagesize=20&paginate=true.', 'réussi', '2026-02-21 10:56:28', NULL, '2026-02-21 10:56:28', '2026-02-21 10:56:28'),
(1094, 'sector?page=1&pageSize=20&search=&paginate=false', NULL, 'Consultation sector?page=1&pageSize=20&search=&paginate=false ❌', 'Échec lors de consultation sector?page=1&pagesize=20&search=&paginate=false.', 'réussi', '2026-02-21 11:01:44', NULL, '2026-02-21 11:01:44', '2026-02-21 11:01:44'),
(1095, '7', NULL, 'Consultation 7 ❌', 'Échec lors de consultation 7.', 'réussi', '2026-02-21 11:01:44', NULL, '2026-02-21 11:01:44', '2026-02-21 11:01:44'),
(1096, 'product?page=1&pageSize=10&search=&paginate=true&companyId=11', NULL, 'Consultation product?page=1&pageSize=10&search=&paginate=true&companyId=11 ❌', 'Échec lors de consultation product?page=1&pagesize=10&search=&paginate=true&companyid=11.', 'réussi', '2026-02-21 11:02:42', NULL, '2026-02-21 11:02:42', '2026-02-21 11:02:42'),
(1097, 'Paiement', 10, NULL, 'Paiement commande ORD-1771671772799', 'réussi', '2026-02-21 11:02:52', NULL, '2026-02-21 11:02:52', '2026-02-21 11:02:52'),
(1098, 'Paiement', 10, NULL, 'Réception paiement commande ORD-1771671772799', 'réussi', '2026-02-21 11:02:52', NULL, '2026-02-21 11:02:52', '2026-02-21 11:02:52'),
(1099, 'paiement', NULL, 'Création paiement ✅', 'Création paiement effectuée avec succès.', 'réussi', '2026-02-21 11:02:55', NULL, '2026-02-21 11:02:55', '2026-02-21 11:02:55'),
(1100, '7', NULL, 'Consultation 7 ✅', 'Consultation 7 effectuée avec succès.', 'réussi', '2026-02-21 11:02:58', NULL, '2026-02-21 11:02:58', '2026-02-21 11:02:58'),
(1101, 'notification_track?userId=7&search=&page=1&pageSize=20&paginate=true', NULL, 'Consultation notification_track?userId=7&search=&page=1&pageSize=20&paginate=true ❌', 'Échec lors de consultation notification_track?userid=7&search=&page=1&pagesize=20&paginate=true.', 'réussi', '2026-02-21 11:04:17', NULL, '2026-02-21 11:04:17', '2026-02-21 11:04:17'),
(1102, 'notification_track?userId=7&search=&page=1&pageSize=20&paginate=true', NULL, 'Consultation notification_track?userId=7&search=&page=1&pageSize=20&paginate=true ❌', 'Échec lors de consultation notification_track?userid=7&search=&page=1&pagesize=20&paginate=true.', 'réussi', '2026-02-21 11:04:18', NULL, '2026-02-21 11:04:18', '2026-02-21 11:04:18'),
(1103, 'notification_track?commerceId=1&userId=2', NULL, 'Consultation notification_track?commerceId=1&userId=2 ✅', 'Consultation notification_track?commerceId=1&userId=2 effectuée avec succès.', 'réussi', '2026-02-21 14:59:57', NULL, '2026-02-21 14:59:57', '2026-02-21 14:59:57'),
(1104, 'notification_track?userId=2&paginate=true', NULL, 'Consultation notification_track?userId=2&paginate=true ✅', 'Consultation notification_track?userId=2&paginate=true effectuée avec succès.', 'réussi', '2026-02-21 15:00:37', NULL, '2026-02-21 15:00:37', '2026-02-21 15:00:37'),
(1105, 'notification_track?userId=1&paginate=true', NULL, 'Consultation notification_track?userId=1&paginate=true ✅', 'Consultation notification_track?userId=1&paginate=true effectuée avec succès.', 'réussi', '2026-02-21 15:00:45', NULL, '2026-02-21 15:00:45', '2026-02-21 15:00:45'),
(1106, 'create', NULL, 'Création create ❌', 'Échec lors de création create.', 'réussi', '2026-02-21 15:02:03', NULL, '2026-02-21 15:02:03', '2026-02-21 15:02:03'),
(1107, 'create', NULL, 'Création create ❌', 'Échec lors de création create.', 'réussi', '2026-02-21 15:02:47', NULL, '2026-02-21 15:02:47', '2026-02-21 15:02:47'),
(1108, 'create', NULL, 'Création create ✅', 'Création create effectuée avec succès.', 'réussi', '2026-02-21 15:03:23', NULL, '2026-02-21 15:03:23', '2026-02-21 15:03:23'),
(1109, 'notification_track?userId=7&paginate=true', NULL, 'Consultation notification_track?userId=7&paginate=true ✅', 'Consultation notification_track?userId=7&paginate=true effectuée avec succès.', 'réussi', '2026-02-21 15:06:31', NULL, '2026-02-21 15:06:31', '2026-02-21 15:06:31'),
(1110, 'create', NULL, 'Création create ✅', 'Création create effectuée avec succès.', 'réussi', '2026-02-21 15:07:22', NULL, '2026-02-21 15:07:22', '2026-02-21 15:07:22'),
(1111, 'notification_track?userId=7&paginate=true', NULL, 'Consultation notification_track?userId=7&paginate=true ✅', 'Consultation notification_track?userId=7&paginate=true effectuée avec succès.', 'réussi', '2026-02-21 15:07:31', NULL, '2026-02-21 15:07:31', '2026-02-21 15:07:31'),
(1112, 'Transfert', 10, NULL, 'Transfert à Jerry', 'réussi', '2026-02-21 15:08:49', NULL, '2026-02-21 15:08:49', '2026-02-21 15:08:49'),
(1113, 'transfert', NULL, 'Création transfert ✅', 'Création transfert effectuée avec succès.', 'réussi', '2026-02-21 15:08:49', NULL, '2026-02-21 15:08:49', '2026-02-21 15:08:49'),
(1114, 'retrait', NULL, 'Création retrait ❌', 'Échec lors de création retrait.', 'réussi', '2026-02-21 15:10:44', NULL, '2026-02-21 15:10:44', '2026-02-21 15:10:44'),
(1115, 'Retrait', 5, NULL, 'Retrait effectué', 'réussi', '2026-02-21 15:16:36', NULL, '2026-02-21 15:16:36', '2026-02-21 15:16:36'),
(1116, 'Retrait', 5, NULL, 'Retrait client reçu', 'réussi', '2026-02-21 15:16:36', NULL, '2026-02-21 15:16:36', '2026-02-21 15:16:36'),
(1117, 'Retrait', 0.14925, NULL, 'Frais retrait reçu', 'réussi', '2026-02-21 15:16:36', NULL, '2026-02-21 15:16:36', '2026-02-21 15:16:36'),
(1118, 'retrait', NULL, 'Création retrait ✅', 'Création retrait effectuée avec succès.', 'réussi', '2026-02-21 15:16:38', NULL, '2026-02-21 15:16:38', '2026-02-21 15:16:38'),
(1119, 'retrait', NULL, 'Création retrait ❌', 'Échec lors de création retrait.', 'réussi', '2026-02-21 15:28:25', NULL, '2026-02-21 15:28:25', '2026-02-21 15:28:25'),
(1120, 'Retrait', 5, NULL, 'Retrait effectué', 'réussi', '2026-02-21 15:28:49', 7, '2026-02-21 15:28:49', '2026-02-21 15:28:49'),
(1121, 'Retrait', 5, NULL, 'Retrait client reçu', 'réussi', '2026-02-21 15:28:49', 10, '2026-02-21 15:28:49', '2026-02-21 15:28:49'),
(1122, 'Retrait', 0.14925, NULL, 'Frais retrait reçu', 'réussi', '2026-02-21 15:28:49', 2, '2026-02-21 15:28:49', '2026-02-21 15:28:49'),
(1123, 'retrait', NULL, 'Création retrait ✅', 'Création retrait effectuée avec succès.', 'réussi', '2026-02-21 15:28:51', NULL, '2026-02-21 15:28:51', '2026-02-21 15:28:51'),
(1124, 'notification_track?userId=7&paginate=true', NULL, 'Consultation notification_track?userId=7&paginate=true ✅', 'Consultation notification_track?userId=7&paginate=true effectuée avec succès.', 'réussi', '2026-02-21 15:30:34', NULL, '2026-02-21 15:30:34', '2026-02-21 15:30:34'),
(1125, 'Retrait', 5, NULL, 'Retrait effectué', 'réussi', '2026-02-21 15:32:16', 7, '2026-02-21 15:32:16', '2026-02-21 15:32:16'),
(1126, 'Retrait', 5, NULL, 'Retrait client reçu', 'réussi', '2026-02-21 15:32:16', 10, '2026-02-21 15:32:16', '2026-02-21 15:32:16'),
(1127, 'Retrait', 0.14925, NULL, 'Frais retrait reçu', 'réussi', '2026-02-21 15:32:16', 2, '2026-02-21 15:32:16', '2026-02-21 15:32:16'),
(1128, 'retrait', NULL, 'Création retrait ✅', 'Création retrait effectuée avec succès.', 'réussi', '2026-02-21 15:32:18', NULL, '2026-02-21 15:32:18', '2026-02-21 15:32:18'),
(1129, 'retrait', NULL, 'Création retrait ❌', 'Échec lors de création retrait.', 'réussi', '2026-02-21 15:34:40', NULL, '2026-02-21 15:34:40', '2026-02-21 15:34:40'),
(1130, 'recharge', NULL, 'Création recharge ✅', 'Création recharge effectuée avec succès.', 'réussi', '2026-02-21 15:41:46', NULL, '2026-02-21 15:41:46', '2026-02-21 15:41:46'),
(1131, 'recharge', NULL, 'Création recharge ✅', 'Création recharge effectuée avec succès.', 'réussi', '2026-02-21 15:46:30', NULL, '2026-02-21 15:46:30', '2026-02-21 15:46:30'),
(1132, '7', NULL, 'Consultation 7 ✅', 'Consultation 7 effectuée avec succès.', 'réussi', '2026-02-22 07:47:22', NULL, '2026-02-22 07:47:22', '2026-02-22 07:47:22'),
(1133, 'sector?page=1&pageSize=20&search=&paginate=false', NULL, 'Consultation sector?page=1&pageSize=20&search=&paginate=false ✅', 'Consultation sector?page=1&pageSize=20&search=&paginate=false effectuée avec succès.', 'réussi', '2026-02-22 08:22:06', NULL, '2026-02-22 08:22:06', '2026-02-22 08:22:06'),
(1134, '7', NULL, 'Consultation 7 ❌', 'Échec lors de consultation 7.', 'réussi', '2026-02-22 08:22:06', NULL, '2026-02-22 08:22:06', '2026-02-22 08:22:06'),
(1135, '7', NULL, 'Consultation 7 ❌', 'Échec lors de consultation 7.', 'réussi', '2026-02-22 08:31:43', NULL, '2026-02-22 08:31:43', '2026-02-22 08:31:43'),
(1136, 'sector?page=1&pageSize=20&search=&paginate=false', NULL, 'Consultation sector?page=1&pageSize=20&search=&paginate=false ❌', 'Échec lors de consultation sector?page=1&pagesize=20&search=&paginate=false.', 'réussi', '2026-02-22 08:31:43', NULL, '2026-02-22 08:31:43', '2026-02-22 08:31:43'),
(1137, 'sector?page=1&pageSize=20&search=&paginate=false', NULL, 'Consultation sector?page=1&pageSize=20&search=&paginate=false ❌', 'Échec lors de consultation sector?page=1&pagesize=20&search=&paginate=false.', 'réussi', '2026-02-22 08:38:24', NULL, '2026-02-22 08:38:24', '2026-02-22 08:38:24'),
(1138, '7', NULL, 'Consultation 7 ❌', 'Échec lors de consultation 7.', 'réussi', '2026-02-22 08:38:24', NULL, '2026-02-22 08:38:24', '2026-02-22 08:38:24'),
(1139, '7', NULL, 'Consultation 7 ❌', 'Échec lors de consultation 7.', 'réussi', '2026-02-22 08:46:53', NULL, '2026-02-22 08:46:53', '2026-02-22 08:46:53'),
(1140, 'sector?page=1&pageSize=20&search=&paginate=false', NULL, 'Consultation sector?page=1&pageSize=20&search=&paginate=false ❌', 'Échec lors de consultation sector?page=1&pagesize=20&search=&paginate=false.', 'réussi', '2026-02-22 08:46:53', NULL, '2026-02-22 08:46:53', '2026-02-22 08:46:53'),
(1141, '7', NULL, 'Consultation 7 ✅', 'Consultation 7 effectuée avec succès.', 'réussi', '2026-02-22 09:05:17', NULL, '2026-02-22 09:05:17', '2026-02-22 09:05:17'),
(1142, 'sector?page=1&pageSize=20&search=&paginate=false', NULL, 'Consultation sector?page=1&pageSize=20&search=&paginate=false ✅', 'Consultation sector?page=1&pageSize=20&search=&paginate=false effectuée avec succès.', 'réussi', '2026-02-22 09:06:09', NULL, '2026-02-22 09:06:09', '2026-02-22 09:06:09'),
(1143, '7', NULL, 'Consultation 7 ❌', 'Échec lors de consultation 7.', 'réussi', '2026-02-22 09:06:09', NULL, '2026-02-22 09:06:09', '2026-02-22 09:06:09'),
(1144, '7', NULL, 'Consultation 7 ❌', 'Échec lors de consultation 7.', 'réussi', '2026-02-22 09:42:01', NULL, '2026-02-22 09:42:01', '2026-02-22 09:42:01'),
(1145, 'sector?page=1&pageSize=20&search=&paginate=false', NULL, 'Consultation sector?page=1&pageSize=20&search=&paginate=false ❌', 'Échec lors de consultation sector?page=1&pagesize=20&search=&paginate=false.', 'réussi', '2026-02-22 09:42:01', NULL, '2026-02-22 09:42:01', '2026-02-22 09:42:01'),
(1146, 'sector?page=1&pageSize=20&search=&paginate=false', NULL, 'Consultation sector?page=1&pageSize=20&search=&paginate=false ❌', 'Échec lors de consultation sector?page=1&pagesize=20&search=&paginate=false.', 'réussi', '2026-02-22 09:59:08', NULL, '2026-02-22 09:59:08', '2026-02-22 09:59:08'),
(1147, '7', NULL, 'Consultation 7 ❌', 'Échec lors de consultation 7.', 'réussi', '2026-02-22 09:59:08', NULL, '2026-02-22 09:59:08', '2026-02-22 09:59:08'),
(1148, '7', NULL, 'Consultation 7 ✅', 'Consultation 7 effectuée avec succès.', 'réussi', '2026-02-22 10:11:40', NULL, '2026-02-22 10:11:40', '2026-02-22 10:11:40'),
(1149, '7', NULL, 'Consultation 7 ❌', 'Échec lors de consultation 7.', 'réussi', '2026-02-22 10:23:01', NULL, '2026-02-22 10:23:01', '2026-02-22 10:23:01'),
(1150, 'sector?page=1&pageSize=20&search=&paginate=false', NULL, 'Consultation sector?page=1&pageSize=20&search=&paginate=false ✅', 'Consultation sector?page=1&pageSize=20&search=&paginate=false effectuée avec succès.', 'réussi', '2026-02-22 10:23:01', NULL, '2026-02-22 10:23:01', '2026-02-22 10:23:01'),
(1151, '7', NULL, 'Consultation 7 ❌', 'Échec lors de consultation 7.', 'réussi', '2026-02-22 10:38:19', NULL, '2026-02-22 10:38:19', '2026-02-22 10:38:19'),
(1152, 'sector?page=1&pageSize=20&search=&paginate=false', NULL, 'Consultation sector?page=1&pageSize=20&search=&paginate=false ❌', 'Échec lors de consultation sector?page=1&pagesize=20&search=&paginate=false.', 'réussi', '2026-02-22 10:38:19', NULL, '2026-02-22 10:38:19', '2026-02-22 10:38:19'),
(1153, 'sector?page=1&pageSize=20&search=&paginate=false', NULL, 'Consultation sector?page=1&pageSize=20&search=&paginate=false ❌', 'Échec lors de consultation sector?page=1&pagesize=20&search=&paginate=false.', 'réussi', '2026-02-22 10:43:11', NULL, '2026-02-22 10:43:11', '2026-02-22 10:43:11'),
(1154, '7', NULL, 'Consultation 7 ❌', 'Échec lors de consultation 7.', 'réussi', '2026-02-22 10:43:11', NULL, '2026-02-22 10:43:11', '2026-02-22 10:43:11'),
(1155, 'sector?page=1&pageSize=20&search=&paginate=false', NULL, 'Consultation sector?page=1&pageSize=20&search=&paginate=false ❌', 'Échec lors de consultation sector?page=1&pagesize=20&search=&paginate=false.', 'réussi', '2026-02-22 10:44:06', NULL, '2026-02-22 10:44:06', '2026-02-22 10:44:06'),
(1156, '7', NULL, 'Consultation 7 ❌', 'Échec lors de consultation 7.', 'réussi', '2026-02-22 10:44:06', NULL, '2026-02-22 10:44:06', '2026-02-22 10:44:06'),
(1157, '7', NULL, 'Consultation 7 ✅', 'Consultation 7 effectuée avec succès.', 'réussi', '2026-02-22 11:20:31', NULL, '2026-02-22 11:20:31', '2026-02-22 11:20:31'),
(1158, 'notification_track?userId=7&search=&page=1&pageSize=20&paginate=true', NULL, 'Consultation notification_track?userId=7&search=&page=1&pageSize=20&paginate=true ✅', 'Consultation notification_track?userId=7&search=&page=1&pageSize=20&paginate=true effectuée avec succès.', 'réussi', '2026-02-22 11:20:46', NULL, '2026-02-22 11:20:46', '2026-02-22 11:20:46'),
(1159, 'sector?page=1&pageSize=10&search=&paginate=true', NULL, 'Consultation sector?page=1&pageSize=10&search=&paginate=true ❌', 'Échec lors de consultation sector?page=1&pagesize=10&search=&paginate=true.', 'réussi', '2026-02-22 11:21:14', NULL, '2026-02-22 11:21:14', '2026-02-22 11:21:14'),
(1160, 'sector?page=2&pageSize=10&search=&paginate=true', NULL, 'Consultation sector?page=2&pageSize=10&search=&paginate=true ❌', 'Échec lors de consultation sector?page=2&pagesize=10&search=&paginate=true.', 'réussi', '2026-02-22 11:21:16', NULL, '2026-02-22 11:21:16', '2026-02-22 11:21:16'),
(1161, 'tsx?id=7&page=1&pageSize=10&paginate=true', NULL, 'Consultation tsx?id=7&page=1&pageSize=10&paginate=true ✅', 'Consultation tsx?id=7&page=1&pageSize=10&paginate=true effectuée avec succès.', 'réussi', '2026-02-22 11:21:18', NULL, '2026-02-22 11:21:18', '2026-02-22 11:21:18'),
(1162, 'tsx?page=1&pageSize=1000&paginate=true', NULL, 'Consultation tsx?page=1&pageSize=1000&paginate=true ✅', 'Consultation tsx?page=1&pageSize=1000&paginate=true effectuée avec succès.', 'réussi', '2026-02-22 11:21:23', NULL, '2026-02-22 11:21:23', '2026-02-22 11:21:23'),
(1163, 'notification_track?userId=7&search=&page=1&pageSize=20&paginate=true', NULL, 'Consultation notification_track?userId=7&search=&page=1&pageSize=20&paginate=true ❌', 'Échec lors de consultation notification_track?userid=7&search=&page=1&pagesize=20&paginate=true.', 'réussi', '2026-02-22 11:26:41', NULL, '2026-02-22 11:26:41', '2026-02-22 11:26:41'),
(1164, 'notification_track?userId=7&search=&page=1&pageSize=20&paginate=true', NULL, 'Consultation notification_track?userId=7&search=&page=1&pageSize=20&paginate=true ❌', 'Échec lors de consultation notification_track?userid=7&search=&page=1&pagesize=20&paginate=true.', 'réussi', '2026-02-22 11:26:52', NULL, '2026-02-22 11:26:52', '2026-02-22 11:26:52'),
(1165, 'notification_track?userId=7&search=&page=1&pageSize=20&paginate=true', NULL, 'Consultation notification_track?userId=7&search=&page=1&pageSize=20&paginate=true ❌', 'Échec lors de consultation notification_track?userid=7&search=&page=1&pagesize=20&paginate=true.', 'réussi', '2026-02-22 11:29:59', NULL, '2026-02-22 11:29:59', '2026-02-22 11:29:59'),
(1166, 'notification_track?userId=7&search=&page=1&pageSize=20&paginate=true', NULL, 'Consultation notification_track?userId=7&search=&page=1&pageSize=20&paginate=true ❌', 'Échec lors de consultation notification_track?userid=7&search=&page=1&pagesize=20&paginate=true.', 'réussi', '2026-02-22 11:31:42', NULL, '2026-02-22 11:31:42', '2026-02-22 11:31:42'),
(1167, 'notification_track?userId=7&search=&page=1&pageSize=20&paginate=true', NULL, 'Consultation notification_track?userId=7&search=&page=1&pageSize=20&paginate=true ❌', 'Échec lors de consultation notification_track?userid=7&search=&page=1&pagesize=20&paginate=true.', 'réussi', '2026-02-22 11:36:22', NULL, '2026-02-22 11:36:22', '2026-02-22 11:36:22'),
(1168, 'notification_track?userId=7&search=&page=1&pageSize=20&paginate=true', NULL, 'Consultation notification_track?userId=7&search=&page=1&pageSize=20&paginate=true ❌', 'Échec lors de consultation notification_track?userid=7&search=&page=1&pagesize=20&paginate=true.', 'réussi', '2026-02-22 11:36:28', NULL, '2026-02-22 11:36:28', '2026-02-22 11:36:28'),
(1169, 'sector?page=1&pageSize=20&search=&paginate=false', NULL, 'Consultation sector?page=1&pageSize=20&search=&paginate=false ❌', 'Échec lors de consultation sector?page=1&pagesize=20&search=&paginate=false.', 'réussi', '2026-02-22 11:45:26', NULL, '2026-02-22 11:45:26', '2026-02-22 11:45:26'),
(1170, '7', NULL, 'Consultation 7 ❌', 'Échec lors de consultation 7.', 'réussi', '2026-02-22 11:45:26', NULL, '2026-02-22 11:45:26', '2026-02-22 11:45:26'),
(1171, 'notification_track?userId=7&search=&page=1&pageSize=20&paginate=true', NULL, 'Consultation notification_track?userId=7&search=&page=1&pageSize=20&paginate=true ❌', 'Échec lors de consultation notification_track?userid=7&search=&page=1&pagesize=20&paginate=true.', 'réussi', '2026-02-22 11:47:19', NULL, '2026-02-22 11:47:19', '2026-02-22 11:47:19'),
(1172, 'sector?page=1&pageSize=20&search=&paginate=false', NULL, 'Consultation sector?page=1&pageSize=20&search=&paginate=false ❌', 'Échec lors de consultation sector?page=1&pagesize=20&search=&paginate=false.', 'réussi', '2026-02-22 11:48:19', NULL, '2026-02-22 11:48:19', '2026-02-22 11:48:19'),
(1173, '7', NULL, 'Consultation 7 ✅', 'Consultation 7 effectuée avec succès.', 'réussi', '2026-02-22 11:48:19', NULL, '2026-02-22 11:48:19', '2026-02-22 11:48:19'),
(1174, 'sector?page=1&pageSize=20&search=&paginate=false', NULL, 'Consultation sector?page=1&pageSize=20&search=&paginate=false ❌', 'Échec lors de consultation sector?page=1&pagesize=20&search=&paginate=false.', 'réussi', '2026-02-22 11:48:22', NULL, '2026-02-22 11:48:22', '2026-02-22 11:48:22'),
(1175, '7', NULL, 'Consultation 7 ❌', 'Échec lors de consultation 7.', 'réussi', '2026-02-22 11:48:22', NULL, '2026-02-22 11:48:22', '2026-02-22 11:48:22'),
(1176, 'notification_track?userId=7&search=&page=1&pageSize=20&paginate=true', NULL, 'Consultation notification_track?userId=7&search=&page=1&pageSize=20&paginate=true ❌', 'Échec lors de consultation notification_track?userid=7&search=&page=1&pagesize=20&paginate=true.', 'réussi', '2026-02-22 11:48:55', NULL, '2026-02-22 11:48:55', '2026-02-22 11:48:55'),
(1177, 'sector?page=1&pageSize=20&search=&paginate=false', NULL, 'Consultation sector?page=1&pageSize=20&search=&paginate=false ❌', 'Échec lors de consultation sector?page=1&pagesize=20&search=&paginate=false.', 'réussi', '2026-02-22 11:49:36', NULL, '2026-02-22 11:49:36', '2026-02-22 11:49:36'),
(1178, '7', NULL, 'Consultation 7 ✅', 'Consultation 7 effectuée avec succès.', 'réussi', '2026-02-22 11:49:36', NULL, '2026-02-22 11:49:36', '2026-02-22 11:49:36'),
(1179, 'sector?page=1&pageSize=10&search=&paginate=true', NULL, 'Consultation sector?page=1&pageSize=10&search=&paginate=true ❌', 'Échec lors de consultation sector?page=1&pagesize=10&search=&paginate=true.', 'réussi', '2026-02-22 11:54:44', NULL, '2026-02-22 11:54:44', '2026-02-22 11:54:44'),
(1180, 'tsx?id=7&page=1&pageSize=10&paginate=true', NULL, 'Consultation tsx?id=7&page=1&pageSize=10&paginate=true ❌', 'Échec lors de consultation tsx?id=7&page=1&pagesize=10&paginate=true.', 'réussi', '2026-02-22 11:54:46', NULL, '2026-02-22 11:54:46', '2026-02-22 11:54:46'),
(1181, 'tsx?page=1&pageSize=1000&paginate=true', NULL, 'Consultation tsx?page=1&pageSize=1000&paginate=true ❌', 'Échec lors de consultation tsx?page=1&pagesize=1000&paginate=true.', 'réussi', '2026-02-22 11:54:47', NULL, '2026-02-22 11:54:47', '2026-02-22 11:54:47'),
(1182, 'notification_track?userId=7&search=&page=1&pageSize=20&paginate=true', NULL, 'Consultation notification_track?userId=7&search=&page=1&pageSize=20&paginate=true ❌', 'Échec lors de consultation notification_track?userid=7&search=&page=1&pagesize=20&paginate=true.', 'réussi', '2026-02-22 11:54:56', NULL, '2026-02-22 11:54:56', '2026-02-22 11:54:56'),
(1183, 'sector?page=1&pageSize=20&search=&paginate=false', NULL, 'Consultation sector?page=1&pageSize=20&search=&paginate=false ❌', 'Échec lors de consultation sector?page=1&pagesize=20&search=&paginate=false.', 'réussi', '2026-02-22 12:06:16', NULL, '2026-02-22 12:06:16', '2026-02-22 12:06:16'),
(1184, '7', NULL, 'Consultation 7 ✅', 'Consultation 7 effectuée avec succès.', 'réussi', '2026-02-22 12:06:16', NULL, '2026-02-22 12:06:16', '2026-02-22 12:06:16'),
(1185, 'tsx?page=1&pageSize=1000&paginate=true', NULL, 'Consultation tsx?page=1&pageSize=1000&paginate=true ❌', 'Échec lors de consultation tsx?page=1&pagesize=1000&paginate=true.', 'réussi', '2026-02-22 12:06:42', NULL, '2026-02-22 12:06:42', '2026-02-22 12:06:42'),
(1186, 'tsx?id=7&page=1&pageSize=10&paginate=true', NULL, 'Consultation tsx?id=7&page=1&pageSize=10&paginate=true ❌', 'Échec lors de consultation tsx?id=7&page=1&pagesize=10&paginate=true.', 'réussi', '2026-02-22 12:06:57', NULL, '2026-02-22 12:06:57', '2026-02-22 12:06:57'),
(1187, 'sector?page=1&pageSize=10&search=&paginate=true', NULL, 'Consultation sector?page=1&pageSize=10&search=&paginate=true ❌', 'Échec lors de consultation sector?page=1&pagesize=10&search=&paginate=true.', 'réussi', '2026-02-22 12:07:17', NULL, '2026-02-22 12:07:17', '2026-02-22 12:07:17'),
(1188, 'sector?page=1&pageSize=20&search=&paginate=false', NULL, 'Consultation sector?page=1&pageSize=20&search=&paginate=false ❌', 'Échec lors de consultation sector?page=1&pagesize=20&search=&paginate=false.', 'réussi', '2026-02-22 12:07:19', NULL, '2026-02-22 12:07:19', '2026-02-22 12:07:19'),
(1189, '7', NULL, 'Consultation 7 ✅', 'Consultation 7 effectuée avec succès.', 'réussi', '2026-02-22 12:07:19', NULL, '2026-02-22 12:07:19', '2026-02-22 12:07:19'),
(1190, 'sector?page=1&pageSize=20&search=&paginate=false', NULL, 'Consultation sector?page=1&pageSize=20&search=&paginate=false ❌', 'Échec lors de consultation sector?page=1&pagesize=20&search=&paginate=false.', 'réussi', '2026-02-22 12:07:27', NULL, '2026-02-22 12:07:27', '2026-02-22 12:07:27'),
(1191, '7', NULL, 'Consultation 7 ❌', 'Échec lors de consultation 7.', 'réussi', '2026-02-22 12:07:27', NULL, '2026-02-22 12:07:27', '2026-02-22 12:07:27'),
(1192, 'tsx?id=7&page=1&pageSize=10&paginate=true', NULL, 'Consultation tsx?id=7&page=1&pageSize=10&paginate=true ❌', 'Échec lors de consultation tsx?id=7&page=1&pagesize=10&paginate=true.', 'réussi', '2026-02-22 12:07:53', NULL, '2026-02-22 12:07:53', '2026-02-22 12:07:53'),
(1193, 'sector?page=1&pageSize=20&search=&paginate=false', NULL, 'Consultation sector?page=1&pageSize=20&search=&paginate=false ❌', 'Échec lors de consultation sector?page=1&pagesize=20&search=&paginate=false.', 'réussi', '2026-02-22 12:09:40', NULL, '2026-02-22 12:09:40', '2026-02-22 12:09:40'),
(1194, '7', NULL, 'Consultation 7 ✅', 'Consultation 7 effectuée avec succès.', 'réussi', '2026-02-22 12:09:40', NULL, '2026-02-22 12:09:40', '2026-02-22 12:09:40'),
(1195, '7', NULL, 'Consultation 7 ❌', 'Échec lors de consultation 7.', 'réussi', '2026-02-22 12:10:02', NULL, '2026-02-22 12:10:02', '2026-02-22 12:10:02'),
(1196, 'sector?page=1&pageSize=20&search=&paginate=false', NULL, 'Consultation sector?page=1&pageSize=20&search=&paginate=false ❌', 'Échec lors de consultation sector?page=1&pagesize=20&search=&paginate=false.', 'réussi', '2026-02-22 12:10:02', NULL, '2026-02-22 12:10:02', '2026-02-22 12:10:02'),
(1197, 'sector?page=1&pageSize=10&search=&paginate=true', NULL, 'Consultation sector?page=1&pageSize=10&search=&paginate=true ❌', 'Échec lors de consultation sector?page=1&pagesize=10&search=&paginate=true.', 'réussi', '2026-02-22 12:10:34', NULL, '2026-02-22 12:10:34', '2026-02-22 12:10:34'),
(1198, 'tsx?id=7&page=1&pageSize=10&paginate=true', NULL, 'Consultation tsx?id=7&page=1&pageSize=10&paginate=true ❌', 'Échec lors de consultation tsx?id=7&page=1&pagesize=10&paginate=true.', 'réussi', '2026-02-22 12:10:36', NULL, '2026-02-22 12:10:36', '2026-02-22 12:10:36'),
(1199, 'tsx?page=1&pageSize=1000&paginate=true', NULL, 'Consultation tsx?page=1&pageSize=1000&paginate=true ❌', 'Échec lors de consultation tsx?page=1&pagesize=1000&paginate=true.', 'réussi', '2026-02-22 12:10:37', NULL, '2026-02-22 12:10:37', '2026-02-22 12:10:37'),
(1200, 'sector?page=1&pageSize=20&search=&paginate=false', NULL, 'Consultation sector?page=1&pageSize=20&search=&paginate=false ❌', 'Échec lors de consultation sector?page=1&pagesize=20&search=&paginate=false.', 'réussi', '2026-02-22 12:10:55', NULL, '2026-02-22 12:10:55', '2026-02-22 12:10:55'),
(1201, '7', NULL, 'Consultation 7 ✅', 'Consultation 7 effectuée avec succès.', 'réussi', '2026-02-22 12:10:55', NULL, '2026-02-22 12:10:55', '2026-02-22 12:10:55'),
(1202, 'sector?page=1&pageSize=10&search=&paginate=true', NULL, 'Consultation sector?page=1&pageSize=10&search=&paginate=true ❌', 'Échec lors de consultation sector?page=1&pagesize=10&search=&paginate=true.', 'réussi', '2026-02-22 12:11:23', NULL, '2026-02-22 12:11:23', '2026-02-22 12:11:23'),
(1203, 'tsx?id=7&page=1&pageSize=10&paginate=true', NULL, 'Consultation tsx?id=7&page=1&pageSize=10&paginate=true ❌', 'Échec lors de consultation tsx?id=7&page=1&pagesize=10&paginate=true.', 'réussi', '2026-02-22 12:11:24', NULL, '2026-02-22 12:11:24', '2026-02-22 12:11:24'),
(1204, 'notification_track?userId=7&search=&page=1&pageSize=20&paginate=true', NULL, 'Consultation notification_track?userId=7&search=&page=1&pageSize=20&paginate=true ❌', 'Échec lors de consultation notification_track?userid=7&search=&page=1&pagesize=20&paginate=true.', 'réussi', '2026-02-22 12:14:04', NULL, '2026-02-22 12:14:04', '2026-02-22 12:14:04'),
(1205, 'tsx?page=1&pageSize=1000&paginate=true', NULL, 'Consultation tsx?page=1&pageSize=1000&paginate=true ❌', 'Échec lors de consultation tsx?page=1&pagesize=1000&paginate=true.', 'réussi', '2026-02-22 12:14:36', NULL, '2026-02-22 12:14:36', '2026-02-22 12:14:36'),
(1206, '7', NULL, 'Consultation 7 ✅', 'Consultation 7 effectuée avec succès.', 'réussi', '2026-02-22 12:15:14', NULL, '2026-02-22 12:15:14', '2026-02-22 12:15:14'),
(1207, 'sector?page=1&pageSize=20&search=&paginate=false', NULL, 'Consultation sector?page=1&pageSize=20&search=&paginate=false ❌', 'Échec lors de consultation sector?page=1&pagesize=20&search=&paginate=false.', 'réussi', '2026-02-22 12:15:14', NULL, '2026-02-22 12:15:14', '2026-02-22 12:15:14'),
(1208, 'tsx?id=7&page=1&pageSize=10&paginate=true', NULL, 'Consultation tsx?id=7&page=1&pageSize=10&paginate=true ❌', 'Échec lors de consultation tsx?id=7&page=1&pagesize=10&paginate=true.', 'réussi', '2026-02-22 12:15:44', NULL, '2026-02-22 12:15:44', '2026-02-22 12:15:44'),
(1209, '7', NULL, 'Consultation 7 ✅', 'Consultation 7 effectuée avec succès.', 'réussi', '2026-02-22 12:15:57', NULL, '2026-02-22 12:15:57', '2026-02-22 12:15:57'),
(1210, 'sector?page=1&pageSize=20&search=&paginate=false', NULL, 'Consultation sector?page=1&pageSize=20&search=&paginate=false ❌', 'Échec lors de consultation sector?page=1&pagesize=20&search=&paginate=false.', 'réussi', '2026-02-22 12:15:57', NULL, '2026-02-22 12:15:57', '2026-02-22 12:15:57'),
(1211, '1', NULL, 'Consultation 1 ✅', 'Consultation 1 effectuée avec succès.', 'réussi', '2026-02-22 12:16:26', NULL, '2026-02-22 12:16:26', '2026-02-22 12:16:26'),
(1212, 'tsx?id=1&page=1&pageSize=10&paginate=true', NULL, 'Consultation tsx?id=1&page=1&pageSize=10&paginate=true ❌', 'Échec lors de consultation tsx?id=1&page=1&pagesize=10&paginate=true.', 'réussi', '2026-02-22 12:16:29', NULL, '2026-02-22 12:16:29', '2026-02-22 12:16:29'),
(1213, 'notification_track?userId=1&search=&page=1&pageSize=20&paginate=true', NULL, 'Consultation notification_track?userId=1&search=&page=1&pageSize=20&paginate=true ❌', 'Échec lors de consultation notification_track?userid=1&search=&page=1&pagesize=20&paginate=true.', 'réussi', '2026-02-22 12:16:36', NULL, '2026-02-22 12:16:36', '2026-02-22 12:16:36'),
(1214, 'tsx?page=1&pageSize=1000&paginate=true', NULL, 'Consultation tsx?page=1&pageSize=1000&paginate=true ❌', 'Échec lors de consultation tsx?page=1&pagesize=1000&paginate=true.', 'réussi', '2026-02-22 12:16:40', NULL, '2026-02-22 12:16:40', '2026-02-22 12:16:40'),
(1215, 'sector?page=1&pageSize=10&search=&paginate=true', NULL, 'Consultation sector?page=1&pageSize=10&search=&paginate=true ❌', 'Échec lors de consultation sector?page=1&pagesize=10&search=&paginate=true.', 'réussi', '2026-02-22 12:16:51', NULL, '2026-02-22 12:16:51', '2026-02-22 12:16:51'),
(1216, 'sector?page=2&pageSize=10&search=&paginate=true', NULL, 'Consultation sector?page=2&pageSize=10&search=&paginate=true ❌', 'Échec lors de consultation sector?page=2&pagesize=10&search=&paginate=true.', 'réussi', '2026-02-22 12:17:21', NULL, '2026-02-22 12:17:21', '2026-02-22 12:17:21'),
(1217, 'notification_track?userId=1&search=&page=1&pageSize=20&paginate=true', NULL, 'Consultation notification_track?userId=1&search=&page=1&pageSize=20&paginate=true ❌', 'Échec lors de consultation notification_track?userid=1&search=&page=1&pagesize=20&paginate=true.', 'réussi', '2026-02-22 12:19:00', NULL, '2026-02-22 12:19:00', '2026-02-22 12:19:00'),
(1218, 'notification_track?userId=1&search=&page=1&pageSize=20&paginate=true', NULL, 'Consultation notification_track?userId=1&search=&page=1&pageSize=20&paginate=true ❌', 'Échec lors de consultation notification_track?userid=1&search=&page=1&pagesize=20&paginate=true.', 'réussi', '2026-02-22 12:23:04', NULL, '2026-02-22 12:23:04', '2026-02-22 12:23:04'),
(1219, 'users?search=&page=1&pageSize=20&paginate=true', NULL, 'Consultation users?search=&page=1&pageSize=20&paginate=true ✅', 'Consultation users?search=&page=1&pageSize=20&paginate=true effectuée avec succès.', 'réussi', '2026-02-22 12:23:26', NULL, '2026-02-22 12:23:26', '2026-02-22 12:23:26'),
(1220, 'users?search=user_9gqpq&page=1&pageSize=20&paginate=true', NULL, 'Consultation users?search=user_9gqpq&page=1&pageSize=20&paginate=true ✅', 'Consultation users?search=user_9gqpq&page=1&pageSize=20&paginate=true effectuée avec succès.', 'réussi', '2026-02-22 12:23:29', NULL, '2026-02-22 12:23:29', '2026-02-22 12:23:29'),
(1221, 'Transfert', 10, NULL, 'Transfert à user_9gqpq', 'réussi', '2026-02-22 12:23:40', 1, '2026-02-22 12:23:40', '2026-02-22 12:23:40'),
(1222, 'transfert', NULL, 'Création transfert ✅', 'Création transfert effectuée avec succès.', 'réussi', '2026-02-22 12:23:40', NULL, '2026-02-22 12:23:40', '2026-02-22 12:23:40'),
(1223, '1', NULL, 'Consultation 1 ✅', 'Consultation 1 effectuée avec succès.', 'réussi', '2026-02-22 12:23:45', NULL, '2026-02-22 12:23:45', '2026-02-22 12:23:45'),
(1224, 'notification_track?userId=1&search=&page=1&pageSize=20&paginate=true', NULL, 'Consultation notification_track?userId=1&search=&page=1&pageSize=20&paginate=true ✅', 'Consultation notification_track?userId=1&search=&page=1&pageSize=20&paginate=true effectuée avec succès.', 'réussi', '2026-02-22 12:24:02', NULL, '2026-02-22 12:24:02', '2026-02-22 12:24:02'),
(1225, 'notification_track?userId=1&search=&page=1&pageSize=20&paginate=true', NULL, 'Consultation notification_track?userId=1&search=&page=1&pageSize=20&paginate=true ❌', 'Échec lors de consultation notification_track?userid=1&search=&page=1&pagesize=20&paginate=true.', 'réussi', '2026-02-22 12:27:35', NULL, '2026-02-22 12:27:35', '2026-02-22 12:27:35'),
(1226, 'notification_track?userId=1&search=&page=1&pageSize=20&paginate=true', NULL, 'Consultation notification_track?userId=1&search=&page=1&pageSize=20&paginate=true ❌', 'Échec lors de consultation notification_track?userid=1&search=&page=1&pagesize=20&paginate=true.', 'réussi', '2026-02-22 12:35:22', NULL, '2026-02-22 12:35:22', '2026-02-22 12:35:22'),
(1227, 'notification_track?userId=1&search=&page=1&pageSize=20&paginate=true', NULL, 'Consultation notification_track?userId=1&search=&page=1&pageSize=20&paginate=true ❌', 'Échec lors de consultation notification_track?userid=1&search=&page=1&pagesize=20&paginate=true.', 'réussi', '2026-02-22 12:39:30', NULL, '2026-02-22 12:39:30', '2026-02-22 12:39:30'),
(1228, 'sector?page=1&pageSize=10&search=&paginate=true', NULL, 'Consultation sector?page=1&pageSize=10&search=&paginate=true ❌', 'Échec lors de consultation sector?page=1&pagesize=10&search=&paginate=true.', 'réussi', '2026-02-22 12:43:44', NULL, '2026-02-22 12:43:44', '2026-02-22 12:43:44'),
(1229, 'product?page=1&pageSize=10&search=&paginate=true&companyId=8', NULL, 'Consultation product?page=1&pageSize=10&search=&paginate=true&companyId=8 ❌', 'Échec lors de consultation product?page=1&pagesize=10&search=&paginate=true&companyid=8.', 'réussi', '2026-02-22 12:44:15', NULL, '2026-02-22 12:44:15', '2026-02-22 12:44:15'),
(1230, 'notification_track?userId=1&search=&page=1&pageSize=20&paginate=true', NULL, 'Consultation notification_track?userId=1&search=&page=1&pageSize=20&paginate=true ❌', 'Échec lors de consultation notification_track?userid=1&search=&page=1&pagesize=20&paginate=true.', 'réussi', '2026-02-22 12:45:09', NULL, '2026-02-22 12:45:09', '2026-02-22 12:45:09'),
(1231, 'product?page=1&pageSize=10&search=&paginate=true&companyId=8', NULL, 'Consultation product?page=1&pageSize=10&search=&paginate=true&companyId=8 ❌', 'Échec lors de consultation product?page=1&pagesize=10&search=&paginate=true&companyid=8.', 'réussi', '2026-02-22 12:46:23', NULL, '2026-02-22 12:46:23', '2026-02-22 12:46:23'),
(1232, 'product?page=1&pageSize=10&search=&paginate=true&companyId=8', NULL, 'Consultation product?page=1&pageSize=10&search=&paginate=true&companyId=8 ❌', 'Échec lors de consultation product?page=1&pagesize=10&search=&paginate=true&companyid=8.', 'réussi', '2026-02-22 12:46:51', NULL, '2026-02-22 12:46:51', '2026-02-22 12:46:51'),
(1233, 'notification_track?userId=1&search=&page=1&pageSize=20&paginate=true', NULL, 'Consultation notification_track?userId=1&search=&page=1&pageSize=20&paginate=true ❌', 'Échec lors de consultation notification_track?userid=1&search=&page=1&pagesize=20&paginate=true.', 'réussi', '2026-02-22 12:49:28', NULL, '2026-02-22 12:49:28', '2026-02-22 12:49:28'),
(1234, 'product?page=1&pageSize=10&search=&paginate=true&companyId=8', NULL, 'Consultation product?page=1&pageSize=10&search=&paginate=true&companyId=8 ❌', 'Échec lors de consultation product?page=1&pagesize=10&search=&paginate=true&companyid=8.', 'réussi', '2026-02-22 12:51:39', NULL, '2026-02-22 12:51:39', '2026-02-22 12:51:39'),
(1235, 'product?page=1&pageSize=10&search=&paginate=true&companyId=8', NULL, 'Consultation product?page=1&pageSize=10&search=&paginate=true&companyId=8 ❌', 'Échec lors de consultation product?page=1&pagesize=10&search=&paginate=true&companyid=8.', 'réussi', '2026-02-22 12:53:18', NULL, '2026-02-22 12:53:18', '2026-02-22 12:53:18'),
(1236, 'product?page=1&pageSize=10&search=&paginate=true&companyId=11', NULL, 'Consultation product?page=1&pageSize=10&search=&paginate=true&companyId=11 ❌', 'Échec lors de consultation product?page=1&pagesize=10&search=&paginate=true&companyid=11.', 'réussi', '2026-02-22 12:55:56', NULL, '2026-02-22 12:55:56', '2026-02-22 12:55:56'),
(1237, 'sector?page=1&pageSize=20&search=&paginate=false', NULL, 'Consultation sector?page=1&pageSize=20&search=&paginate=false ❌', 'Échec lors de consultation sector?page=1&pagesize=20&search=&paginate=false.', 'réussi', '2026-02-22 12:56:14', NULL, '2026-02-22 12:56:14', '2026-02-22 12:56:14'),
(1238, '1', NULL, 'Consultation 1 ❌', 'Échec lors de consultation 1.', 'réussi', '2026-02-22 12:56:14', NULL, '2026-02-22 12:56:14', '2026-02-22 12:56:14'),
(1239, 'sector?page=1&pageSize=20&search=&paginate=false', NULL, 'Consultation sector?page=1&pageSize=20&search=&paginate=false ❌', 'Échec lors de consultation sector?page=1&pagesize=20&search=&paginate=false.', 'réussi', '2026-02-22 12:56:26', NULL, '2026-02-22 12:56:26', '2026-02-22 12:56:26'),
(1240, '1', NULL, 'Consultation 1 ❌', 'Échec lors de consultation 1.', 'réussi', '2026-02-22 12:56:26', NULL, '2026-02-22 12:56:26', '2026-02-22 12:56:26'),
(1241, '7', NULL, 'Consultation 7 ✅', 'Consultation 7 effectuée avec succès.', 'réussi', '2026-02-22 12:57:16', NULL, '2026-02-22 12:57:16', '2026-02-22 12:57:16'),
(1242, 'tsx?page=1&pageSize=1000&paginate=true', NULL, 'Consultation tsx?page=1&pageSize=1000&paginate=true ❌', 'Échec lors de consultation tsx?page=1&pagesize=1000&paginate=true.', 'réussi', '2026-02-22 12:57:21', NULL, '2026-02-22 12:57:21', '2026-02-22 12:57:21'),
(1243, 'tsx?id=7&page=1&pageSize=10&paginate=true', NULL, 'Consultation tsx?id=7&page=1&pageSize=10&paginate=true ❌', 'Échec lors de consultation tsx?id=7&page=1&pagesize=10&paginate=true.', 'réussi', '2026-02-22 12:57:22', NULL, '2026-02-22 12:57:22', '2026-02-22 12:57:22'),
(1244, 'sector?page=1&pageSize=10&search=&paginate=true', NULL, 'Consultation sector?page=1&pageSize=10&search=&paginate=true ❌', 'Échec lors de consultation sector?page=1&pagesize=10&search=&paginate=true.', 'réussi', '2026-02-22 12:57:23', NULL, '2026-02-22 12:57:23', '2026-02-22 12:57:23'),
(1245, 'product?page=1&pageSize=10&search=&paginate=true&companyId=11', NULL, 'Consultation product?page=1&pageSize=10&search=&paginate=true&companyId=11 ❌', 'Échec lors de consultation product?page=1&pagesize=10&search=&paginate=true&companyid=11.', 'réussi', '2026-02-22 12:58:34', NULL, '2026-02-22 12:58:34', '2026-02-22 12:58:34'),
(1246, 'product?page=1&pageSize=10&search=&paginate=true&companyId=9', NULL, 'Consultation product?page=1&pageSize=10&search=&paginate=true&companyId=9 ❌', 'Échec lors de consultation product?page=1&pagesize=10&search=&paginate=true&companyid=9.', 'réussi', '2026-02-22 12:59:08', NULL, '2026-02-22 12:59:08', '2026-02-22 12:59:08'),
(1247, 'product?page=1&pageSize=10&search=&paginate=true&companyId=12', NULL, 'Consultation product?page=1&pageSize=10&search=&paginate=true&companyId=12 ✅', 'Consultation product?page=1&pageSize=10&search=&paginate=true&companyId=12 effectuée avec succès.', 'réussi', '2026-02-22 12:59:54', NULL, '2026-02-22 12:59:54', '2026-02-22 12:59:54'),
(1248, 'sector?page=2&pageSize=10&search=&paginate=true', NULL, 'Consultation sector?page=2&pageSize=10&search=&paginate=true ❌', 'Échec lors de consultation sector?page=2&pagesize=10&search=&paginate=true.', 'réussi', '2026-02-22 13:00:03', NULL, '2026-02-22 13:00:03', '2026-02-22 13:00:03'),
(1249, 'notification_track?userId=7&search=&page=1&pageSize=20&paginate=true', NULL, 'Consultation notification_track?userId=7&search=&page=1&pageSize=20&paginate=true ❌', 'Échec lors de consultation notification_track?userid=7&search=&page=1&pagesize=20&paginate=true.', 'réussi', '2026-02-22 13:00:19', NULL, '2026-02-22 13:00:19', '2026-02-22 13:00:19'),
(1250, 'notification_track?userId=7&search=&page=1&pageSize=20&paginate=true', NULL, 'Consultation notification_track?userId=7&search=&page=1&pageSize=20&paginate=true ❌', 'Échec lors de consultation notification_track?userid=7&search=&page=1&pagesize=20&paginate=true.', 'réussi', '2026-02-22 13:00:25', NULL, '2026-02-22 13:00:25', '2026-02-22 13:00:25'),
(1251, 'tsx?id=7&page=1&pageSize=10&paginate=true', NULL, 'Consultation tsx?id=7&page=1&pageSize=10&paginate=true ❌', 'Échec lors de consultation tsx?id=7&page=1&pagesize=10&paginate=true.', 'réussi', '2026-02-22 13:01:42', NULL, '2026-02-22 13:01:42', '2026-02-22 13:01:42'),
(1252, 'tsx?page=1&pageSize=1000&paginate=true', NULL, 'Consultation tsx?page=1&pageSize=1000&paginate=true ❌', 'Échec lors de consultation tsx?page=1&pagesize=1000&paginate=true.', 'réussi', '2026-02-22 13:01:49', NULL, '2026-02-22 13:01:49', '2026-02-22 13:01:49'),
(1253, 'product?page=1&pageSize=10&search=&paginate=true&companyId=8', NULL, 'Consultation product?page=1&pageSize=10&search=&paginate=true&companyId=8 ❌', 'Échec lors de consultation product?page=1&pagesize=10&search=&paginate=true&companyid=8.', 'réussi', '2026-02-22 13:05:57', NULL, '2026-02-22 13:05:57', '2026-02-22 13:05:57'),
(1254, 'users?search=&page=1&pageSize=20&paginate=true', NULL, 'Consultation users?search=&page=1&pageSize=20&paginate=true ✅', 'Consultation users?search=&page=1&pageSize=20&paginate=true effectuée avec succès.', 'réussi', '2026-02-22 13:06:52', NULL, '2026-02-22 13:06:52', '2026-02-22 13:06:52'),
(1255, 'users?search=1&page=1&pageSize=20&paginate=true', NULL, 'Consultation users?search=1&page=1&pageSize=20&paginate=true ✅', 'Consultation users?search=1&page=1&pageSize=20&paginate=true effectuée avec succès.', 'réussi', '2026-02-22 13:06:56', NULL, '2026-02-22 13:06:56', '2026-02-22 13:06:56'),
(1256, 'users?search=&page=1&pageSize=20&paginate=true', NULL, 'Consultation users?search=&page=1&pageSize=20&paginate=true ❌', 'Échec lors de consultation users?search=&page=1&pagesize=20&paginate=true.', 'réussi', '2026-02-22 13:06:56', NULL, '2026-02-22 13:06:56', '2026-02-22 13:06:56'),
(1257, 'users?search=1&page=1&pageSize=20&paginate=true', NULL, 'Consultation users?search=1&page=1&pageSize=20&paginate=true ❌', 'Échec lors de consultation users?search=1&page=1&pagesize=20&paginate=true.', 'réussi', '2026-02-22 13:06:56', NULL, '2026-02-22 13:06:56', '2026-02-22 13:06:56'),
(1258, 'users?search=10&page=1&pageSize=20&paginate=true', NULL, 'Consultation users?search=10&page=1&pageSize=20&paginate=true ✅', 'Consultation users?search=10&page=1&pageSize=20&paginate=true effectuée avec succès.', 'réussi', '2026-02-22 13:06:56', NULL, '2026-02-22 13:06:56', '2026-02-22 13:06:56'),
(1259, 'users?search=10&page=1&pageSize=20&paginate=true', NULL, 'Consultation users?search=10&page=1&pageSize=20&paginate=true ❌', 'Échec lors de consultation users?search=10&page=1&pagesize=20&paginate=true.', 'réussi', '2026-02-22 13:06:58', NULL, '2026-02-22 13:06:58', '2026-02-22 13:06:58'),
(1260, 'users?search=1&page=1&pageSize=20&paginate=true', NULL, 'Consultation users?search=1&page=1&pageSize=20&paginate=true ❌', 'Échec lors de consultation users?search=1&page=1&pagesize=20&paginate=true.', 'réussi', '2026-02-22 13:06:59', NULL, '2026-02-22 13:06:59', '2026-02-22 13:06:59'),
(1261, 'users?search=john&page=1&pageSize=20&paginate=true', NULL, 'Consultation users?search=john&page=1&pageSize=20&paginate=true ✅', 'Consultation users?search=john&page=1&pageSize=20&paginate=true effectuée avec succès.', 'réussi', '2026-02-22 13:07:00', NULL, '2026-02-22 13:07:00', '2026-02-22 13:07:00'),
(1262, 'Transfert', 10, NULL, 'Transfert à john', 'réussi', '2026-02-22 13:07:12', 7, '2026-02-22 13:07:12', '2026-02-22 13:07:12'),
(1263, 'transfert', NULL, 'Création transfert ✅', 'Création transfert effectuée avec succès.', 'réussi', '2026-02-22 13:07:12', NULL, '2026-02-22 13:07:12', '2026-02-22 13:07:12'),
(1264, 'product?page=1&pageSize=10&search=&paginate=true&companyId=8', NULL, 'Consultation product?page=1&pageSize=10&search=&paginate=true&companyId=8 ❌', 'Échec lors de consultation product?page=1&pagesize=10&search=&paginate=true&companyid=8.', 'réussi', '2026-02-22 13:07:22', NULL, '2026-02-22 13:07:22', '2026-02-22 13:07:22'),
(1265, 'Paiement', 10, NULL, 'Paiement commande ORD-1771765651986', 'réussi', '2026-02-22 13:07:32', 7, '2026-02-22 13:07:32', '2026-02-22 13:07:32'),
(1266, 'Paiement', 10, NULL, 'Réception paiement commande ORD-1771765651986', 'réussi', '2026-02-22 13:07:32', 2, '2026-02-22 13:07:32', '2026-02-22 13:07:32'),
(1267, 'paiement', NULL, 'Création paiement ✅', 'Création paiement effectuée avec succès.', 'réussi', '2026-02-22 13:07:34', NULL, '2026-02-22 13:07:34', '2026-02-22 13:07:34'),
(1268, '7', NULL, 'Consultation 7 ✅', 'Consultation 7 effectuée avec succès.', 'réussi', '2026-02-22 13:07:37', NULL, '2026-02-22 13:07:37', '2026-02-22 13:07:37'),
(1269, 'notification_track?userId=7&search=&page=1&pageSize=20&paginate=true', NULL, 'Consultation notification_track?userId=7&search=&page=1&pageSize=20&paginate=true ✅', 'Consultation notification_track?userId=7&search=&page=1&pageSize=20&paginate=true effectuée avec succès.', 'réussi', '2026-02-22 13:07:39', NULL, '2026-02-22 13:07:39', '2026-02-22 13:07:39'),
(1270, 'notification_track?userId=7&search=&page=1&pageSize=20&paginate=true', NULL, 'Consultation notification_track?userId=7&search=&page=1&pageSize=20&paginate=true ❌', 'Échec lors de consultation notification_track?userid=7&search=&page=1&pagesize=20&paginate=true.', 'réussi', '2026-02-22 13:07:40', NULL, '2026-02-22 13:07:40', '2026-02-22 13:07:40'),
(1271, 'tsx?page=1&pageSize=1000&paginate=true', NULL, 'Consultation tsx?page=1&pageSize=1000&paginate=true ❌', 'Échec lors de consultation tsx?page=1&pagesize=1000&paginate=true.', 'réussi', '2026-02-22 13:08:00', NULL, '2026-02-22 13:08:00', '2026-02-22 13:08:00'),
(1272, 'notification_track?userId=7&search=&page=1&pageSize=20&paginate=true', NULL, 'Consultation notification_track?userId=7&search=&page=1&pageSize=20&paginate=true ❌', 'Échec lors de consultation notification_track?userid=7&search=&page=1&pagesize=20&paginate=true.', 'réussi', '2026-02-22 13:08:05', NULL, '2026-02-22 13:08:05', '2026-02-22 13:08:05'),
(1273, 'tsx?page=1&pageSize=1000&paginate=true', NULL, 'Consultation tsx?page=1&pageSize=1000&paginate=true ❌', 'Échec lors de consultation tsx?page=1&pagesize=1000&paginate=true.', 'réussi', '2026-02-22 13:08:25', NULL, '2026-02-22 13:08:25', '2026-02-22 13:08:25'),
(1274, 'sector?page=1&pageSize=10&search=&paginate=true', NULL, 'Consultation sector?page=1&pageSize=10&search=&paginate=true ❌', 'Échec lors de consultation sector?page=1&pagesize=10&search=&paginate=true.', 'réussi', '2026-02-22 13:08:26', NULL, '2026-02-22 13:08:26', '2026-02-22 13:08:26'),
(1275, 'sector?page=1&pageSize=20&search=&paginate=false', NULL, 'Consultation sector?page=1&pageSize=20&search=&paginate=false ❌', 'Échec lors de consultation sector?page=1&pagesize=20&search=&paginate=false.', 'réussi', '2026-02-22 13:27:10', NULL, '2026-02-22 13:27:10', '2026-02-22 13:27:10'),
(1276, '7', NULL, 'Consultation 7 ❌', 'Échec lors de consultation 7.', 'réussi', '2026-02-22 13:27:10', NULL, '2026-02-22 13:27:10', '2026-02-22 13:27:10'),
(1277, 'notification_track?userId=7&search=&page=1&pageSize=20&paginate=true', NULL, 'Consultation notification_track?userId=7&search=&page=1&pageSize=20&paginate=true ❌', 'Échec lors de consultation notification_track?userid=7&search=&page=1&pagesize=20&paginate=true.', 'réussi', '2026-02-22 13:28:45', NULL, '2026-02-22 13:28:45', '2026-02-22 13:28:45');
INSERT INTO `histories` (`historyId`, `type`, `amount`, `action`, `description`, `status`, `date`, `userId`, `createdAt`, `updatedAt`) VALUES
(1278, 'sector?page=1&pageSize=10&search=&paginate=true', NULL, 'Consultation sector?page=1&pageSize=10&search=&paginate=true ❌', 'Échec lors de consultation sector?page=1&pagesize=10&search=&paginate=true.', 'réussi', '2026-02-22 13:28:58', NULL, '2026-02-22 13:28:58', '2026-02-22 13:28:58'),
(1279, 'product?page=1&pageSize=10&search=&paginate=true&companyId=8', NULL, 'Consultation product?page=1&pageSize=10&search=&paginate=true&companyId=8 ❌', 'Échec lors de consultation product?page=1&pagesize=10&search=&paginate=true&companyid=8.', 'réussi', '2026-02-22 13:29:01', NULL, '2026-02-22 13:29:01', '2026-02-22 13:29:01'),
(1280, 'product?page=1&pageSize=10&search=&paginate=true&companyId=9', NULL, 'Consultation product?page=1&pageSize=10&search=&paginate=true&companyId=9 ❌', 'Échec lors de consultation product?page=1&pagesize=10&search=&paginate=true&companyid=9.', 'réussi', '2026-02-22 13:29:12', NULL, '2026-02-22 13:29:12', '2026-02-22 13:29:12'),
(1281, 'product?page=1&pageSize=10&search=&paginate=true&companyId=10', NULL, 'Consultation product?page=1&pageSize=10&search=&paginate=true&companyId=10 ✅', 'Consultation product?page=1&pageSize=10&search=&paginate=true&companyId=10 effectuée avec succès.', 'réussi', '2026-02-22 13:29:32', NULL, '2026-02-22 13:29:32', '2026-02-22 13:29:32'),
(1282, 'sector?page=2&pageSize=10&search=&paginate=true', NULL, 'Consultation sector?page=2&pageSize=10&search=&paginate=true ❌', 'Échec lors de consultation sector?page=2&pagesize=10&search=&paginate=true.', 'réussi', '2026-02-22 13:29:42', NULL, '2026-02-22 13:29:42', '2026-02-22 13:29:42'),
(1283, 'product?page=1&pageSize=10&search=&paginate=true&companyId=13', NULL, 'Consultation product?page=1&pageSize=10&search=&paginate=true&companyId=13 ❌', 'Échec lors de consultation product?page=1&pagesize=10&search=&paginate=true&companyid=13.', 'réussi', '2026-02-22 13:29:51', NULL, '2026-02-22 13:29:51', '2026-02-22 13:29:51'),
(1284, 'tsx?id=7&page=1&pageSize=10&paginate=true', NULL, 'Consultation tsx?id=7&page=1&pageSize=10&paginate=true ❌', 'Échec lors de consultation tsx?id=7&page=1&pagesize=10&paginate=true.', 'réussi', '2026-02-22 13:30:29', NULL, '2026-02-22 13:30:29', '2026-02-22 13:30:29'),
(1285, 'tsx?page=1&pageSize=1000&paginate=true', NULL, 'Consultation tsx?page=1&pageSize=1000&paginate=true ❌', 'Échec lors de consultation tsx?page=1&pagesize=1000&paginate=true.', 'réussi', '2026-02-22 13:30:29', NULL, '2026-02-22 13:30:29', '2026-02-22 13:30:29'),
(1286, 'sector?page=1&pageSize=20&search=&paginate=false', NULL, 'Consultation sector?page=1&pageSize=20&search=&paginate=false ❌', 'Échec lors de consultation sector?page=1&pagesize=20&search=&paginate=false.', 'réussi', '2026-02-22 13:42:09', NULL, '2026-02-22 13:42:09', '2026-02-22 13:42:09'),
(1287, '7', NULL, 'Consultation 7 ✅', 'Consultation 7 effectuée avec succès.', 'réussi', '2026-02-22 13:42:09', NULL, '2026-02-22 13:42:09', '2026-02-22 13:42:09'),
(1288, 'connexion', NULL, 'Échec de la connexion ❌', 'Une tentative de connexion a été détectée, mais elle a échoué.', 'réussi', '2026-02-22 13:42:15', NULL, '2026-02-22 13:42:15', '2026-02-22 13:42:15'),
(1289, 'create', NULL, 'Création create ✅', 'Création create effectuée avec succès.', 'réussi', '2026-02-22 13:42:15', NULL, '2026-02-22 13:42:15', '2026-02-22 13:42:15'),
(1290, 'create', NULL, 'Création create ✅', 'Création create effectuée avec succès.', 'réussi', '2026-02-22 13:42:16', NULL, '2026-02-22 13:42:16', '2026-02-22 13:42:16'),
(1291, 'sector?page=1&pageSize=10&search=&paginate=true', NULL, 'Consultation sector?page=1&pageSize=10&search=&paginate=true ❌', 'Échec lors de consultation sector?page=1&pagesize=10&search=&paginate=true.', 'réussi', '2026-02-22 13:42:51', NULL, '2026-02-22 13:42:51', '2026-02-22 13:42:51'),
(1292, 'tsx?id=7&page=1&pageSize=10&paginate=true', NULL, 'Consultation tsx?id=7&page=1&pageSize=10&paginate=true ❌', 'Échec lors de consultation tsx?id=7&page=1&pagesize=10&paginate=true.', 'réussi', '2026-02-22 13:42:53', NULL, '2026-02-22 13:42:53', '2026-02-22 13:42:53'),
(1293, 'tsx?page=1&pageSize=1000&paginate=true', NULL, 'Consultation tsx?page=1&pageSize=1000&paginate=true ❌', 'Échec lors de consultation tsx?page=1&pagesize=1000&paginate=true.', 'réussi', '2026-02-22 13:42:57', NULL, '2026-02-22 13:42:57', '2026-02-22 13:42:57'),
(1294, 'product?page=1&pageSize=10&search=&paginate=true&companyId=8', NULL, 'Consultation product?page=1&pageSize=10&search=&paginate=true&companyId=8 ❌', 'Échec lors de consultation product?page=1&pagesize=10&search=&paginate=true&companyid=8.', 'réussi', '2026-02-22 13:43:05', NULL, '2026-02-22 13:43:05', '2026-02-22 13:43:05'),
(1295, 'product?page=1&pageSize=10&search=&paginate=true&companyId=11', NULL, 'Consultation product?page=1&pageSize=10&search=&paginate=true&companyId=11 ❌', 'Échec lors de consultation product?page=1&pagesize=10&search=&paginate=true&companyid=11.', 'réussi', '2026-02-22 13:43:11', NULL, '2026-02-22 13:43:11', '2026-02-22 13:43:11'),
(1296, 'product?page=1&pageSize=10&search=&paginate=true&companyId=13', NULL, 'Consultation product?page=1&pageSize=10&search=&paginate=true&companyId=13 ❌', 'Échec lors de consultation product?page=1&pagesize=10&search=&paginate=true&companyid=13.', 'réussi', '2026-02-22 13:43:20', NULL, '2026-02-22 13:43:20', '2026-02-22 13:43:20'),
(1297, 'sector?page=2&pageSize=10&search=&paginate=true', NULL, 'Consultation sector?page=2&pageSize=10&search=&paginate=true ❌', 'Échec lors de consultation sector?page=2&pagesize=10&search=&paginate=true.', 'réussi', '2026-02-22 13:43:25', NULL, '2026-02-22 13:43:25', '2026-02-22 13:43:25'),
(1298, 'product?page=1&pageSize=10&search=&paginate=true&companyId=9', NULL, 'Consultation product?page=1&pageSize=10&search=&paginate=true&companyId=9 ❌', 'Échec lors de consultation product?page=1&pagesize=10&search=&paginate=true&companyid=9.', 'réussi', '2026-02-22 13:43:48', NULL, '2026-02-22 13:43:48', '2026-02-22 13:43:48'),
(1299, 'product?page=1&pageSize=10&search=&paginate=true&companyId=13', NULL, 'Consultation product?page=1&pageSize=10&search=&paginate=true&companyId=13 ❌', 'Échec lors de consultation product?page=1&pagesize=10&search=&paginate=true&companyid=13.', 'réussi', '2026-02-22 14:04:45', NULL, '2026-02-22 14:04:45', '2026-02-22 14:04:45'),
(1300, 'sector?page=1&pageSize=20&search=&paginate=false', NULL, 'Consultation sector?page=1&pageSize=20&search=&paginate=false ❌', 'Échec lors de consultation sector?page=1&pagesize=20&search=&paginate=false.', 'réussi', '2026-02-22 14:05:37', NULL, '2026-02-22 14:05:37', '2026-02-22 14:05:37'),
(1301, '7', NULL, 'Consultation 7 ✅', 'Consultation 7 effectuée avec succès.', 'réussi', '2026-02-22 14:05:37', NULL, '2026-02-22 14:05:37', '2026-02-22 14:05:37'),
(1302, 'sector?page=1&pageSize=10&search=&paginate=true', NULL, 'Consultation sector?page=1&pageSize=10&search=&paginate=true ❌', 'Échec lors de consultation sector?page=1&pagesize=10&search=&paginate=true.', 'réussi', '2026-02-22 14:06:02', NULL, '2026-02-22 14:06:02', '2026-02-22 14:06:02'),
(1303, 'tsx?id=7&page=1&pageSize=10&paginate=true', NULL, 'Consultation tsx?id=7&page=1&pageSize=10&paginate=true ❌', 'Échec lors de consultation tsx?id=7&page=1&pagesize=10&paginate=true.', 'réussi', '2026-02-22 14:06:03', NULL, '2026-02-22 14:06:03', '2026-02-22 14:06:03'),
(1304, 'tsx?page=1&pageSize=1000&paginate=true', NULL, 'Consultation tsx?page=1&pageSize=1000&paginate=true ❌', 'Échec lors de consultation tsx?page=1&pagesize=1000&paginate=true.', 'réussi', '2026-02-22 14:06:04', NULL, '2026-02-22 14:06:04', '2026-02-22 14:06:04'),
(1305, 'product?page=1&pageSize=10&search=&paginate=true&companyId=8', NULL, 'Consultation product?page=1&pageSize=10&search=&paginate=true&companyId=8 ❌', 'Échec lors de consultation product?page=1&pagesize=10&search=&paginate=true&companyid=8.', 'réussi', '2026-02-22 14:06:15', NULL, '2026-02-22 14:06:15', '2026-02-22 14:06:15'),
(1306, 'product?page=1&pageSize=10&search=&paginate=true&companyId=13', NULL, 'Consultation product?page=1&pageSize=10&search=&paginate=true&companyId=13 ❌', 'Échec lors de consultation product?page=1&pagesize=10&search=&paginate=true&companyid=13.', 'réussi', '2026-02-22 14:06:23', NULL, '2026-02-22 14:06:23', '2026-02-22 14:06:23'),
(1307, 'sector?page=2&pageSize=10&search=&paginate=true', NULL, 'Consultation sector?page=2&pageSize=10&search=&paginate=true ❌', 'Échec lors de consultation sector?page=2&pagesize=10&search=&paginate=true.', 'réussi', '2026-02-22 14:07:36', NULL, '2026-02-22 14:07:36', '2026-02-22 14:07:36'),
(1308, 'product?page=1&pageSize=10&search=&paginate=true&companyId=8', NULL, 'Consultation product?page=1&pageSize=10&search=&paginate=true&companyId=8 ❌', 'Échec lors de consultation product?page=1&pagesize=10&search=&paginate=true&companyid=8.', 'réussi', '2026-02-22 14:12:16', NULL, '2026-02-22 14:12:16', '2026-02-22 14:12:16'),
(1309, 'product?page=1&pageSize=10&search=&paginate=true&companyId=8', NULL, 'Consultation product?page=1&pageSize=10&search=&paginate=true&companyId=8 ❌', 'Échec lors de consultation product?page=1&pagesize=10&search=&paginate=true&companyid=8.', 'réussi', '2026-02-22 14:14:35', NULL, '2026-02-22 14:14:35', '2026-02-22 14:14:35'),
(1310, 'Paiement', 10, NULL, 'Paiement commande ORD-1771769715496', 'réussi', '2026-02-22 14:15:15', 7, '2026-02-22 14:15:15', '2026-02-22 14:15:15'),
(1311, 'Paiement', 10, NULL, 'Réception paiement commande ORD-1771769715496', 'réussi', '2026-02-22 14:15:15', 2, '2026-02-22 14:15:15', '2026-02-22 14:15:15'),
(1312, 'paiement', NULL, 'Création paiement ✅', 'Création paiement effectuée avec succès.', 'réussi', '2026-02-22 14:15:20', NULL, '2026-02-22 14:15:20', '2026-02-22 14:15:20'),
(1313, '7', NULL, 'Consultation 7 ✅', 'Consultation 7 effectuée avec succès.', 'réussi', '2026-02-22 14:15:23', NULL, '2026-02-22 14:15:23', '2026-02-22 14:15:23'),
(1314, 'sector?page=1&pageSize=10&search=&paginate=true', NULL, 'Consultation sector?page=1&pageSize=10&search=&paginate=true ❌', 'Échec lors de consultation sector?page=1&pagesize=10&search=&paginate=true.', 'réussi', '2026-02-22 14:16:23', NULL, '2026-02-22 14:16:23', '2026-02-22 14:16:23'),
(1315, 'notification_track?userId=7&search=&page=1&pageSize=20&paginate=true', NULL, 'Consultation notification_track?userId=7&search=&page=1&pageSize=20&paginate=true ✅', 'Consultation notification_track?userId=7&search=&page=1&pageSize=20&paginate=true effectuée avec succès.', 'réussi', '2026-02-22 14:16:29', NULL, '2026-02-22 14:16:29', '2026-02-22 14:16:29'),
(1316, '7', NULL, 'Consultation 7 ❌', 'Échec lors de consultation 7.', 'réussi', '2026-02-22 14:17:43', NULL, '2026-02-22 14:17:43', '2026-02-22 14:17:43'),
(1317, 'notification_track?userId=7&search=&page=1&pageSize=20&paginate=true', NULL, 'Consultation notification_track?userId=7&search=&page=1&pageSize=20&paginate=true ❌', 'Échec lors de consultation notification_track?userid=7&search=&page=1&pagesize=20&paginate=true.', 'réussi', '2026-02-22 14:17:46', NULL, '2026-02-22 14:17:46', '2026-02-22 14:17:46'),
(1318, 'createrecharge', NULL, 'Création createrecharge ❌', 'Échec lors de création createrecharge.', 'réussi', '2026-02-22 14:19:18', NULL, '2026-02-22 14:19:18', '2026-02-22 14:19:18'),
(1319, 'users?search=&page=1&pageSize=20&paginate=true', NULL, 'Consultation users?search=&page=1&pageSize=20&paginate=true ✅', 'Consultation users?search=&page=1&pageSize=20&paginate=true effectuée avec succès.', 'réussi', '2026-02-22 14:20:32', NULL, '2026-02-22 14:20:32', '2026-02-22 14:20:32'),
(1320, 'notification_track?userId=7&search=&page=1&pageSize=20&paginate=true', NULL, 'Consultation notification_track?userId=7&search=&page=1&pageSize=20&paginate=true ❌', 'Échec lors de consultation notification_track?userid=7&search=&page=1&pagesize=20&paginate=true.', 'réussi', '2026-02-22 14:22:19', NULL, '2026-02-22 14:22:19', '2026-02-22 14:22:19'),
(1321, 'users?search=&page=1&pageSize=20&paginate=true', NULL, 'Consultation users?search=&page=1&pageSize=20&paginate=true ❌', 'Échec lors de consultation users?search=&page=1&pagesize=20&paginate=true.', 'réussi', '2026-02-22 14:22:52', NULL, '2026-02-22 14:22:52', '2026-02-22 14:22:52'),
(1322, 'createrecharge', NULL, 'Création createrecharge ❌', 'Échec lors de création createrecharge.', 'réussi', '2026-02-22 14:26:57', NULL, '2026-02-22 14:26:57', '2026-02-22 14:26:57'),
(1323, 'notification_track?userId=7&search=&page=1&pageSize=20&paginate=true', NULL, 'Consultation notification_track?userId=7&search=&page=1&pageSize=20&paginate=true ❌', 'Échec lors de consultation notification_track?userid=7&search=&page=1&pagesize=20&paginate=true.', 'réussi', '2026-02-22 14:28:55', NULL, '2026-02-22 14:28:55', '2026-02-22 14:28:55'),
(1324, 'users?search=&page=1&pageSize=20&paginate=true', NULL, 'Consultation users?search=&page=1&pageSize=20&paginate=true ❌', 'Échec lors de consultation users?search=&page=1&pagesize=20&paginate=true.', 'réussi', '2026-02-22 14:35:15', NULL, '2026-02-22 14:35:15', '2026-02-22 14:35:15'),
(1325, 'users?search=Leader+Mushio&page=1&pageSize=20&paginate=true', NULL, 'Consultation users?search=Leader+Mushio&page=1&pageSize=20&paginate=true ✅', 'Consultation users?search=Leader+Mushio&page=1&pageSize=20&paginate=true effectuée avec succès.', 'réussi', '2026-02-22 14:35:20', NULL, '2026-02-22 14:35:20', '2026-02-22 14:35:20'),
(1326, 'users?search=john&page=1&pageSize=20&paginate=true', NULL, 'Consultation users?search=john&page=1&pageSize=20&paginate=true ✅', 'Consultation users?search=john&page=1&pageSize=20&paginate=true effectuée avec succès.', 'réussi', '2026-02-22 14:35:41', NULL, '2026-02-22 14:35:41', '2026-02-22 14:35:41'),
(1327, 'sector?page=1&pageSize=20&search=&paginate=false', NULL, 'Consultation sector?page=1&pageSize=20&search=&paginate=false ❌', 'Échec lors de consultation sector?page=1&pagesize=20&search=&paginate=false.', 'réussi', '2026-02-22 14:39:56', NULL, '2026-02-22 14:39:56', '2026-02-22 14:39:56'),
(1328, '7', NULL, 'Consultation 7 ❌', 'Échec lors de consultation 7.', 'réussi', '2026-02-22 14:39:56', NULL, '2026-02-22 14:39:56', '2026-02-22 14:39:56'),
(1329, 'notification_track?userId=7&search=&page=1&pageSize=20&paginate=true', NULL, 'Consultation notification_track?userId=7&search=&page=1&pageSize=20&paginate=true ❌', 'Échec lors de consultation notification_track?userid=7&search=&page=1&pagesize=20&paginate=true.', 'réussi', '2026-02-22 14:41:52', NULL, '2026-02-22 14:41:52', '2026-02-22 14:41:52'),
(1330, 'users?search=&page=1&pageSize=20&paginate=true', NULL, 'Consultation users?search=&page=1&pageSize=20&paginate=true ✅', 'Consultation users?search=&page=1&pageSize=20&paginate=true effectuée avec succès.', 'réussi', '2026-02-22 14:42:00', NULL, '2026-02-22 14:42:00', '2026-02-22 14:42:00'),
(1331, 'sector?page=1&pageSize=20&search=&paginate=false', NULL, 'Consultation sector?page=1&pageSize=20&search=&paginate=false ❌', 'Échec lors de consultation sector?page=1&pagesize=20&search=&paginate=false.', 'réussi', '2026-02-22 14:45:01', NULL, '2026-02-22 14:45:01', '2026-02-22 14:45:01'),
(1332, '6', NULL, 'Consultation 6 ✅', 'Consultation 6 effectuée avec succès.', 'réussi', '2026-02-22 14:45:01', NULL, '2026-02-22 14:45:01', '2026-02-22 14:45:01'),
(1333, 'tsx?id=6&page=1&pageSize=10&paginate=true', NULL, 'Consultation tsx?id=6&page=1&pageSize=10&paginate=true ✅', 'Consultation tsx?id=6&page=1&pageSize=10&paginate=true effectuée avec succès.', 'réussi', '2026-02-22 14:45:13', NULL, '2026-02-22 14:45:13', '2026-02-22 14:45:13'),
(1334, 'tsx?id=7&page=1&pageSize=10&paginate=true', NULL, 'Consultation tsx?id=7&page=1&pageSize=10&paginate=true ❌', 'Échec lors de consultation tsx?id=7&page=1&pagesize=10&paginate=true.', 'réussi', '2026-02-22 14:47:15', NULL, '2026-02-22 14:47:15', '2026-02-22 14:47:15'),
(1335, 'sector?page=1&pageSize=20&search=&paginate=false', NULL, 'Consultation sector?page=1&pageSize=20&search=&paginate=false ❌', 'Échec lors de consultation sector?page=1&pagesize=20&search=&paginate=false.', 'réussi', '2026-02-22 14:47:56', NULL, '2026-02-22 14:47:56', '2026-02-22 14:47:56'),
(1336, '7', NULL, 'Consultation 7 ✅', 'Consultation 7 effectuée avec succès.', 'réussi', '2026-02-22 14:47:56', NULL, '2026-02-22 14:47:56', '2026-02-22 14:47:56'),
(1337, 'sector?page=1&pageSize=10&search=&paginate=true', NULL, 'Consultation sector?page=1&pageSize=10&search=&paginate=true ❌', 'Échec lors de consultation sector?page=1&pagesize=10&search=&paginate=true.', 'réussi', '2026-02-22 14:50:58', NULL, '2026-02-22 14:50:58', '2026-02-22 14:50:58'),
(1338, 'users?search=&page=1&pageSize=20&paginate=true', NULL, 'Consultation users?search=&page=1&pageSize=20&paginate=true ✅', 'Consultation users?search=&page=1&pageSize=20&paginate=true effectuée avec succès.', 'réussi', '2026-02-22 14:54:49', NULL, '2026-02-22 14:54:49', '2026-02-22 14:54:49'),
(1339, 'Transfert', 2, NULL, 'Transfert à Jerry', 'réussi', '2026-02-22 14:55:45', 7, '2026-02-22 14:55:45', '2026-02-22 14:55:45'),
(1340, 'transfert', NULL, 'Création transfert ✅', 'Création transfert effectuée avec succès.', 'réussi', '2026-02-22 14:55:45', NULL, '2026-02-22 14:55:45', '2026-02-22 14:55:45'),
(1341, '7', NULL, 'Consultation 7 ✅', 'Consultation 7 effectuée avec succès.', 'réussi', '2026-02-22 14:55:53', NULL, '2026-02-22 14:55:53', '2026-02-22 14:55:53'),
(1342, 'sector?page=1&pageSize=10&search=&paginate=true', NULL, 'Consultation sector?page=1&pageSize=10&search=&paginate=true ❌', 'Échec lors de consultation sector?page=1&pagesize=10&search=&paginate=true.', 'réussi', '2026-02-22 14:56:30', NULL, '2026-02-22 14:56:30', '2026-02-22 14:56:30'),
(1343, 'tsx?id=7&page=1&pageSize=10&paginate=true', NULL, 'Consultation tsx?id=7&page=1&pageSize=10&paginate=true ❌', 'Échec lors de consultation tsx?id=7&page=1&pagesize=10&paginate=true.', 'réussi', '2026-02-22 14:56:32', NULL, '2026-02-22 14:56:32', '2026-02-22 14:56:32'),
(1344, 'tsx?page=1&pageSize=1000&paginate=true', NULL, 'Consultation tsx?page=1&pageSize=1000&paginate=true ❌', 'Échec lors de consultation tsx?page=1&pagesize=1000&paginate=true.', 'réussi', '2026-02-22 14:56:33', NULL, '2026-02-22 14:56:33', '2026-02-22 14:56:33'),
(1345, 'users?search=&page=1&pageSize=20&paginate=true', NULL, 'Consultation users?search=&page=1&pageSize=20&paginate=true ✅', 'Consultation users?search=&page=1&pageSize=20&paginate=true effectuée avec succès.', 'réussi', '2026-02-22 14:56:47', NULL, '2026-02-22 14:56:47', '2026-02-22 14:56:47'),
(1346, 'sector?page=1&pageSize=20&search=&paginate=false', NULL, 'Consultation sector?page=1&pageSize=20&search=&paginate=false ❌', 'Échec lors de consultation sector?page=1&pagesize=20&search=&paginate=false.', 'réussi', '2026-02-22 15:09:15', NULL, '2026-02-22 15:09:15', '2026-02-22 15:09:15'),
(1347, '7', NULL, 'Consultation 7 ❌', 'Échec lors de consultation 7.', 'réussi', '2026-02-22 15:09:15', NULL, '2026-02-22 15:09:15', '2026-02-22 15:09:15'),
(1348, 'sector?page=1&pageSize=20&search=&paginate=false', NULL, 'Consultation sector?page=1&pageSize=20&search=&paginate=false ❌', 'Échec lors de consultation sector?page=1&pagesize=20&search=&paginate=false.', 'réussi', '2026-02-22 15:23:19', NULL, '2026-02-22 15:23:19', '2026-02-22 15:23:19'),
(1349, '7', NULL, 'Consultation 7 ✅', 'Consultation 7 effectuée avec succès.', 'réussi', '2026-02-22 15:23:19', NULL, '2026-02-22 15:23:19', '2026-02-22 15:23:19'),
(1350, 'sector?page=1&pageSize=10&search=&paginate=true', NULL, 'Consultation sector?page=1&pageSize=10&search=&paginate=true ❌', 'Échec lors de consultation sector?page=1&pagesize=10&search=&paginate=true.', 'réussi', '2026-02-22 15:26:20', NULL, '2026-02-22 15:26:20', '2026-02-22 15:26:20'),
(1351, 'sector?page=1&pageSize=20&search=&paginate=false', NULL, 'Consultation sector?page=1&pageSize=20&search=&paginate=false ❌', 'Échec lors de consultation sector?page=1&pagesize=20&search=&paginate=false.', 'réussi', '2026-02-22 15:26:58', NULL, '2026-02-22 15:26:58', '2026-02-22 15:26:58'),
(1352, '7', NULL, 'Consultation 7 ✅', 'Consultation 7 effectuée avec succès.', 'réussi', '2026-02-22 15:26:58', NULL, '2026-02-22 15:26:58', '2026-02-22 15:26:58'),
(1353, 'createrecharge', NULL, 'Création createrecharge ❌', 'Échec lors de création createrecharge.', 'réussi', '2026-02-22 15:34:08', NULL, '2026-02-22 15:34:08', '2026-02-22 15:34:08'),
(1354, 'createrecharge', NULL, 'Création createrecharge ✅', 'Création createrecharge effectuée avec succès.', 'réussi', '2026-02-22 15:34:47', NULL, '2026-02-22 15:34:47', '2026-02-22 15:34:47'),
(1355, 'recharge', NULL, 'Création recharge ✅', 'Création recharge effectuée avec succès.', 'réussi', '2026-02-22 15:34:50', NULL, '2026-02-22 15:34:50', '2026-02-22 15:34:50'),
(1356, '7', NULL, 'Consultation 7 ✅', 'Consultation 7 effectuée avec succès.', 'réussi', '2026-02-22 15:35:03', NULL, '2026-02-22 15:35:03', '2026-02-22 15:35:03'),
(1357, 'product?page=1&pageSize=10&search=&paginate=true&companyId=9', NULL, 'Consultation product?page=1&pageSize=10&search=&paginate=true&companyId=9 ❌', 'Échec lors de consultation product?page=1&pagesize=10&search=&paginate=true&companyid=9.', 'réussi', '2026-02-22 15:35:19', NULL, '2026-02-22 15:35:19', '2026-02-22 15:35:19'),
(1358, 'Paiement', 10, NULL, 'Paiement commande ORD-1771774570393', 'réussi', '2026-02-22 15:36:10', 7, '2026-02-22 15:36:10', '2026-02-22 15:36:10'),
(1359, 'Paiement', 10, NULL, 'Réception paiement commande ORD-1771774570393', 'réussi', '2026-02-22 15:36:10', 2, '2026-02-22 15:36:10', '2026-02-22 15:36:10'),
(1360, 'paiement', NULL, 'Création paiement ✅', 'Création paiement effectuée avec succès.', 'réussi', '2026-02-22 15:36:13', NULL, '2026-02-22 15:36:13', '2026-02-22 15:36:13'),
(1361, '7', NULL, 'Consultation 7 ✅', 'Consultation 7 effectuée avec succès.', 'réussi', '2026-02-22 15:36:16', NULL, '2026-02-22 15:36:16', '2026-02-22 15:36:16'),
(1362, 'notification_track?userId=7&search=&page=1&pageSize=20&paginate=true', NULL, 'Consultation notification_track?userId=7&search=&page=1&pageSize=20&paginate=true ✅', 'Consultation notification_track?userId=7&search=&page=1&pageSize=20&paginate=true effectuée avec succès.', 'réussi', '2026-02-22 15:36:19', NULL, '2026-02-22 15:36:19', '2026-02-22 15:36:19'),
(1363, 'notification_track?userId=7&search=&page=1&pageSize=20&paginate=true', NULL, 'Consultation notification_track?userId=7&search=&page=1&pageSize=20&paginate=true ❌', 'Échec lors de consultation notification_track?userid=7&search=&page=1&pagesize=20&paginate=true.', 'réussi', '2026-02-22 15:36:23', NULL, '2026-02-22 15:36:23', '2026-02-22 15:36:23'),
(1364, 'Paiement', 10, NULL, 'Paiement commande ORD-1771774632016', 'réussi', '2026-02-22 15:37:12', 7, '2026-02-22 15:37:12', '2026-02-22 15:37:12'),
(1365, 'Paiement', 10, NULL, 'Réception paiement commande ORD-1771774632016', 'réussi', '2026-02-22 15:37:12', 2, '2026-02-22 15:37:12', '2026-02-22 15:37:12'),
(1366, 'paiement', NULL, 'Création paiement ✅', 'Création paiement effectuée avec succès.', 'réussi', '2026-02-22 15:37:16', NULL, '2026-02-22 15:37:16', '2026-02-22 15:37:16'),
(1367, '7', NULL, 'Consultation 7 ✅', 'Consultation 7 effectuée avec succès.', 'réussi', '2026-02-22 15:37:18', NULL, '2026-02-22 15:37:18', '2026-02-22 15:37:18'),
(1368, 'sector?page=1&pageSize=10&search=&paginate=true', NULL, 'Consultation sector?page=1&pageSize=10&search=&paginate=true ❌', 'Échec lors de consultation sector?page=1&pagesize=10&search=&paginate=true.', 'réussi', '2026-02-22 15:39:18', NULL, '2026-02-22 15:39:18', '2026-02-22 15:39:18'),
(1369, 'sector?page=2&pageSize=10&search=&paginate=true', NULL, 'Consultation sector?page=2&pageSize=10&search=&paginate=true ❌', 'Échec lors de consultation sector?page=2&pagesize=10&search=&paginate=true.', 'réussi', '2026-02-22 15:39:47', NULL, '2026-02-22 15:39:47', '2026-02-22 15:39:47'),
(1370, 'tsx?id=7&page=1&pageSize=10&paginate=true', NULL, 'Consultation tsx?id=7&page=1&pageSize=10&paginate=true ❌', 'Échec lors de consultation tsx?id=7&page=1&pagesize=10&paginate=true.', 'réussi', '2026-02-22 15:42:06', NULL, '2026-02-22 15:42:06', '2026-02-22 15:42:06'),
(1371, 'Retrait', 10, NULL, 'Retrait effectué', 'réussi', '2026-02-22 15:44:36', 7, '2026-02-22 15:44:36', '2026-02-22 15:44:36'),
(1372, 'Retrait', 10, NULL, 'Retrait client reçu', 'réussi', '2026-02-22 15:44:36', 10, '2026-02-22 15:44:36', '2026-02-22 15:44:36'),
(1373, 'Retrait', 0.2985, NULL, 'Frais retrait reçu', 'réussi', '2026-02-22 15:44:36', 2, '2026-02-22 15:44:36', '2026-02-22 15:44:36'),
(1374, 'retrait', NULL, 'Création retrait ✅', 'Création retrait effectuée avec succès.', 'réussi', '2026-02-22 15:44:41', NULL, '2026-02-22 15:44:41', '2026-02-22 15:44:41'),
(1375, '7', NULL, 'Consultation 7 ✅', 'Consultation 7 effectuée avec succès.', 'réussi', '2026-02-22 15:44:46', NULL, '2026-02-22 15:44:46', '2026-02-22 15:44:46'),
(1376, '7', NULL, 'Consultation 7 ❌', 'Échec lors de consultation 7.', 'réussi', '2026-02-22 15:45:20', NULL, '2026-02-22 15:45:20', '2026-02-22 15:45:20'),
(1377, 'notification_track?userId=7&search=&page=1&pageSize=20&paginate=true', NULL, 'Consultation notification_track?userId=7&search=&page=1&pageSize=20&paginate=true ✅', 'Consultation notification_track?userId=7&search=&page=1&pageSize=20&paginate=true effectuée avec succès.', 'réussi', '2026-02-22 15:45:22', NULL, '2026-02-22 15:45:22', '2026-02-22 15:45:22'),
(1378, 'tsx?page=1&pageSize=1000&paginate=true', NULL, 'Consultation tsx?page=1&pageSize=1000&paginate=true ✅', 'Consultation tsx?page=1&pageSize=1000&paginate=true effectuée avec succès.', 'réussi', '2026-02-22 15:46:05', NULL, '2026-02-22 15:46:05', '2026-02-22 15:46:05'),
(1379, 'tsx?id=6&page=1&pageSize=10&paginate=true', NULL, 'Consultation tsx?id=6&page=1&pageSize=10&paginate=true ❌', 'Échec lors de consultation tsx?id=6&page=1&pagesize=10&paginate=true.', 'réussi', '2026-02-22 15:47:11', NULL, '2026-02-22 15:47:11', '2026-02-22 15:47:11'),
(1380, 'Transfert', 10, NULL, 'Transfert à Jerry', 'réussi', '2026-02-22 15:47:55', 7, '2026-02-22 15:47:55', '2026-02-22 15:47:55'),
(1381, 'transfert', NULL, 'Création transfert ✅', 'Création transfert effectuée avec succès.', 'réussi', '2026-02-22 15:47:55', NULL, '2026-02-22 15:47:55', '2026-02-22 15:47:55'),
(1382, '6', NULL, 'Consultation 6 ✅', 'Consultation 6 effectuée avec succès.', 'réussi', '2026-02-22 15:48:31', NULL, '2026-02-22 15:48:31', '2026-02-22 15:48:31'),
(1383, 'notification_track?userId=6&search=&page=1&pageSize=20&paginate=true', NULL, 'Consultation notification_track?userId=6&search=&page=1&pageSize=20&paginate=true ✅', 'Consultation notification_track?userId=6&search=&page=1&pageSize=20&paginate=true effectuée avec succès.', 'réussi', '2026-02-22 15:48:40', NULL, '2026-02-22 15:48:40', '2026-02-22 15:48:40'),
(1384, 'transaction', NULL, 'Consultation des transactions 📄', 'La liste de vos transactions a été consultée avec succès.', 'réussi', '2026-02-22 15:53:20', NULL, '2026-02-22 15:53:20', '2026-02-22 15:53:20'),
(1385, 'tsx', NULL, 'Consultation tsx ✅', 'Consultation tsx effectuée avec succès.', 'réussi', '2026-02-22 15:53:20', NULL, '2026-02-22 15:53:20', '2026-02-22 15:53:20'),
(1386, 'sector?page=1&pageSize=20&search=&paginate=false', NULL, 'Consultation sector?page=1&pageSize=20&search=&paginate=false ❌', 'Échec lors de consultation sector?page=1&pagesize=20&search=&paginate=false.', 'réussi', '2026-02-22 15:54:20', NULL, '2026-02-22 15:54:20', '2026-02-22 15:54:20'),
(1387, '7', NULL, 'Consultation 7 ✅', 'Consultation 7 effectuée avec succès.', 'réussi', '2026-02-22 15:54:20', NULL, '2026-02-22 15:54:20', '2026-02-22 15:54:20'),
(1388, 'sector?page=1&pageSize=20&search=&paginate=false', NULL, 'Consultation sector?page=1&pageSize=20&search=&paginate=false ❌', 'Échec lors de consultation sector?page=1&pagesize=20&search=&paginate=false.', 'réussi', '2026-02-22 15:57:56', NULL, '2026-02-22 15:57:56', '2026-02-22 15:57:56'),
(1389, '7', NULL, 'Consultation 7 ❌', 'Échec lors de consultation 7.', 'réussi', '2026-02-22 15:57:56', NULL, '2026-02-22 15:57:56', '2026-02-22 15:57:56'),
(1390, 'sector?page=1&pageSize=20&search=&paginate=false', NULL, 'Consultation sector?page=1&pageSize=20&search=&paginate=false ❌', 'Échec lors de consultation sector?page=1&pagesize=20&search=&paginate=false.', 'réussi', '2026-02-22 15:58:08', NULL, '2026-02-22 15:58:08', '2026-02-22 15:58:08'),
(1391, '7', NULL, 'Consultation 7 ❌', 'Échec lors de consultation 7.', 'réussi', '2026-02-22 15:58:08', NULL, '2026-02-22 15:58:08', '2026-02-22 15:58:08'),
(1392, '1', NULL, 'Consultation 1 ✅', 'Consultation 1 effectuée avec succès.', 'réussi', '2026-02-22 16:00:46', NULL, '2026-02-22 16:00:46', '2026-02-22 16:00:46'),
(1393, 'notification_track?userId=1&search=&page=1&pageSize=20&paginate=true', NULL, 'Consultation notification_track?userId=1&search=&page=1&pageSize=20&paginate=true ❌', 'Échec lors de consultation notification_track?userid=1&search=&page=1&pagesize=20&paginate=true.', 'réussi', '2026-02-22 16:00:55', NULL, '2026-02-22 16:00:55', '2026-02-22 16:00:55'),
(1394, 'notification_track?userId=1&search=&page=1&pageSize=20&paginate=true', NULL, 'Consultation notification_track?userId=1&search=&page=1&pageSize=20&paginate=true ❌', 'Échec lors de consultation notification_track?userid=1&search=&page=1&pagesize=20&paginate=true.', 'réussi', '2026-02-22 16:00:56', NULL, '2026-02-22 16:00:56', '2026-02-22 16:00:56'),
(1395, 'users?search=&page=1&pageSize=20&paginate=true', NULL, 'Consultation users?search=&page=1&pageSize=20&paginate=true ✅', 'Consultation users?search=&page=1&pageSize=20&paginate=true effectuée avec succès.', 'réussi', '2026-02-22 16:01:25', NULL, '2026-02-22 16:01:25', '2026-02-22 16:01:25'),
(1396, 'tsx?page=1&pageSize=1000&paginate=true', NULL, 'Consultation tsx?page=1&pageSize=1000&paginate=true ❌', 'Échec lors de consultation tsx?page=1&pagesize=1000&paginate=true.', 'réussi', '2026-02-22 16:01:31', NULL, '2026-02-22 16:01:31', '2026-02-22 16:01:31'),
(1397, '1', NULL, 'Consultation 1 ❌', 'Échec lors de consultation 1.', 'réussi', '2026-02-22 16:02:03', NULL, '2026-02-22 16:02:03', '2026-02-22 16:02:03'),
(1398, 'sector?page=1&pageSize=20&search=&paginate=false', NULL, 'Consultation sector?page=1&pageSize=20&search=&paginate=false ❌', 'Échec lors de consultation sector?page=1&pagesize=20&search=&paginate=false.', 'réussi', '2026-02-22 16:02:03', NULL, '2026-02-22 16:02:03', '2026-02-22 16:02:03'),
(1399, 'profile', NULL, 'Mise à jour profile ✅', 'Mise à jour profile effectuée avec succès.', 'réussi', '2026-02-22 16:14:09', NULL, '2026-02-22 16:14:09', '2026-02-22 16:14:09'),
(1400, '1', NULL, 'Consultation 1 ✅', 'Consultation 1 effectuée avec succès.', 'réussi', '2026-02-22 16:14:09', NULL, '2026-02-22 16:14:09', '2026-02-22 16:14:09'),
(1401, 'sector?page=1&pageSize=10&search=&paginate=true', NULL, 'Consultation sector?page=1&pageSize=10&search=&paginate=true ❌', 'Échec lors de consultation sector?page=1&pagesize=10&search=&paginate=true.', 'réussi', '2026-02-22 16:15:09', NULL, '2026-02-22 16:15:09', '2026-02-22 16:15:09'),
(1402, 'sector?page=2&pageSize=10&search=&paginate=true', NULL, 'Consultation sector?page=2&pageSize=10&search=&paginate=true ❌', 'Échec lors de consultation sector?page=2&pagesize=10&search=&paginate=true.', 'réussi', '2026-02-22 16:15:27', NULL, '2026-02-22 16:15:27', '2026-02-22 16:15:27'),
(1403, 'product?page=1&pageSize=10&search=&paginate=true&companyId=9', NULL, 'Consultation product?page=1&pageSize=10&search=&paginate=true&companyId=9 ❌', 'Échec lors de consultation product?page=1&pagesize=10&search=&paginate=true&companyid=9.', 'réussi', '2026-02-22 16:15:42', NULL, '2026-02-22 16:15:42', '2026-02-22 16:15:42'),
(1404, '1', NULL, 'Consultation 1 ❌', 'Échec lors de consultation 1.', 'réussi', '2026-02-22 16:16:23', NULL, '2026-02-22 16:16:23', '2026-02-22 16:16:23'),
(1405, '7', NULL, 'Consultation 7 ✅', 'Consultation 7 effectuée avec succès.', 'réussi', '2026-02-22 16:19:42', NULL, '2026-02-22 16:19:42', '2026-02-22 16:19:42'),
(1406, 'createrecharge', NULL, 'Création createrecharge ❌', 'Échec lors de création createrecharge.', 'réussi', '2026-02-22 16:20:54', NULL, '2026-02-22 16:20:54', '2026-02-22 16:20:54'),
(1407, 'Retrait', 10, NULL, 'Retrait effectué', 'réussi', '2026-02-22 16:22:36', 7, '2026-02-22 16:22:36', '2026-02-22 16:22:36'),
(1408, 'Retrait', 10, NULL, 'Retrait client reçu', 'réussi', '2026-02-22 16:22:36', 10, '2026-02-22 16:22:36', '2026-02-22 16:22:36'),
(1409, 'Retrait', 0.2985, NULL, 'Frais retrait reçu', 'réussi', '2026-02-22 16:22:36', 2, '2026-02-22 16:22:36', '2026-02-22 16:22:36'),
(1410, 'retrait', NULL, 'Création retrait ✅', 'Création retrait effectuée avec succès.', 'réussi', '2026-02-22 16:22:39', NULL, '2026-02-22 16:22:39', '2026-02-22 16:22:39'),
(1411, '7', NULL, 'Consultation 7 ✅', 'Consultation 7 effectuée avec succès.', 'réussi', '2026-02-23 16:49:45', NULL, '2026-02-23 16:49:45', '2026-02-23 16:49:45'),
(1412, '1', NULL, 'Consultation 1 ✅', 'Consultation 1 effectuée avec succès.', 'réussi', '2026-02-23 17:02:11', NULL, '2026-02-23 17:02:11', '2026-02-23 17:02:11'),
(1413, '1', NULL, 'Consultation 1 ❌', 'Échec lors de consultation 1.', 'réussi', '2026-02-23 17:02:15', NULL, '2026-02-23 17:02:15', '2026-02-23 17:02:15'),
(1414, 'sector?page=1&pageSize=20&search=&paginate=false', NULL, 'Consultation sector?page=1&pageSize=20&search=&paginate=false ✅', 'Consultation sector?page=1&pageSize=20&search=&paginate=false effectuée avec succès.', 'réussi', '2026-02-23 17:02:28', NULL, '2026-02-23 17:02:28', '2026-02-23 17:02:28'),
(1415, '1', NULL, 'Consultation 1 ❌', 'Échec lors de consultation 1.', 'réussi', '2026-02-23 17:02:28', NULL, '2026-02-23 17:02:28', '2026-02-23 17:02:28'),
(1416, 'notification_track?userId=1&search=&page=1&pageSize=20&paginate=true', NULL, 'Consultation notification_track?userId=1&search=&page=1&pageSize=20&paginate=true ❌', 'Échec lors de consultation notification_track?userid=1&search=&page=1&pagesize=20&paginate=true.', 'réussi', '2026-02-23 17:03:02', NULL, '2026-02-23 17:03:02', '2026-02-23 17:03:02'),
(1417, 'product?page=1&pageSize=10&search=&paginate=true&companyId=9', NULL, 'Consultation product?page=1&pageSize=10&search=&paginate=true&companyId=9 ❌', 'Échec lors de consultation product?page=1&pagesize=10&search=&paginate=true&companyid=9.', 'réussi', '2026-02-23 17:03:28', NULL, '2026-02-23 17:03:28', '2026-02-23 17:03:28'),
(1418, 'sector?page=1&pageSize=10&search=&paginate=true', NULL, 'Consultation sector?page=1&pageSize=10&search=&paginate=true ❌', 'Échec lors de consultation sector?page=1&pagesize=10&search=&paginate=true.', 'réussi', '2026-02-23 17:10:42', NULL, '2026-02-23 17:10:42', '2026-02-23 17:10:42'),
(1419, 'tsx?id=1&page=1&pageSize=10&paginate=true', NULL, 'Consultation tsx?id=1&page=1&pageSize=10&paginate=true ❌', 'Échec lors de consultation tsx?id=1&page=1&pagesize=10&paginate=true.', 'réussi', '2026-02-23 17:10:42', NULL, '2026-02-23 17:10:42', '2026-02-23 17:10:42'),
(1420, 'tsx?page=1&pageSize=1000&paginate=true', NULL, 'Consultation tsx?page=1&pageSize=1000&paginate=true ✅', 'Consultation tsx?page=1&pageSize=1000&paginate=true effectuée avec succès.', 'réussi', '2026-02-23 17:10:43', NULL, '2026-02-23 17:10:43', '2026-02-23 17:10:43'),
(1421, 'notification_track?userId=1&search=&page=1&pageSize=20&paginate=true', NULL, 'Consultation notification_track?userId=1&search=&page=1&pageSize=20&paginate=true ❌', 'Échec lors de consultation notification_track?userid=1&search=&page=1&pagesize=20&paginate=true.', 'réussi', '2026-02-23 17:10:55', NULL, '2026-02-23 17:10:55', '2026-02-23 17:10:55'),
(1422, 'notification_track?userId=1&search=&page=1&pageSize=20&paginate=true', NULL, 'Consultation notification_track?userId=1&search=&page=1&pageSize=20&paginate=true ❌', 'Échec lors de consultation notification_track?userid=1&search=&page=1&pagesize=20&paginate=true.', 'réussi', '2026-02-23 17:10:59', NULL, '2026-02-23 17:10:59', '2026-02-23 17:10:59'),
(1423, 'sector?page=2&pageSize=10&search=&paginate=true', NULL, 'Consultation sector?page=2&pageSize=10&search=&paginate=true ❌', 'Échec lors de consultation sector?page=2&pagesize=10&search=&paginate=true.', 'réussi', '2026-02-23 17:30:53', NULL, '2026-02-23 17:30:53', '2026-02-23 17:30:53'),
(1424, 'transfert', NULL, 'Création transfert ❌', 'Échec lors de création transfert.', 'réussi', '2026-02-23 17:31:41', NULL, '2026-02-23 17:31:41', '2026-02-23 17:31:41'),
(1425, 'transfert', NULL, 'Création transfert ❌', 'Échec lors de création transfert.', 'réussi', '2026-02-23 17:33:28', NULL, '2026-02-23 17:33:28', '2026-02-23 17:33:28'),
(1426, 'transfert', NULL, 'Création transfert ❌', 'Échec lors de création transfert.', 'réussi', '2026-02-23 17:34:21', NULL, '2026-02-23 17:34:21', '2026-02-23 17:34:21'),
(1427, 'transfert', NULL, 'Création transfert ❌', 'Échec lors de création transfert.', 'réussi', '2026-02-23 17:34:48', NULL, '2026-02-23 17:34:48', '2026-02-23 17:34:48'),
(1428, 'notification_track?userId=1&search=&page=1&pageSize=20&paginate=true', NULL, 'Consultation notification_track?userId=1&search=&page=1&pageSize=20&paginate=true ❌', 'Échec lors de consultation notification_track?userid=1&search=&page=1&pagesize=20&paginate=true.', 'réussi', '2026-02-23 17:35:20', NULL, '2026-02-23 17:35:20', '2026-02-23 17:35:20'),
(1429, '7', NULL, 'Consultation 7 ✅', 'Consultation 7 effectuée avec succès.', 'réussi', '2026-02-23 17:38:25', NULL, '2026-02-23 17:38:25', '2026-02-23 17:38:25'),
(1430, 'sector?page=1&pageSize=20&search=&paginate=false', NULL, 'Consultation sector?page=1&pageSize=20&search=&paginate=false ❌', 'Échec lors de consultation sector?page=1&pagesize=20&search=&paginate=false.', 'réussi', '2026-02-23 17:40:20', NULL, '2026-02-23 17:40:20', '2026-02-23 17:40:20'),
(1431, '7', NULL, 'Consultation 7 ❌', 'Échec lors de consultation 7.', 'réussi', '2026-02-23 17:40:20', NULL, '2026-02-23 17:40:20', '2026-02-23 17:40:20'),
(1432, 'sector?page=1&pageSize=20&search=&paginate=false', NULL, 'Consultation sector?page=1&pageSize=20&search=&paginate=false ❌', 'Échec lors de consultation sector?page=1&pagesize=20&search=&paginate=false.', 'réussi', '2026-02-23 17:42:12', NULL, '2026-02-23 17:42:12', '2026-02-23 17:42:12'),
(1433, '7', NULL, 'Consultation 7 ✅', 'Consultation 7 effectuée avec succès.', 'réussi', '2026-02-23 17:42:12', NULL, '2026-02-23 17:42:12', '2026-02-23 17:42:12'),
(1434, 'sector?page=1&pageSize=20&search=&paginate=false', NULL, 'Consultation sector?page=1&pageSize=20&search=&paginate=false ❌', 'Échec lors de consultation sector?page=1&pagesize=20&search=&paginate=false.', 'réussi', '2026-02-23 18:09:37', NULL, '2026-02-23 18:09:37', '2026-02-23 18:09:37'),
(1435, '7', NULL, 'Consultation 7 ✅', 'Consultation 7 effectuée avec succès.', 'réussi', '2026-02-23 18:09:37', NULL, '2026-02-23 18:09:37', '2026-02-23 18:09:37'),
(1436, 'sector?page=1&pageSize=10&search=&paginate=true', NULL, 'Consultation sector?page=1&pageSize=10&search=&paginate=true ❌', 'Échec lors de consultation sector?page=1&pagesize=10&search=&paginate=true.', 'réussi', '2026-02-23 18:10:11', NULL, '2026-02-23 18:10:11', '2026-02-23 18:10:11'),
(1437, 'sector?page=2&pageSize=10&search=&paginate=true', NULL, 'Consultation sector?page=2&pageSize=10&search=&paginate=true ❌', 'Échec lors de consultation sector?page=2&pagesize=10&search=&paginate=true.', 'réussi', '2026-02-23 18:10:12', NULL, '2026-02-23 18:10:12', '2026-02-23 18:10:12'),
(1438, 'tsx?id=7&page=1&pageSize=10&paginate=true', NULL, 'Consultation tsx?id=7&page=1&pageSize=10&paginate=true ✅', 'Consultation tsx?id=7&page=1&pageSize=10&paginate=true effectuée avec succès.', 'réussi', '2026-02-23 18:10:13', NULL, '2026-02-23 18:10:13', '2026-02-23 18:10:13'),
(1439, 'sector?page=1&pageSize=20&search=&paginate=false', NULL, 'Consultation sector?page=1&pageSize=20&search=&paginate=false ❌', 'Échec lors de consultation sector?page=1&pagesize=20&search=&paginate=false.', 'réussi', '2026-02-23 18:11:38', NULL, '2026-02-23 18:11:38', '2026-02-23 18:11:38'),
(1440, '7', NULL, 'Consultation 7 ✅', 'Consultation 7 effectuée avec succès.', 'réussi', '2026-02-23 18:11:38', NULL, '2026-02-23 18:11:38', '2026-02-23 18:11:38'),
(1441, 'transfert', NULL, 'Création transfert ❌', 'Échec lors de création transfert.', 'réussi', '2026-02-23 18:21:52', NULL, '2026-02-23 18:21:52', '2026-02-23 18:21:52'),
(1442, 'transfert', NULL, 'Création transfert ❌', 'Échec lors de création transfert.', 'réussi', '2026-02-23 18:23:49', NULL, '2026-02-23 18:23:49', '2026-02-23 18:23:49'),
(1443, 'product?page=1&pageSize=10&search=&paginate=true&companyId=13', NULL, 'Consultation product?page=1&pageSize=10&search=&paginate=true&companyId=13 ❌', 'Échec lors de consultation product?page=1&pagesize=10&search=&paginate=true&companyid=13.', 'réussi', '2026-02-23 18:25:29', NULL, '2026-02-23 18:25:29', '2026-02-23 18:25:29'),
(1444, 'Paiement', 10, NULL, 'Paiement commande ORD-1771871158381', 'réussi', '2026-02-23 18:25:58', 7, '2026-02-23 18:25:58', '2026-02-23 18:25:58'),
(1445, 'Paiement', 10, NULL, 'Réception paiement commande ORD-1771871158381', 'réussi', '2026-02-23 18:25:58', 2, '2026-02-23 18:25:58', '2026-02-23 18:25:58'),
(1446, 'paiement', NULL, 'Création paiement ✅', 'Création paiement effectuée avec succès.', 'réussi', '2026-02-23 18:26:00', NULL, '2026-02-23 18:26:00', '2026-02-23 18:26:00'),
(1447, '7', NULL, 'Consultation 7 ✅', 'Consultation 7 effectuée avec succès.', 'réussi', '2026-02-23 18:26:03', NULL, '2026-02-23 18:26:03', '2026-02-23 18:26:03'),
(1448, 'notification_track?userId=7&search=&page=1&pageSize=20&paginate=true', NULL, 'Consultation notification_track?userId=7&search=&page=1&pageSize=20&paginate=true ✅', 'Consultation notification_track?userId=7&search=&page=1&pageSize=20&paginate=true effectuée avec succès.', 'réussi', '2026-02-23 18:29:29', NULL, '2026-02-23 18:29:29', '2026-02-23 18:29:29'),
(1449, 'sector?page=1&pageSize=20&search=&paginate=false', NULL, 'Consultation sector?page=1&pageSize=20&search=&paginate=false ❌', 'Échec lors de consultation sector?page=1&pagesize=20&search=&paginate=false.', 'réussi', '2026-02-23 18:29:54', NULL, '2026-02-23 18:29:54', '2026-02-23 18:29:54'),
(1450, '7', NULL, 'Consultation 7 ✅', 'Consultation 7 effectuée avec succès.', 'réussi', '2026-02-23 18:29:54', NULL, '2026-02-23 18:29:54', '2026-02-23 18:29:54'),
(1451, 'Transfert', 500, NULL, 'Transfert à Leader Mushio', 'réussi', '2026-02-23 18:30:41', 7, '2026-02-23 18:30:41', '2026-02-23 18:30:41'),
(1452, 'transfert', NULL, 'Création transfert ✅', 'Création transfert effectuée avec succès.', 'réussi', '2026-02-23 18:30:41', NULL, '2026-02-23 18:30:41', '2026-02-23 18:30:41'),
(1453, '7', NULL, 'Consultation 7 ✅', 'Consultation 7 effectuée avec succès.', 'réussi', '2026-02-23 18:30:47', NULL, '2026-02-23 18:30:47', '2026-02-23 18:30:47'),
(1454, 'notification_track?userId=7&search=&page=1&pageSize=20&paginate=true', NULL, 'Consultation notification_track?userId=7&search=&page=1&pageSize=20&paginate=true ✅', 'Consultation notification_track?userId=7&search=&page=1&pageSize=20&paginate=true effectuée avec succès.', 'réussi', '2026-02-23 18:30:52', NULL, '2026-02-23 18:30:52', '2026-02-23 18:30:52'),
(1455, 'sector?page=1&pageSize=10&search=&paginate=true', NULL, 'Consultation sector?page=1&pageSize=10&search=&paginate=true ❌', 'Échec lors de consultation sector?page=1&pagesize=10&search=&paginate=true.', 'réussi', '2026-02-23 18:30:57', NULL, '2026-02-23 18:30:57', '2026-02-23 18:30:57'),
(1456, 'sector?page=2&pageSize=10&search=&paginate=true', NULL, 'Consultation sector?page=2&pageSize=10&search=&paginate=true ❌', 'Échec lors de consultation sector?page=2&pagesize=10&search=&paginate=true.', 'réussi', '2026-02-23 18:31:02', NULL, '2026-02-23 18:31:02', '2026-02-23 18:31:02'),
(1457, 'tsx?id=7&page=1&pageSize=10&paginate=true', NULL, 'Consultation tsx?id=7&page=1&pageSize=10&paginate=true ❌', 'Échec lors de consultation tsx?id=7&page=1&pagesize=10&paginate=true.', 'réussi', '2026-02-23 18:31:10', NULL, '2026-02-23 18:31:10', '2026-02-23 18:31:10'),
(1458, 'tsx?id=7&page=1&pageSize=10&paginate=true', NULL, 'Consultation tsx?id=7&page=1&pageSize=10&paginate=true ❌', 'Échec lors de consultation tsx?id=7&page=1&pagesize=10&paginate=true.', 'réussi', '2026-02-23 18:31:15', NULL, '2026-02-23 18:31:15', '2026-02-23 18:31:15'),
(1459, 'tsx?page=1&pageSize=1000&paginate=true', NULL, 'Consultation tsx?page=1&pageSize=1000&paginate=true ❌', 'Échec lors de consultation tsx?page=1&pagesize=1000&paginate=true.', 'réussi', '2026-02-23 18:31:25', NULL, '2026-02-23 18:31:25', '2026-02-23 18:31:25'),
(1460, 'tsx?page=1&pageSize=1000&paginate=true', NULL, 'Consultation tsx?page=1&pageSize=1000&paginate=true ❌', 'Échec lors de consultation tsx?page=1&pagesize=1000&paginate=true.', 'réussi', '2026-02-23 18:31:30', NULL, '2026-02-23 18:31:30', '2026-02-23 18:31:30'),
(1461, 'tsx?page=1&pageSize=1000&paginate=true', NULL, 'Consultation tsx?page=1&pageSize=1000&paginate=true ❌', 'Échec lors de consultation tsx?page=1&pagesize=1000&paginate=true.', 'réussi', '2026-02-23 18:31:47', NULL, '2026-02-23 18:31:47', '2026-02-23 18:31:47'),
(1462, 'notification_track?userId=7&search=&page=1&pageSize=20&paginate=true', NULL, 'Consultation notification_track?userId=7&search=&page=1&pageSize=20&paginate=true ❌', 'Échec lors de consultation notification_track?userid=7&search=&page=1&pagesize=20&paginate=true.', 'réussi', '2026-02-23 18:32:01', NULL, '2026-02-23 18:32:01', '2026-02-23 18:32:01'),
(1463, 'Retrait', 10, NULL, 'Retrait effectué', 'réussi', '2026-02-23 18:32:48', 7, '2026-02-23 18:32:48', '2026-02-23 18:32:48'),
(1464, 'Retrait', 10, NULL, 'Retrait client reçu', 'réussi', '2026-02-23 18:32:48', 10, '2026-02-23 18:32:48', '2026-02-23 18:32:48'),
(1465, 'Retrait', 0.2985, NULL, 'Frais retrait reçu', 'réussi', '2026-02-23 18:32:48', 2, '2026-02-23 18:32:48', '2026-02-23 18:32:48'),
(1466, 'retrait', NULL, 'Création retrait ✅', 'Création retrait effectuée avec succès.', 'réussi', '2026-02-23 18:32:51', NULL, '2026-02-23 18:32:51', '2026-02-23 18:32:51'),
(1467, '7', NULL, 'Consultation 7 ✅', 'Consultation 7 effectuée avec succès.', 'réussi', '2026-02-23 18:32:55', NULL, '2026-02-23 18:32:55', '2026-02-23 18:32:55'),
(1468, 'notification_track?userId=7&search=&page=1&pageSize=20&paginate=true', NULL, 'Consultation notification_track?userId=7&search=&page=1&pageSize=20&paginate=true ✅', 'Consultation notification_track?userId=7&search=&page=1&pageSize=20&paginate=true effectuée avec succès.', 'réussi', '2026-02-23 18:32:59', NULL, '2026-02-23 18:32:59', '2026-02-23 18:32:59'),
(1469, 'users?search=&page=1&pageSize=20&paginate=true', NULL, 'Consultation users?search=&page=1&pageSize=20&paginate=true ✅', 'Consultation users?search=&page=1&pageSize=20&paginate=true effectuée avec succès.', 'réussi', '2026-02-23 18:33:10', NULL, '2026-02-23 18:33:10', '2026-02-23 18:33:10'),
(1470, 'tsx?id=7&page=1&pageSize=10&paginate=true', NULL, 'Consultation tsx?id=7&page=1&pageSize=10&paginate=true ✅', 'Consultation tsx?id=7&page=1&pageSize=10&paginate=true effectuée avec succès.', 'réussi', '2026-02-23 18:33:20', NULL, '2026-02-23 18:33:20', '2026-02-23 18:33:20'),
(1471, 'tsx?page=1&pageSize=1000&paginate=true', NULL, 'Consultation tsx?page=1&pageSize=1000&paginate=true ✅', 'Consultation tsx?page=1&pageSize=1000&paginate=true effectuée avec succès.', 'réussi', '2026-02-23 18:33:34', NULL, '2026-02-23 18:33:34', '2026-02-23 18:33:34'),
(1472, 'tsx?page=1&pageSize=1000&paginate=true', NULL, 'Consultation tsx?page=1&pageSize=1000&paginate=true ❌', 'Échec lors de consultation tsx?page=1&pagesize=1000&paginate=true.', 'réussi', '2026-02-23 18:33:44', NULL, '2026-02-23 18:33:44', '2026-02-23 18:33:44'),
(1473, 'tsx?page=1&pageSize=1000&paginate=true', NULL, 'Consultation tsx?page=1&pageSize=1000&paginate=true ❌', 'Échec lors de consultation tsx?page=1&pagesize=1000&paginate=true.', 'réussi', '2026-02-23 18:33:52', NULL, '2026-02-23 18:33:52', '2026-02-23 18:33:52'),
(1474, 'users?search=&page=1&pageSize=20&paginate=true', NULL, 'Consultation users?search=&page=1&pageSize=20&paginate=true ❌', 'Échec lors de consultation users?search=&page=1&pagesize=20&paginate=true.', 'réussi', '2026-02-23 18:34:45', NULL, '2026-02-23 18:34:45', '2026-02-23 18:34:45'),
(1475, '7', NULL, 'Consultation 7 ❌', 'Échec lors de consultation 7.', 'réussi', '2026-02-23 18:35:54', NULL, '2026-02-23 18:35:54', '2026-02-23 18:35:54'),
(1476, 'notification_track?userId=7&search=&page=1&pageSize=20&paginate=true', NULL, 'Consultation notification_track?userId=7&search=&page=1&pageSize=20&paginate=true ❌', 'Échec lors de consultation notification_track?userid=7&search=&page=1&pagesize=20&paginate=true.', 'réussi', '2026-02-23 18:36:21', NULL, '2026-02-23 18:36:21', '2026-02-23 18:36:21'),
(1477, 'users?search=&page=1&pageSize=20&paginate=true', NULL, 'Consultation users?search=&page=1&pageSize=20&paginate=true ❌', 'Échec lors de consultation users?search=&page=1&pagesize=20&paginate=true.', 'réussi', '2026-02-23 18:39:42', NULL, '2026-02-23 18:39:42', '2026-02-23 18:39:42'),
(1478, 'users?search=&page=1&pageSize=20&paginate=true', NULL, 'Consultation users?search=&page=1&pageSize=20&paginate=true ❌', 'Échec lors de consultation users?search=&page=1&pagesize=20&paginate=true.', 'réussi', '2026-02-23 18:39:46', NULL, '2026-02-23 18:39:46', '2026-02-23 18:39:46'),
(1479, 'users?search=1&page=1&pageSize=20&paginate=true', NULL, 'Consultation users?search=1&page=1&pageSize=20&paginate=true ❌', 'Échec lors de consultation users?search=1&page=1&pagesize=20&paginate=true.', 'réussi', '2026-02-23 18:39:46', NULL, '2026-02-23 18:39:46', '2026-02-23 18:39:46'),
(1480, 'users?search=1&page=1&pageSize=20&paginate=true', NULL, 'Consultation users?search=1&page=1&pageSize=20&paginate=true ❌', 'Échec lors de consultation users?search=1&page=1&pagesize=20&paginate=true.', 'réussi', '2026-02-23 18:39:47', NULL, '2026-02-23 18:39:47', '2026-02-23 18:39:47');
INSERT INTO `histories` (`historyId`, `type`, `amount`, `action`, `description`, `status`, `date`, `userId`, `createdAt`, `updatedAt`) VALUES
(1481, 'users?search=1.&page=1&pageSize=20&paginate=true', NULL, 'Consultation users?search=1.&page=1&pageSize=20&paginate=true ✅', 'Consultation users?search=1.&page=1&pageSize=20&paginate=true effectuée avec succès.', 'réussi', '2026-02-23 18:39:47', NULL, '2026-02-23 18:39:47', '2026-02-23 18:39:47'),
(1482, 'users?search=1.&page=1&pageSize=20&paginate=true', NULL, 'Consultation users?search=1.&page=1&pageSize=20&paginate=true ❌', 'Échec lors de consultation users?search=1.&page=1&pagesize=20&paginate=true.', 'réussi', '2026-02-23 18:39:47', NULL, '2026-02-23 18:39:47', '2026-02-23 18:39:47'),
(1483, 'users?search=1.5&page=1&pageSize=20&paginate=true', NULL, 'Consultation users?search=1.5&page=1&pageSize=20&paginate=true ✅', 'Consultation users?search=1.5&page=1&pageSize=20&paginate=true effectuée avec succès.', 'réussi', '2026-02-23 18:39:47', NULL, '2026-02-23 18:39:47', '2026-02-23 18:39:47'),
(1484, 'users?search=1.5&page=1&pageSize=20&paginate=true', NULL, 'Consultation users?search=1.5&page=1&pageSize=20&paginate=true ❌', 'Échec lors de consultation users?search=1.5&page=1&pagesize=20&paginate=true.', 'réussi', '2026-02-23 18:39:56', NULL, '2026-02-23 18:39:56', '2026-02-23 18:39:56'),
(1485, 'users?search=1.&page=1&pageSize=20&paginate=true', NULL, 'Consultation users?search=1.&page=1&pageSize=20&paginate=true ❌', 'Échec lors de consultation users?search=1.&page=1&pagesize=20&paginate=true.', 'réussi', '2026-02-23 18:39:57', NULL, '2026-02-23 18:39:57', '2026-02-23 18:39:57'),
(1486, 'users?search=1&page=1&pageSize=20&paginate=true', NULL, 'Consultation users?search=1&page=1&pageSize=20&paginate=true ❌', 'Échec lors de consultation users?search=1&page=1&pagesize=20&paginate=true.', 'réussi', '2026-02-23 18:39:57', NULL, '2026-02-23 18:39:57', '2026-02-23 18:39:57'),
(1487, 'users?search=Leader+Mushio&page=1&pageSize=20&paginate=true', NULL, 'Consultation users?search=Leader+Mushio&page=1&pageSize=20&paginate=true ✅', 'Consultation users?search=Leader+Mushio&page=1&pageSize=20&paginate=true effectuée avec succès.', 'réussi', '2026-02-23 18:39:58', NULL, '2026-02-23 18:39:58', '2026-02-23 18:39:58'),
(1488, 'users?search=Leader+Mushi&page=1&pageSize=20&paginate=true', NULL, 'Consultation users?search=Leader+Mushi&page=1&pageSize=20&paginate=true ✅', 'Consultation users?search=Leader+Mushi&page=1&pageSize=20&paginate=true effectuée avec succès.', 'réussi', '2026-02-23 18:40:03', NULL, '2026-02-23 18:40:03', '2026-02-23 18:40:03'),
(1489, 'users?search=Leader+Mushio&page=1&pageSize=20&paginate=true', NULL, 'Consultation users?search=Leader+Mushio&page=1&pageSize=20&paginate=true ❌', 'Échec lors de consultation users?search=leader+mushio&page=1&pagesize=20&paginate=true.', 'réussi', '2026-02-23 18:40:04', NULL, '2026-02-23 18:40:04', '2026-02-23 18:40:04'),
(1490, 'users?search=Leader+Mush&page=1&pageSize=20&paginate=true', NULL, 'Consultation users?search=Leader+Mush&page=1&pageSize=20&paginate=true ✅', 'Consultation users?search=Leader+Mush&page=1&pageSize=20&paginate=true effectuée avec succès.', 'réussi', '2026-02-23 18:40:04', NULL, '2026-02-23 18:40:04', '2026-02-23 18:40:04'),
(1491, 'users?search=Leader+Mushi&page=1&pageSize=20&paginate=true', NULL, 'Consultation users?search=Leader+Mushi&page=1&pageSize=20&paginate=true ❌', 'Échec lors de consultation users?search=leader+mushi&page=1&pagesize=20&paginate=true.', 'réussi', '2026-02-23 18:40:04', NULL, '2026-02-23 18:40:04', '2026-02-23 18:40:04'),
(1492, 'users?search=Leader+Mus&page=1&pageSize=20&paginate=true', NULL, 'Consultation users?search=Leader+Mus&page=1&pageSize=20&paginate=true ✅', 'Consultation users?search=Leader+Mus&page=1&pageSize=20&paginate=true effectuée avec succès.', 'réussi', '2026-02-23 18:40:04', NULL, '2026-02-23 18:40:04', '2026-02-23 18:40:04'),
(1493, 'users?search=Leader+Mu&page=1&pageSize=20&paginate=true', NULL, 'Consultation users?search=Leader+Mu&page=1&pageSize=20&paginate=true ✅', 'Consultation users?search=Leader+Mu&page=1&pageSize=20&paginate=true effectuée avec succès.', 'réussi', '2026-02-23 18:40:04', NULL, '2026-02-23 18:40:04', '2026-02-23 18:40:04'),
(1494, 'users?search=Leader+Mu&page=1&pageSize=20&paginate=true', NULL, 'Consultation users?search=Leader+Mu&page=1&pageSize=20&paginate=true ❌', 'Échec lors de consultation users?search=leader+mu&page=1&pagesize=20&paginate=true.', 'réussi', '2026-02-23 18:40:04', NULL, '2026-02-23 18:40:04', '2026-02-23 18:40:04'),
(1495, 'users?search=Leader+M&page=1&pageSize=20&paginate=true', NULL, 'Consultation users?search=Leader+M&page=1&pageSize=20&paginate=true ✅', 'Consultation users?search=Leader+M&page=1&pageSize=20&paginate=true effectuée avec succès.', 'réussi', '2026-02-23 18:40:04', NULL, '2026-02-23 18:40:04', '2026-02-23 18:40:04'),
(1496, 'users?search=Leader+M&page=1&pageSize=20&paginate=true', NULL, 'Consultation users?search=Leader+M&page=1&pageSize=20&paginate=true ❌', 'Échec lors de consultation users?search=leader+m&page=1&pagesize=20&paginate=true.', 'réussi', '2026-02-23 18:40:04', NULL, '2026-02-23 18:40:04', '2026-02-23 18:40:04'),
(1497, 'users?search=Leader+&page=1&pageSize=20&paginate=true', NULL, 'Consultation users?search=Leader+&page=1&pageSize=20&paginate=true ✅', 'Consultation users?search=Leader+&page=1&pageSize=20&paginate=true effectuée avec succès.', 'réussi', '2026-02-23 18:40:04', NULL, '2026-02-23 18:40:04', '2026-02-23 18:40:04'),
(1498, 'users?search=Leader+&page=1&pageSize=20&paginate=true', NULL, 'Consultation users?search=Leader+&page=1&pageSize=20&paginate=true ❌', 'Échec lors de consultation users?search=leader+&page=1&pagesize=20&paginate=true.', 'réussi', '2026-02-23 18:40:04', NULL, '2026-02-23 18:40:04', '2026-02-23 18:40:04'),
(1499, 'users?search=Leader&page=1&pageSize=20&paginate=true', NULL, 'Consultation users?search=Leader&page=1&pageSize=20&paginate=true ✅', 'Consultation users?search=Leader&page=1&pageSize=20&paginate=true effectuée avec succès.', 'réussi', '2026-02-23 18:40:04', NULL, '2026-02-23 18:40:04', '2026-02-23 18:40:04'),
(1500, 'users?search=Leade&page=1&pageSize=20&paginate=true', NULL, 'Consultation users?search=Leade&page=1&pageSize=20&paginate=true ✅', 'Consultation users?search=Leade&page=1&pageSize=20&paginate=true effectuée avec succès.', 'réussi', '2026-02-23 18:40:04', NULL, '2026-02-23 18:40:04', '2026-02-23 18:40:04'),
(1501, 'users?search=Leade&page=1&pageSize=20&paginate=true', NULL, 'Consultation users?search=Leade&page=1&pageSize=20&paginate=true ❌', 'Échec lors de consultation users?search=leade&page=1&pagesize=20&paginate=true.', 'réussi', '2026-02-23 18:40:05', NULL, '2026-02-23 18:40:05', '2026-02-23 18:40:05'),
(1502, 'users?search=Lead&page=1&pageSize=20&paginate=true', NULL, 'Consultation users?search=Lead&page=1&pageSize=20&paginate=true ✅', 'Consultation users?search=Lead&page=1&pageSize=20&paginate=true effectuée avec succès.', 'réussi', '2026-02-23 18:40:05', NULL, '2026-02-23 18:40:05', '2026-02-23 18:40:05'),
(1503, 'users?search=Lead&page=1&pageSize=20&paginate=true', NULL, 'Consultation users?search=Lead&page=1&pageSize=20&paginate=true ❌', 'Échec lors de consultation users?search=lead&page=1&pagesize=20&paginate=true.', 'réussi', '2026-02-23 18:40:05', NULL, '2026-02-23 18:40:05', '2026-02-23 18:40:05'),
(1504, 'users?search=Lea&page=1&pageSize=20&paginate=true', NULL, 'Consultation users?search=Lea&page=1&pageSize=20&paginate=true ✅', 'Consultation users?search=Lea&page=1&pageSize=20&paginate=true effectuée avec succès.', 'réussi', '2026-02-23 18:40:05', NULL, '2026-02-23 18:40:05', '2026-02-23 18:40:05'),
(1505, 'users?search=Lea&page=1&pageSize=20&paginate=true', NULL, 'Consultation users?search=Lea&page=1&pageSize=20&paginate=true ❌', 'Échec lors de consultation users?search=lea&page=1&pagesize=20&paginate=true.', 'réussi', '2026-02-23 18:40:05', NULL, '2026-02-23 18:40:05', '2026-02-23 18:40:05'),
(1506, 'users?search=Le&page=1&pageSize=20&paginate=true', NULL, 'Consultation users?search=Le&page=1&pageSize=20&paginate=true ✅', 'Consultation users?search=Le&page=1&pageSize=20&paginate=true effectuée avec succès.', 'réussi', '2026-02-23 18:40:05', NULL, '2026-02-23 18:40:05', '2026-02-23 18:40:05'),
(1507, 'users?search=L&page=1&pageSize=20&paginate=true', NULL, 'Consultation users?search=L&page=1&pageSize=20&paginate=true ✅', 'Consultation users?search=L&page=1&pageSize=20&paginate=true effectuée avec succès.', 'réussi', '2026-02-23 18:40:05', NULL, '2026-02-23 18:40:05', '2026-02-23 18:40:05'),
(1508, 'users?search=L&page=1&pageSize=20&paginate=true', NULL, 'Consultation users?search=L&page=1&pageSize=20&paginate=true ❌', 'Échec lors de consultation users?search=l&page=1&pagesize=20&paginate=true.', 'réussi', '2026-02-23 18:40:05', NULL, '2026-02-23 18:40:05', '2026-02-23 18:40:05'),
(1509, 'users?search=user_9gqpq&page=1&pageSize=20&paginate=true', NULL, 'Consultation users?search=user_9gqpq&page=1&pageSize=20&paginate=true ✅', 'Consultation users?search=user_9gqpq&page=1&pageSize=20&paginate=true effectuée avec succès.', 'réussi', '2026-02-23 18:40:14', NULL, '2026-02-23 18:40:14', '2026-02-23 18:40:14'),
(1510, 'users?search=Malo&page=1&pageSize=20&paginate=true', NULL, 'Consultation users?search=Malo&page=1&pageSize=20&paginate=true ✅', 'Consultation users?search=Malo&page=1&pageSize=20&paginate=true effectuée avec succès.', 'réussi', '2026-02-23 18:40:18', NULL, '2026-02-23 18:40:18', '2026-02-23 18:40:18'),
(1511, 'Transfert', 1.5, NULL, 'Transfert à Malo', 'réussi', '2026-02-23 18:40:47', 7, '2026-02-23 18:40:47', '2026-02-23 18:40:47'),
(1512, 'transfert', NULL, 'Création transfert ✅', 'Création transfert effectuée avec succès.', 'réussi', '2026-02-23 18:40:47', NULL, '2026-02-23 18:40:47', '2026-02-23 18:40:47'),
(1513, '7', NULL, 'Consultation 7 ✅', 'Consultation 7 effectuée avec succès.', 'réussi', '2026-02-23 18:40:52', NULL, '2026-02-23 18:40:52', '2026-02-23 18:40:52'),
(1514, 'retrait', NULL, 'Création retrait ❌', 'Échec lors de création retrait.', 'réussi', '2026-02-23 18:41:50', NULL, '2026-02-23 18:41:50', '2026-02-23 18:41:50'),
(1515, 'retrait', NULL, 'Création retrait ❌', 'Échec lors de création retrait.', 'réussi', '2026-02-23 18:42:23', NULL, '2026-02-23 18:42:23', '2026-02-23 18:42:23'),
(1516, 'retrait', NULL, 'Création retrait ❌', 'Échec lors de création retrait.', 'réussi', '2026-02-23 18:50:05', NULL, '2026-02-23 18:50:05', '2026-02-23 18:50:05'),
(1517, 'Retrait', 5.5, NULL, 'Retrait effectué', 'réussi', '2026-02-23 18:50:45', 7, '2026-02-23 18:50:45', '2026-02-23 18:50:45'),
(1518, 'Retrait', 5.5, NULL, 'Retrait client reçu', 'réussi', '2026-02-23 18:50:45', 10, '2026-02-23 18:50:45', '2026-02-23 18:50:45'),
(1519, 'Retrait', 0.164175, NULL, 'Frais retrait reçu', 'réussi', '2026-02-23 18:50:45', 2, '2026-02-23 18:50:45', '2026-02-23 18:50:45'),
(1520, 'retrait', NULL, 'Création retrait ✅', 'Création retrait effectuée avec succès.', 'réussi', '2026-02-23 18:50:47', NULL, '2026-02-23 18:50:47', '2026-02-23 18:50:47'),
(1521, '7', NULL, 'Consultation 7 ✅', 'Consultation 7 effectuée avec succès.', 'réussi', '2026-02-23 18:50:52', NULL, '2026-02-23 18:50:52', '2026-02-23 18:50:52'),
(1522, '7', NULL, 'Consultation 7 ❌', 'Échec lors de consultation 7.', 'réussi', '2026-02-23 18:53:06', NULL, '2026-02-23 18:53:06', '2026-02-23 18:53:06'),
(1523, 'createrecharge', NULL, 'Création createrecharge ❌', 'Échec lors de création createrecharge.', 'réussi', '2026-02-23 18:55:50', NULL, '2026-02-23 18:55:50', '2026-02-23 18:55:50'),
(1524, 'users?search=&page=1&pageSize=20&paginate=true', NULL, 'Consultation users?search=&page=1&pageSize=20&paginate=true ✅', 'Consultation users?search=&page=1&pageSize=20&paginate=true effectuée avec succès.', 'réussi', '2026-02-23 18:55:58', NULL, '2026-02-23 18:55:58', '2026-02-23 18:55:58'),
(1525, 'Transfert', 1.8, NULL, 'Transfert à Leader Mushio', 'réussi', '2026-02-23 18:58:37', 7, '2026-02-23 18:58:37', '2026-02-23 18:58:37'),
(1526, 'transfert', NULL, 'Création transfert ✅', 'Création transfert effectuée avec succès.', 'réussi', '2026-02-23 18:58:37', NULL, '2026-02-23 18:58:37', '2026-02-23 18:58:37'),
(1527, '7', NULL, 'Consultation 7 ✅', 'Consultation 7 effectuée avec succès.', 'réussi', '2026-02-23 18:58:41', NULL, '2026-02-23 18:58:41', '2026-02-23 18:58:41'),
(1528, 'notification_track?userId=7&search=&page=1&pageSize=20&paginate=true', NULL, 'Consultation notification_track?userId=7&search=&page=1&pageSize=20&paginate=true ✅', 'Consultation notification_track?userId=7&search=&page=1&pageSize=20&paginate=true effectuée avec succès.', 'réussi', '2026-02-23 18:58:42', NULL, '2026-02-23 18:58:42', '2026-02-23 18:58:42'),
(1529, 'notification_track?userId=7&search=&page=1&pageSize=20&paginate=true', NULL, 'Consultation notification_track?userId=7&search=&page=1&pageSize=20&paginate=true ❌', 'Échec lors de consultation notification_track?userid=7&search=&page=1&pagesize=20&paginate=true.', 'réussi', '2026-02-23 18:58:44', NULL, '2026-02-23 18:58:44', '2026-02-23 18:58:44'),
(1530, 'tsx?page=1&pageSize=1000&paginate=true', NULL, 'Consultation tsx?page=1&pageSize=1000&paginate=true ✅', 'Consultation tsx?page=1&pageSize=1000&paginate=true effectuée avec succès.', 'réussi', '2026-02-23 18:58:57', NULL, '2026-02-23 18:58:57', '2026-02-23 18:58:57'),
(1531, 'product?page=1&pageSize=10&search=&paginate=true&companyId=8', NULL, 'Consultation product?page=1&pageSize=10&search=&paginate=true&companyId=8 ❌', 'Échec lors de consultation product?page=1&pagesize=10&search=&paginate=true&companyid=8.', 'réussi', '2026-02-23 18:59:29', NULL, '2026-02-23 18:59:29', '2026-02-23 18:59:29'),
(1532, 'tsx?id=7&page=1&pageSize=10&paginate=true', NULL, 'Consultation tsx?id=7&page=1&pageSize=10&paginate=true ✅', 'Consultation tsx?id=7&page=1&pageSize=10&paginate=true effectuée avec succès.', 'réussi', '2026-02-23 19:00:10', NULL, '2026-02-23 19:00:10', '2026-02-23 19:00:10'),
(1533, 'users?search=&page=1&pageSize=20&paginate=true', NULL, 'Consultation users?search=&page=1&pageSize=20&paginate=true ✅', 'Consultation users?search=&page=1&pageSize=20&paginate=true effectuée avec succès.', 'réussi', '2026-02-23 19:00:32', NULL, '2026-02-23 19:00:32', '2026-02-23 19:00:32'),
(1534, '7', NULL, 'Consultation 7 ✅', 'Consultation 7 effectuée avec succès.', 'réussi', '2026-02-23 19:13:28', NULL, '2026-02-23 19:13:28', '2026-02-23 19:13:28'),
(1535, 'profile', NULL, 'Mise à jour profile ✅', 'Mise à jour profile effectuée avec succès.', 'réussi', '2026-02-23 19:13:39', NULL, '2026-02-23 19:13:39', '2026-02-23 19:13:39'),
(1536, '7', NULL, 'Consultation 7 ✅', 'Consultation 7 effectuée avec succès.', 'réussi', '2026-02-23 19:13:40', NULL, '2026-02-23 19:13:40', '2026-02-23 19:13:40'),
(1537, 'MODIFICATION_PROFIL', NULL, 'Profil modifié ✅', 'Profil mis à jour.', 'réussi', '2026-02-23 19:13:40', NULL, '2026-02-23 19:13:40', '2026-02-23 19:13:40'),
(1538, 'create', NULL, 'Création create ✅', 'Création create effectuée avec succès.', 'réussi', '2026-02-23 19:13:40', NULL, '2026-02-23 19:13:40', '2026-02-23 19:13:40'),
(1539, 'create', NULL, 'Création create ✅', 'Création create effectuée avec succès.', 'réussi', '2026-02-23 19:13:40', NULL, '2026-02-23 19:13:40', '2026-02-23 19:13:40'),
(1540, 'notification_track?userId=7&search=&page=1&pageSize=20&paginate=true', NULL, 'Consultation notification_track?userId=7&search=&page=1&pageSize=20&paginate=true ✅', 'Consultation notification_track?userId=7&search=&page=1&pageSize=20&paginate=true effectuée avec succès.', 'réussi', '2026-02-23 19:13:42', NULL, '2026-02-23 19:13:42', '2026-02-23 19:13:42'),
(1541, 'notification_track?userId=7&search=&page=1&pageSize=20&paginate=true', NULL, 'Consultation notification_track?userId=7&search=&page=1&pageSize=20&paginate=true ❌', 'Échec lors de consultation notification_track?userid=7&search=&page=1&pagesize=20&paginate=true.', 'réussi', '2026-02-23 19:15:27', NULL, '2026-02-23 19:15:27', '2026-02-23 19:15:27'),
(1542, 'transaction', NULL, 'Consultation des transactions 📄', 'La liste de vos transactions a été consultée avec succès.', 'réussi', '2026-02-23 19:19:22', NULL, '2026-02-23 19:19:22', '2026-02-23 19:19:22'),
(1543, 'tsx?userId=7', NULL, 'Consultation tsx?userId=7 ✅', 'Consultation tsx?userId=7 effectuée avec succès.', 'réussi', '2026-02-23 19:19:22', NULL, '2026-02-23 19:19:22', '2026-02-23 19:19:22'),
(1544, 'users?search=&page=1&pageSize=20&paginate=true', NULL, 'Consultation users?search=&page=1&pageSize=20&paginate=true ✅', 'Consultation users?search=&page=1&pageSize=20&paginate=true effectuée avec succès.', 'réussi', '2026-02-23 19:36:40', NULL, '2026-02-23 19:36:40', '2026-02-23 19:36:40'),
(1545, 'users?search=5&page=1&pageSize=20&paginate=true', NULL, 'Consultation users?search=5&page=1&pageSize=20&paginate=true ✅', 'Consultation users?search=5&page=1&pageSize=20&paginate=true effectuée avec succès.', 'réussi', '2026-02-23 19:36:45', NULL, '2026-02-23 19:36:45', '2026-02-23 19:36:45'),
(1546, 'users?search=&page=1&pageSize=20&paginate=true', NULL, 'Consultation users?search=&page=1&pageSize=20&paginate=true ❌', 'Échec lors de consultation users?search=&page=1&pagesize=20&paginate=true.', 'réussi', '2026-02-23 19:36:45', NULL, '2026-02-23 19:36:45', '2026-02-23 19:36:45'),
(1547, 'users?search=5&page=1&pageSize=20&paginate=true', NULL, 'Consultation users?search=5&page=1&pageSize=20&paginate=true ❌', 'Échec lors de consultation users?search=5&page=1&pagesize=20&paginate=true.', 'réussi', '2026-02-23 19:36:52', NULL, '2026-02-23 19:36:52', '2026-02-23 19:36:52'),
(1548, 'users?search=&page=1&pageSize=20&paginate=true', NULL, 'Consultation users?search=&page=1&pageSize=20&paginate=true ❌', 'Échec lors de consultation users?search=&page=1&pagesize=20&paginate=true.', 'réussi', '2026-02-23 19:37:07', NULL, '2026-02-23 19:37:07', '2026-02-23 19:37:07'),
(1549, 'users?search=L&page=1&pageSize=20&paginate=true', NULL, 'Consultation users?search=L&page=1&pageSize=20&paginate=true ✅', 'Consultation users?search=L&page=1&pageSize=20&paginate=true effectuée avec succès.', 'réussi', '2026-02-23 19:37:07', NULL, '2026-02-23 19:37:07', '2026-02-23 19:37:07'),
(1550, 'users?search=Le&page=1&pageSize=20&paginate=true', NULL, 'Consultation users?search=Le&page=1&pageSize=20&paginate=true ✅', 'Consultation users?search=Le&page=1&pageSize=20&paginate=true effectuée avec succès.', 'réussi', '2026-02-23 19:37:07', NULL, '2026-02-23 19:37:07', '2026-02-23 19:37:07'),
(1551, 'users?search=L&page=1&pageSize=20&paginate=true', NULL, 'Consultation users?search=L&page=1&pageSize=20&paginate=true ❌', 'Échec lors de consultation users?search=l&page=1&pagesize=20&paginate=true.', 'réussi', '2026-02-23 19:37:07', NULL, '2026-02-23 19:37:07', '2026-02-23 19:37:07'),
(1552, 'users?search=Le&page=1&pageSize=20&paginate=true', NULL, 'Consultation users?search=Le&page=1&pageSize=20&paginate=true ❌', 'Échec lors de consultation users?search=le&page=1&pagesize=20&paginate=true.', 'réussi', '2026-02-23 19:37:08', NULL, '2026-02-23 19:37:08', '2026-02-23 19:37:08'),
(1553, 'users?search=Lea&page=1&pageSize=20&paginate=true', NULL, 'Consultation users?search=Lea&page=1&pageSize=20&paginate=true ✅', 'Consultation users?search=Lea&page=1&pageSize=20&paginate=true effectuée avec succès.', 'réussi', '2026-02-23 19:37:08', NULL, '2026-02-23 19:37:08', '2026-02-23 19:37:08'),
(1554, 'users?search=Lea&page=1&pageSize=20&paginate=true', NULL, 'Consultation users?search=Lea&page=1&pageSize=20&paginate=true ❌', 'Échec lors de consultation users?search=lea&page=1&pagesize=20&paginate=true.', 'réussi', '2026-02-23 19:37:09', NULL, '2026-02-23 19:37:09', '2026-02-23 19:37:09'),
(1555, 'users?search=L%C3%A9a&page=1&pageSize=20&paginate=true', NULL, 'Consultation users?search=L%C3%A9a&page=1&pageSize=20&paginate=true ✅', 'Consultation users?search=L%C3%A9a&page=1&pageSize=20&paginate=true effectuée avec succès.', 'réussi', '2026-02-23 19:37:09', NULL, '2026-02-23 19:37:09', '2026-02-23 19:37:09'),
(1556, 'users?search=john&page=1&pageSize=20&paginate=true', NULL, 'Consultation users?search=john&page=1&pageSize=20&paginate=true ✅', 'Consultation users?search=john&page=1&pageSize=20&paginate=true effectuée avec succès.', 'réussi', '2026-02-23 19:37:10', NULL, '2026-02-23 19:37:10', '2026-02-23 19:37:10'),
(1557, 'transfert', NULL, 'Création transfert ❌', 'Échec lors de création transfert.', 'réussi', '2026-02-23 19:37:50', NULL, '2026-02-23 19:37:50', '2026-02-23 19:37:50'),
(1558, 'Transfert', 10, 'Transfert EC ✅', 'Transfert envoyé à john', 'réussi', '2026-02-23 19:44:39', 7, '2026-02-23 19:44:39', '2026-02-23 19:44:39'),
(1559, 'transfert', NULL, 'Création transfert ✅', 'Création transfert effectuée avec succès.', 'réussi', '2026-02-23 19:44:40', NULL, '2026-02-23 19:44:40', '2026-02-23 19:44:40'),
(1560, 'users?search=&page=1&pageSize=20&paginate=true', NULL, 'Consultation users?search=&page=1&pageSize=20&paginate=true ✅', 'Consultation users?search=&page=1&pageSize=20&paginate=true effectuée avec succès.', 'réussi', '2026-02-23 19:44:40', NULL, '2026-02-23 19:44:40', '2026-02-23 19:44:40'),
(1561, '7', NULL, 'Consultation 7 ✅', 'Consultation 7 effectuée avec succès.', 'réussi', '2026-02-23 19:44:43', NULL, '2026-02-23 19:44:43', '2026-02-23 19:44:43'),
(1562, 'notification_track?userId=7&search=&page=1&pageSize=20&paginate=true', NULL, 'Consultation notification_track?userId=7&search=&page=1&pageSize=20&paginate=true ✅', 'Consultation notification_track?userId=7&search=&page=1&pageSize=20&paginate=true effectuée avec succès.', 'réussi', '2026-02-23 19:44:44', NULL, '2026-02-23 19:44:44', '2026-02-23 19:44:44'),
(1563, 'notification_track?userId=7&search=&page=1&pageSize=20&paginate=true', NULL, 'Consultation notification_track?userId=7&search=&page=1&pageSize=20&paginate=true ❌', 'Échec lors de consultation notification_track?userid=7&search=&page=1&pagesize=20&paginate=true.', 'réussi', '2026-02-23 19:44:46', NULL, '2026-02-23 19:44:46', '2026-02-23 19:44:46'),
(1564, 'tsx?id=7&page=1&pageSize=10&paginate=true', NULL, 'Consultation tsx?id=7&page=1&pageSize=10&paginate=true ✅', 'Consultation tsx?id=7&page=1&pageSize=10&paginate=true effectuée avec succès.', 'réussi', '2026-02-23 19:44:50', NULL, '2026-02-23 19:44:50', '2026-02-23 19:44:50'),
(1565, 'tsx?page=1&pageSize=1000&paginate=true', NULL, 'Consultation tsx?page=1&pageSize=1000&paginate=true ✅', 'Consultation tsx?page=1&pageSize=1000&paginate=true effectuée avec succès.', 'réussi', '2026-02-23 19:46:13', NULL, '2026-02-23 19:46:13', '2026-02-23 19:46:13'),
(1566, 'tsx?page=1&pageSize=1000&paginate=true', NULL, 'Consultation tsx?page=1&pageSize=1000&paginate=true ❌', 'Échec lors de consultation tsx?page=1&pagesize=1000&paginate=true.', 'réussi', '2026-02-23 19:47:48', NULL, '2026-02-23 19:47:48', '2026-02-23 19:47:48'),
(1567, '7', NULL, 'Consultation 7 ❌', 'Échec lors de consultation 7.', 'réussi', '2026-02-23 20:10:02', NULL, '2026-02-23 20:10:02', '2026-02-23 20:10:02'),
(1568, 'sector?page=1&pageSize=20&search=&paginate=false', NULL, 'Consultation sector?page=1&pageSize=20&search=&paginate=false ❌', 'Échec lors de consultation sector?page=1&pagesize=20&search=&paginate=false.', 'réussi', '2026-02-23 20:10:02', NULL, '2026-02-23 20:10:02', '2026-02-23 20:10:02'),
(1569, 'notification_track?userId=7&search=&page=1&pageSize=20&paginate=true', NULL, 'Consultation notification_track?userId=7&search=&page=1&pageSize=20&paginate=true ❌', 'Échec lors de consultation notification_track?userid=7&search=&page=1&pagesize=20&paginate=true.', 'réussi', '2026-02-23 20:10:40', NULL, '2026-02-23 20:10:40', '2026-02-23 20:10:40'),
(1570, 'sector?page=1&pageSize=20&search=&paginate=false', NULL, 'Consultation sector?page=1&pageSize=20&search=&paginate=false ❌', 'Échec lors de consultation sector?page=1&pagesize=20&search=&paginate=false.', 'réussi', '2026-02-23 20:14:03', NULL, '2026-02-23 20:14:03', '2026-02-23 20:14:03'),
(1571, '1', NULL, 'Consultation 1 ✅', 'Consultation 1 effectuée avec succès.', 'réussi', '2026-02-23 20:14:03', NULL, '2026-02-23 20:14:03', '2026-02-23 20:14:03'),
(1572, '7', NULL, 'Consultation 7 ✅', 'Consultation 7 effectuée avec succès.', 'réussi', '2026-02-23 20:14:11', NULL, '2026-02-23 20:14:11', '2026-02-23 20:14:11'),
(1573, 'tsx?id=1&page=1&pageSize=10&paginate=true', NULL, 'Consultation tsx?id=1&page=1&pageSize=10&paginate=true ✅', 'Consultation tsx?id=1&page=1&pageSize=10&paginate=true effectuée avec succès.', 'réussi', '2026-02-23 20:15:34', NULL, '2026-02-23 20:15:34', '2026-02-23 20:15:34'),
(1574, 'users?search=&page=1&pageSize=20&paginate=true', NULL, 'Consultation users?search=&page=1&pageSize=20&paginate=true ✅', 'Consultation users?search=&page=1&pageSize=20&paginate=true effectuée avec succès.', 'réussi', '2026-02-23 20:16:33', NULL, '2026-02-23 20:16:33', '2026-02-23 20:16:33'),
(1575, 'product?page=1&pageSize=10&search=&paginate=true&companyId=11', NULL, 'Consultation product?page=1&pageSize=10&search=&paginate=true&companyId=11 ✅', 'Consultation product?page=1&pageSize=10&search=&paginate=true&companyId=11 effectuée avec succès.', 'réussi', '2026-02-23 20:16:47', NULL, '2026-02-23 20:16:47', '2026-02-23 20:16:47'),
(1576, 'users?search=&page=1&pageSize=20&paginate=true', NULL, 'Consultation users?search=&page=1&pageSize=20&paginate=true ✅', 'Consultation users?search=&page=1&pageSize=20&paginate=true effectuée avec succès.', 'réussi', '2026-02-23 20:17:36', NULL, '2026-02-23 20:17:36', '2026-02-23 20:17:36'),
(1577, 'users?search=user_4ekko&page=1&pageSize=20&paginate=true', NULL, 'Consultation users?search=user_4ekko&page=1&pageSize=20&paginate=true ✅', 'Consultation users?search=user_4ekko&page=1&pageSize=20&paginate=true effectuée avec succès.', 'réussi', '2026-02-23 20:17:47', NULL, '2026-02-23 20:17:47', '2026-02-23 20:17:47'),
(1578, 'Transfert', 1.5, 'Transfert EC ✅', 'Transfert envoyé à user_4ekko', 'réussi', '2026-02-23 20:18:13', 7, '2026-02-23 20:18:13', '2026-02-23 20:18:13'),
(1579, 'transfert', NULL, 'Création transfert ✅', 'Création transfert effectuée avec succès.', 'réussi', '2026-02-23 20:18:13', NULL, '2026-02-23 20:18:13', '2026-02-23 20:18:13'),
(1580, '7', NULL, 'Consultation 7 ✅', 'Consultation 7 effectuée avec succès.', 'réussi', '2026-02-23 20:18:18', NULL, '2026-02-23 20:18:18', '2026-02-23 20:18:18'),
(1581, 'notification_track?userId=7&search=&page=1&pageSize=20&paginate=true', NULL, 'Consultation notification_track?userId=7&search=&page=1&pageSize=20&paginate=true ✅', 'Consultation notification_track?userId=7&search=&page=1&pageSize=20&paginate=true effectuée avec succès.', 'réussi', '2026-02-23 20:18:22', NULL, '2026-02-23 20:18:22', '2026-02-23 20:18:22'),
(1582, 'notification_track?userId=7&search=&page=1&pageSize=20&paginate=true', NULL, 'Consultation notification_track?userId=7&search=&page=1&pageSize=20&paginate=true ❌', 'Échec lors de consultation notification_track?userid=7&search=&page=1&pagesize=20&paginate=true.', 'réussi', '2026-02-23 20:18:24', NULL, '2026-02-23 20:18:24', '2026-02-23 20:18:24'),
(1583, 'tsx?id=7&page=1&pageSize=10&paginate=true', NULL, 'Consultation tsx?id=7&page=1&pageSize=10&paginate=true ✅', 'Consultation tsx?id=7&page=1&pageSize=10&paginate=true effectuée avec succès.', 'réussi', '2026-02-23 20:18:39', NULL, '2026-02-23 20:18:39', '2026-02-23 20:18:39'),
(1584, 'tsx?page=1&pageSize=1000&paginate=true', NULL, 'Consultation tsx?page=1&pageSize=1000&paginate=true ✅', 'Consultation tsx?page=1&pageSize=1000&paginate=true effectuée avec succès.', 'réussi', '2026-02-23 20:18:42', NULL, '2026-02-23 20:18:42', '2026-02-23 20:18:42'),
(1585, 'tsx?page=1&pageSize=1000&paginate=true', NULL, 'Consultation tsx?page=1&pageSize=1000&paginate=true ❌', 'Échec lors de consultation tsx?page=1&pagesize=1000&paginate=true.', 'réussi', '2026-02-23 20:18:44', NULL, '2026-02-23 20:18:44', '2026-02-23 20:18:44'),
(1586, 'sector?page=1&pageSize=10&search=&paginate=true', NULL, 'Consultation sector?page=1&pageSize=10&search=&paginate=true ❌', 'Échec lors de consultation sector?page=1&pagesize=10&search=&paginate=true.', 'réussi', '2026-02-23 20:19:17', NULL, '2026-02-23 20:19:17', '2026-02-23 20:19:17'),
(1587, 'notification_track?userId=7&search=&page=1&pageSize=20&paginate=true', NULL, 'Consultation notification_track?userId=7&search=&page=1&pageSize=20&paginate=true ❌', 'Échec lors de consultation notification_track?userid=7&search=&page=1&pagesize=20&paginate=true.', 'réussi', '2026-02-23 20:21:11', NULL, '2026-02-23 20:21:11', '2026-02-23 20:21:11'),
(1588, 'users?search=&page=1&pageSize=20&paginate=true', NULL, 'Consultation users?search=&page=1&pageSize=20&paginate=true ✅', 'Consultation users?search=&page=1&pageSize=20&paginate=true effectuée avec succès.', 'réussi', '2026-02-23 20:21:13', NULL, '2026-02-23 20:21:13', '2026-02-23 20:21:13'),
(1589, '7', NULL, 'Consultation 7 ❌', 'Échec lors de consultation 7.', 'réussi', '2026-02-23 20:21:15', NULL, '2026-02-23 20:21:15', '2026-02-23 20:21:15'),
(1590, 'sector?page=2&pageSize=10&search=&paginate=true', NULL, 'Consultation sector?page=2&pageSize=10&search=&paginate=true ❌', 'Échec lors de consultation sector?page=2&pagesize=10&search=&paginate=true.', 'réussi', '2026-02-23 20:21:34', NULL, '2026-02-23 20:21:34', '2026-02-23 20:21:34'),
(1591, 'product?page=1&pageSize=10&search=&paginate=true&companyId=8', NULL, 'Consultation product?page=1&pageSize=10&search=&paginate=true&companyId=8 ❌', 'Échec lors de consultation product?page=1&pagesize=10&search=&paginate=true&companyid=8.', 'réussi', '2026-02-23 20:24:59', NULL, '2026-02-23 20:24:59', '2026-02-23 20:24:59'),
(1592, 'product?page=1&pageSize=10&search=&paginate=true&companyId=8', NULL, 'Consultation product?page=1&pageSize=10&search=&paginate=true&companyId=8 ✅', 'Consultation product?page=1&pageSize=10&search=&paginate=true&companyId=8 effectuée avec succès.', 'réussi', '2026-02-23 20:28:25', NULL, '2026-02-23 20:28:25', '2026-02-23 20:28:25'),
(1593, 'product?page=1&pageSize=10&search=&paginate=true&companyId=8', NULL, 'Consultation product?page=1&pageSize=10&search=&paginate=true&companyId=8 ❌', 'Échec lors de consultation product?page=1&pagesize=10&search=&paginate=true&companyid=8.', 'réussi', '2026-02-23 20:28:26', NULL, '2026-02-23 20:28:26', '2026-02-23 20:28:26'),
(1594, 'sector?page=1&pageSize=20&search=&paginate=false', NULL, 'Consultation sector?page=1&pageSize=20&search=&paginate=false ❌', 'Échec lors de consultation sector?page=1&pagesize=20&search=&paginate=false.', 'réussi', '2026-02-23 20:34:58', NULL, '2026-02-23 20:34:58', '2026-02-23 20:34:58'),
(1595, '7', NULL, 'Consultation 7 ❌', 'Échec lors de consultation 7.', 'réussi', '2026-02-23 20:34:58', NULL, '2026-02-23 20:34:58', '2026-02-23 20:34:58'),
(1596, 'sector?page=1&pageSize=10&search=&paginate=true', NULL, 'Consultation sector?page=1&pageSize=10&search=&paginate=true ❌', 'Échec lors de consultation sector?page=1&pagesize=10&search=&paginate=true.', 'réussi', '2026-02-23 20:35:30', NULL, '2026-02-23 20:35:30', '2026-02-23 20:35:30'),
(1597, 'product?page=1&pageSize=10&search=&paginate=true&companyId=8', NULL, 'Consultation product?page=1&pageSize=10&search=&paginate=true&companyId=8 ❌', 'Échec lors de consultation product?page=1&pagesize=10&search=&paginate=true&companyid=8.', 'réussi', '2026-02-23 20:35:35', NULL, '2026-02-23 20:35:35', '2026-02-23 20:35:35'),
(1598, 'sector?page=2&pageSize=10&search=&paginate=true', NULL, 'Consultation sector?page=2&pageSize=10&search=&paginate=true ❌', 'Échec lors de consultation sector?page=2&pagesize=10&search=&paginate=true.', 'réussi', '2026-02-23 20:36:33', NULL, '2026-02-23 20:36:33', '2026-02-23 20:36:33'),
(1599, 'tsx?id=7&page=1&pageSize=10&paginate=true', NULL, 'Consultation tsx?id=7&page=1&pageSize=10&paginate=true ❌', 'Échec lors de consultation tsx?id=7&page=1&pagesize=10&paginate=true.', 'réussi', '2026-02-23 20:36:39', NULL, '2026-02-23 20:36:39', '2026-02-23 20:36:39'),
(1600, 'tsx?page=1&pageSize=1000&paginate=true', NULL, 'Consultation tsx?page=1&pageSize=1000&paginate=true ❌', 'Échec lors de consultation tsx?page=1&pagesize=1000&paginate=true.', 'réussi', '2026-02-23 20:36:39', NULL, '2026-02-23 20:36:39', '2026-02-23 20:36:39'),
(1601, 'product?page=1&pageSize=10&search=&paginate=true&companyId=8', NULL, 'Consultation product?page=1&pageSize=10&search=&paginate=true&companyId=8 ❌', 'Échec lors de consultation product?page=1&pagesize=10&search=&paginate=true&companyid=8.', 'réussi', '2026-02-23 20:38:09', NULL, '2026-02-23 20:38:09', '2026-02-23 20:38:09'),
(1602, '7', NULL, 'Consultation 7 ✅', 'Consultation 7 effectuée avec succès.', 'réussi', '2026-02-23 20:40:14', NULL, '2026-02-23 20:40:14', '2026-02-23 20:40:14'),
(1603, '7', NULL, 'Consultation 7 ✅', 'Consultation 7 effectuée avec succès.', 'réussi', '2026-02-24 19:31:55', NULL, '2026-02-24 19:31:55', '2026-02-24 19:31:55'),
(1604, '7', NULL, 'Consultation 7 ✅', 'Consultation 7 effectuée avec succès.', 'réussi', '2026-02-24 19:32:27', NULL, '2026-02-24 19:32:27', '2026-02-24 19:32:27'),
(1605, '7', NULL, 'Consultation 7 ❌', 'Échec lors de consultation 7.', 'réussi', '2026-02-24 19:32:37', NULL, '2026-02-24 19:32:37', '2026-02-24 19:32:37'),
(1606, 'sector?page=1&pageSize=20&search=&paginate=false', NULL, 'Consultation sector?page=1&pageSize=20&search=&paginate=false ✅', 'Consultation sector?page=1&pageSize=20&search=&paginate=false effectuée avec succès.', 'réussi', '2026-02-24 19:32:37', NULL, '2026-02-24 19:32:37', '2026-02-24 19:32:37'),
(1607, 'product?page=1&pageSize=10&search=&paginate=true&companyId=8', NULL, 'Consultation product?page=1&pageSize=10&search=&paginate=true&companyId=8 ❌', 'Échec lors de consultation product?page=1&pagesize=10&search=&paginate=true&companyid=8.', 'réussi', '2026-02-24 19:33:07', NULL, '2026-02-24 19:33:07', '2026-02-24 19:33:07'),
(1608, 'paiement', NULL, 'Création paiement ❌', 'Échec lors de création paiement.', 'réussi', '2026-02-24 19:37:42', NULL, '2026-02-24 19:37:42', '2026-02-24 19:37:42'),
(1609, 'sector?page=1&pageSize=20&search=&paginate=false', NULL, 'Consultation sector?page=1&pageSize=20&search=&paginate=false ❌', 'Échec lors de consultation sector?page=1&pagesize=20&search=&paginate=false.', 'réussi', '2026-02-24 19:38:22', NULL, '2026-02-24 19:38:22', '2026-02-24 19:38:22'),
(1610, '7', NULL, 'Consultation 7 ✅', 'Consultation 7 effectuée avec succès.', 'réussi', '2026-02-24 19:38:22', NULL, '2026-02-24 19:38:22', '2026-02-24 19:38:22'),
(1611, 'product?page=1&pageSize=10&search=&paginate=true&companyId=8', NULL, 'Consultation product?page=1&pageSize=10&search=&paginate=true&companyId=8 ❌', 'Échec lors de consultation product?page=1&pagesize=10&search=&paginate=true&companyid=8.', 'réussi', '2026-02-24 19:41:14', NULL, '2026-02-24 19:41:14', '2026-02-24 19:41:14'),
(1612, 'Paiement', 10, 'Paiement EC ✅', 'Paiement commande ORD-1771962092654', 'réussi', '2026-02-24 19:41:32', 7, '2026-02-24 19:41:32', '2026-02-24 19:41:32'),
(1613, 'Paiement', 10, 'Réception paiement ✅', 'Réception paiement commande ORD-1771962092654', 'réussi', '2026-02-24 19:41:32', 2, '2026-02-24 19:41:32', '2026-02-24 19:41:32'),
(1614, 'paiement', NULL, 'Création paiement ✅', 'Création paiement effectuée avec succès.', 'réussi', '2026-02-24 19:41:32', NULL, '2026-02-24 19:41:32', '2026-02-24 19:41:32'),
(1615, 'sector?page=1&pageSize=20&search=&paginate=false', NULL, 'Consultation sector?page=1&pageSize=20&search=&paginate=false ❌', 'Échec lors de consultation sector?page=1&pagesize=20&search=&paginate=false.', 'réussi', '2026-02-24 19:44:43', NULL, '2026-02-24 19:44:43', '2026-02-24 19:44:43'),
(1616, '7', NULL, 'Consultation 7 ✅', 'Consultation 7 effectuée avec succès.', 'réussi', '2026-02-24 19:44:43', NULL, '2026-02-24 19:44:43', '2026-02-24 19:44:43'),
(1617, '7', NULL, 'Consultation 7 ✅', 'Consultation 7 effectuée avec succès.', 'réussi', '2026-02-24 19:48:06', NULL, '2026-02-24 19:48:06', '2026-02-24 19:48:06'),
(1618, 'product?page=1&pageSize=10&search=&paginate=true&companyId=8', NULL, 'Consultation product?page=1&pageSize=10&search=&paginate=true&companyId=8 ❌', 'Échec lors de consultation product?page=1&pagesize=10&search=&paginate=true&companyid=8.', 'réussi', '2026-02-24 19:48:14', NULL, '2026-02-24 19:48:14', '2026-02-24 19:48:14'),
(1619, 'Paiement', 20, 'Paiement EC ✅', 'Paiement commande ORD-1771962510864', 'réussi', '2026-02-24 19:48:30', 7, '2026-02-24 19:48:30', '2026-02-24 19:48:30'),
(1620, 'Paiement', 20, 'Réception paiement ✅', 'Réception paiement commande ORD-1771962510864', 'réussi', '2026-02-24 19:48:30', 2, '2026-02-24 19:48:30', '2026-02-24 19:48:30'),
(1621, 'paiement', NULL, 'Création paiement ✅', 'Création paiement effectuée avec succès.', 'réussi', '2026-02-24 19:48:30', NULL, '2026-02-24 19:48:30', '2026-02-24 19:48:30'),
(1622, '7', NULL, 'Consultation 7 ✅', 'Consultation 7 effectuée avec succès.', 'réussi', '2026-02-24 19:48:34', NULL, '2026-02-24 19:48:34', '2026-02-24 19:48:34'),
(1623, 'product?page=1&pageSize=10&search=&paginate=true&companyId=11', NULL, 'Consultation product?page=1&pageSize=10&search=&paginate=true&companyId=11 ❌', 'Échec lors de consultation product?page=1&pagesize=10&search=&paginate=true&companyid=11.', 'réussi', '2026-02-24 19:48:40', NULL, '2026-02-24 19:48:40', '2026-02-24 19:48:40'),
(1624, 'Paiement', 10, 'Paiement EC ✅', 'Paiement commande ORD-1771962531552', 'réussi', '2026-02-24 19:48:51', 7, '2026-02-24 19:48:51', '2026-02-24 19:48:51'),
(1625, 'Paiement', 10, 'Réception paiement ✅', 'Réception paiement commande ORD-1771962531552', 'réussi', '2026-02-24 19:48:51', 2, '2026-02-24 19:48:51', '2026-02-24 19:48:51'),
(1626, 'paiement', NULL, 'Création paiement ✅', 'Création paiement effectuée avec succès.', 'réussi', '2026-02-24 19:48:51', NULL, '2026-02-24 19:48:51', '2026-02-24 19:48:51'),
(1627, '7', NULL, 'Consultation 7 ✅', 'Consultation 7 effectuée avec succès.', 'réussi', '2026-02-24 19:48:54', NULL, '2026-02-24 19:48:54', '2026-02-24 19:48:54'),
(1628, 'product?page=1&pageSize=10&search=&paginate=true&companyId=12', NULL, 'Consultation product?page=1&pageSize=10&search=&paginate=true&companyId=12 ❌', 'Échec lors de consultation product?page=1&pagesize=10&search=&paginate=true&companyid=12.', 'réussi', '2026-02-24 19:49:02', NULL, '2026-02-24 19:49:02', '2026-02-24 19:49:02'),
(1629, 'notification_track?userId=7&search=&page=1&pageSize=20&paginate=true', NULL, 'Consultation notification_track?userId=7&search=&page=1&pageSize=20&paginate=true ✅', 'Consultation notification_track?userId=7&search=&page=1&pageSize=20&paginate=true effectuée avec succès.', 'réussi', '2026-02-24 19:49:08', NULL, '2026-02-24 19:49:08', '2026-02-24 19:49:08'),
(1630, 'notification_track?userId=7&search=&page=1&pageSize=20&paginate=true', NULL, 'Consultation notification_track?userId=7&search=&page=1&pageSize=20&paginate=true ❌', 'Échec lors de consultation notification_track?userid=7&search=&page=1&pagesize=20&paginate=true.', 'réussi', '2026-02-24 19:49:11', NULL, '2026-02-24 19:49:11', '2026-02-24 19:49:11'),
(1631, 'notification_track?userId=7&search=&page=1&pageSize=20&paginate=true', NULL, 'Consultation notification_track?userId=7&search=&page=1&pageSize=20&paginate=true ❌', 'Échec lors de consultation notification_track?userid=7&search=&page=1&pagesize=20&paginate=true.', 'réussi', '2026-02-24 19:49:12', NULL, '2026-02-24 19:49:12', '2026-02-24 19:49:12'),
(1632, 'notification_track?userId=7&search=&page=1&pageSize=20&paginate=true', NULL, 'Consultation notification_track?userId=7&search=&page=1&pageSize=20&paginate=true ❌', 'Échec lors de consultation notification_track?userid=7&search=&page=1&pagesize=20&paginate=true.', 'réussi', '2026-02-24 19:49:15', NULL, '2026-02-24 19:49:15', '2026-02-24 19:49:15'),
(1633, 'tsx?page=1&pageSize=1000&paginate=true', NULL, 'Consultation tsx?page=1&pageSize=1000&paginate=true ✅', 'Consultation tsx?page=1&pageSize=1000&paginate=true effectuée avec succès.', 'réussi', '2026-02-24 19:49:21', NULL, '2026-02-24 19:49:21', '2026-02-24 19:49:21'),
(1634, 'tsx?page=1&pageSize=1000&paginate=true', NULL, 'Consultation tsx?page=1&pageSize=1000&paginate=true ❌', 'Échec lors de consultation tsx?page=1&pagesize=1000&paginate=true.', 'réussi', '2026-02-24 19:49:22', NULL, '2026-02-24 19:49:22', '2026-02-24 19:49:22'),
(1635, 'paiement', NULL, 'Création paiement ❌', 'Échec lors de création paiement.', 'réussi', '2026-02-24 19:50:11', NULL, '2026-02-24 19:50:11', '2026-02-24 19:50:11'),
(1636, 'Paiement', 5.5, 'Paiement EC ✅', 'Paiement commande ORD-1771962714159', 'réussi', '2026-02-24 19:51:54', 7, '2026-02-24 19:51:54', '2026-02-24 19:51:54'),
(1637, 'Paiement', 5.5, 'Réception paiement ✅', 'Réception paiement commande ORD-1771962714159', 'réussi', '2026-02-24 19:51:54', 2, '2026-02-24 19:51:54', '2026-02-24 19:51:54'),
(1638, 'paiement', NULL, 'Création paiement ✅', 'Création paiement effectuée avec succès.', 'réussi', '2026-02-24 19:51:54', NULL, '2026-02-24 19:51:54', '2026-02-24 19:51:54'),
(1639, '7', NULL, 'Consultation 7 ✅', 'Consultation 7 effectuée avec succès.', 'réussi', '2026-02-24 19:51:57', NULL, '2026-02-24 19:51:57', '2026-02-24 19:51:57'),
(1640, 'users?search=&page=1&pageSize=20&paginate=true', NULL, 'Consultation users?search=&page=1&pageSize=20&paginate=true ✅', 'Consultation users?search=&page=1&pageSize=20&paginate=true effectuée avec succès.', 'réussi', '2026-02-24 19:52:06', NULL, '2026-02-24 19:52:06', '2026-02-24 19:52:06'),
(1641, 'users?search=john&page=1&pageSize=20&paginate=true', NULL, 'Consultation users?search=john&page=1&pageSize=20&paginate=true ✅', 'Consultation users?search=john&page=1&pageSize=20&paginate=true effectuée avec succès.', 'réussi', '2026-02-24 19:52:14', NULL, '2026-02-24 19:52:14', '2026-02-24 19:52:14'),
(1642, 'users?search=&page=1&pageSize=20&paginate=true', NULL, 'Consultation users?search=&page=1&pageSize=20&paginate=true ❌', 'Échec lors de consultation users?search=&page=1&pagesize=20&paginate=true.', 'réussi', '2026-02-24 19:53:20', NULL, '2026-02-24 19:53:20', '2026-02-24 19:53:20'),
(1643, 'notification_track?userId=7&search=&page=1&pageSize=20&paginate=true', NULL, 'Consultation notification_track?userId=7&search=&page=1&pageSize=20&paginate=true ✅', 'Consultation notification_track?userId=7&search=&page=1&pageSize=20&paginate=true effectuée avec succès.', 'réussi', '2026-02-24 19:55:54', NULL, '2026-02-24 19:55:54', '2026-02-24 19:55:54'),
(1644, 'notification_track?userId=7&search=&page=2&pageSize=20&paginate=true', NULL, 'Consultation notification_track?userId=7&search=&page=2&pageSize=20&paginate=true ✅', 'Consultation notification_track?userId=7&search=&page=2&pageSize=20&paginate=true effectuée avec succès.', 'réussi', '2026-02-24 19:55:57', NULL, '2026-02-24 19:55:57', '2026-02-24 19:55:57'),
(1645, 'tsx?id=7&page=1&pageSize=10&paginate=true', NULL, 'Consultation tsx?id=7&page=1&pageSize=10&paginate=true ✅', 'Consultation tsx?id=7&page=1&pageSize=10&paginate=true effectuée avec succès.', 'réussi', '2026-02-24 19:56:08', NULL, '2026-02-24 19:56:08', '2026-02-24 19:56:08'),
(1646, 'tsx?id=7&page=1&pageSize=10&paginate=true', NULL, 'Consultation tsx?id=7&page=1&pageSize=10&paginate=true ❌', 'Échec lors de consultation tsx?id=7&page=1&pagesize=10&paginate=true.', 'réussi', '2026-02-24 19:56:11', NULL, '2026-02-24 19:56:11', '2026-02-24 19:56:11'),
(1647, 'tsx?id=7&page=2&pageSize=10&paginate=true', NULL, 'Consultation tsx?id=7&page=2&pageSize=10&paginate=true ✅', 'Consultation tsx?id=7&page=2&pageSize=10&paginate=true effectuée avec succès.', 'réussi', '2026-02-24 19:56:16', NULL, '2026-02-24 19:56:16', '2026-02-24 19:56:16'),
(1648, 'sector?page=1&pageSize=10&search=&paginate=true', NULL, 'Consultation sector?page=1&pageSize=10&search=&paginate=true ❌', 'Échec lors de consultation sector?page=1&pagesize=10&search=&paginate=true.', 'réussi', '2026-02-24 19:56:44', NULL, '2026-02-24 19:56:44', '2026-02-24 19:56:44'),
(1649, 'tsx?id=7&page=2&pageSize=10&paginate=true', NULL, 'Consultation tsx?id=7&page=2&pageSize=10&paginate=true ❌', 'Échec lors de consultation tsx?id=7&page=2&pagesize=10&paginate=true.', 'réussi', '2026-02-24 19:56:58', NULL, '2026-02-24 19:56:58', '2026-02-24 19:56:58'),
(1650, 'users?search=&page=1&pageSize=20&paginate=true', NULL, 'Consultation users?search=&page=1&pageSize=20&paginate=true ❌', 'Échec lors de consultation users?search=&page=1&pagesize=20&paginate=true.', 'réussi', '2026-02-24 19:58:03', NULL, '2026-02-24 19:58:03', '2026-02-24 19:58:03'),
(1651, 'users?search=&page=1&pageSize=20&paginate=true', NULL, 'Consultation users?search=&page=1&pageSize=20&paginate=true ❌', 'Échec lors de consultation users?search=&page=1&pagesize=20&paginate=true.', 'réussi', '2026-02-24 20:00:30', NULL, '2026-02-24 20:00:30', '2026-02-24 20:00:30'),
(1652, 'users?search=%C2%B4&page=1&pageSize=20&paginate=true', NULL, 'Consultation users?search=%C2%B4&page=1&pageSize=20&paginate=true ✅', 'Consultation users?search=%C2%B4&page=1&pageSize=20&paginate=true effectuée avec succès.', 'réussi', '2026-02-24 20:00:39', NULL, '2026-02-24 20:00:39', '2026-02-24 20:00:39'),
(1653, 'users?search=&page=1&pageSize=20&paginate=true', NULL, 'Consultation users?search=&page=1&pageSize=20&paginate=true ❌', 'Échec lors de consultation users?search=&page=1&pagesize=20&paginate=true.', 'réussi', '2026-02-24 20:00:39', NULL, '2026-02-24 20:00:39', '2026-02-24 20:00:39'),
(1654, 'users?search=%C2%B4&page=1&pageSize=20&paginate=true', NULL, 'Consultation users?search=%C2%B4&page=1&pageSize=20&paginate=true ❌', 'Échec lors de consultation users?search=%c2%b4&page=1&pagesize=20&paginate=true.', 'réussi', '2026-02-24 20:00:41', NULL, '2026-02-24 20:00:41', '2026-02-24 20:00:41'),
(1655, 'users?search=%C2%B4n&page=1&pageSize=20&paginate=true', NULL, 'Consultation users?search=%C2%B4n&page=1&pageSize=20&paginate=true ✅', 'Consultation users?search=%C2%B4n&page=1&pageSize=20&paginate=true effectuée avec succès.', 'réussi', '2026-02-24 20:00:41', NULL, '2026-02-24 20:00:41', '2026-02-24 20:00:41'),
(1656, 'notification_track?userId=7&search=&page=1&pageSize=20&paginate=true', NULL, 'Consultation notification_track?userId=7&search=&page=1&pageSize=20&paginate=true ❌', 'Échec lors de consultation notification_track?userid=7&search=&page=1&pagesize=20&paginate=true.', 'réussi', '2026-02-24 20:03:47', NULL, '2026-02-24 20:03:47', '2026-02-24 20:03:47'),
(1657, 'users?search=&page=1&pageSize=20&paginate=true', NULL, 'Consultation users?search=&page=1&pageSize=20&paginate=true ❌', 'Échec lors de consultation users?search=&page=1&pagesize=20&paginate=true.', 'réussi', '2026-02-24 20:05:07', NULL, '2026-02-24 20:05:07', '2026-02-24 20:05:07'),
(1658, 'notification_track?userId=7&search=&page=1&pageSize=20&paginate=true', NULL, 'Consultation notification_track?userId=7&search=&page=1&pageSize=20&paginate=true ❌', 'Échec lors de consultation notification_track?userid=7&search=&page=1&pagesize=20&paginate=true.', 'réussi', '2026-02-24 20:10:48', NULL, '2026-02-24 20:10:48', '2026-02-24 20:10:48'),
(1659, 'users?search=N&page=1&pageSize=20&paginate=true', NULL, 'Consultation users?search=N&page=1&pageSize=20&paginate=true ✅', 'Consultation users?search=N&page=1&pageSize=20&paginate=true effectuée avec succès.', 'réussi', '2026-02-24 20:10:54', NULL, '2026-02-24 20:10:54', '2026-02-24 20:10:54'),
(1660, 'users?search=&page=1&pageSize=20&paginate=true', NULL, 'Consultation users?search=&page=1&pageSize=20&paginate=true ❌', 'Échec lors de consultation users?search=&page=1&pagesize=20&paginate=true.', 'réussi', '2026-02-24 20:10:54', NULL, '2026-02-24 20:10:54', '2026-02-24 20:10:54'),
(1661, 'users?search=N&page=1&pageSize=20&paginate=true', NULL, 'Consultation users?search=N&page=1&pageSize=20&paginate=true ❌', 'Échec lors de consultation users?search=n&page=1&pagesize=20&paginate=true.', 'réussi', '2026-02-24 20:10:55', NULL, '2026-02-24 20:10:55', '2026-02-24 20:10:55'),
(1662, 'users?search=Nq&page=1&pageSize=20&paginate=true', NULL, 'Consultation users?search=Nq&page=1&pageSize=20&paginate=true ✅', 'Consultation users?search=Nq&page=1&pageSize=20&paginate=true effectuée avec succès.', 'réussi', '2026-02-24 20:10:55', NULL, '2026-02-24 20:10:55', '2026-02-24 20:10:55'),
(1663, 'users?search=Nq&page=1&pageSize=20&paginate=true', NULL, 'Consultation users?search=Nq&page=1&pageSize=20&paginate=true ❌', 'Échec lors de consultation users?search=nq&page=1&pagesize=20&paginate=true.', 'réussi', '2026-02-24 20:10:56', NULL, '2026-02-24 20:10:56', '2026-02-24 20:10:56'),
(1664, 'users?search=N&page=1&pageSize=20&paginate=true', NULL, 'Consultation users?search=N&page=1&pageSize=20&paginate=true ❌', 'Échec lors de consultation users?search=n&page=1&pagesize=20&paginate=true.', 'réussi', '2026-02-24 20:10:56', NULL, '2026-02-24 20:10:56', '2026-02-24 20:10:56'),
(1665, 'users?search=&page=1&pageSize=20&paginate=true', NULL, 'Consultation users?search=&page=1&pageSize=20&paginate=true ❌', 'Échec lors de consultation users?search=&page=1&pagesize=20&paginate=true.', 'réussi', '2026-02-24 20:10:57', NULL, '2026-02-24 20:10:57', '2026-02-24 20:10:57'),
(1666, 'users?search=B&page=1&pageSize=20&paginate=true', NULL, 'Consultation users?search=B&page=1&pageSize=20&paginate=true ✅', 'Consultation users?search=B&page=1&pageSize=20&paginate=true effectuée avec succès.', 'réussi', '2026-02-24 20:10:57', NULL, '2026-02-24 20:10:57', '2026-02-24 20:10:57'),
(1667, 'users?search=B&page=1&pageSize=20&paginate=true', NULL, 'Consultation users?search=B&page=1&pageSize=20&paginate=true ❌', 'Échec lors de consultation users?search=b&page=1&pagesize=20&paginate=true.', 'réussi', '2026-02-24 20:10:57', NULL, '2026-02-24 20:10:57', '2026-02-24 20:10:57'),
(1668, 'users?search=Bi&page=1&pageSize=20&paginate=true', NULL, 'Consultation users?search=Bi&page=1&pageSize=20&paginate=true ✅', 'Consultation users?search=Bi&page=1&pageSize=20&paginate=true effectuée avec succès.', 'réussi', '2026-02-24 20:10:57', NULL, '2026-02-24 20:10:57', '2026-02-24 20:10:57');
INSERT INTO `histories` (`historyId`, `type`, `amount`, `action`, `description`, `status`, `date`, `userId`, `createdAt`, `updatedAt`) VALUES
(1669, 'users?search=Bi&page=1&pageSize=20&paginate=true', NULL, 'Consultation users?search=Bi&page=1&pageSize=20&paginate=true ❌', 'Échec lors de consultation users?search=bi&page=1&pagesize=20&paginate=true.', 'réussi', '2026-02-24 20:10:57', NULL, '2026-02-24 20:10:57', '2026-02-24 20:10:57'),
(1670, 'users?search=Bim&page=1&pageSize=20&paginate=true', NULL, 'Consultation users?search=Bim&page=1&pageSize=20&paginate=true ✅', 'Consultation users?search=Bim&page=1&pageSize=20&paginate=true effectuée avec succès.', 'réussi', '2026-02-24 20:10:57', NULL, '2026-02-24 20:10:57', '2026-02-24 20:10:57'),
(1671, 'users?search=Bim&page=1&pageSize=20&paginate=true', NULL, 'Consultation users?search=Bim&page=1&pageSize=20&paginate=true ❌', 'Échec lors de consultation users?search=bim&page=1&pagesize=20&paginate=true.', 'réussi', '2026-02-24 20:10:58', NULL, '2026-02-24 20:10:58', '2026-02-24 20:10:58'),
(1672, 'users?search=Bi&page=1&pageSize=20&paginate=true', NULL, 'Consultation users?search=Bi&page=1&pageSize=20&paginate=true ❌', 'Échec lors de consultation users?search=bi&page=1&pagesize=20&paginate=true.', 'réussi', '2026-02-24 20:10:59', NULL, '2026-02-24 20:10:59', '2026-02-24 20:10:59'),
(1673, 'users?search=B&page=1&pageSize=20&paginate=true', NULL, 'Consultation users?search=B&page=1&pageSize=20&paginate=true ❌', 'Échec lors de consultation users?search=b&page=1&pagesize=20&paginate=true.', 'réussi', '2026-02-24 20:10:59', NULL, '2026-02-24 20:10:59', '2026-02-24 20:10:59'),
(1674, 'users?search=&page=1&pageSize=20&paginate=true', NULL, 'Consultation users?search=&page=1&pageSize=20&paginate=true ❌', 'Échec lors de consultation users?search=&page=1&pagesize=20&paginate=true.', 'réussi', '2026-02-24 20:11:01', NULL, '2026-02-24 20:11:01', '2026-02-24 20:11:01'),
(1675, 'users?search=b&page=1&pageSize=20&paginate=true', NULL, 'Consultation users?search=b&page=1&pageSize=20&paginate=true ✅', 'Consultation users?search=b&page=1&pageSize=20&paginate=true effectuée avec succès.', 'réussi', '2026-02-24 20:11:01', NULL, '2026-02-24 20:11:01', '2026-02-24 20:11:01'),
(1676, 'users?search=b&page=1&pageSize=20&paginate=true', NULL, 'Consultation users?search=b&page=1&pageSize=20&paginate=true ❌', 'Échec lors de consultation users?search=b&page=1&pagesize=20&paginate=true.', 'réussi', '2026-02-24 20:11:01', NULL, '2026-02-24 20:11:01', '2026-02-24 20:11:01'),
(1677, 'users?search=bi&page=1&pageSize=20&paginate=true', NULL, 'Consultation users?search=bi&page=1&pageSize=20&paginate=true ✅', 'Consultation users?search=bi&page=1&pageSize=20&paginate=true effectuée avec succès.', 'réussi', '2026-02-24 20:11:01', NULL, '2026-02-24 20:11:01', '2026-02-24 20:11:01'),
(1678, 'users?search=bi&page=1&pageSize=20&paginate=true', NULL, 'Consultation users?search=bi&page=1&pageSize=20&paginate=true ❌', 'Échec lors de consultation users?search=bi&page=1&pagesize=20&paginate=true.', 'réussi', '2026-02-24 20:11:01', NULL, '2026-02-24 20:11:01', '2026-02-24 20:11:01'),
(1679, 'users?search=bim&page=1&pageSize=20&paginate=true', NULL, 'Consultation users?search=bim&page=1&pageSize=20&paginate=true ✅', 'Consultation users?search=bim&page=1&pageSize=20&paginate=true effectuée avec succès.', 'réussi', '2026-02-24 20:11:01', NULL, '2026-02-24 20:11:01', '2026-02-24 20:11:01'),
(1680, 'users?search=bim&page=1&pageSize=20&paginate=true', NULL, 'Consultation users?search=bim&page=1&pageSize=20&paginate=true ❌', 'Échec lors de consultation users?search=bim&page=1&pagesize=20&paginate=true.', 'réussi', '2026-02-24 20:11:03', NULL, '2026-02-24 20:11:03', '2026-02-24 20:11:03'),
(1681, 'users?search=nom&page=1&pageSize=20&paginate=true', NULL, 'Consultation users?search=nom&page=1&pageSize=20&paginate=true ✅', 'Consultation users?search=nom&page=1&pageSize=20&paginate=true effectuée avec succès.', 'réussi', '2026-02-24 20:11:03', NULL, '2026-02-24 20:11:03', '2026-02-24 20:11:03'),
(1682, 'users?search=no&page=1&pageSize=20&paginate=true', NULL, 'Consultation users?search=no&page=1&pageSize=20&paginate=true ✅', 'Consultation users?search=no&page=1&pageSize=20&paginate=true effectuée avec succès.', 'réussi', '2026-02-24 20:11:04', NULL, '2026-02-24 20:11:04', '2026-02-24 20:11:04'),
(1683, 'users?search=nom&page=1&pageSize=20&paginate=true', NULL, 'Consultation users?search=nom&page=1&pageSize=20&paginate=true ❌', 'Échec lors de consultation users?search=nom&page=1&pagesize=20&paginate=true.', 'réussi', '2026-02-24 20:11:04', NULL, '2026-02-24 20:11:04', '2026-02-24 20:11:04'),
(1684, 'users?search=no&page=1&pageSize=20&paginate=true', NULL, 'Consultation users?search=no&page=1&pageSize=20&paginate=true ❌', 'Échec lors de consultation users?search=no&page=1&pagesize=20&paginate=true.', 'réussi', '2026-02-24 20:11:04', NULL, '2026-02-24 20:11:04', '2026-02-24 20:11:04'),
(1685, 'users?search=n&page=1&pageSize=20&paginate=true', NULL, 'Consultation users?search=n&page=1&pageSize=20&paginate=true ✅', 'Consultation users?search=n&page=1&pageSize=20&paginate=true effectuée avec succès.', 'réussi', '2026-02-24 20:11:04', NULL, '2026-02-24 20:11:04', '2026-02-24 20:11:04'),
(1686, 'users?search=n&page=1&pageSize=20&paginate=true', NULL, 'Consultation users?search=n&page=1&pageSize=20&paginate=true ❌', 'Échec lors de consultation users?search=n&page=1&pagesize=20&paginate=true.', 'réussi', '2026-02-24 20:11:05', NULL, '2026-02-24 20:11:05', '2026-02-24 20:11:05'),
(1687, 'users?search=S&page=1&pageSize=20&paginate=true', NULL, 'Consultation users?search=S&page=1&pageSize=20&paginate=true ✅', 'Consultation users?search=S&page=1&pageSize=20&paginate=true effectuée avec succès.', 'réussi', '2026-02-24 20:13:06', NULL, '2026-02-24 20:13:06', '2026-02-24 20:13:06'),
(1688, 'users?search=&page=1&pageSize=20&paginate=true', NULL, 'Consultation users?search=&page=1&pageSize=20&paginate=true ❌', 'Échec lors de consultation users?search=&page=1&pagesize=20&paginate=true.', 'réussi', '2026-02-24 20:13:06', NULL, '2026-02-24 20:13:06', '2026-02-24 20:13:06'),
(1689, 'users?search=S&page=1&pageSize=20&paginate=true', NULL, 'Consultation users?search=S&page=1&pageSize=20&paginate=true ❌', 'Échec lors de consultation users?search=s&page=1&pagesize=20&paginate=true.', 'réussi', '2026-02-24 20:13:07', NULL, '2026-02-24 20:13:07', '2026-02-24 20:13:07'),
(1690, 'users?search=Sn&page=1&pageSize=20&paginate=true', NULL, 'Consultation users?search=Sn&page=1&pageSize=20&paginate=true ✅', 'Consultation users?search=Sn&page=1&pageSize=20&paginate=true effectuée avec succès.', 'réussi', '2026-02-24 20:13:07', NULL, '2026-02-24 20:13:07', '2026-02-24 20:13:07'),
(1691, 'users?search=Sns&page=1&pageSize=20&paginate=true', NULL, 'Consultation users?search=Sns&page=1&pageSize=20&paginate=true ✅', 'Consultation users?search=Sns&page=1&pageSize=20&paginate=true effectuée avec succès.', 'réussi', '2026-02-24 20:13:07', NULL, '2026-02-24 20:13:07', '2026-02-24 20:13:07'),
(1692, 'users?search=Sns%E2%80%99&page=1&pageSize=20&paginate=true', NULL, 'Consultation users?search=Sns%E2%80%99&page=1&pageSize=20&paginate=true ✅', 'Consultation users?search=Sns%E2%80%99&page=1&pageSize=20&paginate=true effectuée avec succès.', 'réussi', '2026-02-24 20:13:07', NULL, '2026-02-24 20:13:07', '2026-02-24 20:13:07'),
(1693, 'users?search=Sns%E2%80%99&page=1&pageSize=20&paginate=true', NULL, 'Consultation users?search=Sns%E2%80%99&page=1&pageSize=20&paginate=true ❌', 'Échec lors de consultation users?search=sns%e2%80%99&page=1&pagesize=20&paginate=true.', 'réussi', '2026-02-24 20:13:08', NULL, '2026-02-24 20:13:08', '2026-02-24 20:13:08'),
(1694, 'users?search=Sns%E2%80%99%C2%B4&page=1&pageSize=20&paginate=true', NULL, 'Consultation users?search=Sns%E2%80%99%C2%B4&page=1&pageSize=20&paginate=true ✅', 'Consultation users?search=Sns%E2%80%99%C2%B4&page=1&pageSize=20&paginate=true effectuée avec succès.', 'réussi', '2026-02-24 20:13:08', NULL, '2026-02-24 20:13:08', '2026-02-24 20:13:08'),
(1695, 'users?search=Sns%E2%80%99%C2%B4&page=1&pageSize=20&paginate=true', NULL, 'Consultation users?search=Sns%E2%80%99%C2%B4&page=1&pageSize=20&paginate=true ❌', 'Échec lors de consultation users?search=sns%e2%80%99%c2%b4&page=1&pagesize=20&paginate=true.', 'réussi', '2026-02-24 20:13:08', NULL, '2026-02-24 20:13:08', '2026-02-24 20:13:08'),
(1696, 'users?search=Sns%E2%80%99%C2%B4n&page=1&pageSize=20&paginate=true', NULL, 'Consultation users?search=Sns%E2%80%99%C2%B4n&page=1&pageSize=20&paginate=true ✅', 'Consultation users?search=Sns%E2%80%99%C2%B4n&page=1&pageSize=20&paginate=true effectuée avec succès.', 'réussi', '2026-02-24 20:13:08', NULL, '2026-02-24 20:13:08', '2026-02-24 20:13:08'),
(1697, 'users?search=Sns%E2%80%99%C2%B4n&page=1&pageSize=20&paginate=true', NULL, 'Consultation users?search=Sns%E2%80%99%C2%B4n&page=1&pageSize=20&paginate=true ❌', 'Échec lors de consultation users?search=sns%e2%80%99%c2%b4n&page=1&pagesize=20&paginate=true.', 'réussi', '2026-02-24 20:13:08', NULL, '2026-02-24 20:13:08', '2026-02-24 20:13:08'),
(1698, 'users?search=Sns%E2%80%99%C2%B4ns&page=1&pageSize=20&paginate=true', NULL, 'Consultation users?search=Sns%E2%80%99%C2%B4ns&page=1&pageSize=20&paginate=true ✅', 'Consultation users?search=Sns%E2%80%99%C2%B4ns&page=1&pageSize=20&paginate=true effectuée avec succès.', 'réussi', '2026-02-24 20:13:08', NULL, '2026-02-24 20:13:08', '2026-02-24 20:13:08'),
(1699, 'users?search=Sns%E2%80%99%C2%B4ns&page=1&pageSize=20&paginate=true', NULL, 'Consultation users?search=Sns%E2%80%99%C2%B4ns&page=1&pageSize=20&paginate=true ❌', 'Échec lors de consultation users?search=sns%e2%80%99%c2%b4ns&page=1&pagesize=20&paginate=true.', 'réussi', '2026-02-24 20:13:09', NULL, '2026-02-24 20:13:09', '2026-02-24 20:13:09'),
(1700, 'users?search=Sns%E2%80%99%C2%B4n&page=1&pageSize=20&paginate=true', NULL, 'Consultation users?search=Sns%E2%80%99%C2%B4n&page=1&pageSize=20&paginate=true ❌', 'Échec lors de consultation users?search=sns%e2%80%99%c2%b4n&page=1&pagesize=20&paginate=true.', 'réussi', '2026-02-24 20:13:09', NULL, '2026-02-24 20:13:09', '2026-02-24 20:13:09'),
(1701, 'users?search=Sns%E2%80%99%C2%B4&page=1&pageSize=20&paginate=true', NULL, 'Consultation users?search=Sns%E2%80%99%C2%B4&page=1&pageSize=20&paginate=true ❌', 'Échec lors de consultation users?search=sns%e2%80%99%c2%b4&page=1&pagesize=20&paginate=true.', 'réussi', '2026-02-24 20:13:09', NULL, '2026-02-24 20:13:09', '2026-02-24 20:13:09'),
(1702, 'users?search=Sns%E2%80%99&page=1&pageSize=20&paginate=true', NULL, 'Consultation users?search=Sns%E2%80%99&page=1&pageSize=20&paginate=true ❌', 'Échec lors de consultation users?search=sns%e2%80%99&page=1&pagesize=20&paginate=true.', 'réussi', '2026-02-24 20:13:09', NULL, '2026-02-24 20:13:09', '2026-02-24 20:13:09'),
(1703, 'users?search=Sns&page=1&pageSize=20&paginate=true', NULL, 'Consultation users?search=Sns&page=1&pageSize=20&paginate=true ❌', 'Échec lors de consultation users?search=sns&page=1&pagesize=20&paginate=true.', 'réussi', '2026-02-24 20:13:10', NULL, '2026-02-24 20:13:10', '2026-02-24 20:13:10'),
(1704, 'users?search=Sn&page=1&pageSize=20&paginate=true', NULL, 'Consultation users?search=Sn&page=1&pageSize=20&paginate=true ❌', 'Échec lors de consultation users?search=sn&page=1&pagesize=20&paginate=true.', 'réussi', '2026-02-24 20:13:10', NULL, '2026-02-24 20:13:10', '2026-02-24 20:13:10'),
(1705, 'users?search=S&page=1&pageSize=20&paginate=true', NULL, 'Consultation users?search=S&page=1&pageSize=20&paginate=true ❌', 'Échec lors de consultation users?search=s&page=1&pagesize=20&paginate=true.', 'réussi', '2026-02-24 20:13:10', NULL, '2026-02-24 20:13:10', '2026-02-24 20:13:10'),
(1706, 'users?search=&page=1&pageSize=20&paginate=true', NULL, 'Consultation users?search=&page=1&pageSize=20&paginate=true ❌', 'Échec lors de consultation users?search=&page=1&pagesize=20&paginate=true.', 'réussi', '2026-02-24 20:13:53', NULL, '2026-02-24 20:13:53', '2026-02-24 20:13:53'),
(1707, 'users?search=J&page=1&pageSize=20&paginate=true', NULL, 'Consultation users?search=J&page=1&pageSize=20&paginate=true ✅', 'Consultation users?search=J&page=1&pageSize=20&paginate=true effectuée avec succès.', 'réussi', '2026-02-24 20:13:53', NULL, '2026-02-24 20:13:53', '2026-02-24 20:13:53'),
(1708, 'users?search=J&page=1&pageSize=20&paginate=true', NULL, 'Consultation users?search=J&page=1&pageSize=20&paginate=true ❌', 'Échec lors de consultation users?search=j&page=1&pagesize=20&paginate=true.', 'réussi', '2026-02-24 20:13:56', NULL, '2026-02-24 20:13:56', '2026-02-24 20:13:56'),
(1709, 'users?search=&page=1&pageSize=20&paginate=true', NULL, 'Consultation users?search=&page=1&pageSize=20&paginate=true ❌', 'Échec lors de consultation users?search=&page=1&pagesize=20&paginate=true.', 'réussi', '2026-02-24 20:13:58', NULL, '2026-02-24 20:13:58', '2026-02-24 20:13:58'),
(1710, 'users?search=k&page=1&pageSize=20&paginate=true', NULL, 'Consultation users?search=k&page=1&pageSize=20&paginate=true ✅', 'Consultation users?search=k&page=1&pageSize=20&paginate=true effectuée avec succès.', 'réussi', '2026-02-24 20:13:58', NULL, '2026-02-24 20:13:58', '2026-02-24 20:13:58'),
(1711, 'users?search=kJ&page=1&pageSize=20&paginate=true', NULL, 'Consultation users?search=kJ&page=1&pageSize=20&paginate=true ✅', 'Consultation users?search=kJ&page=1&pageSize=20&paginate=true effectuée avec succès.', 'réussi', '2026-02-24 20:13:59', NULL, '2026-02-24 20:13:59', '2026-02-24 20:13:59'),
(1712, 'users?search=k&page=1&pageSize=20&paginate=true', NULL, 'Consultation users?search=k&page=1&pageSize=20&paginate=true ❌', 'Échec lors de consultation users?search=k&page=1&pagesize=20&paginate=true.', 'réussi', '2026-02-24 20:13:59', NULL, '2026-02-24 20:13:59', '2026-02-24 20:13:59'),
(1713, 'users?search=kJ&page=1&pageSize=20&paginate=true', NULL, 'Consultation users?search=kJ&page=1&pageSize=20&paginate=true ❌', 'Échec lors de consultation users?search=kj&page=1&pagesize=20&paginate=true.', 'réussi', '2026-02-24 20:13:59', NULL, '2026-02-24 20:13:59', '2026-02-24 20:13:59'),
(1714, 'users?search=kJs&page=1&pageSize=20&paginate=true', NULL, 'Consultation users?search=kJs&page=1&pageSize=20&paginate=true ✅', 'Consultation users?search=kJs&page=1&pageSize=20&paginate=true effectuée avec succès.', 'réussi', '2026-02-24 20:13:59', NULL, '2026-02-24 20:13:59', '2026-02-24 20:13:59'),
(1715, 'users?search=kJsj&page=1&pageSize=20&paginate=true', NULL, 'Consultation users?search=kJsj&page=1&pageSize=20&paginate=true ✅', 'Consultation users?search=kJsj&page=1&pageSize=20&paginate=true effectuée avec succès.', 'réussi', '2026-02-24 20:13:59', NULL, '2026-02-24 20:13:59', '2026-02-24 20:13:59'),
(1716, 'users?search=kJsj&page=1&pageSize=20&paginate=true', NULL, 'Consultation users?search=kJsj&page=1&pageSize=20&paginate=true ❌', 'Échec lors de consultation users?search=kjsj&page=1&pagesize=20&paginate=true.', 'réussi', '2026-02-24 20:14:00', NULL, '2026-02-24 20:14:00', '2026-02-24 20:14:00'),
(1717, 'users?search=kJs&page=1&pageSize=20&paginate=true', NULL, 'Consultation users?search=kJs&page=1&pageSize=20&paginate=true ❌', 'Échec lors de consultation users?search=kjs&page=1&pagesize=20&paginate=true.', 'réussi', '2026-02-24 20:14:00', NULL, '2026-02-24 20:14:00', '2026-02-24 20:14:00'),
(1718, 'users?search=kJ&page=1&pageSize=20&paginate=true', NULL, 'Consultation users?search=kJ&page=1&pageSize=20&paginate=true ❌', 'Échec lors de consultation users?search=kj&page=1&pagesize=20&paginate=true.', 'réussi', '2026-02-24 20:14:00', NULL, '2026-02-24 20:14:00', '2026-02-24 20:14:00'),
(1719, 'users?search=k&page=1&pageSize=20&paginate=true', NULL, 'Consultation users?search=k&page=1&pageSize=20&paginate=true ❌', 'Échec lors de consultation users?search=k&page=1&pagesize=20&paginate=true.', 'réussi', '2026-02-24 20:14:01', NULL, '2026-02-24 20:14:01', '2026-02-24 20:14:01'),
(1720, 'users?search=&page=1&pageSize=20&paginate=true', NULL, 'Consultation users?search=&page=1&pageSize=20&paginate=true ❌', 'Échec lors de consultation users?search=&page=1&pagesize=20&paginate=true.', 'réussi', '2026-02-24 20:14:02', NULL, '2026-02-24 20:14:02', '2026-02-24 20:14:02'),
(1721, 'users?search=J&page=1&pageSize=20&paginate=true', NULL, 'Consultation users?search=J&page=1&pageSize=20&paginate=true ❌', 'Échec lors de consultation users?search=j&page=1&pagesize=20&paginate=true.', 'réussi', '2026-02-24 20:14:03', NULL, '2026-02-24 20:14:03', '2026-02-24 20:14:03'),
(1722, 'users?search=Je&page=1&pageSize=20&paginate=true', NULL, 'Consultation users?search=Je&page=1&pageSize=20&paginate=true ✅', 'Consultation users?search=Je&page=1&pageSize=20&paginate=true effectuée avec succès.', 'réussi', '2026-02-24 20:14:03', NULL, '2026-02-24 20:14:03', '2026-02-24 20:14:03'),
(1723, 'users?search=Je&page=1&pageSize=20&paginate=true', NULL, 'Consultation users?search=Je&page=1&pageSize=20&paginate=true ❌', 'Échec lors de consultation users?search=je&page=1&pagesize=20&paginate=true.', 'réussi', '2026-02-24 20:14:03', NULL, '2026-02-24 20:14:03', '2026-02-24 20:14:03'),
(1724, 'users?search=Jes&page=1&pageSize=20&paginate=true', NULL, 'Consultation users?search=Jes&page=1&pageSize=20&paginate=true ✅', 'Consultation users?search=Jes&page=1&pageSize=20&paginate=true effectuée avec succès.', 'réussi', '2026-02-24 20:14:03', NULL, '2026-02-24 20:14:03', '2026-02-24 20:14:03'),
(1725, 'users?search=Jes&page=1&pageSize=20&paginate=true', NULL, 'Consultation users?search=Jes&page=1&pageSize=20&paginate=true ❌', 'Échec lors de consultation users?search=jes&page=1&pagesize=20&paginate=true.', 'réussi', '2026-02-24 20:14:04', NULL, '2026-02-24 20:14:04', '2026-02-24 20:14:04'),
(1726, 'users?search=Je&page=1&pageSize=20&paginate=true', NULL, 'Consultation users?search=Je&page=1&pageSize=20&paginate=true ❌', 'Échec lors de consultation users?search=je&page=1&pagesize=20&paginate=true.', 'réussi', '2026-02-24 20:14:04', NULL, '2026-02-24 20:14:04', '2026-02-24 20:14:04'),
(1727, 'users?search=J&page=1&pageSize=20&paginate=true', NULL, 'Consultation users?search=J&page=1&pageSize=20&paginate=true ❌', 'Échec lors de consultation users?search=j&page=1&pagesize=20&paginate=true.', 'réussi', '2026-02-24 20:14:04', NULL, '2026-02-24 20:14:04', '2026-02-24 20:14:04'),
(1728, 'users?search=D&page=1&pageSize=20&paginate=true', NULL, 'Consultation users?search=D&page=1&pageSize=20&paginate=true ✅', 'Consultation users?search=D&page=1&pageSize=20&paginate=true effectuée avec succès.', 'réussi', '2026-02-24 20:14:05', NULL, '2026-02-24 20:14:05', '2026-02-24 20:14:05'),
(1729, 'users?search=Dk&page=1&pageSize=20&paginate=true', NULL, 'Consultation users?search=Dk&page=1&pageSize=20&paginate=true ✅', 'Consultation users?search=Dk&page=1&pageSize=20&paginate=true effectuée avec succès.', 'réussi', '2026-02-24 20:14:05', NULL, '2026-02-24 20:14:05', '2026-02-24 20:14:05'),
(1730, 'users?search=&page=1&pageSize=20&paginate=true', NULL, 'Consultation users?search=&page=1&pageSize=20&paginate=true ❌', 'Échec lors de consultation users?search=&page=1&pagesize=20&paginate=true.', 'réussi', '2026-02-24 20:14:05', NULL, '2026-02-24 20:14:05', '2026-02-24 20:14:05'),
(1731, 'users?search=Dks&page=1&pageSize=20&paginate=true', NULL, 'Consultation users?search=Dks&page=1&pageSize=20&paginate=true ✅', 'Consultation users?search=Dks&page=1&pageSize=20&paginate=true effectuée avec succès.', 'réussi', '2026-02-24 20:14:05', NULL, '2026-02-24 20:14:05', '2026-02-24 20:14:05'),
(1732, 'users?search=Dksj&page=1&pageSize=20&paginate=true', NULL, 'Consultation users?search=Dksj&page=1&pageSize=20&paginate=true ✅', 'Consultation users?search=Dksj&page=1&pageSize=20&paginate=true effectuée avec succès.', 'réussi', '2026-02-24 20:14:05', NULL, '2026-02-24 20:14:05', '2026-02-24 20:14:05'),
(1733, 'users?search=Dksj&page=1&pageSize=20&paginate=true', NULL, 'Consultation users?search=Dksj&page=1&pageSize=20&paginate=true ❌', 'Échec lors de consultation users?search=dksj&page=1&pagesize=20&paginate=true.', 'réussi', '2026-02-24 20:14:06', NULL, '2026-02-24 20:14:06', '2026-02-24 20:14:06'),
(1734, 'users?search=Dks&page=1&pageSize=20&paginate=true', NULL, 'Consultation users?search=Dks&page=1&pageSize=20&paginate=true ❌', 'Échec lors de consultation users?search=dks&page=1&pagesize=20&paginate=true.', 'réussi', '2026-02-24 20:14:06', NULL, '2026-02-24 20:14:06', '2026-02-24 20:14:06'),
(1735, 'users?search=Dk&page=1&pageSize=20&paginate=true', NULL, 'Consultation users?search=Dk&page=1&pageSize=20&paginate=true ❌', 'Échec lors de consultation users?search=dk&page=1&pagesize=20&paginate=true.', 'réussi', '2026-02-24 20:14:06', NULL, '2026-02-24 20:14:06', '2026-02-24 20:14:06'),
(1736, 'users?search=D&page=1&pageSize=20&paginate=true', NULL, 'Consultation users?search=D&page=1&pageSize=20&paginate=true ❌', 'Échec lors de consultation users?search=d&page=1&pagesize=20&paginate=true.', 'réussi', '2026-02-24 20:14:06', NULL, '2026-02-24 20:14:06', '2026-02-24 20:14:06'),
(1737, 'users?search=&page=1&pageSize=20&paginate=true', NULL, 'Consultation users?search=&page=1&pageSize=20&paginate=true ❌', 'Échec lors de consultation users?search=&page=1&pagesize=20&paginate=true.', 'réussi', '2026-02-24 20:14:07', NULL, '2026-02-24 20:14:07', '2026-02-24 20:14:07'),
(1738, 'users?search=J&page=1&pageSize=20&paginate=true', NULL, 'Consultation users?search=J&page=1&pageSize=20&paginate=true ❌', 'Échec lors de consultation users?search=j&page=1&pagesize=20&paginate=true.', 'réussi', '2026-02-24 20:14:07', NULL, '2026-02-24 20:14:07', '2026-02-24 20:14:07'),
(1739, 'users?search=Je&page=1&pageSize=20&paginate=true', NULL, 'Consultation users?search=Je&page=1&pageSize=20&paginate=true ❌', 'Échec lors de consultation users?search=je&page=1&pagesize=20&paginate=true.', 'réussi', '2026-02-24 20:14:08', NULL, '2026-02-24 20:14:08', '2026-02-24 20:14:08'),
(1740, 'users?search=Jesu&page=1&pageSize=20&paginate=true', NULL, 'Consultation users?search=Jesu&page=1&pageSize=20&paginate=true ✅', 'Consultation users?search=Jesu&page=1&pageSize=20&paginate=true effectuée avec succès.', 'réussi', '2026-02-24 20:14:08', NULL, '2026-02-24 20:14:08', '2026-02-24 20:14:08'),
(1741, 'users?search=Jes&page=1&pageSize=20&paginate=true', NULL, 'Consultation users?search=Jes&page=1&pageSize=20&paginate=true ❌', 'Échec lors de consultation users?search=jes&page=1&pagesize=20&paginate=true.', 'réussi', '2026-02-24 20:14:08', NULL, '2026-02-24 20:14:08', '2026-02-24 20:14:08'),
(1742, 'users?search=Jesu&page=1&pageSize=20&paginate=true', NULL, 'Consultation users?search=Jesu&page=1&pageSize=20&paginate=true ❌', 'Échec lors de consultation users?search=jesu&page=1&pagesize=20&paginate=true.', 'réussi', '2026-02-24 20:14:08', NULL, '2026-02-24 20:14:08', '2026-02-24 20:14:08'),
(1743, 'users?search=Jes&page=1&pageSize=20&paginate=true', NULL, 'Consultation users?search=Jes&page=1&pageSize=20&paginate=true ❌', 'Échec lors de consultation users?search=jes&page=1&pagesize=20&paginate=true.', 'réussi', '2026-02-24 20:14:08', NULL, '2026-02-24 20:14:08', '2026-02-24 20:14:08'),
(1744, 'users?search=Je&page=1&pageSize=20&paginate=true', NULL, 'Consultation users?search=Je&page=1&pageSize=20&paginate=true ❌', 'Échec lors de consultation users?search=je&page=1&pagesize=20&paginate=true.', 'réussi', '2026-02-24 20:14:09', NULL, '2026-02-24 20:14:09', '2026-02-24 20:14:09'),
(1745, 'users?search=J&page=1&pageSize=20&paginate=true', NULL, 'Consultation users?search=J&page=1&pageSize=20&paginate=true ❌', 'Échec lors de consultation users?search=j&page=1&pagesize=20&paginate=true.', 'réussi', '2026-02-24 20:14:09', NULL, '2026-02-24 20:14:09', '2026-02-24 20:14:09'),
(1746, 'users?search=&page=1&pageSize=20&paginate=true', NULL, 'Consultation users?search=&page=1&pageSize=20&paginate=true ❌', 'Échec lors de consultation users?search=&page=1&pagesize=20&paginate=true.', 'réussi', '2026-02-24 20:16:25', NULL, '2026-02-24 20:16:25', '2026-02-24 20:16:25'),
(1747, 'tsx?id=7&page=1&pageSize=10&paginate=true', NULL, 'Consultation tsx?id=7&page=1&pageSize=10&paginate=true ❌', 'Échec lors de consultation tsx?id=7&page=1&pagesize=10&paginate=true.', 'réussi', '2026-02-24 20:20:23', NULL, '2026-02-24 20:20:23', '2026-02-24 20:20:23'),
(1748, 'Retrait', 20, NULL, 'Retrait effectué', 'réussi', '2026-02-24 20:21:05', 7, '2026-02-24 20:21:05', '2026-02-24 20:21:05'),
(1749, 'Retrait', 20, NULL, 'Retrait client reçu', 'réussi', '2026-02-24 20:21:05', 10, '2026-02-24 20:21:05', '2026-02-24 20:21:05'),
(1750, 'Retrait', 0.597, NULL, 'Frais retrait reçu', 'réussi', '2026-02-24 20:21:05', 2, '2026-02-24 20:21:05', '2026-02-24 20:21:05'),
(1751, 'retrait', NULL, 'Création retrait ✅', 'Création retrait effectuée avec succès.', 'réussi', '2026-02-24 20:21:09', NULL, '2026-02-24 20:21:09', '2026-02-24 20:21:09'),
(1752, 'Retrait', 20.5, NULL, 'Retrait effectué', 'réussi', '2026-02-24 20:21:19', 7, '2026-02-24 20:21:19', '2026-02-24 20:21:19'),
(1753, 'Retrait', 20.5, NULL, 'Retrait client reçu', 'réussi', '2026-02-24 20:21:19', 10, '2026-02-24 20:21:19', '2026-02-24 20:21:19'),
(1754, 'Retrait', 0.611925, NULL, 'Frais retrait reçu', 'réussi', '2026-02-24 20:21:19', 2, '2026-02-24 20:21:19', '2026-02-24 20:21:19'),
(1755, 'retrait', NULL, 'Création retrait ✅', 'Création retrait effectuée avec succès.', 'réussi', '2026-02-24 20:21:21', NULL, '2026-02-24 20:21:21', '2026-02-24 20:21:21'),
(1756, 'tsx?id=7&page=1&pageSize=10&paginate=true', NULL, 'Consultation tsx?id=7&page=1&pageSize=10&paginate=true ✅', 'Consultation tsx?id=7&page=1&pageSize=10&paginate=true effectuée avec succès.', 'réussi', '2026-02-24 20:21:30', NULL, '2026-02-24 20:21:30', '2026-02-24 20:21:30'),
(1757, 'tsx?id=7&page=1&pageSize=10&paginate=true', NULL, 'Consultation tsx?id=7&page=1&pageSize=10&paginate=true ❌', 'Échec lors de consultation tsx?id=7&page=1&pagesize=10&paginate=true.', 'réussi', '2026-02-24 20:21:33', NULL, '2026-02-24 20:21:33', '2026-02-24 20:21:33'),
(1758, 'tsx?page=1&pageSize=1000&paginate=true', NULL, 'Consultation tsx?page=1&pageSize=1000&paginate=true ✅', 'Consultation tsx?page=1&pageSize=1000&paginate=true effectuée avec succès.', 'réussi', '2026-02-24 20:21:36', NULL, '2026-02-24 20:21:36', '2026-02-24 20:21:36'),
(1759, 'tsx?page=1&pageSize=1000&paginate=true', NULL, 'Consultation tsx?page=1&pageSize=1000&paginate=true ❌', 'Échec lors de consultation tsx?page=1&pagesize=1000&paginate=true.', 'réussi', '2026-02-24 20:21:41', NULL, '2026-02-24 20:21:41', '2026-02-24 20:21:41'),
(1760, 'notification_track?userId=7&search=&page=1&pageSize=20&paginate=true', NULL, 'Consultation notification_track?userId=7&search=&page=1&pageSize=20&paginate=true ✅', 'Consultation notification_track?userId=7&search=&page=1&pageSize=20&paginate=true effectuée avec succès.', 'réussi', '2026-02-24 20:22:22', NULL, '2026-02-24 20:22:22', '2026-02-24 20:22:22'),
(1761, 'notification_track?userId=7&search=&page=1&pageSize=20&paginate=true', NULL, 'Consultation notification_track?userId=7&search=&page=1&pageSize=20&paginate=true ❌', 'Échec lors de consultation notification_track?userid=7&search=&page=1&pagesize=20&paginate=true.', 'réussi', '2026-02-24 20:22:23', NULL, '2026-02-24 20:22:23', '2026-02-24 20:22:23'),
(1762, '7', NULL, 'Consultation 7 ✅', 'Consultation 7 effectuée avec succès.', 'réussi', '2026-02-24 20:23:23', NULL, '2026-02-24 20:23:23', '2026-02-24 20:23:23'),
(1763, 'notification_track?userId=7&search=&page=2&pageSize=20&paginate=true', NULL, 'Consultation notification_track?userId=7&search=&page=2&pageSize=20&paginate=true ✅', 'Consultation notification_track?userId=7&search=&page=2&pageSize=20&paginate=true effectuée avec succès.', 'réussi', '2026-02-24 20:23:27', NULL, '2026-02-24 20:23:27', '2026-02-24 20:23:27'),
(1764, 'sector?page=2&pageSize=10&search=&paginate=true', NULL, 'Consultation sector?page=2&pageSize=10&search=&paginate=true ❌', 'Échec lors de consultation sector?page=2&pagesize=10&search=&paginate=true.', 'réussi', '2026-02-24 20:27:08', NULL, '2026-02-24 20:27:08', '2026-02-24 20:27:08'),
(1765, 'users?search=&page=1&pageSize=20&paginate=true', NULL, 'Consultation users?search=&page=1&pageSize=20&paginate=true ✅', 'Consultation users?search=&page=1&pageSize=20&paginate=true effectuée avec succès.', 'réussi', '2026-02-24 20:53:33', NULL, '2026-02-24 20:53:33', '2026-02-24 20:53:33'),
(1766, 'notification_track?userId=7&search=&page=1&pageSize=20&paginate=true', NULL, 'Consultation notification_track?userId=7&search=&page=1&pageSize=20&paginate=true ❌', 'Échec lors de consultation notification_track?userid=7&search=&page=1&pagesize=20&paginate=true.', 'réussi', '2026-02-24 21:00:25', NULL, '2026-02-24 21:00:25', '2026-02-24 21:00:25'),
(1767, 'users?search=&page=1&pageSize=20&paginate=true', NULL, 'Consultation users?search=&page=1&pageSize=20&paginate=true ✅', 'Consultation users?search=&page=1&pageSize=20&paginate=true effectuée avec succès.', 'réussi', '2026-02-24 21:11:51', NULL, '2026-02-24 21:11:51', '2026-02-24 21:11:51'),
(1768, 'users?search=L&page=1&pageSize=20&paginate=true', NULL, 'Consultation users?search=L&page=1&pageSize=20&paginate=true ✅', 'Consultation users?search=L&page=1&pageSize=20&paginate=true effectuée avec succès.', 'réussi', '2026-02-24 21:12:01', NULL, '2026-02-24 21:12:01', '2026-02-24 21:12:01'),
(1769, 'users?search=&page=1&pageSize=20&paginate=true', NULL, 'Consultation users?search=&page=1&pageSize=20&paginate=true ❌', 'Échec lors de consultation users?search=&page=1&pagesize=20&paginate=true.', 'réussi', '2026-02-24 21:12:01', NULL, '2026-02-24 21:12:01', '2026-02-24 21:12:01'),
(1770, 'users?search=L&page=1&pageSize=20&paginate=true', NULL, 'Consultation users?search=L&page=1&pageSize=20&paginate=true ❌', 'Échec lors de consultation users?search=l&page=1&pagesize=20&paginate=true.', 'réussi', '2026-02-24 21:12:01', NULL, '2026-02-24 21:12:01', '2026-02-24 21:12:01'),
(1771, 'users?search=Le&page=1&pageSize=20&paginate=true', NULL, 'Consultation users?search=Le&page=1&pageSize=20&paginate=true ✅', 'Consultation users?search=Le&page=1&pageSize=20&paginate=true effectuée avec succès.', 'réussi', '2026-02-24 21:12:01', NULL, '2026-02-24 21:12:01', '2026-02-24 21:12:01'),
(1772, 'users?search=Le&page=1&pageSize=20&paginate=true', NULL, 'Consultation users?search=Le&page=1&pageSize=20&paginate=true ❌', 'Échec lors de consultation users?search=le&page=1&pagesize=20&paginate=true.', 'réussi', '2026-02-24 21:12:02', NULL, '2026-02-24 21:12:02', '2026-02-24 21:12:02'),
(1773, 'users?search=Lea&page=1&pageSize=20&paginate=true', NULL, 'Consultation users?search=Lea&page=1&pageSize=20&paginate=true ✅', 'Consultation users?search=Lea&page=1&pageSize=20&paginate=true effectuée avec succès.', 'réussi', '2026-02-24 21:12:02', NULL, '2026-02-24 21:12:02', '2026-02-24 21:12:02'),
(1774, 'users?search=Lea&page=1&pageSize=20&paginate=true', NULL, 'Consultation users?search=Lea&page=1&pageSize=20&paginate=true ❌', 'Échec lors de consultation users?search=lea&page=1&pagesize=20&paginate=true.', 'réussi', '2026-02-24 21:12:03', NULL, '2026-02-24 21:12:03', '2026-02-24 21:12:03'),
(1775, 'users?search=L%C3%A9a&page=1&pageSize=20&paginate=true', NULL, 'Consultation users?search=L%C3%A9a&page=1&pageSize=20&paginate=true ✅', 'Consultation users?search=L%C3%A9a&page=1&pageSize=20&paginate=true effectuée avec succès.', 'réussi', '2026-02-24 21:12:03', NULL, '2026-02-24 21:12:03', '2026-02-24 21:12:03'),
(1776, 'users?search=L%C3%A9a&page=1&pageSize=20&paginate=true', NULL, 'Consultation users?search=L%C3%A9a&page=1&pageSize=20&paginate=true ❌', 'Échec lors de consultation users?search=l%c3%a9a&page=1&pagesize=20&paginate=true.', 'réussi', '2026-02-24 21:12:08', NULL, '2026-02-24 21:12:08', '2026-02-24 21:12:08'),
(1777, 'users?search=&page=1&pageSize=20&paginate=true', NULL, 'Consultation users?search=&page=1&pageSize=20&paginate=true ❌', 'Échec lors de consultation users?search=&page=1&pagesize=20&paginate=true.', 'réussi', '2026-02-24 21:21:08', NULL, '2026-02-24 21:21:08', '2026-02-24 21:21:08'),
(1778, 'users?search=Je&page=1&pageSize=20&paginate=true', NULL, 'Consultation users?search=Je&page=1&pageSize=20&paginate=true ❌', 'Échec lors de consultation users?search=je&page=1&pagesize=20&paginate=true.', 'réussi', '2026-02-24 21:21:08', NULL, '2026-02-24 21:21:08', '2026-02-24 21:21:08'),
(1779, 'users?search=john&page=1&pageSize=20&paginate=true', NULL, 'Consultation users?search=john&page=1&pageSize=20&paginate=true ❌', 'Échec lors de consultation users?search=john&page=1&pagesize=20&paginate=true.', 'réussi', '2026-02-24 21:21:08', NULL, '2026-02-24 21:21:08', '2026-02-24 21:21:08'),
(1780, '7', NULL, 'Consultation 7 ✅', 'Consultation 7 effectuée avec succès.', 'réussi', '2026-02-24 23:38:41', NULL, '2026-02-24 23:38:41', '2026-02-24 23:38:41'),
(1781, '7', NULL, 'Consultation 7 ✅', 'Consultation 7 effectuée avec succès.', 'réussi', '2026-02-24 23:39:10', NULL, '2026-02-24 23:39:10', '2026-02-24 23:39:10'),
(1782, 'sector?page=1&pageSize=10&search=&paginate=true', NULL, 'Consultation sector?page=1&pageSize=10&search=&paginate=true ❌', 'Échec lors de consultation sector?page=1&pagesize=10&search=&paginate=true.', 'réussi', '2026-02-24 23:39:18', NULL, '2026-02-24 23:39:18', '2026-02-24 23:39:18'),
(1783, 'sector?page=2&pageSize=10&search=&paginate=true', NULL, 'Consultation sector?page=2&pageSize=10&search=&paginate=true ❌', 'Échec lors de consultation sector?page=2&pagesize=10&search=&paginate=true.', 'réussi', '2026-02-24 23:39:19', NULL, '2026-02-24 23:39:19', '2026-02-24 23:39:19'),
(1784, 'tsx?id=7&page=1&pageSize=10&paginate=true', NULL, 'Consultation tsx?id=7&page=1&pageSize=10&paginate=true ❌', 'Échec lors de consultation tsx?id=7&page=1&pagesize=10&paginate=true.', 'réussi', '2026-02-24 23:39:23', NULL, '2026-02-24 23:39:23', '2026-02-24 23:39:23'),
(1785, 'tsx?page=1&pageSize=1000&paginate=true', NULL, 'Consultation tsx?page=1&pageSize=1000&paginate=true ❌', 'Échec lors de consultation tsx?page=1&pagesize=1000&paginate=true.', 'réussi', '2026-02-24 23:39:24', NULL, '2026-02-24 23:39:24', '2026-02-24 23:39:24'),
(1786, 'profile', NULL, 'Mise à jour profile ✅', 'Mise à jour profile effectuée avec succès.', 'réussi', '2026-02-24 23:39:42', NULL, '2026-02-24 23:39:42', '2026-02-24 23:39:42'),
(1787, '7', NULL, 'Consultation 7 ✅', 'Consultation 7 effectuée avec succès.', 'réussi', '2026-02-24 23:39:42', NULL, '2026-02-24 23:39:42', '2026-02-24 23:39:42');

-- --------------------------------------------------------

--
-- Structure de la table `notes`
--

CREATE TABLE `notes` (
  `noteId` int(11) NOT NULL,
  `userId` int(11) DEFAULT NULL,
  `companyId` int(11) NOT NULL,
  `productId` int(11) DEFAULT NULL,
  `branchTrackId` int(11) DEFAULT NULL,
  `totalStars` int(11) DEFAULT NULL,
  `notes` text DEFAULT NULL,
  `createdAt` datetime NOT NULL,
  `updatedAt` datetime NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Structure de la table `notifications`
--

CREATE TABLE `notifications` (
  `notificationId` int(11) NOT NULL,
  `title` varchar(200) NOT NULL,
  `global` tinyint(1) NOT NULL DEFAULT 0,
  `message` text NOT NULL,
  `type` enum('INFO','SUCCESS','ERREUR','EXPEDITION','RECEPTION','ALERTE','LITIGE') NOT NULL DEFAULT 'INFO',
  `isRead` tinyint(1) NOT NULL DEFAULT 0,
  `expeTrackId` int(11) DEFAULT NULL,
  `userId` int(11) DEFAULT NULL,
  `commerceId` int(11) DEFAULT NULL,
  `branchTrackId` int(11) DEFAULT NULL,
  `createdAt` datetime NOT NULL,
  `updatedAt` datetime NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Déchargement des données de la table `notifications`
--

INSERT INTO `notifications` (`notificationId`, `title`, `global`, `message`, `type`, `isRead`, `expeTrackId`, `userId`, `commerceId`, `branchTrackId`, `createdAt`, `updatedAt`) VALUES
(1, 'Erreur', 0, 'Une erreur est survenue lors de création create.', 'ERREUR', 0, NULL, NULL, NULL, NULL, '2026-02-12 06:27:01', '2026-02-12 06:27:01'),
(2, 'Erreur', 0, 'Une erreur est survenue lors de création create.', 'ERREUR', 0, NULL, NULL, NULL, NULL, '2026-02-12 06:32:45', '2026-02-12 06:32:45'),
(3, 'Opération réussie', 0, 'Création create effectuée avec succès.', 'SUCCESS', 0, NULL, NULL, NULL, NULL, '2026-02-12 06:33:55', '2026-02-12 06:33:55'),
(4, 'Opération réussie', 0, 'Consultation sector effectuée avec succès.', 'SUCCESS', 0, NULL, NULL, NULL, NULL, '2026-02-12 07:49:04', '2026-02-12 07:49:04'),
(5, 'Erreur', 0, 'Une erreur est survenue lors de création create.', 'ERREUR', 0, NULL, NULL, NULL, NULL, '2026-02-12 08:14:22', '2026-02-12 08:14:22'),
(6, 'Erreur', 0, 'Une erreur est survenue lors de création create.', 'ERREUR', 0, NULL, NULL, NULL, NULL, '2026-02-12 08:21:38', '2026-02-12 08:21:38'),
(7, 'Opération réussie', 0, 'Création create effectuée avec succès.', 'SUCCESS', 0, NULL, NULL, NULL, NULL, '2026-02-12 08:27:04', '2026-02-12 08:27:04'),
(8, 'Opération réussie', 0, 'Consultation sector effectuée avec succès.', 'SUCCESS', 0, NULL, NULL, NULL, NULL, '2026-02-12 08:27:19', '2026-02-12 08:27:19'),
(9, 'Opération réussie', 0, 'Consultation sector effectuée avec succès.', 'SUCCESS', 0, NULL, NULL, NULL, NULL, '2026-02-12 08:27:28', '2026-02-12 08:27:28'),
(10, 'Opération réussie', 0, 'Consultation sector effectuée avec succès.', 'SUCCESS', 0, NULL, NULL, NULL, NULL, '2026-02-12 08:34:10', '2026-02-12 08:34:10'),
(11, 'Erreur', 0, 'Une erreur est survenue lors de consultation company.', 'ERREUR', 0, NULL, NULL, NULL, NULL, '2026-02-12 08:38:52', '2026-02-12 08:38:52'),
(12, 'Opération réussie', 0, 'Consultation 1 effectuée avec succès.', 'SUCCESS', 0, NULL, NULL, NULL, NULL, '2026-02-12 08:40:00', '2026-02-12 08:40:00'),
(13, 'Erreur', 0, 'Une erreur est survenue lors de consultation company.', 'ERREUR', 0, NULL, NULL, NULL, NULL, '2026-02-12 08:40:12', '2026-02-12 08:40:12'),
(14, 'Opération réussie', 0, 'Consultation sector effectuée avec succès.', 'SUCCESS', 0, NULL, NULL, NULL, NULL, '2026-02-12 08:40:22', '2026-02-12 08:40:22'),
(15, 'Erreur', 0, 'Une erreur est survenue lors de consultation company.', 'ERREUR', 0, NULL, NULL, NULL, NULL, '2026-02-12 08:42:09', '2026-02-12 08:42:09'),
(16, 'Erreur', 0, 'Une erreur est survenue lors de consultation company.', 'ERREUR', 0, NULL, NULL, NULL, NULL, '2026-02-12 08:44:56', '2026-02-12 08:44:56'),
(17, 'Opération réussie', 0, 'Consultation company effectuée avec succès.', 'SUCCESS', 0, NULL, NULL, NULL, NULL, '2026-02-12 08:47:09', '2026-02-12 08:47:09'),
(18, 'Opération réussie', 0, 'Création create effectuée avec succès.', 'SUCCESS', 0, NULL, NULL, NULL, NULL, '2026-02-12 09:03:42', '2026-02-12 09:03:42'),
(19, 'Erreur', 0, 'Une erreur est survenue lors de création create.', 'ERREUR', 0, NULL, NULL, NULL, NULL, '2026-02-12 09:21:58', '2026-02-12 09:21:58'),
(20, 'Opération réussie', 0, 'Création create effectuée avec succès.', 'SUCCESS', 0, NULL, NULL, NULL, NULL, '2026-02-12 09:23:45', '2026-02-12 09:23:45'),
(21, 'Opération réussie', 0, 'Consultation company effectuée avec succès.', 'SUCCESS', 0, NULL, NULL, NULL, NULL, '2026-02-12 09:41:02', '2026-02-12 09:41:02'),
(22, 'Opération réussie', 0, 'Consultation company effectuée avec succès.', 'SUCCESS', 0, NULL, NULL, NULL, NULL, '2026-02-12 18:28:35', '2026-02-12 18:28:35'),
(23, 'Erreur', 0, 'Une erreur est survenue lors de création create.', 'ERREUR', 0, NULL, NULL, NULL, NULL, '2026-02-12 18:44:14', '2026-02-12 18:44:14'),
(24, 'Opération réussie', 0, 'Création create effectuée avec succès.', 'SUCCESS', 0, NULL, NULL, NULL, NULL, '2026-02-12 18:45:05', '2026-02-12 18:45:05'),
(25, 'Opération réussie', 0, 'Création create effectuée avec succès.', 'SUCCESS', 0, NULL, NULL, NULL, NULL, '2026-02-12 18:52:54', '2026-02-12 18:52:54'),
(26, 'Opération réussie', 0, 'Création create effectuée avec succès.', 'SUCCESS', 0, NULL, NULL, NULL, NULL, '2026-02-12 19:00:08', '2026-02-12 19:00:08'),
(27, 'Opération réussie', 0, 'Création create effectuée avec succès.', 'SUCCESS', 0, NULL, NULL, NULL, NULL, '2026-02-12 19:00:39', '2026-02-12 19:00:39'),
(28, 'Opération réussie', 0, 'Consultation 1 effectuée avec succès.', 'SUCCESS', 0, NULL, NULL, NULL, NULL, '2026-02-15 07:32:00', '2026-02-15 07:32:00'),
(29, 'Opération réussie', 0, 'Création createrecharge effectuée avec succès.', 'SUCCESS', 0, NULL, NULL, NULL, NULL, '2026-02-15 07:35:37', '2026-02-15 07:35:37'),
(30, 'Recharge réussie ✅', 0, 'Votre compte a été crédité de 100 avec succès. Merci d’avoir utilisé notre service.', 'SUCCESS', 0, NULL, NULL, NULL, NULL, '2026-02-15 07:35:37', '2026-02-15 07:35:37'),
(31, 'Opération réussie', 0, 'Création recharge effectuée avec succès.', 'SUCCESS', 0, NULL, NULL, NULL, NULL, '2026-02-15 07:35:37', '2026-02-15 07:35:37'),
(32, 'Opération réussie', 0, 'Consultation 1 effectuée avec succès.', 'SUCCESS', 0, NULL, NULL, NULL, NULL, '2026-02-15 07:35:46', '2026-02-15 07:35:46'),
(33, 'Opération réussie', 0, 'Consultation notification_track?userId=1&search=&page=1&pageSize=20 effectuée avec succès.', 'SUCCESS', 0, NULL, NULL, NULL, NULL, '2026-02-15 07:36:43', '2026-02-15 07:36:43'),
(34, 'Opération réussie', 0, 'Consultation sector effectuée avec succès.', 'SUCCESS', 0, NULL, NULL, NULL, NULL, '2026-02-15 07:38:13', '2026-02-15 07:38:13'),
(35, 'Erreur', 0, 'Une erreur est survenue lors de création retrait.', 'ERREUR', 0, NULL, NULL, NULL, NULL, '2026-02-15 07:39:37', '2026-02-15 07:39:37'),
(36, 'Erreur', 0, 'Une erreur est survenue lors de création retrait.', 'ERREUR', 0, NULL, NULL, NULL, NULL, '2026-02-15 07:51:11', '2026-02-15 07:51:11'),
(40, 'Erreur', 0, 'Une erreur est survenue lors de création retrait.', 'ERREUR', 0, NULL, NULL, NULL, NULL, '2026-02-15 07:55:41', '2026-02-15 07:55:41'),
(41, 'Retrait réussi ✅', 0, 'Votre retrait de 10$ a été effectué.', 'SUCCESS', 0, NULL, NULL, NULL, NULL, '2026-02-15 07:56:23', '2026-02-15 07:56:23'),
(42, 'Nouveau retrait 💰', 0, 'Vous avez reçu un client pour 10$.', 'INFO', 0, NULL, NULL, NULL, NULL, '2026-02-15 07:56:23', '2026-02-15 07:56:23'),
(43, 'Frais retrait reçu 💰', 0, 'Frais de 0.2$ crédité.', 'INFO', 0, NULL, NULL, NULL, NULL, '2026-02-15 07:56:23', '2026-02-15 07:56:23'),
(44, 'Opération réussie', 0, 'Création retrait effectuée avec succès.', 'SUCCESS', 0, NULL, NULL, NULL, NULL, '2026-02-15 07:56:26', '2026-02-15 07:56:26'),
(45, 'Opération réussie', 0, 'Consultation 1 effectuée avec succès.', 'SUCCESS', 0, NULL, NULL, NULL, NULL, '2026-02-15 07:56:34', '2026-02-15 07:56:34'),
(46, 'Retrait réussi ✅', 0, 'Votre retrait de 9$ a été effectué.', 'SUCCESS', 0, NULL, NULL, NULL, NULL, '2026-02-15 08:08:22', '2026-02-15 08:08:22'),
(47, 'Nouveau retrait 💰', 0, 'Vous avez reçu un client pour 9$.', 'INFO', 0, NULL, NULL, NULL, NULL, '2026-02-15 08:08:22', '2026-02-15 08:08:22'),
(48, 'Frais retrait reçu 💰', 0, 'Frais de 0.26865$ crédité.', 'INFO', 0, NULL, NULL, NULL, NULL, '2026-02-15 08:08:22', '2026-02-15 08:08:22'),
(49, 'Opération réussie', 0, 'Création retrait effectuée avec succès.', 'SUCCESS', 0, NULL, NULL, NULL, NULL, '2026-02-15 08:08:24', '2026-02-15 08:08:24'),
(50, 'Opération réussie', 0, 'Consultation 1 effectuée avec succès.', 'SUCCESS', 0, NULL, NULL, NULL, NULL, '2026-02-15 08:08:32', '2026-02-15 08:08:32'),
(51, 'Retrait réussi ✅', 0, 'Votre retrait de 20$ a été effectué.', 'SUCCESS', 0, NULL, NULL, NULL, NULL, '2026-02-15 08:19:42', '2026-02-15 08:19:42'),
(52, 'Nouveau retrait 💰', 0, 'Vous avez reçu un client pour 20$.', 'INFO', 0, NULL, NULL, NULL, NULL, '2026-02-15 08:19:42', '2026-02-15 08:19:42'),
(53, 'Frais retrait reçu 💰', 0, 'Frais de 0.597$ crédité.', 'INFO', 0, NULL, NULL, NULL, NULL, '2026-02-15 08:19:42', '2026-02-15 08:19:42'),
(54, 'Opération réussie', 0, 'Création retrait effectuée avec succès.', 'SUCCESS', 0, NULL, NULL, NULL, NULL, '2026-02-15 08:19:45', '2026-02-15 08:19:45'),
(55, 'Opération réussie', 0, 'Consultation 1 effectuée avec succès.', 'SUCCESS', 0, NULL, NULL, NULL, NULL, '2026-02-15 08:19:49', '2026-02-15 08:19:49'),
(56, 'Erreur', 0, 'Une erreur est survenue lors de création retrait.', 'ERREUR', 0, NULL, NULL, NULL, NULL, '2026-02-15 08:26:30', '2026-02-15 08:26:30'),
(57, 'Erreur', 0, 'Une erreur est survenue lors de création retrait.', 'ERREUR', 0, NULL, NULL, NULL, NULL, '2026-02-15 08:26:47', '2026-02-15 08:26:47'),
(58, 'Opération réussie', 0, 'Consultation 1 effectuée avec succès.', 'SUCCESS', 0, NULL, NULL, NULL, NULL, '2026-02-15 08:31:47', '2026-02-15 08:31:47'),
(59, 'Opération réussie', 0, 'Consultation users?search=&page=1&pageSize=20&paginate=true effectuée avec succès.', 'SUCCESS', 0, NULL, NULL, NULL, NULL, '2026-02-15 08:36:13', '2026-02-15 08:36:13'),
(60, 'Opération réussie', 0, 'Consultation users?search=john&page=1&pageSize=20&paginate=true effectuée avec succès.', 'SUCCESS', 0, NULL, NULL, NULL, NULL, '2026-02-15 08:36:36', '2026-02-15 08:36:36'),
(61, 'Opération réussie', 0, 'Consultation users?search=joh&page=1&pageSize=20&paginate=true effectuée avec succès.', 'SUCCESS', 0, NULL, NULL, NULL, NULL, '2026-02-15 08:36:51', '2026-02-15 08:36:51'),
(62, 'Erreur', 0, 'Une erreur est survenue lors de consultation users?search=john&page=1&pagesize=20&paginate=true.', 'ERREUR', 0, NULL, NULL, NULL, NULL, '2026-02-15 08:36:51', '2026-02-15 08:36:51'),
(63, 'Opération réussie', 0, 'Consultation users?search=jo&page=1&pageSize=20&paginate=true effectuée avec succès.', 'SUCCESS', 0, NULL, NULL, NULL, NULL, '2026-02-15 08:36:51', '2026-02-15 08:36:51'),
(64, 'Erreur', 0, 'Une erreur est survenue lors de consultation users?search=jo&page=1&pagesize=20&paginate=true.', 'ERREUR', 0, NULL, NULL, NULL, NULL, '2026-02-15 08:36:52', '2026-02-15 08:36:52'),
(65, 'Opération réussie', 0, 'Consultation users?search=j&page=1&pageSize=20&paginate=true effectuée avec succès.', 'SUCCESS', 0, NULL, NULL, NULL, NULL, '2026-02-15 08:36:52', '2026-02-15 08:36:52'),
(66, 'Erreur', 0, 'Une erreur est survenue lors de consultation users?search=j&page=1&pagesize=20&paginate=true.', 'ERREUR', 0, NULL, NULL, NULL, NULL, '2026-02-15 08:36:52', '2026-02-15 08:36:52'),
(67, 'Opération réussie', 0, 'Consultation users?search=user_9gqpq&page=1&pageSize=20&paginate=true effectuée avec succès.', 'SUCCESS', 0, NULL, NULL, NULL, NULL, '2026-02-15 08:36:55', '2026-02-15 08:36:55'),
(68, 'Transfert réussi ✅', 0, 'Vous avez envoyé 5$ (frais: 0.5$).', 'SUCCESS', 0, NULL, NULL, NULL, NULL, '2026-02-15 08:37:03', '2026-02-15 08:37:03'),
(69, 'Fonds reçus ✅', 0, 'Vous avez reçu 4$ de Leader Mushio.', 'SUCCESS', 0, NULL, NULL, NULL, NULL, '2026-02-15 08:37:03', '2026-02-15 08:37:03'),
(70, 'Abonnement activé 🎉', 0, '1$ a été déduit pour activer votre abonnement.', 'INFO', 0, NULL, NULL, NULL, NULL, '2026-02-15 08:37:03', '2026-02-15 08:37:03'),
(71, 'Opération réussie', 0, 'Création transfert effectuée avec succès.', 'SUCCESS', 0, NULL, NULL, NULL, NULL, '2026-02-15 08:37:03', '2026-02-15 08:37:03'),
(72, 'Opération réussie', 0, 'Consultation 1 effectuée avec succès.', 'SUCCESS', 0, NULL, NULL, NULL, NULL, '2026-02-15 08:37:10', '2026-02-15 08:37:10'),
(73, 'Erreur', 0, 'Une erreur est survenue lors de création create.', 'ERREUR', 0, NULL, NULL, NULL, NULL, '2026-02-15 08:38:29', '2026-02-15 08:38:29'),
(74, 'Erreur', 0, 'Une erreur est survenue lors de création create.', 'ERREUR', 0, NULL, NULL, NULL, NULL, '2026-02-15 08:38:41', '2026-02-15 08:38:41'),
(75, 'Erreur', 0, 'Une erreur est survenue lors de création create.', 'ERREUR', 0, NULL, NULL, NULL, NULL, '2026-02-15 08:45:20', '2026-02-15 08:45:20'),
(76, 'Erreur', 0, 'Une erreur est survenue lors de création create.', 'ERREUR', 0, NULL, NULL, NULL, NULL, '2026-02-15 08:46:50', '2026-02-15 08:46:50'),
(77, 'Erreur', 0, 'Une erreur est survenue lors de création create.', 'ERREUR', 0, NULL, NULL, NULL, NULL, '2026-02-15 08:48:57', '2026-02-15 08:48:57'),
(78, 'Opération réussie', 0, 'Création create effectuée avec succès.', 'SUCCESS', 0, NULL, NULL, NULL, NULL, '2026-02-15 08:49:14', '2026-02-15 08:49:14'),
(79, 'Erreur', 0, 'Une erreur est survenue lors de consultation 1.', 'ERREUR', 0, NULL, NULL, NULL, NULL, '2026-02-15 08:49:18', '2026-02-15 08:49:18'),
(80, 'Opération réussie', 0, 'Consultation notification_track?userId=1&search=&page=1&pageSize=20 effectuée avec succès.', 'SUCCESS', 0, NULL, NULL, NULL, NULL, '2026-02-15 08:49:21', '2026-02-15 08:49:21'),
(81, 'Opération réussie', 0, 'Consultation 1 effectuée avec succès.', 'SUCCESS', 0, NULL, NULL, NULL, NULL, '2026-02-15 09:35:22', '2026-02-15 09:35:22'),
(82, 'Opération réussie', 0, 'Consultation sector?page=1&pageSize=10 effectuée avec succès.', 'SUCCESS', 0, NULL, NULL, NULL, NULL, '2026-02-15 09:35:30', '2026-02-15 09:35:30'),
(83, 'Opération réussie', 0, 'Consultation sector?page=1&pageSize=10&search= effectuée avec succès.', 'SUCCESS', 0, NULL, NULL, NULL, NULL, '2026-02-15 09:37:33', '2026-02-15 09:37:33'),
(84, 'Opération réussie', 0, 'Consultation sector?page=1&pageSize=10&search=J effectuée avec succès.', 'SUCCESS', 0, NULL, NULL, NULL, NULL, '2026-02-15 09:38:51', '2026-02-15 09:38:51'),
(85, 'Opération réussie', 0, 'Consultation sector?page=1&pageSize=10&search=S effectuée avec succès.', 'SUCCESS', 0, NULL, NULL, NULL, NULL, '2026-02-15 09:38:53', '2026-02-15 09:38:53'),
(86, 'Opération réussie', 0, 'Consultation sector?page=1&pageSize=10&search=Se effectuée avec succès.', 'SUCCESS', 0, NULL, NULL, NULL, NULL, '2026-02-15 09:38:54', '2026-02-15 09:38:54'),
(87, 'Opération réussie', 0, 'Consultation sector?page=1&pageSize=10&search=B effectuée avec succès.', 'SUCCESS', 0, NULL, NULL, NULL, NULL, '2026-02-15 09:38:55', '2026-02-15 09:38:55'),
(88, 'Opération réussie', 0, 'Consultation sector?page=1&pageSize=10&search=Bi effectuée avec succès.', 'SUCCESS', 0, NULL, NULL, NULL, NULL, '2026-02-15 09:38:56', '2026-02-15 09:38:56'),
(89, 'Opération réussie', 0, 'Consultation sector?page=1&pageSize=10&search=Bim effectuée avec succès.', 'SUCCESS', 0, NULL, NULL, NULL, NULL, '2026-02-15 09:38:56', '2026-02-15 09:38:56'),
(90, 'Opération réussie', 0, 'Consultation sector?page=1&pageSize=10&search=Bims effectuée avec succès.', 'SUCCESS', 0, NULL, NULL, NULL, NULL, '2026-02-15 09:38:57', '2026-02-15 09:38:57'),
(91, 'Opération réussie', 0, 'Consultation sector?page=1&pageSize=10&search=Bims%E2%80%99 effectuée avec succès.', 'SUCCESS', 0, NULL, NULL, NULL, NULL, '2026-02-15 09:38:57', '2026-02-15 09:38:57'),
(92, 'Opération réussie', 0, 'Consultation sector?page=1&pageSize=10&search=D effectuée avec succès.', 'SUCCESS', 0, NULL, NULL, NULL, NULL, '2026-02-15 09:39:00', '2026-02-15 09:39:00'),
(93, 'Opération réussie', 0, 'Consultation sector?page=1&pageSize=10&search=Dj effectuée avec succès.', 'SUCCESS', 0, NULL, NULL, NULL, NULL, '2026-02-15 09:39:00', '2026-02-15 09:39:00'),
(94, 'Opération réussie', 0, 'Consultation sector?page=1&pageSize=10&search=Djs effectuée avec succès.', 'SUCCESS', 0, NULL, NULL, NULL, NULL, '2026-02-15 09:39:00', '2026-02-15 09:39:00'),
(95, 'Opération réussie', 0, 'Consultation sector?page=1&pageSize=10&search=Sa effectuée avec succès.', 'SUCCESS', 0, NULL, NULL, NULL, NULL, '2026-02-15 09:39:04', '2026-02-15 09:39:04'),
(96, 'Opération réussie', 0, 'Consultation sector?page=1&pageSize=10&search=San effectuée avec succès.', 'SUCCESS', 0, NULL, NULL, NULL, NULL, '2026-02-15 09:39:04', '2026-02-15 09:39:04'),
(97, 'Opération réussie', 0, 'Consultation sector?page=1&pageSize=10&search=Sant effectuée avec succès.', 'SUCCESS', 0, NULL, NULL, NULL, NULL, '2026-02-15 09:39:05', '2026-02-15 09:39:05'),
(98, 'Opération réussie', 0, 'Consultation sector?page=1&pageSize=10&search=C effectuée avec succès.', 'SUCCESS', 0, NULL, NULL, NULL, NULL, '2026-02-15 09:43:29', '2026-02-15 09:43:29'),
(99, 'Opération réussie', 0, 'Consultation sector?page=1&pageSize=10&search=Cv effectuée avec succès.', 'SUCCESS', 0, NULL, NULL, NULL, NULL, '2026-02-15 09:43:29', '2026-02-15 09:43:29'),
(100, 'Opération réussie', 0, 'Consultation sector?page=1&pageSize=10&search=Cvv effectuée avec succès.', 'SUCCESS', 0, NULL, NULL, NULL, NULL, '2026-02-15 09:43:29', '2026-02-15 09:43:29'),
(101, 'Opération réussie', 0, 'Consultation sector?page=1&pageSize=10&search=Cvvs effectuée avec succès.', 'SUCCESS', 0, NULL, NULL, NULL, NULL, '2026-02-15 09:43:30', '2026-02-15 09:43:30'),
(102, 'Opération réussie', 0, 'Consultation sector?page=1&pageSize=10&search=Cf effectuée avec succès.', 'SUCCESS', 0, NULL, NULL, NULL, NULL, '2026-02-15 09:43:32', '2026-02-15 09:43:32'),
(103, 'Opération réussie', 0, 'Consultation sector?page=1&pageSize=10&search=Cfb effectuée avec succès.', 'SUCCESS', 0, NULL, NULL, NULL, NULL, '2026-02-15 09:43:32', '2026-02-15 09:43:32'),
(104, 'Erreur', 0, 'Une erreur est survenue lors de consultation sector?page=1&pagesize=10&search=c.', 'ERREUR', 0, NULL, NULL, NULL, NULL, '2026-02-15 09:45:26', '2026-02-15 09:45:26'),
(105, 'Opération réussie', 0, 'Consultation sector?page=1&pageSize=10&search=Cc effectuée avec succès.', 'SUCCESS', 0, NULL, NULL, NULL, NULL, '2026-02-15 09:45:26', '2026-02-15 09:45:26'),
(106, 'Opération réussie', 0, 'Consultation sector?page=1&pageSize=10&search=Cc%E2%80%99 effectuée avec succès.', 'SUCCESS', 0, NULL, NULL, NULL, NULL, '2026-02-15 09:45:28', '2026-02-15 09:45:28'),
(107, 'Opération réussie', 0, 'Consultation sector?page=1&pageSize=10&search=Cc%E2%80%99v effectuée avec succès.', 'SUCCESS', 0, NULL, NULL, NULL, NULL, '2026-02-15 09:45:28', '2026-02-15 09:45:28'),
(108, 'Erreur', 0, 'Une erreur est survenue lors de consultation sector?page=1&pagesize=10&search=d.', 'ERREUR', 0, NULL, NULL, NULL, NULL, '2026-02-15 09:45:38', '2026-02-15 09:45:38'),
(109, 'Opération réussie', 0, 'Consultation sector?page=1&pageSize=10&search=Dw effectuée avec succès.', 'SUCCESS', 0, NULL, NULL, NULL, NULL, '2026-02-15 09:45:39', '2026-02-15 09:45:39'),
(110, 'Opération réussie', 0, 'Consultation sector?page=1&pageSize=10&search=De effectuée avec succès.', 'SUCCESS', 0, NULL, NULL, NULL, NULL, '2026-02-15 09:45:40', '2026-02-15 09:45:40'),
(111, 'Erreur', 0, 'Une erreur est survenue lors de consultation 1.', 'ERREUR', 0, NULL, NULL, NULL, NULL, '2026-02-15 09:46:44', '2026-02-15 09:46:44'),
(112, 'Opération réussie', 0, 'Consultation sector?page=1&pageSize=15&search= effectuée avec succès.', 'SUCCESS', 0, NULL, NULL, NULL, NULL, '2026-02-15 09:47:20', '2026-02-15 09:47:20'),
(113, 'Erreur', 0, 'Une erreur est survenue lors de consultation 1.', 'ERREUR', 0, NULL, NULL, NULL, NULL, '2026-02-15 09:48:36', '2026-02-15 09:48:36'),
(114, 'Opération réussie', 0, 'Consultation 1 effectuée avec succès.', 'SUCCESS', 0, NULL, NULL, NULL, NULL, '2026-02-15 09:53:17', '2026-02-15 09:53:17'),
(115, 'Échec de connexion', 0, 'Une tentative de connexion a échoué.', 'ERREUR', 0, NULL, 1, NULL, NULL, '2026-02-15 09:53:37', '2026-02-15 09:53:37'),
(116, 'Opération réussie', 0, 'Création create effectuée avec succès.', 'SUCCESS', 0, NULL, NULL, NULL, NULL, '2026-02-15 09:53:37', '2026-02-15 09:53:37'),
(117, 'Opération réussie', 0, 'Création create effectuée avec succès.', 'SUCCESS', 0, NULL, NULL, NULL, NULL, '2026-02-15 09:53:37', '2026-02-15 09:53:37'),
(118, 'Erreur', 0, 'Une erreur est survenue lors de consultation sector?page=1&pagesize=10&search=.', 'ERREUR', 0, NULL, NULL, NULL, NULL, '2026-02-15 09:54:00', '2026-02-15 09:54:00'),
(119, 'Opération réussie', 0, 'Consultation 1 effectuée avec succès.', 'SUCCESS', 0, NULL, NULL, NULL, NULL, '2026-02-15 09:55:38', '2026-02-15 09:55:38'),
(120, 'Erreur', 0, 'Une erreur est survenue lors de consultation sector?page=1&pagesize=10&search=.', 'ERREUR', 0, NULL, NULL, NULL, NULL, '2026-02-15 09:56:01', '2026-02-15 09:56:01'),
(121, 'Opération réussie', 0, 'Consultation sector?page=1&pageSize=10&search=&paginate=true effectuée avec succès.', 'SUCCESS', 0, NULL, NULL, NULL, NULL, '2026-02-15 09:58:26', '2026-02-15 09:58:26'),
(122, 'Opération réussie', 0, 'Consultation sector?page=2&pageSize=10&search=&paginate=true effectuée avec succès.', 'SUCCESS', 0, NULL, NULL, NULL, NULL, '2026-02-15 09:58:32', '2026-02-15 09:58:32'),
(123, 'Erreur', 0, 'Une erreur est survenue lors de consultation sector?page=1&pagesize=10&search=&paginate=true.', 'ERREUR', 0, NULL, NULL, NULL, NULL, '2026-02-15 09:59:55', '2026-02-15 09:59:55'),
(124, 'Opération réussie', 0, 'Consultation 1 effectuée avec succès.', 'SUCCESS', 0, NULL, NULL, NULL, NULL, '2026-02-15 10:00:11', '2026-02-15 10:00:11'),
(125, 'Erreur', 0, 'Une erreur est survenue lors de consultation sector?page=1&pagesize=10&search=&paginate=true.', 'ERREUR', 0, NULL, NULL, NULL, NULL, '2026-02-15 10:00:36', '2026-02-15 10:00:36'),
(126, 'Erreur', 0, 'Une erreur est survenue lors de consultation sector?page=2&pagesize=10&search=&paginate=true.', 'ERREUR', 0, NULL, NULL, NULL, NULL, '2026-02-15 10:00:40', '2026-02-15 10:00:40'),
(127, 'Opération réussie', 0, 'Consultation sector?page=2&pageSize=10&search=N&paginate=true effectuée avec succès.', 'SUCCESS', 0, NULL, NULL, NULL, NULL, '2026-02-15 10:00:50', '2026-02-15 10:00:50'),
(128, 'Opération réussie', 0, 'Consultation sector?page=1&pageSize=10&search=N&paginate=true effectuée avec succès.', 'SUCCESS', 0, NULL, NULL, NULL, NULL, '2026-02-15 10:00:50', '2026-02-15 10:00:50'),
(129, 'Opération réussie', 0, 'Consultation sector?page=1&pageSize=10&search=Ns&paginate=true effectuée avec succès.', 'SUCCESS', 0, NULL, NULL, NULL, NULL, '2026-02-15 10:00:51', '2026-02-15 10:00:51'),
(130, 'Opération réussie', 0, 'Consultation sector?page=1&pageSize=10&search=Js&paginate=true effectuée avec succès.', 'SUCCESS', 0, NULL, NULL, NULL, NULL, '2026-02-15 10:00:53', '2026-02-15 10:00:53'),
(131, 'Opération réussie', 0, 'Consultation 1 effectuée avec succès.', 'SUCCESS', 0, NULL, NULL, NULL, NULL, '2026-02-15 11:41:01', '2026-02-15 11:41:01'),
(132, 'Erreur', 0, 'Une erreur est survenue lors de consultation sector?page=1&pagesize=10&search=&paginate=true.', 'ERREUR', 0, NULL, NULL, NULL, NULL, '2026-02-15 11:41:09', '2026-02-15 11:41:09'),
(133, 'Erreur', 0, 'Une erreur est survenue lors de consultation 1.', 'ERREUR', 0, NULL, NULL, NULL, NULL, '2026-02-15 11:54:02', '2026-02-15 11:54:02'),
(134, 'Erreur', 0, 'Une erreur est survenue lors de consultation sector?page=1&pagesize=10&search=&paginate=true.', 'ERREUR', 0, NULL, NULL, NULL, NULL, '2026-02-15 11:54:44', '2026-02-15 11:54:44'),
(135, 'Opération réussie', 0, 'Consultation 1 effectuée avec succès.', 'SUCCESS', 0, NULL, NULL, NULL, NULL, '2026-02-15 12:01:04', '2026-02-15 12:01:04'),
(136, 'Erreur', 0, 'Une erreur est survenue lors de consultation sector?page=1&pagesize=10&search=&paginate=true.', 'ERREUR', 0, NULL, NULL, NULL, NULL, '2026-02-15 12:01:29', '2026-02-15 12:01:29'),
(137, 'Erreur', 0, 'Une erreur est survenue lors de consultation sector?page=1&pagesize=10&search=&paginate=true.', 'ERREUR', 0, NULL, NULL, NULL, NULL, '2026-02-15 12:03:38', '2026-02-15 12:03:38'),
(138, 'Erreur', 0, 'Une erreur est survenue lors de consultation sector?page=1&pagesize=10&search=&paginate=true.', 'ERREUR', 0, NULL, NULL, NULL, NULL, '2026-02-15 12:03:41', '2026-02-15 12:03:41'),
(139, 'Opération réussie', 0, 'Consultation 1 effectuée avec succès.', 'SUCCESS', 0, NULL, NULL, NULL, NULL, '2026-02-15 12:05:45', '2026-02-15 12:05:45'),
(140, 'Erreur', 0, 'Une erreur est survenue lors de consultation sector?page=1&pagesize=10&search=&paginate=true.', 'ERREUR', 0, NULL, NULL, NULL, NULL, '2026-02-15 12:06:45', '2026-02-15 12:06:45'),
(141, 'Erreur', 0, 'Une erreur est survenue lors de consultation sector?page=2&pagesize=10&search=&paginate=true.', 'ERREUR', 0, NULL, NULL, NULL, NULL, '2026-02-15 12:07:04', '2026-02-15 12:07:04'),
(142, 'Opération réussie', 0, 'Consultation 1 effectuée avec succès.', 'SUCCESS', 0, NULL, NULL, NULL, NULL, '2026-02-15 12:07:16', '2026-02-15 12:07:16'),
(143, 'Erreur', 0, 'Une erreur est survenue lors de consultation sector?page=1&pagesize=10&search=&paginate=true.', 'ERREUR', 0, NULL, NULL, NULL, NULL, '2026-02-15 12:11:33', '2026-02-15 12:11:33'),
(144, 'Erreur', 0, 'Une erreur est survenue lors de consultation 1.', 'ERREUR', 0, NULL, NULL, NULL, NULL, '2026-02-15 12:13:12', '2026-02-15 12:13:12'),
(145, 'Erreur', 0, 'Une erreur est survenue lors de consultation sector?page=1&pagesize=10&search=&paginate=true.', 'ERREUR', 0, NULL, NULL, NULL, NULL, '2026-02-15 12:14:08', '2026-02-15 12:14:08'),
(146, 'Erreur', 0, 'Une erreur est survenue lors de consultation sector?page=2&pagesize=10&search=&paginate=true.', 'ERREUR', 0, NULL, NULL, NULL, NULL, '2026-02-15 12:15:36', '2026-02-15 12:15:36'),
(147, 'Erreur', 0, 'Une erreur est survenue lors de consultation sector?page=1&pagesize=10&search=&paginate=true.', 'ERREUR', 0, NULL, NULL, NULL, NULL, '2026-02-15 12:17:36', '2026-02-15 12:17:36'),
(148, 'Erreur', 0, 'Une erreur est survenue lors de consultation sector?page=2&pagesize=10&search=&paginate=true.', 'ERREUR', 0, NULL, NULL, NULL, NULL, '2026-02-15 12:19:54', '2026-02-15 12:19:54'),
(149, 'Opération réussie', 0, 'Consultation 1 effectuée avec succès.', 'SUCCESS', 0, NULL, NULL, NULL, NULL, '2026-02-15 12:23:52', '2026-02-15 12:23:52'),
(150, 'Erreur', 0, 'Une erreur est survenue lors de consultation sector?page=1&pagesize=10&search=&paginate=true.', 'ERREUR', 0, NULL, NULL, NULL, NULL, '2026-02-15 12:24:59', '2026-02-15 12:24:59'),
(151, 'Erreur', 0, 'Une erreur est survenue lors de consultation sector?page=1&pagesize=10&search=&paginate=true.', 'ERREUR', 0, NULL, NULL, NULL, NULL, '2026-02-15 12:32:48', '2026-02-15 12:32:48'),
(152, 'Opération réussie', 0, 'Consultation 1 effectuée avec succès.', 'SUCCESS', 0, NULL, NULL, NULL, NULL, '2026-02-15 12:34:34', '2026-02-15 12:34:34'),
(153, 'Erreur', 0, 'Une erreur est survenue lors de consultation sector?page=1&pagesize=10&search=&paginate=true.', 'ERREUR', 0, NULL, NULL, NULL, NULL, '2026-02-15 12:35:08', '2026-02-15 12:35:08'),
(154, 'Opération réussie', 0, 'Consultation 1 effectuée avec succès.', 'SUCCESS', 0, NULL, NULL, NULL, NULL, '2026-02-15 12:44:21', '2026-02-15 12:44:21'),
(155, 'Opération réussie', 0, 'Création create effectuée avec succès.', 'SUCCESS', 0, NULL, NULL, NULL, NULL, '2026-02-15 12:45:41', '2026-02-15 12:45:41'),
(156, 'Échec de connexion', 0, 'Une tentative de connexion a échoué.', 'ERREUR', 0, NULL, 1, NULL, NULL, '2026-02-15 12:45:41', '2026-02-15 12:45:41'),
(157, 'Opération réussie', 0, 'Création create effectuée avec succès.', 'SUCCESS', 0, NULL, NULL, NULL, NULL, '2026-02-15 12:45:41', '2026-02-15 12:45:41'),
(158, 'Erreur', 0, 'Une erreur est survenue lors de consultation sector?page=1&pagesize=10&search=&paginate=true.', 'ERREUR', 0, NULL, NULL, NULL, NULL, '2026-02-15 12:46:03', '2026-02-15 12:46:03'),
(159, 'Erreur', 0, 'Une erreur est survenue lors de consultation sector?page=2&pagesize=10&search=&paginate=true.', 'ERREUR', 0, NULL, NULL, NULL, NULL, '2026-02-15 12:50:30', '2026-02-15 12:50:30'),
(160, 'Opération réussie', 0, 'Consultation 1 effectuée avec succès.', 'SUCCESS', 0, NULL, NULL, NULL, NULL, '2026-02-15 12:57:30', '2026-02-15 12:57:30'),
(161, 'Erreur', 0, 'Une erreur est survenue lors de consultation sector?page=1&pagesize=10&search=&paginate=true.', 'ERREUR', 0, NULL, NULL, NULL, NULL, '2026-02-15 12:58:07', '2026-02-15 12:58:07'),
(162, 'Erreur', 0, 'Une erreur est survenue lors de consultation sector?page=2&pagesize=10&search=&paginate=true.', 'ERREUR', 0, NULL, NULL, NULL, NULL, '2026-02-15 13:00:54', '2026-02-15 13:00:54'),
(163, 'Opération réussie', 0, 'Mise à jour profile effectuée avec succès.', 'SUCCESS', 0, NULL, NULL, NULL, NULL, '2026-02-15 13:08:36', '2026-02-15 13:08:36'),
(164, 'Opération réussie', 0, 'Consultation 1 effectuée avec succès.', 'SUCCESS', 0, NULL, NULL, NULL, NULL, '2026-02-15 13:08:36', '2026-02-15 13:08:36'),
(165, 'Erreur', 0, 'Une erreur est survenue lors de consultation 1.', 'ERREUR', 0, NULL, NULL, NULL, NULL, '2026-02-15 13:16:06', '2026-02-15 13:16:06'),
(166, 'Erreur', 0, 'Une erreur est survenue lors de consultation 2.', 'ERREUR', 0, NULL, NULL, NULL, NULL, '2026-02-15 13:16:14', '2026-02-15 13:16:14'),
(167, 'Erreur', 0, 'Une erreur est survenue lors de consultation 2.', 'ERREUR', 0, NULL, NULL, NULL, NULL, '2026-02-15 13:21:23', '2026-02-15 13:21:23'),
(168, 'Erreur', 0, 'Une erreur est survenue lors de consultation 1.', 'ERREUR', 0, NULL, NULL, NULL, NULL, '2026-02-15 13:21:32', '2026-02-15 13:21:32'),
(169, 'Opération réussie', 0, 'Consultation company effectuée avec succès.', 'SUCCESS', 0, NULL, NULL, NULL, NULL, '2026-02-15 13:21:39', '2026-02-15 13:21:39'),
(170, 'Opération réussie', 0, 'Consultation 8 effectuée avec succès.', 'SUCCESS', 0, NULL, NULL, NULL, NULL, '2026-02-15 13:21:53', '2026-02-15 13:21:53'),
(171, 'Opération réussie', 0, 'Consultation 1 effectuée avec succès.', 'SUCCESS', 0, NULL, NULL, NULL, NULL, '2026-02-15 13:26:28', '2026-02-15 13:26:28'),
(172, 'Erreur', 0, 'Une erreur est survenue lors de consultation sector?page=1&pagesize=10&search=&paginate=true.', 'ERREUR', 0, NULL, NULL, NULL, NULL, '2026-02-15 13:27:24', '2026-02-15 13:27:24'),
(173, 'Opération réussie', 0, 'Consultation 8 effectuée avec succès.', 'SUCCESS', 0, NULL, NULL, NULL, NULL, '2026-02-15 13:28:23', '2026-02-15 13:28:23'),
(174, 'Erreur', 0, 'Une erreur est survenue lors de consultation 8.', 'ERREUR', 0, NULL, NULL, NULL, NULL, '2026-02-15 13:40:35', '2026-02-15 13:40:35'),
(175, 'Erreur', 0, 'Une erreur est survenue lors de consultation 8.', 'ERREUR', 0, NULL, NULL, NULL, NULL, '2026-02-15 13:43:14', '2026-02-15 13:43:14'),
(176, 'Opération réussie', 0, 'Consultation product effectuée avec succès.', 'SUCCESS', 0, NULL, NULL, NULL, NULL, '2026-02-15 13:49:02', '2026-02-15 13:49:02'),
(177, 'Erreur', 0, 'Une erreur est survenue lors de consultation sector?page=2&pagesize=10&search=&paginate=true.', 'ERREUR', 0, NULL, NULL, NULL, NULL, '2026-02-15 13:56:34', '2026-02-15 13:56:34'),
(178, 'Opération réussie', 0, 'Consultation product?companyId=8 effectuée avec succès.', 'SUCCESS', 0, NULL, NULL, NULL, NULL, '2026-02-15 13:58:46', '2026-02-15 13:58:46'),
(179, 'Opération réussie', 0, 'Consultation product?companyId=8 effectuée avec succès.', 'SUCCESS', 0, NULL, NULL, NULL, NULL, '2026-02-15 13:59:50', '2026-02-15 13:59:50'),
(180, 'Opération réussie', 0, 'Consultation 1 effectuée avec succès.', 'SUCCESS', 0, NULL, NULL, NULL, NULL, '2026-02-15 14:22:11', '2026-02-15 14:22:11'),
(181, 'Erreur', 0, 'Une erreur est survenue lors de consultation sector?page=1&pagesize=10&search=&paginate=true.', 'ERREUR', 0, NULL, NULL, NULL, NULL, '2026-02-15 14:22:41', '2026-02-15 14:22:41'),
(182, 'Opération réussie', 0, 'Consultation 1 effectuée avec succès.', 'SUCCESS', 0, NULL, NULL, NULL, NULL, '2026-02-15 14:24:23', '2026-02-15 14:24:23'),
(183, 'Erreur', 0, 'Une erreur est survenue lors de consultation sector?page=1&pagesize=10&search=&paginate=true.', 'ERREUR', 0, NULL, NULL, NULL, NULL, '2026-02-15 14:24:50', '2026-02-15 14:24:50'),
(184, 'Opération réussie', 0, 'Consultation product?page=1&pageSize=10&search=&paginate=true effectuée avec succès.', 'SUCCESS', 0, NULL, NULL, NULL, NULL, '2026-02-15 14:24:53', '2026-02-15 14:24:53'),
(185, 'Opération réussie', 0, 'Consultation product?page=2&pageSize=10&search=&paginate=true effectuée avec succès.', 'SUCCESS', 0, NULL, NULL, NULL, NULL, '2026-02-15 14:24:59', '2026-02-15 14:24:59'),
(186, 'Opération réussie', 0, 'Consultation product?page=1&pageSize=10&search=&paginate=true&companyId=8 effectuée avec succès.', 'SUCCESS', 0, NULL, NULL, NULL, NULL, '2026-02-15 14:30:57', '2026-02-15 14:30:57'),
(187, 'Erreur', 0, 'Une erreur est survenue lors de consultation product?page=1&pagesize=10&search=&paginate=true&companyid=8.', 'ERREUR', 0, NULL, NULL, NULL, NULL, '2026-02-15 14:32:10', '2026-02-15 14:32:10'),
(188, 'Opération réussie', 0, 'Consultation 1 effectuée avec succès.', 'SUCCESS', 0, NULL, NULL, NULL, NULL, '2026-02-15 14:40:24', '2026-02-15 14:40:24'),
(189, 'Erreur', 0, 'Une erreur est survenue lors de consultation sector?page=1&pagesize=10&search=&paginate=true.', 'ERREUR', 0, NULL, NULL, NULL, NULL, '2026-02-15 14:41:03', '2026-02-15 14:41:03'),
(190, 'Erreur', 0, 'Une erreur est survenue lors de consultation product?page=1&pagesize=10&search=&paginate=true&companyid=8.', 'ERREUR', 0, NULL, NULL, NULL, NULL, '2026-02-15 14:41:13', '2026-02-15 14:41:13'),
(191, 'Opération réussie', 0, 'Consultation product?page=1&pageSize=10&search=B&paginate=true&companyId=8 effectuée avec succès.', 'SUCCESS', 0, NULL, NULL, NULL, NULL, '2026-02-15 14:42:02', '2026-02-15 14:42:02'),
(192, 'Opération réussie', 0, 'Consultation product?page=1&pageSize=10&search=Bi&paginate=true&companyId=8 effectuée avec succès.', 'SUCCESS', 0, NULL, NULL, NULL, NULL, '2026-02-15 14:42:02', '2026-02-15 14:42:02'),
(193, 'Opération réussie', 0, 'Consultation product?page=1&pageSize=10&search=Bim&paginate=true&companyId=8 effectuée avec succès.', 'SUCCESS', 0, NULL, NULL, NULL, NULL, '2026-02-15 14:42:02', '2026-02-15 14:42:02'),
(194, 'Opération réussie', 0, 'Consultation product?page=1&pageSize=10&search=D&paginate=true&companyId=8 effectuée avec succès.', 'SUCCESS', 0, NULL, NULL, NULL, NULL, '2026-02-15 14:42:04', '2026-02-15 14:42:04'),
(195, 'Opération réussie', 0, 'Consultation product?page=1&pageSize=10&search=Dl&paginate=true&companyId=8 effectuée avec succès.', 'SUCCESS', 0, NULL, NULL, NULL, NULL, '2026-02-15 14:42:04', '2026-02-15 14:42:04'),
(196, 'Opération réussie', 0, 'Consultation product?page=1&pageSize=10&search=Dld&paginate=true&companyId=8 effectuée avec succès.', 'SUCCESS', 0, NULL, NULL, NULL, NULL, '2026-02-15 14:42:04', '2026-02-15 14:42:04'),
(197, 'Erreur', 0, 'Une erreur est survenue lors de consultation product?page=1&pagesize=10&search=&paginate=true&companyid=8.', 'ERREUR', 0, NULL, NULL, NULL, NULL, '2026-02-15 14:47:31', '2026-02-15 14:47:31'),
(198, 'Opération réussie', 0, 'Consultation product?page=1&pageSize=10&search=H&paginate=true&companyId=8 effectuée avec succès.', 'SUCCESS', 0, NULL, NULL, NULL, NULL, '2026-02-15 14:47:36', '2026-02-15 14:47:36'),
(199, 'Opération réussie', 0, 'Consultation product?page=1&pageSize=10&search=Hh&paginate=true&companyId=8 effectuée avec succès.', 'SUCCESS', 0, NULL, NULL, NULL, NULL, '2026-02-15 14:47:36', '2026-02-15 14:47:36'),
(200, 'Opération réussie', 0, 'Consultation product?page=1&pageSize=10&search=S&paginate=true&companyId=8 effectuée avec succès.', 'SUCCESS', 0, NULL, NULL, NULL, NULL, '2026-02-15 14:48:16', '2026-02-15 14:48:16'),
(201, 'Opération réussie', 0, 'Consultation product?page=1&pageSize=10&search=Sk&paginate=true&companyId=8 effectuée avec succès.', 'SUCCESS', 0, NULL, NULL, NULL, NULL, '2026-02-15 14:48:16', '2026-02-15 14:48:16'),
(202, 'Opération réussie', 0, 'Consultation product?page=1&pageSize=10&search=Bw&paginate=true&companyId=8 effectuée avec succès.', 'SUCCESS', 0, NULL, NULL, NULL, NULL, '2026-02-15 14:49:01', '2026-02-15 14:49:01'),
(203, 'Erreur', 0, 'Une erreur est survenue lors de consultation product?page=1&pagesize=10&search=b&paginate=true&companyid=8.', 'ERREUR', 0, NULL, NULL, NULL, NULL, '2026-02-15 14:49:01', '2026-02-15 14:49:01'),
(204, 'Opération réussie', 0, 'Consultation product effectuée avec succès.', 'SUCCESS', 0, NULL, NULL, NULL, NULL, '2026-02-15 14:51:36', '2026-02-15 14:51:36'),
(205, 'Opération réussie', 0, 'Consultation product?companyId=8 effectuée avec succès.', 'SUCCESS', 0, NULL, NULL, NULL, NULL, '2026-02-15 14:52:00', '2026-02-15 14:52:00'),
(206, 'Opération réussie', 0, 'Consultation 1 effectuée avec succès.', 'SUCCESS', 0, NULL, NULL, NULL, NULL, '2026-02-15 14:54:06', '2026-02-15 14:54:06'),
(207, 'Opération réussie', 0, 'Consultation product?companyId=8 effectuée avec succès.', 'SUCCESS', 0, NULL, NULL, NULL, NULL, '2026-02-15 14:54:41', '2026-02-15 14:54:41'),
(208, 'Erreur', 0, 'Une erreur est survenue lors de consultation sector?page=2&pagesize=10&search=&paginate=true.', 'ERREUR', 0, NULL, NULL, NULL, NULL, '2026-02-15 14:55:50', '2026-02-15 14:55:50'),
(209, 'Erreur', 0, 'Une erreur est survenue lors de consultation 1.', 'ERREUR', 0, NULL, NULL, NULL, NULL, '2026-02-15 14:56:07', '2026-02-15 14:56:07'),
(210, 'Opération réussie', 0, 'Consultation notification_track?userId=1&search=&page=1&pageSize=20 effectuée avec succès.', 'SUCCESS', 0, NULL, NULL, NULL, NULL, '2026-02-15 14:56:41', '2026-02-15 14:56:41'),
(211, 'Erreur', 0, 'Une erreur est survenue lors de consultation sector?page=1&pagesize=10&search=&paginate=true.', 'ERREUR', 0, NULL, NULL, NULL, NULL, '2026-02-15 14:56:54', '2026-02-15 14:56:54'),
(212, 'Opération réussie', 0, 'Consultation product?page=1&pageSize=10&search=&paginate=true&companyId=8 effectuée avec succès.', 'SUCCESS', 0, NULL, NULL, NULL, NULL, '2026-02-15 14:57:00', '2026-02-15 14:57:00'),
(213, 'Opération réussie', 0, 'Consultation product?page=1&pageSize=10&search=&paginate=true&companyId=8 effectuée avec succès.', 'SUCCESS', 0, NULL, NULL, NULL, NULL, '2026-02-15 15:04:09', '2026-02-15 15:04:09'),
(214, 'Erreur', 0, 'Une erreur est survenue lors de consultation product?page=1&pagesize=10&search=&paginate=true&companyid=8.', 'ERREUR', 0, NULL, NULL, NULL, NULL, '2026-02-15 15:04:11', '2026-02-15 15:04:11'),
(215, 'Erreur', 0, 'Une erreur est survenue lors de consultation product?page=1&pagesize=10&search=&paginate=true&companyid=8.', 'ERREUR', 0, NULL, NULL, NULL, NULL, '2026-02-15 15:04:18', '2026-02-15 15:04:18'),
(216, 'Erreur', 0, 'Une erreur est survenue lors de consultation product?page=1&pagesize=10&search=&paginate=true&companyid=8.', 'ERREUR', 0, NULL, NULL, NULL, NULL, '2026-02-15 15:04:20', '2026-02-15 15:04:20'),
(217, 'Erreur', 0, 'Une erreur est survenue lors de consultation product?page=1&pagesize=10&search=&paginate=true&companyid=8.', 'ERREUR', 0, NULL, NULL, NULL, NULL, '2026-02-15 15:04:21', '2026-02-15 15:04:21'),
(218, 'Erreur', 0, 'Une erreur est survenue lors de consultation product?page=1&pagesize=10&search=&paginate=true&companyid=8.', 'ERREUR', 0, NULL, NULL, NULL, NULL, '2026-02-15 15:05:07', '2026-02-15 15:05:07'),
(219, 'Erreur', 0, 'Une erreur est survenue lors de consultation product?page=1&pagesize=10&search=&paginate=true&companyid=8.', 'ERREUR', 0, NULL, NULL, NULL, NULL, '2026-02-15 15:05:08', '2026-02-15 15:05:08'),
(220, 'Erreur', 0, 'Une erreur est survenue lors de consultation product?page=1&pagesize=10&search=&paginate=true&companyid=8.', 'ERREUR', 0, NULL, NULL, NULL, NULL, '2026-02-15 15:05:09', '2026-02-15 15:05:09'),
(221, 'Erreur', 0, 'Une erreur est survenue lors de consultation product?page=1&pagesize=10&search=&paginate=true&companyid=8.', 'ERREUR', 0, NULL, NULL, NULL, NULL, '2026-02-15 15:11:40', '2026-02-15 15:11:40'),
(222, 'Erreur', 0, 'Une erreur est survenue lors de consultation product?page=1&pagesize=10&search=&paginate=true&companyid=8.', 'ERREUR', 0, NULL, NULL, NULL, NULL, '2026-02-15 15:11:42', '2026-02-15 15:11:42'),
(223, 'Opération réussie', 0, 'Consultation 1 effectuée avec succès.', 'SUCCESS', 0, NULL, NULL, NULL, NULL, '2026-02-15 15:41:37', '2026-02-15 15:41:37'),
(224, 'Erreur', 0, 'Une erreur est survenue lors de consultation sector?page=1&pagesize=10&search=&paginate=true.', 'ERREUR', 0, NULL, NULL, NULL, NULL, '2026-02-15 15:42:14', '2026-02-15 15:42:14'),
(225, 'Erreur', 0, 'Une erreur est survenue lors de consultation product?page=1&pagesize=10&search=&paginate=true&companyid=8.', 'ERREUR', 0, NULL, NULL, NULL, NULL, '2026-02-15 15:42:20', '2026-02-15 15:42:20'),
(226, 'Erreur', 0, 'Une erreur est survenue lors de création paiement.', 'ERREUR', 0, NULL, NULL, NULL, NULL, '2026-02-15 15:42:38', '2026-02-15 15:42:38'),
(227, 'Erreur', 0, 'Une erreur est survenue lors de création paiement.', 'ERREUR', 0, NULL, NULL, NULL, NULL, '2026-02-15 15:44:41', '2026-02-15 15:44:41'),
(228, 'Erreur', 0, 'Une erreur est survenue lors de création paiement.', 'ERREUR', 0, NULL, NULL, NULL, NULL, '2026-02-15 15:45:53', '2026-02-15 15:45:53'),
(229, 'Opération réussie', 0, 'Consultation 1 effectuée avec succès.', 'SUCCESS', 0, NULL, NULL, NULL, NULL, '2026-02-15 15:47:06', '2026-02-15 15:47:06'),
(230, 'Opération réussie', 0, 'Consultation 1 effectuée avec succès.', 'SUCCESS', 0, NULL, NULL, NULL, NULL, '2026-02-15 15:47:37', '2026-02-15 15:47:37'),
(231, 'Erreur', 0, 'Une erreur est survenue lors de consultation sector?page=1&pagesize=10&search=&paginate=true.', 'ERREUR', 0, NULL, NULL, NULL, NULL, '2026-02-15 15:47:39', '2026-02-15 15:47:39'),
(232, 'Erreur', 0, 'Une erreur est survenue lors de consultation product?page=1&pagesize=10&search=&paginate=true&companyid=8.', 'ERREUR', 0, NULL, NULL, NULL, NULL, '2026-02-15 15:47:41', '2026-02-15 15:47:41'),
(233, 'Erreur', 0, 'Une erreur est survenue lors de création paiement.', 'ERREUR', 0, NULL, NULL, NULL, NULL, '2026-02-15 15:47:50', '2026-02-15 15:47:50'),
(234, 'Erreur', 0, 'Une erreur est survenue lors de création paiement.', 'ERREUR', 0, NULL, NULL, NULL, NULL, '2026-02-15 15:49:34', '2026-02-15 15:49:34'),
(235, 'Opération réussie', 0, 'Consultation 1 effectuée avec succès.', 'SUCCESS', 0, NULL, NULL, NULL, NULL, '2026-02-15 15:55:39', '2026-02-15 15:55:39'),
(236, 'Erreur', 0, 'Une erreur est survenue lors de consultation sector?page=1&pagesize=10&search=&paginate=true.', 'ERREUR', 0, NULL, NULL, NULL, NULL, '2026-02-15 15:56:17', '2026-02-15 15:56:17'),
(237, 'Erreur', 0, 'Une erreur est survenue lors de consultation product?page=1&pagesize=10&search=&paginate=true&companyid=8.', 'ERREUR', 0, NULL, NULL, NULL, NULL, '2026-02-15 15:56:26', '2026-02-15 15:56:26'),
(238, 'Paiement réussi ✅', 0, 'Votre paiement de 100$ pour la commande ORD-1771170994610 a été effectué avec succès.', 'SUCCESS', 0, NULL, NULL, NULL, NULL, '2026-02-15 15:56:34', '2026-02-15 15:56:34'),
(239, 'Commande payée 🛒', 0, 'Une nouvelle commande ORD-1771170994610 a été payée.', 'INFO', 0, NULL, NULL, NULL, NULL, '2026-02-15 15:56:34', '2026-02-15 15:56:34'),
(240, 'Opération réussie', 0, 'Création paiement effectuée avec succès.', 'SUCCESS', 0, NULL, NULL, NULL, NULL, '2026-02-15 15:56:38', '2026-02-15 15:56:38'),
(241, 'Opération réussie', 0, 'Consultation 1 effectuée avec succès.', 'SUCCESS', 0, NULL, NULL, NULL, NULL, '2026-02-15 15:58:27', '2026-02-15 15:58:27'),
(242, 'Opération réussie', 0, 'Création create effectuée avec succès.', 'SUCCESS', 0, NULL, NULL, NULL, NULL, '2026-02-15 16:00:15', '2026-02-15 16:00:15'),
(243, 'Échec de connexion', 0, 'Une tentative de connexion a échoué.', 'ERREUR', 0, NULL, 1, NULL, NULL, '2026-02-15 16:00:15', '2026-02-15 16:00:15'),
(244, 'Opération réussie', 0, 'Création create effectuée avec succès.', 'SUCCESS', 0, NULL, NULL, NULL, NULL, '2026-02-15 16:00:15', '2026-02-15 16:00:15'),
(245, 'Erreur', 0, 'Une erreur est survenue lors de consultation sector?page=1&pagesize=10&search=&paginate=true.', 'ERREUR', 0, NULL, NULL, NULL, NULL, '2026-02-15 16:00:49', '2026-02-15 16:00:49'),
(246, 'Erreur', 0, 'Une erreur est survenue lors de consultation product?page=1&pagesize=10&search=&paginate=true&companyid=8.', 'ERREUR', 0, NULL, NULL, NULL, NULL, '2026-02-15 16:00:53', '2026-02-15 16:00:53'),
(247, 'Paiement réussi ✅', 0, 'Votre paiement de 100$ pour la commande ORD-1771171272432 a été effectué avec succès.', 'SUCCESS', 0, NULL, NULL, NULL, NULL, '2026-02-15 16:01:12', '2026-02-15 16:01:12'),
(248, 'Commande payée 🛒', 0, 'Une nouvelle commande ORD-1771171272432 a été payée.', 'INFO', 0, NULL, NULL, NULL, NULL, '2026-02-15 16:01:12', '2026-02-15 16:01:12'),
(249, 'Opération réussie', 0, 'Création paiement effectuée avec succès.', 'SUCCESS', 0, NULL, NULL, NULL, NULL, '2026-02-15 16:01:15', '2026-02-15 16:01:15'),
(250, 'Opération réussie', 0, 'Consultation 1 effectuée avec succès.', 'SUCCESS', 0, NULL, NULL, NULL, NULL, '2026-02-15 16:02:46', '2026-02-15 16:02:46'),
(251, 'Opération réussie', 0, 'Consultation 1 effectuée avec succès.', 'SUCCESS', 0, NULL, NULL, NULL, NULL, '2026-02-15 16:03:13', '2026-02-15 16:03:13'),
(252, 'Erreur', 0, 'Une erreur est survenue lors de consultation sector?page=1&pagesize=10&search=&paginate=true.', 'ERREUR', 0, NULL, NULL, NULL, NULL, '2026-02-15 16:03:15', '2026-02-15 16:03:15'),
(253, 'Erreur', 0, 'Une erreur est survenue lors de consultation product?page=1&pagesize=10&search=&paginate=true&companyid=8.', 'ERREUR', 0, NULL, NULL, NULL, NULL, '2026-02-15 16:03:18', '2026-02-15 16:03:18'),
(254, 'Paiement réussi ✅', 0, 'Votre paiement de 100$ pour la commande ORD-1771171402442 a été effectué avec succès.', 'SUCCESS', 0, NULL, NULL, NULL, NULL, '2026-02-15 16:03:22', '2026-02-15 16:03:22'),
(255, 'Commande payée 🛒', 0, 'Une nouvelle commande ORD-1771171402442 a été payée.', 'INFO', 0, NULL, NULL, NULL, NULL, '2026-02-15 16:03:22', '2026-02-15 16:03:22'),
(256, 'Opération réussie', 0, 'Création paiement effectuée avec succès.', 'SUCCESS', 0, NULL, NULL, NULL, NULL, '2026-02-15 16:03:26', '2026-02-15 16:03:26'),
(257, 'Opération réussie', 0, 'Consultation 1 effectuée avec succès.', 'SUCCESS', 0, NULL, NULL, NULL, NULL, '2026-02-15 16:04:04', '2026-02-15 16:04:04'),
(258, 'Paiement réussi ✅', 0, 'Votre paiement de 100$ pour la commande ORD-1771171454531 a été effectué avec succès.', 'SUCCESS', 0, NULL, NULL, NULL, NULL, '2026-02-15 16:04:14', '2026-02-15 16:04:14'),
(259, 'Commande payée 🛒', 0, 'Une nouvelle commande ORD-1771171454531 a été payée.', 'INFO', 0, NULL, NULL, NULL, NULL, '2026-02-15 16:04:14', '2026-02-15 16:04:14'),
(260, 'Opération réussie', 0, 'Création paiement effectuée avec succès.', 'SUCCESS', 0, NULL, NULL, NULL, NULL, '2026-02-15 16:04:17', '2026-02-15 16:04:17'),
(261, 'Opération réussie', 0, 'Consultation 1 effectuée avec succès.', 'SUCCESS', 0, NULL, NULL, NULL, NULL, '2026-02-15 16:05:19', '2026-02-15 16:05:19'),
(262, 'Erreur', 0, 'Une erreur est survenue lors de consultation sector?page=1&pagesize=10&search=&paginate=true.', 'ERREUR', 0, NULL, NULL, NULL, NULL, '2026-02-15 16:05:51', '2026-02-15 16:05:51'),
(263, 'Erreur', 0, 'Une erreur est survenue lors de consultation product?page=1&pagesize=10&search=&paginate=true&companyid=8.', 'ERREUR', 0, NULL, NULL, NULL, NULL, '2026-02-15 16:05:54', '2026-02-15 16:05:54'),
(264, 'Paiement réussi ✅', 0, 'Votre paiement de 100$ pour la commande ORD-1771171557310 a été effectué avec succès.', 'SUCCESS', 0, NULL, NULL, NULL, NULL, '2026-02-15 16:05:57', '2026-02-15 16:05:57'),
(265, 'Commande payée 🛒', 0, 'Une nouvelle commande ORD-1771171557310 a été payée.', 'INFO', 0, NULL, NULL, NULL, NULL, '2026-02-15 16:05:57', '2026-02-15 16:05:57'),
(266, 'Opération réussie', 0, 'Création paiement effectuée avec succès.', 'SUCCESS', 0, NULL, NULL, NULL, NULL, '2026-02-15 16:06:01', '2026-02-15 16:06:01'),
(267, 'Opération réussie', 0, 'Consultation 1 effectuée avec succès.', 'SUCCESS', 0, NULL, NULL, NULL, NULL, '2026-02-15 16:06:05', '2026-02-15 16:06:05'),
(268, 'Opération réussie', 0, 'Consultation notification_track?userId=1&search=&page=1&pageSize=20 effectuée avec succès.', 'SUCCESS', 0, NULL, NULL, NULL, NULL, '2026-02-15 16:06:08', '2026-02-15 16:06:08'),
(269, 'Erreur', 0, 'Une erreur est survenue lors de création paiement.', 'ERREUR', 0, NULL, NULL, NULL, NULL, '2026-02-15 16:06:21', '2026-02-15 16:06:21'),
(270, 'Erreur', 0, 'Une erreur est survenue lors de consultation 1.', 'ERREUR', 0, NULL, NULL, NULL, NULL, '2026-02-15 16:09:41', '2026-02-15 16:09:41'),
(271, 'Erreur', 0, 'Une erreur est survenue lors de consultation sector?page=1&pagesize=10&search=&paginate=true.', 'ERREUR', 0, NULL, NULL, NULL, NULL, '2026-02-15 16:10:18', '2026-02-15 16:10:18'),
(272, 'Erreur', 0, 'Une erreur est survenue lors de consultation product?page=1&pagesize=10&search=&paginate=true&companyid=8.', 'ERREUR', 0, NULL, NULL, NULL, NULL, '2026-02-15 16:10:20', '2026-02-15 16:10:20'),
(273, 'Paiement réussi ✅', 0, 'Votre paiement de 100$ pour la commande ORD-1771171824276 a été effectué avec succès.', 'SUCCESS', 0, NULL, NULL, NULL, NULL, '2026-02-15 16:10:24', '2026-02-15 16:10:24'),
(274, 'Commande payée 🛒', 0, 'Une nouvelle commande ORD-1771171824276 a été payée.', 'INFO', 0, NULL, NULL, NULL, NULL, '2026-02-15 16:10:24', '2026-02-15 16:10:24'),
(275, 'Opération réussie', 0, 'Création paiement effectuée avec succès.', 'SUCCESS', 0, NULL, NULL, NULL, NULL, '2026-02-15 16:10:28', '2026-02-15 16:10:28'),
(276, 'Opération réussie', 0, 'Consultation 1 effectuée avec succès.', 'SUCCESS', 0, NULL, NULL, NULL, NULL, '2026-02-15 16:10:32', '2026-02-15 16:10:32'),
(277, 'Erreur', 0, 'Une erreur est survenue lors de création paiement.', 'ERREUR', 0, NULL, NULL, NULL, NULL, '2026-02-15 16:10:41', '2026-02-15 16:10:41'),
(278, 'Erreur', 0, 'Une erreur est survenue lors de consultation 1.', 'ERREUR', 0, NULL, NULL, NULL, NULL, '2026-02-15 16:12:43', '2026-02-15 16:12:43'),
(279, 'Opération réussie', 0, 'Création create effectuée avec succès.', 'SUCCESS', 0, NULL, NULL, NULL, NULL, '2026-02-15 16:16:52', '2026-02-15 16:16:52'),
(280, 'Échec de connexion', 0, 'Une tentative de connexion a échoué.', 'ERREUR', 0, NULL, 1, NULL, NULL, '2026-02-15 16:16:52', '2026-02-15 16:16:52'),
(281, 'Opération réussie', 0, 'Création create effectuée avec succès.', 'SUCCESS', 0, NULL, NULL, NULL, NULL, '2026-02-15 16:16:52', '2026-02-15 16:16:52'),
(282, 'Opération réussie', 0, 'Consultation 1 effectuée avec succès.', 'SUCCESS', 0, NULL, NULL, NULL, NULL, '2026-02-15 16:17:08', '2026-02-15 16:17:08'),
(283, 'Erreur', 0, 'Une erreur est survenue lors de consultation sector?page=1&pagesize=10&search=&paginate=true.', 'ERREUR', 0, NULL, NULL, NULL, NULL, '2026-02-15 16:17:11', '2026-02-15 16:17:11'),
(284, 'Erreur', 0, 'Une erreur est survenue lors de consultation product?page=1&pagesize=10&search=&paginate=true&companyid=8.', 'ERREUR', 0, NULL, NULL, NULL, NULL, '2026-02-15 16:17:14', '2026-02-15 16:17:14'),
(285, 'Paiement réussi ✅', 0, 'Votre paiement de 100$ pour la commande ORD-1771172244260 a été effectué avec succès.', 'SUCCESS', 0, NULL, NULL, NULL, NULL, '2026-02-15 16:17:24', '2026-02-15 16:17:24');
INSERT INTO `notifications` (`notificationId`, `title`, `global`, `message`, `type`, `isRead`, `expeTrackId`, `userId`, `commerceId`, `branchTrackId`, `createdAt`, `updatedAt`) VALUES
(286, 'Commande payée 🛒', 0, 'Une nouvelle commande ORD-1771172244260 a été payée.', 'INFO', 0, NULL, NULL, NULL, NULL, '2026-02-15 16:17:24', '2026-02-15 16:17:24'),
(287, 'Opération réussie', 0, 'Création paiement effectuée avec succès.', 'SUCCESS', 0, NULL, NULL, NULL, NULL, '2026-02-15 16:17:27', '2026-02-15 16:17:27'),
(288, 'Opération réussie', 0, 'Consultation 1 effectuée avec succès.', 'SUCCESS', 0, NULL, NULL, NULL, NULL, '2026-02-15 16:17:31', '2026-02-15 16:17:31'),
(289, 'Opération réussie', 0, 'Consultation 1 effectuée avec succès.', 'SUCCESS', 0, NULL, NULL, NULL, NULL, '2026-02-15 16:18:40', '2026-02-15 16:18:40'),
(290, 'Opération réussie', 0, 'Consultation 1 effectuée avec succès.', 'SUCCESS', 0, NULL, NULL, NULL, NULL, '2026-02-15 16:19:06', '2026-02-15 16:19:06'),
(291, 'Erreur', 0, 'Une erreur est survenue lors de consultation sector?page=1&pagesize=10&search=&paginate=true.', 'ERREUR', 0, NULL, NULL, NULL, NULL, '2026-02-15 16:19:08', '2026-02-15 16:19:08'),
(292, 'Erreur', 0, 'Une erreur est survenue lors de consultation product?page=1&pagesize=10&search=&paginate=true&companyid=8.', 'ERREUR', 0, NULL, NULL, NULL, NULL, '2026-02-15 16:19:11', '2026-02-15 16:19:11'),
(293, 'Erreur', 0, 'Une erreur est survenue lors de consultation product?page=1&pagesize=10&search=&paginate=true&companyid=8.', 'ERREUR', 0, NULL, NULL, NULL, NULL, '2026-02-15 16:19:17', '2026-02-15 16:19:17'),
(294, 'Paiement réussi ✅', 0, 'Votre paiement de 100$ pour la commande ORD-1771172373660 a été effectué avec succès.', 'SUCCESS', 0, NULL, NULL, NULL, NULL, '2026-02-15 16:19:33', '2026-02-15 16:19:33'),
(295, 'Commande payée 🛒', 0, 'Une nouvelle commande ORD-1771172373660 a été payée.', 'INFO', 0, NULL, NULL, NULL, NULL, '2026-02-15 16:19:33', '2026-02-15 16:19:33'),
(296, 'Opération réussie', 0, 'Création paiement effectuée avec succès.', 'SUCCESS', 0, NULL, NULL, NULL, NULL, '2026-02-15 16:19:37', '2026-02-15 16:19:37'),
(297, 'Opération réussie', 0, 'Consultation 1 effectuée avec succès.', 'SUCCESS', 0, NULL, NULL, NULL, NULL, '2026-02-15 16:19:42', '2026-02-15 16:19:42'),
(298, 'Erreur', 0, 'Une erreur est survenue lors de consultation 1.', 'ERREUR', 0, NULL, NULL, NULL, NULL, '2026-02-15 16:23:08', '2026-02-15 16:23:08'),
(299, 'Opération réussie', 0, 'Création create effectuée avec succès.', 'SUCCESS', 0, NULL, NULL, NULL, NULL, '2026-02-15 16:24:19', '2026-02-15 16:24:19'),
(300, 'Échec de connexion', 0, 'Une tentative de connexion a échoué.', 'ERREUR', 0, NULL, 1, NULL, NULL, '2026-02-15 16:24:19', '2026-02-15 16:24:19'),
(301, 'Opération réussie', 0, 'Création create effectuée avec succès.', 'SUCCESS', 0, NULL, NULL, NULL, NULL, '2026-02-15 16:24:19', '2026-02-15 16:24:19'),
(302, 'Erreur', 0, 'Une erreur est survenue lors de consultation sector?page=1&pagesize=10&search=&paginate=true.', 'ERREUR', 0, NULL, NULL, NULL, NULL, '2026-02-15 16:24:39', '2026-02-15 16:24:39'),
(303, 'Erreur', 0, 'Une erreur est survenue lors de consultation product?page=1&pagesize=10&search=&paginate=true&companyid=8.', 'ERREUR', 0, NULL, NULL, NULL, NULL, '2026-02-15 16:24:42', '2026-02-15 16:24:42'),
(304, 'Paiement réussi ✅', 0, 'Votre paiement de 100$ pour la commande ORD-1771172696166 a été effectué avec succès.', 'SUCCESS', 0, NULL, NULL, NULL, NULL, '2026-02-15 16:24:56', '2026-02-15 16:24:56'),
(305, 'Commande payée 🛒', 0, 'Une nouvelle commande ORD-1771172696166 a été payée.', 'INFO', 0, NULL, NULL, NULL, NULL, '2026-02-15 16:24:56', '2026-02-15 16:24:56'),
(306, 'Opération réussie', 0, 'Création paiement effectuée avec succès.', 'SUCCESS', 0, NULL, NULL, NULL, NULL, '2026-02-15 16:25:00', '2026-02-15 16:25:00'),
(307, 'Opération réussie', 0, 'Consultation 1 effectuée avec succès.', 'SUCCESS', 0, NULL, NULL, NULL, NULL, '2026-02-15 16:25:06', '2026-02-15 16:25:06'),
(308, 'Erreur', 0, 'Une erreur est survenue lors de création paiement.', 'ERREUR', 0, NULL, NULL, NULL, NULL, '2026-02-15 16:30:33', '2026-02-15 16:30:33'),
(309, 'Erreur', 0, 'Une erreur est survenue lors de création paiement.', 'ERREUR', 0, NULL, NULL, NULL, NULL, '2026-02-15 16:30:36', '2026-02-15 16:30:36'),
(310, 'Erreur', 0, 'Une erreur est survenue lors de création paiement.', 'ERREUR', 0, NULL, NULL, NULL, NULL, '2026-02-15 16:31:34', '2026-02-15 16:31:34'),
(311, 'Erreur', 0, 'Une erreur est survenue lors de création paiement.', 'ERREUR', 0, NULL, NULL, NULL, NULL, '2026-02-15 16:31:36', '2026-02-15 16:31:36'),
(312, 'Erreur', 0, 'Une erreur est survenue lors de création paiement.', 'ERREUR', 0, NULL, NULL, NULL, NULL, '2026-02-15 16:31:39', '2026-02-15 16:31:39'),
(313, 'Erreur', 0, 'Une erreur est survenue lors de création paiement.', 'ERREUR', 0, NULL, NULL, NULL, NULL, '2026-02-15 16:32:20', '2026-02-15 16:32:20'),
(314, 'Erreur', 0, 'Une erreur est survenue lors de création paiement.', 'ERREUR', 0, NULL, NULL, NULL, NULL, '2026-02-15 16:32:22', '2026-02-15 16:32:22'),
(315, 'Erreur', 0, 'Une erreur est survenue lors de création paiement.', 'ERREUR', 0, NULL, NULL, NULL, NULL, '2026-02-15 16:32:24', '2026-02-15 16:32:24'),
(316, 'Erreur', 0, 'Une erreur est survenue lors de création paiement.', 'ERREUR', 0, NULL, NULL, NULL, NULL, '2026-02-15 16:32:26', '2026-02-15 16:32:26'),
(317, 'Opération réussie', 0, 'Consultation notification_track?userId=1&search=&page=1&pageSize=20 effectuée avec succès.', 'SUCCESS', 0, NULL, NULL, NULL, NULL, '2026-02-15 16:33:41', '2026-02-15 16:33:41'),
(318, 'Erreur', 0, 'Une erreur est survenue lors de consultation 1.', 'ERREUR', 0, NULL, NULL, NULL, NULL, '2026-02-15 16:34:54', '2026-02-15 16:34:54'),
(319, 'Erreur', 0, 'Une erreur est survenue lors de consultation sector?page=1&pagesize=10&search=&paginate=true.', 'ERREUR', 0, NULL, NULL, NULL, NULL, '2026-02-15 16:35:59', '2026-02-15 16:35:59'),
(320, 'Erreur', 0, 'Une erreur est survenue lors de consultation product?page=1&pagesize=10&search=&paginate=true&companyid=8.', 'ERREUR', 0, NULL, NULL, NULL, NULL, '2026-02-15 16:36:01', '2026-02-15 16:36:01'),
(321, 'Erreur', 0, 'Une erreur est survenue lors de création paiement.', 'ERREUR', 0, NULL, NULL, NULL, NULL, '2026-02-15 16:36:10', '2026-02-15 16:36:10'),
(322, 'Opération réussie', 0, 'Consultation product?page=1&pageSize=10&search=D&paginate=true&companyId=8 effectuée avec succès.', 'SUCCESS', 0, NULL, NULL, NULL, NULL, '2026-02-15 16:38:28', '2026-02-15 16:38:28'),
(323, 'Opération réussie', 0, 'Consultation product?page=1&pageSize=10&search=Df&paginate=true&companyId=8 effectuée avec succès.', 'SUCCESS', 0, NULL, NULL, NULL, NULL, '2026-02-15 16:38:29', '2026-02-15 16:38:29'),
(324, 'Erreur', 0, 'Une erreur est survenue lors de consultation product?page=1&pagesize=10&search=d&paginate=true&companyid=8.', 'ERREUR', 0, NULL, NULL, NULL, NULL, '2026-02-15 16:41:29', '2026-02-15 16:41:29'),
(325, 'Erreur', 0, 'Une erreur est survenue lors de consultation product?page=1&pagesize=10&search=&paginate=true&companyid=8.', 'ERREUR', 0, NULL, NULL, NULL, NULL, '2026-02-15 16:41:29', '2026-02-15 16:41:29'),
(326, 'Opération réussie', 0, 'Consultation notification_track?userId=1&search=&page=1&pageSize=20 effectuée avec succès.', 'SUCCESS', 0, NULL, NULL, NULL, NULL, '2026-02-15 16:41:46', '2026-02-15 16:41:46'),
(327, 'Opération réussie', 0, 'Consultation 1 effectuée avec succès.', 'SUCCESS', 0, NULL, NULL, NULL, NULL, '2026-02-15 16:43:06', '2026-02-15 16:43:06'),
(328, 'Erreur', 0, 'Une erreur est survenue lors de consultation sector?page=1&pagesize=10&search=&paginate=true.', 'ERREUR', 0, NULL, NULL, NULL, NULL, '2026-02-15 16:44:41', '2026-02-15 16:44:41'),
(329, 'Opération réussie', 0, 'Consultation 1 effectuée avec succès.', 'SUCCESS', 0, NULL, NULL, NULL, NULL, '2026-02-15 16:45:08', '2026-02-15 16:45:08'),
(330, 'Erreur', 0, 'Une erreur est survenue lors de consultation sector?page=1&pagesize=10&search=&paginate=true.', 'ERREUR', 0, NULL, NULL, NULL, NULL, '2026-02-15 16:45:48', '2026-02-15 16:45:48'),
(331, 'Opération réussie', 0, 'Consultation 1 effectuée avec succès.', 'SUCCESS', 0, NULL, NULL, NULL, NULL, '2026-02-15 16:48:21', '2026-02-15 16:48:21'),
(332, 'Erreur', 0, 'Une erreur est survenue lors de consultation sector?page=1&pagesize=10&search=&paginate=true.', 'ERREUR', 0, NULL, NULL, NULL, NULL, '2026-02-15 16:48:58', '2026-02-15 16:48:58'),
(333, 'Opération réussie', 0, 'Consultation product?page=1&pageSize=10&search=&paginate=true&companyId=13 effectuée avec succès.', 'SUCCESS', 0, NULL, NULL, NULL, NULL, '2026-02-15 16:50:33', '2026-02-15 16:50:33'),
(334, 'Opération réussie', 0, 'Consultation product?page=1&pageSize=10&search=&paginate=true&companyId=14 effectuée avec succès.', 'SUCCESS', 0, NULL, NULL, NULL, NULL, '2026-02-15 16:51:22', '2026-02-15 16:51:22'),
(335, 'Erreur', 0, 'Une erreur est survenue lors de consultation product?page=1&pagesize=10&search=&paginate=true&companyid=8.', 'ERREUR', 0, NULL, NULL, NULL, NULL, '2026-02-15 16:51:55', '2026-02-15 16:51:55'),
(336, 'Erreur', 0, 'Une erreur est survenue lors de consultation product?page=1&pagesize=10&search=&paginate=true&companyid=14.', 'ERREUR', 0, NULL, NULL, NULL, NULL, '2026-02-15 16:52:33', '2026-02-15 16:52:33'),
(337, 'Opération réussie', 0, 'Consultation product?page=1&pageSize=10&search=J&paginate=true&companyId=13 effectuée avec succès.', 'SUCCESS', 0, NULL, NULL, NULL, NULL, '2026-02-15 16:52:38', '2026-02-15 16:52:38'),
(338, 'Opération réussie', 0, 'Consultation product?page=1&pageSize=10&search=Jj&paginate=true&companyId=13 effectuée avec succès.', 'SUCCESS', 0, NULL, NULL, NULL, NULL, '2026-02-15 16:52:38', '2026-02-15 16:52:38'),
(339, 'Opération réussie', 0, 'Consultation notification_track?userId=1&search=&page=1&pageSize=20 effectuée avec succès.', 'SUCCESS', 0, NULL, NULL, NULL, NULL, '2026-02-15 16:52:53', '2026-02-15 16:52:53'),
(340, 'Paiement réussi ✅', 0, 'Votre paiement de 80$ pour la commande ORD-1771174416878 a été effectué avec succès.', 'SUCCESS', 0, NULL, NULL, NULL, NULL, '2026-02-15 16:53:36', '2026-02-15 16:53:36'),
(341, 'Commande payée 🛒', 0, 'Une nouvelle commande ORD-1771174416878 a été payée.', 'INFO', 0, NULL, NULL, NULL, NULL, '2026-02-15 16:53:36', '2026-02-15 16:53:36'),
(342, 'Opération réussie', 0, 'Création paiement effectuée avec succès.', 'SUCCESS', 0, NULL, NULL, NULL, NULL, '2026-02-15 16:53:39', '2026-02-15 16:53:39'),
(343, 'Opération réussie', 0, 'Consultation 1 effectuée avec succès.', 'SUCCESS', 0, NULL, NULL, NULL, NULL, '2026-02-15 16:53:42', '2026-02-15 16:53:42'),
(344, 'Erreur', 0, 'Une erreur est survenue lors de consultation product?page=1&pagesize=10&search=&paginate=true&companyid=8.', 'ERREUR', 0, NULL, NULL, NULL, NULL, '2026-02-15 16:54:53', '2026-02-15 16:54:53'),
(345, 'Erreur', 0, 'Une erreur est survenue lors de consultation 1.', 'ERREUR', 0, NULL, NULL, NULL, NULL, '2026-02-15 16:56:01', '2026-02-15 16:56:01'),
(346, 'Erreur', 0, 'Une erreur est survenue lors de consultation sector?page=1&pagesize=10&search=&paginate=true.', 'ERREUR', 0, NULL, NULL, NULL, NULL, '2026-02-15 16:56:28', '2026-02-15 16:56:28'),
(347, 'Erreur', 0, 'Une erreur est survenue lors de consultation product?page=1&pagesize=10&search=&paginate=true&companyid=8.', 'ERREUR', 0, NULL, NULL, NULL, NULL, '2026-02-15 16:56:31', '2026-02-15 16:56:31'),
(348, 'Opération réussie', 0, 'Consultation 1 effectuée avec succès.', 'SUCCESS', 0, NULL, NULL, NULL, NULL, '2026-02-15 16:56:58', '2026-02-15 16:56:58'),
(349, 'Erreur', 0, 'Une erreur est survenue lors de consultation sector?page=1&pagesize=10&search=&paginate=true.', 'ERREUR', 0, NULL, NULL, NULL, NULL, '2026-02-15 16:57:27', '2026-02-15 16:57:27'),
(350, 'Opération réussie', 0, 'Consultation product?page=1&pageSize=10&search=&paginate=true&companyId=11 effectuée avec succès.', 'SUCCESS', 0, NULL, NULL, NULL, NULL, '2026-02-15 16:57:31', '2026-02-15 16:57:31'),
(351, 'Erreur', 0, 'Une erreur est survenue lors de consultation product?page=1&pagesize=10&search=&paginate=true&companyid=13.', 'ERREUR', 0, NULL, NULL, NULL, NULL, '2026-02-15 16:57:50', '2026-02-15 16:57:50'),
(352, 'Erreur', 0, 'Une erreur est survenue lors de consultation sector?page=2&pagesize=10&search=&paginate=true.', 'ERREUR', 0, NULL, NULL, NULL, NULL, '2026-02-15 16:58:23', '2026-02-15 16:58:23'),
(353, 'Opération réussie', 0, 'Consultation 1 effectuée avec succès.', 'SUCCESS', 0, NULL, NULL, NULL, NULL, '2026-02-15 17:00:26', '2026-02-15 17:00:26'),
(354, 'Erreur', 0, 'Une erreur est survenue lors de consultation 1.', 'ERREUR', 0, NULL, NULL, NULL, NULL, '2026-02-15 17:00:35', '2026-02-15 17:00:35'),
(355, 'Erreur', 0, 'Une erreur est survenue lors de consultation sector?page=1&pagesize=10&search=&paginate=true.', 'ERREUR', 0, NULL, NULL, NULL, NULL, '2026-02-15 17:01:18', '2026-02-15 17:01:18'),
(356, 'Erreur', 0, 'Une erreur est survenue lors de consultation product?page=1&pagesize=10&search=&paginate=true&companyid=8.', 'ERREUR', 0, NULL, NULL, NULL, NULL, '2026-02-15 17:01:21', '2026-02-15 17:01:21'),
(357, 'Erreur', 0, 'Une erreur est survenue lors de consultation product?page=1&pagesize=10&search=&paginate=true&companyid=11.', 'ERREUR', 0, NULL, NULL, NULL, NULL, '2026-02-15 17:01:31', '2026-02-15 17:01:31'),
(358, 'Opération réussie', 0, 'Consultation product?page=1&pageSize=10&search=&paginate=true&companyId=9 effectuée avec succès.', 'SUCCESS', 0, NULL, NULL, NULL, NULL, '2026-02-15 17:01:38', '2026-02-15 17:01:38'),
(359, 'Opération réussie', 0, 'Consultation product?page=1&pageSize=10&search=&paginate=true&companyId=10 effectuée avec succès.', 'SUCCESS', 0, NULL, NULL, NULL, NULL, '2026-02-15 17:02:00', '2026-02-15 17:02:00'),
(360, 'Erreur', 0, 'Une erreur est survenue lors de consultation sector?page=2&pagesize=10&search=&paginate=true.', 'ERREUR', 0, NULL, NULL, NULL, NULL, '2026-02-15 17:03:12', '2026-02-15 17:03:12'),
(361, 'Erreur', 0, 'Une erreur est survenue lors de consultation sector?page=1&pagesize=10&search=&paginate=true.', 'ERREUR', 0, NULL, NULL, NULL, NULL, '2026-02-15 17:07:05', '2026-02-15 17:07:05'),
(362, 'Opération réussie', 0, 'Consultation sector?page=1&pageSize=10&search=&paginate=false effectuée avec succès.', 'SUCCESS', 0, NULL, NULL, NULL, NULL, '2026-02-15 17:08:59', '2026-02-15 17:08:59'),
(363, 'Opération réussie', 0, 'Consultation sector?page=1&pageSize=20&search=&paginate=false effectuée avec succès.', 'SUCCESS', 0, NULL, NULL, NULL, NULL, '2026-02-15 17:11:55', '2026-02-15 17:11:55'),
(364, 'Opération réussie', 0, 'Consultation 1 effectuée avec succès.', 'SUCCESS', 0, NULL, NULL, NULL, NULL, '2026-02-15 17:16:20', '2026-02-15 17:16:20'),
(365, 'Erreur', 0, 'Une erreur est survenue lors de consultation product?page=1&pagesize=10&search=&paginate=true&companyid=9.', 'ERREUR', 0, NULL, NULL, NULL, NULL, '2026-02-15 17:17:04', '2026-02-15 17:17:04'),
(366, 'Erreur', 0, 'Une erreur est survenue lors de consultation product?page=1&pagesize=10&search=&paginate=true&companyid=10.', 'ERREUR', 0, NULL, NULL, NULL, NULL, '2026-02-15 17:17:18', '2026-02-15 17:17:18'),
(367, 'Opération réussie', 0, 'Consultation notification_track?userId=1&search=&page=1&pageSize=20 effectuée avec succès.', 'SUCCESS', 0, NULL, NULL, NULL, NULL, '2026-02-15 17:17:23', '2026-02-15 17:17:23'),
(368, 'Erreur', 0, 'Une erreur est survenue lors de consultation sector?page=2&pagesize=10&search=&paginate=true.', 'ERREUR', 0, NULL, NULL, NULL, NULL, '2026-02-15 17:17:32', '2026-02-15 17:17:32'),
(369, 'Opération réussie', 0, 'Consultation notification_track?userId=1&search=&page=1&pageSize=20 effectuée avec succès.', 'SUCCESS', 0, NULL, NULL, NULL, NULL, '2026-02-15 17:18:48', '2026-02-15 17:18:48'),
(370, 'Opération réussie', 0, 'Consultation notification_track?userId=1&search=&page=1&pageSize=20 effectuée avec succès.', 'SUCCESS', 0, NULL, NULL, NULL, NULL, '2026-02-15 17:20:25', '2026-02-15 17:20:25'),
(371, 'Erreur', 0, 'Une erreur est survenue lors de consultation product?page=1&pagesize=10&search=&paginate=true&companyid=8.', 'ERREUR', 0, NULL, NULL, NULL, NULL, '2026-02-15 17:22:20', '2026-02-15 17:22:20'),
(372, 'Erreur', 0, 'Une erreur est survenue lors de consultation 1.', 'ERREUR', 0, NULL, NULL, NULL, NULL, '2026-02-15 17:22:27', '2026-02-15 17:22:27'),
(373, 'Erreur', 0, 'Une erreur est survenue lors de consultation 1.', 'ERREUR', 0, NULL, NULL, NULL, NULL, '2026-02-15 17:25:43', '2026-02-15 17:25:43'),
(374, 'Erreur', 0, 'Une erreur est survenue lors de consultation 1.', 'ERREUR', 0, NULL, NULL, NULL, NULL, '2026-02-15 17:26:36', '2026-02-15 17:26:36'),
(375, 'Erreur', 0, 'Une erreur est survenue lors de consultation 1.', 'ERREUR', 0, NULL, NULL, NULL, NULL, '2026-02-15 17:27:51', '2026-02-15 17:27:51'),
(376, 'Erreur', 0, 'Une erreur est survenue lors de consultation 1.', 'ERREUR', 0, NULL, NULL, NULL, NULL, '2026-02-15 17:29:02', '2026-02-15 17:29:02'),
(377, 'Erreur', 0, 'Une erreur est survenue lors de consultation 1.', 'ERREUR', 0, NULL, NULL, NULL, NULL, '2026-02-15 17:29:46', '2026-02-15 17:29:46'),
(378, 'Opération réussie', 0, 'Consultation notification_track?userId=1&search=&page=1&pageSize=20 effectuée avec succès.', 'SUCCESS', 0, NULL, NULL, NULL, NULL, '2026-02-15 17:29:50', '2026-02-15 17:29:50'),
(379, 'Opération réussie', 0, 'Consultation users?search=&page=1&pageSize=20&paginate=true effectuée avec succès.', 'SUCCESS', 0, NULL, NULL, NULL, NULL, '2026-02-15 17:29:57', '2026-02-15 17:29:57'),
(380, 'Erreur', 0, 'Une erreur est survenue lors de consultation product?page=1&pagesize=10&search=&paginate=true&companyid=8.', 'ERREUR', 0, NULL, NULL, NULL, NULL, '2026-02-15 17:30:09', '2026-02-15 17:30:09'),
(381, 'Erreur', 0, 'Une erreur est survenue lors de création paiement.', 'ERREUR', 0, NULL, NULL, NULL, NULL, '2026-02-15 17:30:20', '2026-02-15 17:30:20'),
(382, 'Erreur', 0, 'Une erreur est survenue lors de consultation product?page=1&pagesize=10&search=&paginate=true&companyid=11.', 'ERREUR', 0, NULL, NULL, NULL, NULL, '2026-02-15 17:30:31', '2026-02-15 17:30:31'),
(383, 'Opération réussie', 0, 'Consultation product?page=1&pageSize=10&search=&paginate=true&companyId=12 effectuée avec succès.', 'SUCCESS', 0, NULL, NULL, NULL, NULL, '2026-02-15 17:30:37', '2026-02-15 17:30:37'),
(384, 'Erreur', 0, 'Une erreur est survenue lors de consultation product?page=1&pagesize=10&search=&paginate=true&companyid=9.', 'ERREUR', 0, NULL, NULL, NULL, NULL, '2026-02-15 17:30:42', '2026-02-15 17:30:42'),
(385, 'Erreur', 0, 'Une erreur est survenue lors de consultation product?page=1&pagesize=10&search=&paginate=true&companyid=8.', 'ERREUR', 0, NULL, NULL, NULL, NULL, '2026-02-15 17:34:25', '2026-02-15 17:34:25'),
(386, 'Opération réussie', 0, 'Consultation notification_track?userId=1&search=&page=1&pageSize=20 effectuée avec succès.', 'SUCCESS', 0, NULL, NULL, NULL, NULL, '2026-02-15 17:34:31', '2026-02-15 17:34:31'),
(387, 'Erreur', 0, 'Une erreur est survenue lors de consultation sector?page=1&pagesize=20&search=&paginate=false.', 'ERREUR', 0, NULL, NULL, NULL, NULL, '2026-02-15 17:54:24', '2026-02-15 17:54:24'),
(388, 'Erreur', 0, 'Une erreur est survenue lors de consultation 1.', 'ERREUR', 0, NULL, NULL, NULL, NULL, '2026-02-15 17:54:24', '2026-02-15 17:54:24'),
(389, 'Opération réussie', 0, 'Consultation 4 effectuée avec succès.', 'SUCCESS', 0, NULL, NULL, NULL, NULL, '2026-02-15 17:56:33', '2026-02-15 17:56:33'),
(390, 'Opération réussie', 0, 'Création createrecharge effectuée avec succès.', 'SUCCESS', 0, NULL, NULL, NULL, NULL, '2026-02-15 17:57:43', '2026-02-15 17:57:43'),
(391, 'Recharge réussie ✅', 0, 'Votre compte a été crédité de 1000 avec succès. Merci d’avoir utilisé notre service.', 'SUCCESS', 0, NULL, NULL, NULL, NULL, '2026-02-15 17:57:43', '2026-02-15 17:57:43'),
(392, 'Opération réussie', 0, 'Création recharge effectuée avec succès.', 'SUCCESS', 0, NULL, NULL, NULL, NULL, '2026-02-15 17:57:43', '2026-02-15 17:57:43'),
(393, 'Opération réussie', 0, 'Consultation 4 effectuée avec succès.', 'SUCCESS', 0, NULL, NULL, NULL, NULL, '2026-02-15 17:57:55', '2026-02-15 17:57:55'),
(394, 'Opération réussie', 0, 'Mise à jour profile effectuée avec succès.', 'SUCCESS', 0, NULL, NULL, NULL, NULL, '2026-02-15 17:58:20', '2026-02-15 17:58:20'),
(395, 'Opération réussie', 0, 'Consultation 4 effectuée avec succès.', 'SUCCESS', 0, NULL, NULL, NULL, NULL, '2026-02-15 17:58:20', '2026-02-15 17:58:20'),
(396, 'Opération réussie', 0, 'Création create effectuée avec succès.', 'SUCCESS', 0, NULL, NULL, NULL, NULL, '2026-02-15 17:58:20', '2026-02-15 17:58:20'),
(397, 'Profil mis à jour', 0, 'Votre profil a été mis à jour avec succès depuis l\'application.', 'SUCCESS', 0, NULL, 4, NULL, NULL, '2026-02-15 17:58:20', '2026-02-15 17:58:20'),
(398, 'Opération réussie', 0, 'Création create effectuée avec succès.', 'SUCCESS', 0, NULL, NULL, NULL, NULL, '2026-02-15 17:58:20', '2026-02-15 17:58:20'),
(399, 'Opération réussie', 0, 'Consultation notification_track?userId=4&search=&page=1&pageSize=20 effectuée avec succès.', 'SUCCESS', 0, NULL, NULL, NULL, NULL, '2026-02-15 17:58:30', '2026-02-15 17:58:30'),
(400, 'Opération réussie', 0, 'Consultation 2 effectuée avec succès.', 'SUCCESS', 0, NULL, NULL, NULL, NULL, '2026-02-15 17:59:55', '2026-02-15 17:59:55'),
(401, 'Erreur', 0, 'Une erreur est survenue lors de consultation 2.', 'ERREUR', 0, NULL, NULL, NULL, NULL, '2026-02-15 18:00:01', '2026-02-15 18:00:01'),
(402, 'Opération réussie', 0, 'Consultation notification_track?userId=2&search=&page=1&pageSize=20 effectuée avec succès.', 'SUCCESS', 0, NULL, NULL, NULL, NULL, '2026-02-15 18:00:06', '2026-02-15 18:00:06'),
(403, 'Opération réussie', 0, 'Consultation sector?page=1&pageSize=20&search=&paginate=false effectuée avec succès.', 'SUCCESS', 0, NULL, NULL, NULL, NULL, '2026-02-15 18:04:39', '2026-02-15 18:04:39'),
(404, 'Opération réussie', 0, 'Consultation 1 effectuée avec succès.', 'SUCCESS', 0, NULL, NULL, NULL, NULL, '2026-02-15 18:04:39', '2026-02-15 18:04:39'),
(405, 'Erreur', 0, 'Une erreur est survenue lors de consultation 1.', 'ERREUR', 0, NULL, NULL, NULL, NULL, '2026-02-15 18:04:42', '2026-02-15 18:04:42'),
(406, 'Opération réussie', 0, 'Consultation users?search=&page=1&pageSize=20&paginate=true effectuée avec succès.', 'SUCCESS', 0, NULL, NULL, NULL, NULL, '2026-02-15 18:05:08', '2026-02-15 18:05:08'),
(407, 'Opération réussie', 0, 'Consultation users?search=Leader+Mushio&page=1&pageSize=20&paginate=true effectuée avec succès.', 'SUCCESS', 0, NULL, NULL, NULL, NULL, '2026-02-15 18:05:10', '2026-02-15 18:05:10'),
(408, 'Opération réussie', 0, 'Consultation users?search=Malo&page=1&pageSize=20&paginate=true effectuée avec succès.', 'SUCCESS', 0, NULL, NULL, NULL, NULL, '2026-02-15 18:05:16', '2026-02-15 18:05:16'),
(409, 'Transfert réussi ✅', 0, 'Vous avez envoyé 20$ (frais: 0.5$).', 'SUCCESS', 0, NULL, NULL, NULL, NULL, '2026-02-15 18:05:22', '2026-02-15 18:05:22'),
(410, 'Fonds reçus ✅', 0, 'Vous avez reçu 20$ de Leader Mushio.', 'SUCCESS', 0, NULL, NULL, NULL, NULL, '2026-02-15 18:05:22', '2026-02-15 18:05:22'),
(411, 'Opération réussie', 0, 'Création transfert effectuée avec succès.', 'SUCCESS', 0, NULL, NULL, NULL, NULL, '2026-02-15 18:05:22', '2026-02-15 18:05:22'),
(412, 'Opération réussie', 0, 'Consultation 1 effectuée avec succès.', 'SUCCESS', 0, NULL, NULL, NULL, NULL, '2026-02-15 18:05:29', '2026-02-15 18:05:29'),
(413, 'Opération réussie', 0, 'Consultation 2 effectuée avec succès.', 'SUCCESS', 0, NULL, NULL, NULL, NULL, '2026-02-15 18:06:17', '2026-02-15 18:06:17'),
(414, 'Erreur', 0, 'Une erreur est survenue lors de consultation 2.', 'ERREUR', 0, NULL, NULL, NULL, NULL, '2026-02-15 18:06:21', '2026-02-15 18:06:21'),
(415, 'Opération réussie', 0, 'Création createrecharge effectuée avec succès.', 'SUCCESS', 0, NULL, NULL, NULL, NULL, '2026-02-15 18:07:21', '2026-02-15 18:07:21'),
(416, 'Recharge réussie ✅', 0, 'Votre compte a été crédité de 10 avec succès. Merci d’avoir utilisé notre service.', 'SUCCESS', 0, NULL, NULL, NULL, NULL, '2026-02-15 18:07:21', '2026-02-15 18:07:21'),
(417, 'Opération réussie', 0, 'Création recharge effectuée avec succès.', 'SUCCESS', 0, NULL, NULL, NULL, NULL, '2026-02-15 18:07:21', '2026-02-15 18:07:21'),
(418, 'Opération réussie', 0, 'Consultation 2 effectuée avec succès.', 'SUCCESS', 0, NULL, NULL, NULL, NULL, '2026-02-15 18:07:25', '2026-02-15 18:07:25'),
(419, 'Opération réussie', 0, 'Consultation 1 effectuée avec succès.', 'SUCCESS', 0, NULL, NULL, NULL, NULL, '2026-02-15 18:08:25', '2026-02-15 18:08:25'),
(420, 'Erreur', 0, 'Une erreur est survenue lors de consultation 1.', 'ERREUR', 0, NULL, NULL, NULL, NULL, '2026-02-15 18:08:29', '2026-02-15 18:08:29'),
(421, 'Erreur', 0, 'Une erreur est survenue lors de création retrait.', 'ERREUR', 0, NULL, NULL, NULL, NULL, '2026-02-15 18:08:41', '2026-02-15 18:08:41'),
(422, 'Erreur', 0, 'Une erreur est survenue lors de création retrait.', 'ERREUR', 0, NULL, NULL, NULL, NULL, '2026-02-15 18:09:05', '2026-02-15 18:09:05'),
(423, 'Opération réussie', 0, 'Consultation 5 effectuée avec succès.', 'SUCCESS', 0, NULL, NULL, NULL, NULL, '2026-02-15 18:13:24', '2026-02-15 18:13:24'),
(424, 'Opération réussie', 0, 'Création createrecharge effectuée avec succès.', 'SUCCESS', 0, NULL, NULL, NULL, NULL, '2026-02-15 18:13:47', '2026-02-15 18:13:47'),
(425, 'Recharge réussie ✅', 0, 'Votre compte a été crédité de 1000 avec succès. Merci d’avoir utilisé notre service.', 'SUCCESS', 0, NULL, NULL, NULL, NULL, '2026-02-15 18:13:48', '2026-02-15 18:13:48'),
(426, 'Opération réussie', 0, 'Création recharge effectuée avec succès.', 'SUCCESS', 0, NULL, NULL, NULL, NULL, '2026-02-15 18:13:48', '2026-02-15 18:13:48'),
(427, 'Opération réussie', 0, 'Consultation 5 effectuée avec succès.', 'SUCCESS', 0, NULL, NULL, NULL, NULL, '2026-02-15 18:13:54', '2026-02-15 18:13:54'),
(428, 'Retrait réussi ✅', 0, 'Votre retrait de 100$ a été effectué.', 'SUCCESS', 0, NULL, NULL, NULL, NULL, '2026-02-15 18:14:16', '2026-02-15 18:14:16'),
(429, 'Nouveau retrait 💰', 0, 'Vous avez reçu un client pour 100$.', 'INFO', 0, NULL, NULL, NULL, NULL, '2026-02-15 18:14:16', '2026-02-15 18:14:16'),
(430, 'Frais retrait reçu 💰', 0, 'Frais de 2.985$ crédité.', 'INFO', 0, NULL, NULL, NULL, NULL, '2026-02-15 18:14:16', '2026-02-15 18:14:16'),
(431, 'Opération réussie', 0, 'Création retrait effectuée avec succès.', 'SUCCESS', 0, NULL, NULL, NULL, NULL, '2026-02-15 18:14:19', '2026-02-15 18:14:19'),
(432, 'Opération réussie', 0, 'Consultation 5 effectuée avec succès.', 'SUCCESS', 0, NULL, NULL, NULL, NULL, '2026-02-15 18:14:22', '2026-02-15 18:14:22'),
(433, 'Retrait réussi ✅', 0, 'Votre retrait de 50$ a été effectué.', 'SUCCESS', 0, NULL, NULL, NULL, NULL, '2026-02-15 18:15:46', '2026-02-15 18:15:46'),
(434, 'Nouveau retrait 💰', 0, 'Vous avez reçu un client pour 50$.', 'INFO', 0, NULL, NULL, NULL, NULL, '2026-02-15 18:15:46', '2026-02-15 18:15:46'),
(435, 'Frais retrait reçu 💰', 0, 'Frais de 1.4925$ crédité.', 'INFO', 0, NULL, NULL, NULL, NULL, '2026-02-15 18:15:46', '2026-02-15 18:15:46'),
(436, 'Opération réussie', 0, 'Création retrait effectuée avec succès.', 'SUCCESS', 0, NULL, NULL, NULL, NULL, '2026-02-15 18:15:49', '2026-02-15 18:15:49'),
(437, 'Opération réussie', 0, 'Consultation 5 effectuée avec succès.', 'SUCCESS', 0, NULL, NULL, NULL, NULL, '2026-02-15 18:15:52', '2026-02-15 18:15:52'),
(438, 'Retrait réussi ✅', 0, 'Votre retrait de 100$ a été effectué.', 'SUCCESS', 0, NULL, NULL, NULL, NULL, '2026-02-15 18:16:03', '2026-02-15 18:16:03'),
(439, 'Nouveau retrait 💰', 0, 'Vous avez reçu un client pour 100$.', 'INFO', 0, NULL, NULL, NULL, NULL, '2026-02-15 18:16:03', '2026-02-15 18:16:03'),
(440, 'Frais retrait reçu 💰', 0, 'Frais de 2.985$ crédité.', 'INFO', 0, NULL, NULL, NULL, NULL, '2026-02-15 18:16:03', '2026-02-15 18:16:03'),
(441, 'Opération réussie', 0, 'Création retrait effectuée avec succès.', 'SUCCESS', 0, NULL, NULL, NULL, NULL, '2026-02-15 18:16:08', '2026-02-15 18:16:08'),
(442, 'Opération réussie', 0, 'Consultation 5 effectuée avec succès.', 'SUCCESS', 0, NULL, NULL, NULL, NULL, '2026-02-15 18:16:11', '2026-02-15 18:16:11'),
(443, 'Erreur', 0, 'Une erreur est survenue lors de création retrait.', 'ERREUR', 0, NULL, NULL, NULL, NULL, '2026-02-15 18:16:21', '2026-02-15 18:16:21'),
(444, 'Opération réussie', 0, 'Consultation notification_track?userId=5&search=&page=1&pageSize=20 effectuée avec succès.', 'SUCCESS', 0, NULL, NULL, NULL, NULL, '2026-02-15 18:16:31', '2026-02-15 18:16:31'),
(445, 'Opération réussie', 0, 'Consultation users?search=&page=1&pageSize=20&paginate=true effectuée avec succès.', 'SUCCESS', 0, NULL, NULL, NULL, NULL, '2026-02-15 18:17:12', '2026-02-15 18:17:12'),
(446, 'Opération réussie', 0, 'Consultation users?search=Leader+Mushio&page=1&pageSize=20&paginate=true effectuée avec succès.', 'SUCCESS', 0, NULL, NULL, NULL, NULL, '2026-02-15 18:17:24', '2026-02-15 18:17:24'),
(447, 'Transfert réussi ✅', 0, 'Vous avez envoyé 100$ (frais: 1$).', 'SUCCESS', 0, NULL, NULL, NULL, NULL, '2026-02-15 18:17:29', '2026-02-15 18:17:29'),
(448, 'Fonds reçus ✅', 0, 'Vous avez reçu 100$ de user_4ekko.', 'SUCCESS', 0, NULL, NULL, NULL, NULL, '2026-02-15 18:17:29', '2026-02-15 18:17:29'),
(449, 'Opération réussie', 0, 'Création transfert effectuée avec succès.', 'SUCCESS', 0, NULL, NULL, NULL, NULL, '2026-02-15 18:17:29', '2026-02-15 18:17:29'),
(450, 'Opération réussie', 0, 'Consultation 5 effectuée avec succès.', 'SUCCESS', 0, NULL, NULL, NULL, NULL, '2026-02-15 18:17:32', '2026-02-15 18:17:32'),
(451, 'Opération réussie', 0, 'Consultation users?search=Malo&page=1&pageSize=20&paginate=true effectuée avec succès.', 'SUCCESS', 0, NULL, NULL, NULL, NULL, '2026-02-15 18:18:03', '2026-02-15 18:18:03'),
(452, 'Transfert réussi ✅', 0, 'Vous avez envoyé 50$ (frais: 0.5$).', 'SUCCESS', 0, NULL, NULL, NULL, NULL, '2026-02-15 18:18:07', '2026-02-15 18:18:07'),
(453, 'Fonds reçus ✅', 0, 'Vous avez reçu 50$ de user_4ekko.', 'SUCCESS', 0, NULL, NULL, NULL, NULL, '2026-02-15 18:18:07', '2026-02-15 18:18:07'),
(454, 'Opération réussie', 0, 'Création transfert effectuée avec succès.', 'SUCCESS', 0, NULL, NULL, NULL, NULL, '2026-02-15 18:18:07', '2026-02-15 18:18:07'),
(455, 'Opération réussie', 0, 'Consultation 5 effectuée avec succès.', 'SUCCESS', 0, NULL, NULL, NULL, NULL, '2026-02-15 18:18:10', '2026-02-15 18:18:10'),
(456, 'Erreur', 0, 'Une erreur est survenue lors de consultation sector?page=1&pagesize=10&search=&paginate=true.', 'ERREUR', 0, NULL, NULL, NULL, NULL, '2026-02-15 18:19:02', '2026-02-15 18:19:02'),
(457, 'Erreur', 0, 'Une erreur est survenue lors de consultation product?page=1&pagesize=10&search=&paginate=true&companyid=8.', 'ERREUR', 0, NULL, NULL, NULL, NULL, '2026-02-15 18:19:11', '2026-02-15 18:19:11'),
(458, 'Paiement réussi ✅', 0, 'Votre paiement de 100$ pour la commande ORD-1771179602282 a été effectué avec succès.', 'SUCCESS', 0, NULL, NULL, NULL, NULL, '2026-02-15 18:20:02', '2026-02-15 18:20:02'),
(459, 'Commande payée 🛒', 0, 'Une nouvelle commande ORD-1771179602282 a été payée.', 'INFO', 0, NULL, NULL, NULL, NULL, '2026-02-15 18:20:02', '2026-02-15 18:20:02'),
(460, 'Opération réussie', 0, 'Création paiement effectuée avec succès.', 'SUCCESS', 0, NULL, NULL, NULL, NULL, '2026-02-15 18:20:06', '2026-02-15 18:20:06'),
(461, 'Opération réussie', 0, 'Consultation 5 effectuée avec succès.', 'SUCCESS', 0, NULL, NULL, NULL, NULL, '2026-02-15 18:20:11', '2026-02-15 18:20:11'),
(462, 'Opération réussie', 0, 'Consultation product?page=1&pageSize=10&search=&paginate=true&companyId=13 effectuée avec succès.', 'SUCCESS', 0, NULL, NULL, NULL, NULL, '2026-02-15 18:22:13', '2026-02-15 18:22:13'),
(463, 'Paiement réussi ✅', 0, 'Votre paiement de 80$ pour la commande ORD-1771179749270 a été effectué avec succès.', 'SUCCESS', 0, NULL, NULL, NULL, NULL, '2026-02-15 18:22:29', '2026-02-15 18:22:29'),
(464, 'Commande payée 🛒', 0, 'Une nouvelle commande ORD-1771179749270 a été payée.', 'INFO', 0, NULL, NULL, NULL, NULL, '2026-02-15 18:22:29', '2026-02-15 18:22:29'),
(465, 'Opération réussie', 0, 'Création paiement effectuée avec succès.', 'SUCCESS', 0, NULL, NULL, NULL, NULL, '2026-02-15 18:22:33', '2026-02-15 18:22:33'),
(466, 'Opération réussie', 0, 'Consultation 5 effectuée avec succès.', 'SUCCESS', 0, NULL, NULL, NULL, NULL, '2026-02-15 18:22:41', '2026-02-15 18:22:41'),
(467, 'Opération réussie', 0, 'Consultation notification_track?userId=5&search=&page=1&pageSize=20 effectuée avec succès.', 'SUCCESS', 0, NULL, NULL, NULL, NULL, '2026-02-15 18:22:50', '2026-02-15 18:22:50'),
(468, 'Erreur', 0, 'Une erreur est survenue lors de consultation 5.', 'ERREUR', 0, NULL, NULL, NULL, NULL, '2026-02-15 18:23:12', '2026-02-15 18:23:12'),
(469, 'Erreur', 0, 'Une erreur est survenue lors de consultation product?page=1&pagesize=10&search=&paginate=true&companyid=12.', 'ERREUR', 0, NULL, NULL, NULL, NULL, '2026-02-15 18:23:41', '2026-02-15 18:23:41'),
(470, 'Erreur', 0, 'Une erreur est survenue lors de consultation product?page=1&pagesize=10&search=&paginate=true&companyid=11.', 'ERREUR', 0, NULL, NULL, NULL, NULL, '2026-02-15 18:23:51', '2026-02-15 18:23:51'),
(471, 'Erreur', 0, 'Une erreur est survenue lors de consultation product?page=1&pagesize=10&search=&paginate=true&companyid=9.', 'ERREUR', 0, NULL, NULL, NULL, NULL, '2026-02-15 18:24:26', '2026-02-15 18:24:26'),
(472, 'Paiement réussi ✅', 0, 'Votre paiement de 30$ pour la commande ORD-1771179901635 a été effectué avec succès.', 'SUCCESS', 0, NULL, NULL, NULL, NULL, '2026-02-15 18:25:01', '2026-02-15 18:25:01'),
(473, 'Commande payée 🛒', 0, 'Une nouvelle commande ORD-1771179901635 a été payée.', 'INFO', 0, NULL, NULL, NULL, NULL, '2026-02-15 18:25:01', '2026-02-15 18:25:01'),
(474, 'Opération réussie', 0, 'Création paiement effectuée avec succès.', 'SUCCESS', 0, NULL, NULL, NULL, NULL, '2026-02-15 18:25:06', '2026-02-15 18:25:06'),
(475, 'Opération réussie', 0, 'Consultation 5 effectuée avec succès.', 'SUCCESS', 0, NULL, NULL, NULL, NULL, '2026-02-15 18:25:13', '2026-02-15 18:25:13'),
(476, 'Opération réussie', 0, 'Consultation 5 effectuée avec succès.', 'SUCCESS', 0, NULL, NULL, NULL, NULL, '2026-02-16 18:33:33', '2026-02-16 18:33:33'),
(477, 'Opération réussie', 0, 'Consultation 1 effectuée avec succès.', 'SUCCESS', 0, NULL, NULL, NULL, NULL, '2026-02-16 18:34:01', '2026-02-16 18:34:01'),
(478, 'Erreur', 0, 'Une erreur est survenue lors de consultation 1.', 'ERREUR', 0, NULL, NULL, NULL, NULL, '2026-02-16 18:34:09', '2026-02-16 18:34:09'),
(479, 'Erreur', 0, 'Une erreur est survenue lors de consultation sector?page=1&pagesize=10&search=&paginate=true.', 'ERREUR', 0, NULL, NULL, NULL, NULL, '2026-02-16 18:34:21', '2026-02-16 18:34:21'),
(480, 'Erreur', 0, 'Une erreur est survenue lors de consultation 1.', 'ERREUR', 0, NULL, NULL, NULL, NULL, '2026-02-16 18:34:24', '2026-02-16 18:34:24'),
(481, 'Opération réussie', 0, 'Consultation sector?page=1&pageSize=20&search=&paginate=false effectuée avec succès.', 'SUCCESS', 0, NULL, NULL, NULL, NULL, '2026-02-16 18:34:38', '2026-02-16 18:34:38'),
(482, 'Erreur', 0, 'Une erreur est survenue lors de consultation 1.', 'ERREUR', 0, NULL, NULL, NULL, NULL, '2026-02-16 18:34:38', '2026-02-16 18:34:38'),
(483, 'Erreur', 0, 'Une erreur est survenue lors de consultation product?page=1&pagesize=10&search=&paginate=true&companyid=11.', 'ERREUR', 0, NULL, NULL, NULL, NULL, '2026-02-16 18:35:23', '2026-02-16 18:35:23'),
(484, 'Erreur', 0, 'Une erreur est survenue lors de consultation product?page=1&pagesize=10&search=&paginate=true&companyid=12.', 'ERREUR', 0, NULL, NULL, NULL, NULL, '2026-02-16 18:35:25', '2026-02-16 18:35:25'),
(485, 'Erreur', 0, 'Une erreur est survenue lors de consultation sector?page=1&pagesize=10&search=&paginate=true.', 'ERREUR', 0, NULL, NULL, NULL, NULL, '2026-02-16 18:35:41', '2026-02-16 18:35:41'),
(486, 'Erreur', 0, 'Une erreur est survenue lors de consultation sector?page=2&pagesize=10&search=&paginate=true.', 'ERREUR', 0, NULL, NULL, NULL, NULL, '2026-02-16 18:36:14', '2026-02-16 18:36:14'),
(487, 'Opération réussie', 0, 'Consultation notification_track?userId=1&search=&page=1&pageSize=20 effectuée avec succès.', 'SUCCESS', 0, NULL, NULL, NULL, NULL, '2026-02-16 18:38:40', '2026-02-16 18:38:40'),
(488, 'Opération réussie', 0, 'Consultation company effectuée avec succès.', 'SUCCESS', 0, NULL, NULL, NULL, NULL, '2026-02-16 18:54:18', '2026-02-16 18:54:18'),
(489, 'Opération réussie', 0, 'Consultation tsx effectuée avec succès.', 'SUCCESS', 0, NULL, NULL, NULL, NULL, '2026-02-16 18:54:36', '2026-02-16 18:54:36'),
(490, 'Erreur', 0, 'Une erreur est survenue lors de consultation tsx.', 'ERREUR', 0, NULL, NULL, NULL, NULL, '2026-02-16 19:00:42', '2026-02-16 19:00:42'),
(491, 'Opération réussie', 0, 'Consultation tsx effectuée avec succès.', 'SUCCESS', 0, NULL, NULL, NULL, NULL, '2026-02-16 19:03:57', '2026-02-16 19:03:57'),
(492, 'Opération réussie', 0, 'Consultation 1 effectuée avec succès.', 'SUCCESS', 0, NULL, NULL, NULL, NULL, '2026-02-16 19:05:41', '2026-02-16 19:05:41'),
(493, 'Erreur', 0, 'Une erreur est survenue lors de consultation 1.', 'ERREUR', 0, NULL, NULL, NULL, NULL, '2026-02-16 19:08:57', '2026-02-16 19:08:57'),
(494, 'Erreur', 0, 'Une erreur est survenue lors de consultation 1.', 'ERREUR', 0, NULL, NULL, NULL, NULL, '2026-02-16 19:09:01', '2026-02-16 19:09:01'),
(495, 'Erreur', 0, 'Une erreur est survenue lors de consultation 1.', 'ERREUR', 0, NULL, NULL, NULL, NULL, '2026-02-16 19:09:02', '2026-02-16 19:09:02'),
(496, 'Opération réussie', 0, 'Consultation tsx?id=1 effectuée avec succès.', 'SUCCESS', 0, NULL, NULL, NULL, NULL, '2026-02-16 19:11:08', '2026-02-16 19:11:08'),
(497, 'Erreur', 0, 'Une erreur est survenue lors de consultation sector?page=1&pagesize=20&search=&paginate=false.', 'ERREUR', 0, NULL, NULL, NULL, NULL, '2026-02-16 19:14:51', '2026-02-16 19:14:51'),
(498, 'Erreur', 0, 'Une erreur est survenue lors de consultation 1.', 'ERREUR', 0, NULL, NULL, NULL, NULL, '2026-02-16 19:14:51', '2026-02-16 19:14:51'),
(499, 'Opération réussie', 0, 'Consultation tsx?id=1 effectuée avec succès.', 'SUCCESS', 0, NULL, NULL, NULL, NULL, '2026-02-16 19:14:54', '2026-02-16 19:14:54'),
(500, 'Erreur', 0, 'Une erreur est survenue lors de consultation tsx?id=1.', 'ERREUR', 0, NULL, NULL, NULL, NULL, '2026-02-16 19:15:04', '2026-02-16 19:15:04'),
(501, 'Opération réussie', 0, 'Consultation notification_track?userId=1&search=&page=1&pageSize=20 effectuée avec succès.', 'SUCCESS', 0, NULL, NULL, NULL, NULL, '2026-02-16 19:16:26', '2026-02-16 19:16:26'),
(502, 'Opération réussie', 0, 'Consultation tsx effectuée avec succès.', 'SUCCESS', 0, NULL, NULL, NULL, NULL, '2026-02-16 19:17:19', '2026-02-16 19:17:19'),
(503, 'Erreur', 0, 'Une erreur est survenue lors de consultation tsx?id=1.', 'ERREUR', 0, NULL, NULL, NULL, NULL, '2026-02-16 19:32:17', '2026-02-16 19:32:17'),
(504, 'Erreur', 0, 'Une erreur est survenue lors de consultation tsx?id=1.', 'ERREUR', 0, NULL, NULL, NULL, NULL, '2026-02-16 19:32:54', '2026-02-16 19:32:54'),
(505, 'Erreur', 0, 'Une erreur est survenue lors de consultation sector?page=1&pagesize=10&search=&paginate=true.', 'ERREUR', 0, NULL, NULL, NULL, NULL, '2026-02-16 19:33:42', '2026-02-16 19:33:42'),
(506, 'Opération réussie', 0, 'Consultation tsx?id=1&page=1&pageSize=10&paginate=true effectuée avec succès.', 'SUCCESS', 0, NULL, NULL, NULL, NULL, '2026-02-16 19:34:57', '2026-02-16 19:34:57'),
(507, 'Erreur', 0, 'Une erreur est survenue lors de consultation sector?page=2&pagesize=10&search=&paginate=true.', 'ERREUR', 0, NULL, NULL, NULL, NULL, '2026-02-16 19:39:33', '2026-02-16 19:39:33'),
(508, 'Opération réussie', 0, 'Consultation tsx?page=1&pageSize=1000&paginate=true effectuée avec succès.', 'SUCCESS', 0, NULL, NULL, NULL, NULL, '2026-02-16 19:42:30', '2026-02-16 19:42:30'),
(509, 'Erreur', 0, 'Une erreur est survenue lors de consultation sector?page=1&pagesize=10&search=&paginate=true.', 'ERREUR', 0, NULL, NULL, NULL, NULL, '2026-02-16 19:57:53', '2026-02-16 19:57:53'),
(510, 'Erreur', 0, 'Une erreur est survenue lors de consultation tsx?id=1&page=1&pagesize=10&paginate=true.', 'ERREUR', 0, NULL, NULL, NULL, NULL, '2026-02-16 19:57:56', '2026-02-16 19:57:56'),
(511, 'Erreur', 0, 'Une erreur est survenue lors de consultation 1.', 'ERREUR', 0, NULL, NULL, NULL, NULL, '2026-02-16 19:58:31', '2026-02-16 19:58:31'),
(512, 'Erreur', 0, 'Une erreur est survenue lors de consultation tsx?page=1&pagesize=1000&paginate=true.', 'ERREUR', 0, NULL, NULL, NULL, NULL, '2026-02-16 20:06:47', '2026-02-16 20:06:47'),
(513, 'Erreur', 0, 'Une erreur est survenue lors de consultation tsx?page=1&pagesize=1000&paginate=true.', 'ERREUR', 0, NULL, NULL, NULL, NULL, '2026-02-16 20:06:48', '2026-02-16 20:06:48'),
(514, 'Erreur', 0, 'Une erreur est survenue lors de consultation tsx?page=1&pagesize=1000&paginate=true.', 'ERREUR', 0, NULL, NULL, NULL, NULL, '2026-02-16 20:07:10', '2026-02-16 20:07:10'),
(515, 'Erreur', 0, 'Une erreur est survenue lors de consultation tsx?page=1&pagesize=1000&paginate=true.', 'ERREUR', 0, NULL, NULL, NULL, NULL, '2026-02-16 20:07:11', '2026-02-16 20:07:11'),
(516, 'Erreur', 0, 'Une erreur est survenue lors de consultation tsx?page=1&pagesize=1000&paginate=true.', 'ERREUR', 0, NULL, NULL, NULL, NULL, '2026-02-16 20:07:37', '2026-02-16 20:07:37'),
(517, 'Erreur', 0, 'Une erreur est survenue lors de consultation tsx?page=1&pagesize=1000&paginate=true.', 'ERREUR', 0, NULL, NULL, NULL, NULL, '2026-02-16 20:17:22', '2026-02-16 20:17:22'),
(518, 'Opération réussie', 0, 'Consultation notification_track?userId=1&search=&page=1&pageSize=20 effectuée avec succès.', 'SUCCESS', 0, NULL, NULL, NULL, NULL, '2026-02-16 20:21:49', '2026-02-16 20:21:49'),
(519, 'Erreur', 0, 'Une erreur est survenue lors de consultation sector?page=2&pagesize=10&search=&paginate=true.', 'ERREUR', 0, NULL, NULL, NULL, NULL, '2026-02-16 20:24:56', '2026-02-16 20:24:56'),
(520, 'Opération réussie', 0, 'Consultation sector?page=1&pageSize=20&search=&paginate=false effectuée avec succès.', 'SUCCESS', 0, NULL, NULL, NULL, NULL, '2026-02-19 05:17:33', '2026-02-19 05:17:33'),
(521, 'Opération réussie', 0, 'Consultation 1 effectuée avec succès.', 'SUCCESS', 0, NULL, NULL, NULL, NULL, '2026-02-19 05:17:33', '2026-02-19 05:17:33'),
(522, 'Erreur', 0, 'Une erreur est survenue lors de consultation sector?page=1&pagesize=10&search=&paginate=true.', 'ERREUR', 0, NULL, NULL, NULL, NULL, '2026-02-19 05:19:31', '2026-02-19 05:19:31'),
(523, 'Erreur', 0, 'Une erreur est survenue lors de consultation tsx?id=1&page=1&pagesize=10&paginate=true.', 'ERREUR', 0, NULL, NULL, NULL, NULL, '2026-02-19 05:21:21', '2026-02-19 05:21:21'),
(524, 'Erreur', 0, 'Une erreur est survenue lors de consultation tsx?page=1&pagesize=1000&paginate=true.', 'ERREUR', 0, NULL, NULL, NULL, NULL, '2026-02-19 05:21:22', '2026-02-19 05:21:22'),
(525, 'Erreur', 0, 'Une erreur est survenue lors de consultation sector?page=2&pagesize=10&search=&paginate=true.', 'ERREUR', 0, NULL, NULL, NULL, NULL, '2026-02-19 05:22:25', '2026-02-19 05:22:25'),
(526, 'Opération réussie', 0, 'Consultation users?search=&page=1&pageSize=20&paginate=true effectuée avec succès.', 'SUCCESS', 0, NULL, NULL, NULL, NULL, '2026-02-19 05:23:38', '2026-02-19 05:23:38'),
(527, 'Erreur', 0, 'Une erreur est survenue lors de consultation sector?page=1&pagesize=10&search=&paginate=true.', 'ERREUR', 0, NULL, NULL, NULL, NULL, '2026-02-19 05:24:51', '2026-02-19 05:24:51'),
(528, 'Erreur', 0, 'Une erreur est survenue lors de consultation sector?page=2&pagesize=10&search=&paginate=true.', 'ERREUR', 0, NULL, NULL, NULL, NULL, '2026-02-19 05:37:10', '2026-02-19 05:37:10'),
(529, 'Erreur', 0, 'Une erreur est survenue lors de consultation sector?page=1&pagesize=20&search=&paginate=false.', 'ERREUR', 0, NULL, NULL, NULL, NULL, '2026-02-19 05:54:54', '2026-02-19 05:54:54'),
(530, 'Erreur', 0, 'Une erreur est survenue lors de consultation 1.', 'ERREUR', 0, NULL, NULL, NULL, NULL, '2026-02-19 05:54:54', '2026-02-19 05:54:54'),
(531, 'Opération réussie', 0, 'Création createrecharge effectuée avec succès.', 'SUCCESS', 0, NULL, NULL, NULL, NULL, '2026-02-19 05:56:09', '2026-02-19 05:56:09'),
(532, 'Recharge réussie ✅', 0, 'Votre compte a été crédité de 100 avec succès. Merci d’avoir utilisé notre service.', 'SUCCESS', 0, NULL, NULL, NULL, NULL, '2026-02-19 05:56:09', '2026-02-19 05:56:09'),
(533, 'Opération réussie', 0, 'Création recharge effectuée avec succès.', 'SUCCESS', 0, NULL, NULL, NULL, NULL, '2026-02-19 05:56:09', '2026-02-19 05:56:09'),
(534, 'Opération réussie', 0, 'Consultation notification_track?userId=1&search=&page=1&pageSize=20 effectuée avec succès.', 'SUCCESS', 0, NULL, NULL, NULL, NULL, '2026-02-19 05:56:12', '2026-02-19 05:56:12'),
(535, 'Opération réussie', 0, 'Consultation 1 effectuée avec succès.', 'SUCCESS', 0, NULL, NULL, NULL, NULL, '2026-02-19 05:56:16', '2026-02-19 05:56:16'),
(536, 'Opération réussie', 0, 'Consultation users?search=&page=1&pageSize=20&paginate=true effectuée avec succès.', 'SUCCESS', 0, NULL, NULL, NULL, NULL, '2026-02-19 05:56:24', '2026-02-19 05:56:24'),
(537, 'Erreur', 0, 'Une erreur est survenue lors de consultation sector?page=1&pagesize=10&search=&paginate=true.', 'ERREUR', 0, NULL, NULL, NULL, NULL, '2026-02-19 05:56:26', '2026-02-19 05:56:26'),
(538, 'Erreur', 0, 'Une erreur est survenue lors de consultation product?page=1&pagesize=10&search=&paginate=true&companyid=8.', 'ERREUR', 0, NULL, NULL, NULL, NULL, '2026-02-19 05:56:29', '2026-02-19 05:56:29'),
(539, 'Paiement réussi ✅', 0, 'Votre paiement de 100$ pour la commande ORD-1771480593517 a été effectué avec succès.', 'SUCCESS', 0, NULL, NULL, NULL, NULL, '2026-02-19 05:56:33', '2026-02-19 05:56:33'),
(540, 'Commande payée 🛒', 0, 'Une nouvelle commande ORD-1771480593517 a été payée.', 'INFO', 0, NULL, NULL, NULL, NULL, '2026-02-19 05:56:33', '2026-02-19 05:56:33'),
(541, 'Opération réussie', 0, 'Création paiement effectuée avec succès.', 'SUCCESS', 0, NULL, NULL, NULL, NULL, '2026-02-19 05:56:36', '2026-02-19 05:56:36'),
(542, 'Opération réussie', 0, 'Consultation 1 effectuée avec succès.', 'SUCCESS', 0, NULL, NULL, NULL, NULL, '2026-02-19 05:56:39', '2026-02-19 05:56:39'),
(543, 'Erreur', 0, 'Une erreur est survenue lors de consultation tsx?id=1&page=1&pagesize=10&paginate=true.', 'ERREUR', 0, NULL, NULL, NULL, NULL, '2026-02-19 06:02:37', '2026-02-19 06:02:37'),
(544, 'Erreur', 0, 'Une erreur est survenue lors de consultation tsx?page=1&pagesize=1000&paginate=true.', 'ERREUR', 0, NULL, NULL, NULL, NULL, '2026-02-19 06:02:42', '2026-02-19 06:02:42'),
(545, 'Opération réussie', 0, 'Consultation notification_track?userId=1&search=&page=1&pageSize=20 effectuée avec succès.', 'SUCCESS', 0, NULL, NULL, NULL, NULL, '2026-02-19 06:03:23', '2026-02-19 06:03:23'),
(546, 'Opération réussie', 0, 'Mise à jour profile effectuée avec succès.', 'SUCCESS', 0, NULL, NULL, NULL, NULL, '2026-02-19 06:14:16', '2026-02-19 06:14:16'),
(547, 'Opération réussie', 0, 'Consultation 1 effectuée avec succès.', 'SUCCESS', 0, NULL, NULL, NULL, NULL, '2026-02-19 06:14:16', '2026-02-19 06:14:16'),
(548, 'Opération réussie', 0, 'Création create effectuée avec succès.', 'SUCCESS', 0, NULL, NULL, NULL, NULL, '2026-02-19 06:14:16', '2026-02-19 06:14:16'),
(549, 'Profil mis à jour', 0, 'Votre profil a été mis à jour avec succès depuis l\'application.', 'SUCCESS', 0, NULL, 1, NULL, NULL, '2026-02-19 06:14:16', '2026-02-19 06:14:16'),
(550, 'Opération réussie', 0, 'Création create effectuée avec succès.', 'SUCCESS', 0, NULL, NULL, NULL, NULL, '2026-02-19 06:14:16', '2026-02-19 06:14:16'),
(551, 'Erreur', 0, 'Une erreur est survenue lors de création createrecharge.', 'ERREUR', 0, NULL, NULL, NULL, NULL, '2026-02-19 06:18:07', '2026-02-19 06:18:07'),
(552, 'Erreur', 0, 'Une erreur est survenue lors de création createrecharge.', 'ERREUR', 0, NULL, NULL, NULL, NULL, '2026-02-19 06:18:51', '2026-02-19 06:18:51'),
(553, 'Opération réussie', 0, 'Consultation 1 effectuée avec succès.', 'SUCCESS', 0, NULL, NULL, NULL, NULL, '2026-02-19 06:33:15', '2026-02-19 06:33:15'),
(554, 'Erreur', 0, 'Une erreur est survenue lors de consultation 1.', 'ERREUR', 0, NULL, NULL, NULL, NULL, '2026-02-19 06:33:18', '2026-02-19 06:33:18'),
(555, 'Erreur', 0, 'Une erreur est survenue lors de consultation 1.', 'ERREUR', 0, NULL, NULL, NULL, NULL, '2026-02-19 06:33:19', '2026-02-19 06:33:19'),
(556, 'Opération réussie', 0, 'Consultation users?search=&page=1&pageSize=20&paginate=true effectuée avec succès.', 'SUCCESS', 0, NULL, NULL, NULL, NULL, '2026-02-19 06:33:23', '2026-02-19 06:33:23'),
(557, 'Opération réussie', 0, 'Consultation 1 effectuée avec succès.', 'SUCCESS', 0, NULL, NULL, NULL, NULL, '2026-02-20 04:12:21', '2026-02-20 04:12:21'),
(558, 'Erreur', 0, 'Une erreur est survenue lors de consultation sector?page=1&pagesize=10&search=&paginate=true.', 'ERREUR', 0, NULL, NULL, NULL, NULL, '2026-02-20 04:15:35', '2026-02-20 04:15:35'),
(559, 'Opération réussie', 0, 'Consultation 1 effectuée avec succès.', 'SUCCESS', 0, NULL, NULL, NULL, NULL, '2026-02-20 04:15:38', '2026-02-20 04:15:38'),
(560, 'Erreur', 0, 'Une erreur est survenue lors de consultation tsx?page=1&pagesize=1000&paginate=true.', 'ERREUR', 0, NULL, NULL, NULL, NULL, '2026-02-20 04:15:43', '2026-02-20 04:15:43'),
(561, 'Erreur', 0, 'Une erreur est survenue lors de consultation tsx?id=1&page=1&pagesize=10&paginate=true.', 'ERREUR', 0, NULL, NULL, NULL, NULL, '2026-02-20 04:15:44', '2026-02-20 04:15:44'),
(562, 'Erreur', 0, 'Une erreur est survenue lors de consultation 1.', 'ERREUR', 0, NULL, NULL, NULL, NULL, '2026-02-20 04:16:02', '2026-02-20 04:16:02'),
(563, 'Opération réussie', 0, 'Consultation sector?page=1&pageSize=20&search=&paginate=false effectuée avec succès.', 'SUCCESS', 0, NULL, NULL, NULL, NULL, '2026-02-20 04:16:56', '2026-02-20 04:16:56'),
(564, 'Erreur', 0, 'Une erreur est survenue lors de consultation 1.', 'ERREUR', 0, NULL, NULL, NULL, NULL, '2026-02-20 04:16:56', '2026-02-20 04:16:56'),
(565, 'Erreur', 0, 'Une erreur est survenue lors de consultation sector?page=1&pagesize=20&search=&paginate=false.', 'ERREUR', 0, NULL, NULL, NULL, NULL, '2026-02-20 04:27:08', '2026-02-20 04:27:08'),
(566, 'Opération réussie', 0, 'Consultation 1 effectuée avec succès.', 'SUCCESS', 0, NULL, NULL, NULL, NULL, '2026-02-20 04:27:08', '2026-02-20 04:27:08');
INSERT INTO `notifications` (`notificationId`, `title`, `global`, `message`, `type`, `isRead`, `expeTrackId`, `userId`, `commerceId`, `branchTrackId`, `createdAt`, `updatedAt`) VALUES
(567, 'Opération réussie', 0, 'Consultation notification_track?userId=1&search=&page=1&pageSize=20 effectuée avec succès.', 'SUCCESS', 0, NULL, NULL, NULL, NULL, '2026-02-20 04:28:25', '2026-02-20 04:28:25'),
(568, 'Opération réussie', 0, 'Mise à jour profile effectuée avec succès.', 'SUCCESS', 0, NULL, NULL, NULL, NULL, '2026-02-20 04:29:25', '2026-02-20 04:29:25'),
(569, 'Opération réussie', 0, 'Consultation 1 effectuée avec succès.', 'SUCCESS', 0, NULL, NULL, NULL, NULL, '2026-02-20 04:29:25', '2026-02-20 04:29:25'),
(570, 'Opération réussie', 0, 'Création create effectuée avec succès.', 'SUCCESS', 0, NULL, NULL, NULL, NULL, '2026-02-20 04:29:25', '2026-02-20 04:29:25'),
(571, 'Profil mis à jour', 0, 'Votre profil a été mis à jour avec succès.', 'SUCCESS', 0, NULL, 1, NULL, NULL, '2026-02-20 04:29:25', '2026-02-20 04:29:25'),
(572, 'Opération réussie', 0, 'Création create effectuée avec succès.', 'SUCCESS', 0, NULL, NULL, NULL, NULL, '2026-02-20 04:29:25', '2026-02-20 04:29:25'),
(573, 'Opération réussie', 0, 'Consultation notification_track?userId=1&search=&page=1&pageSize=20 effectuée avec succès.', 'SUCCESS', 0, NULL, NULL, NULL, NULL, '2026-02-20 04:32:40', '2026-02-20 04:32:40'),
(574, 'Erreur', 0, 'Une erreur est survenue lors de consultation sector?page=1&pagesize=10&search=&paginate=true.', 'ERREUR', 0, NULL, NULL, NULL, NULL, '2026-02-20 04:33:28', '2026-02-20 04:33:28'),
(575, 'Erreur', 0, 'Une erreur est survenue lors de consultation tsx?id=1&page=1&pagesize=10&paginate=true.', 'ERREUR', 0, NULL, NULL, NULL, NULL, '2026-02-20 04:33:29', '2026-02-20 04:33:29'),
(576, 'Erreur', 0, 'Une erreur est survenue lors de consultation tsx?page=1&pagesize=1000&paginate=true.', 'ERREUR', 0, NULL, NULL, NULL, NULL, '2026-02-20 04:33:34', '2026-02-20 04:33:34'),
(577, 'Opération réussie', 0, 'Consultation notification_track?userId=1&search=&page=1&pageSize=20 effectuée avec succès.', 'SUCCESS', 0, NULL, NULL, NULL, NULL, '2026-02-20 04:34:16', '2026-02-20 04:34:16'),
(578, 'Opération réussie', 0, 'Consultation notification_track?userId=1&search=Sn&page=1&pageSize=20 effectuée avec succès.', 'SUCCESS', 0, NULL, NULL, NULL, NULL, '2026-02-20 04:36:38', '2026-02-20 04:36:38'),
(579, 'Opération réussie', 0, 'Consultation notification_track?userId=1&search=&page=1&pageSize=20 effectuée avec succès.', 'SUCCESS', 0, NULL, NULL, NULL, NULL, '2026-02-20 04:36:38', '2026-02-20 04:36:38'),
(580, 'Opération réussie', 0, 'Consultation notification_track?userId=1&search=S&page=1&pageSize=20 effectuée avec succès.', 'SUCCESS', 0, NULL, NULL, NULL, NULL, '2026-02-20 04:36:38', '2026-02-20 04:36:38'),
(581, 'Opération réussie', 0, 'Consultation notification_track?userId=1&search=Snb&page=1&pageSize=20 effectuée avec succès.', 'SUCCESS', 0, NULL, NULL, NULL, NULL, '2026-02-20 04:36:39', '2026-02-20 04:36:39'),
(582, 'Opération réussie', 0, 'Consultation notification_track?userId=1&search=Snbs&page=1&pageSize=20 effectuée avec succès.', 'SUCCESS', 0, NULL, NULL, NULL, NULL, '2026-02-20 04:36:39', '2026-02-20 04:36:39'),
(583, 'Opération réussie', 0, 'Consultation notification_track?userId=1&search=Snbs&page=1&pageSize=20 effectuée avec succès.', 'SUCCESS', 0, NULL, NULL, NULL, NULL, '2026-02-20 04:36:39', '2026-02-20 04:36:39'),
(584, 'Opération réussie', 0, 'Consultation notification_track?userId=1&search=Snb&page=1&pageSize=20 effectuée avec succès.', 'SUCCESS', 0, NULL, NULL, NULL, NULL, '2026-02-20 04:36:39', '2026-02-20 04:36:39'),
(585, 'Opération réussie', 0, 'Consultation notification_track?userId=1&search=Sn&page=1&pageSize=20 effectuée avec succès.', 'SUCCESS', 0, NULL, NULL, NULL, NULL, '2026-02-20 04:36:39', '2026-02-20 04:36:39'),
(586, 'Opération réussie', 0, 'Consultation notification_track?userId=1&search=S&page=1&pageSize=20 effectuée avec succès.', 'SUCCESS', 0, NULL, NULL, NULL, NULL, '2026-02-20 04:36:40', '2026-02-20 04:36:40'),
(587, 'Opération réussie', 0, 'Consultation notification_track?userId=1&search=&page=1&pageSize=20 effectuée avec succès.', 'SUCCESS', 0, NULL, NULL, NULL, NULL, '2026-02-20 04:39:12', '2026-02-20 04:39:12'),
(588, 'Erreur', 0, 'Une erreur est survenue lors de consultation 1.', 'ERREUR', 0, NULL, NULL, NULL, NULL, '2026-02-20 04:41:21', '2026-02-20 04:41:21'),
(589, 'Erreur', 0, 'Une erreur est survenue lors de consultation sector?page=1&pagesize=20&search=&paginate=false.', 'ERREUR', 0, NULL, NULL, NULL, NULL, '2026-02-20 04:41:21', '2026-02-20 04:41:21'),
(590, 'Erreur', 0, 'Une erreur est survenue lors de consultation sector?page=1&pagesize=10&search=&paginate=true.', 'ERREUR', 0, NULL, NULL, NULL, NULL, '2026-02-20 04:42:08', '2026-02-20 04:42:08'),
(591, 'Erreur', 0, 'Une erreur est survenue lors de consultation sector?page=2&pagesize=10&search=&paginate=true.', 'ERREUR', 0, NULL, NULL, NULL, NULL, '2026-02-20 04:42:11', '2026-02-20 04:42:11'),
(592, 'Opération réussie', 0, 'Consultation notification_track?userId=1&search=&page=1&pageSize=20 effectuée avec succès.', 'SUCCESS', 0, NULL, NULL, NULL, NULL, '2026-02-20 04:43:06', '2026-02-20 04:43:06'),
(593, 'Erreur', 0, 'Une erreur est survenue lors de consultation product?page=1&pagesize=10&search=&paginate=true&companyid=9.', 'ERREUR', 0, NULL, NULL, NULL, NULL, '2026-02-20 04:43:57', '2026-02-20 04:43:57'),
(594, 'Erreur', 0, 'Une erreur est survenue lors de consultation product?page=1&pagesize=10&search=&paginate=true&companyid=8.', 'ERREUR', 0, NULL, NULL, NULL, NULL, '2026-02-20 04:44:02', '2026-02-20 04:44:02'),
(595, 'Erreur', 0, 'Une erreur est survenue lors de consultation tsx?id=1&page=1&pagesize=10&paginate=true.', 'ERREUR', 0, NULL, NULL, NULL, NULL, '2026-02-20 04:44:47', '2026-02-20 04:44:47'),
(596, 'Erreur', 0, 'Une erreur est survenue lors de consultation tsx?page=1&pagesize=1000&paginate=true.', 'ERREUR', 0, NULL, NULL, NULL, NULL, '2026-02-20 04:44:47', '2026-02-20 04:44:47'),
(597, 'Erreur', 0, 'Une erreur est survenue lors de consultation product?page=1&pagesize=10&search=&paginate=true&companyid=11.', 'ERREUR', 0, NULL, NULL, NULL, NULL, '2026-02-20 04:45:05', '2026-02-20 04:45:05'),
(598, 'Opération réussie', 0, 'Consultation notification_track?userId=1&search=&page=1&pageSize=20 effectuée avec succès.', 'SUCCESS', 0, NULL, NULL, NULL, NULL, '2026-02-20 04:46:06', '2026-02-20 04:46:06'),
(599, 'Erreur', 0, 'Une erreur est survenue lors de consultation product?page=1&pagesize=10&search=&paginate=true&companyid=8.', 'ERREUR', 0, NULL, NULL, NULL, NULL, '2026-02-20 04:47:02', '2026-02-20 04:47:02'),
(600, 'Erreur', 0, 'Une erreur est survenue lors de consultation product?page=1&pagesize=10&search=&paginate=true&companyid=8.', 'ERREUR', 0, NULL, NULL, NULL, NULL, '2026-02-20 04:49:20', '2026-02-20 04:49:20'),
(601, 'Opération réussie', 0, 'Consultation notification_track?userId=1&search=&page=1&pageSize=20 effectuée avec succès.', 'SUCCESS', 0, NULL, NULL, NULL, NULL, '2026-02-20 04:49:45', '2026-02-20 04:49:45'),
(602, 'Erreur', 0, 'Une erreur est survenue lors de consultation product?page=1&pagesize=10&search=&paginate=true&companyid=11.', 'ERREUR', 0, NULL, NULL, NULL, NULL, '2026-02-20 04:51:02', '2026-02-20 04:51:02'),
(603, 'Paiement réussi ✅', 0, 'Votre paiement de 100$ pour la commande ORD-1771563100707 a été effectué avec succès.', 'SUCCESS', 0, NULL, NULL, NULL, NULL, '2026-02-20 04:51:40', '2026-02-20 04:51:40'),
(604, 'Commande payée 🛒', 0, 'Une nouvelle commande ORD-1771563100707 a été payée.', 'INFO', 0, NULL, NULL, NULL, NULL, '2026-02-20 04:51:40', '2026-02-20 04:51:40'),
(605, 'Opération réussie', 0, 'Création paiement effectuée avec succès.', 'SUCCESS', 0, NULL, NULL, NULL, NULL, '2026-02-20 04:51:43', '2026-02-20 04:51:43'),
(606, 'Opération réussie', 0, 'Consultation 1 effectuée avec succès.', 'SUCCESS', 0, NULL, NULL, NULL, NULL, '2026-02-20 04:51:49', '2026-02-20 04:51:49'),
(607, 'Erreur', 0, 'Une erreur est survenue lors de consultation sector?page=1&pagesize=10&search=&paginate=true.', 'ERREUR', 0, NULL, NULL, NULL, NULL, '2026-02-20 04:52:11', '2026-02-20 04:52:11'),
(608, 'Erreur', 0, 'Une erreur est survenue lors de consultation product?page=1&pagesize=10&search=&paginate=true&companyid=11.', 'ERREUR', 0, NULL, NULL, NULL, NULL, '2026-02-20 04:52:33', '2026-02-20 04:52:33'),
(609, 'Opération réussie', 0, 'Consultation notification_track?userId=1&search=&page=1&pageSize=20 effectuée avec succès.', 'SUCCESS', 0, NULL, NULL, NULL, NULL, '2026-02-20 05:05:06', '2026-02-20 05:05:06'),
(610, 'Opération réussie', 0, 'Consultation notification_track?userId=1&search=&page=1&pageSize=20 effectuée avec succès.', 'SUCCESS', 0, NULL, NULL, NULL, NULL, '2026-02-20 05:07:27', '2026-02-20 05:07:27'),
(611, 'Opération réussie', 0, 'Consultation notification_track?userId=1&search=&page=1&pageSize=20 effectuée avec succès.', 'SUCCESS', 0, NULL, NULL, NULL, NULL, '2026-02-20 05:10:29', '2026-02-20 05:10:29'),
(612, 'Opération réussie', 0, 'Consultation users?search=&page=1&pageSize=20&paginate=true effectuée avec succès.', 'SUCCESS', 0, NULL, NULL, NULL, NULL, '2026-02-20 05:13:12', '2026-02-20 05:13:12'),
(613, 'Erreur', 0, 'Une erreur est survenue lors de consultation sector?page=1&pagesize=20&search=&paginate=false.', 'ERREUR', 0, NULL, NULL, NULL, NULL, '2026-02-20 05:14:36', '2026-02-20 05:14:36'),
(614, 'Erreur', 0, 'Une erreur est survenue lors de consultation 1.', 'ERREUR', 0, NULL, NULL, NULL, NULL, '2026-02-20 05:14:37', '2026-02-20 05:14:37'),
(615, 'Opération réussie', 0, 'Consultation 1 effectuée avec succès.', 'SUCCESS', 0, NULL, NULL, NULL, NULL, '2026-02-20 05:15:12', '2026-02-20 05:15:12'),
(616, 'Erreur', 0, 'Une erreur est survenue lors de consultation sector?page=1&pagesize=20&search=&paginate=false.', 'ERREUR', 0, NULL, NULL, NULL, NULL, '2026-02-20 05:15:24', '2026-02-20 05:15:24'),
(617, 'Erreur', 0, 'Une erreur est survenue lors de consultation 1.', 'ERREUR', 0, NULL, NULL, NULL, NULL, '2026-02-20 05:15:24', '2026-02-20 05:15:24'),
(618, 'Opération réussie', 0, 'Consultation notification_track?userId=1&search=&page=1&pageSize=20 effectuée avec succès.', 'SUCCESS', 0, NULL, NULL, NULL, NULL, '2026-02-20 05:16:34', '2026-02-20 05:16:34'),
(619, 'Erreur', 0, 'Une erreur est survenue lors de consultation sector?page=1&pagesize=10&search=&paginate=true.', 'ERREUR', 0, NULL, NULL, NULL, NULL, '2026-02-20 05:17:06', '2026-02-20 05:17:06'),
(620, 'Erreur', 0, 'Une erreur est survenue lors de consultation tsx?id=1&page=1&pagesize=10&paginate=true.', 'ERREUR', 0, NULL, NULL, NULL, NULL, '2026-02-20 05:17:09', '2026-02-20 05:17:09'),
(621, 'Erreur', 0, 'Une erreur est survenue lors de consultation tsx?page=1&pagesize=1000&paginate=true.', 'ERREUR', 0, NULL, NULL, NULL, NULL, '2026-02-20 05:17:14', '2026-02-20 05:17:14'),
(622, 'Erreur', 0, 'Une erreur est survenue lors de consultation product?page=1&pagesize=10&search=&paginate=true&companyid=8.', 'ERREUR', 0, NULL, NULL, NULL, NULL, '2026-02-20 05:18:11', '2026-02-20 05:18:11'),
(623, 'Opération réussie', 0, 'Consultation users?search=&page=1&pageSize=20&paginate=true effectuée avec succès.', 'SUCCESS', 0, NULL, NULL, NULL, NULL, '2026-02-20 05:18:28', '2026-02-20 05:18:28'),
(624, 'Opération réussie', 0, 'Consultation users?search=john&page=1&pageSize=20&paginate=true effectuée avec succès.', 'SUCCESS', 0, NULL, NULL, NULL, NULL, '2026-02-20 05:18:36', '2026-02-20 05:18:36'),
(625, 'Transfert réussi ✅', 0, 'Vous avez envoyé 100$ (frais: 1$).', 'SUCCESS', 0, NULL, NULL, NULL, NULL, '2026-02-20 05:18:46', '2026-02-20 05:18:46'),
(626, 'Fonds reçus ✅', 0, 'Vous avez reçu 99$ de Leader Mushio.', 'SUCCESS', 0, NULL, NULL, NULL, NULL, '2026-02-20 05:18:46', '2026-02-20 05:18:46'),
(627, 'Abonnement activé 🎉', 0, '1$ a été déduit pour activer votre abonnement.', 'INFO', 0, NULL, NULL, NULL, NULL, '2026-02-20 05:18:46', '2026-02-20 05:18:46'),
(628, 'Opération réussie', 0, 'Création transfert effectuée avec succès.', 'SUCCESS', 0, NULL, NULL, NULL, NULL, '2026-02-20 05:18:46', '2026-02-20 05:18:46'),
(629, 'Opération réussie', 0, 'Consultation 1 effectuée avec succès.', 'SUCCESS', 0, NULL, NULL, NULL, NULL, '2026-02-20 05:18:52', '2026-02-20 05:18:52'),
(630, 'Opération réussie', 0, 'Consultation notification_track?userId=1&search=&page=1&pageSize=20 effectuée avec succès.', 'SUCCESS', 0, NULL, NULL, NULL, NULL, '2026-02-20 05:18:58', '2026-02-20 05:18:58'),
(631, 'Erreur', 0, 'Une erreur est survenue lors de consultation sector?page=1&pagesize=20&search=&paginate=false.', 'ERREUR', 0, NULL, NULL, NULL, NULL, '2026-02-20 05:24:59', '2026-02-20 05:24:59'),
(632, 'Erreur', 0, 'Une erreur est survenue lors de consultation 1.', 'ERREUR', 0, NULL, NULL, NULL, NULL, '2026-02-20 05:24:59', '2026-02-20 05:24:59'),
(633, 'Opération réussie', 0, 'Création create effectuée avec succès.', 'SUCCESS', 0, NULL, NULL, NULL, NULL, '2026-02-20 05:25:27', '2026-02-20 05:25:27'),
(634, 'Échec de connexion', 0, 'Une tentative de connexion a échoué.', 'ERREUR', 0, NULL, 1, NULL, NULL, '2026-02-20 05:25:27', '2026-02-20 05:25:27'),
(635, 'Opération réussie', 0, 'Création create effectuée avec succès.', 'SUCCESS', 0, NULL, NULL, NULL, NULL, '2026-02-20 05:25:27', '2026-02-20 05:25:27'),
(636, 'Opération réussie', 0, 'Consultation 1 effectuée avec succès.', 'SUCCESS', 0, NULL, NULL, NULL, NULL, '2026-02-20 05:26:16', '2026-02-20 05:26:16'),
(637, 'Erreur', 0, 'Une erreur est survenue lors de consultation 1.', 'ERREUR', 0, NULL, NULL, NULL, NULL, '2026-02-20 05:26:19', '2026-02-20 05:26:19'),
(638, 'Erreur', 0, 'Une erreur est survenue lors de consultation sector?page=1&pagesize=20&search=&paginate=false.', 'ERREUR', 0, NULL, NULL, NULL, NULL, '2026-02-20 05:28:28', '2026-02-20 05:28:28'),
(639, 'Erreur', 0, 'Une erreur est survenue lors de consultation 1.', 'ERREUR', 0, NULL, NULL, NULL, NULL, '2026-02-20 05:28:28', '2026-02-20 05:28:28'),
(640, 'Erreur', 0, 'Une erreur est survenue lors de consultation sector?page=1&pagesize=20&search=&paginate=false.', 'ERREUR', 0, NULL, NULL, NULL, NULL, '2026-02-20 05:28:57', '2026-02-20 05:28:57'),
(641, 'Erreur', 0, 'Une erreur est survenue lors de consultation 1.', 'ERREUR', 0, NULL, NULL, NULL, NULL, '2026-02-20 05:28:58', '2026-02-20 05:28:58'),
(642, 'Erreur', 0, 'Une erreur est survenue lors de consultation sector?page=1&pagesize=20&search=&paginate=false.', 'ERREUR', 0, NULL, NULL, NULL, NULL, '2026-02-20 05:29:54', '2026-02-20 05:29:54'),
(643, 'Erreur', 0, 'Une erreur est survenue lors de consultation 1.', 'ERREUR', 0, NULL, NULL, NULL, NULL, '2026-02-20 05:29:54', '2026-02-20 05:29:54'),
(644, 'Erreur', 0, 'Une erreur est survenue lors de consultation sector?page=1&pagesize=20&search=&paginate=false.', 'ERREUR', 0, NULL, NULL, NULL, NULL, '2026-02-20 05:32:05', '2026-02-20 05:32:05'),
(645, 'Opération réussie', 0, 'Consultation 1 effectuée avec succès.', 'SUCCESS', 0, NULL, NULL, NULL, NULL, '2026-02-20 05:32:05', '2026-02-20 05:32:05'),
(646, 'Opération réussie', 0, 'Création create effectuée avec succès.', 'SUCCESS', 0, NULL, NULL, NULL, NULL, '2026-02-20 05:32:40', '2026-02-20 05:32:40'),
(647, 'Échec de connexion', 0, 'Une tentative de connexion a échoué.', 'ERREUR', 0, NULL, 1, NULL, NULL, '2026-02-20 05:32:40', '2026-02-20 05:32:40'),
(648, 'Opération réussie', 0, 'Création create effectuée avec succès.', 'SUCCESS', 0, NULL, NULL, NULL, NULL, '2026-02-20 05:32:41', '2026-02-20 05:32:41'),
(649, 'Erreur', 0, 'Une erreur est survenue lors de consultation tsx?id=1&page=1&pagesize=10&paginate=true.', 'ERREUR', 0, NULL, NULL, NULL, NULL, '2026-02-20 05:33:31', '2026-02-20 05:33:31'),
(650, 'Erreur', 0, 'Une erreur est survenue lors de création paiement.', 'ERREUR', 0, NULL, NULL, NULL, NULL, '2026-02-20 05:35:00', '2026-02-20 05:35:00'),
(651, 'Erreur', 0, 'Une erreur est survenue lors de création paiement.', 'ERREUR', 0, NULL, NULL, NULL, NULL, '2026-02-20 05:35:07', '2026-02-20 05:35:07'),
(652, 'Erreur', 0, 'Une erreur est survenue lors de création paiement.', 'ERREUR', 0, NULL, NULL, NULL, NULL, '2026-02-20 05:36:24', '2026-02-20 05:36:24'),
(653, 'Erreur', 0, 'Une erreur est survenue lors de création paiement.', 'ERREUR', 0, NULL, NULL, NULL, NULL, '2026-02-20 05:37:30', '2026-02-20 05:37:30'),
(654, 'Transfert réussi ✅', 0, 'Vous avez envoyé 100$ (frais: 1$).', 'SUCCESS', 0, NULL, NULL, NULL, NULL, '2026-02-20 05:45:01', '2026-02-20 05:45:01'),
(655, 'Fonds reçus ✅', 0, 'Vous avez reçu 100$ de Leader Mushio.', 'SUCCESS', 0, NULL, NULL, NULL, NULL, '2026-02-20 05:45:01', '2026-02-20 05:45:01'),
(656, 'Opération réussie', 0, 'Création transfert effectuée avec succès.', 'SUCCESS', 0, NULL, NULL, NULL, NULL, '2026-02-20 05:45:01', '2026-02-20 05:45:01'),
(657, 'Opération réussie', 0, 'Consultation 1 effectuée avec succès.', 'SUCCESS', 0, NULL, NULL, NULL, NULL, '2026-02-20 05:45:08', '2026-02-20 05:45:08'),
(658, 'Opération réussie', 0, 'Consultation notification_track?userId=1&search=&page=1&pageSize=20 effectuée avec succès.', 'SUCCESS', 0, NULL, NULL, NULL, NULL, '2026-02-20 05:45:13', '2026-02-20 05:45:13'),
(659, 'Paiement réussi ✅', 0, 'Votre paiement de 10$ pour la commande ORD-1771568905511 a été effectué avec succès.', 'SUCCESS', 0, NULL, NULL, NULL, NULL, '2026-02-20 06:28:25', '2026-02-20 06:28:25'),
(660, 'Commande payée 🛒', 0, 'Une nouvelle commande ORD-1771568905511 a été payée.', 'INFO', 0, NULL, NULL, NULL, NULL, '2026-02-20 06:28:25', '2026-02-20 06:28:25'),
(661, 'Transfert réussi ✅', 0, 'Vous avez envoyé 10$ (frais: 0.5$).', 'SUCCESS', 0, NULL, NULL, NULL, NULL, '2026-02-20 08:07:27', '2026-02-20 08:07:27'),
(662, 'Fonds reçus ✅', 0, 'Vous avez reçu 9$ de Leader Mushio.', 'SUCCESS', 0, NULL, NULL, NULL, NULL, '2026-02-20 08:07:27', '2026-02-20 08:07:27'),
(663, 'Abonnement activé 🎉', 0, '1$ a été déduit pour activer votre abonnement.', 'INFO', 0, NULL, NULL, NULL, NULL, '2026-02-20 08:07:27', '2026-02-20 08:07:27'),
(664, 'Transfert réussi ✅', 0, 'Vous avez envoyé 10$ (frais: 0.5$).', 'SUCCESS', 0, NULL, NULL, NULL, NULL, '2026-02-20 08:09:26', '2026-02-20 08:09:26'),
(665, 'Fonds reçus ✅', 0, 'Vous avez reçu 9$ de Leader Mushio.', 'SUCCESS', 0, NULL, NULL, NULL, NULL, '2026-02-20 08:09:26', '2026-02-20 08:09:26'),
(666, 'Abonnement activé 🎉', 0, '1$ a été déduit pour activer votre abonnement.', 'INFO', 0, NULL, NULL, NULL, NULL, '2026-02-20 08:09:26', '2026-02-20 08:09:26'),
(667, 'Paiement réussi ✅', 0, 'Votre paiement de 100$ pour la commande ORD-1771575237091 a été effectué avec succès.', 'SUCCESS', 0, NULL, NULL, NULL, NULL, '2026-02-20 08:13:57', '2026-02-20 08:13:57'),
(668, 'Commande payée 🛒', 0, 'Une nouvelle commande ORD-1771575237091 a été payée.', 'INFO', 0, NULL, NULL, NULL, NULL, '2026-02-20 08:13:57', '2026-02-20 08:13:57'),
(669, 'Échec de connexion', 0, 'Une tentative de connexion a échoué.', 'ERREUR', 0, NULL, 1, NULL, NULL, '2026-02-20 17:57:33', '2026-02-20 17:57:33'),
(670, 'Échec de connexion', 0, 'Une tentative de connexion a échoué.', 'ERREUR', 0, NULL, 7, NULL, NULL, '2026-02-20 18:22:25', '2026-02-20 18:22:25'),
(671, 'Profil mis à jour', 0, 'Votre profil a été mis à jour avec succès.', 'SUCCESS', 0, NULL, 7, NULL, NULL, '2026-02-20 18:27:47', '2026-02-20 18:27:47'),
(672, 'Recharge réussie ✅', 0, 'Votre compte a été crédité de 1 avec succès. Merci d’avoir utilisé notre service.', 'SUCCESS', 0, NULL, NULL, NULL, NULL, '2026-02-20 20:54:13', '2026-02-20 20:54:13'),
(673, 'Transfert réussi ✅', 0, 'Vous avez envoyé 10$ (frais: 0.5$).', 'SUCCESS', 0, NULL, NULL, NULL, NULL, '2026-02-20 21:01:36', '2026-02-20 21:01:36'),
(674, 'Fonds reçus ✅', 0, 'Vous avez reçu 9$ de Leader Mushio.', 'SUCCESS', 0, NULL, NULL, NULL, NULL, '2026-02-20 21:01:36', '2026-02-20 21:01:36'),
(675, 'Abonnement activé 🎉', 0, '1$ a été déduit pour activer votre abonnement.', 'INFO', 0, NULL, NULL, NULL, NULL, '2026-02-20 21:01:36', '2026-02-20 21:01:36'),
(676, 'Recharge réussie ✅', 0, 'Votre compte a été crédité de 10$ avec succès. Merci d’avoir utilisé notre service.', 'SUCCESS', 0, NULL, NULL, NULL, NULL, '2026-02-20 21:11:35', '2026-02-20 21:11:35'),
(677, 'Recharge réussie ✅', 0, 'Votre compte a été crédité de 100$ avec succès. Merci d’avoir utilisé notre service.', 'SUCCESS', 0, NULL, NULL, NULL, NULL, '2026-02-21 07:26:54', '2026-02-21 07:26:54'),
(678, 'Recharge réussie ✅', 0, 'Votre compte a été crédité de 9.80$ (brut: 10$ — frais: 0.20$).', 'SUCCESS', 0, NULL, NULL, NULL, NULL, '2026-02-21 07:49:04', '2026-02-21 07:49:04'),
(679, 'Recharge réussie ✅', 0, 'Votre compte a été crédité de 9.80$ (brut: 10$ — frais: 0.20$).', 'SUCCESS', 0, NULL, NULL, NULL, NULL, '2026-02-21 07:49:11', '2026-02-21 07:49:11'),
(680, 'Recharge réussie ✅', 0, 'Votre compte a été crédité de 9.80$ (brut: 10$ — frais: 0.20$).', 'SUCCESS', 0, NULL, NULL, NULL, NULL, '2026-02-21 07:49:16', '2026-02-21 07:49:16'),
(681, 'Recharge réussie ✅', 0, 'Votre compte a été crédité de 20$. Aucun frais prélevé.', 'SUCCESS', 0, NULL, NULL, NULL, NULL, '2026-02-21 07:52:09', '2026-02-21 07:52:09'),
(682, 'Recharge réussie ✅', 0, 'Votre compte a été crédité de 19$ — abonnement annuel activé (-1$).', 'SUCCESS', 0, NULL, NULL, NULL, NULL, '2026-02-21 07:54:07', '2026-02-21 07:54:07'),
(683, 'Recharge réussie ✅', 0, 'Votre compte a été crédité de 20$. Aucun frais prélevé.', 'SUCCESS', 0, NULL, NULL, NULL, NULL, '2026-02-21 07:55:39', '2026-02-21 07:55:39'),
(684, 'Recharge réussie ✅', 0, 'Votre compte a été crédité de 20$. Aucun frais prélevé.', 'SUCCESS', 0, NULL, NULL, NULL, NULL, '2026-02-21 08:18:58', '2026-02-21 08:18:58'),
(685, 'Recharge réussie ✅', 0, 'Votre compte a été crédité de 19$ — abonnement annuel activé (-1$).', 'SUCCESS', 0, NULL, NULL, NULL, NULL, '2026-02-21 08:24:24', '2026-02-21 08:24:24'),
(686, 'Recharge réussie ✅', 0, 'Votre compte a été crédité de 20$. Aucun frais prélevé.', 'SUCCESS', 0, NULL, NULL, NULL, NULL, '2026-02-21 08:25:47', '2026-02-21 08:25:47'),
(687, 'Recharge réussie ✅', 0, 'Votre compte a été crédité de 20$. Aucun frais prélevé.', 'SUCCESS', 0, NULL, NULL, NULL, NULL, '2026-02-21 08:29:03', '2026-02-21 08:29:03'),
(688, 'Recharge réussie ✅', 0, 'Votre compte a été crédité de 20$. Aucun frais prélevé.', 'SUCCESS', 0, NULL, NULL, NULL, NULL, '2026-02-21 08:30:04', '2026-02-21 08:30:04'),
(689, 'Recharge réussie ✅', 0, 'Votre compte a été crédité de 20$. Aucun frais prélevé.', 'SUCCESS', 0, NULL, NULL, NULL, NULL, '2026-02-21 08:32:51', '2026-02-21 08:32:51'),
(690, 'Recharge réussie ✅', 0, 'Votre compte a été crédité de 20$. Aucun frais prélevé.', 'SUCCESS', 0, NULL, NULL, NULL, NULL, '2026-02-21 08:33:34', '2026-02-21 08:33:34'),
(691, 'Recharge réussie ✅', 0, 'Votre compte a été crédité de 20$. Aucun frais prélevé.', 'SUCCESS', 0, NULL, NULL, NULL, NULL, '2026-02-21 08:34:45', '2026-02-21 08:34:45'),
(698, 'Transfert envoyé ✅', 0, 'Vous avez transféré 10$ à user_7cfxq.', 'SUCCESS', 0, NULL, NULL, NULL, NULL, '2026-02-21 08:55:57', '2026-02-21 08:55:57'),
(699, 'Fonds reçus 💰', 0, 'Vous avez reçu 9$ de Leader Mushio.', 'SUCCESS', 0, NULL, NULL, NULL, NULL, '2026-02-21 08:55:57', '2026-02-21 08:55:57'),
(700, 'Abonnement activé 🎉', 0, '1$ a été déduit pour activer l’abonnement. Vous pouvez maintenant utiliser toutes les fonctionnalités.', 'INFO', 0, NULL, NULL, NULL, NULL, '2026-02-21 08:55:57', '2026-02-21 08:55:57'),
(701, 'Transfert envoyé ✅', 0, 'Vous avez transféré 10$ à user_7cfxq.', 'SUCCESS', 0, NULL, NULL, NULL, NULL, '2026-02-21 08:56:46', '2026-02-21 08:56:46'),
(702, 'Fonds reçus 💰', 0, 'Vous avez reçu 9$ de Mushio leaader.', 'SUCCESS', 0, NULL, NULL, NULL, NULL, '2026-02-21 08:56:46', '2026-02-21 08:56:46'),
(703, 'Abonnement activé 🎉', 0, '1$ a été déduit pour activer l’abonnement. Vous pouvez maintenant utiliser toutes les fonctionnalités.', 'INFO', 0, NULL, NULL, NULL, NULL, '2026-02-21 08:56:46', '2026-02-21 08:56:46'),
(704, 'Transfert envoyé ✅', 0, 'Vous avez transféré 10$ à user_7cfxq.', 'SUCCESS', 0, NULL, NULL, NULL, NULL, '2026-02-21 08:58:58', '2026-02-21 08:58:58'),
(705, 'Fonds reçus 💰', 0, 'Vous avez reçu 9$ de Mushio leaader.', 'SUCCESS', 0, NULL, NULL, NULL, NULL, '2026-02-21 08:58:58', '2026-02-21 08:58:58'),
(706, 'Abonnement activé 🎉', 0, '1$ a été déduit pour activer l’abonnement. Vous pouvez maintenant utiliser toutes les fonctionnalités.', 'INFO', 0, NULL, NULL, NULL, NULL, '2026-02-21 08:58:58', '2026-02-21 08:58:58'),
(707, 'Transfert envoyé ✅', 0, 'Vous avez transféré 10$ à user_3aunk.', 'SUCCESS', 0, NULL, NULL, NULL, NULL, '2026-02-21 09:08:54', '2026-02-21 09:08:54'),
(708, 'Fonds reçus 💰', 0, 'Vous avez reçu 9$ de Mushio leaader.', 'SUCCESS', 0, NULL, NULL, NULL, NULL, '2026-02-21 09:08:54', '2026-02-21 09:08:54'),
(709, 'Abonnement activé 🎉', 0, '1$ a été déduit pour activer l’abonnement. Vous pouvez maintenant utiliser toutes les fonctionnalités.', 'INFO', 0, NULL, NULL, NULL, NULL, '2026-02-21 09:08:54', '2026-02-21 09:08:54'),
(710, 'Recharge réussie ✅', 0, 'Votre compte a été crédité de 2$ — abonnement annuel activé (-1$).', 'SUCCESS', 0, NULL, NULL, NULL, NULL, '2026-02-21 09:11:29', '2026-02-21 09:11:29'),
(711, 'Profil mis à jour', 0, 'Votre profil a été mis à jour avec succès.', 'SUCCESS', 0, NULL, 6, NULL, NULL, '2026-02-21 09:19:42', '2026-02-21 09:19:42'),
(712, 'Recharge réussie ✅', 0, 'Votre compte a été crédité de 1$. Aucun frais prélevé.', 'SUCCESS', 0, NULL, NULL, NULL, NULL, '2026-02-21 09:22:28', '2026-02-21 09:22:28'),
(713, 'Échec de connexion', 0, 'Une tentative de connexion a échoué.', 'ERREUR', 0, NULL, 1, NULL, NULL, '2026-02-21 09:27:54', '2026-02-21 09:27:54'),
(714, 'Transfert envoyé ✅', 0, 'Vous avez transféré 10$ à Jerry.', 'SUCCESS', 0, NULL, NULL, NULL, NULL, '2026-02-21 09:28:18', '2026-02-21 09:28:18'),
(715, 'Fonds reçus 💰', 0, 'Vous avez reçu 10$ de Leader Mushio.', 'SUCCESS', 0, NULL, NULL, NULL, NULL, '2026-02-21 09:28:18', '2026-02-21 09:28:18'),
(716, 'Retrait réussi ✅', 0, 'Votre retrait de 10$ a été effectué.', 'SUCCESS', 0, NULL, NULL, NULL, NULL, '2026-02-21 09:37:56', '2026-02-21 09:37:56'),
(717, 'Nouveau retrait 💰', 0, 'Vous avez reçu un client pour 10$.', 'INFO', 0, NULL, NULL, NULL, NULL, '2026-02-21 09:37:56', '2026-02-21 09:37:56'),
(718, 'Frais retrait reçu 💰', 0, 'Frais de 0.2985$ crédité.', 'INFO', 0, NULL, NULL, NULL, NULL, '2026-02-21 09:37:56', '2026-02-21 09:37:56'),
(719, 'Retrait réussi ✅', 0, 'Votre retrait de 5$ a été effectué.', 'SUCCESS', 0, NULL, NULL, NULL, NULL, '2026-02-21 09:40:42', '2026-02-21 09:40:42'),
(720, 'Nouveau retrait 💰', 0, 'Vous avez reçu un client pour 5$.', 'INFO', 0, NULL, NULL, NULL, NULL, '2026-02-21 09:40:42', '2026-02-21 09:40:42'),
(721, 'Frais retrait reçu 💰', 0, 'Frais de 0.14925$ crédité.', 'INFO', 0, NULL, NULL, NULL, NULL, '2026-02-21 09:40:42', '2026-02-21 09:40:42'),
(722, 'Retrait réussi ✅', 0, 'Votre retrait de 20$ a été effectué. Frais: 0.6$ (total débité: 20.6$).', 'SUCCESS', 0, NULL, NULL, NULL, NULL, '2026-02-21 09:56:15', '2026-02-21 09:56:15'),
(723, 'Nouveau retrait 💰', 0, 'Vous avez reçu un retrait de 20$ + frais agent 0.003$.', 'INFO', 0, NULL, NULL, NULL, NULL, '2026-02-21 09:56:15', '2026-02-21 09:56:15'),
(724, 'Frais retrait reçu 💰', 0, 'Frais de 0.597$ crédité sur le compte BIM Bank.', 'INFO', 0, NULL, NULL, NULL, NULL, '2026-02-21 09:56:15', '2026-02-21 09:56:15'),
(725, 'Transfert envoyé ✅', 0, 'Vous avez transféré 2$ à Leader Mushio.', 'SUCCESS', 0, NULL, NULL, NULL, NULL, '2026-02-21 09:57:53', '2026-02-21 09:57:53'),
(726, 'Fonds reçus 💰', 0, 'Vous avez reçu 2$ de Jerry.', 'SUCCESS', 0, NULL, NULL, NULL, NULL, '2026-02-21 09:57:53', '2026-02-21 09:57:53'),
(727, 'Transfert envoyé ✅', 0, 'Vous avez transféré 10$ à john.', 'SUCCESS', 0, NULL, NULL, NULL, NULL, '2026-02-21 10:33:51', '2026-02-21 10:33:51'),
(728, 'Fonds reçus 💰', 0, 'Vous avez reçu 9$ de Leader Mushio.', 'SUCCESS', 0, NULL, NULL, NULL, NULL, '2026-02-21 10:33:51', '2026-02-21 10:33:51'),
(729, 'Abonnement activé 🎉', 0, '1$ a été déduit pour activer l’abonnement. Vous pouvez maintenant utiliser toutes les fonctionnalités.', 'INFO', 0, NULL, NULL, NULL, NULL, '2026-02-21 10:33:51', '2026-02-21 10:33:51'),
(730, 'Transfert envoyé ✅', 0, 'Vous avez transféré 10$ à user_4ekko.', 'SUCCESS', 0, NULL, NULL, NULL, NULL, '2026-02-21 10:54:11', '2026-02-21 10:54:11'),
(731, 'Fonds reçus 💰', 0, 'Vous avez reçu 10$ de Mushio leaader.', 'SUCCESS', 0, NULL, NULL, NULL, NULL, '2026-02-21 10:54:11', '2026-02-21 10:54:11'),
(732, 'Paiement réussi ✅', 0, 'Votre paiement de 1$ pour la commande ORD-1771671376699 a été effectué avec succès.', 'SUCCESS', 0, NULL, NULL, NULL, NULL, '2026-02-21 10:56:16', '2026-02-21 10:56:16'),
(733, 'Commande payée 🛒', 0, 'Une nouvelle commande ORD-1771671376699 a été payée.', 'INFO', 0, NULL, NULL, NULL, NULL, '2026-02-21 10:56:16', '2026-02-21 10:56:16'),
(734, 'Paiement réussi ✅', 0, 'Votre paiement de 10$ pour la commande ORD-1771671772799 a été effectué avec succès.', 'SUCCESS', 0, NULL, NULL, NULL, NULL, '2026-02-21 11:02:52', '2026-02-21 11:02:52'),
(735, 'Commande payée 🛒', 0, 'Une nouvelle commande ORD-1771671772799 a été payée.', 'INFO', 0, NULL, NULL, NULL, NULL, '2026-02-21 11:02:52', '2026-02-21 11:02:52'),
(738, 'Erreur', 0, 'Une erreur est survenue lors du traitement de votre demande.', 'ERREUR', 0, NULL, 7, NULL, NULL, '2026-02-21 15:03:23', '2026-02-21 15:03:23'),
(739, 'SUCCESS', 0, 'Une INFOS est survenue lors du traitement de votre demande.', 'ERREUR', 0, NULL, 7, NULL, NULL, '2026-02-21 15:07:21', '2026-02-21 15:07:21'),
(740, 'Transfert envoyé ✅', 0, 'Vous avez transféré 10$ à Jerry.', 'SUCCESS', 0, NULL, NULL, NULL, NULL, '2026-02-21 15:08:44', '2026-02-21 15:08:44'),
(741, 'Fonds reçus 💰', 0, 'Vous avez reçu 10$ de Mushio leaader.', 'SUCCESS', 0, NULL, NULL, NULL, NULL, '2026-02-21 15:08:44', '2026-02-21 15:08:44'),
(742, 'Retrait réussi ✅', 0, 'Votre retrait de 5$ a été effectué. Frais: 0.15$ (total débité: 5.15$).', 'SUCCESS', 0, NULL, NULL, NULL, NULL, '2026-02-21 15:16:36', '2026-02-21 15:16:36'),
(743, 'Nouveau retrait 💰', 0, 'Vous avez reçu un retrait de 5$ + frais agent 0.00075$.', 'INFO', 0, NULL, NULL, NULL, NULL, '2026-02-21 15:16:36', '2026-02-21 15:16:36'),
(744, 'Frais retrait reçu 💰', 0, 'Frais de 0.14925$ crédité sur le compte BIM Bank.', 'INFO', 0, NULL, NULL, NULL, NULL, '2026-02-21 15:16:36', '2026-02-21 15:16:36'),
(745, 'Retrait réussi ✅', 0, 'Votre retrait de 5$ a été effectué. Frais: 0.15$ (total débité: 5.15$).', 'SUCCESS', 0, NULL, 7, NULL, NULL, '2026-02-21 15:28:49', '2026-02-21 15:28:49'),
(746, 'Nouveau retrait 💰', 0, 'Vous avez reçu un retrait de 5$ + frais agent 0.00075$.', 'INFO', 0, NULL, 10, NULL, NULL, '2026-02-21 15:28:49', '2026-02-21 15:28:49'),
(747, 'Frais retrait reçu 💰', 0, 'Frais de 0.14925$ crédité sur le compte BIM Bank.', 'INFO', 0, NULL, 2, NULL, NULL, '2026-02-21 15:28:49', '2026-02-21 15:28:49'),
(748, 'Retrait réussi ✅', 0, 'Votre retrait de 5$ a été effectué. Frais: 0.15$ (total débité: 5.15$).', 'SUCCESS', 0, NULL, 7, NULL, NULL, '2026-02-21 15:32:16', '2026-02-21 15:32:16'),
(749, 'Nouveau retrait 💰', 0, 'Vous avez reçu un retrait de 5$ + frais agent 0.00075$.', 'INFO', 0, NULL, 10, NULL, NULL, '2026-02-21 15:32:16', '2026-02-21 15:32:16'),
(750, 'Frais retrait reçu 💰', 0, 'Frais de 0.14925$ crédité sur le compte BIM Bank.', 'INFO', 0, NULL, 2, NULL, NULL, '2026-02-21 15:32:16', '2026-02-21 15:32:16'),
(751, 'Recharge réussie ✅', 0, 'Votre compte a été crédité de 10$. Aucun frais prélevé.', 'SUCCESS', 0, NULL, NULL, NULL, NULL, '2026-02-21 15:39:17', '2026-02-21 15:39:17'),
(752, 'Recharge réussie ✅', 0, 'Votre compte a été crédité de 10$. Aucun frais prélevé.', 'SUCCESS', 0, NULL, NULL, NULL, NULL, '2026-02-21 15:41:43', '2026-02-21 15:41:43'),
(753, 'Recharge réussie ✅', 0, 'Votre compte a été crédité de 10$. Aucun frais prélevé.', 'SUCCESS', 0, NULL, NULL, NULL, NULL, '2026-02-21 15:46:28', '2026-02-21 15:46:28'),
(754, 'Transfert envoyé ✅', 0, 'Vous avez transféré 10$ à user_9gqpq.', 'SUCCESS', 0, NULL, 1, NULL, NULL, '2026-02-22 12:23:35', '2026-02-22 12:23:35'),
(755, 'Fonds reçus 💰', 0, 'Vous avez reçu 10$ de Leader Mushio.', 'SUCCESS', 0, NULL, 2, NULL, NULL, '2026-02-22 12:23:35', '2026-02-22 12:23:35'),
(756, 'Transfert envoyé ✅', 0, 'Vous avez transféré 10$ à john.', 'SUCCESS', 0, NULL, 7, NULL, NULL, '2026-02-22 13:07:07', '2026-02-22 13:07:07'),
(757, 'Fonds reçus 💰', 0, 'Vous avez reçu 9$ de Mushio leaader.', 'SUCCESS', 0, NULL, 3, NULL, NULL, '2026-02-22 13:07:07', '2026-02-22 13:07:07'),
(758, 'Abonnement activé 🎉', 0, '1$ a été déduit pour activer l’abonnement. Vous pouvez maintenant utiliser toutes les fonctionnalités.', 'INFO', 0, NULL, 3, NULL, NULL, '2026-02-22 13:07:07', '2026-02-22 13:07:07'),
(759, 'Paiement réussi ✅', 0, 'Votre paiement de 10$ pour la commande ORD-1771765651986 a été effectué avec succès.', 'SUCCESS', 0, NULL, 7, NULL, NULL, '2026-02-22 13:07:32', '2026-02-22 13:07:32'),
(760, 'Commande payée 🛒', 0, 'Une nouvelle commande ORD-1771765651986 a été payée.', 'INFO', 0, NULL, 2, NULL, NULL, '2026-02-22 13:07:32', '2026-02-22 13:07:32'),
(761, 'Échec de connexion', 0, 'Une tentative de connexion a échoué.', 'ERREUR', 0, NULL, 7, NULL, NULL, '2026-02-22 13:42:16', '2026-02-22 13:42:16'),
(762, 'Paiement réussi ✅', 0, 'Votre paiement de 10$ pour la commande ORD-1771769715496 a été effectué avec succès.', 'SUCCESS', 0, NULL, 7, NULL, NULL, '2026-02-22 14:15:15', '2026-02-22 14:15:15'),
(763, 'Commande payée 🛒', 0, 'Une nouvelle commande ORD-1771769715496 a été payée.', 'INFO', 0, NULL, 2, NULL, NULL, '2026-02-22 14:15:15', '2026-02-22 14:15:15'),
(764, 'Transfert envoyé ✅', 0, 'Vous avez transféré 2$ à Jerry.', 'SUCCESS', 0, NULL, 7, NULL, NULL, '2026-02-22 14:55:39', '2026-02-22 14:55:39'),
(765, 'Fonds reçus 💰', 0, 'Vous avez reçu 2$ de Mushio leaader.', 'SUCCESS', 0, NULL, 6, NULL, NULL, '2026-02-22 14:55:39', '2026-02-22 14:55:39'),
(766, 'Recharge réussie ✅', 0, 'Votre compte a été crédité de 1$. Aucun frais prélevé.', 'SUCCESS', 0, NULL, 7, NULL, NULL, '2026-02-22 15:34:47', '2026-02-22 15:34:47'),
(767, 'Paiement réussi ✅', 0, 'Votre paiement de 10$ pour la commande ORD-1771774570393 a été effectué avec succès.', 'SUCCESS', 0, NULL, 7, NULL, NULL, '2026-02-22 15:36:10', '2026-02-22 15:36:10'),
(768, 'Commande payée 🛒', 0, 'Une nouvelle commande ORD-1771774570393 a été payée.', 'INFO', 0, NULL, 2, NULL, NULL, '2026-02-22 15:36:10', '2026-02-22 15:36:10'),
(769, 'Paiement réussi ✅', 0, 'Votre paiement de 10$ pour la commande ORD-1771774632016 a été effectué avec succès.', 'SUCCESS', 0, NULL, 7, NULL, NULL, '2026-02-22 15:37:12', '2026-02-22 15:37:12'),
(770, 'Commande payée 🛒', 0, 'Une nouvelle commande ORD-1771774632016 a été payée.', 'INFO', 0, NULL, 2, NULL, NULL, '2026-02-22 15:37:12', '2026-02-22 15:37:12'),
(771, 'Retrait réussi ✅', 0, 'Votre retrait de 10$ a été effectué. Frais: 0.3$ (total débité: 10.3$).', 'SUCCESS', 0, NULL, 7, NULL, NULL, '2026-02-22 15:44:36', '2026-02-22 15:44:36'),
(772, 'Nouveau retrait 💰', 0, 'Vous avez reçu un retrait de 10$ + frais agent 0.0015$.', 'INFO', 0, NULL, 10, NULL, NULL, '2026-02-22 15:44:36', '2026-02-22 15:44:36'),
(773, 'Frais retrait reçu 💰', 0, 'Frais de 0.2985$ crédité sur le compte BIM Bank.', 'INFO', 0, NULL, 2, NULL, NULL, '2026-02-22 15:44:36', '2026-02-22 15:44:36'),
(774, 'Transfert envoyé ✅', 0, 'Vous avez transféré 10$ à Jerry.', 'SUCCESS', 0, NULL, 7, NULL, NULL, '2026-02-22 15:47:49', '2026-02-22 15:47:49'),
(775, 'Fonds reçus 💰', 0, 'Vous avez reçu 10$ de Mushio leaader.', 'SUCCESS', 0, NULL, 6, NULL, NULL, '2026-02-22 15:47:49', '2026-02-22 15:47:49'),
(776, 'Retrait réussi ✅', 0, 'Votre retrait de 10$ a été effectué. Frais: 0.3$ (total débité: 10.3$).', 'SUCCESS', 0, NULL, 7, NULL, NULL, '2026-02-22 16:22:36', '2026-02-22 16:22:36'),
(777, 'Nouveau retrait 💰', 0, 'Vous avez reçu un retrait de 10$ + frais agent 0.0015$.', 'INFO', 0, NULL, 10, NULL, NULL, '2026-02-22 16:22:36', '2026-02-22 16:22:36'),
(778, 'Frais retrait reçu 💰', 0, 'Frais de 0.2985$ crédité sur le compte BIM Bank.', 'INFO', 0, NULL, 2, NULL, NULL, '2026-02-22 16:22:36', '2026-02-22 16:22:36'),
(779, 'Paiement réussi ✅', 0, 'Votre paiement de 10$ pour la commande ORD-1771871158381 a été effectué avec succès.', 'SUCCESS', 0, NULL, 7, NULL, NULL, '2026-02-23 18:25:58', '2026-02-23 18:25:58'),
(780, 'Commande payée 🛒', 0, 'Une nouvelle commande ORD-1771871158381 a été payée.', 'INFO', 0, NULL, 2, NULL, NULL, '2026-02-23 18:25:58', '2026-02-23 18:25:58'),
(781, 'Transfert envoyé ✅', 0, 'Vous avez transféré 500 EC à Leader Mushio.', 'SUCCESS', 0, NULL, 7, NULL, NULL, '2026-02-23 18:30:41', '2026-02-23 18:30:41'),
(782, 'Fonds reçus 💰', 0, 'Vous avez reçu 500 EC de Mushio leaader.', 'SUCCESS', 0, NULL, 1, NULL, NULL, '2026-02-23 18:30:41', '2026-02-23 18:30:41'),
(783, 'Retrait réussi ✅', 0, 'Votre retrait de 10$ a été effectué. Frais: 0.3$ (total débité: 10.3$).', 'SUCCESS', 0, NULL, 7, NULL, NULL, '2026-02-23 18:32:48', '2026-02-23 18:32:48'),
(784, 'Nouveau retrait 💰', 0, 'Vous avez reçu un retrait de 10$ + frais agent 0.0015$.', 'INFO', 0, NULL, 10, NULL, NULL, '2026-02-23 18:32:48', '2026-02-23 18:32:48'),
(785, 'Frais retrait reçu 💰', 0, 'Frais de 0.2985$ crédité sur le compte BIM Bank.', 'INFO', 0, NULL, 2, NULL, NULL, '2026-02-23 18:32:48', '2026-02-23 18:32:48'),
(786, 'Transfert envoyé ✅', 0, 'Vous avez transféré 1.5 EC à Malo.', 'SUCCESS', 0, NULL, 7, NULL, NULL, '2026-02-23 18:40:47', '2026-02-23 18:40:47'),
(787, 'Fonds reçus 💰', 0, 'Vous avez reçu 1.5 EC de Mushio leaader.', 'SUCCESS', 0, NULL, 4, NULL, NULL, '2026-02-23 18:40:47', '2026-02-23 18:40:47'),
(788, 'Retrait réussi ✅', 0, 'Votre retrait de 5.5$ a été effectué. Frais: 0.165$ (total débité: 5.665$).', 'SUCCESS', 0, NULL, 7, NULL, NULL, '2026-02-23 18:50:45', '2026-02-23 18:50:45'),
(789, 'Nouveau retrait 💰', 0, 'Vous avez reçu un retrait de 5.5$ + frais agent 0.0008250000000000001$.', 'INFO', 0, NULL, 10, NULL, NULL, '2026-02-23 18:50:45', '2026-02-23 18:50:45'),
(790, 'Frais retrait reçu 💰', 0, 'Frais de 0.16417500000000002$ crédité sur le compte BIM Bank.', 'INFO', 0, NULL, 2, NULL, NULL, '2026-02-23 18:50:45', '2026-02-23 18:50:45'),
(791, 'Transfert envoyé ✅', 0, 'Vous avez transféré 1.8 EC à Leader Mushio.', 'SUCCESS', 0, NULL, 7, NULL, NULL, '2026-02-23 18:58:37', '2026-02-23 18:58:37'),
(792, 'Fonds reçus 💰', 0, 'Vous avez reçu 1.8 EC de Mushio leaader.', 'SUCCESS', 0, NULL, 1, NULL, NULL, '2026-02-23 18:58:37', '2026-02-23 18:58:37'),
(793, 'Profil mis à jour', 0, 'Votre profil a été mis à jour avec succès.', 'SUCCESS', 0, NULL, 7, NULL, NULL, '2026-02-23 19:13:40', '2026-02-23 19:13:40'),
(794, 'Transfert envoyé ✅', 0, 'Vous avez transféré 10 EC à john.', 'SUCCESS', 0, NULL, 7, NULL, NULL, '2026-02-23 19:44:39', '2026-02-23 19:44:39'),
(795, 'Fonds reçus 💰', 0, 'Vous avez reçu 9 EC de Mushio leaader.', 'SUCCESS', 0, NULL, 3, NULL, NULL, '2026-02-23 19:44:39', '2026-02-23 19:44:39'),
(796, 'Abonnement activé 🎉', 0, '1 EC a été déduit pour activer votre abonnement.', 'INFO', 0, NULL, 3, NULL, NULL, '2026-02-23 19:44:39', '2026-02-23 19:44:39'),
(797, 'Transfert envoyé ✅', 0, 'Vous avez transféré 1.5 EC à user_4ekko.', 'SUCCESS', 0, NULL, 7, NULL, NULL, '2026-02-23 20:18:13', '2026-02-23 20:18:13'),
(798, 'Fonds reçus 💰', 0, 'Vous avez reçu 1.5 EC de Mushio leaader.', 'SUCCESS', 0, NULL, 5, NULL, NULL, '2026-02-23 20:18:13', '2026-02-23 20:18:13'),
(799, 'Paiement réussi ✅', 0, 'Votre paiement de 10 EC pour la commande ORD-1771962092654 a été effectué.', 'SUCCESS', 0, NULL, 7, NULL, NULL, '2026-02-24 19:41:32', '2026-02-24 19:41:32'),
(800, 'Commande payée 🛒', 0, 'Une nouvelle commande ORD-1771962092654 a été payée.', 'INFO', 0, NULL, 2, NULL, NULL, '2026-02-24 19:41:32', '2026-02-24 19:41:32'),
(801, 'Paiement réussi ✅', 0, 'Votre paiement de 20 EC pour la commande ORD-1771962510864 a été effectué.', 'SUCCESS', 0, NULL, 7, NULL, NULL, '2026-02-24 19:48:30', '2026-02-24 19:48:30'),
(802, 'Commande payée 🛒', 0, 'Une nouvelle commande ORD-1771962510864 a été payée.', 'INFO', 0, NULL, 2, NULL, NULL, '2026-02-24 19:48:30', '2026-02-24 19:48:30'),
(803, 'Paiement réussi ✅', 0, 'Votre paiement de 10 EC pour la commande ORD-1771962531552 a été effectué.', 'SUCCESS', 0, NULL, 7, NULL, NULL, '2026-02-24 19:48:51', '2026-02-24 19:48:51'),
(804, 'Commande payée 🛒', 0, 'Une nouvelle commande ORD-1771962531552 a été payée.', 'INFO', 0, NULL, 2, NULL, NULL, '2026-02-24 19:48:51', '2026-02-24 19:48:51'),
(805, 'Paiement réussi ✅', 0, 'Votre paiement de 5.5 EC pour la commande ORD-1771962714159 a été effectué.', 'SUCCESS', 0, NULL, 7, NULL, NULL, '2026-02-24 19:51:54', '2026-02-24 19:51:54'),
(806, 'Commande payée 🛒', 0, 'Une nouvelle commande ORD-1771962714159 a été payée.', 'INFO', 0, NULL, 2, NULL, NULL, '2026-02-24 19:51:54', '2026-02-24 19:51:54'),
(807, 'Retrait réussi ✅', 0, 'Votre retrait de 20$ a été effectué. Frais: 0.6$ (total débité: 20.6$).', 'SUCCESS', 0, NULL, 7, NULL, NULL, '2026-02-24 20:21:05', '2026-02-24 20:21:05'),
(808, 'Nouveau retrait 💰', 0, 'Vous avez reçu un retrait de 20$ + frais agent 0.003$.', 'INFO', 0, NULL, 10, NULL, NULL, '2026-02-24 20:21:05', '2026-02-24 20:21:05'),
(809, 'Frais retrait reçu 💰', 0, 'Frais de 0.597$ crédité sur le compte BIM Bank.', 'INFO', 0, NULL, 2, NULL, NULL, '2026-02-24 20:21:05', '2026-02-24 20:21:05'),
(810, 'Retrait réussi ✅', 0, 'Votre retrait de 20.5$ a été effectué. Frais: 0.615$ (total débité: 21.115$).', 'SUCCESS', 0, NULL, 7, NULL, NULL, '2026-02-24 20:21:19', '2026-02-24 20:21:19'),
(811, 'Nouveau retrait 💰', 0, 'Vous avez reçu un retrait de 20.5$ + frais agent 0.003075$.', 'INFO', 0, NULL, 10, NULL, NULL, '2026-02-24 20:21:19', '2026-02-24 20:21:19'),
(812, 'Frais retrait reçu 💰', 0, 'Frais de 0.6119249999999999$ crédité sur le compte BIM Bank.', 'INFO', 0, NULL, 2, NULL, NULL, '2026-02-24 20:21:19', '2026-02-24 20:21:19');

-- --------------------------------------------------------

--
-- Structure de la table `orders`
--

CREATE TABLE `orders` (
  `orderId` int(11) NOT NULL,
  `orderNumber` varchar(100) NOT NULL,
  `userId` int(11) DEFAULT NULL,
  `companyId` int(11) NOT NULL,
  `productId` int(11) NOT NULL,
  `branchTrackId` int(11) DEFAULT NULL,
  `totalAmount` decimal(10,2) NOT NULL,
  `status` enum('pending','confirmed','paid','processing','shipped','delivered','cancelled') NOT NULL DEFAULT 'pending',
  `paymentMethod` varchar(50) DEFAULT NULL,
  `shippingAddress` text NOT NULL,
  `notes` text DEFAULT NULL,
  `createdAt` datetime NOT NULL,
  `updatedAt` datetime NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Déchargement des données de la table `orders`
--

INSERT INTO `orders` (`orderId`, `orderNumber`, `userId`, `companyId`, `productId`, `branchTrackId`, `totalAmount`, `status`, `paymentMethod`, `shippingAddress`, `notes`, `createdAt`, `updatedAt`) VALUES
(1, 'ORD-1771170994610', 1, 8, 1, NULL, 100.00, 'paid', 'BIM NEXT APP', 'Vers BIM, adresse officielle', 'Paiement produit', '2026-02-15 15:56:34', '2026-02-15 15:56:34'),
(2, 'ORD-1771171272432', 1, 8, 1, NULL, 100.00, 'paid', 'BIM NEXT APP', 'Vers BIM, adresse officielle', 'Paiement produit', '2026-02-15 16:01:12', '2026-02-15 16:01:12'),
(3, 'ORD-1771171402442', 1, 8, 1, NULL, 100.00, 'paid', 'BIM NEXT APP', 'Vers BIM, adresse officielle', 'Paiement produit', '2026-02-15 16:03:22', '2026-02-15 16:03:22'),
(4, 'ORD-1771171454531', 1, 8, 1, NULL, 100.00, 'paid', 'BIM NEXT APP', 'Vers BIM, adresse officielle', 'Paiement produit', '2026-02-15 16:04:14', '2026-02-15 16:04:14'),
(5, 'ORD-1771171557310', 1, 8, 1, NULL, 100.00, 'paid', 'BIM NEXT APP', 'Vers BIM, adresse officielle', 'Paiement produit', '2026-02-15 16:05:57', '2026-02-15 16:05:57'),
(6, 'ORD-1771171824276', 1, 8, 1, NULL, 100.00, 'paid', 'BIM NEXT APP', 'Vers BIM, adresse officielle', 'Paiement produit', '2026-02-15 16:10:24', '2026-02-15 16:10:24'),
(7, 'ORD-1771172244260', 1, 8, 1, NULL, 100.00, 'paid', 'BIM NEXT APP', 'Vers BIM, adresse officielle', 'Paiement produit', '2026-02-15 16:17:24', '2026-02-15 16:17:24'),
(8, 'ORD-1771172373660', 1, 8, 1, NULL, 100.00, 'paid', 'BIM NEXT APP', 'Vers BIM, adresse officielle', 'Paiement produit', '2026-02-15 16:19:33', '2026-02-15 16:19:33'),
(9, 'ORD-1771172696166', 1, 8, 1, NULL, 100.00, 'paid', 'BIM NEXT APP', 'Vers BIM, adresse officielle', 'Paiement produit', '2026-02-15 16:24:56', '2026-02-15 16:24:56'),
(10, 'ORD-1771174416878', 1, 13, 16, NULL, 80.00, 'paid', 'BIM NEXT APP', 'Vers BIM, adresse officielle', 'Paiement produit', '2026-02-15 16:53:36', '2026-02-15 16:53:36'),
(11, 'ORD-1771179602282', 5, 8, 1, NULL, 100.00, 'paid', 'BIM NEXT APP', 'Vers BIM, adresse officielle', 'Paiement produit', '2026-02-15 18:20:02', '2026-02-15 18:20:02'),
(12, 'ORD-1771179749270', 5, 13, 16, NULL, 80.00, 'paid', 'BIM NEXT APP', 'Vers BIM, adresse officielle', 'Paiement produit', '2026-02-15 18:22:29', '2026-02-15 18:22:29'),
(13, 'ORD-1771179901635', 5, 9, 8, NULL, 30.00, 'paid', 'BIM NEXT APP', 'Vers BIM, adresse officielle', 'Paiement produit', '2026-02-15 18:25:01', '2026-02-15 18:25:01'),
(14, 'ORD-1771480593517', 1, 8, 1, NULL, 100.00, 'paid', 'BIM NEXT APP', 'Vers BIM, adresse officielle', 'Paiement produit', '2026-02-19 05:56:33', '2026-02-19 05:56:33'),
(15, 'ORD-1771563100707', 1, 8, 1, NULL, 100.00, 'paid', 'BIM NEXT APP', 'Vers BIM, adresse officielle', 'Paiement produit', '2026-02-20 04:51:40', '2026-02-20 04:51:40'),
(16, 'ORD-1771568905511', 1, 10, 11, NULL, 10.00, 'paid', 'BIM NEXT APP', 'Vers BIM, adresse officielle', 'Paiement produit', '2026-02-20 06:28:25', '2026-02-20 06:28:25'),
(17, 'ORD-1771575237091', 1, 8, 1, NULL, 100.00, 'paid', 'BIM NEXT APP', 'Vers BIM, adresse officielle', 'Paiement produit', '2026-02-20 08:13:57', '2026-02-20 08:13:57'),
(18, 'ORD-1771671376699', 7, 9, 8, NULL, 1.00, 'paid', 'BIM NEXT APP', 'Vers BIM, adresse officielle', 'Paiement produit', '2026-02-21 10:56:16', '2026-02-21 10:56:16'),
(19, 'ORD-1771671772799', 7, 11, 12, NULL, 10.00, 'paid', 'BIM NEXT APP', 'Vers BIM, adresse officielle', 'Paiement produit', '2026-02-21 11:02:52', '2026-02-21 11:02:52'),
(20, 'ORD-1771765651986', 7, 8, 1, NULL, 10.00, 'paid', 'BIM NEXT APP', 'Vers BIM, adresse officielle', 'Paiement produit', '2026-02-22 13:07:31', '2026-02-22 13:07:31'),
(21, 'ORD-1771769715496', 7, 8, 1, NULL, 10.00, 'paid', 'BIM NEXT APP', 'Vers BIM, adresse officielle', 'Paiement produit', '2026-02-22 14:15:15', '2026-02-22 14:15:15'),
(22, 'ORD-1771774570393', 7, 9, 8, NULL, 10.00, 'paid', 'BIM NEXT APP', 'Vers BIM, adresse officielle', 'Paiement produit', '2026-02-22 15:36:10', '2026-02-22 15:36:10'),
(23, 'ORD-1771774632016', 7, 9, 8, NULL, 10.00, 'paid', 'BIM NEXT APP', 'Vers BIM, adresse officielle', 'Paiement produit', '2026-02-22 15:37:12', '2026-02-22 15:37:12'),
(24, 'ORD-1771871158381', 7, 13, 16, NULL, 10.00, 'paid', 'BIM NEXT APP', 'Vers BIM, adresse officielle', 'Paiement produit', '2026-02-23 18:25:58', '2026-02-23 18:25:58'),
(25, 'ORD-1771962092654', 7, 8, 1, NULL, 10.00, 'paid', 'BIM NEXT APP', 'Vers BIM, adresse officielle', 'Paiement produit', '2026-02-24 19:41:32', '2026-02-24 19:41:32'),
(26, 'ORD-1771962510864', 7, 8, 1, NULL, 20.00, 'paid', 'BIM NEXT APP', 'Vers BIM, adresse officielle', 'Paiement produit', '2026-02-24 19:48:30', '2026-02-24 19:48:30'),
(27, 'ORD-1771962531552', 7, 11, 12, NULL, 10.00, 'paid', 'BIM NEXT APP', 'Vers BIM, adresse officielle', 'Paiement produit', '2026-02-24 19:48:51', '2026-02-24 19:48:51'),
(28, 'ORD-1771962714159', 7, 11, 12, NULL, 5.50, 'paid', 'BIM NEXT APP', 'Vers BIM, adresse officielle', 'Paiement produit', '2026-02-24 19:51:54', '2026-02-24 19:51:54');

-- --------------------------------------------------------

--
-- Structure de la table `products`
--

CREATE TABLE `products` (
  `productId` int(11) NOT NULL,
  `name` varchar(200) NOT NULL,
  `price` decimal(10,2) NOT NULL,
  `description` text NOT NULL,
  `TVA` decimal(5,2) DEFAULT NULL,
  `EAN` varchar(50) DEFAULT NULL,
  `qty` int(11) NOT NULL,
  `threshold` int(11) DEFAULT NULL,
  `expiredAt` datetime DEFAULT NULL,
  `availability` varchar(50) DEFAULT NULL,
  `imageUrl` varchar(255) DEFAULT NULL,
  `currencyId` int(11) NOT NULL,
  `commerceId` int(11) DEFAULT NULL,
  `branchTrackId` int(11) DEFAULT NULL,
  `createdAt` datetime NOT NULL,
  `updatedAt` datetime NOT NULL,
  `Warning` varchar(400) DEFAULT NULL,
  `companyId` int(11) DEFAULT NULL,
  `unityMesure` text DEFAULT NULL,
  `reduction` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Déchargement des données de la table `products`
--

INSERT INTO `products` (`productId`, `name`, `price`, `description`, `TVA`, `EAN`, `qty`, `threshold`, `expiredAt`, `availability`, `imageUrl`, `currencyId`, `commerceId`, `branchTrackId`, `createdAt`, `updatedAt`, `Warning`, `companyId`, `unityMesure`, `reduction`) VALUES
(1, 'BIM ACCÈS : 200$/AN', 200.00, 'Est un package individuel valable une année.\nIl prend en charge les maladies courantes : Paludisme, fièvre Typhoïde, grippe, blessures, brûlures, fractures légère.\nServices offerts : Fiche de consultation, soins infirmiers, examens de laboratoire liés aux pathologies prises en charge, médicaments génériques, hospitalisation à 50%.', NULL, NULL, 10, NULL, '2026-12-31 00:00:00', NULL, NULL, 1, NULL, NULL, '2026-02-12 09:23:45', '2026-02-12 09:23:45', NULL, 8, 'Package', NULL),
(2, 'BIM FAMILY : 400$/AN', 400.00, 'Est un package familial valable également une année, qui comprend 4 personnes, papa, maman et deux enfants.\nIl prend en charge les maladies courantes : Paludisme, fièvre typhoïde, grippe, blessures, brûlures, fractures légère.\nServices offerts : Fiche de consultation, soins infirmiers, examens de laboratoire liés aux pathologies prises en charge, médicaments génériques, hospitalisation à 50%.', NULL, NULL, 10, NULL, '2026-12-31 00:00:00', NULL, NULL, 1, NULL, NULL, '2026-02-12 09:23:45', '2026-02-12 09:23:45', NULL, 8, 'Package', NULL),
(3, 'BIM FULL FAMILY : 1000$/AN', 1000.00, 'Est un package pour une grande famille composé de 10 personnes valable une année.\nIl prend en charge les maladies courantes : Paludisme, fièvre typhoïde, grippe, blessures, brûlures, fractures légère.\nServices offerts : Fiche de consultation, soins infirmiers, examens de laboratoire liés aux pathologies prises en charge, médicaments génériques, hospitalisation à 50%.', NULL, NULL, 10, NULL, '2026-12-31 00:00:00', NULL, NULL, 1, NULL, NULL, '2026-02-12 09:23:45', '2026-02-12 09:23:45', NULL, 8, 'Package', NULL),
(8, 'Essence - 3000 FC', 1.32, 'Carburant de type Essence destiné aux véhicules à moteur essence. Assure une combustion optimale, de bonnes performances et une consommation maîtrisée. Produit conforme aux normes de qualité en vigueur.', NULL, NULL, 10, NULL, '2026-12-31 00:00:00', NULL, NULL, 1, NULL, NULL, '2026-02-12 18:45:05', '2026-02-12 18:45:05', NULL, 9, 'Litre', NULL),
(9, 'Mazout - 3200 FC', 1.41, 'Carburant de type Mazout (Diesel) conçu pour les véhicules et moteurs diesel. Offre une bonne performance énergétique et contribue à la protection du moteur lorsqu’il est utilisé conformément aux recommandations du constructeur.', NULL, NULL, 10, NULL, '2026-12-31 00:00:00', NULL, NULL, 1, NULL, NULL, '2026-02-12 18:45:05', '2026-02-12 18:45:05', NULL, 9, 'Litre', NULL),
(10, 'Essence - 2900 FC', 1.28, 'Carburant Essence destiné aux véhicules légers et motos fonctionnant à l’essence. Garantit un bon rendement moteur et une combustion efficace. Distribué selon les standards de qualité de la station.', NULL, NULL, 10, NULL, '2026-12-31 00:00:00', NULL, NULL, 1, NULL, NULL, '2026-02-12 18:45:05', '2026-02-12 18:45:05', NULL, 10, 'Litre', NULL),
(11, 'Mazout - 3100 FC', 1.36, 'Carburant de type Mazout (Diesel) destiné aux véhicules et moteurs diesel. Assure une performance énergétique stable, une bonne combustion et contribue à la longévité du moteur lorsqu’il est utilisé conformément aux normes recommandées.', NULL, NULL, 10, NULL, '2026-12-31 00:00:00', NULL, NULL, 1, NULL, NULL, '2026-02-12 18:45:05', '2026-02-12 18:45:05', NULL, 10, 'Litre', NULL),
(12, 'Recharge gaz 12 Kg', 25.00, 'Recharge de gaz domestique (GPL) de 12 Kg destinée à un usage ménager : cuisson et autres besoins domestiques. Produit contrôlé et conforme aux normes de sécurité en vigueur, garantissant une combustion propre et efficace.', NULL, NULL, 10, NULL, '2026-12-31 00:00:00', NULL, NULL, 1, NULL, NULL, '2026-02-12 18:52:54', '2026-02-12 18:52:54', NULL, 11, 'Kg', NULL),
(13, 'Recharge gaz 6 Kg', 11.00, 'Recharge de gaz domestique (GPL) de 6 Kg adaptée aux petits ménages et usages domestiques. Offre une combustion stable et performante pour la cuisson quotidienne.', NULL, NULL, 10, NULL, '2026-12-31 00:00:00', NULL, NULL, 1, NULL, NULL, '2026-02-12 18:52:54', '2026-02-12 18:52:54', NULL, 11, 'Kg', NULL),
(14, 'Recharge gaz 6 Kg', 11.00, 'Recharge de gaz domestique (GPL) de 6 Kg destinée aux besoins ménagers. Produit fiable assurant une bonne performance énergétique et une utilisation sécurisée lorsqu’il est correctement installé.', NULL, NULL, 10, NULL, '2026-12-31 00:00:00', NULL, NULL, 1, NULL, NULL, '2026-02-12 18:52:54', '2026-02-12 18:52:54', NULL, 12, 'Kg', NULL),
(15, 'Recharge gaz 12 Kg', 28.00, 'Recharge de gaz domestique (GPL) de 12 Kg pour usage résidentiel ou commercial léger. Assure une combustion efficace et constante pour les activités de cuisine et autres usages énergétiques.', NULL, NULL, 10, NULL, '2026-12-31 00:00:00', NULL, NULL, 1, NULL, NULL, '2026-02-12 18:52:54', '2026-02-12 18:52:54', NULL, 12, 'Kg', NULL),
(16, 'Chambre Standard', 80.00, 'Chambre Standard confortable idéale pour un séjour professionnel ou touristique. Équipée d’un lit confortable, salle de bain privée, télévision, climatisation et connexion Wi-Fi. Petit-déjeuner non inclus.', NULL, NULL, 10, NULL, '2026-12-31 00:00:00', NULL, NULL, 1, NULL, NULL, '2026-02-12 19:00:08', '2026-02-12 19:00:08', NULL, 13, 'Nuit', NULL),
(17, 'Chambre VIP', 150.00, 'Chambre VIP spacieuse et luxueuse offrant un confort supérieur. Comprend un grand lit, salon privé, salle de bain moderne, climatisation, Wi-Fi, télévision écran plat et petit-déjeuner inclus.', NULL, NULL, 10, NULL, '2026-12-31 00:00:00', NULL, NULL, 1, NULL, NULL, '2026-02-12 19:00:08', '2026-02-12 19:00:08', NULL, 13, 'Nuit', NULL),
(18, 'Appartement', 300.00, 'Appartement meublé haut standing adapté aux longs séjours. Comprend chambre(s), salon, cuisine équipée, salle de bain moderne, climatisation et Wi-Fi. Idéal pour familles ou séjours prolongés.', NULL, NULL, 10, NULL, '2026-12-31 00:00:00', NULL, NULL, 1, NULL, NULL, '2026-02-12 19:00:08', '2026-02-12 19:00:08', NULL, 13, 'Nuit', NULL),
(19, 'Chambre Standard', 45.00, 'Chambre Standard économique offrant un confort simple et fonctionnel. Équipée d’un lit, salle de bain privée et ventilation. Convient pour courts séjours à prix abordable.', NULL, NULL, 10, NULL, '2026-12-31 00:00:00', NULL, NULL, 1, NULL, NULL, '2026-02-12 19:00:08', '2026-02-12 19:00:08', NULL, 14, 'Nuit', NULL),
(20, 'Chambre Semi-VIP', 70.00, 'Chambre Semi-VIP confortable offrant un niveau de standing supérieur à la chambre standard. Équipée d’un grand lit, salle de bain moderne, climatisation, télévision et connexion Wi-Fi. Idéale pour un séjour confortable à prix modéré.', NULL, NULL, 10, NULL, '2026-12-31 00:00:00', NULL, NULL, 1, NULL, NULL, '2026-02-12 19:00:39', '2026-02-12 19:00:39', NULL, 14, 'Nuit', NULL),
(21, 'Chambre VIP', 90.00, 'Chambre VIP spacieuse et élégante offrant un confort haut de gamme. Comprend un grand lit, climatisation, télévision écran plat, Wi-Fi, salle de bain moderne et espace détente. Parfaite pour un séjour premium.', NULL, NULL, 10, NULL, '2026-12-31 00:00:00', NULL, NULL, 1, NULL, NULL, '2026-02-12 19:00:39', '2026-02-12 19:00:39', NULL, 14, 'Nuit', NULL);

-- --------------------------------------------------------

--
-- Structure de la table `product_categories`
--

CREATE TABLE `product_categories` (
  `productId` int(11) NOT NULL,
  `categoryId` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Structure de la table `product_solds`
--

CREATE TABLE `product_solds` (
  `id` int(11) NOT NULL,
  `productId` int(11) NOT NULL,
  `name` varchar(200) DEFAULT NULL,
  `priceOfSelling` decimal(10,2) NOT NULL,
  `priceAfterCredit` decimal(10,2) NOT NULL,
  `benefice` decimal(10,2) NOT NULL,
  `qty` int(11) NOT NULL,
  `threshold` int(11) DEFAULT NULL,
  `availability` varchar(50) DEFAULT NULL,
  `commerceId` int(11) DEFAULT NULL,
  `branchTrackId` int(11) DEFAULT NULL,
  `currencyId` int(11) NOT NULL,
  `createdAt` datetime NOT NULL,
  `updatedAt` datetime NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Structure de la table `redevtracks`
--

CREATE TABLE `redevtracks` (
  `id` int(11) NOT NULL,
  `productId` int(11) NOT NULL,
  `customerName` varchar(150) NOT NULL COMMENT 'Nom du client qui a pris le crédit',
  `amountLeft` decimal(10,2) NOT NULL COMMENT 'Montant restant du crédit',
  `description` text DEFAULT NULL,
  `commerceId` int(11) DEFAULT NULL,
  `branchTrackId` int(11) DEFAULT NULL,
  `dueDate` datetime NOT NULL COMMENT 'Date limite de paiement pour le crédit',
  `status` enum('EN_COURS','PAYE','EN_RETARD') DEFAULT 'EN_COURS' COMMENT 'Statut du crédit',
  `alertSent` tinyint(1) DEFAULT 0 COMMENT 'Indique si une alerte a été envoyée pour ce crédit',
  `createdAt` datetime NOT NULL,
  `updatedAt` datetime NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Structure de la table `roles`
--

CREATE TABLE `roles` (
  `id` int(11) NOT NULL,
  `name` varchar(100) NOT NULL COMMENT 'Nom unique du rôle',
  `description` varchar(255) DEFAULT NULL COMMENT 'Description du rôle',
  `createdAt` datetime NOT NULL,
  `updatedAt` datetime NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Structure de la table `supportTracks`
--

CREATE TABLE `supportTracks` (
  `supportTrackId` int(11) NOT NULL,
  `sujet` varchar(150) DEFAULT NULL COMMENT 'Sujet du ticket de support',
  `email` varchar(150) NOT NULL COMMENT 'Email de l’utilisateur',
  `description` varchar(500) NOT NULL COMMENT 'Description du problème ou demande',
  `imageUrl` varchar(255) DEFAULT NULL COMMENT 'URL d’une image associée au ticket',
  `commerceId` int(11) DEFAULT NULL,
  `branchTrackId` int(11) DEFAULT NULL,
  `id` int(11) NOT NULL,
  `createdAt` datetime NOT NULL,
  `updatedAt` datetime NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Déchargement des données de la table `supportTracks`
--

INSERT INTO `supportTracks` (`supportTrackId`, `sujet`, `email`, `description`, `imageUrl`, `commerceId`, `branchTrackId`, `id`, `createdAt`, `updatedAt`) VALUES
(1, 'Problème de connexion', 'leadermushio377@gmail.com', 'Hello jahshshhsd\n\n', '/images/1771145351525-396759379.png', NULL, NULL, 1, '2026-02-15 08:49:14', '2026-02-15 08:49:14');

-- --------------------------------------------------------

--
-- Structure de la table `transactions`
--

CREATE TABLE `transactions` (
  `transactionId` int(11) NOT NULL,
  `amount` float NOT NULL COMMENT 'Montant de la transaction',
  `status` enum('réussi','échoué','en attente','annuler') DEFAULT 'réussi' COMMENT 'Statut de la transaction',
  `description` varchar(255) DEFAULT NULL COMMENT 'Description ou commentaire de la transaction',
  `transactionType` enum('retrait','recharge','transfert','paiement') DEFAULT 'paiement' COMMENT 'Type de transaction',
  `transactionDate` datetime DEFAULT NULL COMMENT 'Date de la transaction',
  `id` int(11) NOT NULL COMMENT 'Référence de l’utilisateur',
  `branchTrackId` int(11) DEFAULT NULL COMMENT 'Référence du suivi de branche',
  `commerceId` int(11) DEFAULT NULL COMMENT 'Référence du commerce',
  `createdAt` datetime NOT NULL,
  `updatedAt` datetime NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Déchargement des données de la table `transactions`
--

INSERT INTO `transactions` (`transactionId`, `amount`, `status`, `description`, `transactionType`, `transactionDate`, `id`, `branchTrackId`, `commerceId`, `createdAt`, `updatedAt`) VALUES
(2, 10, 'réussi', 'Retrait effectué avec succès', 'retrait', '2026-02-15 07:56:23', 1, NULL, NULL, '2026-02-15 07:56:23', '2026-02-15 07:56:23'),
(3, 9, 'réussi', 'Retrait effectué avec succès', 'retrait', '2026-02-15 08:08:21', 1, NULL, NULL, '2026-02-15 08:08:21', '2026-02-15 08:08:21'),
(4, 20, 'réussi', 'Retrait effectué avec succès', 'retrait', '2026-02-15 08:19:42', 1, NULL, NULL, '2026-02-15 08:19:42', '2026-02-15 08:19:42'),
(5, 100, 'réussi', 'Retrait effectué avec succès', 'retrait', '2026-02-15 18:14:15', 5, NULL, NULL, '2026-02-15 18:14:15', '2026-02-15 18:14:15'),
(6, 50, 'réussi', 'Retrait effectué avec succès', 'retrait', '2026-02-15 18:15:46', 5, NULL, NULL, '2026-02-15 18:15:46', '2026-02-15 18:15:46'),
(7, 100, 'réussi', 'Retrait effectué avec succès', 'retrait', '2026-02-15 18:16:03', 5, NULL, NULL, '2026-02-15 18:16:03', '2026-02-15 18:16:03'),
(8, 10, 'réussi', 'Retrait effectué avec succès', 'retrait', '2026-02-21 09:37:56', 6, NULL, NULL, '2026-02-21 09:37:56', '2026-02-21 09:37:56'),
(9, 5, 'réussi', 'Retrait effectué avec succès', 'retrait', '2026-02-21 09:40:41', 6, NULL, NULL, '2026-02-21 09:40:41', '2026-02-21 09:40:41'),
(10, 20, 'réussi', 'Retrait effectué avec succès', 'retrait', '2026-02-21 09:56:15', 6, NULL, NULL, '2026-02-21 09:56:15', '2026-02-21 09:56:15'),
(11, 5, 'réussi', 'Retrait effectué avec succès', 'retrait', '2026-02-21 15:16:36', 7, NULL, NULL, '2026-02-21 15:16:36', '2026-02-21 15:16:36'),
(12, 5, 'réussi', 'Retrait effectué avec succès', 'retrait', '2026-02-21 15:28:49', 7, NULL, NULL, '2026-02-21 15:28:49', '2026-02-21 15:28:49'),
(13, 5, 'réussi', 'Retrait effectué avec succès', 'retrait', '2026-02-21 15:32:16', 7, NULL, NULL, '2026-02-21 15:32:16', '2026-02-21 15:32:16'),
(14, 10, 'réussi', 'Retrait effectué avec succès', 'retrait', '2026-02-22 15:44:36', 7, NULL, NULL, '2026-02-22 15:44:36', '2026-02-22 15:44:36'),
(15, 10, 'réussi', 'Retrait effectué avec succès', 'retrait', '2026-02-22 16:22:36', 7, NULL, NULL, '2026-02-22 16:22:36', '2026-02-22 16:22:36'),
(16, 10, 'réussi', 'Retrait effectué avec succès', 'retrait', '2026-02-23 18:32:48', 7, NULL, NULL, '2026-02-23 18:32:48', '2026-02-23 18:32:48'),
(20, 5.5, 'réussi', 'Retrait effectué avec succès', 'retrait', '2026-02-23 18:50:45', 7, NULL, NULL, '2026-02-23 18:50:45', '2026-02-23 18:50:45'),
(21, 10, 'réussi', 'Transfert envoyé à john', 'transfert', '2026-02-23 19:44:39', 7, NULL, NULL, '2026-02-23 19:44:39', '2026-02-23 19:44:39'),
(22, 9, 'réussi', 'Transfert reçu de Mushio leaader', 'transfert', '2026-02-23 19:44:39', 3, NULL, NULL, '2026-02-23 19:44:39', '2026-02-23 19:44:39'),
(23, 1.5, 'réussi', 'Transfert envoyé à user_4ekko', 'transfert', '2026-02-23 20:18:13', 7, NULL, NULL, '2026-02-23 20:18:13', '2026-02-23 20:18:13'),
(24, 1.5, 'réussi', 'Transfert reçu de Mushio leaader', 'transfert', '2026-02-23 20:18:13', 5, NULL, NULL, '2026-02-23 20:18:13', '2026-02-23 20:18:13'),
(25, 10, 'réussi', 'Paiement commande ORD-1771962092654 — BIM ACCÈS : 200$/AN', 'paiement', '2026-02-24 19:41:32', 7, NULL, NULL, '2026-02-24 19:41:32', '2026-02-24 19:41:32'),
(26, 10, 'réussi', 'Réception paiement commande ORD-1771962092654', 'paiement', '2026-02-24 19:41:32', 2, NULL, NULL, '2026-02-24 19:41:32', '2026-02-24 19:41:32'),
(27, 20, 'réussi', 'Paiement commande ORD-1771962510864 — BIM ACCÈS : 200$/AN', 'paiement', '2026-02-24 19:48:30', 7, NULL, NULL, '2026-02-24 19:48:30', '2026-02-24 19:48:30'),
(28, 20, 'réussi', 'Réception paiement commande ORD-1771962510864', 'paiement', '2026-02-24 19:48:30', 2, NULL, NULL, '2026-02-24 19:48:30', '2026-02-24 19:48:30'),
(29, 10, 'réussi', 'Paiement commande ORD-1771962531552 — Recharge gaz 12 Kg', 'paiement', '2026-02-24 19:48:51', 7, NULL, NULL, '2026-02-24 19:48:51', '2026-02-24 19:48:51'),
(30, 10, 'réussi', 'Réception paiement commande ORD-1771962531552', 'paiement', '2026-02-24 19:48:51', 2, NULL, NULL, '2026-02-24 19:48:51', '2026-02-24 19:48:51'),
(31, 5.5, 'réussi', 'Paiement commande ORD-1771962714159 — Recharge gaz 12 Kg', 'paiement', '2026-02-24 19:51:54', 7, NULL, NULL, '2026-02-24 19:51:54', '2026-02-24 19:51:54'),
(32, 5.5, 'réussi', 'Réception paiement commande ORD-1771962714159', 'paiement', '2026-02-24 19:51:54', 2, NULL, NULL, '2026-02-24 19:51:54', '2026-02-24 19:51:54'),
(33, 20, 'réussi', 'Retrait effectué avec succès', 'retrait', '2026-02-24 20:21:05', 7, NULL, NULL, '2026-02-24 20:21:05', '2026-02-24 20:21:05'),
(34, 20.5, 'réussi', 'Retrait effectué avec succès', 'retrait', '2026-02-24 20:21:19', 7, NULL, NULL, '2026-02-24 20:21:19', '2026-02-24 20:21:19');

-- --------------------------------------------------------

--
-- Structure de la table `transactionsRecharge`
--

CREATE TABLE `transactionsRecharge` (
  `transactionRechargeId` int(11) NOT NULL,
  `amount` float NOT NULL COMMENT 'Montant du retrait (min: 5$, max: 1000$)',
  `telephone` varchar(20) DEFAULT NULL COMMENT 'Numéro de téléphone associé à la recharge',
  `reference` varchar(100) NOT NULL COMMENT 'Référence unique de la recharge',
  `status` enum('pending','success','failed') DEFAULT 'pending' COMMENT 'Statut de la recharge',
  `id` int(11) NOT NULL COMMENT 'Référence de l’utilisateur',
  `createdAt` datetime NOT NULL,
  `updatedAt` datetime NOT NULL,
  `userId` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Déchargement des données de la table `transactionsRecharge`
--

INSERT INTO `transactionsRecharge` (`transactionRechargeId`, `amount`, `telephone`, `reference`, `status`, `id`, `createdAt`, `updatedAt`, `userId`) VALUES
(1, 100, '243990000009', 'RC-1771140922223-3486', 'success', 1, '2026-02-15 07:35:22', '2026-02-15 07:35:37', NULL),
(2, 1000, '243990000009', 'RC-1771178251474-4636', 'success', 4, '2026-02-15 17:57:31', '2026-02-15 17:57:43', NULL),
(3, 10, '243990000009', 'RC-1771178839079-2052', 'success', 2, '2026-02-15 18:07:19', '2026-02-15 18:07:21', NULL),
(4, 1000, '243990000009', 'RC-1771179225817-9906', 'success', 5, '2026-02-15 18:13:45', '2026-02-15 18:13:47', NULL),
(5, 100, '243990000009', 'RC-1771480560658-8920', 'success', 1, '2026-02-19 05:56:00', '2026-02-19 05:56:09', NULL),
(6, 2, '243977624084', 'RC-1771481886280-634', 'pending', 1, '2026-02-19 06:18:06', '2026-02-19 06:18:06', NULL),
(7, 2, '243977624084', 'RC-1771481930392-183', 'pending', 1, '2026-02-19 06:18:50', '2026-02-19 06:18:50', NULL),
(8, 5, '243977624084', 'RC-1771574436384-2158', 'pending', 1, '2026-02-20 08:00:36', '2026-02-20 08:00:36', NULL),
(9, 10, '243977624084', 'RC-1771619285485-3038', 'failed', 6, '2026-02-20 20:28:05', '2026-02-20 20:28:34', NULL),
(10, 10, '243977624084', 'RC-1771619729297-5173', 'failed', 6, '2026-02-20 20:35:29', '2026-02-20 20:35:57', NULL),
(11, 10, '243977624084', 'RC-1771619800006-678', 'failed', 6, '2026-02-20 20:36:40', '2026-02-20 20:37:08', NULL),
(12, 1, '243977624084', 'RC-1771619837664-6816', 'failed', 6, '2026-02-20 20:37:17', '2026-02-20 20:37:45', NULL),
(13, 50, '243977624084', 'RC-1771619884099-8299', 'failed', 6, '2026-02-20 20:38:04', '2026-02-20 20:38:32', NULL),
(14, 10, '243977624084', 'RC-1771619928253-2631', 'failed', 6, '2026-02-20 20:38:48', '2026-02-20 20:39:16', NULL),
(15, 1, '243977624084', 'RC-1771619979140-794', 'success', 6, '2026-02-20 20:39:39', '2026-02-20 20:39:58', NULL),
(16, 1, '243977624084', 'RC-1771620826874-3823', 'success', 1, '2026-02-20 20:53:46', '2026-02-20 20:54:13', NULL),
(17, 2, '243977624084', 'RC-1771621496713-878', 'failed', 6, '2026-02-20 21:04:56', '2026-02-20 21:05:25', NULL),
(18, 10, '243977624084', 'RC-1771621542390-3455', 'failed', 6, '2026-02-20 21:05:42', '2026-02-20 21:06:11', NULL),
(19, 100, '243977624084', 'RC-1771621585453-8312', 'failed', 6, '2026-02-20 21:06:25', '2026-02-20 21:06:54', NULL),
(20, 1, '243977624084', 'RC-1771621706408-5768', 'failed', 1, '2026-02-20 21:08:26', '2026-02-20 21:09:04', NULL),
(21, 1, '243977624084', 'RC-1771621829394-4530', 'failed', 1, '2026-02-20 21:10:29', '2026-02-20 21:10:58', NULL),
(22, 10, '243977624084', 'RC-1771621874131-1885', 'success', 1, '2026-02-20 21:11:14', '2026-02-20 21:11:35', NULL),
(23, 1000, '243990000009', 'RC-1771622785009-2420', 'failed', 1, '2026-02-20 21:26:25', '2026-02-20 21:26:33', NULL),
(24, 1000, '243977621084', 'RC-1771622811842-9568', 'failed', 1, '2026-02-20 21:26:51', '2026-02-20 21:26:52', NULL),
(25, 1000, '243977624084', 'RC-1771622852040-1744', 'failed', 1, '2026-02-20 21:27:32', '2026-02-20 21:28:00', NULL),
(26, 1000, '243977624084', 'RC-1771655339158-3280', 'failed', 1, '2026-02-21 06:28:59', '2026-02-21 06:29:00', NULL),
(27, 100, '243977624084', 'RC-1771655356662-8114', 'failed', 1, '2026-02-21 06:29:16', '2026-02-21 06:29:18', NULL),
(28, 1000, '243990000009', 'RC-1771655379172-4027', 'failed', 1, '2026-02-21 06:29:39', '2026-02-21 06:29:40', NULL),
(29, 1000, '243990000009', 'RC-1771655431191-8723', 'failed', 1, '2026-02-21 06:30:31', '2026-02-21 06:30:32', NULL),
(30, 1000, '243977624084', 'RC-1771655716013-5478', 'failed', 1, '2026-02-21 06:35:16', '2026-02-21 06:35:16', NULL),
(31, 1000, '243977624084', 'RC-1771655751503-7286', 'failed', 1, '2026-02-21 06:35:51', '2026-02-21 06:36:20', NULL),
(32, 100, '243977624084', 'RC-1771655885686-8389', 'failed', 1, '2026-02-21 06:38:05', '2026-02-21 06:38:35', NULL),
(33, 10, '243977624084', 'RC-1771655982254-7473', 'failed', 1, '2026-02-21 06:39:42', '2026-02-21 06:40:11', NULL),
(34, 100, '243977624084', 'RC-1771656069306-7052', 'failed', 1, '2026-02-21 06:41:09', '2026-02-21 06:41:38', NULL),
(35, 100, '243977624084', 'RC-1771656109097-4341', 'failed', 1, '2026-02-21 06:41:49', '2026-02-21 06:42:18', NULL),
(36, 200, '243977624084', 'RC-1771656870227-1313', 'failed', 6, '2026-02-21 06:54:30', '2026-02-21 06:54:59', NULL),
(37, 1000, '243977624084', 'RC-1771656953375-4365', 'failed', 6, '2026-02-21 06:55:53', '2026-02-21 06:56:21', NULL),
(38, 100, '243977624084', 'RC-1771658307240-5761', 'failed', 6, '2026-02-21 07:18:27', '2026-02-21 07:18:56', NULL),
(39, 30, '243977624084', 'RC-1771665066780-6783', 'success', 6, '2026-02-21 09:11:06', '2026-02-21 09:11:29', NULL),
(40, 10, '243977624084', 'RC-1771665720668-395', 'success', 6, '2026-02-21 09:22:00', '2026-02-21 09:22:27', NULL),
(41, 100, '243977624084', 'RC-1771769929082-4773', 'failed', 7, '2026-02-22 14:18:49', '2026-02-22 14:19:18', NULL),
(42, 100, '243977624084', 'RC-1771770388258-951', 'failed', 7, '2026-02-22 14:26:28', '2026-02-22 14:26:57', NULL),
(43, 10, '243977624084', 'RC-1771774419834-9982', 'failed', 7, '2026-02-22 15:33:39', '2026-02-22 15:34:08', NULL),
(44, 10, '243977624084', 'RC-1771774467847-1700', 'success', 7, '2026-02-22 15:34:27', '2026-02-22 15:34:47', NULL),
(45, 100, '243977624084', 'RC-1771777225400-349', 'failed', 7, '2026-02-22 16:20:25', '2026-02-22 16:20:54', NULL),
(46, 15, '243977624084', 'RC-1771872921830-89', 'failed', 7, '2026-02-23 18:55:21', '2026-02-23 18:55:50', NULL),
(47, 10, '243977624084', 'RC-1771976411662-2588', 'failed', 7, '2026-02-24 23:40:11', '2026-02-24 23:40:40', NULL);

-- --------------------------------------------------------

--
-- Structure de la table `transactionsRetrait`
--

CREATE TABLE `transactionsRetrait` (
  `transactionRetraitId` int(11) NOT NULL,
  `amount` float NOT NULL COMMENT 'Montant du retrait (min: 5$, max: 1000$)',
  `targetId` int(11) NOT NULL COMMENT 'ID de la cible du retrait',
  `id` int(11) NOT NULL COMMENT 'Référence de l''utilisateur',
  `branchTrackId` int(11) DEFAULT NULL COMMENT 'Référence du suivi de branche',
  `commerceId` int(11) DEFAULT NULL COMMENT 'Référence du commerce',
  `createdAt` datetime NOT NULL,
  `updatedAt` datetime NOT NULL,
  `maxRetraitParJuur` int(11) DEFAULT 3,
  `userId` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Déchargement des données de la table `transactionsRetrait`
--

INSERT INTO `transactionsRetrait` (`transactionRetraitId`, `amount`, `targetId`, `id`, `branchTrackId`, `commerceId`, `createdAt`, `updatedAt`, `maxRetraitParJuur`, `userId`) VALUES
(2, 10, 3, 1, NULL, NULL, '2026-02-15 07:56:23', '2026-02-15 07:56:23', 3, NULL),
(3, 9, 3, 1, NULL, NULL, '2026-02-15 08:08:21', '2026-02-15 08:08:21', 3, NULL),
(4, 20, 3, 1, NULL, NULL, '2026-02-15 08:19:42', '2026-02-15 08:19:42', 3, NULL),
(5, 100, 3, 5, NULL, NULL, '2026-02-15 18:14:15', '2026-02-15 18:14:15', 3, NULL),
(6, 50, 3, 5, NULL, NULL, '2026-02-15 18:15:46', '2026-02-15 18:15:46', 3, NULL),
(7, 100, 3, 5, NULL, NULL, '2026-02-15 18:16:03', '2026-02-15 18:16:03', 3, NULL),
(8, 10, 10, 6, NULL, NULL, '2026-02-21 09:37:56', '2026-02-21 09:37:56', 3, NULL),
(9, 5, 10, 6, NULL, NULL, '2026-02-21 09:40:41', '2026-02-21 09:40:41', 3, NULL),
(10, 20, 10, 6, NULL, NULL, '2026-02-21 09:56:15', '2026-02-21 09:56:15', 3, NULL),
(11, 5, 10, 7, NULL, NULL, '2026-02-21 15:16:36', '2026-02-21 15:16:36', 3, NULL),
(12, 5, 10, 7, NULL, NULL, '2026-02-21 15:28:49', '2026-02-21 15:28:49', 3, NULL),
(13, 5, 10, 7, NULL, NULL, '2026-02-21 15:32:16', '2026-02-21 15:32:16', 3, NULL),
(14, 10, 10, 7, NULL, NULL, '2026-02-22 15:44:36', '2026-02-22 15:44:36', 3, NULL),
(15, 10, 10, 7, NULL, NULL, '2026-02-22 16:22:36', '2026-02-22 16:22:36', 3, NULL),
(16, 10, 10, 7, NULL, NULL, '2026-02-23 18:32:48', '2026-02-23 18:32:48', 3, NULL),
(17, 5.5, 10, 7, NULL, NULL, '2026-02-23 18:50:45', '2026-02-23 18:50:45', 3, NULL),
(18, 20, 10, 7, NULL, NULL, '2026-02-24 20:21:05', '2026-02-24 20:21:05', 3, NULL),
(19, 20.5, 10, 7, NULL, NULL, '2026-02-24 20:21:19', '2026-02-24 20:21:19', 3, NULL);

-- --------------------------------------------------------

--
-- Structure de la table `transactionsTransfert`
--

CREATE TABLE `transactionsTransfert` (
  `transactionTransfertId` int(11) NOT NULL,
  `amount` float NOT NULL COMMENT 'Montant du transfert',
  `targetId` int(11) NOT NULL COMMENT 'ID de l’utilisateur cible du transfert',
  `id` int(11) NOT NULL COMMENT 'Référence de l''utilisateur initiateur',
  `branchTrackId` int(11) DEFAULT NULL COMMENT 'Référence du suivi de branche',
  `commerceId` int(11) DEFAULT NULL COMMENT 'Référence du commerce',
  `createdAt` datetime NOT NULL,
  `updatedAt` datetime NOT NULL,
  `senderId` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Déchargement des données de la table `transactionsTransfert`
--

INSERT INTO `transactionsTransfert` (`transactionTransfertId`, `amount`, `targetId`, `id`, `branchTrackId`, `commerceId`, `createdAt`, `updatedAt`, `senderId`) VALUES
(1, 5, 2, 1, NULL, NULL, '2026-02-15 08:37:03', '2026-02-15 08:37:03', NULL),
(2, 20, 4, 1, NULL, NULL, '2026-02-15 18:05:22', '2026-02-15 18:05:22', NULL),
(3, 100, 1, 5, NULL, NULL, '2026-02-15 18:17:29', '2026-02-15 18:17:29', NULL),
(4, 50, 4, 5, NULL, NULL, '2026-02-15 18:18:07', '2026-02-15 18:18:07', NULL),
(5, 100, 3, 1, NULL, NULL, '2026-02-20 05:18:46', '2026-02-20 05:18:46', NULL),
(6, 100, 1, 1, NULL, NULL, '2026-02-20 05:45:01', '2026-02-20 05:45:01', NULL),
(7, 10, 6, 1, NULL, NULL, '2026-02-20 08:07:27', '2026-02-20 08:07:27', NULL),
(8, 10, 6, 1, NULL, NULL, '2026-02-20 08:09:26', '2026-02-20 08:09:26', NULL),
(9, 10, 6, 1, NULL, NULL, '2026-02-20 21:01:36', '2026-02-20 21:01:36', NULL),
(12, 10, 9, 1, NULL, NULL, '2026-02-21 08:55:57', '2026-02-21 08:55:57', NULL),
(13, 10, 9, 7, NULL, NULL, '2026-02-21 08:56:46', '2026-02-21 08:56:46', NULL),
(14, 10, 9, 7, NULL, NULL, '2026-02-21 08:58:58', '2026-02-21 08:58:58', NULL),
(15, 10, 6, 7, NULL, NULL, '2026-02-21 09:08:54', '2026-02-21 09:08:54', NULL),
(16, 10, 6, 1, NULL, NULL, '2026-02-21 09:28:18', '2026-02-21 09:28:18', NULL),
(17, 2, 1, 6, NULL, NULL, '2026-02-21 09:57:53', '2026-02-21 09:57:53', NULL),
(18, 10, 3, 1, NULL, NULL, '2026-02-21 10:33:51', '2026-02-21 10:33:51', NULL),
(19, 10, 5, 7, NULL, NULL, '2026-02-21 10:54:11', '2026-02-21 10:54:11', NULL),
(20, 10, 6, 7, NULL, NULL, '2026-02-21 15:08:44', '2026-02-21 15:08:44', NULL),
(21, 10, 2, 1, NULL, NULL, '2026-02-22 12:23:35', '2026-02-22 12:23:35', NULL),
(22, 10, 3, 7, NULL, NULL, '2026-02-22 13:07:07', '2026-02-22 13:07:07', NULL),
(23, 2, 6, 7, NULL, NULL, '2026-02-22 14:55:39', '2026-02-22 14:55:39', NULL),
(24, 10, 6, 7, NULL, NULL, '2026-02-22 15:47:49', '2026-02-22 15:47:49', NULL),
(25, 500, 1, 7, NULL, NULL, '2026-02-23 18:30:41', '2026-02-23 18:30:41', NULL),
(26, 1.5, 4, 7, NULL, NULL, '2026-02-23 18:40:47', '2026-02-23 18:40:47', NULL),
(27, 1.8, 1, 7, NULL, NULL, '2026-02-23 18:58:37', '2026-02-23 18:58:37', NULL),
(28, 10, 3, 7, NULL, NULL, '2026-02-23 19:44:39', '2026-02-23 19:44:39', NULL),
(29, 1.5, 5, 7, NULL, NULL, '2026-02-23 20:18:13', '2026-02-23 20:18:13', NULL);

-- --------------------------------------------------------

--
-- Structure de la table `transactions_recharge`
--

CREATE TABLE `transactions_recharge` (
  `transactionPaiementId` int(11) NOT NULL,
  `amount` float NOT NULL,
  `description` varchar(255) DEFAULT NULL,
  `targetId` varchar(150) NOT NULL,
  `productId` int(11) DEFAULT NULL,
  `userId` int(11) NOT NULL,
  `createdAt` datetime NOT NULL,
  `updatedAt` datetime NOT NULL,
  `companyId` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Déchargement des données de la table `transactions_recharge`
--

INSERT INTO `transactions_recharge` (`transactionPaiementId`, `amount`, `description`, `targetId`, `productId`, `userId`, `createdAt`, `updatedAt`, `companyId`) VALUES
(1, 100, 'Paiement commande ORD-1771170994610', '2', 1, 1, '2026-02-15 15:56:34', '2026-02-15 15:56:34', 8),
(2, 100, 'Paiement commande ORD-1771171272432', '2', 1, 1, '2026-02-15 16:01:12', '2026-02-15 16:01:12', 8),
(3, 100, 'Paiement commande ORD-1771171402442', '2', 1, 1, '2026-02-15 16:03:22', '2026-02-15 16:03:22', 8),
(4, 100, 'Paiement commande ORD-1771171454531', '2', 1, 1, '2026-02-15 16:04:14', '2026-02-15 16:04:14', 8),
(5, 100, 'Paiement commande ORD-1771171557310', '2', 1, 1, '2026-02-15 16:05:57', '2026-02-15 16:05:57', 8),
(6, 100, 'Paiement commande ORD-1771171824276', '2', 1, 1, '2026-02-15 16:10:24', '2026-02-15 16:10:24', 8),
(7, 100, 'Paiement commande ORD-1771172244260', '2', 1, 1, '2026-02-15 16:17:24', '2026-02-15 16:17:24', 8),
(8, 100, 'Paiement commande ORD-1771172373660', '2', 1, 1, '2026-02-15 16:19:33', '2026-02-15 16:19:33', 8),
(9, 100, 'Paiement commande ORD-1771172696166', '2', 1, 1, '2026-02-15 16:24:56', '2026-02-15 16:24:56', 8),
(10, 80, 'Paiement commande ORD-1771174416878', '2', 16, 1, '2026-02-15 16:53:36', '2026-02-15 16:53:36', 13),
(11, 100, 'Paiement commande ORD-1771179602282', '2', 1, 5, '2026-02-15 18:20:02', '2026-02-15 18:20:02', 8),
(12, 80, 'Paiement commande ORD-1771179749270', '2', 16, 5, '2026-02-15 18:22:29', '2026-02-15 18:22:29', 13),
(13, 30, 'Paiement commande ORD-1771179901635', '2', 8, 5, '2026-02-15 18:25:01', '2026-02-15 18:25:01', 9),
(14, 100, 'Paiement commande ORD-1771480593517', '2', 1, 1, '2026-02-19 05:56:33', '2026-02-19 05:56:33', 8),
(15, 100, 'Paiement commande ORD-1771563100707', '2', 1, 1, '2026-02-20 04:51:40', '2026-02-20 04:51:40', 8),
(16, 10, 'Paiement commande ORD-1771568905511', '2', 11, 1, '2026-02-20 06:28:25', '2026-02-20 06:28:25', 10),
(17, 100, 'Paiement commande ORD-1771575237091', '2', 1, 1, '2026-02-20 08:13:57', '2026-02-20 08:13:57', 8),
(18, 1, 'Paiement commande ORD-1771671376699', '2', 8, 7, '2026-02-21 10:56:16', '2026-02-21 10:56:16', 9),
(19, 10, 'Paiement commande ORD-1771671772799', '2', 12, 7, '2026-02-21 11:02:52', '2026-02-21 11:02:52', 11),
(20, 10, 'Paiement commande ORD-1771765651986', '2', 1, 7, '2026-02-22 13:07:32', '2026-02-22 13:07:32', 8),
(21, 10, 'Paiement commande ORD-1771769715496', '2', 1, 7, '2026-02-22 14:15:15', '2026-02-22 14:15:15', 8),
(22, 10, 'Paiement commande ORD-1771774570393', '2', 8, 7, '2026-02-22 15:36:10', '2026-02-22 15:36:10', 9),
(23, 10, 'Paiement commande ORD-1771774632016', '2', 8, 7, '2026-02-22 15:37:12', '2026-02-22 15:37:12', 9),
(24, 10, 'Paiement commande ORD-1771871158381', '2', 16, 7, '2026-02-23 18:25:58', '2026-02-23 18:25:58', 13),
(25, 10, 'Paiement commande ORD-1771962092654', '2', 1, 7, '2026-02-24 19:41:32', '2026-02-24 19:41:32', 8),
(26, 20, 'Paiement commande ORD-1771962510864', '2', 1, 7, '2026-02-24 19:48:30', '2026-02-24 19:48:30', 8),
(27, 10, 'Paiement commande ORD-1771962531552', '2', 12, 7, '2026-02-24 19:48:51', '2026-02-24 19:48:51', 11),
(28, 5.5, 'Paiement commande ORD-1771962714159', '2', 12, 7, '2026-02-24 19:51:54', '2026-02-24 19:51:54', 11);

-- --------------------------------------------------------

--
-- Structure de la table `UserRoles`
--

CREATE TABLE `UserRoles` (
  `userId` int(11) NOT NULL,
  `roleId` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Structure de la table `users`
--

CREATE TABLE `users` (
  `id` int(11) NOT NULL,
  `username` varchar(255) NOT NULL,
  `fullname` varchar(255) DEFAULT NULL,
  `telephone` varchar(255) DEFAULT NULL,
  `poste` varchar(255) DEFAULT NULL,
  `adresse` varchar(255) DEFAULT NULL,
  `email` varchar(255) NOT NULL,
  `password` varchar(255) NOT NULL,
  `otp` varchar(255) DEFAULT NULL,
  `otpExpires` datetime DEFAULT NULL,
  `resetPasswordToken` varchar(255) DEFAULT NULL,
  `resetPasswordExpiresAt` datetime DEFAULT NULL,
  `tokenDateAbonnementExpiresAt` datetime DEFAULT NULL,
  `refreshToken` varchar(255) DEFAULT NULL,
  `token` varchar(255) DEFAULT NULL,
  `TokenAbonemment` varchar(255) DEFAULT NULL,
  `accountNumber` varchar(255) DEFAULT NULL,
  `soldNumber` decimal(10,2) DEFAULT NULL,
  `nRecharge` int(11) DEFAULT 0,
  `isActive` tinyint(1) DEFAULT 0,
  `isBlocked` tinyint(1) DEFAULT 0,
  `isAgent` tinyint(1) DEFAULT 0,
  `imageUrl` varchar(255) DEFAULT NULL,
  `commerceId` int(11) DEFAULT NULL,
  `branchTrackId` int(11) DEFAULT NULL,
  `expoPushToken` varchar(255) DEFAULT NULL,
  `createdAt` datetime NOT NULL,
  `updatedAt` datetime NOT NULL,
  `maxRetraitParJour` int(11) NOT NULL DEFAULT 3 COMMENT 'Nombre maximum de retraits autorisés par jour',
  `maxRechargeParJour` int(11) NOT NULL DEFAULT 10 COMMENT 'Nombre maximum de recharges autorisées par jour',
  `maxTransfertParJour` int(11) NOT NULL DEFAULT 5 COMMENT 'Nombre maximum de transferts autorisés par jour',
  `randomly` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Déchargement des données de la table `users`
--

INSERT INTO `users` (`id`, `username`, `fullname`, `telephone`, `poste`, `adresse`, `email`, `password`, `otp`, `otpExpires`, `resetPasswordToken`, `resetPasswordExpiresAt`, `tokenDateAbonnementExpiresAt`, `refreshToken`, `token`, `TokenAbonemment`, `accountNumber`, `soldNumber`, `nRecharge`, `isActive`, `isBlocked`, `isAgent`, `imageUrl`, `commerceId`, `branchTrackId`, `expoPushToken`, `createdAt`, `updatedAt`, `maxRetraitParJour`, `maxRechargeParJour`, `maxTransfertParJour`, `randomly`) VALUES
(1, 'Leader Mushio', NULL, NULL, 'Directeur ', NULL, 'leadermueshio377@gmail.com', '$2b$10$mGGqUQ3nTrlrWAIguiJJgexUnad3UxocnREXlWmQTRIPcNm2EkOjK', '797746', '2026-02-20 19:04:18', '26a67943a0024baed1a5bab62b94eefece69f76c9c5c53f228f0eca5d9361a7a', '2026-02-20 19:34:18', NULL, 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjEsImVtYWlsIjoibGVhZGVybXVlc2hpbzM3N0BnbWFpbC5jb20iLCJpYXQiOjE3NzIwMjQ3MTEsImV4cCI6MTc3MjYyOTUxMX0.cPNEMYeAWbqFIofKzocD9N2r5eEvMmmJAiJnzdHJjio', NULL, 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjEsInR5cGUiOiJBQk9OTkVNRU5UIiwiaWF0IjoxNzcxMTQwOTM3LCJleHAiOjE4MDI2OTg1Mzd9.mpjVq3O_MGf-XX6TMv_RP_mNgxIcizctMTnKbYz9tRg', '6556602611178423', 0.00, 9, 1, 0, 0, '/images/1771776849615-526267209.png', NULL, NULL, 'ExponentPushToken[JMA5AeBxCca36_JBwbcnwN]', '2026-02-12 06:16:43', '2026-02-25 13:05:11', 3, 10, 5, '0'),
(2, 'user_9gqpq', NULL, NULL, NULL, NULL, 'bimbank@bimreseau.com', '$2b$10$CKdJl6J.kbctKbFZGSpoSOtDP9JhnsccbTeJZz4zrr8xQuNt.HuGO', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjIsInR5cGUiOiJBQk9OTkVNRU5UIiwiaWF0IjoxNzcxMTc4ODQxLCJleHAiOjE4MDI3MzY0NDF9.KBOK-rEEQfc0tcqE4dmLo56UD6zXKg8nW75OpcUMDm8', '6322894838534978', 0.00, 1, 1, 0, 0, NULL, NULL, NULL, 'ExponentPushToken[Z-MYQFEKFcu-hAdaX9Imqb]', '2026-02-15 07:24:32', '2026-02-24 20:21:19', 3, 10, 5, '0'),
(3, 'john', NULL, NULL, NULL, NULL, 'leadermaloleadermalo@gmail.com', '$2b$10$JXwBVLDxAGcitgf/cgUtuuky.XnIrWzOoBUTl9XTYIgjW/zyu2UUe', '742620', '2026-02-15 08:00:38', NULL, NULL, NULL, NULL, NULL, 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjMsInR5cGUiOiJBQk9OTkVNRU5UIiwiaWF0IjoxNzcxODc1ODc5LCJleHAiOjE4MDM0MzM0Nzl9.VxPQZnNApMWI77L-zuDE0mjO-MK8npAWwvg-iLtsREg', '9006', 0.00, 1, 1, 0, 1, NULL, NULL, NULL, NULL, '2026-02-15 07:30:38', '2026-02-23 19:44:39', 3, 10, 5, '0'),
(4, 'Malo', NULL, NULL, NULL, NULL, 'leadermushio377@gmail.comm', '$2b$10$N9BuAkuMMBY4iPo4XTwD8eHtKhlI5V6/X3QO.wgukMVq7Gzqm48Yy', NULL, NULL, NULL, NULL, NULL, 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjQsImVtYWlsIjoibGVhZGVybXVzaGlvMzc3QGdtYWlsLmNvbSIsImlhdCI6MTc3MTE3ODE4OSwiZXhwIjoxNzcxNzgyOTg5fQ.lL5gnFVwFlVysO2hhipGMZ2pZ6lECFJ53KfA0Lm4b8M', NULL, 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjQsInR5cGUiOiJBQk9OTkVNRU5UIiwiaWF0IjoxNzcxMTc4MjYzLCJleHAiOjE4MDI3MzU4NjN9.x8PHe6oWbAJ6sJxDVRkbPyjiSMsigJt_-7zCcGXOZVw', '6924885846964632', 0.00, 1, 1, 0, 0, NULL, NULL, NULL, 'ExponentPushToken[Z-MYQFEKFcu-hAdaX9Imqb]', '2026-02-15 17:54:46', '2026-02-23 18:40:47', 3, 10, 5, '0'),
(5, 'user_4ekko', NULL, NULL, NULL, NULL, 'bim.rdcofficiel@gmail.com', '$2b$10$7D0mFkNzEmK72uSBD3s9P.LDqiQ2kdmUAibC/kyKRMfpMtBwCoirO', NULL, NULL, NULL, NULL, NULL, 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjUsImVtYWlsIjoiYmltLnJkY29mZmljaWVsQGdtYWlsLmNvbSIsImlhdCI6MTc3MTE3OTE5OSwiZXhwIjoxNzcxNzgzOTk5fQ.ypB17cWNUqvLrd68mRCwLmdzQf1--4IE6YfTIAS4BJc', NULL, 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjUsInR5cGUiOiJBQk9OTkVNRU5UIiwiaWF0IjoxNzcxMTc5MjI4LCJleHAiOjE4MDI3MzY4Mjh9.8O2ICyFvXZxje_bYqavVQCuq2DUlox3MWrgY_obLlpo', '6626659014713561', 0.00, 1, 1, 0, 0, NULL, NULL, NULL, 'ExponentPushToken[Z-MYQFEKFcu-hAdaX9Imqb]', '2026-02-15 18:11:45', '2026-02-23 20:18:13', 3, 10, 5, '0'),
(6, 'Jerry', NULL, NULL, NULL, NULL, 'jerry@bimreseau.com', '$2b$10$l9dG.2TWo/TpZzM4Sbaif.03QSLnKSkhdDudFInARnK0X3feCSsKS', NULL, NULL, NULL, NULL, NULL, 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjYsImVtYWlsIjoiamVycnlAYmltcmVzZWF1LmNvbSIsImlhdCI6MTc3MTc3MTQ5NiwiZXhwIjoxNzcyMzc2Mjk2fQ.Sxq0XXVT_BsgTnhz66ZkBUQhdBFQ_N4L-JxD8IjWfrs', NULL, 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjYsInR5cGUiOiJBQk9OTkVNRU5UIiwiaWF0IjoxNzcxNjY1MDg5LCJleHAiOjE4MDMyMjI2ODl9.G5Y4lI8zsiRVQIttlB4VMVJkMPx6fZK7gIFT2cjdFt4', '3657086396688584', 0.00, 2, 1, 0, 0, NULL, NULL, NULL, 'ExponentPushToken[JMA5AeBxCca36_JBwbcnwN]', '2026-02-20 07:52:09', '2026-02-22 15:47:49', 3, 10, 5, '0'),
(7, 'Mushio leaader', NULL, NULL, 'Developer', NULL, 'leadermushio377@gmail.com', '$2b$10$GgsD45gPi.NjWgIa/vfgzu7zXsfHrp7Ao.3P67NG9S0eMxA3ksMrq', NULL, NULL, '2051e66c8ca07734d18dfd5607df1b74019c818a346c1d20468f750d7d8b4b8a', '2026-02-22 12:10:03', NULL, 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjcsImVtYWlsIjoibGVhZGVybXVzaGlvMzc3QGdtYWlsLmNvbSIsImlhdCI6MTc3MTk3NjM0MywiZXhwIjoxNzcyNTgxMTQzfQ.p3gG5srKWc0J6bF-lYKVd09Vzs_DlfBOnBVxRcUqQOE', NULL, 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjcsInR5cGUiOiJBQk9OTkVNRU5UIiwiaWF0IjoxNzcxNjYyMjY0LCJleHAiOjE4MDMyMTk4NjR9.vQEX65cSojWFCVmAC281lh998ubY9wKlUN_NfQnS37c', '3942750562999326', 0.00, 11, 1, 0, 0, '/images/1771976381845-245836392.png', NULL, NULL, 'ExponentPushToken[Z-MYQFEKFcu-hAdaX9Imqb]', '2026-02-20 18:02:47', '2026-02-24 23:39:42', 3, 10, 5, '$2b$10$Bonqn2zA0qxMeNeGFT97jecCZD.TbP9E4b.QO8I7pwaLDqEX3EP2m'),
(8, 'user_f155z', NULL, NULL, NULL, NULL, 'm@gmail.com', '$2b$10$PL/qeW5MzDqfAaw.hIHMX.HYy1pEzMagoLFdUV1qspf.xCUYnRUHm', '230916', '2026-02-20 19:02:01', NULL, NULL, NULL, NULL, NULL, 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjgsInR5cGUiOiJBQk9OTkVNRU5UIiwiaWF0IjoxNzcxNjYwNDQ3LCJleHAiOjE4MDMyMTgwNDd9.wYhyz2di1m0d75LE4sNV-vX49NhUxSm6s_gAjhjGGtM', '9826043648931128', 0.00, 3, 0, 0, 0, NULL, NULL, NULL, NULL, '2026-02-20 18:32:01', '2026-02-21 08:18:58', 3, 10, 5, '0'),
(9, 'user_7cfxq', NULL, NULL, NULL, NULL, 'leadermuhio377@gmail.com', '$2b$10$YwNZJJ96S5IErtAuwOjpmeeQs86lAivU39FX479tzu16kL5qri2WC', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '7915664886124349', 0.00, 0, 1, 0, 0, NULL, NULL, NULL, NULL, '2026-02-20 18:33:45', '2026-02-21 08:58:58', 3, 10, 5, '0'),
(10, 'malodev', NULL, NULL, NULL, NULL, 'leader@bimreseau.com', '$2b$10$xandxp07fePSStujZIIe9.10YgNyBhQ0qlQocfFKt.2gt6xmuTHS2', '379654', '2026-02-21 10:06:13', NULL, NULL, NULL, 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjEwLCJlbWFpbCI6ImxlYWRlckBiaW1yZXNlYXUuY29tIiwiaWF0IjoxNzcyMDI0OTQxLCJleHAiOjE3NzI2Mjk3NDF9.7DiGgXmmnEeI-ojg_m_YNt95QlSbMVjX_ieOCZtDK8M', NULL, NULL, '4781', 0.00, 0, 1, 0, 1, NULL, NULL, NULL, NULL, '2026-02-21 09:36:13', '2026-02-25 13:09:01', 3, 10, 5, '0');

--
-- Index pour les tables déchargées
--

--
-- Index pour la table `bonus`
--
ALTER TABLE `bonus`
  ADD PRIMARY KEY (`bonusId`),
  ADD KEY `userId` (`userId`),
  ADD KEY `companyId` (`companyId`);

--
-- Index pour la table `branchTracks`
--
ALTER TABLE `branchTracks`
  ADD PRIMARY KEY (`branchTrackId`),
  ADD UNIQUE KEY `branch_tracks_branch_track_email` (`branchTrackEmail`),
  ADD KEY `commerceId` (`commerceId`);

--
-- Index pour la table `branch_tracks`
--
ALTER TABLE `branch_tracks`
  ADD PRIMARY KEY (`branchTrackId`),
  ADD UNIQUE KEY `branch_tracks_branch_track_email` (`branchTrackEmail`);

--
-- Index pour la table `businessCategories`
--
ALTER TABLE `businessCategories`
  ADD PRIMARY KEY (`businessId`),
  ADD UNIQUE KEY `business_categories_name` (`name`);

--
-- Index pour la table `categories`
--
ALTER TABLE `categories`
  ADD PRIMARY KEY (`categoryId`),
  ADD UNIQUE KEY `categories_name_commerce_id` (`name`,`commerceId`),
  ADD KEY `commerceId` (`commerceId`),
  ADD KEY `branchTrackId` (`branchTrackId`);

--
-- Index pour la table `client_tracks`
--
ALTER TABLE `client_tracks`
  ADD PRIMARY KEY (`clientTrackId`),
  ADD UNIQUE KEY `client_tracks_email` (`email`),
  ADD KEY `commerceId` (`commerceId`),
  ADD KEY `branchTrackId` (`branchTrackId`);

--
-- Index pour la table `commerces`
--
ALTER TABLE `commerces`
  ADD PRIMARY KEY (`commerceId`),
  ADD UNIQUE KEY `commerces_commerce_email` (`commerceEmail`),
  ADD KEY `userId` (`userId`);

--
-- Index pour la table `companies`
--
ALTER TABLE `companies`
  ADD PRIMARY KEY (`companyId`),
  ADD UNIQUE KEY `companies_email` (`email`),
  ADD KEY `branchTrackId` (`branchTrackId`),
  ADD KEY `businessId` (`businessId`);

--
-- Index pour la table `currencies`
--
ALTER TABLE `currencies`
  ADD PRIMARY KEY (`currencyId`),
  ADD UNIQUE KEY `currencies_code` (`code`);

--
-- Index pour la table `expe_tracks`
--
ALTER TABLE `expe_tracks`
  ADD PRIMARY KEY (`expeTrackId`),
  ADD UNIQUE KEY `expe_tracks_reference` (`reference`),
  ADD KEY `commerceId` (`commerceId`),
  ADD KEY `branchTrackId` (`branchTrackId`);

--
-- Index pour la table `feedback_tracks`
--
ALTER TABLE `feedback_tracks`
  ADD PRIMARY KEY (`feedBackTrackId`),
  ADD KEY `commerceId` (`commerceId`),
  ADD KEY `branchTrackId` (`branchTrackId`);

--
-- Index pour la table `histories`
--
ALTER TABLE `histories`
  ADD PRIMARY KEY (`historyId`),
  ADD KEY `userId` (`userId`);

--
-- Index pour la table `notes`
--
ALTER TABLE `notes`
  ADD PRIMARY KEY (`noteId`),
  ADD KEY `userId` (`userId`),
  ADD KEY `companyId` (`companyId`),
  ADD KEY `productId` (`productId`),
  ADD KEY `branchTrackId` (`branchTrackId`);

--
-- Index pour la table `notifications`
--
ALTER TABLE `notifications`
  ADD PRIMARY KEY (`notificationId`),
  ADD KEY `expeTrackId` (`expeTrackId`),
  ADD KEY `userId` (`userId`),
  ADD KEY `commerceId` (`commerceId`),
  ADD KEY `branchTrackId` (`branchTrackId`);

--
-- Index pour la table `orders`
--
ALTER TABLE `orders`
  ADD PRIMARY KEY (`orderId`),
  ADD UNIQUE KEY `orders_order_number` (`orderNumber`),
  ADD KEY `branchTrackId` (`branchTrackId`),
  ADD KEY `userId` (`userId`),
  ADD KEY `companyId` (`companyId`),
  ADD KEY `productId` (`productId`);

--
-- Index pour la table `products`
--
ALTER TABLE `products`
  ADD PRIMARY KEY (`productId`),
  ADD KEY `currencyId` (`currencyId`),
  ADD KEY `commerceId` (`commerceId`),
  ADD KEY `branchTrackId` (`branchTrackId`),
  ADD KEY `companyId` (`companyId`);

--
-- Index pour la table `product_categories`
--
ALTER TABLE `product_categories`
  ADD PRIMARY KEY (`productId`,`categoryId`),
  ADD UNIQUE KEY `product_categories_categoryId_productId_unique` (`productId`,`categoryId`);

--
-- Index pour la table `product_solds`
--
ALTER TABLE `product_solds`
  ADD PRIMARY KEY (`id`),
  ADD KEY `productId` (`productId`),
  ADD KEY `commerceId` (`commerceId`),
  ADD KEY `branchTrackId` (`branchTrackId`),
  ADD KEY `currencyId` (`currencyId`);

--
-- Index pour la table `redevtracks`
--
ALTER TABLE `redevtracks`
  ADD PRIMARY KEY (`id`),
  ADD KEY `productId` (`productId`),
  ADD KEY `commerceId` (`commerceId`),
  ADD KEY `branchTrackId` (`branchTrackId`);

--
-- Index pour la table `roles`
--
ALTER TABLE `roles`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `roles_name` (`name`);

--
-- Index pour la table `supportTracks`
--
ALTER TABLE `supportTracks`
  ADD PRIMARY KEY (`supportTrackId`),
  ADD KEY `commerceId` (`commerceId`),
  ADD KEY `branchTrackId` (`branchTrackId`),
  ADD KEY `id` (`id`);

--
-- Index pour la table `transactions`
--
ALTER TABLE `transactions`
  ADD PRIMARY KEY (`transactionId`),
  ADD KEY `id` (`id`),
  ADD KEY `branchTrackId` (`branchTrackId`),
  ADD KEY `commerceId` (`commerceId`);

--
-- Index pour la table `transactionsRecharge`
--
ALTER TABLE `transactionsRecharge`
  ADD PRIMARY KEY (`transactionRechargeId`),
  ADD UNIQUE KEY `transactions_recharge_reference` (`reference`),
  ADD KEY `id` (`id`),
  ADD KEY `userId` (`userId`);

--
-- Index pour la table `transactionsRetrait`
--
ALTER TABLE `transactionsRetrait`
  ADD PRIMARY KEY (`transactionRetraitId`),
  ADD KEY `id` (`id`),
  ADD KEY `branchTrackId` (`branchTrackId`),
  ADD KEY `commerceId` (`commerceId`),
  ADD KEY `userId` (`userId`);

--
-- Index pour la table `transactionsTransfert`
--
ALTER TABLE `transactionsTransfert`
  ADD PRIMARY KEY (`transactionTransfertId`),
  ADD KEY `id` (`id`),
  ADD KEY `branchTrackId` (`branchTrackId`),
  ADD KEY `commerceId` (`commerceId`),
  ADD KEY `senderId` (`senderId`);

--
-- Index pour la table `transactions_recharge`
--
ALTER TABLE `transactions_recharge`
  ADD PRIMARY KEY (`transactionPaiementId`),
  ADD KEY `productId` (`productId`),
  ADD KEY `userId` (`userId`),
  ADD KEY `companyId` (`companyId`);

--
-- Index pour la table `UserRoles`
--
ALTER TABLE `UserRoles`
  ADD PRIMARY KEY (`userId`,`roleId`),
  ADD UNIQUE KEY `UserRoles_roleId_userId_unique` (`userId`,`roleId`);

--
-- Index pour la table `users`
--
ALTER TABLE `users`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `users_email` (`email`),
  ADD KEY `commerceId` (`commerceId`),
  ADD KEY `branchTrackId` (`branchTrackId`);

--
-- AUTO_INCREMENT pour les tables déchargées
--

--
-- AUTO_INCREMENT pour la table `bonus`
--
ALTER TABLE `bonus`
  MODIFY `bonusId` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT pour la table `branchTracks`
--
ALTER TABLE `branchTracks`
  MODIFY `branchTrackId` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT pour la table `branch_tracks`
--
ALTER TABLE `branch_tracks`
  MODIFY `branchTrackId` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT pour la table `businessCategories`
--
ALTER TABLE `businessCategories`
  MODIFY `businessId` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=14;

--
-- AUTO_INCREMENT pour la table `categories`
--
ALTER TABLE `categories`
  MODIFY `categoryId` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT pour la table `client_tracks`
--
ALTER TABLE `client_tracks`
  MODIFY `clientTrackId` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT pour la table `commerces`
--
ALTER TABLE `commerces`
  MODIFY `commerceId` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT pour la table `companies`
--
ALTER TABLE `companies`
  MODIFY `companyId` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=15;

--
-- AUTO_INCREMENT pour la table `currencies`
--
ALTER TABLE `currencies`
  MODIFY `currencyId` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT pour la table `expe_tracks`
--
ALTER TABLE `expe_tracks`
  MODIFY `expeTrackId` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT pour la table `feedback_tracks`
--
ALTER TABLE `feedback_tracks`
  MODIFY `feedBackTrackId` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT pour la table `histories`
--
ALTER TABLE `histories`
  MODIFY `historyId` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=1788;

--
-- AUTO_INCREMENT pour la table `notes`
--
ALTER TABLE `notes`
  MODIFY `noteId` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT pour la table `notifications`
--
ALTER TABLE `notifications`
  MODIFY `notificationId` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=813;

--
-- AUTO_INCREMENT pour la table `orders`
--
ALTER TABLE `orders`
  MODIFY `orderId` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=29;

--
-- AUTO_INCREMENT pour la table `products`
--
ALTER TABLE `products`
  MODIFY `productId` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=22;

--
-- AUTO_INCREMENT pour la table `product_solds`
--
ALTER TABLE `product_solds`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT pour la table `redevtracks`
--
ALTER TABLE `redevtracks`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT pour la table `roles`
--
ALTER TABLE `roles`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT pour la table `supportTracks`
--
ALTER TABLE `supportTracks`
  MODIFY `supportTrackId` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT pour la table `transactions`
--
ALTER TABLE `transactions`
  MODIFY `transactionId` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=35;

--
-- AUTO_INCREMENT pour la table `transactionsRecharge`
--
ALTER TABLE `transactionsRecharge`
  MODIFY `transactionRechargeId` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=48;

--
-- AUTO_INCREMENT pour la table `transactionsRetrait`
--
ALTER TABLE `transactionsRetrait`
  MODIFY `transactionRetraitId` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=20;

--
-- AUTO_INCREMENT pour la table `transactionsTransfert`
--
ALTER TABLE `transactionsTransfert`
  MODIFY `transactionTransfertId` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=30;

--
-- AUTO_INCREMENT pour la table `transactions_recharge`
--
ALTER TABLE `transactions_recharge`
  MODIFY `transactionPaiementId` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=29;

--
-- AUTO_INCREMENT pour la table `users`
--
ALTER TABLE `users`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=11;

--
-- Contraintes pour les tables déchargées
--

--
-- Contraintes pour la table `bonus`
--
ALTER TABLE `bonus`
  ADD CONSTRAINT `bonus_ibfk_131` FOREIGN KEY (`userId`) REFERENCES `users` (`id`) ON DELETE SET NULL ON UPDATE CASCADE,
  ADD CONSTRAINT `bonus_ibfk_132` FOREIGN KEY (`companyId`) REFERENCES `companies` (`companyId`) ON UPDATE CASCADE;

--
-- Contraintes pour la table `branchTracks`
--
ALTER TABLE `branchTracks`
  ADD CONSTRAINT `branchTracks_ibfk_1` FOREIGN KEY (`commerceId`) REFERENCES `commerces` (`commerceId`) ON DELETE SET NULL ON UPDATE CASCADE;

--
-- Contraintes pour la table `categories`
--
ALTER TABLE `categories`
  ADD CONSTRAINT `categories_ibfk_185` FOREIGN KEY (`commerceId`) REFERENCES `commerces` (`commerceId`) ON DELETE SET NULL ON UPDATE CASCADE,
  ADD CONSTRAINT `categories_ibfk_186` FOREIGN KEY (`branchTrackId`) REFERENCES `branch_tracks` (`branchTrackId`) ON DELETE SET NULL ON UPDATE CASCADE;

--
-- Contraintes pour la table `client_tracks`
--
ALTER TABLE `client_tracks`
  ADD CONSTRAINT `client_tracks_ibfk_159` FOREIGN KEY (`commerceId`) REFERENCES `commerces` (`commerceId`) ON DELETE SET NULL ON UPDATE CASCADE,
  ADD CONSTRAINT `client_tracks_ibfk_160` FOREIGN KEY (`branchTrackId`) REFERENCES `branch_tracks` (`branchTrackId`) ON DELETE SET NULL ON UPDATE CASCADE;

--
-- Contraintes pour la table `commerces`
--
ALTER TABLE `commerces`
  ADD CONSTRAINT `commerces_ibfk_1` FOREIGN KEY (`userId`) REFERENCES `users` (`id`) ON DELETE SET NULL ON UPDATE CASCADE;

--
-- Contraintes pour la table `companies`
--
ALTER TABLE `companies`
  ADD CONSTRAINT `companies_ibfk_145` FOREIGN KEY (`branchTrackId`) REFERENCES `branch_tracks` (`branchTrackId`) ON DELETE SET NULL ON UPDATE CASCADE,
  ADD CONSTRAINT `companies_ibfk_146` FOREIGN KEY (`businessId`) REFERENCES `businessCategories` (`businessId`) ON DELETE SET NULL ON UPDATE CASCADE;

--
-- Contraintes pour la table `expe_tracks`
--
ALTER TABLE `expe_tracks`
  ADD CONSTRAINT `expe_tracks_ibfk_83` FOREIGN KEY (`commerceId`) REFERENCES `commerces` (`commerceId`) ON UPDATE CASCADE,
  ADD CONSTRAINT `expe_tracks_ibfk_84` FOREIGN KEY (`branchTrackId`) REFERENCES `branch_tracks` (`branchTrackId`) ON DELETE SET NULL ON UPDATE CASCADE;

--
-- Contraintes pour la table `feedback_tracks`
--
ALTER TABLE `feedback_tracks`
  ADD CONSTRAINT `feedback_tracks_ibfk_139` FOREIGN KEY (`commerceId`) REFERENCES `commerces` (`commerceId`) ON DELETE SET NULL ON UPDATE CASCADE,
  ADD CONSTRAINT `feedback_tracks_ibfk_140` FOREIGN KEY (`branchTrackId`) REFERENCES `branch_tracks` (`branchTrackId`) ON DELETE SET NULL ON UPDATE CASCADE;

--
-- Contraintes pour la table `histories`
--
ALTER TABLE `histories`
  ADD CONSTRAINT `histories_ibfk_1` FOREIGN KEY (`userId`) REFERENCES `users` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Contraintes pour la table `notes`
--
ALTER TABLE `notes`
  ADD CONSTRAINT `notes_ibfk_29` FOREIGN KEY (`userId`) REFERENCES `users` (`id`) ON DELETE SET NULL ON UPDATE CASCADE,
  ADD CONSTRAINT `notes_ibfk_30` FOREIGN KEY (`companyId`) REFERENCES `companies` (`companyId`) ON UPDATE CASCADE,
  ADD CONSTRAINT `notes_ibfk_31` FOREIGN KEY (`productId`) REFERENCES `products` (`productId`) ON UPDATE CASCADE,
  ADD CONSTRAINT `notes_ibfk_32` FOREIGN KEY (`branchTrackId`) REFERENCES `branch_tracks` (`branchTrackId`) ON DELETE SET NULL ON UPDATE CASCADE;

--
-- Contraintes pour la table `notifications`
--
ALTER TABLE `notifications`
  ADD CONSTRAINT `notifications_ibfk_289` FOREIGN KEY (`expeTrackId`) REFERENCES `expe_tracks` (`expeTrackId`) ON DELETE SET NULL ON UPDATE CASCADE,
  ADD CONSTRAINT `notifications_ibfk_290` FOREIGN KEY (`userId`) REFERENCES `users` (`id`) ON DELETE SET NULL ON UPDATE CASCADE,
  ADD CONSTRAINT `notifications_ibfk_291` FOREIGN KEY (`commerceId`) REFERENCES `commerces` (`commerceId`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `notifications_ibfk_292` FOREIGN KEY (`branchTrackId`) REFERENCES `branch_tracks` (`branchTrackId`) ON DELETE SET NULL ON UPDATE CASCADE;

--
-- Contraintes pour la table `orders`
--
ALTER TABLE `orders`
  ADD CONSTRAINT `orders_ibfk_95` FOREIGN KEY (`userId`) REFERENCES `users` (`id`) ON DELETE SET NULL ON UPDATE CASCADE,
  ADD CONSTRAINT `orders_ibfk_96` FOREIGN KEY (`companyId`) REFERENCES `companies` (`companyId`) ON UPDATE CASCADE,
  ADD CONSTRAINT `orders_ibfk_97` FOREIGN KEY (`productId`) REFERENCES `products` (`productId`) ON UPDATE CASCADE;

--
-- Contraintes pour la table `products`
--
ALTER TABLE `products`
  ADD CONSTRAINT `products_ibfk_370` FOREIGN KEY (`currencyId`) REFERENCES `currencies` (`currencyId`) ON UPDATE CASCADE,
  ADD CONSTRAINT `products_ibfk_371` FOREIGN KEY (`commerceId`) REFERENCES `commerces` (`commerceId`) ON DELETE SET NULL ON UPDATE CASCADE,
  ADD CONSTRAINT `products_ibfk_372` FOREIGN KEY (`branchTrackId`) REFERENCES `branchTracks` (`branchTrackId`) ON DELETE SET NULL ON UPDATE CASCADE,
  ADD CONSTRAINT `products_ibfk_373` FOREIGN KEY (`companyId`) REFERENCES `companies` (`companyId`) ON DELETE SET NULL ON UPDATE CASCADE;

--
-- Contraintes pour la table `product_solds`
--
ALTER TABLE `product_solds`
  ADD CONSTRAINT `product_solds_ibfk_330` FOREIGN KEY (`productId`) REFERENCES `products` (`productId`) ON UPDATE CASCADE,
  ADD CONSTRAINT `product_solds_ibfk_331` FOREIGN KEY (`commerceId`) REFERENCES `commerces` (`commerceId`) ON DELETE SET NULL ON UPDATE CASCADE,
  ADD CONSTRAINT `product_solds_ibfk_332` FOREIGN KEY (`branchTrackId`) REFERENCES `branchTracks` (`branchTrackId`) ON DELETE SET NULL ON UPDATE CASCADE,
  ADD CONSTRAINT `product_solds_ibfk_333` FOREIGN KEY (`currencyId`) REFERENCES `currencies` (`currencyId`) ON UPDATE CASCADE;

--
-- Contraintes pour la table `redevtracks`
--
ALTER TABLE `redevtracks`
  ADD CONSTRAINT `redevtracks_ibfk_208` FOREIGN KEY (`productId`) REFERENCES `products` (`productId`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `redevtracks_ibfk_209` FOREIGN KEY (`commerceId`) REFERENCES `commerces` (`commerceId`) ON DELETE SET NULL ON UPDATE CASCADE,
  ADD CONSTRAINT `redevtracks_ibfk_210` FOREIGN KEY (`branchTrackId`) REFERENCES `branchTracks` (`branchTrackId`) ON DELETE SET NULL ON UPDATE CASCADE;

--
-- Contraintes pour la table `supportTracks`
--
ALTER TABLE `supportTracks`
  ADD CONSTRAINT `supportTracks_ibfk_204` FOREIGN KEY (`commerceId`) REFERENCES `commerces` (`commerceId`) ON DELETE SET NULL ON UPDATE CASCADE,
  ADD CONSTRAINT `supportTracks_ibfk_205` FOREIGN KEY (`branchTrackId`) REFERENCES `branchTracks` (`branchTrackId`) ON DELETE SET NULL ON UPDATE CASCADE,
  ADD CONSTRAINT `supportTracks_ibfk_206` FOREIGN KEY (`id`) REFERENCES `users` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Contraintes pour la table `transactions`
--
ALTER TABLE `transactions`
  ADD CONSTRAINT `transactions_ibfk_192` FOREIGN KEY (`id`) REFERENCES `users` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `transactions_ibfk_193` FOREIGN KEY (`branchTrackId`) REFERENCES `branchTracks` (`branchTrackId`) ON DELETE SET NULL ON UPDATE CASCADE,
  ADD CONSTRAINT `transactions_ibfk_194` FOREIGN KEY (`commerceId`) REFERENCES `commerces` (`commerceId`) ON DELETE SET NULL ON UPDATE CASCADE;

--
-- Contraintes pour la table `transactionsRecharge`
--
ALTER TABLE `transactionsRecharge`
  ADD CONSTRAINT `transactionsRecharge_ibfk_1` FOREIGN KEY (`id`) REFERENCES `users` (`id`) ON UPDATE CASCADE,
  ADD CONSTRAINT `transactionsRecharge_ibfk_2` FOREIGN KEY (`userId`) REFERENCES `users` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Contraintes pour la table `transactionsRetrait`
--
ALTER TABLE `transactionsRetrait`
  ADD CONSTRAINT `transactionsRetrait_ibfk_190` FOREIGN KEY (`id`) REFERENCES `users` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `transactionsRetrait_ibfk_191` FOREIGN KEY (`branchTrackId`) REFERENCES `branchTracks` (`branchTrackId`) ON DELETE SET NULL ON UPDATE CASCADE,
  ADD CONSTRAINT `transactionsRetrait_ibfk_192` FOREIGN KEY (`commerceId`) REFERENCES `commerces` (`commerceId`) ON DELETE SET NULL ON UPDATE CASCADE,
  ADD CONSTRAINT `transactionsRetrait_ibfk_193` FOREIGN KEY (`userId`) REFERENCES `users` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Contraintes pour la table `transactionsTransfert`
--
ALTER TABLE `transactionsTransfert`
  ADD CONSTRAINT `transactionsTransfert_ibfk_187` FOREIGN KEY (`id`) REFERENCES `users` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `transactionsTransfert_ibfk_188` FOREIGN KEY (`branchTrackId`) REFERENCES `branchTracks` (`branchTrackId`) ON DELETE SET NULL ON UPDATE CASCADE,
  ADD CONSTRAINT `transactionsTransfert_ibfk_189` FOREIGN KEY (`commerceId`) REFERENCES `commerces` (`commerceId`) ON DELETE SET NULL ON UPDATE CASCADE,
  ADD CONSTRAINT `transactionsTransfert_ibfk_190` FOREIGN KEY (`senderId`) REFERENCES `users` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Contraintes pour la table `transactions_recharge`
--
ALTER TABLE `transactions_recharge`
  ADD CONSTRAINT `transactions_recharge_ibfk_155` FOREIGN KEY (`productId`) REFERENCES `products` (`productId`) ON DELETE SET NULL ON UPDATE CASCADE,
  ADD CONSTRAINT `transactions_recharge_ibfk_156` FOREIGN KEY (`userId`) REFERENCES `users` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `transactions_recharge_ibfk_157` FOREIGN KEY (`companyId`) REFERENCES `companies` (`companyId`) ON DELETE SET NULL ON UPDATE CASCADE;

--
-- Contraintes pour la table `users`
--
ALTER TABLE `users`
  ADD CONSTRAINT `users_ibfk_213` FOREIGN KEY (`commerceId`) REFERENCES `commerces` (`commerceId`) ON DELETE SET NULL ON UPDATE CASCADE,
  ADD CONSTRAINT `users_ibfk_214` FOREIGN KEY (`branchTrackId`) REFERENCES `branchTracks` (`branchTrackId`) ON DELETE SET NULL ON UPDATE CASCADE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
