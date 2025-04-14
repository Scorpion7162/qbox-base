-- --------------------------------------------------------
-- Host:                         192.168.0.20
-- Server version:               11.6.2-MariaDB - mariadb.org binary distribution
-- Server OS:                    Win64
-- HeidiSQL Version:             12.10.0.7000
-- --------------------------------------------------------

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET NAMES utf8 */;
/*!50503 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;


-- Dumping database structure for freeserver
CREATE DATABASE IF NOT EXISTS `qbxbase` /*!40100 DEFAULT CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci */;
USE `qbxbase`;

-- Dumping structure for table freeserver.bank_accounts_new
CREATE TABLE IF NOT EXISTS `bank_accounts_new` (
  `id` varchar(50) NOT NULL,
  `amount` int(11) DEFAULT 0,
  `transactions` longtext DEFAULT NULL,
  `auth` longtext DEFAULT NULL,
  `isFrozen` int(11) DEFAULT 0,
  `creator` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Dumping data for table freeserver.bank_accounts_new: ~25 rows (approximately)
INSERT INTO `bank_accounts_new` (`id`, `amount`, `transactions`, `auth`, `isFrozen`, `creator`) VALUES
	('ambulance', 0, '[]', '[]', 0, NULL),
	('ballas', 0, '[]', '[]', 0, NULL),
	('bcso', 0, '[]', '[]', 0, NULL),
	('bus', 0, '[]', '[]', 0, NULL),
	('cardealer', 0, '[]', '[]', 0, NULL),
	('cartel', 0, '[]', '[]', 0, NULL),
	('families', 0, '[]', '[]', 0, NULL),
	('garbage', 0, '[]', '[]', 0, NULL),
	('hotdog', 0, '[]', '[]', 0, NULL),
	('judge', 0, '[]', '[]', 0, NULL),
	('lawyer', 0, '[]', '[]', 0, NULL),
	('lostmc', 0, '[]', '[]', 0, NULL),
	('mechanic', 0, '[]', '[]', 0, NULL),
	('none', 0, '[]', '[]', 0, NULL),
	('police', 0, '[]', '[]', 0, NULL),
	('realestate', 0, '[]', '[]', 0, NULL),
	('reporter', 0, '[]', '[]', 0, NULL),
	('sasp', 0, '[]', '[]', 0, NULL),
	('taxi', 0, '[]', '[]', 0, NULL),
	('tow', 0, '[]', '[]', 0, NULL),
	('triads', 0, '[]', '[]', 0, NULL),
	('trucker', 0, '[]', '[]', 0, NULL),
	('unemployed', 0, '[]', '[]', 0, NULL),
	('vagos', 0, '[]', '[]', 0, NULL),
	('vineyard', 0, '[]', '[]', 0, NULL);

-- Dumping structure for table freeserver.bans
CREATE TABLE IF NOT EXISTS `bans` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(50) DEFAULT NULL,
  `license` varchar(50) DEFAULT NULL,
  `discord` varchar(50) DEFAULT NULL,
  `ip` varchar(50) DEFAULT NULL,
  `reason` text DEFAULT NULL,
  `expire` int(11) DEFAULT NULL,
  `bannedby` varchar(255) NOT NULL DEFAULT 'LeBanhammer',
  PRIMARY KEY (`id`),
  KEY `license` (`license`),
  KEY `discord` (`discord`),
  KEY `ip` (`ip`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Dumping data for table freeserver.bans: ~0 rows (approximately)

-- Dumping structure for table freeserver.dealers
CREATE TABLE IF NOT EXISTS `dealers` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(50) NOT NULL DEFAULT '0',
  `coords` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL,
  `time` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL,
  `createdby` varchar(50) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Dumping data for table freeserver.dealers: ~0 rows (approximately)

-- Dumping structure for table freeserver.lapraces
CREATE TABLE IF NOT EXISTS `lapraces` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(50) DEFAULT NULL,
  `checkpoints` text DEFAULT NULL,
  `records` text DEFAULT NULL,
  `creator` varchar(50) DEFAULT NULL,
  `distance` int(11) DEFAULT NULL,
  `raceid` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `raceid` (`raceid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Dumping data for table freeserver.lapraces: ~0 rows (approximately)

-- Dumping structure for table freeserver.lation_mining
CREATE TABLE IF NOT EXISTS `lation_mining` (
  `identifier` varchar(255) NOT NULL,
  `name` varchar(255) DEFAULT NULL,
  `level` int(11) NOT NULL DEFAULT 1,
  `exp` int(11) NOT NULL DEFAULT 0,
  `mined` int(11) NOT NULL DEFAULT 0,
  `smelted` int(11) NOT NULL DEFAULT 0,
  `earned` int(11) NOT NULL DEFAULT 0,
  PRIMARY KEY (`identifier`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;

-- Dumping data for table freeserver.lation_mining: ~0 rows (approximately)

-- Dumping structure for table freeserver.management_outfits
CREATE TABLE IF NOT EXISTS `management_outfits` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `job_name` varchar(50) NOT NULL,
  `type` varchar(50) NOT NULL,
  `minrank` int(11) NOT NULL DEFAULT 0,
  `name` varchar(50) NOT NULL DEFAULT 'Cool Outfit',
  `gender` varchar(50) NOT NULL DEFAULT 'male',
  `model` varchar(50) DEFAULT NULL,
  `props` text DEFAULT NULL,
  `components` text DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=26 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Dumping data for table freeserver.management_outfits: ~0 rows (approximately)

-- Dumping structure for table freeserver.mdt_announcements
CREATE TABLE IF NOT EXISTS `mdt_announcements` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `creator` varchar(50) NOT NULL,
  `contents` text NOT NULL,
  `createdAt` datetime NOT NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`id`),
  KEY `FK_mdt_announcements_players` (`creator`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Dumping data for table freeserver.mdt_announcements: ~0 rows (approximately)

-- Dumping structure for table freeserver.mdt_bolos
CREATE TABLE IF NOT EXISTS `mdt_bolos` (
  `plate` varchar(50) NOT NULL,
  `reason` text NOT NULL,
  `expiresAt` datetime NOT NULL,
  UNIQUE KEY `plate` (`plate`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Dumping data for table freeserver.mdt_bolos: ~0 rows (approximately)

-- Dumping structure for table freeserver.mdt_incidents
CREATE TABLE IF NOT EXISTS `mdt_incidents` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `title` varchar(50) NOT NULL,
  `description` text DEFAULT NULL,
  `author` varchar(50) DEFAULT NULL,
  `date` datetime DEFAULT current_timestamp(),
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Dumping data for table freeserver.mdt_incidents: ~0 rows (approximately)

-- Dumping structure for table freeserver.mdt_incidents_charges
CREATE TABLE IF NOT EXISTS `mdt_incidents_charges` (
  `incidentid` int(10) unsigned NOT NULL,
  `citizenid` varchar(50) NOT NULL,
  `charge` varchar(100) DEFAULT NULL,
  `type` enum('misdemeanor','felony','infraction') NOT NULL,
  `count` int(10) unsigned NOT NULL DEFAULT 1,
  `time` int(10) unsigned DEFAULT NULL,
  `fine` int(10) unsigned DEFAULT NULL,
  `points` int(10) unsigned DEFAULT NULL,
  KEY `FK_mdt_incidents_charges_mdt_incidents_criminals` (`incidentid`),
  KEY `FK_mdt_incidents_charges_mdt_incidents_criminals_2` (`citizenid`),
  KEY `FK_mdt_incidents_charges_mdt_offenses` (`charge`),
  CONSTRAINT `FK_mdt_incidents_charges_mdt_incidents_criminals_2` FOREIGN KEY (`citizenid`) REFERENCES `mdt_incidents_criminals` (`citizenid`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `FK_mdt_incidents_charges_mdt_offenses` FOREIGN KEY (`charge`) REFERENCES `mdt_offenses` (`label`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Dumping data for table freeserver.mdt_incidents_charges: ~0 rows (approximately)

-- Dumping structure for table freeserver.mdt_incidents_criminals
CREATE TABLE IF NOT EXISTS `mdt_incidents_criminals` (
  `incidentid` int(10) unsigned NOT NULL,
  `citizenid` varchar(50) NOT NULL,
  `reduction` tinyint(3) unsigned DEFAULT NULL,
  `warrantExpiry` date DEFAULT NULL,
  `processed` tinyint(4) DEFAULT NULL,
  `pleadedGuilty` tinyint(4) DEFAULT NULL,
  KEY `incidentid` (`incidentid`),
  KEY `FK_mdt_incidents_incidents_players` (`citizenid`),
  CONSTRAINT `mdt_incidents_criminals_ibfk_2` FOREIGN KEY (`incidentid`) REFERENCES `mdt_incidents` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Dumping data for table freeserver.mdt_incidents_criminals: ~0 rows (approximately)

-- Dumping structure for table freeserver.mdt_incidents_evidence
CREATE TABLE IF NOT EXISTS `mdt_incidents_evidence` (
  `incidentid` int(10) unsigned NOT NULL,
  `label` varchar(50) NOT NULL DEFAULT '',
  `image` varchar(90) NOT NULL DEFAULT '',
  KEY `incidentid` (`incidentid`),
  CONSTRAINT `FK_mdt_incidents_evidence_mdt_incidents` FOREIGN KEY (`incidentid`) REFERENCES `mdt_incidents` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Dumping data for table freeserver.mdt_incidents_evidence: ~0 rows (approximately)

-- Dumping structure for table freeserver.mdt_incidents_officers
CREATE TABLE IF NOT EXISTS `mdt_incidents_officers` (
  `incidentid` int(10) unsigned NOT NULL,
  `citizenid` varchar(50) NOT NULL,
  KEY `FK_mdt_incidents_officers_players` (`citizenid`),
  KEY `incidentid` (`incidentid`),
  CONSTRAINT `FK_mdt_incidents_officers_mdt_incidents` FOREIGN KEY (`incidentid`) REFERENCES `mdt_incidents` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Dumping data for table freeserver.mdt_incidents_officers: ~0 rows (approximately)

-- Dumping structure for table freeserver.mdt_offenses
CREATE TABLE IF NOT EXISTS `mdt_offenses` (
  `label` varchar(100) NOT NULL,
  `type` enum('misdemeanor','felony','infraction') NOT NULL,
  `category` enum('OFFENSES AGAINST PERSONS','OFFENSES INVOLVING THEFT','OFFENSES INVOLVING FRAUD','OFFENSES INVOLVING DAMAGE TO PROPERTY','OFFENSES AGAINST PUBLIC ADMINISTRATION','OFFENSES AGAINST PUBLIC ORDER','OFFENSES AGAINST HEALTH AND MORALS','OFFENSES AGAINST PUBLIC SAFETY','OFFENSES INVOLVING THE OPERATION OF A VEHICLE','OFFENSES INVOLVING THE WELL-BEING OF WILDLIFE') NOT NULL,
  `description` varchar(250) NOT NULL,
  `time` int(10) unsigned NOT NULL DEFAULT 0,
  `fine` int(10) unsigned NOT NULL DEFAULT 0,
  `points` int(10) unsigned NOT NULL DEFAULT 0,
  PRIMARY KEY (`label`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Dumping data for table freeserver.mdt_offenses: ~104 rows (approximately)
INSERT INTO `mdt_offenses` (`label`, `type`, `category`, `description`, `time`, `fine`, `points`) VALUES
	('Animal Cruelty', 'misdemeanor', 'OFFENSES AGAINST HEALTH AND MORALS', 'Intentionally inflicting harm or failing to provide adequate care to animals.', 90, 5000, 0),
	('Armed Robbery', 'felony', 'OFFENSES INVOLVING THEFT', 'Robbery with the use of a weapon.', 360, 25000, 0),
	('Arson', 'felony', 'OFFENSES INVOLVING DAMAGE TO PROPERTY', 'The criminal act of deliberately setting fire to property.', 360, 20000, 0),
	('Assault', 'misdemeanor', 'OFFENSES AGAINST PERSONS', 'Unlawfully attacking another person.', 30, 1000, 0),
	('Battery', 'misdemeanor', 'OFFENSES AGAINST PERSONS', 'Applying force to another, resulting in harmful or offensive contact.', 60, 3000, 0),
	('Bribery', 'felony', 'OFFENSES AGAINST PUBLIC ADMINISTRATION', 'Offering, giving, receiving, or soliciting anything of value to influence the actions of an official or other person in charge of a public or legal duty.', 180, 15000, 0),
	('Building Code Violation', 'misdemeanor', 'OFFENSES AGAINST PUBLIC SAFETY', 'Violating local building regulations, potentially creating safety hazards.', 30, 2000, 0),
	('Burglary', 'felony', 'OFFENSES INVOLVING THEFT', 'Entering a building unlawfully with intent to commit a felony or a theft.', 90, 5000, 0),
	('Credit Card Fraud', 'felony', 'OFFENSES INVOLVING FRAUD', 'Unauthorized use of a credit card to obtain goods of value.', 90, 5000, 0),
	('Criminal Mischief', 'misdemeanor', 'OFFENSES INVOLVING DAMAGE TO PROPERTY', 'Intentional or knowing damage to anothers property.', 90, 3000, 0),
	('Criminal Possession of Weapon Class A', 'felony', 'OFFENSES AGAINST PUBLIC SAFETY', 'Possession of a Class A weapon, such as a machine gun, assault rifle, or destructive device.', 360, 20000, 0),
	('Criminal Possession of Weapon Class B', 'felony', 'OFFENSES AGAINST PUBLIC SAFETY', 'Possession of a Class B weapon, such as a sawed-off shotgun or handgun.', 180, 15000, 0),
	('Criminal Possession of Weapon Class C', 'misdemeanor', 'OFFENSES AGAINST PUBLIC SAFETY', 'Possession of a Class C weapon, such as a rifle or shotgun.', 90, 5000, 0),
	('Criminal Possession of Weapon Class D', 'misdemeanor', 'OFFENSES AGAINST PUBLIC SAFETY', 'Possession of a Class D weapon, such as a knife or club.', 30, 1000, 0),
	('Curfew Violation', 'infraction', 'OFFENSES AGAINST PUBLIC ORDER', 'Failing to adhere to government-imposed curfew regulations, typically enforced to maintain public order during emergencies.', 0, 300, 0),
	('Damaging Public Utilities', 'felony', 'OFFENSES INVOLVING DAMAGE TO PROPERTY', 'Intentionally damaging or interfering with services of public utility providers.', 180, 10000, 0),
	('Destroying Habitat', 'felony', 'OFFENSES INVOLVING THE WELL-BEING OF WILDLIFE', 'Deliberate destruction of environments that support wildlife.', 180, 15000, 0),
	('Destruction of Signs', 'infraction', 'OFFENSES INVOLVING DAMAGE TO PROPERTY', 'The act of destroying or defacing road signs or other public signs.', 0, 500, 0),
	('Disorderly Conduct', 'misdemeanor', 'OFFENSES AGAINST PUBLIC ORDER', 'Engaging in behavior that disrupts public peace, including fighting, making excessive noise, or causing a public disturbance.', 30, 1000, 0),
	('Disrupting Wildlife with Noise Pollution', 'misdemeanor', 'OFFENSES INVOLVING THE WELL-BEING OF WILDLIFE', 'Causing noise that can harm wildlife behavior and natural habitat.', 60, 3000, 0),
	('Driving Under the Influence (DUI)', 'felony', 'OFFENSES INVOLVING THE OPERATION OF A VEHICLE', 'Operating a vehicle while under the influence of alcohol or drugs.', 90, 7000, 3),
	('Driving with a Suspended License', 'misdemeanor', 'OFFENSES INVOLVING THE OPERATION OF A VEHICLE', 'Driving when your drivers license has been suspended or revoked.', 30, 2000, 2),
	('Driving with Obstructed View', 'infraction', 'OFFENSES INVOLVING THE OPERATION OF A VEHICLE', 'Driving a vehicle with objects blocking the drivers view or control.', 0, 300, 0),
	('Driving Without a License', 'misdemeanor', 'OFFENSES INVOLVING THE OPERATION OF A VEHICLE', 'Operating a vehicle without a valid driving license.', 0, 1000, 2),
	('Drug Possession', 'misdemeanor', 'OFFENSES AGAINST HEALTH AND MORALS', 'Possession of illegal drugs or controlled substances without a prescription.', 60, 2000, 0),
	('DUI with Bodily Injury', 'felony', 'OFFENSES AGAINST PUBLIC SAFETY', 'Driving under the influence of alcohol or drugs and causing bodily harm.', 180, 15000, 3),
	('Election Fraud', 'felony', 'OFFENSES AGAINST PUBLIC ADMINISTRATION', 'Illegal interference with the process of an election.', 240, 20000, 0),
	('Embezzlement', 'felony', 'OFFENSES INVOLVING THEFT', 'Theft or misappropriation of funds placed in ones trust or belonging to ones employer.', 180, 15000, 0),
	('Failure to Yield', 'infraction', 'OFFENSES INVOLVING THE OPERATION OF A VEHICLE', 'Failing to yield the right of way to other road users where required.', 0, 250, 1),
	('False Advertising', 'misdemeanor', 'OFFENSES INVOLVING FRAUD', 'Advertising products or services in a misleading or deceptive way.', 30, 2000, 0),
	('Falsifying Records', 'misdemeanor', 'OFFENSES AGAINST PUBLIC ADMINISTRATION', 'Altering, concealing, falsifying, or destroying a document to obstruct the investigation or other official matters.', 90, 5000, 0),
	('Feeding Wildlife Illegally', 'infraction', 'OFFENSES INVOLVING THE WELL-BEING OF WILDLIFE', 'Feeding wildlife in areas where it is prohibited by law.', 0, 500, 0),
	('Firearm Possession without Permit', 'felony', 'OFFENSES AGAINST PUBLIC SAFETY', 'Owning or carrying a firearm without the necessary permits.', 180, 10000, 0),
	('Gambling Operation', 'felony', 'OFFENSES AGAINST HEALTH AND MORALS', 'Operating or participating in illegal gambling activities, including unlicensed casinos or sports betting.', 180, 15000, 0),
	('Graffiti', 'misdemeanor', 'OFFENSES INVOLVING DAMAGE TO PROPERTY', 'Writing or drawings scribbled, scratched, or sprayed illicitly on a wall or other surface in a public place.', 60, 2500, 0),
	('Grand Theft Auto', 'felony', 'OFFENSES INVOLVING THEFT', 'Theft of an automobile.', 180, 10000, 0),
	('Harassment', 'infraction', 'OFFENSES AGAINST PERSONS', 'Engaging in a pattern of unwanted conduct that alarms or seriously annoys another person, without claiming a legitimate purpose.', 0, 500, 0),
	('Hate Crime', 'felony', 'OFFENSES AGAINST PERSONS', 'A crime motivated by racial, sexual, or other prejudice.', 180, 10000, 0),
	('Hazardous Waste Dumping', 'felony', 'OFFENSES AGAINST PUBLIC SAFETY', 'Disposing of hazardous materials in a manner that endangers public health and the environment.', 180, 15000, 0),
	('Healthcare Fraud', 'felony', 'OFFENSES INVOLVING FRAUD', 'Filing dishonest healthcare claims to obtain a profit.', 180, 15000, 0),
	('Hit and Run', 'felony', 'OFFENSES INVOLVING THE OPERATION OF A VEHICLE', 'Leaving the scene of an accident without providing contact information or assisting the injured.', 180, 10000, 3),
	('Human Trafficking', 'felony', 'OFFENSES AGAINST PERSONS', 'Illegal trade of human beings for the purposes of forced labor or sexual exploitation.', 720, 50000, 0),
	('Identity Theft', 'felony', 'OFFENSES INVOLVING THEFT', 'The fraudulent acquisition and use of a persons private identifying information.', 180, 10000, 0),
	('Illegal Assembly', 'misdemeanor', 'OFFENSES AGAINST PUBLIC ORDER', 'Gathering of people with the intent of engaging in activities that breach public peace or order.', 60, 3000, 0),
	('Illegal Dumping', 'misdemeanor', 'OFFENSES INVOLVING DAMAGE TO PROPERTY', 'Disposing of waste illegally in non-designated areas.', 90, 5000, 0),
	('Illegal Fireworks', 'misdemeanor', 'OFFENSES AGAINST HEALTH AND MORALS', 'Possessing, using, or selling fireworks without appropriate authorization.', 30, 2000, 0),
	('Illegal Fishing', 'misdemeanor', 'OFFENSES INVOLVING THE WELL-BEING OF WILDLIFE', 'Fishing without a license or in restricted areas.', 30, 2000, 0),
	('Illegal Gambling', 'misdemeanor', 'OFFENSES AGAINST PUBLIC ORDER', 'Organizing, participating in, or operating games of chance in public or private settings without legal authorization.', 90, 5000, 0),
	('Illegal Hunting', 'misdemeanor', 'OFFENSES AGAINST PUBLIC SAFETY', 'Hunting wildlife in restricted areas or during off-seasons without proper permits.', 60, 3000, 0),
	('Illegal Lobbying', 'misdemeanor', 'OFFENSES AGAINST PUBLIC ADMINISTRATION', 'Lobbying without proper registration or when specifically prohibited.', 120, 8000, 0),
	('Illegal Logging', 'felony', 'OFFENSES INVOLVING THE WELL-BEING OF WILDLIFE', 'Unauthorized cutting down of trees in protected areas.', 180, 15000, 0),
	('Illegal Pet Trade', 'felony', 'OFFENSES INVOLVING THE WELL-BEING OF WILDLIFE', 'Engaging in the sale or purchase of wild animals as pets illegally.', 360, 20000, 0),
	('Illegal Street Racing', 'misdemeanor', 'OFFENSES INVOLVING THE OPERATION OF A VEHICLE', 'Participating in unauthorized speed contests on public roads.', 90, 5000, 3),
	('Illegal Substance Sale', 'felony', 'OFFENSES AGAINST HEALTH AND MORALS', 'Selling or distributing illegal drugs or other prohibited substances.', 180, 10000, 0),
	('Illegal Tattooing', 'infraction', 'OFFENSES AGAINST HEALTH AND MORALS', 'Tattooing individuals without proper licensing or on minors without legal consent.', 0, 1000, 0),
	('Improper Transport of Hazardous Materials', 'felony', 'OFFENSES AGAINST PUBLIC SAFETY', 'Transporting hazardous materials without adhering to safety regulations and legal requirements.', 240, 15000, 0),
	('Inciting a Riot', 'felony', 'OFFENSES AGAINST PUBLIC ORDER', 'Encouraging, promoting, or participating in violent or disruptive behavior that turns into a mass disturbance.', 90, 7000, 0),
	('Insurance Fraud', 'felony', 'OFFENSES INVOLVING FRAUD', 'The act of falsifying or exaggerating the facts of an accident to an insurance company to obtain payment that would not otherwise be made.', 180, 10000, 0),
	('Kidnapping', 'felony', 'OFFENSES AGAINST PERSONS', 'Unlawfully seizing and carrying away a person by force.', 360, 20000, 0),
	('Larceny', 'misdemeanor', 'OFFENSES INVOLVING THEFT', 'Unlawful taking of personal property.', 60, 2000, 0),
	('Littering', 'infraction', 'OFFENSES INVOLVING DAMAGE TO PROPERTY', 'Carelessly discarding trash or other materials on public or private property.', 0, 250, 0),
	('Littering in Natural Reserves', 'misdemeanor', 'OFFENSES INVOLVING THE WELL-BEING OF WILDLIFE', 'Disposing of waste in a natural reserve, negatively affecting wildlife.', 30, 2000, 0),
	('Loitering', 'infraction', 'OFFENSES AGAINST PUBLIC ORDER', 'Remaining idle in a public place for an extended period without a clear reason, often seen as a nuisance.', 0, 250, 0),
	('Mail Fraud', 'felony', 'OFFENSES INVOLVING FRAUD', 'The use of postal services to commit fraud.', 180, 10000, 0),
	('Manslaughter', 'felony', 'OFFENSES AGAINST PERSONS', 'Killing another person without intention during the commission of a non-felony.', 180, 15000, 0),
	('Misrepresentation', 'misdemeanor', 'OFFENSES INVOLVING FRAUD', 'Deliberately providing false information in a business transaction.', 90, 3000, 0),
	('Misuse of Public Funds', 'felony', 'OFFENSES AGAINST PUBLIC ADMINISTRATION', 'Using public money for unauthorized, illegal, or unethical purposes.', 180, 15000, 0),
	('Murder', 'felony', 'OFFENSES AGAINST PERSONS', 'Unlawful premeditated killing of one human being by another.', 999, 50000, 0),
	('Negligent Discharge of a Firearm', 'misdemeanor', 'OFFENSES AGAINST PUBLIC SAFETY', 'Accidentally discharging a firearm due to careless handling.', 60, 3000, 0),
	('Obstruction of Justice', 'felony', 'OFFENSES AGAINST PUBLIC ADMINISTRATION', 'The crime of obstructing prosecutors or other (usually government) officials.', 180, 10000, 0),
	('Perjury', 'felony', 'OFFENSES AGAINST PUBLIC ADMINISTRATION', 'The offense of willfully telling an untruth in a court after having taken an oath or affirmation.', 180, 10000, 0),
	('Petty Theft', 'misdemeanor', 'OFFENSES INVOLVING THEFT', 'The theft of relatively low value items.', 30, 500, 0),
	('Phishing', 'infraction', 'OFFENSES INVOLVING FRAUD', 'Attempting to acquire sensitive information such as usernames, passwords, and credit card details by masquerading as a trustworthy entity in an electronic communication.', 0, 500, 0),
	('Poaching', 'felony', 'OFFENSES INVOLVING THE WELL-BEING OF WILDLIFE', 'Illegal hunting, killing, or capturing of wild animals.', 180, 10000, 0),
	('Possession of Explosives', 'felony', 'OFFENSES AGAINST PUBLIC SAFETY', 'Illegally possessing or improperly handling explosive materials.', 360, 20000, 0),
	('Prostitution', 'misdemeanor', 'OFFENSES AGAINST HEALTH AND MORALS', 'Engaging in, soliciting, or arranging sexual activities in exchange for payment.', 90, 3000, 0),
	('Public Corruption', 'felony', 'OFFENSES AGAINST PUBLIC ADMINISTRATION', 'The abuse of public office for private gain.', 360, 25000, 0),
	('Public Indecency', 'misdemeanor', 'OFFENSES AGAINST HEALTH AND MORALS', 'Performing acts of a sexual nature in public spaces or exposing oneself inappropriately.', 30, 1000, 0),
	('Public Intoxication', 'misdemeanor', 'OFFENSES AGAINST PUBLIC ORDER', 'Appearing in public places while significantly impaired by alcohol or drugs, posing a potential danger to self and others.', 0, 500, 0),
	('Public Nudity', 'misdemeanor', 'OFFENSES AGAINST PUBLIC ORDER', 'Intentionally exposing oneself in a public space, not complying with local decency laws.', 60, 2000, 0),
	('Receiving Stolen Property', 'misdemeanor', 'OFFENSES INVOLVING THEFT', 'Receiving, buying, or possessing property known to be stolen.', 90, 4000, 0),
	('Reckless Driving', 'misdemeanor', 'OFFENSES INVOLVING THE OPERATION OF A VEHICLE', 'Driving with a willful disregard for the safety of persons or property.', 60, 3000, 4),
	('Reckless Endangerment', 'felony', 'OFFENSES AGAINST PUBLIC SAFETY', 'Engaging in conduct that poses a significant risk of serious physical injury to others.', 90, 7000, 0),
	('Sabotage', 'felony', 'OFFENSES INVOLVING DAMAGE TO PROPERTY', 'Deliberately destroying, damaging, or obstructing something, especially for political or military advantage.', 360, 25000, 0),
	('Securities Fraud', 'felony', 'OFFENSES INVOLVING FRAUD', 'Fraudulent practices in the stock and commodities markets, including insider trading.', 360, 25000, 0),
	('Sexual Assault', 'felony', 'OFFENSES AGAINST PERSONS', 'An act in which a person sexually touches another person without their consent.', 360, 20000, 0),
	('Shoplifting', 'misdemeanor', 'OFFENSES INVOLVING THEFT', 'The act of stealing goods from a store.', 30, 1000, 0),
	('Smoking Ban Violation', 'infraction', 'OFFENSES AGAINST HEALTH AND MORALS', 'Smoking in non-smoking areas or violating local smoking regulations.', 0, 250, 0),
	('Stalking', 'misdemeanor', 'OFFENSES AGAINST PERSONS', 'Repeatedly following or harassing another person and making threats.', 90, 5000, 0),
	('Tax Evasion', 'felony', 'OFFENSES INVOLVING FRAUD', 'The illegal nonpayment or underpayment of tax.', 180, 10000, 0),
	('Ticket Scalping', 'infraction', 'OFFENSES INVOLVING THEFT', 'Selling tickets for an event without a proper license and often at a rate exceeding the face value.', 0, 200, 0),
	('Traffic Obstruction', 'infraction', 'OFFENSES INVOLVING THE OPERATION OF A VEHICLE', 'Obstructing traffic flow intentionally or unintentionally.', 0, 500, 0),
	('Traffic Violation', 'infraction', 'OFFENSES AGAINST PUBLIC SAFETY', 'Violating traffic laws such as speeding, running red lights, or illegal parking.', 0, 500, 1),
	('Trespassing with Damage', 'misdemeanor', 'OFFENSES INVOLVING DAMAGE TO PROPERTY', 'Entering anothers property without permission and causing damage.', 30, 2000, 0),
	('Unauthorized Disclosure of Confidential Information', 'infraction', 'OFFENSES AGAINST PUBLIC ADMINISTRATION', 'Improperly revealing confidential or classified information without authorization.', 0, 1000, 0),
	('Underage Drinking', 'infraction', 'OFFENSES AGAINST HEALTH AND MORALS', 'Consuming or possessing alcohol by individuals under the legal drinking age.', 0, 500, 0),
	('Unlawful Protest', 'misdemeanor', 'OFFENSES AGAINST PUBLIC ORDER', 'Protesting without required permissions or in violation of legal restrictions, potentially leading to public disorder.', 30, 2000, 0),
	('Use of Harmful Pesticides', 'misdemeanor', 'OFFENSES INVOLVING THE WELL-BEING OF WILDLIFE', 'Using pesticides that are known to cause significant harm to wildlife.', 90, 5000, 0),
	('Vagrancy', 'misdemeanor', 'OFFENSES AGAINST PUBLIC ORDER', 'Living in public spaces without a permanent home or employment, often associated with public nuisance behaviors.', 30, 1000, 0),
	('Vandalism', 'misdemeanor', 'OFFENSES INVOLVING DAMAGE TO PROPERTY', 'Deliberately destroying or damaging property.', 30, 1000, 0),
	('Vehicle Manslaughter', 'felony', 'OFFENSES INVOLVING THE OPERATION OF A VEHICLE', 'Causing the death of another through negligent or reckless driving.', 360, 20000, 0),
	('Wildlife Smuggling', 'felony', 'OFFENSES INVOLVING THE WELL-BEING OF WILDLIFE', 'Illegally exporting or importing protected or endangered species.', 360, 25000, 0),
	('Wire Fraud', 'felony', 'OFFENSES INVOLVING FRAUD', 'Fraud involving the use of electronic communications.', 180, 15000, 0),
	('Witness Tampering', 'felony', 'OFFENSES AGAINST PUBLIC ADMINISTRATION', 'The attempt to alter or prevent the testimony of witnesses within criminal or civil proceedings.', 240, 15000, 0);

-- Dumping structure for table freeserver.mdt_profiles
CREATE TABLE IF NOT EXISTS `mdt_profiles` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `citizenid` varchar(50) NOT NULL,
  `image` varchar(90) DEFAULT NULL,
  `notes` text DEFAULT NULL,
  `callsign` varchar(10) DEFAULT NULL,
  `apu` tinyint(4) DEFAULT NULL,
  `air` tinyint(4) DEFAULT NULL,
  `mc` tinyint(4) DEFAULT NULL,
  `k9` tinyint(4) DEFAULT NULL,
  `fto` tinyint(4) DEFAULT NULL,
  `fingerprint` varchar(90) DEFAULT NULL,
  `lastActive` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `mdt_profiles_pk2` (`citizenid`),
  UNIQUE KEY `mdt_profiles_pk` (`callsign`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Dumping data for table freeserver.mdt_profiles: ~0 rows (approximately)
INSERT INTO `mdt_profiles` (`id`, `citizenid`, `image`, `notes`, `callsign`, `apu`, `air`, `mc`, `k9`, `fto`, `fingerprint`, `lastActive`) VALUES
	(1, 'VIY36885', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2025-04-13 16:01:11');

-- Dumping structure for table freeserver.mdt_recent_activity
CREATE TABLE IF NOT EXISTS `mdt_recent_activity` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `citizenid` varchar(50) NOT NULL,
  `category` varchar(100) DEFAULT NULL,
  `type` enum('created','updated','deleted') NOT NULL,
  `date` datetime DEFAULT current_timestamp(),
  `activityid` int(10) unsigned DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Dumping data for table freeserver.mdt_recent_activity: ~0 rows (approximately)

-- Dumping structure for table freeserver.mdt_reports
CREATE TABLE IF NOT EXISTS `mdt_reports` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `title` varchar(50) NOT NULL,
  `description` text DEFAULT NULL,
  `author` varchar(50) DEFAULT NULL,
  `date` datetime DEFAULT current_timestamp(),
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Dumping data for table freeserver.mdt_reports: ~0 rows (approximately)

-- Dumping structure for table freeserver.mdt_reports_citizens
CREATE TABLE IF NOT EXISTS `mdt_reports_citizens` (
  `reportid` int(10) unsigned NOT NULL,
  `citizenid` varchar(50) NOT NULL,
  KEY `FK_mdt_reports_players` (`citizenid`),
  KEY `reportid` (`reportid`),
  CONSTRAINT `FK_mdt_reports_players_mdt_reports` FOREIGN KEY (`reportid`) REFERENCES `mdt_reports` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Dumping data for table freeserver.mdt_reports_citizens: ~0 rows (approximately)

-- Dumping structure for table freeserver.mdt_reports_evidence
CREATE TABLE IF NOT EXISTS `mdt_reports_evidence` (
  `reportid` int(10) unsigned NOT NULL,
  `label` varchar(50) NOT NULL DEFAULT '',
  `image` varchar(90) NOT NULL DEFAULT '',
  KEY `reportid` (`reportid`),
  CONSTRAINT `FK_mdt_reports_evidence_mdt_reports` FOREIGN KEY (`reportid`) REFERENCES `mdt_reports` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Dumping data for table freeserver.mdt_reports_evidence: ~0 rows (approximately)

-- Dumping structure for table freeserver.mdt_reports_officers
CREATE TABLE IF NOT EXISTS `mdt_reports_officers` (
  `reportid` int(10) unsigned NOT NULL,
  `citizenid` varchar(50) NOT NULL,
  KEY `FK_mdt_reports_officers_players` (`citizenid`),
  KEY `reportid` (`reportid`),
  CONSTRAINT `FK_mdt_reports_officers_mdt_reports` FOREIGN KEY (`reportid`) REFERENCES `mdt_reports` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Dumping data for table freeserver.mdt_reports_officers: ~0 rows (approximately)

-- Dumping structure for table freeserver.mdt_vehicles
CREATE TABLE IF NOT EXISTS `mdt_vehicles` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `plate` varchar(50) NOT NULL,
  `image` varchar(90) DEFAULT NULL,
  `notes` text DEFAULT NULL,
  `known_information` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL CHECK (json_valid(`known_information`)),
  PRIMARY KEY (`id`),
  UNIQUE KEY `plate` (`plate`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Dumping data for table freeserver.mdt_vehicles: ~0 rows (approximately)

-- Dumping structure for table freeserver.mdt_warrants
CREATE TABLE IF NOT EXISTS `mdt_warrants` (
  `incidentid` int(10) unsigned NOT NULL,
  `citizenid` varchar(50) NOT NULL,
  `expiresAt` datetime NOT NULL,
  KEY `mdt_warrants_mdt_incidents_id_fk` (`incidentid`),
  CONSTRAINT `mdt_warrants_mdt_incidents_id_fk` FOREIGN KEY (`incidentid`) REFERENCES `mdt_incidents` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Dumping data for table freeserver.mdt_warrants: ~0 rows (approximately)

-- Dumping structure for table freeserver.npwd_calls
CREATE TABLE IF NOT EXISTS `npwd_calls` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `identifier` varchar(48) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `transmitter` varchar(255) NOT NULL,
  `receiver` varchar(255) NOT NULL,
  `is_accepted` tinyint(4) DEFAULT 0,
  `isAnonymous` tinyint(4) NOT NULL DEFAULT 0,
  `start` varchar(255) DEFAULT NULL,
  `end` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `identifier` (`identifier`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;

-- Dumping data for table freeserver.npwd_calls: ~0 rows (approximately)

-- Dumping structure for table freeserver.npwd_darkchat_channels
CREATE TABLE IF NOT EXISTS `npwd_darkchat_channels` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `channel_identifier` varchar(191) NOT NULL,
  `label` varchar(255) DEFAULT '',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE KEY `darkchat_channels_channel_identifier_uindex` (`channel_identifier`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=20 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Dumping data for table freeserver.npwd_darkchat_channels: ~0 rows (approximately)

-- Dumping structure for table freeserver.npwd_darkchat_channel_members
CREATE TABLE IF NOT EXISTS `npwd_darkchat_channel_members` (
  `channel_id` int(11) NOT NULL,
  `user_identifier` varchar(255) NOT NULL,
  `is_owner` tinyint(4) NOT NULL DEFAULT 0,
  KEY `npwd_darkchat_channel_members_npwd_darkchat_channels_id_fk` (`channel_id`) USING BTREE,
  CONSTRAINT `npwd_darkchat_channel_members_npwd_darkchat_channels_id_fk` FOREIGN KEY (`channel_id`) REFERENCES `npwd_darkchat_channels` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Dumping data for table freeserver.npwd_darkchat_channel_members: ~0 rows (approximately)

-- Dumping structure for table freeserver.npwd_darkchat_messages
CREATE TABLE IF NOT EXISTS `npwd_darkchat_messages` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `channel_id` int(11) NOT NULL,
  `message` varchar(255) NOT NULL,
  `user_identifier` varchar(255) NOT NULL,
  `createdAt` timestamp NOT NULL DEFAULT current_timestamp(),
  `is_image` tinyint(4) NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`) USING BTREE,
  KEY `darkchat_messages_darkchat_channels_id_fk` (`channel_id`) USING BTREE,
  CONSTRAINT `darkchat_messages_darkchat_channels_id_fk` FOREIGN KEY (`channel_id`) REFERENCES `npwd_darkchat_channels` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=31 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Dumping data for table freeserver.npwd_darkchat_messages: ~0 rows (approximately)

-- Dumping structure for table freeserver.npwd_marketplace_listings
CREATE TABLE IF NOT EXISTS `npwd_marketplace_listings` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `identifier` varchar(48) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `username` varchar(255) DEFAULT NULL,
  `name` varchar(50) DEFAULT NULL,
  `number` varchar(255) NOT NULL,
  `title` varchar(255) DEFAULT NULL,
  `url` varchar(255) DEFAULT NULL,
  `description` varchar(255) NOT NULL,
  `createdAt` timestamp NOT NULL DEFAULT current_timestamp(),
  `updatedAt` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `reported` tinyint(4) NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`),
  KEY `identifier` (`identifier`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;

-- Dumping data for table freeserver.npwd_marketplace_listings: ~0 rows (approximately)

-- Dumping structure for table freeserver.npwd_match_profiles
CREATE TABLE IF NOT EXISTS `npwd_match_profiles` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `identifier` varchar(48) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `name` varchar(90) NOT NULL,
  `image` varchar(255) NOT NULL,
  `bio` varchar(512) DEFAULT NULL,
  `location` varchar(45) DEFAULT NULL,
  `job` varchar(45) DEFAULT NULL,
  `tags` varchar(255) NOT NULL DEFAULT '',
  `voiceMessage` varchar(512) DEFAULT NULL,
  `createdAt` timestamp NOT NULL DEFAULT current_timestamp(),
  `updatedAt` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  PRIMARY KEY (`id`),
  UNIQUE KEY `identifier_UNIQUE` (`identifier`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;

-- Dumping data for table freeserver.npwd_match_profiles: ~1 rows (approximately)
INSERT INTO `npwd_match_profiles` (`id`, `identifier`, `name`, `image`, `bio`, `location`, `job`, `tags`, `voiceMessage`, `createdAt`, `updatedAt`) VALUES
	(1, 'VIY36885', 'Test Test', 'https://upload.wikimedia.org/wikipedia/commons/a/ac/No_image_available.svg', '', '', '', '', NULL, '2025-04-13 13:07:59', '2025-04-13 13:07:59');

-- Dumping structure for table freeserver.npwd_match_views
CREATE TABLE IF NOT EXISTS `npwd_match_views` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `identifier` varchar(48) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `profile` int(11) NOT NULL,
  `liked` tinyint(4) DEFAULT 0,
  `createdAt` timestamp NOT NULL DEFAULT current_timestamp(),
  `updatedAt` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  PRIMARY KEY (`id`),
  KEY `match_profile_idx` (`profile`),
  KEY `identifier` (`identifier`),
  CONSTRAINT `match_profile` FOREIGN KEY (`profile`) REFERENCES `npwd_match_profiles` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;

-- Dumping data for table freeserver.npwd_match_views: ~0 rows (approximately)

-- Dumping structure for table freeserver.npwd_messages
CREATE TABLE IF NOT EXISTS `npwd_messages` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `message` varchar(512) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `user_identifier` varchar(48) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `conversation_id` varchar(512) NOT NULL,
  `isRead` tinyint(4) NOT NULL DEFAULT 0,
  `createdAt` timestamp NOT NULL DEFAULT current_timestamp(),
  `updatedAt` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `visible` tinyint(4) NOT NULL DEFAULT 1,
  `author` varchar(255) NOT NULL,
  `is_embed` tinyint(4) NOT NULL DEFAULT 0,
  `embed` varchar(512) NOT NULL DEFAULT '',
  PRIMARY KEY (`id`),
  KEY `user_identifier` (`user_identifier`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;

-- Dumping data for table freeserver.npwd_messages: ~0 rows (approximately)

-- Dumping structure for table freeserver.npwd_messages_conversations
CREATE TABLE IF NOT EXISTS `npwd_messages_conversations` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `conversation_list` varchar(225) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `label` varchar(60) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT '',
  `createdAt` timestamp NOT NULL DEFAULT current_timestamp(),
  `updatedAt` timestamp NOT NULL DEFAULT current_timestamp(),
  `last_message_id` int(11) DEFAULT NULL,
  `is_group_chat` tinyint(4) NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;

-- Dumping data for table freeserver.npwd_messages_conversations: ~0 rows (approximately)

-- Dumping structure for table freeserver.npwd_messages_participants
CREATE TABLE IF NOT EXISTS `npwd_messages_participants` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `conversation_id` int(11) NOT NULL,
  `participant` varchar(225) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `unread_count` int(11) DEFAULT 0,
  PRIMARY KEY (`id`) USING BTREE,
  KEY `message_participants_npwd_messages_conversations_id_fk` (`conversation_id`) USING BTREE,
  CONSTRAINT `message_participants_npwd_messages_conversations_id_fk` FOREIGN KEY (`conversation_id`) REFERENCES `npwd_messages_conversations` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;

-- Dumping data for table freeserver.npwd_messages_participants: ~0 rows (approximately)

-- Dumping structure for table freeserver.npwd_notes
CREATE TABLE IF NOT EXISTS `npwd_notes` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `identifier` varchar(48) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `title` varchar(255) NOT NULL,
  `content` varchar(255) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `identifier` (`identifier`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;

-- Dumping data for table freeserver.npwd_notes: ~0 rows (approximately)

-- Dumping structure for table freeserver.npwd_phone_contacts
CREATE TABLE IF NOT EXISTS `npwd_phone_contacts` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `identifier` varchar(48) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `avatar` varchar(255) DEFAULT NULL,
  `number` varchar(20) DEFAULT NULL,
  `display` varchar(255) NOT NULL DEFAULT '',
  PRIMARY KEY (`id`),
  KEY `identifier` (`identifier`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;

-- Dumping data for table freeserver.npwd_phone_contacts: ~0 rows (approximately)

-- Dumping structure for table freeserver.npwd_phone_gallery
CREATE TABLE IF NOT EXISTS `npwd_phone_gallery` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `identifier` varchar(48) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `image` varchar(255) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `identifier` (`identifier`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;

-- Dumping data for table freeserver.npwd_phone_gallery: ~0 rows (approximately)

-- Dumping structure for table freeserver.npwd_twitter_likes
CREATE TABLE IF NOT EXISTS `npwd_twitter_likes` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `profile_id` int(11) NOT NULL,
  `tweet_id` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `unique_combination` (`profile_id`,`tweet_id`),
  KEY `profile_idx` (`profile_id`),
  KEY `tweet_idx` (`tweet_id`),
  CONSTRAINT `profile` FOREIGN KEY (`profile_id`) REFERENCES `npwd_twitter_profiles` (`id`),
  CONSTRAINT `tweet` FOREIGN KEY (`tweet_id`) REFERENCES `npwd_twitter_tweets` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;

-- Dumping data for table freeserver.npwd_twitter_likes: ~0 rows (approximately)

-- Dumping structure for table freeserver.npwd_twitter_profiles
CREATE TABLE IF NOT EXISTS `npwd_twitter_profiles` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `profile_name` varchar(90) NOT NULL,
  `identifier` varchar(48) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `avatar_url` varchar(255) DEFAULT 'https://i.fivemanage.com/images/3ClWwmpwkFhL.png',
  `createdAt` timestamp NOT NULL DEFAULT current_timestamp(),
  `updatedAt` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  PRIMARY KEY (`id`),
  UNIQUE KEY `profile_name_UNIQUE` (`profile_name`),
  KEY `identifier` (`identifier`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;

-- Dumping data for table freeserver.npwd_twitter_profiles: ~1 rows (approximately)
INSERT INTO `npwd_twitter_profiles` (`id`, `profile_name`, `identifier`, `avatar_url`, `createdAt`, `updatedAt`) VALUES
	(1, 'Test_Test', 'VIY36885', 'https://i.fivemanage.com/images/3ClWwmpwkFhL.png', '2025-04-13 13:07:59', '2025-04-13 13:07:59');

-- Dumping structure for table freeserver.npwd_twitter_reports
CREATE TABLE IF NOT EXISTS `npwd_twitter_reports` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `profile_id` int(11) NOT NULL,
  `tweet_id` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `unique_combination` (`profile_id`,`tweet_id`),
  KEY `profile_idx` (`profile_id`),
  KEY `tweet_idx` (`tweet_id`),
  CONSTRAINT `report_profile` FOREIGN KEY (`profile_id`) REFERENCES `npwd_twitter_profiles` (`id`),
  CONSTRAINT `report_tweet` FOREIGN KEY (`tweet_id`) REFERENCES `npwd_twitter_tweets` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;

-- Dumping data for table freeserver.npwd_twitter_reports: ~0 rows (approximately)

-- Dumping structure for table freeserver.npwd_twitter_tweets
CREATE TABLE IF NOT EXISTS `npwd_twitter_tweets` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `message` varchar(1000) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `createdAt` timestamp NOT NULL DEFAULT current_timestamp(),
  `updatedAt` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `likes` int(11) NOT NULL DEFAULT 0,
  `identifier` varchar(48) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `visible` tinyint(4) NOT NULL DEFAULT 1,
  `images` varchar(1000) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT '',
  `retweet` int(11) DEFAULT NULL,
  `profile_id` int(11) NOT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  KEY `npwd_twitter_tweets_npwd_twitter_profiles_id_fk` (`profile_id`) USING BTREE,
  CONSTRAINT `npwd_twitter_tweets_npwd_twitter_profiles_id_fk` FOREIGN KEY (`profile_id`) REFERENCES `npwd_twitter_profiles` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;

-- Dumping data for table freeserver.npwd_twitter_tweets: ~0 rows (approximately)

-- Dumping structure for table freeserver.occasion_vehicles
CREATE TABLE IF NOT EXISTS `occasion_vehicles` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `seller` varchar(50) DEFAULT NULL,
  `price` int(11) DEFAULT NULL,
  `description` longtext DEFAULT NULL,
  `plate` varchar(50) DEFAULT NULL,
  `model` varchar(50) DEFAULT NULL,
  `mods` text DEFAULT NULL,
  `occasionid` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `occasionId` (`occasionid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Dumping data for table freeserver.occasion_vehicles: ~0 rows (approximately)

-- Dumping structure for table freeserver.ox_doorlock
CREATE TABLE IF NOT EXISTS `ox_doorlock` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(50) NOT NULL,
  `data` longtext NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Dumping data for table freeserver.ox_doorlock: ~6 rows (approximately)
INSERT INTO `ox_doorlock` (`id`, `name`, `data`) VALUES
	(1, 'vangelico_jewellery', '{"maxDistance":2,"groups":{"police":0},"doors":[{"model":1425919976,"coords":{"x":-631.9553833007813,"y":-236.33326721191407,"z":38.2065315246582},"heading":306},{"model":9467943,"coords":{"x":-630.426513671875,"y":-238.4375457763672,"z":38.2065315246582},"heading":306}],"state":1,"coords":{"x":-631.19091796875,"y":-237.38540649414063,"z":38.2065315246582},"hideUi":true}'),
	(2, 'BigBankThermite1', '{"heading":160,"doors":false,"maxDistance":2,"hideUi":true,"groups":{"police":0},"coords":{"x":251.85757446289063,"y":221.0654754638672,"z":101.83240509033203},"model":-1508355822,"state":1,"autolock":1800}'),
	(3, 'BigBankThermite2', '{"coords":{"x":261.3004150390625,"y":214.50514221191407,"z":101.83240509033203},"autolock":1800,"maxDistance":2,"groups":{"police":0},"model":-1508355822,"doors":false,"hideUi":true,"heading":250,"state":1}'),
	(4, 'BigBankLPDoor', '{"coords":{"x":256.3115539550781,"y":220.65785217285157,"z":106.42955780029297},"autolock":1800,"maxDistance":2,"model":-222270721,"doors":false,"lockpick":true,"hideUi":true,"heading":340,"state":1,"lockpickDifficulty":["hard"]}'),
	(5, 'PaletoThermiteDoor', '{"coords":{"x":-106.47130584716797,"y":6476.15771484375,"z":31.95479965209961},"autolock":1800,"maxDistance":2,"groups":{"police":0},"model":1309269072,"doors":false,"hideUi":true,"heading":315,"state":1}'),
	(6, 'BigBankRedCardDoor', '{"coords":{"x":262.1980895996094,"y":222.518798828125,"z":106.42955780029297},"autolock":1800,"maxDistance":2,"groups":{"police":0},"model":746855201,"doors":false,"hideUi":true,"heading":250,"state":1}');

-- Dumping structure for table freeserver.ox_inventory
CREATE TABLE IF NOT EXISTS `ox_inventory` (
  `owner` varchar(60) DEFAULT NULL,
  `name` varchar(100) NOT NULL,
  `data` longtext DEFAULT NULL,
  `lastupdated` timestamp NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  UNIQUE KEY `owner` (`owner`,`name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;

-- Dumping data for table freeserver.ox_inventory: ~0 rows (approximately)

-- Dumping structure for table freeserver.players
CREATE TABLE IF NOT EXISTS `players` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `userId` int(10) unsigned DEFAULT NULL,
  `citizenid` varchar(50) NOT NULL,
  `cid` int(11) DEFAULT NULL,
  `license` varchar(255) NOT NULL,
  `name` varchar(255) NOT NULL,
  `money` text NOT NULL,
  `charinfo` text DEFAULT NULL,
  `job` text NOT NULL,
  `gang` text DEFAULT NULL,
  `position` text NOT NULL,
  `metadata` text NOT NULL,
  `inventory` longtext DEFAULT NULL,
  `phone_number` varchar(20) DEFAULT NULL,
  `last_updated` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `last_logged_out` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`citizenid`),
  KEY `id` (`id`),
  KEY `last_updated` (`last_updated`),
  KEY `license` (`license`)
) ENGINE=InnoDB AUTO_INCREMENT=33 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Dumping data for table freeserver.players: ~1 rows (approximately)
INSERT INTO `players` (`id`, `userId`, `citizenid`, `cid`, `license`, `name`, `money`, `charinfo`, `job`, `gang`, `position`, `metadata`, `inventory`, `phone_number`, `last_updated`, `last_logged_out`) VALUES
	(1, 1, 'VIY36885', 1, 'license2:ce35a45657b7133595440ac7bb6b2c6473b28129', 'Scorpion716', '{"crypto":0,"cash":500,"bank":4610}', '{"cid":1,"lastname":"Test","account":"US07QBX2531585841","backstory":"placeholder backstory","nationality":"American","phone":"8655960999","firstname":"Test","birthdate":"2006-12-31","gender":0}', '{"grade":{"name":"Recruit","level":0},"type":"leo","isboss":false,"onduty":false,"label":"LSPD","bankAuth":false,"name":"police","payment":50}', '{"grade":{"name":"Unaffiliated","level":0},"isboss":false,"label":"No Gang","name":"none","bankAuth":false}', '{"x":295.4901123046875,"y":-615.6659545898438,"z":43.4168701171875,"w":342.99212646484377}', '{"status":[],"isdead":false,"phonedata":{"SerialNumber":46729688,"InstalledApps":[]},"callsign":"NO CALLSIGN","attachmentcraftingrep":0,"stress":0,"jobrep":{"hotdog":0,"tow":0,"trucker":0,"taxi":0},"fingerprint":"X7G9MR8BTQY439P","walletid":"QB-12953880","dealerrep":0,"thirst":27.80000000000004,"inside":{"apartment":[]},"ishandcuffed":false,"jailitems":[],"tracker":false,"health":200,"craftingrep":0,"inlaststand":false,"licences":{"id":true,"weapon":false,"driver":true},"armor":0,"injail":0,"hunger":20.19999999999995,"bloodtype":"B-","phone":[],"criminalrecord":{"hasRecord":false}}', '[{"count":500,"slot":1,"name":"money"},{"count":1,"slot":2,"name":"phone"},{"count":5,"slot":3,"name":"lockpick"},{"count":1045,"slot":4,"name":"black_money"},{"count":1,"slot":5,"metadata":{"radioId":"VIY368856735","name":"Test Test"},"name":"radio"}]', '8655960999', '2025-04-13 15:15:42', '2025-04-13 14:45:04');

-- Dumping structure for table freeserver.playerskins
CREATE TABLE IF NOT EXISTS `playerskins` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `citizenid` varchar(255) NOT NULL,
  `model` varchar(255) NOT NULL,
  `skin` text NOT NULL,
  `active` tinyint(4) NOT NULL DEFAULT 1,
  PRIMARY KEY (`id`),
  KEY `citizenid` (`citizenid`),
  KEY `active` (`active`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Dumping data for table freeserver.playerskins: ~1 rows (approximately)
INSERT INTO `playerskins` (`id`, `citizenid`, `model`, `skin`, `active`) VALUES
	(1, 'VIY36885', 'mp_m_freemode_01', '{"props":[{"texture":-1,"prop_id":0,"drawable":-1},{"texture":-1,"prop_id":1,"drawable":-1},{"texture":-1,"prop_id":2,"drawable":-1},{"texture":-1,"prop_id":6,"drawable":-1},{"texture":-1,"prop_id":7,"drawable":-1}],"headBlend":{"skinThird":0,"shapeMix":0,"thirdMix":0,"shapeFirst":0,"skinSecond":0,"skinFirst":0,"skinMix":0,"shapeSecond":0,"shapeThird":0},"model":"mp_m_freemode_01","headOverlays":{"blemishes":{"color":0,"opacity":0,"secondColor":0,"style":0},"ageing":{"color":0,"opacity":0,"secondColor":0,"style":0},"lipstick":{"color":0,"opacity":0,"secondColor":0,"style":0},"sunDamage":{"color":0,"opacity":0,"secondColor":0,"style":0},"chestHair":{"color":0,"opacity":0,"secondColor":0,"style":0},"makeUp":{"color":0,"opacity":0,"secondColor":0,"style":0},"eyebrows":{"color":0,"opacity":0,"secondColor":0,"style":0},"blush":{"color":0,"opacity":0,"secondColor":0,"style":0},"moleAndFreckles":{"color":0,"opacity":0,"secondColor":0,"style":0},"beard":{"color":0,"opacity":0,"secondColor":0,"style":0},"bodyBlemishes":{"color":0,"opacity":0,"secondColor":0,"style":0},"complexion":{"color":0,"opacity":0,"secondColor":0,"style":0}},"hair":{"highlight":0,"color":0,"texture":0,"style":0},"eyeColor":0,"components":[{"texture":0,"component_id":0,"drawable":0},{"texture":0,"component_id":1,"drawable":0},{"texture":0,"component_id":2,"drawable":0},{"texture":0,"component_id":3,"drawable":0},{"texture":0,"component_id":4,"drawable":0},{"texture":0,"component_id":5,"drawable":0},{"texture":0,"component_id":6,"drawable":0},{"texture":0,"component_id":7,"drawable":-1},{"texture":0,"component_id":8,"drawable":0},{"texture":0,"component_id":9,"drawable":0},{"texture":0,"component_id":10,"drawable":0},{"texture":0,"component_id":11,"drawable":0}],"faceFeatures":{"nosePeakLowering":0,"eyeBrownHigh":0,"chinBoneLowering":0,"cheeksBoneHigh":0,"chinBoneSize":0,"jawBoneBackSize":0,"eyeBrownForward":0,"neckThickness":0,"nosePeakSize":0,"cheeksWidth":0,"nosePeakHigh":0,"noseBoneTwist":0,"noseBoneHigh":0,"chinBoneLenght":0,"cheeksBoneWidth":0,"eyesOpening":0,"lipsThickness":0,"noseWidth":0,"jawBoneWidth":0,"chinHole":0},"tattoos":[]}', 1);

-- Dumping structure for table freeserver.player_groups
CREATE TABLE IF NOT EXISTS `player_groups` (
  `citizenid` varchar(50) NOT NULL,
  `group` varchar(50) NOT NULL,
  `type` varchar(50) NOT NULL,
  `grade` tinyint(3) unsigned NOT NULL,
  PRIMARY KEY (`citizenid`,`type`,`group`),
  CONSTRAINT `fk_citizenid` FOREIGN KEY (`citizenid`) REFERENCES `players` (`citizenid`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Dumping data for table freeserver.player_groups: ~1 rows (approximately)
INSERT INTO `player_groups` (`citizenid`, `group`, `type`, `grade`) VALUES
	('VIY36885', 'police', 'job', 0);

-- Dumping structure for table freeserver.player_jobs_activity
CREATE TABLE IF NOT EXISTS `player_jobs_activity` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `citizenid` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `job` varchar(255) NOT NULL,
  `last_checkin` int(11) NOT NULL,
  `last_checkout` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  KEY `id` (`id` DESC) USING BTREE,
  KEY `last_checkout` (`last_checkout`) USING BTREE,
  KEY `citizenid_job` (`citizenid`,`job`) USING BTREE,
  CONSTRAINT `player_jobs_activity_ibfk_1` FOREIGN KEY (`citizenid`) REFERENCES `players` (`citizenid`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Dumping data for table freeserver.player_jobs_activity: ~1 rows (approximately)
INSERT INTO `player_jobs_activity` (`id`, `citizenid`, `job`, `last_checkin`, `last_checkout`) VALUES
	(1, 'VIY36885', 'unemployed', 1744551868, 1744554959);

-- Dumping structure for table freeserver.player_mails
CREATE TABLE IF NOT EXISTS `player_mails` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `citizenid` varchar(50) DEFAULT NULL,
  `sender` varchar(50) DEFAULT NULL,
  `subject` varchar(50) DEFAULT NULL,
  `message` text DEFAULT NULL,
  `read` tinyint(4) DEFAULT 0,
  `mailid` int(11) DEFAULT NULL,
  `date` timestamp NULL DEFAULT current_timestamp(),
  `button` text DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `citizenid` (`citizenid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Dumping data for table freeserver.player_mails: ~0 rows (approximately)

-- Dumping structure for table freeserver.player_outfits
CREATE TABLE IF NOT EXISTS `player_outfits` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `citizenid` varchar(50) DEFAULT NULL,
  `outfitname` varchar(50) NOT NULL DEFAULT '0',
  `model` varchar(50) DEFAULT NULL,
  `props` text DEFAULT NULL,
  `components` text DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `citizenid_outfitname_model` (`citizenid`,`outfitname`,`model`),
  KEY `citizenid` (`citizenid`)
) ENGINE=InnoDB AUTO_INCREMENT=26 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Dumping data for table freeserver.player_outfits: ~0 rows (approximately)

-- Dumping structure for table freeserver.player_outfit_codes
CREATE TABLE IF NOT EXISTS `player_outfit_codes` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `outfitid` int(11) NOT NULL,
  `code` varchar(50) NOT NULL DEFAULT '',
  PRIMARY KEY (`id`),
  KEY `FK_player_outfit_codes_player_outfits` (`outfitid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Dumping data for table freeserver.player_outfit_codes: ~0 rows (approximately)

-- Dumping structure for table freeserver.player_transactions
CREATE TABLE IF NOT EXISTS `player_transactions` (
  `id` varchar(50) NOT NULL,
  `isFrozen` int(11) DEFAULT 0,
  `transactions` longtext DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Dumping data for table freeserver.player_transactions: ~0 rows (approximately)

-- Dumping structure for table freeserver.player_vehicles
CREATE TABLE IF NOT EXISTS `player_vehicles` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `license` varchar(50) DEFAULT NULL,
  `citizenid` varchar(50) DEFAULT NULL,
  `vehicle` varchar(50) DEFAULT NULL,
  `hash` varchar(50) DEFAULT NULL,
  `mods` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL,
  `plate` varchar(15) NOT NULL,
  `fakeplate` varchar(50) DEFAULT NULL,
  `garage` varchar(50) DEFAULT NULL,
  `fuel` int(11) DEFAULT 100,
  `engine` float DEFAULT 1000,
  `body` float DEFAULT 1000,
  `state` int(11) DEFAULT 1,
  `depotprice` int(11) NOT NULL DEFAULT 0,
  `drivingdistance` int(50) DEFAULT NULL,
  `status` text DEFAULT NULL,
  `glovebox` longtext DEFAULT NULL,
  `trunk` longtext DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `plate` (`plate`),
  KEY `citizenid` (`citizenid`),
  CONSTRAINT `player_vehicles_ibfk_1` FOREIGN KEY (`citizenid`) REFERENCES `players` (`citizenid`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Dumping data for table freeserver.player_vehicles: ~0 rows (approximately)

-- Dumping structure for table freeserver.properties
CREATE TABLE IF NOT EXISTS `properties` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `property_name` varchar(255) NOT NULL,
  `coords` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL CHECK (json_valid(`coords`)),
  `price` int(11) NOT NULL DEFAULT 0,
  `owner` varchar(50) DEFAULT NULL,
  `interior` varchar(255) NOT NULL,
  `keyholders` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL DEFAULT json_object() CHECK (json_valid(`keyholders`)),
  `rent_interval` int(11) DEFAULT NULL,
  `interact_options` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL DEFAULT json_object() CHECK (json_valid(`interact_options`)),
  `stash_options` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL DEFAULT json_object() CHECK (json_valid(`stash_options`)),
  `garage` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL CHECK (json_valid(`garage`)),
  PRIMARY KEY (`id`),
  KEY `owner` (`owner`),
  CONSTRAINT `properties_ibfk_1` FOREIGN KEY (`owner`) REFERENCES `players` (`citizenid`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Dumping data for table freeserver.properties: ~0 rows (approximately)
INSERT INTO `properties` (`id`, `property_name`, `coords`, `price`, `owner`, `interior`, `keyholders`, `rent_interval`, `interact_options`, `stash_options`, `garage`) VALUES
	(1, 'Del Perro Heights Apt 1', '{"x":-1447.3499755859376,"y":-537.8400268554688,"z":34.7400016784668}', 0, 'VIY36885', 'DellPerroHeightsApt4', '{}', NULL, '[{"coords":{"x":-1454.0799560546876,"y":-553.25,"z":72.83999633789063},"type":"logout"},{"coords":{"x":-1449.8800048828126,"y":-549.25,"z":72.83999633789063},"type":"clothing"},{"coords":{"x":-1453.02001953125,"y":-539.5,"z":74.04000091552735,"w":35.33000183105469},"type":"exit"}]', '[{"coords":{"x":-1466.8299560546876,"y":-527.030029296875,"z":73.44000244140625},"maxWeight":150000,"slots":50}]', NULL);

-- Dumping structure for table freeserver.properties_decorations
CREATE TABLE IF NOT EXISTS `properties_decorations` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `property_id` int(11) NOT NULL,
  `model` varchar(255) NOT NULL,
  `coords` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL CHECK (json_valid(`coords`)),
  `rotation` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL CHECK (json_valid(`rotation`)),
  PRIMARY KEY (`id`),
  KEY `property_id` (`property_id`),
  CONSTRAINT `properties_decorations_ibfk_1` FOREIGN KEY (`property_id`) REFERENCES `properties` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Dumping data for table freeserver.properties_decorations: ~0 rows (approximately)

-- Dumping structure for table freeserver.users
CREATE TABLE IF NOT EXISTS `users` (
  `userId` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `username` varchar(255) DEFAULT NULL,
  `license` varchar(50) DEFAULT NULL,
  `license2` varchar(50) DEFAULT NULL,
  `fivem` varchar(20) DEFAULT NULL,
  `discord` varchar(30) DEFAULT NULL,
  PRIMARY KEY (`userId`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Dumping data for table freeserver.users: ~1 rows (approximately)
INSERT INTO `users` (`userId`, `username`, `license`, `license2`, `fivem`, `discord`) VALUES
	(1, 'Scorpion716', 'license:ce35a45657b7133595440ac7bb6b2c6473b28129', 'license2:ce35a45657b7133595440ac7bb6b2c6473b28129', 'fivem:10371153', 'discord:625338242425815050');

-- Dumping structure for table freeserver.vehicle_financing
CREATE TABLE IF NOT EXISTS `vehicle_financing` (
  `vehicleId` int(11) NOT NULL,
  `balance` int(11) DEFAULT NULL,
  `paymentamount` int(11) DEFAULT NULL,
  `paymentsleft` int(11) DEFAULT NULL,
  `financetime` int(11) DEFAULT NULL,
  PRIMARY KEY (`vehicleId`),
  CONSTRAINT `vehicleId` FOREIGN KEY (`vehicleId`) REFERENCES `player_vehicles` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Dumping data for table freeserver.vehicle_financing: ~0 rows (approximately)

-- Dumping structure for table freeserver.weed_plants
CREATE TABLE IF NOT EXISTS `weed_plants` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `property` varchar(30) DEFAULT NULL,
  `stage` tinyint(4) NOT NULL DEFAULT 1,
  `sort` varchar(30) NOT NULL,
  `gender` enum('male','female') NOT NULL,
  `food` tinyint(4) NOT NULL DEFAULT 100,
  `health` tinyint(4) NOT NULL DEFAULT 100,
  `stageProgress` tinyint(4) NOT NULL DEFAULT 0,
  `coords` tinytext NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_uca1400_ai_ci;

-- Dumping data for table freeserver.weed_plants: ~0 rows (approximately)

-- Dumping structure for table freeserver.xt_prison
CREATE TABLE IF NOT EXISTS `xt_prison` (
  `identifier` varchar(100) NOT NULL,
  `jailtime` int(11) NOT NULL DEFAULT 0,
  PRIMARY KEY (`identifier`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;

-- Dumping data for table freeserver.xt_prison: ~1 rows (approximately)
INSERT INTO `xt_prison` (`identifier`, `jailtime`) VALUES
	('VIY36885', 0);

-- Dumping structure for table freeserver.xt_prison_items
CREATE TABLE IF NOT EXISTS `xt_prison_items` (
  `owner` varchar(60) DEFAULT NULL,
  `data` longtext DEFAULT NULL,
  UNIQUE KEY `owner` (`owner`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;

-- Dumping data for table freeserver.xt_prison_items: ~0 rows (approximately)

/*!40103 SET TIME_ZONE=IFNULL(@OLD_TIME_ZONE, 'system') */;
/*!40101 SET SQL_MODE=IFNULL(@OLD_SQL_MODE, '') */;
/*!40014 SET FOREIGN_KEY_CHECKS=IFNULL(@OLD_FOREIGN_KEY_CHECKS, 1) */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40111 SET SQL_NOTES=IFNULL(@OLD_SQL_NOTES, 1) */;
