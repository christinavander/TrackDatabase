-- MySQL Workbench Forward Engineering

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

-- -----------------------------------------------------
-- Schema mydb
-- -----------------------------------------------------
-- -----------------------------------------------------
-- Schema dbvanderwerftrack
-- -----------------------------------------------------
DROP SCHEMA IF EXISTS `dbvanderwerftrack` ;

-- -----------------------------------------------------
-- Schema dbvanderwerftrack
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `dbvanderwerftrack` DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci ;
USE `dbvanderwerftrack` ;

-- -----------------------------------------------------
-- Table `dbvanderwerftrack`.`schools`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `dbvanderwerftrack`.`schools` ;

CREATE TABLE IF NOT EXISTS `dbvanderwerftrack`.`schools` (
  `Id` INT NOT NULL,
  `Name` VARCHAR(20) NOT NULL,
  `Points` INT NULL DEFAULT NULL,
  PRIMARY KEY (`Id`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `dbvanderwerftrack`.`athletes`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `dbvanderwerftrack`.`athletes` ;

CREATE TABLE IF NOT EXISTS `dbvanderwerftrack`.`athletes` (
  `competitorNumber` INT NOT NULL,
  `athleteName` VARCHAR(20) NOT NULL,
  `gender` ENUM('m', 'f') NULL DEFAULT NULL,
  `schoolId` INT NOT NULL,
  PRIMARY KEY (`competitorNumber`, `athleteName`, `schoolId`),
  INDEX `schoolId` (`schoolId` ASC) VISIBLE,
  CONSTRAINT `athletes_ibfk_1`
    FOREIGN KEY (`schoolId`)
    REFERENCES `dbvanderwerftrack`.`schools` (`Id`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `dbvanderwerftrack`.`events`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `dbvanderwerftrack`.`events` ;

CREATE TABLE IF NOT EXISTS `dbvanderwerftrack`.`events` (
  `Id` INT NOT NULL,
  `eventName` VARCHAR(20) NULL DEFAULT NULL,
  `type` ENUM('Track', 'Field') NULL DEFAULT NULL,
  PRIMARY KEY (`Id`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `dbvanderwerftrack`.`messages`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `dbvanderwerftrack`.`messages` ;

CREATE TABLE IF NOT EXISTS `dbvanderwerftrack`.`messages` (
  `Date` DATE NULL DEFAULT NULL,
  `Time` TIME NULL DEFAULT NULL,
  `Message` VARCHAR(255) NULL DEFAULT NULL,
  `Student` INT NULL DEFAULT NULL,
  INDEX `Student` (`Student` ASC) VISIBLE,
  CONSTRAINT `messages_ibfk_1`
    FOREIGN KEY (`Student`)
    REFERENCES `dbvanderwerftrack`.`athletes` (`competitorNumber`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `dbvanderwerftrack`.`results`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `dbvanderwerftrack`.`results` ;

CREATE TABLE IF NOT EXISTS `dbvanderwerftrack`.`results` (
  `compNumber` INT NOT NULL,
  `gender` ENUM('m', 'f') NULL DEFAULT NULL,
  `points` INT NULL DEFAULT NULL,
  `disqualified` ENUM('yes', 'no') NULL DEFAULT NULL,
  `place` INT NULL DEFAULT NULL,
  `time` DECIMAL(10,2) NULL DEFAULT NULL,
  `distance` DECIMAL(10,2) NULL DEFAULT NULL,
  `eventId` INT NOT NULL,
  `schoolId` INT NULL DEFAULT NULL,
  PRIMARY KEY (`compNumber`, `eventId`),
  INDEX `eventId` (`eventId` ASC) VISIBLE,
  INDEX `schoolId` (`schoolId` ASC) VISIBLE,
  CONSTRAINT `results_ibfk_1`
    FOREIGN KEY (`compNumber`)
    REFERENCES `dbvanderwerftrack`.`athletes` (`competitorNumber`),
  CONSTRAINT `results_ibfk_2`
    FOREIGN KEY (`eventId`)
    REFERENCES `dbvanderwerftrack`.`events` (`Id`),
  CONSTRAINT `results_ibfk_3`
    FOREIGN KEY (`schoolId`)
    REFERENCES `dbvanderwerftrack`.`schools` (`Id`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;

USE `dbvanderwerftrack`;

DELIMITER $$

USE `dbvanderwerftrack`$$
DROP TRIGGER IF EXISTS `dbvanderwerftrack`.`unknownDisqual` $$
USE `dbvanderwerftrack`$$
CREATE
DEFINER=`root`@`localhost`
TRIGGER `dbvanderwerftrack`.`unknownDisqual`
AFTER INSERT ON `dbvanderwerftrack`.`results`
FOR EACH ROW
begin 

    if NEW.disqualified IS NULL then 

             insert into messages values (CURDATE(), CURTIME(), 'Were they disqualified?', NEW.compNumber); 

      end if; 

     end$$


DELIMITER ;

SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;


insert into schools values (1, "Columbia High"); 
insert into schools values (2, "Portland High"); 
insert into schools values (3, "Win Academy"); 
insert into schools values (4, "Foothill High School"); 
insert into schools values (5, "River Valley School"); 


insert into events values (1, '100m Sprint', ‘Track’); 
insert into events values (2, '200m Dash', 'Track'); 
insert into events values (3, '800m Run', 'Track');  
insert into events values (4, '100m Hurdles', 'Track'); 
insert into events values (5, 'Long Jump', 'Field'); 
insert into events values (6, 'High Jump', 'Field'); 
insert into events values (7, 'Javelin Throw', 'Field'); 
insert into events values (8, 'Shot Put', 'Field'); 


insert into athletes values (1, 'Adam Smith', 'm', 1); 
insert into athletes values (2, 'Christina Vanderwerf', 'f', 1); 
insert into athletes values (3, 'Drew Anderson', 'm', 2); 
insert into athletes values (4, 'Sarah Johnson', 'f', 2); 
insert into athletes values (5, 'Eli Brown', 'm', 3); 
insert into athletes values (6, 'Mary Davis', 'f', 3); 
insert into athletes values (7, 'Thomas White', 'm', 4); 
insert into athletes values (8, 'Ashley Clark', 'f', 4); 
insert into athletes values (9, 'Anthony Lewis', 'm', 5); 
insert into athletes values (10, 'Amy Hall', 'f', 5); 


insert into results values (2, 'f', 6, 'No', 3, 13.00, NULL, 1, 1); 
insert into results values (4, 'f', 10, 'No', 1, 11.25, NULL, 1, 2); 
insert into results values (6, 'f', 8, NULL, 2, 12.5, NULL, 1, 3); 
insert into results values (8, 'f', NULL, 'Yes', NULL, NULL, NULL, 1, 4);

insert into results values ( 1, 'm', 5, 'no', 4, 13.4, NULL, 1, 1); 
insert into results values ( 3, 'm', 6, 'no', 3, 13.1, NULL, 1, 2); 
insert into results values (5, 'm', 8, 'no', 2, 12.85, NULL, 1, 3); 
insert into results values (7, 'm', 10, 'no', 1, 12.80, NULL, 1, 4); 

insert into results values (8, 'f', 6, 'no', 3, 26.22, NULL, 2, 4); 
insert into results values (10, 'f', 8, 'no', 2, 25.13, NULL, 2, 5); 
insert into results values (6, 'f', 5, 'no', 4, 26.33, NULL, 2, 3); 
insert into results values (4, 'f', 10, 'no', 1, 24.99, NULL, 2, 2);

insert into results values (9, 'm', NULL, 'yes', NULL, NULL, NULL, 2, 5); 
insert into results values (3, 'm', 10, NULL, 1, 27.12, NULL, 2, 2); 
insert into results values (1, 'm', 8, 'no', 2, 27.54, NULL, 3, 1); 


insert into results values (2, 'f', 6, 'no', 3, 200.05, NULL, 3, 1); 
insert into results values (10, 'f', 10, 'no', 1, 198.2, NULL, 3, 5); 
insert into results values (4, 'f', 8, 'no', 2, 199.73, NULL, 3, 2); 

insert into results values (5, 'm', 10, 'no', 1, 197.64, NULL, 3, 3); 
insert into results values (7, 'm', 8, 'no', 2, 197.98, NULL, 3, 4); 
insert into results values (9, 'm', 6, 'no', 3, 199.32, NULL, 3, 5); 

insert into results values (2, 'f', 8, 'no', 2, 12.7, NULL, 4, 1); 
insert into results values (6, 'f', 10, 'no', 1, 12.68, NULL, 4, 3); 
insert into results values (8, 'f', 6, 'no', 3, 13.02, NULL, 4, 4); 
insert into results values (10, 'f', 5, 'no', 4, 13.17, NULL, 4, 5); 
insert into results values (4, 'f', NULL, 'yes', NULL, NULL, NULL, 4, 2); 

insert into results values (1, 'm', 4, 'no', 5, NULL, 291, 5, 1); 
insert into results values (3, 'm', 10, 'no', 1, NULL, 294, 5, 2); 
insert into results values (5, 'm', 6, 'no', 3, NULL, 292.6, 5, 3); 
insert into results values (7, 'm', 5, 'no', 4, NULL, 292.1, 5, 4); 
insert into results values (9, 'm', 8, 'no', 2, NULL, 293.5, 5, 5); 

insert into results values (2, 'f', 8, 'no', 2, NULL, 73.9, 6, 1); 
insert into results values (4, 'f', 10, 'no', 1, NULL, 74, 6, 2); 
insert into results values (8, 'f', 6, 'no', 3, NULL, 73.5, 6, 4); 
insert into results values (10, 'f', 5, 'no', 4, NULL, 71, 6, 5); 

insert into results values (6, 'f', 10, 'no', 1, NULL, 88.5, 7, 3); 
insert into results values (10, 'f', 8, 'no', 2, NULL, 87, 7, 5); 
insert into results values (2, 'f', 6, 'no', 3, NULL, 82, 7, 1); 

insert into results values (1, 'm', 6, 'no', 3, NULL, 1548, 8, 1); 
insert into results values (3, 'm', 10, 'no', 1, NULL, 1549, 8, 2); 
insert into results values (7, 'm', 8, 'no', 2, NULL, 1548.5, 8, 4); 
insert into results values (9, 'm', NULL, 'yes', NULL, NULL, NULL, 8, 5); 