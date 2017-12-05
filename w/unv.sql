-- MySQL dump 10.13  Distrib 5.6.23, for osx10.8 (x86_64)
--
-- Host: localhost    Database: unv
-- ------------------------------------------------------
-- Server version	5.6.23

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `acc`
--

DROP TABLE IF EXISTS `acc`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `acc` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `ac` varchar(50) DEFAULT NULL,
  `nm` varchar(100) DEFAULT NULL,
  `ad` varchar(200) DEFAULT NULL,
  `st` tinyint(4) DEFAULT NULL,
  `se` datetime DEFAULT NULL,
  `sx` datetime DEFAULT NULL,
  `xd` datetime DEFAULT NULL,
  `xy` varchar(50) DEFAULT NULL,
  `xa` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `accx01` (`ac`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `acc`
--

LOCK TABLES `acc` WRITE;
/*!40000 ALTER TABLE `acc` DISABLE KEYS */;
INSERT INTO `acc` VALUES (1,'A101','JOHN CITIZEN',NULL,1,'2016-01-01 00:00:00',NULL,'2016-01-01 00:00:00','try','@'),(2,'A102','MARY CITIZEN','1 JALAN LIKU 40000 SHAH ALAM',1,'2016-01-01 00:00:00',NULL,'2016-01-01 00:00:00','try','@'),(3,'A103','PAUL CITIZEN',NULL,1,'2016-01-01 00:00:00',NULL,'2016-01-01 00:00:00','try','@'),(4,'A104','JANE CITIZEN',NULL,1,'2016-01-01 00:00:00',NULL,'2016-01-01 00:00:00','try','@');
/*!40000 ALTER TABLE `acc` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `adoc`
--

DROP TABLE IF EXISTS `adoc`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `adoc` (
  `did` bigint(20) NOT NULL AUTO_INCREMENT,
  `bat` varchar(50) DEFAULT NULL,
  `dno` varchar(50) DEFAULT NULL,
  `ddt` datetime DEFAULT NULL,
  `dtp` varchar(5) DEFAULT NULL,
  `dmd` varchar(5) DEFAULT NULL,
  `ddr` decimal(12,3) DEFAULT NULL,
  `dcr` decimal(12,3) DEFAULT NULL,
  `acc` varchar(50) DEFAULT NULL,
  `rf1` varchar(50) DEFAULT NULL,
  `rf2` varchar(50) DEFAULT NULL,
  `rf3` varchar(50) DEFAULT NULL,
  `nrr` varchar(255) DEFAULT NULL,
  `fl0` tinyint(4) DEFAULT NULL,
  `fl1` tinyint(4) DEFAULT NULL,
  `fl2` tinyint(4) DEFAULT NULL,
  `fl3` tinyint(4) DEFAULT NULL,
  `f0d` datetime DEFAULT NULL,
  `f0y` varchar(50) DEFAULT NULL,
  `f0a` varchar(50) DEFAULT NULL,
  `f1d` datetime DEFAULT NULL,
  `f1y` varchar(50) DEFAULT NULL,
  `f1a` varchar(50) DEFAULT NULL,
  `xdt` datetime DEFAULT NULL,
  `xby` varchar(50) DEFAULT NULL,
  `xat` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`did`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `adoc`
--

LOCK TABLES `adoc` WRITE;
/*!40000 ALTER TABLE `adoc` DISABLE KEYS */;
/*!40000 ALTER TABLE `adoc` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `aglt`
--

DROP TABLE IF EXISTS `aglt`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `aglt` (
  `tid` bigint(20) NOT NULL AUTO_INCREMENT,
  `txd` datetime DEFAULT NULL,
  `txp` varchar(5) DEFAULT NULL,
  `tpd` varchar(20) DEFAULT NULL,
  `acc` varchar(50) DEFAULT NULL,
  `rf1` varchar(50) DEFAULT NULL,
  `rf2` varchar(50) DEFAULT NULL,
  `rf3` varchar(50) DEFAULT NULL,
  `nrr` varchar(255) DEFAULT NULL,
  `tdr` decimal(12,3) DEFAULT NULL,
  `tcr` decimal(12,3) DEFAULT NULL,
  `xdr` decimal(12,3) DEFAULT NULL,
  `xcr` decimal(12,3) DEFAULT NULL,
  `xdt` datetime DEFAULT NULL,
  `xby` varchar(50) DEFAULT NULL,
  `xat` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`tid`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `aglt`
--

LOCK TABLES `aglt` WRITE;
/*!40000 ALTER TABLE `aglt` DISABLE KEYS */;
/*!40000 ALTER TABLE `aglt` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `cacc`
--

DROP TABLE IF EXISTS `cacc`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `cacc` (
  `tid` bigint(20) NOT NULL AUTO_INCREMENT,
  `acc` varchar(50) DEFAULT NULL,
  `nme` varchar(100) DEFAULT NULL,
  `adr` varchar(255) DEFAULT NULL,
  `zip` varchar(20) DEFAULT NULL,
  `eml` varchar(100) DEFAULT NULL,
  `idt` char(3) DEFAULT NULL,
  `idn` varchar(100) DEFAULT NULL,
  `sta` tinyint(4) DEFAULT NULL,
  `sef` datetime DEFAULT NULL,
  `sxp` datetime DEFAULT NULL,
  `xdt` datetime DEFAULT NULL,
  `xby` varchar(50) DEFAULT NULL,
  `xat` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`tid`),
  KEY `cacc_x0` (`acc`)
) ENGINE=InnoDB AUTO_INCREMENT=19 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `cacc`
--

LOCK TABLES `cacc` WRITE;
/*!40000 ALTER TABLE `cacc` DISABLE KEYS */;
INSERT INTO `cacc` VALUES (1,'A101','JOHN CITIZEN',NULL,NULL,NULL,NULL,NULL,1,'2016-01-01 00:00:00',NULL,'2016-01-01 00:00:00','try','@'),(2,'A102','MARY CITIZEN','1 JALAN LIKU 40000 SHAH ALAM',NULL,NULL,NULL,NULL,1,'2016-01-01 00:00:00',NULL,'2016-01-01 00:00:00','try','@'),(3,'A103','PAUL CITIZEN',NULL,NULL,NULL,NULL,NULL,1,'2016-01-01 00:00:00',NULL,'2016-01-01 00:00:00','try','@'),(4,'A104','ABC SDN BHD',NULL,NULL,NULL,NULL,NULL,1,'2016-01-01 00:00:00',NULL,'2016-01-01 00:00:00','try','@'),(18,'0000000014','FARA HASAN','NO 18 MEDAN NUSANTARAN, JALAN SRI HARTAMAS 1','50480',NULL,NULL,'831201105018',1,'2016-09-08 11:45:33',NULL,'2016-09-08 11:45:33','test','@');
/*!40000 ALTER TABLE `cacc` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `opt`
--

DROP TABLE IF EXISTS `opt`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `opt` (
  `sn` varchar(20) DEFAULT NULL,
  `st` tinyint(4) DEFAULT NULL,
  `se` datetime DEFAULT NULL,
  `sx` datetime DEFAULT NULL,
  `xd` datetime DEFAULT NULL,
  `xy` varchar(50) DEFAULT NULL,
  `xa` varchar(50) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `opt`
--

LOCK TABLES `opt` WRITE;
/*!40000 ALTER TABLE `opt` DISABLE KEYS */;
/*!40000 ALTER TABLE `opt` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `rpln`
--

DROP TABLE IF EXISTS `rpln`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `rpln` (
  `tid` bigint(20) NOT NULL AUTO_INCREMENT,
  `pln` varchar(50) DEFAULT NULL,
  `des` varchar(100) DEFAULT NULL,
  `sta` tinyint(4) DEFAULT NULL,
  `sef` datetime DEFAULT NULL,
  `sxp` datetime DEFAULT NULL,
  `xdt` datetime DEFAULT NULL,
  `xby` varchar(50) DEFAULT NULL,
  `xat` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`tid`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `rpln`
--

LOCK TABLES `rpln` WRITE;
/*!40000 ALTER TABLE `rpln` DISABLE KEYS */;
INSERT INTO `rpln` VALUES (1,'std01','Standard Plan',1,'2016-09-01 00:00:00',NULL,'2016-09-06 06:10:36','sys','@'),(2,'vip01','VIP Plan',1,'2016-09-01 00:00:00',NULL,'2016-09-06 06:10:36','sys','@');
/*!40000 ALTER TABLE `rpln` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `rusg`
--

DROP TABLE IF EXISTS `rusg`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `rusg` (
  `uid` varchar(20) DEFAULT NULL,
  `aid` varchar(20) DEFAULT NULL,
  `kls` varchar(20) DEFAULT NULL,
  `des` varchar(100) DEFAULT NULL,
  `zon` int(11) DEFAULT NULL,
  `zsc` varchar(255) DEFAULT NULL,
  `pri` tinyint(4) DEFAULT NULL,
  `unt` char(1) DEFAULT NULL,
  `rte` decimal(10,3) DEFAULT NULL,
  `rsc` varchar(255) DEFAULT NULL,
  `fcy` char(1) DEFAULT NULL,
  `fcg` decimal(12,3) DEFAULT NULL,
  `fut` decimal(12,3) DEFAULT NULL,
  `fsv` varchar(100) DEFAULT NULL,
  `hsc` varchar(255) DEFAULT NULL,
  `rll` char(1) DEFAULT NULL,
  `rmx` decimal(10,3) DEFAULT NULL,
  `xdt` datetime DEFAULT NULL,
  `xby` varchar(50) DEFAULT NULL,
  `xat` varchar(50) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `rusg`
--

LOCK TABLES `rusg` WRITE;
/*!40000 ALTER TABLE `rusg` DISABLE KEYS */;
/*!40000 ALTER TABLE `rusg` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sno`
--

DROP TABLE IF EXISTS `sno`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `sno` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `sn` varchar(20) DEFAULT NULL,
  `ac` varchar(50) DEFAULT NULL,
  `si` varchar(20) DEFAULT NULL,
  `st` tinyint(4) DEFAULT NULL,
  `se` datetime DEFAULT NULL,
  `sx` datetime DEFAULT NULL,
  `xd` datetime DEFAULT NULL,
  `xy` varchar(50) DEFAULT NULL,
  `xa` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=21 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sno`
--

LOCK TABLES `sno` WRITE;
/*!40000 ALTER TABLE `sno` DISABLE KEYS */;
INSERT INTO `sno` VALUES (11,'0101111189','A101','502151123456891',1,'2016-01-01 00:00:00',NULL,'2016-01-01 00:00:00','try','@'),(12,'0101111188','A102','502151123456893',1,'2016-01-01 00:00:00',NULL,'2016-01-01 00:00:00','try','@'),(13,'0101111187','A103','502151123456894',1,'2016-01-01 00:00:00',NULL,'2016-01-01 00:00:00','try','@'),(14,'0101111186','A104','502151123456895',1,'2016-01-01 00:00:00',NULL,'2016-01-01 00:00:00','try','@'),(15,'0101111185','A101','502151123456896',1,'2016-01-01 00:00:00',NULL,'2016-01-01 00:00:00','try','@'),(16,'0101111184','A101','502151123456897',1,'2016-01-01 00:00:00',NULL,'2016-01-01 00:00:00','try','@'),(17,'0101111183','A101','502151123456898',1,'2016-01-01 00:00:00',NULL,'2016-01-01 00:00:00','try','@'),(18,'0101111182','A102','502151123456899',1,'2016-01-01 00:00:00',NULL,'2016-01-01 00:00:00','try','@'),(19,'0101111181','A102','502151123456890',1,'2016-01-01 00:00:00',NULL,'2016-01-01 00:00:00','try','@'),(20,'0101111180','A104','502151123456892',1,'2016-01-01 00:00:00',NULL,'2016-01-01 00:00:00','try','@');
/*!40000 ALTER TABLE `sno` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `spln`
--

DROP TABLE IF EXISTS `spln`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `spln` (
  `tid` bigint(20) NOT NULL AUTO_INCREMENT,
  `sno` varchar(20) DEFAULT NULL,
  `acc` varchar(50) DEFAULT NULL,
  `pln` varchar(50) DEFAULT NULL,
  `sta` tinyint(4) DEFAULT NULL,
  `sef` datetime DEFAULT NULL,
  `sxp` datetime DEFAULT NULL,
  `xdt` datetime DEFAULT NULL,
  `xby` varchar(50) DEFAULT NULL,
  `xat` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`tid`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `spln`
--

LOCK TABLES `spln` WRITE;
/*!40000 ALTER TABLE `spln` DISABLE KEYS */;
INSERT INTO `spln` VALUES (5,'0108008383','0000000014',NULL,1,'2016-09-08 11:45:33',NULL,'2016-09-08 11:45:33','test','@');
/*!40000 ALTER TABLE `spln` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ssno`
--

DROP TABLE IF EXISTS `ssno`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ssno` (
  `tid` bigint(20) NOT NULL AUTO_INCREMENT,
  `sno` varchar(20) DEFAULT NULL,
  `acc` varchar(50) DEFAULT NULL,
  `sim` varchar(20) DEFAULT NULL,
  `sta` tinyint(4) DEFAULT NULL,
  `sef` datetime DEFAULT NULL,
  `sxp` datetime DEFAULT NULL,
  `xdt` datetime DEFAULT NULL,
  `xby` varchar(50) DEFAULT NULL,
  `xat` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`tid`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ssno`
--

LOCK TABLES `ssno` WRITE;
/*!40000 ALTER TABLE `ssno` DISABLE KEYS */;
/*!40000 ALTER TABLE `ssno` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ssub`
--

DROP TABLE IF EXISTS `ssub`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ssub` (
  `tid` bigint(20) NOT NULL AUTO_INCREMENT,
  `sno` varchar(20) DEFAULT NULL,
  `nme` varchar(100) DEFAULT NULL,
  `acc` varchar(50) DEFAULT NULL,
  `sim` varchar(20) DEFAULT NULL,
  `sta` tinyint(4) DEFAULT NULL,
  `sef` datetime DEFAULT NULL,
  `sxp` datetime DEFAULT NULL,
  `xdt` datetime DEFAULT NULL,
  `xby` varchar(50) DEFAULT NULL,
  `xat` varchar(50) DEFAULT NULL,
  `rf1` varchar(50) DEFAULT NULL,
  `rf2` varchar(50) DEFAULT NULL,
  `rf3` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`tid`)
) ENGINE=InnoDB AUTO_INCREMENT=24 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ssub`
--

LOCK TABLES `ssub` WRITE;
/*!40000 ALTER TABLE `ssub` DISABLE KEYS */;
INSERT INTO `ssub` VALUES (1,'0101111189','JOHN CITIZEN','A101','502151123456891',1,'2016-01-01 00:00:00',NULL,'2016-01-01 00:00:00','try','@',NULL,NULL,NULL),(2,'0101111188','MARY CITIZEN','A102','502151123456893',1,'2016-01-01 00:00:00',NULL,'2016-01-01 00:00:00','try','@',NULL,NULL,NULL),(3,'0101111187','PAUL CITIZEN','A103','502151123456894',1,'2016-01-01 00:00:00',NULL,'2016-01-01 00:00:00','try','@',NULL,NULL,NULL),(4,'0101111186','JANE CITIZEN','A104','502151123456895',1,'2016-01-01 00:00:00',NULL,'2016-01-01 00:00:00','try','@',NULL,NULL,NULL),(5,'0101111185','JOHN CITIZEN','A101','502151123456896',1,'2016-01-01 00:00:00',NULL,'2016-01-01 00:00:00','try','@',NULL,NULL,NULL),(6,'0101111184','JOHN CITIZEN','A101','502151123456897',1,'2016-01-01 00:00:00',NULL,'2016-01-01 00:00:00','try','@',NULL,NULL,NULL),(7,'0101111183','JOHN CITIZEN','A101','502151123456898',1,'2016-01-01 00:00:00',NULL,'2016-01-01 00:00:00','try','@',NULL,NULL,NULL),(8,'0101111182','MARY CITIZEN','A102','502151123456899',1,'2016-01-01 00:00:00',NULL,'2016-01-01 00:00:00','try','@',NULL,NULL,NULL),(9,'0101111181','MARY CITIZEN','A102','502151123456890',1,'2016-01-01 00:00:00',NULL,'2016-01-01 00:00:00','try','@',NULL,NULL,NULL),(10,'0101111180','JANE CITIZEN','A104','502151123456892',1,'2016-01-01 00:00:00',NULL,'2016-01-01 00:00:00','try','@',NULL,NULL,NULL),(23,'0108008383','FARA HASAN','0000000014','502195525880031',1,'2016-09-08 11:45:33',NULL,'2016-09-08 11:45:33','test','@',NULL,NULL,NULL);
/*!40000 ALTER TABLE `ssub` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `usg`
--

DROP TABLE IF EXISTS `usg`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `usg` (
  `sn` varchar(20) DEFAULT NULL,
  `kl` tinyint(4) DEFAULT NULL,
  `bn` varchar(20) DEFAULT NULL,
  `vl` varchar(20) DEFAULT NULL,
  `cc` varchar(10) DEFAULT NULL,
  `ci` varchar(20) DEFAULT NULL,
  `op` varchar(20) DEFAULT NULL,
  `tp` varchar(10) DEFAULT NULL,
  `sd` datetime DEFAULT NULL,
  `du` int(11) DEFAULT NULL,
  `va` decimal(10,3) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `usg`
--

LOCK TABLES `usg` WRITE;
/*!40000 ALTER TABLE `usg` DISABLE KEYS */;
INSERT INTO `usg` VALUES ('0101111189',1,'60121112223','ABCD','BER','123456','ABC','VC','2016-04-14 22:22:11',123,1.050),('0101111189',1,'60121112223','ABCD','BER','123456','ABC','VC','2016-04-14 22:32:11',155,1.500);
/*!40000 ALTER TABLE `usg` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `xrf`
--

DROP TABLE IF EXISTS `xrf`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `xrf` (
  `id` int(11) DEFAULT NULL,
  `xr` varchar(20) DEFAULT NULL,
  `va` int(11) DEFAULT NULL,
  `ds` varchar(200) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `xrf`
--

LOCK TABLES `xrf` WRITE;
/*!40000 ALTER TABLE `xrf` DISABLE KEYS */;
/*!40000 ALTER TABLE `xrf` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `z`
--

DROP TABLE IF EXISTS `z`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `z` (
  `a` int(11) DEFAULT NULL,
  `b` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `z`
--

LOCK TABLES `z` WRITE;
/*!40000 ALTER TABLE `z` DISABLE KEYS */;
INSERT INTO `z` VALUES (1,2),(1,NULL),(NULL,NULL);
/*!40000 ALTER TABLE `z` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `zacc`
--

DROP TABLE IF EXISTS `zacc`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `zacc` (
  `i` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  PRIMARY KEY (`i`),
  UNIQUE KEY `i` (`i`)
) ENGINE=InnoDB AUTO_INCREMENT=15 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `zacc`
--

LOCK TABLES `zacc` WRITE;
/*!40000 ALTER TABLE `zacc` DISABLE KEYS */;
INSERT INTO `zacc` VALUES (1),(2),(3),(4),(5),(6),(7),(8),(9),(10),(11),(12),(13),(14);
/*!40000 ALTER TABLE `zacc` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `zz`
--

DROP TABLE IF EXISTS `zz`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `zz` (
  `a` int(11) NOT NULL AUTO_INCREMENT,
  `b` varchar(20) DEFAULT NULL,
  PRIMARY KEY (`a`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `zz`
--

LOCK TABLES `zz` WRITE;
/*!40000 ALTER TABLE `zz` DISABLE KEYS */;
INSERT INTO `zz` VALUES (1,'abc'),(2,'000000001'),(3,'000000002'),(4,'000000004'),(5,'000000005'),(6,'000000006');
/*!40000 ALTER TABLE `zz` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `zzz`
--

DROP TABLE IF EXISTS `zzz`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `zzz` (
  `a` int(11) DEFAULT NULL,
  `d` datetime DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `zzz`
--

LOCK TABLES `zzz` WRITE;
/*!40000 ALTER TABLE `zzz` DISABLE KEYS */;
INSERT INTO `zzz` VALUES (1,'2016-08-31 23:59:59'),(1,'2016-09-07 19:19:38');
/*!40000 ALTER TABLE `zzz` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2016-09-08 15:02:43
