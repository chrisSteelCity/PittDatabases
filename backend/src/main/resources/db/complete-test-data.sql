-- MySQL dump 10.13  Distrib 9.5.0, for macos15.4 (arm64)
--
-- Host: localhost    Database: exercise_tracker
-- ------------------------------------------------------
-- Server version	9.5.0

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `exercises`
--

DROP TABLE IF EXISTS `exercises`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `exercises` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `duration_minutes` int NOT NULL,
  `location` varchar(128) DEFAULT NULL,
  `occurred_at` datetime(6) NOT NULL,
  `timezone` varchar(64) DEFAULT NULL,
  `type` enum('CYCLE','GYM','OTHER','RUN','SWIM','WALK') NOT NULL,
  `user_id` bigint NOT NULL,
  PRIMARY KEY (`id`),
  KEY `idx_exercises_user_time` (`user_id`,`occurred_at`),
  CONSTRAINT `exercises_chk_1` CHECK ((`duration_minutes` >= 1)),
  FOREIGN KEY (`user_id`) REFERENCES `users`(`id`)
) ENGINE=InnoDB AUTO_INCREMENT=284 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `exercises`
--

LOCK TABLES `exercises` WRITE;
/*!40000 ALTER TABLE `exercises` DISABLE KEYS */;
-- User 24 (allen) - Extended data spanning back one year (Nov 2024 - Nov 2025)
INSERT INTO `exercises` VALUES
-- November 2025 (Most recent month)
(1,50,'outside','2025-11-22 07:00:00.000000','America/New_York','RUN',24),(2,35,'inside','2025-11-22 18:30:00.000000','America/New_York','GYM',24),(3,45,'outside','2025-11-21 07:30:00.000000','America/New_York','RUN',24),(4,55,'inside','2025-11-21 17:00:00.000000','America/New_York','GYM',24),(5,30,'outside','2025-11-20 08:00:00.000000','America/New_York','WALK',24),(6,40,'inside','2025-11-20 18:00:00.000000','America/New_York','SWIM',24),(7,60,'outside','2025-11-19 07:15:00.000000','America/New_York','CYCLE',24),(8,50,'inside','2025-11-19 19:00:00.000000','America/New_York','GYM',24),(9,45,'outside','2025-11-18 07:30:00.000000','America/New_York','RUN',24),(10,35,'inside','2025-11-18 17:30:00.000000','America/New_York','SWIM',24),(11,45,'outside','2025-11-17 07:30:00.000000','America/New_York','RUN',24),(12,50,'inside','2025-11-17 18:45:00.000000','America/New_York','GYM',24),(13,60,'outside','2025-11-16 14:15:00.000000','America/New_York','CYCLE',24),(14,30,'outside','2025-11-16 19:00:00.000000','America/New_York','WALK',24),(15,40,'inside','2025-11-15 08:00:00.000000','America/New_York','SWIM',24),(16,25,'outside','2025-11-15 19:30:00.000000','America/New_York','WALK',24),(17,35,'outside','2025-11-14 07:00:00.000000','America/New_York','RUN',24),(18,55,'inside','2025-11-14 15:30:00.000000','America/New_York','GYM',24),(19,35,'outside','2025-11-13 14:30:00.000000','America/New_York','OTHER',24),(20,30,'outside','2025-11-12 08:00:00.000000','America/New_York','WALK',24),(21,45,'inside','2025-11-12 18:00:00.000000','America/New_York','GYM',24),(22,50,'outside','2025-11-11 07:45:00.000000','America/New_York','RUN',24),(23,30,'outside','2025-11-11 14:00:00.000000','America/New_York','WALK',24),(24,40,'outside','2025-11-11 19:15:00.000000','America/New_York','CYCLE',24),(25,35,'inside','2025-11-10 08:15:00.000000','America/New_York','SWIM',24),(26,55,'outside','2025-11-10 19:00:00.000000','America/New_York','CYCLE',24),(27,60,'inside','2025-11-09 15:00:00.000000','America/New_York','GYM',24),(28,30,'inside','2025-11-09 19:30:00.000000','America/New_York','OTHER',24),(29,40,'outside','2025-11-08 07:30:00.000000','America/New_York','RUN',24),(30,35,'inside','2025-11-08 14:00:00.000000','America/New_York','SWIM',24),(31,25,'outside','2025-11-06 08:30:00.000000','America/New_York','WALK',24),(32,45,'outside','2025-11-06 14:30:00.000000','America/New_York','CYCLE',24),(33,50,'inside','2025-11-06 18:30:00.000000','America/New_York','GYM',24),(34,45,'inside','2025-11-05 07:00:00.000000','America/New_York','SWIM',24),(35,65,'outside','2025-11-05 14:30:00.000000','America/New_York','CYCLE',24),(36,35,'outside','2025-11-04 07:15:00.000000','America/New_York','RUN',24),(37,30,'inside','2025-11-04 19:00:00.000000','America/New_York','OTHER',24),
-- Allen's year of data (Nov 2024 - Oct 2025) - 3-4x per week
-- October 2025
(284,50,'outside','2025-10-31 07:00:00.000000','America/New_York','RUN',24),(285,45,'inside','2025-10-31 18:30:00.000000','America/New_York','GYM',24),(286,40,'outside','2025-10-29 07:30:00.000000','America/New_York','RUN',24),(287,55,'inside','2025-10-29 17:00:00.000000','America/New_York','GYM',24),(288,60,'outside','2025-10-27 08:00:00.000000','America/New_York','CYCLE',24),(289,35,'inside','2025-10-27 19:00:00.000000','America/New_York','SWIM',24),(290,45,'outside','2025-10-25 07:00:00.000000','America/New_York','RUN',24),(291,50,'inside','2025-10-23 18:30:00.000000','America/New_York','GYM',24),(292,55,'outside','2025-10-21 07:30:00.000000','America/New_York','CYCLE',24),(293,40,'inside','2025-10-19 17:00:00.000000','America/New_York','SWIM',24),(294,45,'outside','2025-10-17 07:00:00.000000','America/New_York','RUN',24),(295,60,'inside','2025-10-15 18:00:00.000000','America/New_York','GYM',24),(296,35,'outside','2025-10-13 08:00:00.000000','America/New_York','WALK',24),(297,50,'inside','2025-10-11 17:30:00.000000','America/New_York','GYM',24),(298,45,'outside','2025-10-09 07:00:00.000000','America/New_York','RUN',24),(299,40,'inside','2025-10-07 18:30:00.000000','America/New_York','SWIM',24),(300,55,'outside','2025-10-05 07:30:00.000000','America/New_York','CYCLE',24),(301,50,'inside','2025-10-03 17:00:00.000000','America/New_York','GYM',24),(302,45,'outside','2025-10-01 07:00:00.000000','America/New_York','RUN',24),
-- September 2025
(303,40,'inside','2025-09-29 18:30:00.000000','America/New_York','GYM',24),(304,50,'outside','2025-09-27 07:30:00.000000','America/New_York','RUN',24),(305,55,'inside','2025-09-25 17:00:00.000000','America/New_York','GYM',24),(306,45,'outside','2025-09-23 08:00:00.000000','America/New_York','CYCLE',24),(307,35,'inside','2025-09-21 17:30:00.000000','America/New_York','SWIM',24),(308,50,'outside','2025-09-19 07:00:00.000000','America/New_York','RUN',24),(309,60,'inside','2025-09-17 18:30:00.000000','America/New_York','GYM',24),(310,40,'outside','2025-09-15 07:30:00.000000','America/New_York','WALK',24),(311,45,'inside','2025-09-13 17:00:00.000000','America/New_York','SWIM',24),(312,50,'outside','2025-09-11 07:00:00.000000','America/New_York','RUN',24),(313,55,'inside','2025-09-09 18:00:00.000000','America/New_York','GYM',24),(314,35,'outside','2025-09-07 08:00:00.000000','America/New_York','WALK',24),(315,45,'inside','2025-09-05 17:30:00.000000','America/New_York','GYM',24),(316,50,'outside','2025-09-03 07:00:00.000000','America/New_York','RUN',24),(317,40,'inside','2025-09-01 18:30:00.000000','America/New_York','SWIM',24),
-- August 2025
(318,55,'outside','2025-08-30 07:30:00.000000','America/New_York','CYCLE',24),(319,45,'inside','2025-08-28 17:00:00.000000','America/New_York','GYM',24),(320,50,'outside','2025-08-26 07:00:00.000000','America/New_York','RUN',24),(321,40,'inside','2025-08-24 18:30:00.000000','America/New_York','SWIM',24),(322,60,'outside','2025-08-22 07:30:00.000000','America/New_York','CYCLE',24),(323,45,'inside','2025-08-20 17:00:00.000000','America/New_York','GYM',24),(324,50,'outside','2025-08-18 07:00:00.000000','America/New_York','RUN',24),(325,35,'inside','2025-08-16 18:00:00.000000','America/New_York','SWIM',24),(326,55,'outside','2025-08-14 07:30:00.000000','America/New_York','CYCLE',24),(327,45,'inside','2025-08-12 17:30:00.000000','America/New_York','GYM',24),(328,50,'outside','2025-08-10 07:00:00.000000','America/New_York','RUN',24),(329,40,'inside','2025-08-08 18:30:00.000000','America/New_York','GYM',24),(330,45,'outside','2025-08-06 08:00:00.000000','America/New_York','WALK',24),(331,55,'inside','2025-08-04 17:00:00.000000','America/New_York','SWIM',24),(332,50,'outside','2025-08-02 07:00:00.000000','America/New_York','RUN',24),
-- July 2025
(333,45,'inside','2025-07-31 18:30:00.000000','America/New_York','GYM',24),(334,60,'outside','2025-07-29 07:30:00.000000','America/New_York','CYCLE',24),(335,40,'inside','2025-07-27 17:00:00.000000','America/New_York','SWIM',24),(336,50,'outside','2025-07-25 07:00:00.000000','America/New_York','RUN',24),(337,55,'inside','2025-07-23 18:00:00.000000','America/New_York','GYM',24),(338,35,'outside','2025-07-21 08:00:00.000000','America/New_York','WALK',24),(339,45,'inside','2025-07-19 17:30:00.000000','America/New_York','SWIM',24),(340,50,'outside','2025-07-17 07:00:00.000000','America/New_York','RUN',24),(341,60,'inside','2025-07-15 18:30:00.000000','America/New_York','GYM',24),(342,40,'outside','2025-07-13 07:30:00.000000','America/New_York','CYCLE',24),(343,45,'inside','2025-07-11 17:00:00.000000','America/New_York','SWIM',24),(344,50,'outside','2025-07-09 07:00:00.000000','America/New_York','RUN',24),(345,55,'inside','2025-07-07 18:00:00.000000','America/New_York','GYM',24),(346,35,'outside','2025-07-05 08:00:00.000000','America/New_York','WALK',24),(347,45,'inside','2025-07-03 17:30:00.000000','America/New_York','GYM',24),(348,50,'outside','2025-07-01 07:00:00.000000','America/New_York','RUN',24),
-- June 2025
(349,40,'inside','2025-06-29 18:30:00.000000','America/New_York','SWIM',24),(350,55,'outside','2025-06-27 07:30:00.000000','America/New_York','CYCLE',24),(351,45,'inside','2025-06-25 17:00:00.000000','America/New_York','GYM',24),(352,50,'outside','2025-06-23 07:00:00.000000','America/New_York','RUN',24),(353,60,'inside','2025-06-21 18:00:00.000000','America/New_York','GYM',24),(354,35,'outside','2025-06-19 08:00:00.000000','America/New_York','WALK',24),(355,45,'inside','2025-06-17 17:30:00.000000','America/New_York','SWIM',24),(356,50,'outside','2025-06-15 07:00:00.000000','America/New_York','RUN',24),(357,55,'inside','2025-06-13 18:30:00.000000','America/New_York','GYM',24),(358,40,'outside','2025-06-11 07:30:00.000000','America/New_York','CYCLE',24),(359,45,'inside','2025-06-09 17:00:00.000000','America/New_York','SWIM',24),(360,50,'outside','2025-06-07 07:00:00.000000','America/New_York','RUN',24),(361,60,'inside','2025-06-05 18:00:00.000000','America/New_York','GYM',24),(362,35,'outside','2025-06-03 08:00:00.000000','America/New_York','WALK',24),(363,45,'inside','2025-06-01 17:30:00.000000','America/New_York','GYM',24),
-- May 2025
(364,50,'outside','2025-05-30 07:00:00.000000','America/New_York','RUN',24),(365,40,'inside','2025-05-28 18:30:00.000000','America/New_York','SWIM',24),(366,55,'outside','2025-05-26 07:30:00.000000','America/New_York','CYCLE',24),(367,45,'inside','2025-05-24 17:00:00.000000','America/New_York','GYM',24),(368,50,'outside','2025-05-22 07:00:00.000000','America/New_York','RUN',24),(369,60,'inside','2025-05-20 18:00:00.000000','America/New_York','GYM',24),(370,35,'outside','2025-05-18 08:00:00.000000','America/New_York','WALK',24),(371,45,'inside','2025-05-16 17:30:00.000000','America/New_York','SWIM',24),(372,50,'outside','2025-05-14 07:00:00.000000','America/New_York','RUN',24),(373,55,'inside','2025-05-12 18:30:00.000000','America/New_York','GYM',24),(374,40,'outside','2025-05-10 07:30:00.000000','America/New_York','CYCLE',24),(375,45,'inside','2025-05-08 17:00:00.000000','America/New_York','SWIM',24),(376,50,'outside','2025-05-06 07:00:00.000000','America/New_York','RUN',24),(377,60,'inside','2025-05-04 18:00:00.000000','America/New_York','GYM',24),(378,35,'outside','2025-05-02 08:00:00.000000','America/New_York','WALK',24),
-- April 2025
(379,45,'inside','2025-04-30 17:30:00.000000','America/New_York','GYM',24),(380,50,'outside','2025-04-28 07:00:00.000000','America/New_York','RUN',24),(381,40,'inside','2025-04-26 18:30:00.000000','America/New_York','SWIM',24),(382,55,'outside','2025-04-24 07:30:00.000000','America/New_York','CYCLE',24),(383,45,'inside','2025-04-22 17:00:00.000000','America/New_York','GYM',24),(384,50,'outside','2025-04-20 07:00:00.000000','America/New_York','RUN',24),(385,60,'inside','2025-04-18 18:00:00.000000','America/New_York','GYM',24),(386,35,'outside','2025-04-16 08:00:00.000000','America/New_York','WALK',24),(387,45,'inside','2025-04-14 17:30:00.000000','America/New_York','SWIM',24),(388,50,'outside','2025-04-12 07:00:00.000000','America/New_York','RUN',24),(389,55,'inside','2025-04-10 18:30:00.000000','America/New_York','GYM',24),(390,40,'outside','2025-04-08 07:30:00.000000','America/New_York','CYCLE',24),(391,45,'inside','2025-04-06 17:00:00.000000','America/New_York','SWIM',24),(392,50,'outside','2025-04-04 07:00:00.000000','America/New_York','RUN',24),(393,60,'inside','2025-04-02 18:00:00.000000','America/New_York','GYM',24),
-- March 2025
(394,35,'outside','2025-03-31 08:00:00.000000','America/New_York','WALK',24),(395,45,'inside','2025-03-29 17:30:00.000000','America/New_York','GYM',24),(396,50,'outside','2025-03-27 07:00:00.000000','America/New_York','RUN',24),(397,40,'inside','2025-03-25 18:30:00.000000','America/New_York','SWIM',24),(398,55,'outside','2025-03-23 07:30:00.000000','America/New_York','CYCLE',24),(399,45,'inside','2025-03-21 17:00:00.000000','America/New_York','GYM',24),(400,50,'outside','2025-03-19 07:00:00.000000','America/New_York','RUN',24),(401,60,'inside','2025-03-17 18:00:00.000000','America/New_York','GYM',24),(402,35,'outside','2025-03-15 08:00:00.000000','America/New_York','WALK',24),(403,45,'inside','2025-03-13 17:30:00.000000','America/New_York','SWIM',24),(404,50,'outside','2025-03-11 07:00:00.000000','America/New_York','RUN',24),(405,55,'inside','2025-03-09 18:30:00.000000','America/New_York','GYM',24),(406,40,'outside','2025-03-07 07:30:00.000000','America/New_York','CYCLE',24),(407,45,'inside','2025-03-05 17:00:00.000000','America/New_York','SWIM',24),(408,50,'outside','2025-03-03 07:00:00.000000','America/New_York','RUN',24),(409,60,'inside','2025-03-01 18:00:00.000000','America/New_York','GYM',24),
-- February 2025
(410,35,'outside','2025-02-27 08:00:00.000000','America/New_York','WALK',24),(411,45,'inside','2025-02-25 17:30:00.000000','America/New_York','GYM',24),(412,50,'outside','2025-02-23 07:00:00.000000','America/New_York','RUN',24),(413,40,'inside','2025-02-21 18:30:00.000000','America/New_York','SWIM',24),(414,55,'outside','2025-02-19 07:30:00.000000','America/New_York','CYCLE',24),(415,45,'inside','2025-02-17 17:00:00.000000','America/New_York','GYM',24),(416,50,'outside','2025-02-15 07:00:00.000000','America/New_York','RUN',24),(417,60,'inside','2025-02-13 18:00:00.000000','America/New_York','GYM',24),(418,35,'outside','2025-02-11 08:00:00.000000','America/New_York','WALK',24),(419,45,'inside','2025-02-09 17:30:00.000000','America/New_York','SWIM',24),(420,50,'outside','2025-02-07 07:00:00.000000','America/New_York','RUN',24),(421,55,'inside','2025-02-05 18:30:00.000000','America/New_York','GYM',24),(422,40,'outside','2025-02-03 07:30:00.000000','America/New_York','CYCLE',24),(423,45,'inside','2025-02-01 17:00:00.000000','America/New_York','SWIM',24),
-- January 2025
(424,50,'outside','2025-01-30 07:00:00.000000','America/New_York','RUN',24),(425,60,'inside','2025-01-28 18:00:00.000000','America/New_York','GYM',24),(426,35,'outside','2025-01-26 08:00:00.000000','America/New_York','WALK',24),(427,45,'inside','2025-01-24 17:30:00.000000','America/New_York','GYM',24),(428,50,'outside','2025-01-22 07:00:00.000000','America/New_York','RUN',24),(429,40,'inside','2025-01-20 18:30:00.000000','America/New_York','SWIM',24),(430,55,'outside','2025-01-18 07:30:00.000000','America/New_York','CYCLE',24),(431,45,'inside','2025-01-16 17:00:00.000000','America/New_York','GYM',24),(432,50,'outside','2025-01-14 07:00:00.000000','America/New_York','RUN',24),(433,60,'inside','2025-01-12 18:00:00.000000','America/New_York','GYM',24),(434,35,'outside','2025-01-10 08:00:00.000000','America/New_York','WALK',24),(435,45,'inside','2025-01-08 17:30:00.000000','America/New_York','SWIM',24),(436,50,'outside','2025-01-06 07:00:00.000000','America/New_York','RUN',24),(437,55,'inside','2025-01-04 18:30:00.000000','America/New_York','GYM',24),(438,40,'outside','2025-01-02 07:30:00.000000','America/New_York','CYCLE',24),
-- December 2024
(439,45,'inside','2024-12-31 17:00:00.000000','America/New_York','SWIM',24),(440,50,'outside','2024-12-29 07:00:00.000000','America/New_York','RUN',24),(441,60,'inside','2024-12-27 18:00:00.000000','America/New_York','GYM',24),(442,35,'outside','2024-12-25 08:00:00.000000','America/New_York','WALK',24),(443,45,'inside','2024-12-23 17:30:00.000000','America/New_York','GYM',24),(444,50,'outside','2024-12-21 07:00:00.000000','America/New_York','RUN',24),(445,40,'inside','2024-12-19 18:30:00.000000','America/New_York','SWIM',24),(446,55,'outside','2024-12-17 07:30:00.000000','America/New_York','CYCLE',24),(447,45,'inside','2024-12-15 17:00:00.000000','America/New_York','GYM',24),(448,50,'outside','2024-12-13 07:00:00.000000','America/New_York','RUN',24),(449,60,'inside','2024-12-11 18:00:00.000000','America/New_York','GYM',24),(450,35,'outside','2024-12-09 08:00:00.000000','America/New_York','WALK',24),(451,45,'inside','2024-12-07 17:30:00.000000','America/New_York','SWIM',24),(452,50,'outside','2024-12-05 07:00:00.000000','America/New_York','RUN',24),(453,55,'inside','2024-12-03 18:30:00.000000','America/New_York','GYM',24),(454,40,'outside','2024-12-01 07:30:00.000000','America/New_York','CYCLE',24),
-- November 2024
(455,45,'inside','2024-11-29 17:00:00.000000','America/New_York','SWIM',24),(456,50,'outside','2024-11-27 07:00:00.000000','America/New_York','RUN',24),(457,60,'inside','2024-11-25 18:00:00.000000','America/New_York','GYM',24),(458,35,'outside','2024-11-23 08:00:00.000000','America/New_York','WALK',24),(459,45,'inside','2024-11-21 17:30:00.000000','America/New_York','GYM',24),(460,50,'outside','2024-11-19 07:00:00.000000','America/New_York','RUN',24),(461,40,'inside','2024-11-17 18:30:00.000000','America/New_York','SWIM',24),(462,55,'outside','2024-11-15 07:30:00.000000','America/New_York','CYCLE',24),(463,45,'inside','2024-11-13 17:00:00.000000','America/New_York','GYM',24),(464,50,'outside','2024-11-11 07:00:00.000000','America/New_York','RUN',24),(465,60,'inside','2024-11-09 18:00:00.000000','America/New_York','GYM',24),(466,35,'outside','2024-11-07 08:00:00.000000','America/New_York','WALK',24),(467,45,'inside','2024-11-05 17:30:00.000000','America/New_York','SWIM',24),(468,50,'outside','2024-11-03 07:00:00.000000','America/New_York','RUN',24),(469,55,'inside','2024-11-01 18:30:00.000000','America/New_York','GYM',24),

-- Other users - starting from ID 470
(470,30,'outside','2025-11-17 08:00:00.000000','America/Los_Angeles','WALK',5),(471,35,'inside','2025-11-17 17:00:00.000000','America/Los_Angeles','SWIM',5),(472,40,'outside','2025-11-16 07:30:00.000000','America/Los_Angeles','WALK',5),(473,30,'inside','2025-11-16 18:00:00.000000','America/Los_Angeles','SWIM',5),(474,25,'outside','2025-11-15 08:30:00.000000','America/Los_Angeles','WALK',5),(475,45,'inside','2025-11-15 16:00:00.000000','America/Los_Angeles','SWIM',5),(476,35,'outside','2025-11-14 07:00:00.000000','America/Los_Angeles','WALK',5),(477,40,'inside','2025-11-14 17:00:00.000000','America/Los_Angeles','SWIM',5),(478,40,'outside','2025-11-13 08:00:00.000000','America/Los_Angeles','WALK',5),(479,30,'inside','2025-11-13 17:30:00.000000','America/Los_Angeles','SWIM',5),(480,35,'outside','2025-11-12 09:00:00.000000','America/Los_Angeles','WALK',5),(481,35,'inside','2025-11-12 16:00:00.000000','America/Los_Angeles','SWIM',5),(482,30,'outside','2025-11-11 07:30:00.000000','America/Los_Angeles','WALK',5),(483,40,'inside','2025-11-11 16:00:00.000000','America/Los_Angeles','SWIM',5),(484,25,'outside','2025-11-10 08:00:00.000000','America/Los_Angeles','WALK',5),(485,35,'inside','2025-11-10 17:00:00.000000','America/Los_Angeles','SWIM',5),(486,40,'outside','2025-11-09 07:00:00.000000','America/Los_Angeles','WALK',5),(487,30,'inside','2025-11-09 17:00:00.000000','America/Los_Angeles','SWIM',5),(488,20,'inside','2025-11-09 12:00:00.000000','America/Los_Angeles','OTHER',5),(489,30,'outside','2025-11-08 08:30:00.000000','America/Los_Angeles','WALK',5),(490,35,'inside','2025-11-08 17:00:00.000000','America/Los_Angeles','SWIM',5),(491,25,'outside','2025-11-07 09:00:00.000000','America/Los_Angeles','WALK',5),(492,40,'inside','2025-11-07 16:30:00.000000','America/Los_Angeles','SWIM',5),(493,20,'outside','2025-11-07 12:00:00.000000','America/Los_Angeles','OTHER',5),(494,35,'outside','2025-11-06 07:30:00.000000','America/Los_Angeles','WALK',5),(495,40,'inside','2025-11-06 16:30:00.000000','America/Los_Angeles','SWIM',5),(496,30,'outside','2025-11-05 08:00:00.000000','America/Los_Angeles','WALK',5),(497,35,'inside','2025-11-05 17:00:00.000000','America/Los_Angeles','SWIM',5),(498,35,'outside','2025-11-04 07:00:00.000000','America/Los_Angeles','WALK',5),(499,30,'inside','2025-11-04 17:00:00.000000','America/Los_Angeles','SWIM',5),(500,35,'outside','2025-11-17 07:00:00.000000','Europe/London','WALK',7),(501,45,'inside','2025-11-17 18:00:00.000000','Europe/London','GYM',7),(502,30,'outside','2025-11-16 07:30:00.000000','Europe/London','WALK',7),(503,40,'inside','2025-11-16 17:00:00.000000','Europe/London','SWIM',7),(504,40,'outside','2025-11-15 08:00:00.000000','Europe/London','RUN',7),(505,35,'inside','2025-11-15 18:30:00.000000','Europe/London','GYM',7),(506,25,'outside','2025-11-14 07:00:00.000000','Europe/London','WALK',7),(507,50,'inside','2025-11-14 18:00:00.000000','Europe/London','GYM',7),(508,45,'inside','2025-11-13 18:00:00.000000','Europe/London','GYM',7),(509,30,'outside','2025-11-13 12:00:00.000000','Europe/London','WALK',7),(510,35,'outside','2025-11-12 07:30:00.000000','Europe/London','RUN',7),(511,40,'inside','2025-11-12 17:00:00.000000','Europe/London','SWIM',7),(512,40,'inside','2025-11-11 17:00:00.000000','Europe/London','SWIM',7),(513,25,'outside','2025-11-11 08:00:00.000000','Europe/London','WALK',7),(514,50,'inside','2025-11-10 18:00:00.000000','Europe/London','GYM',7),(515,30,'outside','2025-11-10 07:30:00.000000','Europe/London','WALK',7),(516,30,'outside','2025-11-09 07:00:00.000000','Europe/London','WALK',7),(517,40,'inside','2025-11-09 17:30:00.000000','Europe/London','GYM',7),(518,35,'outside','2025-11-09 12:00:00.000000','Europe/London','CYCLE',7),(519,35,'outside','2025-11-08 08:00:00.000000','Europe/London','RUN',7),(520,45,'inside','2025-11-08 18:00:00.000000','Europe/London','GYM',7),(521,30,'outside','2025-11-07 07:30:00.000000','Europe/London','WALK',7),(522,40,'inside','2025-11-07 17:00:00.000000','Europe/London','SWIM',7),(523,20,'outside','2025-11-07 12:00:00.000000','Europe/London','WALK',7),(524,45,'inside','2025-11-06 18:00:00.000000','Europe/London','GYM',7),(525,25,'outside','2025-11-06 07:00:00.000000','Europe/London','WALK',7),(526,35,'outside','2025-11-05 07:00:00.000000','Europe/London','RUN',7),(527,25,'outside','2025-11-05 12:00:00.000000','Europe/London','WALK',7),(528,40,'inside','2025-11-04 18:00:00.000000','Europe/London','GYM',7),(529,30,'outside','2025-11-04 07:30:00.000000','Europe/London','WALK',7),(530,60,'inside','2025-11-17 06:30:00.000000','Asia/Tokyo','GYM',9),(531,35,'outside','2025-11-17 18:00:00.000000','Asia/Tokyo','WALK',9),(532,55,'inside','2025-11-16 07:00:00.000000','Asia/Tokyo','GYM',9),(533,30,'outside','2025-11-16 17:30:00.000000','Asia/Tokyo','RUN',9),(534,50,'inside','2025-11-15 06:00:00.000000','Asia/Tokyo','GYM',9),(535,40,'outside','2025-11-15 18:00:00.000000','Asia/Tokyo','CYCLE',9),(536,60,'inside','2025-11-14 06:30:00.000000','Asia/Tokyo','GYM',9),(537,35,'outside','2025-11-14 17:00:00.000000','Asia/Tokyo','WALK',9),(538,55,'inside','2025-11-13 07:00:00.000000','Asia/Tokyo','GYM',9),(539,35,'outside','2025-11-13 17:00:00.000000','Asia/Tokyo','WALK',9),(540,50,'inside','2025-11-12 06:00:00.000000','Asia/Tokyo','GYM',9),(541,30,'outside','2025-11-12 17:30:00.000000','Asia/Tokyo','RUN',9),(542,60,'inside','2025-11-11 06:30:00.000000','Asia/Tokyo','GYM',9),(543,30,'outside','2025-11-11 18:00:00.000000','Asia/Tokyo','RUN',9),(544,55,'inside','2025-11-10 07:00:00.000000','Asia/Tokyo','GYM',9),(545,40,'outside','2025-11-10 18:00:00.000000','Asia/Tokyo','CYCLE',9),(546,50,'inside','2025-11-09 06:00:00.000000','Asia/Tokyo','GYM',9),(547,35,'outside','2025-11-09 17:30:00.000000','Asia/Tokyo','WALK',9),(548,20,'outside','2025-11-09 12:00:00.000000','Asia/Tokyo','OTHER',9),(549,60,'inside','2025-11-08 06:30:00.000000','Asia/Tokyo','GYM',9),(550,30,'outside','2025-11-08 17:30:00.000000','Asia/Tokyo','RUN',9),(551,55,'inside','2025-11-07 07:00:00.000000','Asia/Tokyo','GYM',9),(552,40,'outside','2025-11-07 18:00:00.000000','Asia/Tokyo','CYCLE',9),(553,20,'outside','2025-11-07 12:00:00.000000','Asia/Tokyo','WALK',9),(554,50,'inside','2025-11-06 06:00:00.000000','Asia/Tokyo','GYM',9),(555,35,'outside','2025-11-06 17:30:00.000000','Asia/Tokyo','WALK',9),(556,60,'inside','2025-11-05 06:30:00.000000','Asia/Tokyo','GYM',9),(557,30,'outside','2025-11-05 17:00:00.000000','Asia/Tokyo','RUN',9),(558,55,'inside','2025-11-04 07:00:00.000000','Asia/Tokyo','GYM',9),(559,40,'outside','2025-11-04 18:00:00.000000','Asia/Tokyo','CYCLE',9),(560,90,'outside','2025-11-17 06:00:00.000000','Australia/Sydney','CYCLE',10),(561,45,'inside','2025-11-17 17:00:00.000000','Australia/Sydney','GYM',10),(562,85,'outside','2025-11-16 06:30:00.000000','Australia/Sydney','CYCLE',10),(563,40,'outside','2025-11-16 17:30:00.000000','Australia/Sydney','WALK',10),(564,95,'outside','2025-11-15 06:00:00.000000','Australia/Sydney','CYCLE',10),(565,50,'inside','2025-11-15 18:00:00.000000','Australia/Sydney','GYM',10),(566,80,'outside','2025-11-14 07:00:00.000000','Australia/Sydney','CYCLE',10),(567,45,'inside','2025-11-14 17:00:00.000000','Australia/Sydney','GYM',10),(568,90,'outside','2025-11-13 06:00:00.000000','Australia/Sydney','CYCLE',10),(569,45,'inside','2025-11-13 17:00:00.000000','Australia/Sydney','GYM',10),(570,85,'outside','2025-11-12 06:30:00.000000','Australia/Sydney','CYCLE',10),(571,40,'outside','2025-11-12 17:30:00.000000','Australia/Sydney','WALK',10),(572,75,'outside','2025-11-11 07:00:00.000000','Australia/Sydney','CYCLE',10),(573,40,'outside','2025-11-11 17:00:00.000000','Australia/Sydney','WALK',10),(574,90,'outside','2025-11-10 06:00:00.000000','Australia/Sydney','CYCLE',10),(575,50,'inside','2025-11-10 18:00:00.000000','Australia/Sydney','GYM',10),(576,85,'outside','2025-11-09 06:30:00.000000','Australia/Sydney','CYCLE',10),(577,50,'inside','2025-11-09 18:00:00.000000','Australia/Sydney','GYM',10),(578,30,'outside','2025-11-09 12:00:00.000000','Australia/Sydney','SWIM',10),(579,80,'outside','2025-11-08 07:00:00.000000','Australia/Sydney','CYCLE',10),(580,40,'outside','2025-11-08 17:30:00.000000','Australia/Sydney','WALK',10),(581,90,'outside','2025-11-07 06:00:00.000000','Australia/Sydney','CYCLE',10),(582,45,'inside','2025-11-07 17:00:00.000000','Australia/Sydney','GYM',10),(583,25,'outside','2025-11-07 12:00:00.000000','Australia/Sydney','SWIM',10),(584,85,'outside','2025-11-06 06:30:00.000000','Australia/Sydney','CYCLE',10),(585,40,'outside','2025-11-06 17:30:00.000000','Australia/Sydney','WALK',10),(586,75,'outside','2025-11-05 07:00:00.000000','Australia/Sydney','CYCLE',10),(587,40,'outside','2025-11-05 17:00:00.000000','Australia/Sydney','WALK',10),(588,90,'outside','2025-11-04 06:00:00.000000','Australia/Sydney','CYCLE',10),(589,50,'inside','2025-11-04 18:00:00.000000','Australia/Sydney','GYM',10),(590,45,'outside','2025-11-17 07:00:00.000000','America/Denver','RUN',12),(591,35,'outside','2025-11-17 17:00:00.000000','America/Denver','WALK',12),(592,50,'outside','2025-11-16 06:30:00.000000','America/Denver','RUN',12),(593,40,'inside','2025-11-16 18:00:00.000000','America/Denver','GYM',12),(594,55,'outside','2025-11-15 07:00:00.000000','America/Denver','RUN',12),(595,30,'outside','2025-11-15 17:30:00.000000','America/Denver','WALK',12),(596,40,'outside','2025-11-14 06:30:00.000000','America/Denver','RUN',12),(597,45,'inside','2025-11-14 18:00:00.000000','America/Denver','GYM',12),(598,50,'outside','2025-11-13 07:00:00.000000','America/Denver','RUN',12),(599,45,'inside','2025-11-13 18:00:00.000000','America/Denver','GYM',12),(600,45,'outside','2025-11-12 06:30:00.000000','America/Denver','RUN',12),(601,35,'outside','2025-11-12 17:00:00.000000','America/Denver','WALK',12),(602,55,'outside','2025-11-11 07:00:00.000000','America/Denver','RUN',12),(603,35,'outside','2025-11-11 17:00:00.000000','America/Denver','WALK',12),(604,40,'outside','2025-11-10 06:30:00.000000','America/Denver','RUN',12),(605,40,'inside','2025-11-10 18:00:00.000000','America/Denver','GYM',12),(606,50,'outside','2025-11-09 07:00:00.000000','America/Denver','RUN',12),(607,40,'inside','2025-11-09 18:00:00.000000','America/Denver','GYM',12),(608,25,'outside','2025-11-09 12:00:00.000000','America/Denver','OTHER',12),(609,45,'outside','2025-11-08 06:30:00.000000','America/Denver','RUN',12),(610,30,'outside','2025-11-08 17:30:00.000000','America/Denver','WALK',12),(611,55,'outside','2025-11-07 07:00:00.000000','America/Denver','RUN',12),(612,30,'outside','2025-11-07 17:30:00.000000','America/Denver','WALK',12),(613,20,'outside','2025-11-07 12:00:00.000000','America/Denver','OTHER',12),(614,40,'outside','2025-11-06 06:30:00.000000','America/Denver','RUN',12),(615,45,'inside','2025-11-06 18:00:00.000000','America/Denver','GYM',12),(616,50,'outside','2025-11-05 07:00:00.000000','America/Denver','RUN',12),(617,45,'inside','2025-11-05 18:00:00.000000','America/Denver','GYM',12),(618,45,'outside','2025-11-04 06:30:00.000000','America/Denver','RUN',12),(619,35,'outside','2025-11-04 17:00:00.000000','America/Denver','WALK',12),(620,40,'outside','2025-11-17 06:30:00.000000','Asia/Hong_Kong','OTHER',13),(621,35,'outside','2025-11-17 18:00:00.000000','Asia/Hong_Kong','WALK',13),(622,50,'inside','2025-11-16 07:00:00.000000','Asia/Hong_Kong','GYM',13),(623,25,'outside','2025-11-16 17:00:00.000000','Asia/Hong_Kong','WALK',13),(624,45,'outside','2025-11-15 06:00:00.000000','Asia/Hong_Kong','OTHER',13),(625,40,'inside','2025-11-15 18:00:00.000000','Asia/Hong_Kong','GYM',13),(626,30,'outside','2025-11-14 07:00:00.000000','Asia/Hong_Kong','WALK',13),(627,50,'inside','2025-11-14 18:00:00.000000','Asia/Hong_Kong','GYM',13),(628,50,'inside','2025-11-13 06:30:00.000000','Asia/Hong_Kong','GYM',13),(629,35,'outside','2025-11-13 17:30:00.000000','Asia/Hong_Kong','WALK',13),(630,40,'outside','2025-11-12 06:00:00.000000','Asia/Hong_Kong','OTHER',13),(631,25,'outside','2025-11-12 18:00:00.000000','Asia/Hong_Kong','WALK',13),(632,45,'inside','2025-11-11 07:00:00.000000','Asia/Hong_Kong','GYM',13),(633,25,'outside','2025-11-11 18:00:00.000000','Asia/Hong_Kong','WALK',13),(634,50,'inside','2025-11-10 06:30:00.000000','Asia/Hong_Kong','GYM',13),(635,30,'outside','2025-11-10 17:00:00.000000','Asia/Hong_Kong','WALK',13),(636,40,'outside','2025-11-09 06:00:00.000000','Asia/Hong_Kong','OTHER',13),(637,30,'outside','2025-11-09 17:00:00.000000','Asia/Hong_Kong','WALK',13),(638,25,'outside','2025-11-09 12:00:00.000000','Asia/Hong_Kong','WALK',13),(639,45,'inside','2025-11-08 07:00:00.000000','Asia/Hong_Kong','GYM',13),(640,35,'outside','2025-11-08 17:30:00.000000','Asia/Hong_Kong','WALK',13),(641,35,'outside','2025-11-07 06:30:00.000000','Asia/Hong_Kong','WALK',13),(642,50,'inside','2025-11-07 18:00:00.000000','Asia/Hong_Kong','GYM',13),(643,20,'outside','2025-11-07 12:00:00.000000','Asia/Hong_Kong','SWIM',13),(644,40,'outside','2025-11-06 06:00:00.000000','Asia/Hong_Kong','OTHER',13),(645,25,'outside','2025-11-06 18:00:00.000000','Asia/Hong_Kong','WALK',13),(646,45,'inside','2025-11-05 07:00:00.000000','Asia/Hong_Kong','GYM',13),(647,25,'outside','2025-11-05 17:30:00.000000','Asia/Hong_Kong','WALK',13),(648,50,'inside','2025-11-04 06:30:00.000000','Asia/Hong_Kong','GYM',13),(649,30,'outside','2025-11-04 17:00:00.000000','Asia/Hong_Kong','WALK',13),(650,40,'outside','2025-11-15 07:00:00.000000','America/Chicago','RUN',4),(651,30,'outside','2025-11-15 17:00:00.000000','America/Chicago','WALK',4),(652,35,'outside','2025-11-14 08:00:00.000000','America/Chicago','WALK',4),(653,45,'inside','2025-11-14 18:00:00.000000','America/Chicago','GYM',4),(654,50,'inside','2025-11-13 18:00:00.000000','America/Chicago','GYM',4),(655,25,'outside','2025-11-13 12:00:00.000000','America/Chicago','WALK',4),(656,45,'outside','2025-11-12 07:00:00.000000','America/Chicago','RUN',4),(657,30,'outside','2025-11-12 17:00:00.000000','America/Chicago','WALK',4),(658,30,'outside','2025-11-11 12:00:00.000000','America/Chicago','WALK',4),(659,40,'inside','2025-11-11 18:00:00.000000','America/Chicago','GYM',4),(660,40,'inside','2025-11-10 18:00:00.000000','America/Chicago','GYM',4),(661,35,'outside','2025-11-10 07:00:00.000000','America/Chicago','RUN',4),(662,35,'outside','2025-11-09 07:00:00.000000','America/Chicago','RUN',4),(663,25,'outside','2025-11-09 17:00:00.000000','America/Chicago','WALK',4),(664,30,'outside','2025-11-09 12:00:00.000000','America/Chicago','WALK',4),(665,25,'outside','2025-11-08 08:00:00.000000','America/Chicago','WALK',4),(666,50,'inside','2025-11-08 18:00:00.000000','America/Chicago','GYM',4),(667,50,'inside','2025-11-07 18:00:00.000000','America/Chicago','GYM',4),(668,20,'outside','2025-11-07 12:00:00.000000','America/Chicago','WALK',4),(669,40,'outside','2025-11-05 07:00:00.000000','America/Chicago','RUN',4),(670,30,'outside','2025-11-05 17:00:00.000000','America/Chicago','WALK',4),(671,35,'outside','2025-11-04 08:00:00.000000','America/Chicago','WALK',4),(672,40,'inside','2025-11-04 18:00:00.000000','America/Chicago','GYM',4),(673,40,'inside','2025-11-15 07:00:00.000000','Europe/Paris','SWIM',8),(674,30,'outside','2025-11-15 17:00:00.000000','Europe/Paris','WALK',8),(675,35,'inside','2025-11-14 08:00:00.000000','Europe/Paris','SWIM',8),(676,25,'outside','2025-11-14 12:00:00.000000','Europe/Paris','WALK',8),(677,40,'outside','2025-11-13 12:00:00.000000','Europe/Paris','WALK',8),(678,35,'inside','2025-11-13 18:00:00.000000','Europe/Paris','SWIM',8),(679,35,'inside','2025-11-12 07:00:00.000000','Europe/Paris','SWIM',8),(680,25,'outside','2025-11-12 18:00:00.000000','Europe/Paris','WALK',8),(681,25,'outside','2025-11-11 18:00:00.000000','Europe/Paris','WALK',8),(682,40,'inside','2025-11-11 07:30:00.000000','Europe/Paris','SWIM',8),(683,40,'inside','2025-11-09 08:00:00.000000','Europe/Paris','SWIM',8),(684,30,'outside','2025-11-09 17:00:00.000000','Europe/Paris','WALK',8),(685,25,'outside','2025-11-09 12:00:00.000000','Europe/Paris','WALK',8),(686,30,'outside','2025-11-08 12:00:00.000000','Europe/Paris','WALK',8),(687,35,'inside','2025-11-08 18:00:00.000000','Europe/Paris','SWIM',8),(688,35,'inside','2025-11-07 07:00:00.000000','Europe/Paris','SWIM',8),(689,25,'outside','2025-11-07 17:00:00.000000','Europe/Paris','WALK',8),(690,40,'outside','2025-11-05 17:00:00.000000','Europe/Paris','WALK',8),(691,35,'inside','2025-11-05 08:00:00.000000','Europe/Paris','SWIM',8),(692,35,'inside','2025-11-04 08:00:00.000000','Europe/Paris','SWIM',8),(693,30,'outside','2025-11-04 17:00:00.000000','Europe/Paris','WALK',8),(694,45,'inside','2025-11-15 07:30:00.000000','Europe/Paris','SWIM',11),(695,25,'outside','2025-11-15 17:00:00.000000','Europe/Paris','WALK',11),(696,40,'inside','2025-11-14 08:00:00.000000','Europe/Paris','SWIM',11),(697,30,'outside','2025-11-14 17:00:00.000000','Europe/Paris','WALK',11),(698,35,'outside','2025-11-13 12:00:00.000000','Europe/Paris','WALK',11),(699,40,'inside','2025-11-13 18:00:00.000000','Europe/Paris','SWIM',11),(700,40,'inside','2025-11-12 07:30:00.000000','Europe/Paris','SWIM',11),(701,30,'outside','2025-11-12 17:00:00.000000','Europe/Paris','WALK',11),(702,30,'outside','2025-11-11 17:00:00.000000','Europe/Paris','WALK',11),(703,45,'inside','2025-11-11 07:30:00.000000','Europe/Paris','SWIM',11),(704,45,'inside','2025-11-09 08:00:00.000000','Europe/Paris','SWIM',11),(705,25,'outside','2025-11-09 17:00:00.000000','Europe/Paris','WALK',11),(706,25,'outside','2025-11-09 12:00:00.000000','Europe/Paris','WALK',11),(707,25,'outside','2025-11-08 12:00:00.000000','Europe/Paris','WALK',11),(708,40,'inside','2025-11-08 18:00:00.000000','Europe/Paris','SWIM',11),(709,40,'inside','2025-11-07 07:30:00.000000','Europe/Paris','SWIM',11),(710,25,'outside','2025-11-07 17:00:00.000000','Europe/Paris','WALK',11),(711,35,'outside','2025-11-05 17:00:00.000000','Europe/Paris','WALK',11),(712,45,'inside','2025-11-05 08:00:00.000000','Europe/Paris','SWIM',11),(713,40,'inside','2025-11-04 08:00:00.000000','Europe/Paris','SWIM',11),(714,30,'outside','2025-11-04 17:00:00.000000','Europe/Paris','WALK',11),(715,30,'outside','2025-11-10 08:00:00.000000','Asia/Shanghai','WALK',6),(716,25,'outside','2025-11-10 17:00:00.000000','Asia/Shanghai','WALK',6),(717,25,'outside','2025-11-09 07:00:00.000000','Asia/Shanghai','WALK',6),(718,20,'outside','2025-11-08 12:00:00.000000','Asia/Shanghai','WALK',6),(719,25,'outside','2025-11-08 17:00:00.000000','Asia/Shanghai','WALK',6),(720,20,'outside','2025-11-07 08:00:00.000000','Asia/Shanghai','WALK',6),(721,25,'outside','2025-11-06 08:00:00.000000','Asia/Shanghai','WALK',6),(722,30,'outside','2025-11-06 17:00:00.000000','Asia/Shanghai','WALK',6),(723,30,'outside','2025-11-04 07:00:00.000000','Asia/Shanghai','WALK',6),(724,20,'outside','2025-11-04 17:00:00.000000','Asia/Shanghai','WALK',6),(725,25,'outside','2025-11-04 12:00:00.000000','Asia/Shanghai','WALK',6),
-- Last Week Data (Nov 25 - Dec 2, 2025)
-- User 24 (allen) - continuing active routine
(726,50,'outside','2025-12-02 07:00:00.000000','America/New_York','RUN',24),(727,45,'inside','2025-12-02 18:00:00.000000','America/New_York','GYM',24),(728,55,'outside','2025-12-01 07:30:00.000000','America/New_York','RUN',24),(729,40,'inside','2025-12-01 17:30:00.000000','America/New_York','SWIM',24),(730,60,'outside','2025-11-30 08:00:00.000000','America/New_York','CYCLE',24),(731,35,'inside','2025-11-30 18:30:00.000000','America/New_York','GYM',24),(732,45,'outside','2025-11-29 07:00:00.000000','America/New_York','RUN',24),(733,50,'inside','2025-11-29 18:00:00.000000','America/New_York','GYM',24),(734,40,'outside','2025-11-28 07:30:00.000000','America/New_York','WALK',24),(735,55,'inside','2025-11-28 17:00:00.000000','America/New_York','GYM',24),(736,50,'outside','2025-11-27 07:00:00.000000','America/New_York','RUN',24),(737,45,'inside','2025-11-27 18:30:00.000000','America/New_York','SWIM',24),(738,35,'outside','2025-11-26 07:30:00.000000','America/New_York','WALK',24),(739,60,'inside','2025-11-26 18:00:00.000000','America/New_York','GYM',24),(740,45,'outside','2025-11-25 07:00:00.000000','America/New_York','RUN',24),(741,40,'inside','2025-11-25 17:30:00.000000','America/New_York','GYM',24),
-- User 5 (sarah_smith) - Last week
(742,30,'outside','2025-12-02 08:00:00.000000','America/Los_Angeles','WALK',5),(743,40,'inside','2025-12-02 17:00:00.000000','America/Los_Angeles','SWIM',5),(744,35,'outside','2025-12-01 07:30:00.000000','America/Los_Angeles','WALK',5),(745,35,'inside','2025-12-01 16:30:00.000000','America/Los_Angeles','SWIM',5),(746,25,'outside','2025-11-30 08:30:00.000000','America/Los_Angeles','WALK',5),(747,40,'inside','2025-11-30 17:00:00.000000','America/Los_Angeles','SWIM',5),(748,30,'outside','2025-11-29 07:00:00.000000','America/Los_Angeles','WALK',5),(749,35,'inside','2025-11-29 16:00:00.000000','America/Los_Angeles','SWIM',5),(750,40,'outside','2025-11-28 08:00:00.000000','America/Los_Angeles','WALK',5),(751,30,'inside','2025-11-28 17:30:00.000000','America/Los_Angeles','SWIM',5),(752,35,'outside','2025-11-27 09:00:00.000000','America/Los_Angeles','WALK',5),(753,40,'inside','2025-11-27 16:00:00.000000','America/Los_Angeles','SWIM',5),(754,25,'outside','2025-11-26 07:30:00.000000','America/Los_Angeles','WALK',5),(755,35,'inside','2025-11-26 17:00:00.000000','America/Los_Angeles','SWIM',5),(756,30,'outside','2025-11-25 08:00:00.000000','America/Los_Angeles','WALK',5),(757,40,'inside','2025-11-25 16:30:00.000000','America/Los_Angeles','SWIM',5),
-- User 7 (emily_davis) - Last week
(758,40,'outside','2025-12-02 07:30:00.000000','Europe/London','RUN',7),(759,50,'inside','2025-12-02 18:00:00.000000','Europe/London','GYM',7),(760,30,'outside','2025-12-01 07:00:00.000000','Europe/London','WALK',7),(761,45,'inside','2025-12-01 17:30:00.000000','Europe/London','GYM',7),(762,35,'outside','2025-11-30 08:00:00.000000','Europe/London','RUN',7),(763,40,'inside','2025-11-30 18:00:00.000000','Europe/London','SWIM',7),(764,25,'outside','2025-11-29 07:30:00.000000','Europe/London','WALK',7),(765,50,'inside','2025-11-29 17:00:00.000000','Europe/London','GYM',7),(766,45,'outside','2025-11-28 07:00:00.000000','Europe/London','RUN',7),(767,35,'inside','2025-11-28 18:00:00.000000','Europe/London','GYM',7),(768,30,'outside','2025-11-27 08:00:00.000000','Europe/London','WALK',7),(769,40,'inside','2025-11-27 17:00:00.000000','Europe/London','SWIM',7),(770,35,'outside','2025-11-26 07:30:00.000000','Europe/London','RUN',7),(771,45,'inside','2025-11-26 18:00:00.000000','Europe/London','GYM',7),(772,30,'outside','2025-11-25 07:00:00.000000','Europe/London','WALK',7),(773,40,'inside','2025-11-25 17:30:00.000000','Europe/London','SWIM',7),
-- User 9 (lisa_brown) - Last week
(774,60,'inside','2025-12-02 06:30:00.000000','Asia/Tokyo','GYM',9),(775,35,'outside','2025-12-02 18:00:00.000000','Asia/Tokyo','WALK',9),(776,55,'inside','2025-12-01 07:00:00.000000','Asia/Tokyo','GYM',9),(777,30,'outside','2025-12-01 17:30:00.000000','Asia/Tokyo','RUN',9),(778,50,'inside','2025-11-30 06:00:00.000000','Asia/Tokyo','GYM',9),(779,40,'outside','2025-11-30 18:00:00.000000','Asia/Tokyo','CYCLE',9),(780,60,'inside','2025-11-29 06:30:00.000000','Asia/Tokyo','GYM',9),(781,35,'outside','2025-11-29 17:00:00.000000','Asia/Tokyo','WALK',9),(782,55,'inside','2025-11-28 07:00:00.000000','Asia/Tokyo','GYM',9),(783,30,'outside','2025-11-28 17:30:00.000000','Asia/Tokyo','RUN',9),(784,50,'inside','2025-11-27 06:00:00.000000','Asia/Tokyo','GYM',9),(785,35,'outside','2025-11-27 18:00:00.000000','Asia/Tokyo','WALK',9),(786,60,'inside','2025-11-26 06:30:00.000000','Asia/Tokyo','GYM',9),(787,40,'outside','2025-11-26 17:30:00.000000','Asia/Tokyo','CYCLE',9),(788,55,'inside','2025-11-25 07:00:00.000000','Asia/Tokyo','GYM',9),(789,30,'outside','2025-11-25 18:00:00.000000','Asia/Tokyo','RUN',9),
-- User 10 (james_taylor) - Last week
(790,90,'outside','2025-12-02 06:00:00.000000','Australia/Sydney','CYCLE',10),(791,50,'inside','2025-12-02 17:00:00.000000','Australia/Sydney','GYM',10),(792,85,'outside','2025-12-01 06:30:00.000000','Australia/Sydney','CYCLE',10),(793,45,'inside','2025-12-01 18:00:00.000000','Australia/Sydney','GYM',10),(794,95,'outside','2025-11-30 06:00:00.000000','Australia/Sydney','CYCLE',10),(795,40,'outside','2025-11-30 17:30:00.000000','Australia/Sydney','WALK',10),(796,80,'outside','2025-11-29 07:00:00.000000','Australia/Sydney','CYCLE',10),(797,50,'inside','2025-11-29 18:00:00.000000','Australia/Sydney','GYM',10),(798,90,'outside','2025-11-28 06:00:00.000000','Australia/Sydney','CYCLE',10),(799,45,'inside','2025-11-28 17:00:00.000000','Australia/Sydney','GYM',10),(800,85,'outside','2025-11-27 06:30:00.000000','Australia/Sydney','CYCLE',10),(801,40,'outside','2025-11-27 17:30:00.000000','Australia/Sydney','WALK',10),(802,75,'outside','2025-11-26 07:00:00.000000','Australia/Sydney','CYCLE',10),(803,50,'inside','2025-11-26 18:00:00.000000','Australia/Sydney','GYM',10),(804,90,'outside','2025-11-25 06:00:00.000000','Australia/Sydney','CYCLE',10),(805,45,'inside','2025-11-25 17:00:00.000000','Australia/Sydney','GYM',10),
-- User 12 (chris_martin) - Last week
(806,50,'outside','2025-12-02 07:00:00.000000','America/Denver','RUN',12),(807,40,'inside','2025-12-02 18:00:00.000000','America/Denver','GYM',12),(808,45,'outside','2025-12-01 06:30:00.000000','America/Denver','RUN',12),(809,35,'outside','2025-12-01 17:00:00.000000','America/Denver','WALK',12),(810,55,'outside','2025-11-30 07:00:00.000000','America/Denver','RUN',12),(811,45,'inside','2025-11-30 18:00:00.000000','America/Denver','GYM',12),(812,40,'outside','2025-11-29 06:30:00.000000','America/Denver','RUN',12),(813,30,'outside','2025-11-29 17:30:00.000000','America/Denver','WALK',12),(814,50,'outside','2025-11-28 07:00:00.000000','America/Denver','RUN',12),(815,45,'inside','2025-11-28 18:00:00.000000','America/Denver','GYM',12),(816,45,'outside','2025-11-27 06:30:00.000000','America/Denver','RUN',12),(817,35,'outside','2025-11-27 17:00:00.000000','America/Denver','WALK',12),(818,55,'outside','2025-11-26 07:00:00.000000','America/Denver','RUN',12),(819,40,'inside','2025-11-26 18:00:00.000000','America/Denver','GYM',12),(820,40,'outside','2025-11-25 06:30:00.000000','America/Denver','RUN',12),(821,45,'inside','2025-11-25 18:00:00.000000','America/Denver','GYM',12),
-- User 13 (jennifer_lee) - Last week
(822,45,'inside','2025-12-02 07:00:00.000000','Asia/Hong_Kong','GYM',13),(823,35,'outside','2025-12-02 17:30:00.000000','Asia/Hong_Kong','WALK',13),(824,50,'inside','2025-12-01 06:30:00.000000','Asia/Hong_Kong','GYM',13),(825,25,'outside','2025-12-01 18:00:00.000000','Asia/Hong_Kong','WALK',13),(826,40,'outside','2025-11-30 06:00:00.000000','Asia/Hong_Kong','OTHER',13),(827,30,'outside','2025-11-30 17:00:00.000000','Asia/Hong_Kong','WALK',13),(828,45,'inside','2025-11-29 07:00:00.000000','Asia/Hong_Kong','GYM',13),(829,35,'outside','2025-11-29 17:30:00.000000','Asia/Hong_Kong','WALK',13),(830,50,'inside','2025-11-28 06:30:00.000000','Asia/Hong_Kong','GYM',13),(831,25,'outside','2025-11-28 18:00:00.000000','Asia/Hong_Kong','WALK',13),(832,40,'outside','2025-11-27 06:00:00.000000','Asia/Hong_Kong','OTHER',13),(833,30,'outside','2025-11-27 17:00:00.000000','Asia/Hong_Kong','WALK',13),(834,45,'inside','2025-11-26 07:00:00.000000','Asia/Hong_Kong','GYM',13),(835,35,'outside','2025-11-26 17:30:00.000000','Asia/Hong_Kong','WALK',13),(836,50,'inside','2025-11-25 06:30:00.000000','Asia/Hong_Kong','GYM',13),(837,25,'outside','2025-11-25 18:00:00.000000','Asia/Hong_Kong','WALK',13),
-- User 4 (john_doe) - Last week
(838,45,'outside','2025-12-02 07:00:00.000000','America/Chicago','RUN',4),(839,50,'inside','2025-12-02 18:00:00.000000','America/Chicago','GYM',4),(840,35,'outside','2025-12-01 08:00:00.000000','America/Chicago','WALK',4),(841,40,'inside','2025-12-01 17:30:00.000000','America/Chicago','GYM',4),(842,40,'outside','2025-11-30 07:00:00.000000','America/Chicago','RUN',4),(843,30,'outside','2025-11-30 17:00:00.000000','America/Chicago','WALK',4),(844,50,'inside','2025-11-29 18:00:00.000000','America/Chicago','GYM',4),(845,25,'outside','2025-11-29 12:00:00.000000','America/Chicago','WALK',4),(846,35,'outside','2025-11-28 07:00:00.000000','America/Chicago','RUN',4),(847,45,'inside','2025-11-28 18:00:00.000000','America/Chicago','GYM',4),(848,30,'outside','2025-11-27 08:00:00.000000','America/Chicago','WALK',4),(849,40,'inside','2025-11-27 17:30:00.000000','America/Chicago','GYM',4),(850,40,'outside','2025-11-26 07:00:00.000000','America/Chicago','RUN',4),(851,35,'inside','2025-11-26 18:00:00.000000','America/Chicago','GYM',4),(852,25,'outside','2025-11-25 08:00:00.000000','America/Chicago','WALK',4),(853,50,'inside','2025-11-25 18:00:00.000000','America/Chicago','GYM',4),
-- User 8 (david_wilson) - Last week
(854,40,'inside','2025-12-02 07:00:00.000000','Europe/Paris','SWIM',8),(855,30,'outside','2025-12-02 17:00:00.000000','Europe/Paris','WALK',8),(856,35,'inside','2025-12-01 08:00:00.000000','Europe/Paris','SWIM',8),(857,25,'outside','2025-12-01 12:00:00.000000','Europe/Paris','WALK',8),(858,40,'inside','2025-11-30 07:00:00.000000','Europe/Paris','SWIM',8),(859,30,'outside','2025-11-30 17:00:00.000000','Europe/Paris','WALK',8),(860,35,'inside','2025-11-29 08:00:00.000000','Europe/Paris','SWIM',8),(861,25,'outside','2025-11-29 12:00:00.000000','Europe/Paris','WALK',8),(862,40,'inside','2025-11-28 07:00:00.000000','Europe/Paris','SWIM',8),(863,30,'outside','2025-11-28 18:00:00.000000','Europe/Paris','WALK',8),(864,35,'inside','2025-11-27 08:00:00.000000','Europe/Paris','SWIM',8),(865,25,'outside','2025-11-27 17:00:00.000000','Europe/Paris','WALK',8),(866,40,'inside','2025-11-26 07:00:00.000000','Europe/Paris','SWIM',8),(867,30,'outside','2025-11-26 17:00:00.000000','Europe/Paris','WALK',8),(868,35,'inside','2025-11-25 08:00:00.000000','Europe/Paris','SWIM',8),(869,25,'outside','2025-11-25 17:00:00.000000','Europe/Paris','WALK',8),
-- User 11 (amanda_white) - Last week
(870,45,'inside','2025-12-02 07:30:00.000000','Europe/Paris','SWIM',11),(871,30,'outside','2025-12-02 17:00:00.000000','Europe/Paris','WALK',11),(872,40,'inside','2025-12-01 08:00:00.000000','Europe/Paris','SWIM',11),(873,25,'outside','2025-12-01 17:00:00.000000','Europe/Paris','WALK',11),(874,45,'inside','2025-11-30 07:30:00.000000','Europe/Paris','SWIM',11),(875,30,'outside','2025-11-30 17:00:00.000000','Europe/Paris','WALK',11),(876,40,'inside','2025-11-29 08:00:00.000000','Europe/Paris','SWIM',11),(877,35,'outside','2025-11-29 12:00:00.000000','Europe/Paris','WALK',11),(878,45,'inside','2025-11-28 07:30:00.000000','Europe/Paris','SWIM',11),(879,25,'outside','2025-11-28 17:00:00.000000','Europe/Paris','WALK',11),(880,40,'inside','2025-11-27 08:00:00.000000','Europe/Paris','SWIM',11),(881,30,'outside','2025-11-27 17:00:00.000000','Europe/Paris','WALK',11),(882,45,'inside','2025-11-26 07:30:00.000000','Europe/Paris','SWIM',11),(883,35,'outside','2025-11-26 17:00:00.000000','Europe/Paris','WALK',11),(884,40,'inside','2025-11-25 08:00:00.000000','Europe/Paris','SWIM',11),(885,30,'outside','2025-11-25 17:00:00.000000','Europe/Paris','WALK',11),
-- User 6 (mike_johnson) - Last week
(886,30,'outside','2025-12-02 08:00:00.000000','Asia/Shanghai','WALK',6),(887,25,'outside','2025-12-02 17:00:00.000000','Asia/Shanghai','WALK',6),(888,25,'outside','2025-12-01 07:00:00.000000','Asia/Shanghai','WALK',6),(889,30,'outside','2025-12-01 17:00:00.000000','Asia/Shanghai','WALK',6),(890,20,'outside','2025-11-30 08:00:00.000000','Asia/Shanghai','WALK',6),(891,25,'outside','2025-11-30 12:00:00.000000','Asia/Shanghai','WALK',6),(892,30,'outside','2025-11-29 07:00:00.000000','Asia/Shanghai','WALK',6),(893,20,'outside','2025-11-29 17:00:00.000000','Asia/Shanghai','WALK',6),(894,25,'outside','2025-11-28 08:00:00.000000','Asia/Shanghai','WALK',6),(895,25,'outside','2025-11-28 12:00:00.000000','Asia/Shanghai','WALK',6),(896,30,'outside','2025-11-27 07:00:00.000000','Asia/Shanghai','WALK',6),(897,20,'outside','2025-11-27 17:00:00.000000','Asia/Shanghai','WALK',6),(898,25,'outside','2025-11-26 08:00:00.000000','Asia/Shanghai','WALK',6),(899,30,'outside','2025-11-26 17:00:00.000000','Asia/Shanghai','WALK',6),(900,20,'outside','2025-11-25 07:00:00.000000','Asia/Shanghai','WALK',6),(901,25,'outside','2025-11-25 12:00:00.000000','Asia/Shanghai','WALK',6);
/*!40000 ALTER TABLE `exercises` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `health_coaches`
--

DROP TABLE IF EXISTS `health_coaches`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `health_coaches` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `password_hash` varchar(100) NOT NULL,
  `username` varchar(32) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_health_coaches_username` (`username`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `health_coaches`
--

LOCK TABLES `health_coaches` WRITE;
/*!40000 ALTER TABLE `health_coaches` DISABLE KEYS */;
INSERT INTO `health_coaches` VALUES (1,'$2a$10$bC/cNXX9uNaLndUbu3pps.8ACCe2SHyniYzlL8fQRma1ScUJPuwdK','123');
/*!40000 ALTER TABLE `health_coaches` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `users`
--

DROP TABLE IF EXISTS `users`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `users` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `password_hash` varchar(100) NOT NULL,
  `username` varchar(32) NOT NULL,
  `uuid` varchar(36) NOT NULL,
  `points` INT NOT NULL,
  `address` VARCHAR(255) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_users_username` (`username`),
  UNIQUE KEY `uk_users_uuid` (`uuid`)
) ENGINE=InnoDB AUTO_INCREMENT=25 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `users`
--

LOCK TABLES `users` WRITE;
/*!40000 ALTER TABLE `users` DISABLE KEYS */;
-- Updated with random starting points (1000-2000 range) and test addresses
INSERT INTO `users` (id, password_hash, username, uuid, points, address) VALUES
(4,'$2b$10$b0/MG/FFeZszLKqxBKrWkec6QtqKxor9U5ofWkVn88Wy2F9ftFRDG','john_doe','1292732a-c0d8-11f0-9ddf-b6be97b7cfe8', 1450, '123 Main St, New York, NY 10001'),
(5,'$2b$10$b0/MG/FFeZszLKqxBKrWkec6QtqKxor9U5ofWkVn88Wy2F9ftFRDG','sarah_smith','12928356-c0d8-11f0-9ddf-b6be97b7cfe8', 1820, '456 Oak Ave, Los Angeles, CA 90028'),
(6,'$2b$10$b0/MG/FFeZszLKqxBKrWkec6QtqKxor9U5ofWkVn88Wy2F9ftFRDG','mike_johnson','12928630-c0d8-11f0-9ddf-b6be97b7cfe8', 1135, '789 Pine Rd, Shanghai, China 200001'),
(7,'$2b$10$b0/MG/FFeZszLKqxBKrWkec6QtqKxor9U5ofWkVn88Wy2F9ftFRDG','emily_davis','12928716-c0d8-11f0-9ddf-b6be97b7cfe8', 1670, '321 Elm St, London, UK SW1A 1AA'),
(8,'$2b$10$b0/MG/FFeZszLKqxBKrWkec6QtqKxor9U5ofWkVn88Wy2F9ftFRDG','david_wilson','129287a2-c0d8-11f0-9ddf-b6be97b7cfe8', 1290, '654 Maple Dr, Paris, France 75001'),
(9,'$2b$10$b0/MG/FFeZszLKqxBKrWkec6QtqKxor9U5ofWkVn88Wy2F9ftFRDG','lisa_brown','1292882e-c0d8-11f0-9ddf-b6be97b7cfe8', 1950, '987 Cedar Ln, Tokyo, Japan 100-0001'),
(10,'$2b$10$b0/MG/FFeZszLKqxBKrWkec6QtqKxor9U5ofWkVn88Wy2F9ftFRDG','james_taylor','129288a6-c0d8-11f0-9ddf-b6be97b7cfe8', 1580, '147 Birch Blvd, Sydney, Australia 2000'),
(11,'$2b$10$b0/MG/FFeZszLKqxBKrWkec6QtqKxor9U5ofWkVn88Wy2F9ftFRDG','amanda_white','12928914-c0d8-11f0-9ddf-b6be97b7cfe8', 1220, '258 Spruce Way, Paris, France 75008'),
(12,'$2b$10$b0/MG/FFeZszLKqxBKrWkec6QtqKxor9U5ofWkVn88Wy2F9ftFRDG','chris_martin','1292898c-c0d8-11f0-9ddf-b6be97b7cfe8', 1740, '369 Willow Ct, Denver, CO 80202'),
(13,'$2b$10$b0/MG/FFeZszLKqxBKrWkec6QtqKxor9U5ofWkVn88Wy2F9ftFRDG','jennifer_lee','12928a04-c0d8-11f0-9ddf-b6be97b7cfe8', 1390, '741 Ash Pkwy, Hong Kong, China'),
(24,'$2b$10$b0/MG/FFeZszLKqxBKrWkec6QtqKxor9U5ofWkVn88Wy2F9ftFRDG','allen','f3c80772-c0da-11f0-9ddf-b6be97b7cfe8', 1850, '852 Redwood St, New York, NY 10002');

INSERT INTO users (id, password_hash, username, uuid, points, address) VALUES
(1, '$2b$10$b0/MG/FFeZszLKqxBKrWkec6QtqKxor9U5ofWkVn88Wy2F9ftFRDG', 't1', UUID(), 1120, '111 Test Ave, Chicago, IL 60601'),
(2, '$2b$10$b0/MG/FFeZszLKqxBKrWkec6QtqKxor9U5ofWkVn88Wy2F9ftFRDG', 't2', UUID(), 1560, '222 Test Blvd, Boston, MA 02101'),
(29, '$2b$10$b0/MG/FFeZszLKqxBKrWkec6QtqKxor9U5ofWkVn88Wy2F9ftFRDG', 't3', UUID(), 1480, '333 Test Ln, Seattle, WA 98101');

/*!40000 ALTER TABLE `users` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `shop_items`
--

DROP TABLE IF EXISTS `shop_items`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `shop_items` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `name` varchar(100) NOT NULL,
  `description` varchar(500) DEFAULT NULL,
  `points_required` int NOT NULL,
  `image_url` varchar(255) DEFAULT NULL,
  `stock` int NOT NULL DEFAULT 0,
  `is_active` BOOLEAN NOT NULL DEFAULT TRUE,
  PRIMARY KEY (`id`),
  CONSTRAINT `check_points_positive` CHECK (`points_required` >= 0)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `shop_items`
--

LOCK TABLES `shop_items` WRITE;
/*!40000 ALTER TABLE `shop_items` DISABLE KEYS */;
-- Comprehensive fitness shop items (English)
INSERT INTO `shop_items` (`name`, `description`, `points_required`, `image_url`, `stock`) VALUES
-- Protection Gear Series
('Professional Wrist Wraps', 'Compression wrist wraps, elastic and breathable, suitable for weightlifting, provides wrist support', 280, 'https://images.unsplash.com/photo-1611672585731-fa10603fb9e0?w=400&h=300&fit=crop', 150),
('Weightlifting Belt', 'Wide and thick lifting belt, protects lower back, essential for squats and deadlifts, adjustable size', 350, 'https://images.unsplash.com/photo-1599058917212-d750089bc07e?w=400&h=300&fit=crop', 80),
('Knee Sleeves', 'Sports knee sleeves pair, for basketball running fitness, anti-slip breathable compression protection', 300, 'https://images.unsplash.com/photo-1606889464198-fcb18894cf50?w=400&h=300&fit=crop', 100),
('Elbow Support Sleeves', 'Weightlifting elbow sleeves, elastic compression, protects elbow joints, comes in pairs', 290, 'https://images.unsplash.com/photo-1599058918394-8dc3f8b6e04e?w=400&h=300&fit=crop', 90),

-- Fitness Equipment Series
('Resistance Bands Set', '5-piece fitness resistance bands, different resistance levels, includes door anchor and storage bag', 320, 'https://images.unsplash.com/photo-1598289431512-b97b0917affc?w=400&h=300&fit=crop', 70),
('Extra Thick Yoga Mat', '10mm thick NBR yoga mat, eco-friendly material, 185cm extra long, includes carrying strap', 340, 'https://images.unsplash.com/photo-1601925260368-ae2f83cf8b7f?w=400&h=300&fit=crop', 85),
('Professional Jump Rope', 'Adjustable bearing jump rope, anti-slip handle, counting function, suitable for fat loss training', 260, 'https://images.unsplash.com/photo-1598970434795-0c54fe7c0648?w=400&h=300&fit=crop', 120),
('Home Fitness Dumbbells', 'Eco-friendly coated dumbbells, 2-piece set, 3kg/5kg/8kg options, anti-slip and drop-resistant', 380, 'https://images.unsplash.com/photo-1571902943202-507ec2618e8f?w=400&h=300&fit=crop', 60),

-- Sports Accessories Series
('Smart Fitness Tracker', 'Heart rate monitoring sleep tracking, 50m waterproof, 7-day battery life, rich sports modes', 400, 'https://images.unsplash.com/photo-1575311373937-040b8e1fd5b6?w=400&h=300&fit=crop', 50),
('Premium Sports Water Bottle', 'Stainless steel insulated sports bottle, 750ml large capacity, 12-hour insulation, leak-proof design', 300, 'https://images.unsplash.com/photo-1602143407151-7111542de6e8?w=400&h=300&fit=crop', 100),
('Large Capacity Sports Backpack', '30L gym bag, wet and dry separation, independent shoe compartment, USB charging port, waterproof fabric', 330, 'https://images.unsplash.com/photo-1553062407-98eeb64c6a62?w=400&h=300&fit=crop', 65),
('Quick-Dry Sports Towel', 'Microfiber sports towel 2-pack, quick-dry antibacterial, soft and absorbent, includes storage bag', 270, 'https://images.unsplash.com/photo-1582735689369-4fe89db7114c?w=400&h=300&fit=crop', 130),

-- Nutrition Supplements Series
('Whey Protein Powder', 'High-quality isolated whey protein, vanilla flavor 2lbs, essential for muscle building, easily soluble', 390, 'https://images.unsplash.com/photo-1579722820308-d74e571900a9?w=400&h=300&fit=crop', 45),
('BCAA Amino Acids', 'Pre/during/post workout supplement, reduces muscle breakdown, speeds recovery, lemon flavor', 360, 'https://images.unsplash.com/photo-1593095948071-474c5cc2989d?w=400&h=300&fit=crop', 55),
('Creatine Powder Supplement', 'Pure creatine monohydrate, 300g pack, enhances explosive power and endurance', 310, 'https://images.unsplash.com/photo-1584464491033-06628f3a6b7b?w=400&h=300&fit=crop', 70),

-- Sports Apparel Series
('Professional Fitness Gloves', 'Half-finger anti-slip fitness gloves, breathable wrist protection, suitable for weightlifting pull-ups', 285, 'https://images.unsplash.com/photo-1598289431512-b97b0917affc?w=400&h=300&fit=crop', 95),
('Compression Athletic Shirt', 'Quick-dry breathable compression top, tight fit design, reduces muscle vibration, enhances performance', 340, 'https://images.unsplash.com/photo-1556821840-3a63f95609a7?w=400&h=300&fit=crop', 75),
('Running Phone Armband', 'Waterproof reflective running armband, fits phones under 6.5 inches, touchscreen compatible', 280, 'https://images.unsplash.com/photo-1606107557195-0e29a4b5b4aa?w=400&h=300&fit=crop', 110),
('Professional Sports Socks', 'Mid-calf sports socks 3-pack, towel bottom cushioning, antibacterial odor-resistant, good elasticity', 250, 'https://images.unsplash.com/photo-1586350977771-b3b0abd50c82?w=400&h=300&fit=crop', 140),

-- Recovery Training Series
('Foam Roller for Muscle Release', '45cm high-density foam roller, muscle relaxation massage, includes usage tutorial', 295, 'https://images.unsplash.com/photo-1599058917212-d750089bc07e?w=400&h=300&fit=crop', 80);
/*!40000 ALTER TABLE `shop_items` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `cart_items`
--

DROP TABLE IF EXISTS `cart_items`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `cart_items` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `user_id` bigint NOT NULL,
  `shop_item_id` bigint NOT NULL,
  `quantity` int NOT NULL DEFAULT 1,
  PRIMARY KEY (`id`),
  KEY `idx_cart_user_item` (`user_id`,`shop_item_id`),
  FOREIGN KEY (`user_id`) REFERENCES `users`(`id`),
  FOREIGN KEY (`shop_item_id`) REFERENCES `shop_items`(`id`)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `cart_items`
--

LOCK TABLES `cart_items` WRITE;
/*!40000 ALTER TABLE `cart_items` DISABLE KEYS */;
-- Initially empty - users will add items to their cart
/*!40000 ALTER TABLE `cart_items` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `orders`
--

DROP TABLE IF EXISTS `orders`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `orders` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `user_id` bigint NOT NULL,
  `total_points` int NOT NULL,
  `shipping_address` varchar(255) DEFAULT NULL,
  `status` varchar(20) NOT NULL DEFAULT 'PENDING',
  `created_at` datetime(6) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `idx_orders_user_time` (`user_id`,`created_at`),
  FOREIGN KEY (`user_id`) REFERENCES `users`(`id`) on Delete CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `orders`
--

LOCK TABLES `orders` WRITE;
/*!40000 ALTER TABLE `orders` DISABLE KEYS */;
INSERT INTO `orders` VALUES
(1,4,650,'123 Main St, New York, NY 10001','DELIVERED','2025-11-10 14:30:00.000000'),
(2,5,300,'456 Oak Ave, Los Angeles, CA 90028','SHIPPED','2025-11-12 10:15:00.000000'),
(3,7,450,'321 Elm St, London, UK SW1A 1AA','DELIVERED','2025-11-08 16:45:00.000000'),
(4,9,800,'987 Cedar Ln, Tokyo, Japan 100-0001','PROCESSING','2025-11-15 09:20:00.000000'),
(5,24,500,'852 Redwood St, New York, NY 10002','DELIVERED','2025-11-05 11:00:00.000000'),
(6,4,200,'123 Main St, New York, NY 10001','PENDING','2025-11-16 13:45:00.000000'),
(7,10,750,'147 Birch Blvd, Sydney, Australia 2000','DELIVERED','2025-11-09 08:30:00.000000'),
(8,12,350,'369 Willow Ct, Denver, CO 80202','SHIPPED','2025-11-14 15:10:00.000000'),
-- Additional test orders for allen user (user_id = 24)
(9,24,600,'852 Redwood St, New York, NY 10002','PENDING','2025-11-20 10:30:00.000000'),
(10,24,740,'852 Redwood St, New York, NY 10002','PROCESSING','2025-11-18 14:15:00.000000'),
(11,24,850,'852 Redwood St, New York, NY 10002','SHIPPED','2025-11-15 09:45:00.000000'),
(12,24,1030,'852 Redwood St, New York, NY 10002','DELIVERED','2025-11-10 16:20:00.000000'),
(13,24,570,'852 Redwood St, New York, NY 10002','CANCELLED','2025-11-08 11:00:00.000000'),
(14,24,780,'852 Redwood St, New York, NY 10002','PENDING','2025-11-21 08:00:00.000000'),
(15,24,690,'852 Redwood St, New York, NY 10002','DELIVERED','2025-11-05 13:30:00.000000'),
(16,24,885,'852 Redwood St, New York, NY 10002','PROCESSING','2025-11-19 15:45:00.000000');
/*!40000 ALTER TABLE `orders` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `order_items`
--

DROP TABLE IF EXISTS `order_items`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `order_items` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `order_id` bigint NOT NULL,
  `shop_item_id` bigint NOT NULL,
  `shop_item_name` varchar(100) NOT NULL,
  `quantity` int NOT NULL,
  `points_per_item` int NOT NULL,
  PRIMARY KEY (`id`),
  KEY `idx_order_items_order` (`order_id`),
  FOREIGN KEY (`order_id`) REFERENCES `orders`(`id`) on delete CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `order_items`
--

LOCK TABLES `order_items` WRITE;
/*!40000 ALTER TABLE `order_items` DISABLE KEYS */;
INSERT INTO `order_items` VALUES
(1,1,1,'Fitness Tracker Watch',1,500),
(2,1,2,'Yoga Mat',1,150),
(3,2,5,'Gym Bag',1,300),
(4,3,2,'Yoga Mat',3,150),
(5,4,1,'Fitness Tracker Watch',1,500),
(6,4,5,'Gym Bag',1,300),
(7,5,1,'Fitness Tracker Watch',1,500),
(8,6,3,'Resistance Bands Set',1,200),
(9,7,1,'Fitness Tracker Watch',1,500),
(10,7,4,'Water Bottle',1,100),
(11,7,2,'Yoga Mat',1,150),
(12,8,3,'Resistance Bands Set',1,200),
(13,8,2,'Yoga Mat',1,150),
-- Order items for allen's test orders
(14,9,1,'Professional Wrist Wraps',1,280),
(15,9,4,'Elbow Support Sleeves',1,290),
(16,9,19,'Professional Sports Socks',1,250),
(17,10,6,'Extra Thick Yoga Mat',1,340),
(18,10,9,'Smart Fitness Tracker',1,400),
(19,11,2,'Weightlifting Belt',1,350),
(20,11,5,'Resistance Bands Set',1,320),
(21,11,12,'Quick-Dry Sports Towel',1,270),
(22,12,8,'Home Fitness Dumbbells',1,380),
(23,12,11,'Large Capacity Sports Backpack',1,330),
(24,12,5,'Resistance Bands Set',1,320),
(25,13,7,'Professional Jump Rope',1,260),
(26,13,15,'Creatine Powder Supplement',1,310),
(27,14,13,'Whey Protein Powder',1,390),
(28,14,14,'BCAA Amino Acids',1,360),
(29,14,18,'Running Phone Armband',1,280),
(30,15,17,'Compression Athletic Shirt',1,340),
(31,15,2,'Weightlifting Belt',1,350),
(32,16,3,'Knee Sleeves',2,300),
(33,16,16,'Professional Fitness Gloves',1,285);
/*!40000 ALTER TABLE `order_items` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `item_likes`
--

DROP TABLE IF EXISTS `item_likes`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `item_likes` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `shop_item_id` bigint NOT NULL,
  `user_id` bigint NOT NULL,
  `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `fk_item_likes_shop_item` (`shop_item_id`),
  KEY `fk_item_likes_user` (`user_id`),
  UNIQUE KEY `unique_user_item_like` (`user_id`,`shop_item_id`),
  CONSTRAINT `fk_item_likes_shop_item` FOREIGN KEY (`shop_item_id`) REFERENCES `shop_items` (`id`) ON DELETE CASCADE,
  CONSTRAINT `fk_item_likes_user` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `item_likes`
--

LOCK TABLES `item_likes` WRITE;
/*!40000 ALTER TABLE `item_likes` DISABLE KEYS */;
INSERT INTO `item_likes` (`shop_item_id`, `user_id`) VALUES
(1, 29),
(2, 29),
(3, 29),
(1, 1),
(1, 2),
(2, 1);
/*!40000 ALTER TABLE `item_likes` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `item_reviews`
--

DROP TABLE IF EXISTS `item_reviews`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `item_reviews` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `shop_item_id` bigint NOT NULL,
  `user_id` bigint NOT NULL,
  `user_name` varchar(32) NOT NULL,
  `review_text` TEXT NOT NULL,
  `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `fk_item_reviews_shop_item` (`shop_item_id`),
  KEY `fk_item_reviews_user` (`user_id`),
  CONSTRAINT `fk_item_reviews_shop_item` FOREIGN KEY (`shop_item_id`) REFERENCES `shop_items` (`id`) ON DELETE CASCADE,
  CONSTRAINT `fk_item_reviews_user` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `item_reviews`
--

LOCK TABLES `item_reviews` WRITE;
/*!40000 ALTER TABLE `item_reviews` DISABLE KEYS */;
INSERT INTO `item_reviews` (`shop_item_id`, `user_id`, `user_name`, `review_text`) VALUES
(1, 29, 'User29', 'Great product! Very comfortable and durable.'),
(1, 1, 'User1', 'Perfect for heavy lifting, highly recommend!'),
(2, 29, 'User29', 'Excellent support for my lower back during squats.'),
(2, 2, 'User2', 'Best weightlifting belt I have ever used!'),
(3, 29, 'User29', 'These knee sleeves are amazing for running and basketball.'),
(1, 2, 'User2', 'Good quality, worth the points!');
/*!40000 ALTER TABLE `item_reviews` ENABLE KEYS */;
UNLOCK TABLES;

/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2025-11-14 10:03:50
