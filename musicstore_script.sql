-- MySQL Workbench Forward Engineering

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

-- -----------------------------------------------------
-- Schema mydb
-- -----------------------------------------------------
-- -----------------------------------------------------
-- Schema musicstore
-- -----------------------------------------------------

-- -----------------------------------------------------
-- Schema musicstore
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `musicstore` DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci ;
USE `musicstore` ;

-- -----------------------------------------------------
-- Table `musicstore`.`artist`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `musicstore`.`artist` (
  `artistID` INT NOT NULL,
  `artistStatus` BIT(1) NULL DEFAULT NULL,
  `artistName` VARCHAR(255) NULL DEFAULT NULL,
  `artistDescription` VARCHAR(255) NULL DEFAULT NULL,
  `artistEmail` VARCHAR(100) NULL DEFAULT NULL,
  `artistStreams` INT NULL DEFAULT NULL,
  PRIMARY KEY (`artistID`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `musicstore`.`customer`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `musicstore`.`customer` (
  `customerID` INT NOT NULL,
  `customerStatus` BIT(1) NULL DEFAULT NULL,
  `customerCity` VARCHAR(255) NULL DEFAULT NULL,
  `customerEmail` VARCHAR(255) NULL DEFAULT NULL,
  `customerFirstName` VARCHAR(255) NULL DEFAULT NULL,
  `customerLastName` VARCHAR(255) NULL DEFAULT NULL,
  `customerPhone` VARCHAR(255) NULL DEFAULT NULL,
  `customerAddress` VARCHAR(255) NULL DEFAULT NULL,
  `customerProvince` VARCHAR(255) NULL DEFAULT NULL,
  `customerCountry` VARCHAR(255) NULL DEFAULT NULL,
  PRIMARY KEY (`customerID`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `musicstore`.`order`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `musicstore`.`order` (
  `orderID` INT NOT NULL,
  `orderDate` DATETIME NULL DEFAULT NULL,
  `customerID` INT NULL DEFAULT NULL,
  `quantity` INT NULL DEFAULT NULL,
  PRIMARY KEY (`orderID`),
  INDEX `FK_order_customerID` (`customerID` ASC) VISIBLE,
  CONSTRAINT `FK_order_customerID`
    FOREIGN KEY (`customerID`)
    REFERENCES `musicstore`.`customer` (`customerID`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `musicstore`.`product`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `musicstore`.`product` (
  `productID` INT NOT NULL,
  `productName` VARCHAR(255) NULL DEFAULT NULL,
  `productInStock` BIT(1) NULL DEFAULT NULL,
  `productPrice` FLOAT NULL DEFAULT NULL,
  `productReleaseDate` DATETIME(6) NULL DEFAULT NULL,
  `artistID` INT NULL DEFAULT NULL,
  `orderID` INT NULL DEFAULT NULL,
  `productCategory` VARCHAR(255) NULL DEFAULT NULL,
  `productQuantity` INT NULL DEFAULT NULL,
  `productCost` FLOAT NULL DEFAULT NULL,
  PRIMARY KEY (`productID`),
  INDEX `FK_prodcut_artistID` (`artistID` ASC) VISIBLE,
  INDEX `FK_product_orderID` (`orderID` ASC) VISIBLE,
  CONSTRAINT `FK_prodcut_artistID`
    FOREIGN KEY (`artistID`)
    REFERENCES `musicstore`.`artist` (`artistID`),
  CONSTRAINT `FK_product_orderID`
    FOREIGN KEY (`orderID`)
    REFERENCES `musicstore`.`order` (`orderID`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `musicstore`.`product_type`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `musicstore`.`product_type` (
  `productTypeID` INT NOT NULL,
  `productID` INT NULL DEFAULT NULL,
  PRIMARY KEY (`productTypeID`),
  INDEX `FK_productType_productID` (`productID` ASC) VISIBLE,
  CONSTRAINT `FK_productType_productID`
    FOREIGN KEY (`productID`)
    REFERENCES `musicstore`.`product` (`productID`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `musicstore`.`genres`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `musicstore`.`genres` (
  `genreID` INT NOT NULL,
  `genreName` VARCHAR(255) NULL DEFAULT NULL,
  `productTypeID` INT NULL DEFAULT NULL,
  PRIMARY KEY (`genreID`),
  INDEX `FK_genres_productTypeID` (`productTypeID` ASC) VISIBLE,
  CONSTRAINT `FK_genres_productTypeID`
    FOREIGN KEY (`productTypeID`)
    REFERENCES `musicstore`.`product_type` (`productTypeID`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `musicstore`.`album`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `musicstore`.`album` (
  `albumID` INT NOT NULL,
  `albumName` VARCHAR(255) NULL DEFAULT NULL,
  `genreID` INT NULL DEFAULT NULL,
  `albumCopies` INT NULL DEFAULT NULL,
  `artistID` INT NULL DEFAULT NULL,
  PRIMARY KEY (`albumID`),
  INDEX `FK_album_genreID` (`genreID` ASC) VISIBLE,
  INDEX `FK_album_artistID_idx` (`artistID` ASC) VISIBLE,
  CONSTRAINT `FK_album_artistID`
    FOREIGN KEY (`artistID`)
    REFERENCES `musicstore`.`artist` (`artistID`),
  CONSTRAINT `FK_album_genreID`
    FOREIGN KEY (`genreID`)
    REFERENCES `musicstore`.`genres` (`genreID`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;

USE `musicstore` ;

-- -----------------------------------------------------
-- procedure GetAllProducts
-- -----------------------------------------------------

DELIMITER $$
USE `musicstore`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `GetAllProducts`()
BEGIN
	SELECT *  FROM musicstore.product;
END$$

DELIMITER ;
USE `musicstore`;

DELIMITER $$
USE `musicstore`$$
CREATE
DEFINER=`root`@`localhost`
TRIGGER `musicstore`.`before_product_insert`
BEFORE INSERT ON `musicstore`.`product`
FOR EACH ROW
BEGIN
 SET new.productReleaseDate = NOW();
 SET new.productCost = new.productQuantity * new.productPrice;
END$$


DELIMITER ;

SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
