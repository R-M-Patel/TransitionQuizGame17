-- phpMyAdmin SQL Dump
-- version 4.6.5.2
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Feb 10, 2017 at 01:47 AM
-- Server version: 10.1.21-MariaDB
-- PHP Version: 5.6.30

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `pharm_genius`
--
CREATE DATABASE IF NOT EXISTS `pharm_genius` DEFAULT CHARACTER SET latin1 COLLATE latin1_swedish_ci;
USE `pharm_genius`;

DELIMITER $$
--
-- Functions
--
CREATE DEFINER=`root`@`localhost` FUNCTION `sp_getScoreForUser` (`username` VARCHAR(20)) RETURNS INT(10) UNSIGNED READS SQL DATA
    SQL SECURITY INVOKER
BEGIN
DECLARE score INT(10);
SELECT SUM(q.score) INTO score
FROM question q
JOIN questions_correctly_answered qca on qca.question_id = q.question_id
WHERE qca.username=username;
RETURN score;
END$$

DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `answer`
--

CREATE TABLE `answer` (
  `answer_id` int(10) UNSIGNED NOT NULL,
  `question_id` int(10) UNSIGNED NOT NULL,
  `answer_text` varchar(256) NOT NULL,
  `correct_flag` enum('Y','N') DEFAULT NULL,
  `times_chosen` int(10) UNSIGNED NOT NULL DEFAULT '0',
  `created_date` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `last_updated_date` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `last_updated_by` varchar(20) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `answer`
--

INSERT INTO `answer` (`answer_id`, `question_id`, `answer_text`, `correct_flag`, `times_chosen`, `created_date`, `last_updated_date`, `last_updated_by`) VALUES
(1, 1, 'Lortab', 'N', 2, '2016-12-08 00:00:00', '2016-12-08 00:00:00', 'sgs38'),
(2, 1, 'Duragesic', 'Y', 12, '2016-12-08 00:00:00', '2016-12-08 00:00:00', 'sgs38'),
(3, 1, 'Norco', 'N', 1, '2016-12-08 00:00:00', '2016-12-08 00:00:00', 'sgs38'),
(4, 1, 'Vicodin', 'N', 1, '2016-12-08 00:00:00', '2016-12-08 00:00:00', 'sgs38'),
(5, 2, 'Oxycotin', 'N', 0, '2016-12-08 00:00:00', '2016-12-08 00:00:00', 'emcgeary'),
(6, 2, 'Oxymorphone', 'N', 0, '2016-12-08 00:00:00', '2016-12-08 00:00:00', 'emcgeary'),
(7, 2, 'Percocet', 'N', 0, '2016-12-08 00:00:00', '2016-12-08 00:00:00', 'emcgeary'),
(8, 2, 'Prozac', 'Y', 0, '2016-12-08 00:00:00', '2016-12-08 00:00:00', 'emcgeary'),
(9, 3, 'canagliflozin/Invokana', 'N', 2, '2016-12-08 00:00:00', '2016-12-08 00:00:00', 'sgs38'),
(10, 3, 'citalopram/Celexa', 'N', 2, '2016-12-08 00:00:00', '2016-12-08 00:00:00', 'sgs38'),
(11, 3, 'clopidogrel/Plavix', 'N', 0, '2016-12-08 00:00:00', '2016-12-08 00:00:00', 'sgs38'),
(12, 3, 'amoxicillin/Augmentin', 'Y', 11, '2016-12-08 00:00:00', '2016-12-08 00:00:00', 'sgs38'),
(13, 4, 'thiazide diuretic', 'N', 1, '2016-12-08 00:00:00', '2016-12-08 00:00:00', 'sgs38'),
(14, 4, 'calcium channel blocker', 'N', 1, '2016-12-08 00:00:00', '2016-12-08 00:00:00', 'sgs38'),
(15, 4, 'beta-adrenergic blocker', 'Y', 19, '2016-12-08 00:00:00', '2016-12-08 00:00:00', 'sgs38'),
(16, 4, 'cholesterol absorption inhib.', 'N', 2, '2016-12-08 00:00:00', '2016-12-08 00:00:00', 'sgs38'),
(17, 5, 'biguanide', 'Y', 14, '2016-12-08 00:00:00', '2016-12-08 00:00:00', 'sgs38'),
(18, 5, 'glucagon', 'N', 1, '2016-12-08 00:00:00', '2016-12-08 00:00:00', 'sgs38'),
(19, 5, 'sulfanamide', 'N', 1, '2016-12-08 00:00:00', '2016-12-08 00:00:00', 'sgs38'),
(20, 5, 'meglitinide', 'N', 1, '2016-12-08 00:00:00', '2016-12-08 00:00:00', 'sgs38'),
(21, 6, 'Prozac', 'N', 1, '2016-12-12 00:00:00', '2016-12-12 00:00:00', 'Lil_Wang'),
(22, 6, 'Wellbutrin XL', 'N', 2, '2016-12-12 00:00:00', '2016-12-12 00:00:00', 'Lil_Wang'),
(23, 6, 'Effexor', 'Y', 3, '2016-12-12 00:00:00', '2016-12-12 00:00:00', 'Lil_Wang'),
(24, 6, 'Desyrel', 'N', 0, '2016-12-12 00:00:00', '2016-12-12 00:00:00', 'Lil_Wang'),
(25, 7, 'hydrochlorothiazide', 'N', 0, '2016-12-08 00:00:00', '2016-12-08 00:00:00', 'sgs38'),
(26, 7, 'furosemide', 'N', 2, '2016-12-08 00:00:00', '2016-12-08 00:00:00', 'sgs38'),
(27, 7, 'escitalopram', 'Y', 15, '2016-12-08 00:00:00', '2016-12-08 00:00:00', 'sgs38'),
(28, 7, 'atenolol', 'N', 0, '2016-12-08 00:00:00', '2016-12-08 00:00:00', 'sgs38'),
(29, 8, 'Fosamax', 'N', 0, '2016-12-08 00:00:00', '2016-12-08 00:00:00', 'sgs38'),
(30, 8, 'Norvasc', 'Y', 1, '2016-12-08 00:00:00', '2016-12-08 00:00:00', 'sgs38'),
(31, 8, 'Tenormin', 'N', 0, '2016-12-08 00:00:00', '2016-12-08 00:00:00', 'sgs38'),
(32, 8, 'Keflex', 'N', 0, '2016-12-08 00:00:00', '2016-12-08 00:00:00', 'sgs38'),
(33, 9, 'Celebrex', 'N', 0, '2016-12-08 00:00:00', '2016-12-08 00:00:00', 'sgs38'),
(34, 9, 'Cipro', 'N', 1, '2016-12-08 00:00:00', '2016-12-08 00:00:00', 'sgs38'),
(35, 9, 'Invokana', 'Y', 1, '2016-12-08 00:00:00', '2016-12-08 00:00:00', 'sgs38'),
(36, 9, 'Celexa', 'N', 1, '2016-12-08 00:00:00', '2016-12-08 00:00:00', 'sgs38'),
(37, 10, 'Acetaminophen', 'Y', 3, '2016-12-12 00:00:00', '2016-12-12 00:00:00', 'Lil_Wang'),
(38, 10, 'Glucophage', 'N', 0, '2016-12-12 00:00:00', '2016-12-12 00:00:00', 'Lil_Wang'),
(39, 10, 'Naproxen', 'N', 2, '2016-12-12 00:00:00', '2016-12-12 00:00:00', 'Lil_Wang'),
(40, 10, 'Ibuprofen', 'N', 1, '2016-12-12 00:00:00', '2016-12-12 00:00:00', 'Lil_Wang'),
(41, 11, 'Stomach', 'N', 0, '2016-11-14 00:00:00', '2016-11-14 00:00:00', 'Ra_vee'),
(42, 11, 'Pancreas', 'Y', 3, '2016-11-14 00:00:00', '2016-11-14 00:00:00', 'Ra_vee'),
(43, 11, 'Lungs', 'N', 0, '2016-11-14 00:00:00', '2016-11-14 00:00:00', 'Ra_vee'),
(44, 11, 'Liver', 'N', 0, '2016-11-14 00:00:00', '2016-11-14 00:00:00', 'Ra_vee'),
(45, 12, 'TRAMADOL', 'Y', 4, '2016-12-12 00:00:00', '2016-12-12 00:00:00', 'Lil_Wang'),
(46, 12, 'OPANA', 'N', 1, '2016-12-12 00:00:00', '2016-12-12 00:00:00', 'Lil_Wang'),
(47, 12, 'Citalopram', 'N', 1, '2016-12-12 00:00:00', '2016-12-12 00:00:00', 'Lil_Wang'),
(48, 12, 'Cymbalta', 'N', 0, '2016-12-12 00:00:00', '2016-12-12 00:00:00', 'Lil_Wang'),
(49, 13, 'Plavix', 'Y', 0, '2016-12-08 00:00:00', '2016-12-08 00:00:00', 'emcgeary'),
(50, 13, 'Microzide', 'N', 0, '2016-12-08 00:00:00', '2016-12-08 00:00:00', 'emcgeary'),
(51, 13, 'Humalog', 'N', 0, '2016-12-08 00:00:00', '2016-12-08 00:00:00', 'emcgeary'),
(52, 13, 'Metformin', 'N', 0, '2016-12-08 00:00:00', '2016-12-08 00:00:00', 'emcgeary'),
(53, 14, 'Duloxetine & Fluoxetine', 'N', 1, '2016-12-12 00:00:00', '2016-12-12 00:00:00', 'Lil_Wang'),
(54, 14, 'Cymbalta & Escitalopram', 'N', 1, '2016-12-12 00:00:00', '2016-12-12 00:00:00', 'Lil_Wang'),
(55, 14, 'Cymbalta & Venlafaxine', 'Y', 4, '2016-12-12 00:00:00', '2016-12-12 00:00:00', 'Lil_Wang'),
(56, 14, 'Venlafaxine and Fluoxetine', 'N', 0, '2016-12-12 00:00:00', '2016-12-12 00:00:00', 'Lil_Wang'),
(57, 15, 'Because', 'N', 0, '2017-02-06 00:00:00', '2017-02-06 00:00:00', 'lizieaxes'),
(58, 15, 'Bipedalism', 'Y', 6, '2017-02-06 00:00:00', '2017-02-06 00:00:00', 'lizieaxes'),
(59, 15, 'It looks neat', 'N', 0, '2017-02-06 00:00:00', '2017-02-06 00:00:00', 'lizieaxes'),
(60, 15, 'Toes', 'N', 0, '2017-02-06 00:00:00', '2017-02-06 00:00:00', 'lizieaxes'),
(61, 16, 'Bayer', 'N', 0, '2016-12-08 00:00:00', '2016-12-08 00:00:00', 'sgs38'),
(62, 16, 'Aleve', 'Y', 4, '2016-12-08 00:00:00', '2016-12-08 00:00:00', 'sgs38'),
(63, 16, 'Duragesic', 'N', 0, '2016-12-08 00:00:00', '2016-12-08 00:00:00', 'sgs38'),
(64, 16, 'Aldactone', 'N', 0, '2016-12-08 00:00:00', '2016-12-08 00:00:00', 'sgs38'),
(65, 17, 'Epiglottis', 'Y', 16, '2016-11-13 00:00:00', '2016-11-13 00:00:00', 'Ra_vee'),
(66, 17, 'Stomach', 'N', 1, '2016-11-13 00:00:00', '2016-11-13 00:00:00', 'Ra_vee'),
(67, 17, 'Large Intestine', 'N', 1, '2016-11-13 00:00:00', '2016-11-13 00:00:00', 'Ra_vee'),
(68, 17, 'Capillaries', 'N', 0, '2016-11-13 00:00:00', '2016-11-13 00:00:00', 'Ra_vee'),
(69, 18, 'Citalopram', 'N', 1, '2016-12-08 00:00:00', '2016-12-08 00:00:00', 'emcgeary'),
(70, 18, 'Furosemide', 'Y', 16, '2016-12-08 00:00:00', '2016-12-08 00:00:00', 'emcgeary'),
(71, 18, 'Escitalopram', 'N', 0, '2016-12-08 00:00:00', '2016-12-08 00:00:00', 'emcgeary'),
(72, 18, 'Fentanyl', 'N', 0, '2016-12-08 00:00:00', '2016-12-08 00:00:00', 'emcgeary'),
(73, 19, 'Bactrim DS', 'Y', 20, '2016-12-08 00:00:00', '2016-12-08 00:00:00', 'sgs38'),
(74, 19, 'Zantac', 'N', 0, '2016-12-08 00:00:00', '2016-12-08 00:00:00', 'sgs38'),
(75, 19, 'Ultram', 'N', 0, '2016-12-08 00:00:00', '2016-12-08 00:00:00', 'sgs38'),
(76, 19, 'Aldactone', 'N', 0, '2016-12-08 00:00:00', '2016-12-08 00:00:00', 'sgs38'),
(77, 20, 'SSRI', 'N', 0, '2016-12-08 00:00:00', '2016-12-08 00:00:00', 'sgs38'),
(78, 20, 'platelet aggregation inhibitor', 'Y', 17, '2016-12-08 00:00:00', '2016-12-08 00:00:00', 'sgs38'),
(79, 20, 'fluoroquinolone', 'N', 0, '2016-12-08 00:00:00', '2016-12-08 00:00:00', 'sgs38'),
(80, 20, 'NSAID', 'N', 1, '2016-12-08 00:00:00', '2016-12-08 00:00:00', 'sgs38'),
(81, 21, 'Bupropion', 'Y', 0, '2016-12-12 00:00:00', '2016-12-12 00:00:00', 'Lil_Wang'),
(82, 21, 'Desyrel', 'N', 0, '2016-12-12 00:00:00', '2016-12-12 00:00:00', 'Lil_Wang'),
(83, 21, 'Elavil', 'N', 0, '2016-12-12 00:00:00', '2016-12-12 00:00:00', 'Lil_Wang'),
(84, 21, 'amitriptyline', 'N', 0, '2016-12-12 00:00:00', '2016-12-12 00:00:00', 'Lil_Wang'),
(85, 22, 'Ranitidine', 'N', 0, '2016-12-08 00:00:00', '2016-12-08 00:00:00', 'emcgeary'),
(86, 22, 'Sitagliptin', 'N', 0, '2016-12-08 00:00:00', '2016-12-08 00:00:00', 'emcgeary'),
(87, 22, 'Fosamax', 'N', 0, '2016-12-08 00:00:00', '2016-12-08 00:00:00', 'emcgeary'),
(88, 22, 'Warfarin', 'Y', 0, '2016-12-08 00:00:00', '2016-12-08 00:00:00', 'emcgeary'),
(89, 23, 'Naproxen has highest CV risk', 'N', 1, '2016-12-12 00:00:00', '2016-12-12 00:00:00', 'Lil_Wang'),
(90, 23, 'Naproxen has lowest CV risk', 'Y', 6, '2016-12-12 00:00:00', '2016-12-12 00:00:00', 'Lil_Wang'),
(91, 23, 'Ibuprofen has lowest CV risk', 'N', 0, '2016-12-12 00:00:00', '2016-12-12 00:00:00', 'Lil_Wang'),
(92, 23, 'Ibuprofen can has cheezburger', 'N', 0, '2016-12-12 00:00:00', '2016-12-12 00:00:00', 'Lil_Wang'),
(93, 24, 'NonPharm (no options)', 'N', 0, '2016-11-28 00:00:00', '2016-11-28 00:00:00', 'Ra_vee'),
(94, 24, 'Acetaminophen', 'Y', 4, '2016-11-28 00:00:00', '2016-11-28 00:00:00', 'Ra_vee'),
(95, 24, 'Menthol', 'N', 1, '2016-11-28 00:00:00', '2016-11-28 00:00:00', 'Ra_vee'),
(96, 24, 'Bismuth', 'N', 0, '2016-11-28 00:00:00', '2016-11-28 00:00:00', 'Ra_vee'),
(97, 25, 'Amoxicillin', 'N', 0, '2016-12-12 00:00:00', '2016-12-12 00:00:00', 'Lil_Wang'),
(98, 25, 'Lexapro', 'N', 1, '2016-12-12 00:00:00', '2016-12-12 00:00:00', 'Lil_Wang'),
(99, 25, 'Celebrex', 'Y', 5, '2016-12-12 00:00:00', '2016-12-12 00:00:00', 'Lil_Wang'),
(100, 25, 'Celexa', 'N', 0, '2016-12-12 00:00:00', '2016-12-12 00:00:00', 'Lil_Wang'),
(101, 26, 'Wellbutrin XL', 'Y', 0, '2016-12-08 00:00:00', '2016-12-08 00:00:00', 'sgs38'),
(102, 26, 'Toprol XL', 'N', 0, '2016-12-08 00:00:00', '2016-12-08 00:00:00', 'sgs38'),
(103, 26, 'Glucotrol XL', 'N', 0, '2016-12-08 00:00:00', '2016-12-08 00:00:00', 'sgs38'),
(104, 26, 'Oxycodone ER', 'N', 0, '2016-12-08 00:00:00', '2016-12-08 00:00:00', 'sgs38'),
(105, 27, 'fentanyl tansdermal', 'N', 0, '2016-12-08 00:00:00', '2016-12-08 00:00:00', 'sgs38'),
(106, 27, 'Opana', 'N', 1, '2016-12-08 00:00:00', '2016-12-08 00:00:00', 'sgs38'),
(107, 27, 'tramadol', 'N', 0, '2016-12-08 00:00:00', '2016-12-08 00:00:00', 'sgs38'),
(108, 27, 'naproxen', 'Y', 17, '2016-12-08 00:00:00', '2016-12-08 00:00:00', 'sgs38'),
(109, 28, 'Victoza', 'Y', 18, '2016-12-08 00:00:00', '2016-12-08 00:00:00', 'sgs38'),
(110, 28, 'Prinivil', 'N', 2, '2016-12-08 00:00:00', '2016-12-08 00:00:00', 'sgs38'),
(111, 28, 'Ativan', 'N', 0, '2016-12-08 00:00:00', '2016-12-08 00:00:00', 'sgs38'),
(112, 28, 'Levoxyl', 'N', 1, '2016-12-08 00:00:00', '2016-12-08 00:00:00', 'sgs38'),
(113, 29, 'OPANA', 'N', 0, '2016-12-12 00:00:00', '2016-12-12 00:00:00', 'Lil_Wang'),
(114, 29, 'Duragesic', 'Y', 0, '2016-12-12 00:00:00', '2016-12-12 00:00:00', 'Lil_Wang'),
(115, 29, 'OXY IR', 'N', 0, '2016-12-12 00:00:00', '2016-12-12 00:00:00', 'Lil_Wang'),
(116, 29, 'Doxycycline', 'N', 0, '2016-12-12 00:00:00', '2016-12-12 00:00:00', 'Lil_Wang'),
(117, 30, 'tetracycline', 'N', 2, '2016-12-08 00:00:00', '2016-12-08 00:00:00', 'sgs38'),
(118, 30, 'duloxetine', 'N', 2, '2016-12-08 00:00:00', '2016-12-08 00:00:00', 'sgs38'),
(119, 30, 'doxycycline', 'Y', 15, '2016-12-08 00:00:00', '2016-12-08 00:00:00', 'sgs38'),
(120, 30, 'fluoxetine', 'N', 0, '2016-12-08 00:00:00', '2016-12-08 00:00:00', 'sgs38'),
(121, 31, 'Aldactone', 'N', 0, '2016-12-08 00:00:00', '2016-12-08 00:00:00', 'sgs38'),
(122, 31, 'Januvia', 'Y', 20, '2016-12-08 00:00:00', '2016-12-08 00:00:00', 'sgs38'),
(123, 31, 'Zantac', 'N', 0, '2016-12-08 00:00:00', '2016-12-08 00:00:00', 'sgs38'),
(124, 31, 'Prilosec', 'N', 0, '2016-12-08 00:00:00', '2016-12-08 00:00:00', 'sgs38'),
(125, 32, 'Celebrex', 'N', 0, '2016-12-08 00:00:00', '2016-12-08 00:00:00', 'emcgeary'),
(126, 32, 'Citalopram', 'N', 0, '2016-12-08 00:00:00', '2016-12-08 00:00:00', 'emcgeary'),
(127, 32, 'Tenormin', 'Y', 0, '2016-12-08 00:00:00', '2016-12-08 00:00:00', 'emcgeary'),
(128, 32, 'Lipitor', 'N', 0, '2016-12-08 00:00:00', '2016-12-08 00:00:00', 'emcgeary'),
(129, 33, '1', 'N', 0, '2017-02-06 00:00:00', '2017-02-06 00:00:00', 'mjb236'),
(130, 33, '2', 'N', 1, '2017-02-06 00:00:00', '2017-02-06 00:00:00', 'mjb236'),
(131, 33, '3', 'Y', 3, '2017-02-06 00:00:00', '2017-02-06 00:00:00', 'mjb236'),
(132, 33, '4', 'N', 0, '2017-02-06 00:00:00', '2017-02-06 00:00:00', 'mjb236'),
(133, 34, 'TRAMADOL', 'N', 0, '2016-12-12 00:00:00', '2016-12-12 00:00:00', 'Lil_Wang'),
(134, 34, 'Fentanyl (Trandermal)', 'Y', 4, '2016-12-12 00:00:00', '2016-12-12 00:00:00', 'Lil_Wang'),
(135, 34, 'Oxycodone', 'N', 1, '2016-12-12 00:00:00', '2016-12-12 00:00:00', 'Lil_Wang'),
(136, 34, 'Oxymorphone', 'N', 0, '2016-12-12 00:00:00', '2016-12-12 00:00:00', 'Lil_Wang'),
(137, 35, 'Flagyl', 'N', 2, '2016-12-12 00:00:00', '2016-12-12 00:00:00', 'Lil_Wang'),
(138, 35, 'Vibramycin', 'N', 0, '2016-12-12 00:00:00', '2016-12-12 00:00:00', 'Lil_Wang'),
(139, 35, 'Fluconazole', 'Y', 4, '2016-12-12 00:00:00', '2016-12-12 00:00:00', 'Lil_Wang'),
(140, 35, 'Bactrim/ Bactrim DS', 'N', 0, '2016-12-12 00:00:00', '2016-12-12 00:00:00', 'Lil_Wang'),
(141, 36, 'Sulfamethoxazole/trimethoprim', 'N', 0, '2016-12-12 00:00:00', '2016-12-12 00:00:00', 'Lil_Wang'),
(142, 36, 'Metronidazole', 'Y', 4, '2016-12-12 00:00:00', '2016-12-12 00:00:00', 'Lil_Wang'),
(143, 36, 'Doxycycline', 'N', 1, '2016-12-12 00:00:00', '2016-12-12 00:00:00', 'Lil_Wang'),
(144, 36, 'Azithromycin', 'N', 0, '2016-12-12 00:00:00', '2016-12-12 00:00:00', 'Lil_Wang'),
(145, 37, 'Duloxetine', 'Y', 5, '2016-12-12 00:00:00', '2016-12-12 00:00:00', 'Lil_Wang'),
(146, 37, 'Citalopram', 'N', 1, '2016-12-12 00:00:00', '2016-12-12 00:00:00', 'Lil_Wang'),
(147, 37, 'Lexapro', 'N', 2, '2016-12-12 00:00:00', '2016-12-12 00:00:00', 'Lil_Wang'),
(148, 37, 'Fluoxetine', 'N', 0, '2016-12-12 00:00:00', '2016-12-12 00:00:00', 'Lil_Wang'),
(149, 38, 'Omnicef', 'Y', 3, '2016-12-08 00:00:00', '2016-12-08 00:00:00', 'sgs38'),
(150, 38, 'Keflex', 'N', 1, '2016-12-08 00:00:00', '2016-12-08 00:00:00', 'sgs38'),
(151, 38, 'Ativan', 'N', 0, '2016-12-08 00:00:00', '2016-12-08 00:00:00', 'sgs38'),
(152, 38, 'Flagyl', 'N', 0, '2016-12-08 00:00:00', '2016-12-08 00:00:00', 'sgs38'),
(153, 39, 'Antihypertensives', 'N', 0, '2016-12-12 00:00:00', '2016-12-12 00:00:00', 'Lil_Wang'),
(154, 39, 'Antibiotics', 'N', 0, '2016-12-12 00:00:00', '2016-12-12 00:00:00', 'Lil_Wang'),
(155, 39, 'Diabetes Meds', 'N', 0, '2016-12-12 00:00:00', '2016-12-12 00:00:00', 'Lil_Wang'),
(156, 39, 'Antidepressants', 'Y', 8, '2016-12-12 00:00:00', '2016-12-12 00:00:00', 'Lil_Wang'),
(157, 40, 'Prilosec', 'Y', 0, '2016-12-08 00:00:00', '2016-12-08 00:00:00', 'emcgeary'),
(158, 40, 'Zantac', 'N', 0, '2016-12-08 00:00:00', '2016-12-08 00:00:00', 'emcgeary'),
(159, 40, 'Januvia', 'N', 0, '2016-12-08 00:00:00', '2016-12-08 00:00:00', 'emcgeary'),
(160, 40, 'Aldactone', 'N', 0, '2016-12-08 00:00:00', '2016-12-08 00:00:00', 'emcgeary'),
(161, 41, 'Dell sucks', 'N', 0, '2017-02-06 00:00:00', '2017-02-06 00:00:00', 'mjb236'),
(162, 41, 'Bill Gates', 'N', 0, '2017-02-06 00:00:00', '2017-02-06 00:00:00', 'mjb236'),
(163, 41, 'Steve Jobs needs my money', 'Y', 3, '2017-02-06 00:00:00', '2017-02-06 00:00:00', 'mjb236'),
(164, 41, 'Snakes!', 'N', 0, '2017-02-06 00:00:00', '2017-02-06 00:00:00', 'mjb236'),
(165, 42, 'Trazodone', 'Y', 5, '2016-12-12 00:00:00', '2016-12-12 00:00:00', 'Lil_Wang'),
(166, 42, 'cymbalta', 'N', 0, '2016-12-12 00:00:00', '2016-12-12 00:00:00', 'Lil_Wang'),
(167, 42, 'escitalopram', 'N', 1, '2016-12-12 00:00:00', '2016-12-12 00:00:00', 'Lil_Wang'),
(168, 42, 'celexa', 'N', 1, '2016-12-12 00:00:00', '2016-12-12 00:00:00', 'Lil_Wang'),
(169, 43, 'Axon', 'N', 0, '2016-11-11 00:00:00', '2016-11-11 00:00:00', 'Ra_vee'),
(170, 43, 'Dendrite', 'Y', 0, '2016-11-11 00:00:00', '2016-11-11 00:00:00', 'Ra_vee'),
(171, 43, 'Cell Body', 'N', 0, '2016-11-11 00:00:00', '2016-11-11 00:00:00', 'Ra_vee'),
(172, 43, 'Nucleus', 'N', 0, '2016-11-11 00:00:00', '2016-11-11 00:00:00', 'Ra_vee'),
(173, 44, 'Invokana', 'N', 0, '2016-12-08 00:00:00', '2016-12-08 00:00:00', 'sgs38'),
(174, 44, 'Cipro', 'N', 1, '2016-12-08 00:00:00', '2016-12-08 00:00:00', 'sgs38'),
(175, 44, 'Tenormin', 'N', 0, '2016-12-08 00:00:00', '2016-12-08 00:00:00', 'sgs38'),
(176, 44, 'Zyban', 'Y', 2, '2016-12-08 00:00:00', '2016-12-08 00:00:00', 'sgs38');

-- --------------------------------------------------------

--
-- Table structure for table `category`
--

CREATE TABLE `category` (
  `category_id` int(10) UNSIGNED NOT NULL,
  `category_name` varchar(50) NOT NULL,
  `description` varchar(256) DEFAULT NULL,
  `verified_flag` varchar(1) DEFAULT NULL,
  `created_date` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `created_by` varchar(20) NOT NULL,
  `last_updated_date` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `last_updated_by` varchar(20) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `category`
--

INSERT INTO `category` (`category_id`, `category_name`, `description`, `verified_flag`, `created_date`, `created_by`, `last_updated_date`, `last_updated_by`) VALUES
(1, 'Anatomy & Physiology', NULL, 'Y', '2017-02-07 22:10:46', 'mjb236', '2017-02-07 22:10:46', 'mjb236'),
(2, 'BioChemistry', NULL, 'Y', '2017-02-07 22:10:46', 'mjb236', '2017-02-07 22:10:46', 'mjb236'),
(3, 'Mike\'s Test Category', NULL, 'Y', '2017-02-07 22:10:46', 'mjb236', '2017-02-07 22:10:46', 'mjb236'),
(4, 'Mike', NULL, NULL, '2017-02-07 22:10:46', 'mjb236', '2017-02-07 22:10:46', 'mjb236'),
(5, 'Self-Care', NULL, 'Y', '2017-02-07 22:10:46', 'mjb236', '2017-02-07 22:10:46', 'mjb236'),
(6, 'Top Drugs 1-60', NULL, 'Y', '2017-02-07 22:10:46', 'mjb236', '2017-02-07 22:10:46', 'mjb236');

-- --------------------------------------------------------

--
-- Table structure for table `question`
--

CREATE TABLE `question` (
  `question_id` int(10) UNSIGNED NOT NULL,
  `quiz_id` int(10) UNSIGNED NOT NULL,
  `question_text` varchar(500) NOT NULL,
  `score` int(10) UNSIGNED NOT NULL DEFAULT '100',
  `times_correctly_answered` int(10) UNSIGNED NOT NULL DEFAULT '0',
  `times_answered` int(10) UNSIGNED NOT NULL DEFAULT '0',
  `explanation` varchar(500) DEFAULT NULL,
  `verified_flag` enum('Y','N') DEFAULT NULL,
  `active_flag` varchar(1) DEFAULT NULL,
  `image_url` varchar(256) DEFAULT NULL,
  `created_date` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `created_by` varchar(20) NOT NULL,
  `last_updated_date` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `last_updated_by` varchar(20) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `question`
--

INSERT INTO `question` (`question_id`, `quiz_id`, `question_text`, `score`, `times_correctly_answered`, `times_answered`, `explanation`, `verified_flag`, `active_flag`, `image_url`, `created_date`, `created_by`, `last_updated_date`, `last_updated_by`) VALUES
(1, 12, 'Which one is NOT a brand name for hydrocodone/acetaminophen?', 100, 12, 16, NULL, 'Y', 'Y', NULL, '2016-12-08 00:00:00', 'sgs38', '2016-12-08 00:00:00', 'sgs38'),
(2, 1, 'Which of the following is NOT an opioid analgesic?', 100, 0, 0, NULL, 'Y', 'Y', NULL, '2016-12-08 00:00:00', 'emcgeary', '2016-12-08 00:00:00', 'emcgeary'),
(3, 12, 'Which of the following generic/brand name pairs do NOT match up?', 100, 11, 16, NULL, 'Y', 'Y', NULL, '2016-12-08 00:00:00', 'sgs38', '2016-12-08 00:00:00', 'sgs38'),
(4, 12, 'What is Toprol XL\'s drug class?', 100, 19, 23, NULL, 'Y', 'Y', NULL, '2016-12-08 00:00:00', 'sgs38', '2016-12-08 00:00:00', 'sgs38'),
(5, 12, 'What is metformin\'s drug class?', 100, 14, 18, NULL, 'Y', 'Y', NULL, '2016-12-08 00:00:00', 'sgs38', '2016-12-08 00:00:00', 'sgs38'),
(6, 12, 'Which Antidepressant should be tapered when use is discontinued?', 100, 3, 6, NULL, 'Y', 'Y', NULL, '2016-12-12 00:00:00', 'Lil_Wang', '2016-12-12 00:00:00', 'Lil_Wang'),
(7, 12, 'Which of the following is NOT used for hypertension?', 100, 15, 17, NULL, 'Y', 'Y', NULL, '2016-12-08 00:00:00', 'sgs38', '2016-12-08 00:00:00', 'sgs38'),
(8, 10, 'What is the brand name for amlodipine?', 100, 1, 1, NULL, 'Y', 'Y', NULL, '2016-12-08 00:00:00', 'sgs38', '2016-12-08 00:00:00', 'sgs38'),
(9, 10, 'What is the brand name for canagliflozin?', 100, 1, 3, NULL, 'Y', 'Y', NULL, '2016-12-08 00:00:00', 'sgs38', '2016-12-08 00:00:00', 'sgs38'),
(10, 12, 'Which drug is contraindicated for patients with severe Hepatic impairment or active/severe hepatic disease?', 100, 3, 6, 'Acetaminophen - max daily dose is 4g (4000mg)', 'Y', 'Y', NULL, '2016-12-12 00:00:00', 'Lil_Wang', '2016-12-12 00:00:00', 'Lil_Wang'),
(11, 3, 'Test Question: What creates Insulin', 100, 3, 3, 'The Pancreas is the site for the Beta-cell function.', 'Y', 'Y', NULL, '2016-11-14 00:00:00', 'Ra_vee', '2016-11-14 00:00:00', 'Ra_vee'),
(12, 12, 'Which DRUGS\'s MOA involves acting on mu-opioid receptors & weak inhibition of serotonin and norepinephrine?', 100, 4, 6, NULL, 'Y', 'Y', NULL, '2016-12-12 00:00:00', 'Lil_Wang', '2016-12-12 00:00:00', 'Lil_Wang'),
(13, 1, 'What is the brand name for Clopidogrel?', 100, 0, 0, NULL, 'Y', 'Y', NULL, '2016-12-08 00:00:00', 'emcgeary', '2016-12-08 00:00:00', 'emcgeary'),
(14, 12, 'Which pair consists of only SNRIs?', 100, 4, 6, NULL, 'Y', 'Y', NULL, '2016-12-12 00:00:00', 'Lil_Wang', '2016-12-12 00:00:00', 'Lil_Wang'),
(15, 4, 'Why do people have two legs?', 100, 6, 6, NULL, 'Y', 'Y', NULL, '2017-02-06 00:00:00', 'lizieaxes', '2017-02-06 00:00:00', 'lizieaxes'),
(16, 10, 'What is the brand name for naproxen?', 100, 4, 4, NULL, 'Y', 'Y', NULL, '2016-12-08 00:00:00', 'sgs38', '2016-12-08 00:00:00', 'sgs38'),
(17, 2, 'Test Question: Which part prevent food from entering the larynx?', 100, 16, 18, 'Epiglottis is found in the neck/throat where it can complete this function.', 'Y', 'Y', NULL, '2016-11-13 00:00:00', 'Ra_vee', '2016-11-13 00:00:00', 'Ra_vee'),
(18, 12, 'Which of the following is a loop diuretic?', 100, 16, 17, NULL, 'Y', 'Y', NULL, '2016-12-08 00:00:00', 'emcgeary', '2016-12-08 00:00:00', 'emcgeary'),
(19, 12, 'What is the brand name for sulfamethoxazole/trimethoprim?', 100, 20, 20, NULL, 'Y', 'Y', NULL, '2016-12-08 00:00:00', 'sgs38', '2016-12-08 00:00:00', 'sgs38'),
(20, 12, 'What is clopidogrel\'s drug class?', 100, 17, 18, NULL, 'Y', 'Y', NULL, '2016-12-08 00:00:00', 'sgs38', '2016-12-08 00:00:00', 'sgs38'),
(21, 1, 'Which antidepressant is contraindicated in patients with seizure disorders, or prior/current diagnosis of anorexia or bulimia?', 100, 0, 0, 'Includes both SR and XL forms of bupropion/wellbutrin.', 'Y', 'Y', NULL, '2016-12-12 00:00:00', 'Lil_Wang', '2016-12-12 00:00:00', 'Lil_Wang'),
(22, 1, 'Which of the following drugs has a varied effect depending on the patient\'s intake of leafy green vegetables?', 100, 0, 0, NULL, 'Y', 'Y', NULL, '2016-12-08 00:00:00', 'emcgeary', '2016-12-08 00:00:00', 'emcgeary'),
(23, 12, 'Which of the following is true about Naproxen and Ibuprofen?', 100, 6, 7, 'Naproxen has the lowest CV risk whereas Ibuprofen has the low GI risk.', 'Y', 'Y', NULL, '2016-12-12 00:00:00', 'Lil_Wang', '2016-12-12 00:00:00', 'Lil_Wang'),
(24, 10, 'What is self-care for headache?', 100, 4, 5, 'Acetaminophen is used for Headache.', 'Y', 'Y', NULL, '2016-11-28 00:00:00', 'Ra_vee', '2016-11-28 00:00:00', 'Ra_vee'),
(25, 12, 'Which drug (as per Dr. Berenbrok\'s Lecture slides) has a boxed warning regarding increased risk of MI and stroke?', 100, 5, 6, 'Celebrex is the answer, and its a cox 2 inhibitor.', 'Y', 'Y', NULL, '2016-12-12 00:00:00', 'Lil_Wang', '2016-12-12 00:00:00', 'Lil_Wang'),
(26, 1, 'What is the brand name for bupropion XL?', 100, 0, 0, NULL, 'Y', 'Y', NULL, '2016-12-08 00:00:00', 'sgs38', '2016-12-08 00:00:00', 'sgs38'),
(27, 12, 'Which drug is NOT an opioid?', 100, 17, 18, NULL, 'Y', 'Y', NULL, '2016-12-08 00:00:00', 'sgs38', '2016-12-08 00:00:00', 'sgs38'),
(28, 12, 'What is the brand name for liraglutide?', 100, 18, 22, NULL, 'Y', 'Y', NULL, '2016-12-08 00:00:00', 'sgs38', '2016-12-08 00:00:00', 'sgs38'),
(29, 1, 'Which opioid has a black box warning in regards to risk of fatal respiratory depression?', 100, 0, 0, NULL, 'Y', 'Y', NULL, '2016-12-12 00:00:00', 'Lil_Wang', '2016-12-12 00:00:00', 'Lil_Wang'),
(30, 12, 'What is the generic name for Vibramycin?', 100, 15, 19, NULL, 'Y', 'N', NULL, '2016-12-08 00:00:00', 'sgs38', '2016-12-08 00:00:00', 'sgs38'),
(31, 12, 'What is the brand name for sitagliptin?', 100, 20, 20, NULL, 'Y', 'Y', NULL, '2016-12-08 00:00:00', 'sgs38', '2016-12-08 00:00:00', 'sgs38'),
(32, 1, 'Which of the following is a beta-blocker?', 100, 0, 0, NULL, 'Y', 'Y', NULL, '2016-12-08 00:00:00', 'emcgeary', '2016-12-08 00:00:00', 'emcgeary'),
(33, 4, 'How many licks does it take to get to the center of a Tootsie Pop?', 100, 3, 4, 'I am old.', 'Y', 'N', NULL, '2017-02-06 00:00:00', 'mjb236', '2017-02-06 00:00:00', 'mjb236'),
(34, 12, 'Which opioid is contraindicated in patients who are non-tolerant to opioids?', 100, 4, 5, NULL, 'Y', 'Y', NULL, '2016-12-12 00:00:00', 'Lil_Wang', '2016-12-12 00:00:00', 'Lil_Wang'),
(35, 12, 'Which drug (as per the lecture slides) is a CYP450 inhibitor?', 100, 4, 6, 'Fluconazole is a CPY450 inhibitor, especially of CYP2C19', 'Y', 'Y', NULL, '2016-12-12 00:00:00', 'Lil_Wang', '2016-12-12 00:00:00', 'Lil_Wang'),
(36, 12, 'Which Antibacterial is contraindicated for concurrent use of Alcohol?', 100, 4, 5, NULL, 'Y', 'Y', NULL, '2016-12-12 00:00:00', 'Lil_Wang', '2016-12-12 00:00:00', 'Lil_Wang'),
(37, 12, 'WHICH OF TEH following is NOT a selective serotonin reuptake inhibitor?', 100, 5, 8, 'Duloxetine is a Serotonin Norepinephrine Reuptake inhibitor', 'Y', 'Y', NULL, '2016-12-12 00:00:00', 'Lil_Wang', '2016-12-12 00:00:00', 'Lil_Wang'),
(38, 10, 'What is the brand name for cefdinir?', 100, 3, 4, NULL, 'Y', 'Y', NULL, '2016-12-08 00:00:00', 'sgs38', '2016-12-08 00:00:00', 'sgs38'),
(39, 12, 'Which Drug type has the common boxed warning of increased risk of compared to placebo ofsuicidal thinking and behavior in children, teens and YA', 100, 8, 8, NULL, 'Y', 'Y', NULL, '2016-12-12 00:00:00', 'Lil_Wang', '2016-12-12 00:00:00', 'Lil_Wang'),
(40, 1, 'Which of the following is a proton pump inhibitor?', 100, 0, 0, NULL, 'Y', 'Y', NULL, '2016-12-08 00:00:00', 'emcgeary', '2016-12-08 00:00:00', 'emcgeary'),
(41, 4, 'Why can\'t I create a question on a Windows laptop?', 100, 3, 3, 'Shrug.', 'Y', 'Y', NULL, '2017-02-06 00:00:00', 'mjb236', '2017-02-06 00:00:00', 'mjb236'),
(42, 12, 'Which drug has an off label use for Insomnia?', 100, 5, 7, 'Trazodone, or Desyrel, is a triazolopyridine with an indication for major depressive disorder. Sedation is a common side effect.', 'Y', 'Y', NULL, '2016-12-12 00:00:00', 'Lil_Wang', '2016-12-12 00:00:00', 'Lil_Wang'),
(43, 1, 'Which part of the nerve is the short branched extension of a nerve cell, along which impulses received from other cells at synapses are transmi', 100, 0, 0, 'The Dendrite is the correct answer to the description. The other options do not have short-branched extensions.', 'Y', 'Y', NULL, '2016-11-11 00:00:00', 'Ra_vee', '2016-11-11 00:00:00', 'Ra_vee'),
(44, 10, 'What is the brand name for bupropion SR?', 100, 2, 3, NULL, 'Y', 'Y', NULL, '2016-12-08 00:00:00', 'sgs38', '2016-12-08 00:00:00', 'sgs38');

-- --------------------------------------------------------

--
-- Table structure for table `questions_correctly_answered`
--

CREATE TABLE `questions_correctly_answered` (
  `question_id` int(10) UNSIGNED NOT NULL,
  `username` varchar(20) NOT NULL,
  `created_date` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `questions_correctly_answered`
--

INSERT INTO `questions_correctly_answered` (`question_id`, `username`, `created_date`) VALUES
(1, 'Lil_Wang', '2016-12-13 14:58:40'),
(1, 'Lil_Wang', '2016-12-14 10:36:02'),
(1, 'Lil_Wang', '2016-12-13 10:49:02'),
(1, 'marisapostava', '2016-12-10 18:16:24'),
(1, 'mattbrock4', '2016-12-13 10:12:05'),
(1, 'zjinli96', '2016-12-09 13:13:28'),
(1, 'MelHawn', '2016-12-09 16:42:30'),
(1, 'LAB212_pitt', '2016-12-14 07:57:16'),
(1, 'olb13', '2016-12-13 02:09:44'),
(1, 'akk54', '2016-12-09 21:09:22'),
(1, 'atayyy', '2016-12-11 13:42:42'),
(1, 'map273', '2016-12-11 16:08:07'),
(3, 'Lil_Wang', '2016-12-14 10:37:33'),
(3, 'Lil_Wang', '2016-12-13 10:49:23'),
(3, 'Lil_Wang', '2016-12-13 14:57:53'),
(3, 'Zjinli', '2016-12-14 11:13:18'),
(3, 'marisapostava', '2016-12-10 18:15:41'),
(3, 'mattbrock4', '2016-12-13 10:49:57'),
(3, 'sawyerbressler', '2016-12-10 15:34:12'),
(3, 'sawyerbressler', '2016-12-10 15:32:26'),
(3, 'LAB212_pitt', '2016-12-14 07:52:19'),
(3, 'olb13', '2016-12-13 02:10:00'),
(3, 'stg50', '2016-12-10 17:00:33'),
(4, 'mjb236', '2017-01-27 08:42:37'),
(4, 'Lil_Wang', '2016-12-13 14:59:46'),
(4, 'Lil_Wang', '2016-12-13 10:49:53'),
(4, 'Lil_Wang', '2016-12-14 10:26:28'),
(4, 'Zjinli', '2016-12-14 11:13:44'),
(4, 'marisapostava', '2016-12-10 18:16:01'),
(4, 'dhm14', '2016-12-10 13:17:39'),
(4, 'mattbrock4', '2016-12-13 10:48:50'),
(4, 'mattbrock4', '2016-12-13 10:11:51'),
(4, 'zjinli96', '2016-12-09 13:13:46'),
(4, 'sawyerbressler', '2016-12-10 15:33:33'),
(4, 'sawyerbressler', '2016-12-10 15:32:57'),
(4, 'MelHawn', '2016-12-09 16:42:45'),
(4, 'LAB212_pitt', '2016-12-14 07:57:00'),
(4, 'olb13', '2016-12-14 00:16:50'),
(4, 'olb13', '2016-12-13 02:11:25'),
(4, 'akk54', '2016-12-09 21:08:16'),
(4, 'atayyy', '2016-12-11 13:42:19'),
(4, 'map273', '2016-12-11 16:06:56'),
(5, 'Lil_Wang', '2016-12-14 10:38:36'),
(5, 'Lil_Wang', '2016-12-13 14:58:33'),
(5, 'Lil_Wang', '2016-12-13 10:50:23'),
(5, 'Zjinli', '2016-12-14 11:13:48'),
(5, 'marisapostava', '2016-12-10 18:17:07'),
(5, 'mattbrock4', '2016-12-13 10:48:58'),
(5, 'mattbrock4', '2016-12-13 10:50:21'),
(5, 'sawyerbressler', '2016-12-10 15:33:42'),
(5, 'LAB212_pitt', '2016-12-13 21:54:42'),
(5, 'LAB212_pitt', '2016-12-14 07:52:08'),
(5, 'olb13', '2016-12-13 02:11:42'),
(5, 'atayyy', '2016-12-11 13:43:34'),
(5, 'stg50', '2016-12-10 17:00:20'),
(5, 'map273', '2016-12-11 16:07:26'),
(6, 'Lil_Wang', '2016-12-13 15:01:57'),
(6, 'Lil_Wang', '2016-12-14 10:36:31'),
(6, 'Lil_Wang', '2016-12-13 20:10:26'),
(7, 'Lil_Wang', '2016-12-13 14:59:40'),
(7, 'Lil_Wang', '2016-12-13 10:48:38'),
(7, 'Lil_Wang', '2016-12-14 10:38:08'),
(7, 'Zjinli', '2016-12-14 11:15:23'),
(7, 'marisapostava', '2016-12-10 18:16:10'),
(7, 'dhm14', '2016-12-10 13:17:25'),
(7, 'jac331', '2016-12-11 23:37:23'),
(7, 'mattbrock4', '2016-12-13 10:48:00'),
(7, 'mattbrock4', '2016-12-13 10:50:12'),
(7, 'mattbrock4', '2016-12-13 10:11:21'),
(7, 'sawyerbressler', '2016-12-10 15:33:50'),
(7, 'LAB212_pitt', '2016-12-14 07:56:51'),
(7, 'LAB212_pitt', '2016-12-13 21:52:57'),
(7, 'olb13', '2016-12-13 02:11:49'),
(7, 'atayyy', '2016-12-11 13:42:08'),
(8, 'mjb236', '2017-02-05 20:44:20'),
(9, 'emcgeary', '2016-12-09 12:59:17'),
(10, 'Lil_Wang', '2016-12-14 10:36:18'),
(10, 'Lil_Wang', '2016-12-13 15:00:31'),
(10, 'Lil_Wang', '2016-12-13 20:12:15'),
(11, 'sgs38', '2016-11-20 20:54:55'),
(11, 'smc156', '2016-11-21 11:37:01'),
(11, 'janelio', '2016-11-29 12:37:21'),
(12, 'Lil_Wang', '2016-12-14 10:36:10'),
(12, 'Lil_Wang', '2016-12-13 14:59:00'),
(12, 'Lil_Wang', '2016-12-13 20:11:27'),
(12, 'Zjinli', '2016-12-14 11:14:34'),
(14, 'Lil_Wang', '2016-12-14 10:26:55'),
(14, 'Lil_Wang', '2016-12-13 14:58:07'),
(14, 'Lil_Wang', '2016-12-13 20:12:57'),
(14, 'Zjinli', '2016-12-14 11:12:15'),
(15, 'mjb236', '2017-02-06 20:38:36'),
(15, 'mjb236', '2017-02-06 20:30:45'),
(15, 'mjb236', '2017-02-06 20:36:48'),
(15, 'lizieaxes', '2017-02-06 20:53:02'),
(15, 'lizieaxes', '2017-02-06 20:32:17'),
(15, 'lizieaxes', '2017-02-06 20:55:12'),
(16, 'sgs38', '2016-12-09 12:55:57'),
(16, 'mjb236', '2017-02-05 20:43:11'),
(16, 'emcgeary', '2016-12-09 12:58:34'),
(16, 'jac331', '2016-12-11 23:41:41'),
(17, 'sgs38', '2016-11-20 20:55:20'),
(17, 'smc156', '2016-11-21 11:36:46'),
(17, 'kmccor2008', '2016-11-15 08:44:45'),
(17, 'janelio', '2016-11-29 12:37:34'),
(17, 'janelio', '2016-11-29 12:31:58'),
(17, 'janelio', '2016-11-29 12:39:06'),
(17, 'janelio', '2016-11-29 12:31:27'),
(17, 'janelio', '2016-11-29 12:39:01'),
(17, 'janelio', '2016-11-29 12:39:12'),
(17, 'Ra_vee', '2016-11-14 11:41:38'),
(17, 'Ra_vee', '2016-11-14 12:43:59'),
(17, 'Ra_vee', '2016-11-14 11:41:49'),
(17, 'Ra_vee', '2016-11-15 13:11:00'),
(17, 'Ra_vee', '2016-11-28 16:58:09'),
(17, 'Ra_vee', '2016-11-14 11:41:54'),
(17, 'Ra_vee', '2016-11-15 13:13:39'),
(18, 'mjb236', '2017-01-27 08:41:01'),
(18, 'Lil_Wang', '2016-12-14 10:36:25'),
(18, 'Lil_Wang', '2016-12-13 10:48:51'),
(18, 'Lil_Wang', '2016-12-13 14:57:13'),
(18, 'Zjinli', '2016-12-14 11:14:10'),
(18, 'marisapostava', '2016-12-10 18:16:37'),
(18, 'jac331', '2016-12-11 23:39:30'),
(18, 'mattbrock4', '2016-12-13 10:47:39'),
(18, 'mattbrock4', '2016-12-13 10:49:50'),
(18, 'zjinli96', '2016-12-09 13:13:50'),
(18, 'sawyerbressler', '2016-12-10 15:34:16'),
(18, 'LAB212_pitt', '2016-12-14 07:54:27'),
(18, 'olb13', '2016-12-13 02:11:12'),
(18, 'akk54', '2016-12-09 21:08:29'),
(18, 'atayyy', '2016-12-11 13:42:49'),
(18, 'map273', '2016-12-11 16:07:05'),
(19, 'Lil_Wang', '2016-12-14 10:38:44'),
(19, 'Lil_Wang', '2016-12-13 10:48:21'),
(19, 'Lil_Wang', '2016-12-13 14:59:21'),
(19, 'Zjinli', '2016-12-14 11:15:13'),
(19, 'marisapostava', '2016-12-10 18:16:59'),
(19, 'dhm14', '2016-12-10 13:17:33'),
(19, 'jac331', '2016-12-11 23:40:10'),
(19, 'mattbrock4', '2016-12-13 10:50:03'),
(19, 'mattbrock4', '2016-12-13 10:12:12'),
(19, 'zjinli96', '2016-12-09 13:14:06'),
(19, 'sawyerbressler', '2016-12-10 15:33:37'),
(19, 'MelHawn', '2016-12-09 16:42:37'),
(19, 'LAB212_pitt', '2016-12-13 21:54:09'),
(19, 'LAB212_pitt', '2016-12-14 07:58:06'),
(19, 'olb13', '2016-12-14 00:16:44'),
(19, 'olb13', '2016-12-13 02:10:54'),
(19, 'akk54', '2016-12-09 21:09:01'),
(19, 'atayyy', '2016-12-11 13:42:55'),
(19, 'stg50', '2016-12-10 17:00:02'),
(19, 'map273', '2016-12-11 16:07:45'),
(20, 'Lil_Wang', '2016-12-14 10:38:19'),
(20, 'Lil_Wang', '2016-12-13 10:50:01'),
(20, 'Lil_Wang', '2016-12-13 15:02:06'),
(20, 'Zjinli', '2016-12-14 11:13:02'),
(20, 'marisapostava', '2016-12-10 18:16:47'),
(20, 'mattbrock4', '2016-12-13 10:49:19'),
(20, 'mattbrock4', '2016-12-13 10:50:58'),
(20, 'zjinli96', '2016-12-09 13:14:02'),
(20, 'sawyerbressler', '2016-12-10 15:34:05'),
(20, 'sawyerbressler', '2016-12-10 15:32:11'),
(20, 'sawyerbressler', '2016-12-10 15:32:52'),
(20, 'LAB212_pitt', '2016-12-14 07:56:11'),
(20, 'olb13', '2016-12-13 02:10:16'),
(20, 'olb13', '2016-12-14 00:15:09'),
(20, 'akk54', '2016-12-09 21:08:55'),
(20, 'atayyy', '2016-12-11 13:43:24'),
(20, 'map273', '2016-12-11 16:07:55'),
(23, 'Lil_Wang', '2016-12-14 10:26:15'),
(23, 'Lil_Wang', '2016-12-13 15:00:46'),
(23, 'Lil_Wang', '2016-12-13 20:11:42'),
(23, 'Zjinli', '2016-12-14 11:15:10'),
(23, 'LAB212_pitt', '2016-12-14 07:57:58'),
(23, 'olb13', '2016-12-14 00:15:35'),
(24, 'mjb236', '2017-02-05 20:42:54'),
(24, 'emcgeary', '2016-12-09 12:58:44'),
(24, 'jac331', '2016-12-11 23:41:26'),
(24, 'Ra_vee', '2016-11-29 13:37:26'),
(25, 'Lil_Wang', '2016-12-13 20:10:34'),
(25, 'Lil_Wang', '2016-12-13 14:58:26'),
(25, 'Lil_Wang', '2016-12-14 10:38:27'),
(25, 'Zjinli', '2016-12-14 11:12:40'),
(25, 'olb13', '2016-12-14 00:15:56'),
(27, 'Lil_Wang', '2016-12-13 14:57:38'),
(27, 'Lil_Wang', '2016-12-14 10:27:04'),
(27, 'Lil_Wang', '2016-12-13 10:49:41'),
(27, 'Zjinli', '2016-12-14 11:15:30'),
(27, 'marisapostava', '2016-12-10 18:17:04'),
(27, 'dhm14', '2016-12-10 13:17:15'),
(27, 'mattbrock4', '2016-12-13 10:48:15'),
(27, 'mattbrock4', '2016-12-13 10:50:53'),
(27, 'zjinli96', '2016-12-09 13:14:13'),
(27, 'sawyerbressler', '2016-12-10 15:32:47'),
(27, 'sawyerbressler', '2016-12-10 15:33:28'),
(27, 'MelHawn', '2016-12-09 16:42:52'),
(27, 'LAB212_pitt', '2016-12-14 07:55:15'),
(27, 'olb13', '2016-12-13 02:09:31'),
(27, 'akk54', '2016-12-09 21:08:48'),
(27, 'atayyy', '2016-12-11 13:42:27'),
(27, 'map273', '2016-12-11 16:07:37'),
(28, 'emcgeary', '2016-12-09 13:00:13'),
(28, 'Lil_Wang', '2016-12-14 10:36:43'),
(28, 'Lil_Wang', '2016-12-13 10:48:29'),
(28, 'Lil_Wang', '2016-12-13 15:01:29'),
(28, 'Zjinli', '2016-12-14 11:14:05'),
(28, 'marisapostava', '2016-12-10 18:15:51'),
(28, 'mattbrock4', '2016-12-13 10:50:27'),
(28, 'mattbrock4', '2016-12-13 10:48:08'),
(28, 'mattbrock4', '2016-12-13 10:11:10'),
(28, 'zjinli96', '2016-12-09 13:13:36'),
(28, 'sawyerbressler', '2016-12-10 15:33:00'),
(28, 'sawyerbressler', '2016-12-10 15:32:02'),
(28, 'sawyerbressler', '2016-12-10 15:34:01'),
(28, 'LAB212_pitt', '2016-12-13 21:51:34'),
(28, 'olb13', '2016-12-13 02:11:07'),
(28, 'olb13', '2016-12-14 00:14:43'),
(28, 'atayyy', '2016-12-11 13:43:39'),
(28, 'map273', '2016-12-11 16:07:32'),
(30, 'emcgeary', '2016-12-09 13:00:19'),
(30, 'emcgeary', '2016-12-09 12:57:08'),
(30, 'Lil_Wang', '2016-12-13 15:01:35'),
(30, 'Lil_Wang', '2016-12-13 10:49:09'),
(30, 'Lil_Wang', '2016-12-14 10:35:56'),
(30, 'jac331', '2016-12-11 23:39:02'),
(30, 'mattbrock4', '2016-12-13 10:50:35'),
(30, 'mattbrock4', '2016-12-13 10:47:52'),
(30, 'zjinli96', '2016-12-09 13:13:33'),
(30, 'sawyerbressler', '2016-12-10 15:33:22'),
(30, 'MelHawn', '2016-12-09 16:43:03'),
(30, 'olb13', '2016-12-13 02:11:19'),
(30, 'olb13', '2016-12-14 00:15:18'),
(30, 'atayyy', '2016-12-11 13:43:30'),
(30, 'map273', '2016-12-11 16:07:49'),
(31, 'Lil_Wang', '2016-12-13 15:01:20'),
(31, 'Lil_Wang', '2016-12-13 10:49:33'),
(31, 'Lil_Wang', '2016-12-14 10:37:08'),
(31, 'Zjinli', '2016-12-14 11:13:23'),
(31, 'marisapostava', '2016-12-10 18:16:17'),
(31, 'dhm14', '2016-12-10 13:17:43'),
(31, 'jac331', '2016-12-11 23:39:14'),
(31, 'mattbrock4', '2016-12-13 10:49:05'),
(31, 'mattbrock4', '2016-12-13 10:50:08'),
(31, 'zjinli96', '2016-12-09 13:14:17'),
(31, 'sawyerbressler', '2016-12-10 15:33:56'),
(31, 'sawyerbressler', '2016-12-10 15:32:18'),
(31, 'sawyerbressler', '2016-12-10 15:32:42'),
(31, 'LAB212_pitt', '2016-12-13 21:50:57'),
(31, 'LAB212_pitt', '2016-12-14 07:52:33'),
(31, 'olb13', '2016-12-13 02:11:36'),
(31, 'akk54', '2016-12-09 21:09:10'),
(31, 'atayyy', '2016-12-11 13:42:35'),
(31, 'stg50', '2016-12-10 17:00:09'),
(31, 'map273', '2016-12-11 16:07:41'),
(33, 'mjb236', '2017-02-06 20:38:27'),
(33, 'mjb236', '2017-02-06 20:36:51'),
(33, 'lizieaxes', '2017-02-06 20:55:17'),
(34, 'Lil_Wang', '2016-12-14 10:37:41'),
(34, 'Lil_Wang', '2016-12-13 14:58:48'),
(34, 'Lil_Wang', '2016-12-13 20:12:36'),
(34, 'Zjinli', '2016-12-14 11:15:37'),
(35, 'Lil_Wang', '2016-12-14 10:36:36'),
(35, 'Lil_Wang', '2016-12-13 20:12:44'),
(35, 'Lil_Wang', '2016-12-13 15:00:01'),
(35, 'LAB212_pitt', '2016-12-14 07:54:43'),
(36, 'Lil_Wang', '2016-12-13 15:01:47'),
(36, 'Lil_Wang', '2016-12-14 10:35:44'),
(36, 'Lil_Wang', '2016-12-13 20:11:20'),
(36, 'Zjinli', '2016-12-14 11:12:48'),
(37, 'mjb236', '2017-01-27 08:41:47'),
(37, 'Lil_Wang', '2016-12-13 20:12:08'),
(37, 'Lil_Wang', '2016-12-13 15:00:10'),
(37, 'Zjinli', '2016-12-14 11:14:53'),
(37, 'olb13', '2016-12-14 00:16:32'),
(38, 'sgs38', '2016-12-09 12:56:27'),
(38, 'emcgeary', '2016-12-09 12:58:21'),
(38, 'jac331', '2016-12-11 23:41:34'),
(39, 'mjb236', '2017-01-27 08:42:17'),
(39, 'Lil_Wang', '2016-12-13 20:11:33'),
(39, 'Lil_Wang', '2016-12-14 10:36:50'),
(39, 'Lil_Wang', '2016-12-13 14:57:25'),
(39, 'Zjinli', '2016-12-14 11:12:23'),
(39, 'LAB212_pitt', '2016-12-14 07:57:44'),
(39, 'LAB212_pitt', '2016-12-13 21:52:28'),
(39, 'olb13', '2016-12-14 00:15:00'),
(41, 'mjb236', '2017-02-06 20:38:32'),
(41, 'lizieaxes', '2017-02-06 20:53:57'),
(41, 'lizieaxes', '2017-02-06 20:55:22'),
(42, 'Lil_Wang', '2016-12-13 14:59:52'),
(42, 'Lil_Wang', '2016-12-13 20:10:39'),
(42, 'Lil_Wang', '2016-12-14 10:26:34'),
(42, 'Zjinli', '2016-12-14 11:15:27'),
(42, 'LAB212_pitt', '2016-12-14 07:54:32'),
(44, 'emcgeary', '2016-12-09 12:59:07'),
(44, 'jac331', '2016-12-11 23:41:49');

-- --------------------------------------------------------

--
-- Table structure for table `question_review`
--

CREATE TABLE `question_review` (
  `question_id` int(10) UNSIGNED NOT NULL,
  `created_date` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Table structure for table `question_review_history`
--

CREATE TABLE `question_review_history` (
  `review_id` int(10) UNSIGNED NOT NULL,
  `question_id` int(10) UNSIGNED NOT NULL,
  `review_outcome` varchar(500) DEFAULT NULL,
  `review_date` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `reviewed_by` varchar(20) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Table structure for table `quiz`
--

CREATE TABLE `quiz` (
  `quiz_id` int(10) UNSIGNED NOT NULL,
  `category_id` int(10) UNSIGNED NOT NULL,
  `quiz_name` varchar(50) NOT NULL,
  `description` varchar(256) DEFAULT NULL,
  `created_date` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `created_by` varchar(20) NOT NULL,
  `last_updated_date` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `last_updated_by` varchar(20) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `quiz`
--

INSERT INTO `quiz` (`quiz_id`, `category_id`, `quiz_name`, `description`, `created_date`, `created_by`, `last_updated_date`, `last_updated_by`) VALUES
(1, 1, 'Exam 3', NULL, '2017-02-07 22:15:30', 'mjb236', '2017-02-07 22:15:30', 'mjb236'),
(2, 1, 'Exam 1', NULL, '2017-02-07 22:16:11', 'mjb236', '2017-02-07 22:16:11', 'mjb236'),
(3, 1, 'Exam 2', NULL, '2017-02-07 22:16:11', 'mjb236', '2017-02-07 22:16:11', 'mjb236'),
(4, 2, 'Exam 3', NULL, '2017-02-07 22:16:11', 'mjb236', '2017-02-07 22:16:11', 'mjb236'),
(5, 2, 'Exam 1', NULL, '2017-02-07 22:16:11', 'mjb236', '2017-02-07 22:16:11', 'mjb236'),
(6, 2, 'Exam 2', NULL, '2017-02-07 22:16:11', 'mjb236', '2017-02-07 22:16:11', 'mjb236'),
(7, 3, 'Mike Quiz 1', NULL, '2017-02-07 22:16:11', 'mjb236', '2017-02-07 22:16:11', 'mjb236'),
(8, 4, 'Test Quiz 1', NULL, '2017-02-07 22:16:11', 'mjb236', '2017-02-07 22:16:11', 'mjb236'),
(9, 5, 'Exam 2', NULL, '2017-02-07 22:16:11', 'mjb236', '2017-02-07 22:16:11', 'mjb236'),
(10, 5, 'Exam 3', NULL, '2017-02-07 22:16:11', 'mjb236', '2017-02-07 22:16:11', 'mjb236'),
(12, 6, 'Top Drugs Final', NULL, '2017-02-07 22:16:11', 'mjb236', '2017-02-07 22:16:11', 'mjb236');

-- --------------------------------------------------------

--
-- Table structure for table `user`
--

CREATE TABLE `user` (
  `username` varchar(20) NOT NULL,
  `password` varchar(60) NOT NULL,
  `email_address` varchar(256) NOT NULL,
  `admin_flag` enum('Y','N') DEFAULT NULL,
  `verified_flag` enum('Y','N') DEFAULT NULL,
  `active_flag` enum('Y','N') DEFAULT NULL,
  `registered_date` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `user`
--

INSERT INTO `user` (`username`, `password`, `email_address`, `admin_flag`, `verified_flag`, `active_flag`, `registered_date`) VALUES
('akk54', 'default', 'default', NULL, NULL, NULL, '2016-11-01 00:00:00'),
('ard71', 'default', 'default', NULL, NULL, NULL, '2016-11-01 00:00:00'),
('Arm148', 'default', 'default', NULL, NULL, NULL, '2016-11-01 00:00:00'),
('asdf', 'default', 'default', NULL, NULL, NULL, '2016-11-01 00:00:00'),
('atayyy', 'default', 'default', NULL, NULL, NULL, '2016-11-01 00:00:00'),
('BMURR', 'default', 'default', NULL, NULL, NULL, '2016-11-01 00:00:00'),
('bogdanbg24', 'default', 'default', NULL, NULL, NULL, '2016-11-01 00:00:00'),
('cdb69', 'default', 'default', NULL, NULL, NULL, '2016-11-01 00:00:00'),
('dhm14', 'default', 'default', NULL, NULL, NULL, '2016-11-01 00:00:00'),
('emcgeary', 'default', 'default', NULL, NULL, NULL, '2016-11-01 00:00:00'),
('jac331', 'default', 'default', NULL, NULL, NULL, '2016-11-01 00:00:00'),
('janelio', 'default', 'default', NULL, NULL, NULL, '2016-11-01 00:00:00'),
('JaradIckes', 'default', 'default', NULL, NULL, NULL, '2016-11-01 00:00:00'),
('josh_hochuli', 'default', 'default', NULL, NULL, NULL, '2016-11-01 00:00:00'),
('kmccor2008', 'default', 'default', NULL, NULL, NULL, '2016-11-01 00:00:00'),
('Kryson53', 'default', 'default', NULL, NULL, NULL, '2016-11-01 00:00:00'),
('LAB212_pitt', 'default', 'default', NULL, NULL, NULL, '2016-11-01 00:00:00'),
('Lil_Wang', 'default', 'default', NULL, NULL, NULL, '2016-11-01 00:00:00'),
('lizieaxes', 'default', 'default', NULL, NULL, NULL, '2016-11-01 00:00:00'),
('map259', 'default', 'default', NULL, NULL, NULL, '2016-11-01 00:00:00'),
('map273', 'default', 'default', NULL, NULL, NULL, '2016-11-01 00:00:00'),
('marisapostava', 'default', 'default', NULL, NULL, NULL, '2016-11-01 00:00:00'),
('mattbrock4', 'default', 'default', NULL, NULL, NULL, '2016-11-01 00:00:00'),
('MelHawn', 'default', 'default', NULL, NULL, NULL, '2016-11-01 00:00:00'),
('mjb236', 'default', 'default', NULL, NULL, NULL, '2016-11-01 00:00:00'),
('olb13', 'default', 'default', NULL, NULL, NULL, '2016-11-01 00:00:00'),
('PittInovation', 'default', 'default', NULL, NULL, NULL, '2016-11-01 00:00:00'),
('Ra_vee', 'default', 'default', NULL, NULL, NULL, '2016-11-01 00:00:00'),
('ROP', 'default', 'default', NULL, NULL, NULL, '2016-11-01 00:00:00'),
('RP1', 'default', 'default', NULL, NULL, NULL, '2016-11-01 00:00:00'),
('sawyerbressler', 'default', 'default', NULL, NULL, NULL, '2016-11-01 00:00:00'),
('sgs38', 'default', 'default', NULL, NULL, NULL, '2016-11-01 00:00:00'),
('smc156', 'default', 'default', NULL, NULL, NULL, '2016-11-01 00:00:00'),
('stg50', 'default', 'default', NULL, NULL, NULL, '2016-11-01 00:00:00'),
('Sunder', 'default', 'default', NULL, NULL, NULL, '2016-11-01 00:00:00'),
('Tyler', 'default', 'default', NULL, NULL, NULL, '2016-11-01 00:00:00'),
('Zjinli', 'default', 'default', NULL, NULL, NULL, '2016-11-01 00:00:00'),
('zjinli96', 'default', 'default', NULL, NULL, NULL, '2016-11-01 00:00:00'),
('znaeb', 'default', 'default', NULL, NULL, NULL, '2016-11-01 00:00:00');

-- --------------------------------------------------------

--
-- Table structure for table `user_profile`
--

CREATE TABLE `user_profile` (
  `username` varchar(20) NOT NULL,
  `full_name` varchar(50) NOT NULL,
  `year` varchar(10) NOT NULL,
  `employer` varchar(50) DEFAULT NULL,
  `interests` varchar(256) DEFAULT NULL,
  `bio` varchar(500) DEFAULT NULL,
  `image_url` varchar(256) DEFAULT NULL,
  `created_date` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `last_updated_date` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `last_updated_by` varchar(20) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `user_profile`
--

INSERT INTO `user_profile` (`username`, `full_name`, `year`, `employer`, `interests`, `bio`, `image_url`, `created_date`, `last_updated_date`, `last_updated_by`) VALUES
('akk54', 'Abby Kois', '2020', 'null', 'null', 'null', NULL, '2017-02-07 21:58:47', '2017-02-07 21:58:47', 'mjb236'),
('ard71', 'Ariella', '2017', 'null', 'null', 'null', NULL, '2017-02-07 21:58:46', '2017-02-07 21:58:46', 'mjb236'),
('Arm148', 'Adam', 'Senior', 'null', 'null', 'null', NULL, '2017-02-07 21:58:47', '2017-02-07 21:58:47', 'mjb236'),
('asdf', 'asdf', 'asdf', 'asdf', 'asdf', 'asd', NULL, '2017-02-07 21:58:47', '2017-02-07 21:58:47', 'mjb236'),
('atayyy', 'Alexandria Taylor', '2020', 'null', 'null', 'null', NULL, '2017-02-07 21:58:47', '2017-02-07 21:58:47', 'mjb236'),
('BMURR', 'Brendan Murray', '2016', 'plz employ me', 'Raquetball', 'Free cake for every creature', NULL, '2017-02-07 21:58:47', '2017-02-07 21:58:47', 'mjb236'),
('bogdanbg24', 'Bogdan Kotzev', 'Senior', 'null', 'null', 'null', NULL, '2017-02-07 21:58:47', '2017-02-07 21:58:47', 'mjb236'),
('cdb69', 'Colton Byerly', 'P1', 'null', 'null', 'null', NULL, '2017-02-07 21:58:46', '2017-02-07 21:58:46', 'mjb236'),
('dhm14', 'DIana Mansour', 'P1', 'null', 'null', 'null', NULL, '2017-02-07 21:58:47', '2017-02-07 21:58:47', 'mjb236'),
('emcgeary', 'Evan McGarry', 'P1', 'null', 'null', 'null', NULL, '2017-02-07 21:58:46', '2017-02-07 21:58:46', 'mjb236'),
('jac331', 'Jaehee Cho', 'P1', 'null', 'null', 'null', NULL, '2017-02-07 21:58:47', '2017-02-07 21:58:47', 'mjb236'),
('janelio', 'Marijanel Alilio', 'P3', 'null', 'null', 'null', NULL, '2017-02-07 21:58:47', '2017-02-07 21:58:47', 'mjb236'),
('JaradIckes', 'Jarad Ickes', 'P1', 'PittPharmacy', 'null', 'null', NULL, '2017-02-07 21:58:47', '2017-02-07 21:58:47', 'mjb236'),
('josh_hochuli', 'Josh Hochuli', '2018', 'University of Pittsburgh', 'Pokemon', 'Yes', NULL, '2017-02-07 21:58:47', '2017-02-07 21:58:47', 'mjb236'),
('kmccor2008', 'Kyle McCormick', '2014', 'Gatti Pharmacy', 'technology', 'null', NULL, '2017-02-07 21:58:47', '2017-02-07 21:58:47', 'mjb236'),
('Kryson53', 'Zack Shahen', 'Sophomore', 'Willie\'s', 'Photography', 'I\'m cooool', NULL, '2017-02-07 21:58:47', '2017-02-07 21:58:47', 'mjb236'),
('LAB212_pitt', 'Lauren Brock', '2020', 'null', 'null', 'null', NULL, '2017-02-07 21:58:47', '2017-02-07 21:58:47', 'mjb236'),
('Lil_Wang', 'John Wang', '2020', 'null', 'null', 'chem.', NULL, '2017-02-07 21:58:46', '2017-02-07 21:58:46', 'mjb236'),
('lizieaxes', 'Melanie Root', 'Freshman', 'null', 'null', 'null', NULL, '2017-02-07 21:58:46', '2017-02-07 21:58:46', 'mjb236'),
('map259', 'Mark', 'Senior', 'null', 'null', 'null', NULL, '2017-02-07 21:58:47', '2017-02-07 21:58:47', 'mjb236'),
('map273', 'Megha Patel', '2020', 'null', 'null', 'null', NULL, '2017-02-07 21:58:47', '2017-02-07 21:58:47', 'mjb236'),
('marisapostava', 'Marisa Postava', 'P1 2020', 'null', 'Critical Care, Specialty Pharmacy', 'null', NULL, '2017-02-07 21:58:47', '2017-02-07 21:58:47', 'mjb236'),
('mattbrock4', 'Matthew', '', 'null', 'null', 'null', NULL, '2017-02-07 21:58:47', '2017-02-07 21:58:47', 'mjb236'),
('MelHawn', 'Melanie Hawn', '2020', 'null', 'null', 'null', NULL, '2017-02-07 21:58:47', '2017-02-07 21:58:47', 'mjb236'),
('mjb236', 'Mike Bowen', 'Senior', 'UPMC', 'Interests', 'Bio', NULL, '2017-02-07 21:58:47', '2017-02-07 21:58:47', 'mjb236'),
('olb13', 'Funto', '2020', 'null', 'null', 'null', NULL, '2017-02-07 21:58:47', '2017-02-07 21:58:47', 'mjb236'),
('PittInovation', 'RP', '2019', 'Durgz', 'Drugs', 'Durgz', NULL, '2017-02-07 21:58:47', '2017-02-07 21:58:47', 'mjb236'),
('Ra_vee', 'Pee', '2019', 'Pitt', 'Tech', 'Tech and mechs', NULL, '2017-02-07 21:58:47', '2017-02-07 21:58:47', 'mjb236'),
('ROP', 'RP', '2016', 'Pitt', 'Pitt', 'Pitt', NULL, '2017-02-07 21:58:47', '2017-02-07 21:58:47', 'mjb236'),
('RP1', 'RP', '2016', 'Umbrella Corp', 'Some', 'Born, Live, Liver', NULL, '2017-02-07 21:58:47', '2017-02-07 21:58:47', 'mjb236'),
('sawyerbressler', 'Sawyer', '2020', 'null', 'null', 'null', NULL, '2017-02-07 21:58:47', '2017-02-07 21:58:47', 'mjb236'),
('sgs38', 'Spencer Schlecht', 'P1', 'null', 'Games, sports, competition, puzzles', 'null', NULL, '2017-02-07 21:58:47', '2017-02-07 21:58:47', 'mjb236'),
('smc156', 'Sophia', '2019', 'null', 'null', 'null', NULL, '2017-02-07 21:58:47', '2017-02-07 21:58:47', 'mjb236'),
('stg50', 'Samantha George', 'P1', 'null', 'null', 'null', NULL, '2017-02-07 21:58:47', '2017-02-07 21:58:47', 'mjb236'),
('Sunder', 'Sam Underwood', 'Senior', 'Sunder Applications', 'CS', 'I\'m helping to write this Web app.', NULL, '2017-02-07 21:58:47', '2017-02-07 21:58:47', 'mjb236'),
('Tyler', 'Tyler Kosmacki', '2016', 'null', 'null', 'null', NULL, '2017-02-07 21:58:47', '2017-02-07 21:58:47', 'mjb236'),
('Zjinli', 'Jinli', 'P1', 'null', 'null', 'null', NULL, '2017-02-07 21:58:46', '2017-02-07 21:58:46', 'mjb236'),
('zjinli96', 'Jinli Zhao', '1996', 'null', 'null', 'null', NULL, '2017-02-07 21:58:47', '2017-02-07 21:58:47', 'mjb236'),
('znaeb', 'Lord of Madness', '2016', 'Laboon Industries', 'Chaos', 'null', NULL, '2017-02-07 21:58:46', '2017-02-07 21:58:46', 'mjb236');

-- --------------------------------------------------------

--
-- Table structure for table `votes`
--

CREATE TABLE `votes` (
  `question_id` int(10) UNSIGNED NOT NULL,
  `username` varchar(20) NOT NULL,
  `value` tinyint(4) NOT NULL DEFAULT '0',
  `created_date` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `last_updated_date` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `votes`
--

INSERT INTO `votes` (`question_id`, `username`, `value`, `created_date`, `last_updated_date`) VALUES
(22, 'Ra_vee', -1, '2017-02-09 18:34:49', '2017-02-09 18:34:49'),
(26, 'sgs38', 1, '2017-02-09 18:34:49', '2017-02-09 18:34:49');

-- --------------------------------------------------------

--
-- Stand-in structure for view `vw_alluserscores`
-- (See below for the actual view)
--
CREATE TABLE `vw_alluserscores` (
`username` varchar(20)
,`score` decimal(32,0)
);

-- --------------------------------------------------------

--
-- Stand-in structure for view `vw_userswithscores`
-- (See below for the actual view)
--
CREATE TABLE `vw_userswithscores` (
`username` varchar(20)
,`score` decimal(32,0)
);

-- --------------------------------------------------------

--
-- Structure for view `vw_alluserscores`
--
DROP TABLE IF EXISTS `vw_alluserscores`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY INVOKER VIEW `vw_alluserscores`  AS  select `u`.`username` AS `username`,ifnull(`s`.`score`,0) AS `score` from (`user` `u` left join `vw_userswithscores` `s` on((`u`.`username` = `s`.`username`))) order by ifnull(`s`.`score`,0) desc ;

-- --------------------------------------------------------

--
-- Structure for view `vw_userswithscores`
--
DROP TABLE IF EXISTS `vw_userswithscores`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY INVOKER VIEW `vw_userswithscores`  AS  select `qac`.`username` AS `username`,sum(`q`.`score`) AS `score` from (`questions_correctly_answered` `qac` join `question` `q` on((`q`.`question_id` = `qac`.`question_id`))) group by `qac`.`username` ;

--
-- Indexes for dumped tables
--

--
-- Indexes for table `answer`
--
ALTER TABLE `answer`
  ADD PRIMARY KEY (`answer_id`),
  ADD KEY `question_id` (`question_id`),
  ADD KEY `last_updated_by` (`last_updated_by`);

--
-- Indexes for table `category`
--
ALTER TABLE `category`
  ADD PRIMARY KEY (`category_id`),
  ADD KEY `category_name` (`category_name`),
  ADD KEY `created_by` (`created_by`),
  ADD KEY `last_updated_by` (`last_updated_by`);

--
-- Indexes for table `question`
--
ALTER TABLE `question`
  ADD PRIMARY KEY (`question_id`),
  ADD KEY `quiz_id` (`quiz_id`),
  ADD KEY `last_updated_by` (`last_updated_by`),
  ADD KEY `created_by` (`created_by`);

--
-- Indexes for table `questions_correctly_answered`
--
ALTER TABLE `questions_correctly_answered`
  ADD KEY `username` (`username`);

--
-- Indexes for table `question_review`
--
ALTER TABLE `question_review`
  ADD PRIMARY KEY (`question_id`);

--
-- Indexes for table `question_review_history`
--
ALTER TABLE `question_review_history`
  ADD PRIMARY KEY (`review_id`),
  ADD KEY `question_id` (`question_id`),
  ADD KEY `reviewed_by` (`reviewed_by`);

--
-- Indexes for table `quiz`
--
ALTER TABLE `quiz`
  ADD PRIMARY KEY (`quiz_id`),
  ADD KEY `category_id` (`category_id`),
  ADD KEY `created_by` (`created_by`),
  ADD KEY `last_updated_by` (`last_updated_by`);

--
-- Indexes for table `user`
--
ALTER TABLE `user`
  ADD PRIMARY KEY (`username`);

--
-- Indexes for table `user_profile`
--
ALTER TABLE `user_profile`
  ADD PRIMARY KEY (`username`),
  ADD KEY `last_updated_by` (`last_updated_by`);

--
-- Indexes for table `votes`
--
ALTER TABLE `votes`
  ADD PRIMARY KEY (`question_id`,`username`),
  ADD KEY `username` (`username`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `answer`
--
ALTER TABLE `answer`
  MODIFY `answer_id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=177;
--
-- AUTO_INCREMENT for table `category`
--
ALTER TABLE `category`
  MODIFY `category_id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;
--
-- AUTO_INCREMENT for table `question`
--
ALTER TABLE `question`
  MODIFY `question_id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=45;
--
-- AUTO_INCREMENT for table `question_review_history`
--
ALTER TABLE `question_review_history`
  MODIFY `review_id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT;
--
-- AUTO_INCREMENT for table `quiz`
--
ALTER TABLE `quiz`
  MODIFY `quiz_id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=13;
--
-- Constraints for dumped tables
--

--
-- Constraints for table `answer`
--
ALTER TABLE `answer`
  ADD CONSTRAINT `answer_ibfk_1` FOREIGN KEY (`last_updated_by`) REFERENCES `user` (`username`),
  ADD CONSTRAINT `answer_ibfk_2` FOREIGN KEY (`question_id`) REFERENCES `question` (`question_id`);

--
-- Constraints for table `category`
--
ALTER TABLE `category`
  ADD CONSTRAINT `category_ibfk_1` FOREIGN KEY (`created_by`) REFERENCES `user` (`username`),
  ADD CONSTRAINT `category_ibfk_2` FOREIGN KEY (`last_updated_by`) REFERENCES `user` (`username`);

--
-- Constraints for table `question`
--
ALTER TABLE `question`
  ADD CONSTRAINT `question_ibfk_1` FOREIGN KEY (`quiz_id`) REFERENCES `quiz` (`quiz_id`),
  ADD CONSTRAINT `question_ibfk_2` FOREIGN KEY (`created_by`) REFERENCES `user` (`username`),
  ADD CONSTRAINT `question_ibfk_3` FOREIGN KEY (`last_updated_by`) REFERENCES `user` (`username`);

--
-- Constraints for table `questions_correctly_answered`
--
ALTER TABLE `questions_correctly_answered`
  ADD CONSTRAINT `questions_correctly_answered_ibfk_1` FOREIGN KEY (`username`) REFERENCES `user` (`username`);

--
-- Constraints for table `question_review`
--
ALTER TABLE `question_review`
  ADD CONSTRAINT `question_review_ibfk_1` FOREIGN KEY (`question_id`) REFERENCES `question` (`question_id`);

--
-- Constraints for table `question_review_history`
--
ALTER TABLE `question_review_history`
  ADD CONSTRAINT `question_review_history_ibfk_1` FOREIGN KEY (`question_id`) REFERENCES `question` (`question_id`),
  ADD CONSTRAINT `question_review_history_ibfk_2` FOREIGN KEY (`reviewed_by`) REFERENCES `user` (`username`);

--
-- Constraints for table `quiz`
--
ALTER TABLE `quiz`
  ADD CONSTRAINT `quiz_ibfk_1` FOREIGN KEY (`category_id`) REFERENCES `category` (`category_id`),
  ADD CONSTRAINT `quiz_ibfk_2` FOREIGN KEY (`created_by`) REFERENCES `user` (`username`),
  ADD CONSTRAINT `quiz_ibfk_3` FOREIGN KEY (`last_updated_by`) REFERENCES `user` (`username`);

--
-- Constraints for table `user_profile`
--
ALTER TABLE `user_profile`
  ADD CONSTRAINT `user_profile_ibfk_1` FOREIGN KEY (`last_updated_by`) REFERENCES `user` (`username`);

--
-- Constraints for table `votes`
--
ALTER TABLE `votes`
  ADD CONSTRAINT `votes_ibfk_1` FOREIGN KEY (`question_id`) REFERENCES `question` (`question_id`),
  ADD CONSTRAINT `votes_ibfk_2` FOREIGN KEY (`username`) REFERENCES `user` (`username`);

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
