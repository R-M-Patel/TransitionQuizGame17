-- phpMyAdmin SQL Dump
-- version 4.6.5.2
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Apr 14, 2017 at 04:11 AM
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
-- Procedures
--
DROP PROCEDURE IF EXISTS `sp_createCategoryAndQuiz`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_createCategoryAndQuiz` (IN `p_username` VARCHAR(20), IN `p_categoryName` VARCHAR(50), IN `p_quizName` VARCHAR(50))  MODIFIES SQL DATA
    SQL SECURITY INVOKER
BEGIN
  DECLARE newCatId INT(10);
  INSERT INTO category
  	(category_name, verified_flag, active_flag, created_by, last_updated_by)
  VALUES
  	(p_categoryName, 'N', 'Y', p_userName, p_username);
  COMMIT;
  SELECT category_id INTO newCatId
  FROM category
  where category_name = p_categoryName;
  INSERT INTO quiz
    (category_id, quiz_name, active_flag, removed_flag, created_by, last_updated_by)
  VALUES
    (newCatId, p_quizName, 'Y', 'N', p_username, p_username);
  COMMIT;
  
END$$

DROP PROCEDURE IF EXISTS `sp_createQuestion`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_createQuestion` (IN `p_username` VARCHAR(20), IN `p_questionText` VARCHAR(500), IN `p_quizId` INT(10), IN `p_correctAnswer` VARCHAR(256), IN `p_answer1` VARCHAR(256), IN `p_answer2` VARCHAR(256), IN `p_answer3` VARCHAR(256), IN `p_answer4` VARCHAR(256), IN `p_explanation` VARCHAR(500))  MODIFIES SQL DATA
    SQL SECURITY INVOKER
BEGIN
  DECLARE newQuestionId INT(10);
  INSERT INTO question
    (question_text, quiz_id, score, times_correctly_answered, times_answered, explanation, verified_flag, active_flag, removed_flag, removed_date, created_by, last_updated_by)
  VALUES
  	(p_questionText, p_quizId, 100, 0, 0, p_explanation, 'N', 'Y', 'N', null, p_username, p_username);
  COMMIT;
    
  SELECT max(question_id) INTO newQuestionId
  FROM question;
    
  INSERT INTO answer
    (question_id, answer_text, correct_flag, times_chosen, last_updated_by)
  VALUES
    (newQuestionId, p_answer1, CASE WHEN p_correctAnswer = p_answer1 THEN 'Y' ELSE 'N' END, 0, p_username);
    INSERT INTO answer
    (question_id, answer_text, correct_flag, times_chosen, last_updated_by)
  VALUES
    (newQuestionId, p_answer2, CASE WHEN p_correctAnswer = p_answer2 THEN 'Y' ELSE 'N' END, 0, p_username);
    INSERT INTO answer
    (question_id, answer_text, correct_flag, times_chosen, last_updated_by)
  VALUES
    (newQuestionId, p_answer3, CASE WHEN p_correctAnswer = p_answer3 THEN 'Y' ELSE 'N' END, 0, p_username);
    INSERT INTO answer
    (question_id, answer_text, correct_flag, times_chosen, last_updated_by)
  VALUES
    (newQuestionId, p_answer4, CASE WHEN p_correctAnswer = p_answer4 THEN 'Y' ELSE 'N' END, 0, p_username);
  
END$$

DROP PROCEDURE IF EXISTS `sp_createUserAccount`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_createUserAccount` (IN `p_username` VARCHAR(20), IN `p_password` VARCHAR(60), IN `p_name` VARCHAR(20), IN `p_year` VARCHAR(10), IN `p_employer` VARCHAR(50), IN `p_bio` VARCHAR(256), IN `p_interests` VARCHAR(500), IN `p_emailAddress` VARCHAR(256))  MODIFIES SQL DATA
    SQL SECURITY INVOKER
BEGIN
  INSERT INTO user
  	(username, password, email_address, score, admin_flag, owner_flag, active_flag)
  VALUES
    (p_username, p_password, p_emailAddress, 0, 'N', 'N', 'Y');
  COMMIT;
  
  INSERT INTO user_profile
    (username, full_name, year, employer, bio, interests, last_updated_by)
  VALUES
    (p_username, p_name, p_year, p_employer, p_bio, p_interests, p_username);
  COMMIT;
END$$

DROP PROCEDURE IF EXISTS `sp_resetUserScore`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_resetUserScore` (IN `p_username` VARCHAR(20))  MODIFIES SQL DATA
    SQL SECURITY INVOKER
BEGIN
  DELETE FROM answer_log
  WHERE username = p_username;
  
  UPDATE user
  SET score = 0
  WHERE username = p_username;
END$$

--
-- Functions
--
DROP FUNCTION IF EXISTS `sp_getScoreForUser`$$
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
-- Table structure for table `admin_email_addresses`
--

DROP TABLE IF EXISTS `admin_email_addresses`;
CREATE TABLE `admin_email_addresses` (
  `email_type` varchar(20) NOT NULL,
  `email_address` varchar(256) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `admin_email_addresses`
--

INSERT INTO `admin_email_addresses` (`email_type`, `email_address`) VALUES
('new_user', 'pharmacyinnovationlab@gmail.com'),
('submit_bug', 'pharmacyinnovationlab@gmail.com'),
('submit_report', 'pharmacyinnovationlab@gmail.com');

-- --------------------------------------------------------

--
-- Table structure for table `answer`
--

DROP TABLE IF EXISTS `answer`;
CREATE TABLE `answer` (
  `answer_id` int(10) UNSIGNED NOT NULL,
  `question_id` int(10) UNSIGNED NOT NULL,
  `answer_text` varchar(256) NOT NULL,
  `correct_flag` enum('Y','N') DEFAULT NULL,
  `times_chosen` int(10) UNSIGNED NOT NULL DEFAULT '0',
  `created_date` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `last_updated_date` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `last_updated_by` varchar(20) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Triggers `answer`
--
DROP TRIGGER IF EXISTS `trg_answerBackup`;
DELIMITER $$
CREATE TRIGGER `trg_answerBackup` BEFORE DELETE ON `answer` FOR EACH ROW BEGIN
  INSERT INTO deleted_answer
    (answer_id, question_id, answer_text, correct_flag, times_chosen, created_date, last_updated_date, last_updated_by)
  VALUES
    (OLD.answer_id, OLD.question_id, OLD.answer_text, OLD.correct_flag, OLD.times_chosen, OLD.created_date, OLD.last_updated_date, OLD.last_updated_by);
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `answer_log`
--

DROP TABLE IF EXISTS `answer_log`;
CREATE TABLE `answer_log` (
  `answer_log_id` int(10) UNSIGNED NOT NULL,
  `question_id` int(10) UNSIGNED NOT NULL,
  `answer_id` int(10) UNSIGNED NOT NULL,
  `username` varchar(20) NOT NULL,
  `attempt_number` int(10) UNSIGNED NOT NULL DEFAULT '1',
  `correct_flag` enum('Y','N') DEFAULT NULL,
  `score` int(10) UNSIGNED NOT NULL DEFAULT '100',
  `created_date` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Triggers `answer_log`
--
DROP TRIGGER IF EXISTS `trg_addAttemptNumber`;
DELIMITER $$
CREATE TRIGGER `trg_addAttemptNumber` BEFORE INSERT ON `answer_log` FOR EACH ROW BEGIN
DECLARE attempt INT(10);
SELECT (count(*) + 1) INTO attempt
FROM answer_log
WHERE username = new.username AND question_id = new.question_id;
SET new.attempt_number = attempt;
END
$$
DELIMITER ;
DROP TRIGGER IF EXISTS `trg_addAttemptToQuestion`;
DELIMITER $$
CREATE TRIGGER `trg_addAttemptToQuestion` AFTER INSERT ON `answer_log` FOR EACH ROW BEGIN
  IF new.correct_flag = 'Y' THEN
    UPDATE question
    SET
      times_correctly_answered = times_correctly_answered + 1,
      times_answered = times_answered + 1
    WHERE question_id = new.question_id;
    UPDATE user
    SET score = score + new.score
    WHERE username = new.username;
  ELSE
  	UPDATE question
    SET
      times_answered = times_answered + 1
    WHERE question_id = new.question_id;
  END IF;
END
$$
DELIMITER ;
DROP TRIGGER IF EXISTS `trg_answerLogBackup`;
DELIMITER $$
CREATE TRIGGER `trg_answerLogBackup` BEFORE DELETE ON `answer_log` FOR EACH ROW BEGIN
  INSERT INTO deleted_answer_log
    (answer_log_id, question_id, answer_id, username, attempt_number, correct_flag, score, created_date)
  VALUES
    (OLD.answer_log_id, OLD.question_id, OLD.answer_id, OLD.username, OLD.attempt_number, OLD.correct_flag, OLD.score, OLD.created_date);
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `bug_report`
--

DROP TABLE IF EXISTS `bug_report`;
CREATE TABLE `bug_report` (
  `report_id` int(10) UNSIGNED NOT NULL,
  `username` varchar(20) NOT NULL,
  `report_text` varchar(350) NOT NULL,
  `created_date` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Triggers `bug_report`
--
DROP TRIGGER IF EXISTS `trg_bugReportBackup`;
DELIMITER $$
CREATE TRIGGER `trg_bugReportBackup` BEFORE DELETE ON `bug_report` FOR EACH ROW BEGIN
  INSERT INTO deleted_bug_report
    (report_id, username, report_text, created_date)
  VALUES
    (OLD.report_id, OLD.username, OLD.report_text, OLD.created_date);
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `category`
--

DROP TABLE IF EXISTS `category`;
CREATE TABLE `category` (
  `category_id` int(10) UNSIGNED NOT NULL,
  `category_name` varchar(50) NOT NULL,
  `description` varchar(256) DEFAULT NULL,
  `verified_flag` enum('Y','N') NOT NULL DEFAULT 'N',
  `active_flag` enum('Y','N') NOT NULL DEFAULT 'N',
  `created_date` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `created_by` varchar(20) NOT NULL,
  `last_updated_date` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `last_updated_by` varchar(20) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Triggers `category`
--
DROP TRIGGER IF EXISTS `trg_categoryBackup`;
DELIMITER $$
CREATE TRIGGER `trg_categoryBackup` BEFORE DELETE ON `category` FOR EACH ROW BEGIN
  INSERT INTO deleted_category
    (category_id, category_name, description, verified_flag, active_flag, created_date, created_by, last_updated_date, last_updated_by)
  VALUES
    (OLD.category_id, OLD.category_name, OLD.description, OLD.verified_flag, OLD.active_flag, OLD.created_date, OLD.created_by, OLD.last_updated_date, OLD.last_updated_by);
END
$$
DELIMITER ;
DROP TRIGGER IF EXISTS `trg_updateQuizStatus`;
DELIMITER $$
CREATE TRIGGER `trg_updateQuizStatus` AFTER UPDATE ON `category` FOR EACH ROW BEGIN
IF new.active_flag = 'N' THEN
  UPDATE quiz q
  SET q.active_flag = 'N'
  WHERE q.category_id = new.category_id;
ELSEIF new.active_flag = 'Y' THEN
  UPDATE quiz q
  SET q.active_flag = 'Y'
  WHERE q.category_id = new.category_id;
END IF;
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `deleted_answer`
--

DROP TABLE IF EXISTS `deleted_answer`;
CREATE TABLE `deleted_answer` (
  `answer_id` int(10) UNSIGNED DEFAULT NULL,
  `question_id` int(10) UNSIGNED DEFAULT NULL,
  `answer_text` varchar(256) DEFAULT NULL,
  `correct_flag` enum('Y','N') DEFAULT NULL,
  `times_chosen` int(10) UNSIGNED DEFAULT NULL,
  `created_date` datetime DEFAULT NULL,
  `last_updated_date` datetime DEFAULT NULL,
  `last_updated_by` varchar(20) DEFAULT NULL,
  `deleted_date` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Table structure for table `deleted_answer_log`
--

DROP TABLE IF EXISTS `deleted_answer_log`;
CREATE TABLE `deleted_answer_log` (
  `answer_log_id` int(10) UNSIGNED NOT NULL,
  `question_id` int(10) UNSIGNED NOT NULL,
  `answer_id` int(10) UNSIGNED NOT NULL,
  `username` varchar(20) NOT NULL,
  `attempt_number` int(10) NOT NULL,
  `correct_flag` enum('Y','N') NOT NULL,
  `score` int(10) NOT NULL,
  `created_date` datetime NOT NULL,
  `deleted_date` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Table structure for table `deleted_bug_report`
--

DROP TABLE IF EXISTS `deleted_bug_report`;
CREATE TABLE `deleted_bug_report` (
  `report_id` int(10) UNSIGNED DEFAULT NULL,
  `username` varchar(20) DEFAULT NULL,
  `report_text` varchar(350) DEFAULT NULL,
  `created_date` datetime DEFAULT NULL,
  `deleted_date` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Table structure for table `deleted_category`
--

DROP TABLE IF EXISTS `deleted_category`;
CREATE TABLE `deleted_category` (
  `category_id` int(10) UNSIGNED DEFAULT NULL,
  `category_name` varchar(50) DEFAULT NULL,
  `description` varchar(256) DEFAULT NULL,
  `verified_flag` enum('Y','N') DEFAULT NULL,
  `active_flag` enum('Y','N') DEFAULT NULL,
  `created_date` datetime DEFAULT NULL,
  `created_by` varchar(20) DEFAULT NULL,
  `last_updated_date` datetime DEFAULT NULL,
  `last_updated_by` varchar(20) DEFAULT NULL,
  `deleted_date` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Table structure for table `deleted_flagged_questions`
--

DROP TABLE IF EXISTS `deleted_flagged_questions`;
CREATE TABLE `deleted_flagged_questions` (
  `flagged_question_id` int(10) UNSIGNED DEFAULT NULL,
  `question_id` int(10) UNSIGNED DEFAULT NULL,
  `problem_text` text,
  `flagged_by_user` varchar(20) DEFAULT NULL,
  `created_date` datetime DEFAULT NULL,
  `deleted_date` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Table structure for table `deleted_question`
--

DROP TABLE IF EXISTS `deleted_question`;
CREATE TABLE `deleted_question` (
  `question_id` int(10) UNSIGNED DEFAULT NULL,
  `quiz_id` int(10) UNSIGNED DEFAULT NULL,
  `question_text` varchar(500) DEFAULT NULL,
  `score` int(10) UNSIGNED DEFAULT NULL,
  `times_correctly_answered` int(10) UNSIGNED DEFAULT NULL,
  `times_answered` int(10) UNSIGNED DEFAULT NULL,
  `explanation` varchar(500) DEFAULT NULL,
  `verified_flag` enum('Y','N') DEFAULT NULL,
  `active_flag` enum('Y','N') DEFAULT NULL,
  `removed_flag` enum('Y','N') DEFAULT NULL,
  `removed_date` datetime DEFAULT NULL,
  `image_url` varchar(256) DEFAULT NULL,
  `created_date` datetime DEFAULT NULL,
  `created_by` varchar(20) DEFAULT NULL,
  `last_updated_date` datetime DEFAULT NULL,
  `last_updated_by` varchar(20) DEFAULT NULL,
  `deleted_date` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Table structure for table `deleted_quiz`
--

DROP TABLE IF EXISTS `deleted_quiz`;
CREATE TABLE `deleted_quiz` (
  `quiz_id` int(10) UNSIGNED DEFAULT NULL,
  `category_id` int(10) UNSIGNED DEFAULT NULL,
  `quiz_name` varchar(50) DEFAULT NULL,
  `description` varchar(256) DEFAULT NULL,
  `active_flag` enum('Y','N') DEFAULT NULL,
  `removed_flag` enum('Y','N') DEFAULT NULL,
  `removed_date` datetime DEFAULT NULL,
  `created_date` datetime DEFAULT NULL,
  `created_by` varchar(20) DEFAULT NULL,
  `last_updated_date` datetime DEFAULT NULL,
  `last_updated_by` varchar(20) DEFAULT NULL,
  `deleted_date` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Table structure for table `deleted_user`
--

DROP TABLE IF EXISTS `deleted_user`;
CREATE TABLE `deleted_user` (
  `username` varchar(20) DEFAULT NULL,
  `password` varchar(60) DEFAULT NULL,
  `email_address` varchar(256) DEFAULT NULL,
  `score` int(10) DEFAULT NULL,
  `admin_flag` enum('Y','N') DEFAULT NULL,
  `owner_flag` enum('Y','N') DEFAULT NULL,
  `active_flag` enum('Y','N') DEFAULT NULL,
  `registered_date` datetime DEFAULT NULL,
  `deleted_date` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Table structure for table `deleted_user_profile`
--

DROP TABLE IF EXISTS `deleted_user_profile`;
CREATE TABLE `deleted_user_profile` (
  `username` varchar(20) DEFAULT NULL,
  `full_name` varchar(50) DEFAULT NULL,
  `year` varchar(10) DEFAULT NULL,
  `employer` varchar(50) DEFAULT NULL,
  `interests` varchar(256) DEFAULT NULL,
  `bio` varchar(500) DEFAULT NULL,
  `image_url` varchar(256) DEFAULT NULL,
  `created_date` datetime DEFAULT NULL,
  `last_updated_date` datetime DEFAULT NULL,
  `last_updated_by` varchar(20) DEFAULT NULL,
  `deleted_date` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Table structure for table `deleted_votes`
--

DROP TABLE IF EXISTS `deleted_votes`;
CREATE TABLE `deleted_votes` (
  `question_id` int(10) UNSIGNED DEFAULT NULL,
  `username` varchar(20) DEFAULT NULL,
  `value` tinyint(4) DEFAULT NULL,
  `created_date` datetime DEFAULT NULL,
  `last_updated_date` datetime DEFAULT NULL,
  `deleted_date` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Table structure for table `flagged_questions`
--

DROP TABLE IF EXISTS `flagged_questions`;
CREATE TABLE `flagged_questions` (
  `flagged_question_id` int(10) UNSIGNED NOT NULL,
  `question_id` int(10) UNSIGNED NOT NULL,
  `problem_text` text NOT NULL,
  `flagged_by_user` varchar(20) NOT NULL,
  `created_date` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Triggers `flagged_questions`
--
DROP TRIGGER IF EXISTS `trg_flaggedQuestionBackup`;
DELIMITER $$
CREATE TRIGGER `trg_flaggedQuestionBackup` BEFORE DELETE ON `flagged_questions` FOR EACH ROW BEGIN
  INSERT INTO deleted_flagged_questions
    (flagged_question_id, question_id, problem_text, flagged_by_user, created_date)
  VALUES
    (OLD.flagged_question_id, OLD.question_id, OLD.problem_text, OLD.flagged_by_user, OLD.created_date);
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `question`
--

DROP TABLE IF EXISTS `question`;
CREATE TABLE `question` (
  `question_id` int(10) UNSIGNED NOT NULL,
  `quiz_id` int(10) UNSIGNED NOT NULL,
  `question_text` varchar(500) NOT NULL,
  `score` int(10) UNSIGNED NOT NULL DEFAULT '100',
  `times_correctly_answered` int(10) UNSIGNED NOT NULL DEFAULT '0',
  `times_answered` int(10) UNSIGNED NOT NULL DEFAULT '0',
  `explanation` varchar(500) DEFAULT NULL,
  `verified_flag` enum('Y','N') NOT NULL DEFAULT 'N',
  `active_flag` enum('Y','N') NOT NULL DEFAULT 'N',
  `removed_flag` enum('Y','N') NOT NULL DEFAULT 'N',
  `removed_date` datetime DEFAULT NULL,
  `image_url` varchar(256) DEFAULT NULL,
  `created_date` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `created_by` varchar(20) NOT NULL,
  `last_updated_date` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `last_updated_by` varchar(20) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Triggers `question`
--
DROP TRIGGER IF EXISTS `trg_questionBackup`;
DELIMITER $$
CREATE TRIGGER `trg_questionBackup` BEFORE DELETE ON `question` FOR EACH ROW BEGIN
  INSERT INTO deleted_question
    (question_id, quiz_id, question_text, score, times_correctly_answered, times_answered, explanation, verified_flag, active_flag, removed_flag, removed_date, image_url, created_date, created_by, last_updated_date, last_updated_by)
  VALUES
    (OLD.question_id, OLD.quiz_id, OLD.question_text, OLD.score, OLD.times_correctly_answered, OLD.times_answered, OLD.explanation, OLD.verified_flag, OLD.active_flag, OLD.removed_flag, OLD.removed_date, OLD.image_url, OLD.created_date, OLD.created_by, OLD.last_updated_date, OLD.last_updated_by);
END
$$
DELIMITER ;
DROP TRIGGER IF EXISTS `trg_updateQuestionRemovedDate`;
DELIMITER $$
CREATE TRIGGER `trg_updateQuestionRemovedDate` BEFORE UPDATE ON `question` FOR EACH ROW BEGIN 
IF new.removed_flag = 'Y' THEN 
  SET new.removed_date = CURRENT_TIMESTAMP; 
ELSE SET new.removed_date = null; 
END IF; 
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `question_review_history`
--

DROP TABLE IF EXISTS `question_review_history`;
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

DROP TABLE IF EXISTS `quiz`;
CREATE TABLE `quiz` (
  `quiz_id` int(10) UNSIGNED NOT NULL,
  `category_id` int(10) UNSIGNED NOT NULL,
  `quiz_name` varchar(50) NOT NULL,
  `description` varchar(256) DEFAULT NULL,
  `active_flag` enum('Y','N') NOT NULL DEFAULT 'N',
  `removed_flag` enum('Y','N') NOT NULL DEFAULT 'N',
  `removed_date` datetime DEFAULT NULL,
  `created_date` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `created_by` varchar(20) NOT NULL,
  `last_updated_date` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `last_updated_by` varchar(20) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Triggers `quiz`
--
DROP TRIGGER IF EXISTS `trg_quizBackup`;
DELIMITER $$
CREATE TRIGGER `trg_quizBackup` BEFORE DELETE ON `quiz` FOR EACH ROW BEGIN
  INSERT INTO deleted_quiz
    (quiz_id, category_id, quiz_name, description, active_flag, removed_flag, removed_date, created_date, created_by, last_updated_date, last_updated_by)
  VALUES
    (OLD.quiz_id, OLD.category_id, OLD.quiz_name, OLD.description, OLD.active_flag, OLD.removed_flag, OLD.removed_date, OLD.created_date, OLD.created_by, OLD.last_updated_date, OLD.last_updated_by);
END
$$
DELIMITER ;
DROP TRIGGER IF EXISTS `trg_updateQuestionStatus`;
DELIMITER $$
CREATE TRIGGER `trg_updateQuestionStatus` AFTER UPDATE ON `quiz` FOR EACH ROW BEGIN
IF new.active_flag = 'N' THEN
  UPDATE question q
  SET q.active_flag = 'N'
  WHERE q.quiz_id = new.quiz_id;
ELSEIF new.active_flag = 'Y' THEN
  UPDATE question q
  SET q.active_flag = 'Y'
  WHERE q.quiz_id = new.quiz_id
    AND q.removed_flag <> 'Y';
END IF;
IF new.removed_flag = 'Y' THEN
  UPDATE question q
  SET q.removed_flag = 'Y', q.active_flag = 'N'
  WHERE q.quiz_id = new.quiz_id;
ELSEIF new.removed_flag = 'N' THEN
  UPDATE question q
  SET q.removed_flag = 'N', q.active_flag = 'Y'
  WHERE q.quiz_id = new.quiz_id;
END IF;
END
$$
DELIMITER ;
DROP TRIGGER IF EXISTS `trg_updateRemovedDate`;
DELIMITER $$
CREATE TRIGGER `trg_updateRemovedDate` BEFORE UPDATE ON `quiz` FOR EACH ROW BEGIN
IF new.removed_flag = 'Y' THEN
  SET new.removed_date = CURRENT_TIMESTAMP;
ELSE
  SET new.removed_date = null;
END IF;
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `user`
--

DROP TABLE IF EXISTS `user`;
CREATE TABLE `user` (
  `username` varchar(20) NOT NULL,
  `password` varchar(60) NOT NULL,
  `email_address` varchar(256) NOT NULL,
  `score` int(10) NOT NULL DEFAULT '0',
  `admin_flag` enum('Y','N') NOT NULL DEFAULT 'N',
  `owner_flag` enum('Y','N') NOT NULL DEFAULT 'N',
  `active_flag` enum('Y','N') NOT NULL DEFAULT 'N',
  `registered_date` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `user`
--

INSERT INTO `user` (`username`, `password`, `email_address`, `score`, `admin_flag`, `owner_flag`, `active_flag`, `registered_date`) VALUES
('Ra_vee', '$2y$10$YjQ3OGQ4MGNkYzdiMzI2Mu8il/EpK95y4goS.YIHHWSv.5cMHsX3S', 'rmp40@pitt.edu', 0, 'Y', 'Y', 'Y', '2017-04-12 21:10:12');

--
-- Triggers `user`
--
DROP TRIGGER IF EXISTS `trg_userBackup`;
DELIMITER $$
CREATE TRIGGER `trg_userBackup` BEFORE DELETE ON `user` FOR EACH ROW BEGIN
  INSERT INTO deleted_user
    (username, password, email_address, score, admin_flag, owner_flag, active_flag, registered_date)
  VALUES
    (OLD.username, OLD.password, OLD.email_address, OLD.score, OLD.admin_flag, OLD.owner_flag, OLD.active_flag, OLD.registered_date);
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `user_profile`
--

DROP TABLE IF EXISTS `user_profile`;
CREATE TABLE `user_profile` (
  `username` varchar(20) NOT NULL,
  `full_name` varchar(50) NOT NULL,
  `year` varchar(10) NOT NULL,
  `employer` varchar(50) DEFAULT NULL,
  `interests` varchar(256) DEFAULT NULL,
  `bio` varchar(500) DEFAULT NULL,
  `image_url` varchar(256) DEFAULT NULL,
  `created_date` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `last_updated_date` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `last_updated_by` varchar(20) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `user_profile`
--

INSERT INTO `user_profile` (`username`, `full_name`, `year`, `employer`, `interests`, `bio`, `image_url`, `created_date`, `last_updated_date`, `last_updated_by`) VALUES
('Ra_vee', 'Ravi Patel', 'Doctor', 'Pitt Pharmacy School', '', '', NULL, '2017-04-12 21:10:12', '2017-04-12 21:10:12', 'Ra_vee');

--
-- Triggers `user_profile`
--
DROP TRIGGER IF EXISTS `trg_userProfileBackup`;
DELIMITER $$
CREATE TRIGGER `trg_userProfileBackup` BEFORE DELETE ON `user_profile` FOR EACH ROW BEGIN
  INSERT INTO deleted_user_profile
    (username, full_name, year, employer, interests, bio, image_url, created_date, last_updated_date, last_updated_by)
  VALUES
    (OLD.username, OLD.full_name, OLD.year, OLD.employer, OLD.interests, OLD.bio, OLD.image_url, OLD.created_date, OLD.last_updated_date, OLD.last_updated_by);
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `votes`
--

DROP TABLE IF EXISTS `votes`;
CREATE TABLE `votes` (
  `question_id` int(10) UNSIGNED NOT NULL,
  `username` varchar(20) NOT NULL,
  `value` tinyint(4) NOT NULL DEFAULT '0',
  `created_date` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `last_updated_date` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Triggers `votes`
--
DROP TRIGGER IF EXISTS `trg_voteBackup`;
DELIMITER $$
CREATE TRIGGER `trg_voteBackup` BEFORE DELETE ON `votes` FOR EACH ROW BEGIN
  INSERT INTO deleted_votes
    (question_id, username, value, created_date, last_updated_date)
  VALUES
    (OLD.question_id, OLD.username, OLD.value, OLD.created_date, OLD.last_updated_date);
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Stand-in structure for view `vw_correctanswers_v1`
-- (See below for the actual view)
--
DROP VIEW IF EXISTS `vw_correctanswers_v1`;
CREATE TABLE `vw_correctanswers_v1` (
`question_id` int(10) unsigned
,`username` varchar(20)
,`created_date` datetime
,`quiz_id` int(10) unsigned
,`attempt_number` int(10) unsigned
,`score` int(10) unsigned
);

-- --------------------------------------------------------

--
-- Stand-in structure for view `vw_correctanswers_v2`
-- (See below for the actual view)
--
DROP VIEW IF EXISTS `vw_correctanswers_v2`;
CREATE TABLE `vw_correctanswers_v2` (
`question_id` int(10) unsigned
,`username` varchar(20)
,`created_date` datetime
,`quiz_id` int(10) unsigned
,`category_id` int(10) unsigned
,`attempt_number` int(10) unsigned
,`score` int(10) unsigned
);

-- --------------------------------------------------------

--
-- Stand-in structure for view `vw_correctanswers_v3`
-- (See below for the actual view)
--
DROP VIEW IF EXISTS `vw_correctanswers_v3`;
CREATE TABLE `vw_correctanswers_v3` (
`question_id` int(10) unsigned
,`username` varchar(20)
,`created_date` datetime
,`quiz_id` int(10) unsigned
,`category_id` int(10) unsigned
,`category_name` varchar(50)
,`attempt_number` int(10) unsigned
,`score` int(10) unsigned
);

-- --------------------------------------------------------

--
-- Stand-in structure for view `vw_questionvotevalue`
-- (See below for the actual view)
--
DROP VIEW IF EXISTS `vw_questionvotevalue`;
CREATE TABLE `vw_questionvotevalue` (
`question_id` int(10) unsigned
,`value` decimal(25,0)
);

-- --------------------------------------------------------

--
-- Structure for view `vw_correctanswers_v1`
--
DROP TABLE IF EXISTS `vw_correctanswers_v1`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `vw_correctanswers_v1`  AS  select `al`.`question_id` AS `question_id`,`al`.`username` AS `username`,`al`.`created_date` AS `created_date`,`q`.`quiz_id` AS `quiz_id`,`al`.`attempt_number` AS `attempt_number`,`al`.`score` AS `score` from (`answer_log` `al` join `question` `q`) where ((`al`.`question_id` = `q`.`question_id`) and (`al`.`correct_flag` = 'Y')) ;

-- --------------------------------------------------------

--
-- Structure for view `vw_correctanswers_v2`
--
DROP TABLE IF EXISTS `vw_correctanswers_v2`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `vw_correctanswers_v2`  AS  select `v1`.`question_id` AS `question_id`,`v1`.`username` AS `username`,`v1`.`created_date` AS `created_date`,`v1`.`quiz_id` AS `quiz_id`,`q`.`category_id` AS `category_id`,`v1`.`attempt_number` AS `attempt_number`,`v1`.`score` AS `score` from (`quiz` `q` join `vw_correctanswers_v1` `v1`) where (`v1`.`quiz_id` = `q`.`quiz_id`) ;

-- --------------------------------------------------------

--
-- Structure for view `vw_correctanswers_v3`
--
DROP TABLE IF EXISTS `vw_correctanswers_v3`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `vw_correctanswers_v3`  AS  select `v2`.`question_id` AS `question_id`,`v2`.`username` AS `username`,`v2`.`created_date` AS `created_date`,`v2`.`quiz_id` AS `quiz_id`,`v2`.`category_id` AS `category_id`,`c`.`category_name` AS `category_name`,`v2`.`attempt_number` AS `attempt_number`,`v2`.`score` AS `score` from (`category` `c` join `vw_correctanswers_v2` `v2`) where (`v2`.`category_id` = `c`.`category_id`) order by `v2`.`username` ;

-- --------------------------------------------------------

--
-- Structure for view `vw_questionvotevalue`
--
DROP TABLE IF EXISTS `vw_questionvotevalue`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY INVOKER VIEW `vw_questionvotevalue`  AS  select `q`.`question_id` AS `question_id`,sum(ifnull(`v`.`value`,0)) AS `value` from (`question` `q` left join `votes` `v` on((`v`.`question_id` = `q`.`question_id`))) group by `q`.`question_id` ;

--
-- Indexes for dumped tables
--

--
-- Indexes for table `admin_email_addresses`
--
ALTER TABLE `admin_email_addresses`
  ADD PRIMARY KEY (`email_type`);

--
-- Indexes for table `answer`
--
ALTER TABLE `answer`
  ADD PRIMARY KEY (`answer_id`),
  ADD KEY `question_id` (`question_id`),
  ADD KEY `last_updated_by` (`last_updated_by`);

--
-- Indexes for table `answer_log`
--
ALTER TABLE `answer_log`
  ADD PRIMARY KEY (`answer_log_id`),
  ADD KEY `question_id` (`question_id`),
  ADD KEY `username` (`username`),
  ADD KEY `answer_id` (`answer_id`);

--
-- Indexes for table `bug_report`
--
ALTER TABLE `bug_report`
  ADD PRIMARY KEY (`report_id`),
  ADD KEY `username` (`username`);

--
-- Indexes for table `category`
--
ALTER TABLE `category`
  ADD PRIMARY KEY (`category_id`),
  ADD KEY `category_name` (`category_name`),
  ADD KEY `created_by` (`created_by`),
  ADD KEY `last_updated_by` (`last_updated_by`);

--
-- Indexes for table `flagged_questions`
--
ALTER TABLE `flagged_questions`
  ADD PRIMARY KEY (`flagged_question_id`),
  ADD KEY `question_id` (`question_id`),
  ADD KEY `flagged_by_user` (`flagged_by_user`);

--
-- Indexes for table `question`
--
ALTER TABLE `question`
  ADD PRIMARY KEY (`question_id`),
  ADD KEY `quiz_id` (`quiz_id`),
  ADD KEY `last_updated_by` (`last_updated_by`),
  ADD KEY `created_by` (`created_by`);

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
  MODIFY `answer_id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=213;
--
-- AUTO_INCREMENT for table `answer_log`
--
ALTER TABLE `answer_log`
  MODIFY `answer_log_id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=670;
--
-- AUTO_INCREMENT for table `bug_report`
--
ALTER TABLE `bug_report`
  MODIFY `report_id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=18;
--
-- AUTO_INCREMENT for table `category`
--
ALTER TABLE `category`
  MODIFY `category_id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=21;
--
-- AUTO_INCREMENT for table `flagged_questions`
--
ALTER TABLE `flagged_questions`
  MODIFY `flagged_question_id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=22;
--
-- AUTO_INCREMENT for table `question`
--
ALTER TABLE `question`
  MODIFY `question_id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=54;
--
-- AUTO_INCREMENT for table `question_review_history`
--
ALTER TABLE `question_review_history`
  MODIFY `review_id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT;
--
-- AUTO_INCREMENT for table `quiz`
--
ALTER TABLE `quiz`
  MODIFY `quiz_id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=29;
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
-- Constraints for table `answer_log`
--
ALTER TABLE `answer_log`
  ADD CONSTRAINT `answer_log_ibfk_1` FOREIGN KEY (`question_id`) REFERENCES `question` (`question_id`),
  ADD CONSTRAINT `answer_log_ibfk_2` FOREIGN KEY (`username`) REFERENCES `user` (`username`),
  ADD CONSTRAINT `answer_log_ibfk_3` FOREIGN KEY (`answer_id`) REFERENCES `answer` (`answer_id`);

--
-- Constraints for table `bug_report`
--
ALTER TABLE `bug_report`
  ADD CONSTRAINT `bug_report_ibfk_1` FOREIGN KEY (`username`) REFERENCES `user` (`username`);

--
-- Constraints for table `category`
--
ALTER TABLE `category`
  ADD CONSTRAINT `category_ibfk_1` FOREIGN KEY (`created_by`) REFERENCES `user` (`username`),
  ADD CONSTRAINT `category_ibfk_2` FOREIGN KEY (`last_updated_by`) REFERENCES `user` (`username`);

--
-- Constraints for table `flagged_questions`
--
ALTER TABLE `flagged_questions`
  ADD CONSTRAINT `flagged_questions_ibfk_1` FOREIGN KEY (`flagged_by_user`) REFERENCES `user` (`username`),
  ADD CONSTRAINT `flagged_questions_ibfk_2` FOREIGN KEY (`question_id`) REFERENCES `question` (`question_id`);

--
-- Constraints for table `question`
--
ALTER TABLE `question`
  ADD CONSTRAINT `question_ibfk_1` FOREIGN KEY (`quiz_id`) REFERENCES `quiz` (`quiz_id`),
  ADD CONSTRAINT `question_ibfk_2` FOREIGN KEY (`created_by`) REFERENCES `user` (`username`),
  ADD CONSTRAINT `question_ibfk_3` FOREIGN KEY (`last_updated_by`) REFERENCES `user` (`username`);

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

GRANT ALL PRIVILEGES ON pharm_genius.* To 'pharm_genius'@'localhost' IDENTIFIED BY 'QuizGameDB1';