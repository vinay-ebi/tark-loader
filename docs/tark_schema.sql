-- MySQL Script generated by MySQL Workbench
-- Tue 07 Mar 2017 11:42:24 GMT
-- Model: New Model    Version: 1.0
-- MySQL Workbench Forward Engineering

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='TRADITIONAL,ALLOW_INVALID_DATES';

-- -----------------------------------------------------
-- Schema tark
-- -----------------------------------------------------

-- -----------------------------------------------------
-- Table `session`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `session` ;

CREATE TABLE IF NOT EXISTS `session` (
  `session_id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `client_id` VARCHAR(128) NULL,
  `start_date` DATETIME NULL,
  `status` VARCHAR(45) NULL,
  PRIMARY KEY (`session_id`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `genome`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `genome` ;

CREATE TABLE IF NOT EXISTS `genome` (
  `genome_id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(128) NULL,
  `tax_id` INT(10) UNSIGNED NULL,
  `session_id` INT(10) UNSIGNED NULL,
  PRIMARY KEY (`genome_id`),
  CONSTRAINT `fk_genome_1`
    FOREIGN KEY (`session_id`)
    REFERENCES `session` (`session_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

CREATE INDEX `fk_genome_1_idx` ON `genome` (`session_id` ASC);

CREATE UNIQUE INDEX `genome_idx` ON `genome` (`name` ASC, `tax_id` ASC);


-- -----------------------------------------------------
-- Table `assembly`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `assembly` ;

CREATE TABLE IF NOT EXISTS `assembly` (
  `assembly_id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `genome_id` INT UNSIGNED NULL,
  `assembly_name` VARCHAR(128) NULL,
  `session_id` INT UNSIGNED NULL,
  PRIMARY KEY (`assembly_id`),
  CONSTRAINT `fk_assembly_1`
    FOREIGN KEY (`genome_id`)
    REFERENCES `genome` (`genome_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_assembly_2`
    FOREIGN KEY (`session_id`)
    REFERENCES `session` (`session_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

CREATE INDEX `fk_assembly_1_idx` ON `assembly` (`genome_id` ASC);

CREATE INDEX `fk_assembly_2_idx` ON `assembly` (`session_id` ASC);

CREATE UNIQUE INDEX `assembly_idx` ON `assembly` (`assembly_name` ASC);


-- -----------------------------------------------------
-- Table `gene_names`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `gene_names` ;

CREATE TABLE IF NOT EXISTS `gene_names` (
  `gene_names_id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `external_id` INT UNSIGNED NULL,
  `name` VARCHAR(32) NULL,
  `source` VARCHAR(32) NULL,
  `primary_id` TINYINT(1) NULL,
  `session_id` INT UNSIGNED NULL,
  PRIMARY KEY (`gene_names_id`),
  CONSTRAINT `fk_gene_names_3`
    FOREIGN KEY (`session_id`)
    REFERENCES `session` (`session_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_gene_3`
    FOREIGN KEY (`external_id`)
    REFERENCES `gene` (`hgnc_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

CREATE INDEX `name_idx` ON `gene_names` (`name` ASC);

CREATE INDEX `external_id_idx` ON `gene_names` (`external_id` ASC);

CREATE INDEX `source_idx` ON `gene_names` (`source` ASC);

CREATE INDEX `fk_gene_names_3_idx` ON `gene_names` (`session_id` ASC);


-- -----------------------------------------------------
-- Table `gene`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `gene` ;

CREATE TABLE IF NOT EXISTS `gene` (
  `gene_id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `stable_id` VARCHAR(64) NOT NULL,
  `stable_id_version` TINYINT UNSIGNED NOT NULL,
  `assembly_id` INT UNSIGNED NULL,
  `loc_start` INT UNSIGNED NULL,
  `loc_end` INT UNSIGNED NULL,
  `loc_strand` TINYINT NULL,
  `loc_region` VARCHAR(42) NULL,
  `loc_checksum` BINARY(20) NULL,
  `hgnc_id` INT UNSIGNED NULL DEFAULT NULL,
  `gene_checksum` BINARY(20) NULL,
  `session_id` INT UNSIGNED NULL,
  PRIMARY KEY (`gene_id`),
  CONSTRAINT `fk_gene_1`
    FOREIGN KEY (`assembly_id`)
    REFERENCES `assembly` (`assembly_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_gene_2`
    FOREIGN KEY (`session_id`)
    REFERENCES `session` (`session_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

CREATE INDEX `fk_gene_1_idx` ON `gene` (`assembly_id` ASC);

CREATE INDEX `stable_id` ON `gene` (`stable_id` ASC, `stable_id_version` ASC);

CREATE INDEX `fk_gene_2_idx` ON `gene` (`session_id` ASC);

CREATE UNIQUE INDEX `gene_checksum_idx` ON `gene` (`gene_checksum` ASC);

CREATE INDEX `fk_gene_3_idx` ON `gene` (`hgnc_id` ASC);


-- -----------------------------------------------------
-- Table `sequence`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `sequence` ;

CREATE TABLE IF NOT EXISTS `sequence` (
  `seq_checksum` BINARY(20) NOT NULL,
  `sequence` LONGTEXT NULL,
  `session_id` INT UNSIGNED NULL,
  PRIMARY KEY (`seq_checksum`),
  CONSTRAINT `fk_sequence_1`
    FOREIGN KEY (`session_id`)
    REFERENCES `session` (`session_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

CREATE INDEX `fk_sequence_1_idx` ON `sequence` (`session_id` ASC);


-- -----------------------------------------------------
-- Table `transcript`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `transcript` ;

CREATE TABLE IF NOT EXISTS `transcript` (
  `transcript_id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `stable_id` VARCHAR(64) NOT NULL,
  `stable_id_version` TINYINT UNSIGNED NOT NULL,
  `assembly_id` INT UNSIGNED NULL,
  `loc_start` INT UNSIGNED NULL,
  `loc_end` INT UNSIGNED NULL,
  `loc_strand` TINYINT NULL,
  `loc_region` VARCHAR(42) NULL,
  `loc_checksum` BINARY(20) NULL,
  `exon_set_checksum` BINARY(20) NULL,
  `transcript_checksum` BINARY(20) NULL,
  `seq_checksum` BINARY(20) NULL,
  `session_id` INT UNSIGNED NULL,
  PRIMARY KEY (`transcript_id`),
  CONSTRAINT `fk_transcript_1`
    FOREIGN KEY (`assembly_id`)
    REFERENCES `assembly` (`assembly_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_transcript_2`
    FOREIGN KEY (`session_id`)
    REFERENCES `session` (`session_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_transcript_3`
    FOREIGN KEY (`seq_checksum`)
    REFERENCES `sequence` (`seq_checksum`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
COMMENT = 'loc_str includes sets of exon start-stop locations: 1000,200' /* comment truncated */ /*0,4000,5000*/;

CREATE INDEX `fk_transcript_2_idx` ON `transcript` (`session_id` ASC);

CREATE UNIQUE INDEX `transcript_chk` ON `transcript` (`transcript_checksum` ASC);

CREATE INDEX `fk_transcript_3_idx` ON `transcript` (`seq_checksum` ASC);

CREATE INDEX `fk_transcript_1_idx` ON `transcript` (`assembly_id` ASC);

CREATE INDEX `stable_id_version` ON `transcript` (`stable_id` ASC, `stable_id_version` ASC);


-- -----------------------------------------------------
-- Table `exon`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `exon` ;

CREATE TABLE IF NOT EXISTS `exon` (
  `exon_id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `stable_id` VARCHAR(64) NOT NULL,
  `stable_id_version` TINYINT UNSIGNED NOT NULL,
  `assembly_id` INT UNSIGNED NULL,
  `loc_start` INT UNSIGNED NULL,
  `loc_end` INT UNSIGNED NULL,
  `loc_strand` TINYINT NULL,
  `loc_region` VARCHAR(42) NULL,
  `loc_checksum` BINARY(20) NULL,
  `exon_checksum` BINARY(20) NULL,
  `seq_checksum` BINARY(20) NULL,
  `session_id` INT UNSIGNED NULL,
  PRIMARY KEY (`exon_id`),
  CONSTRAINT `fk_exon_1`
    FOREIGN KEY (`assembly_id`)
    REFERENCES `assembly` (`assembly_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_exon_2`
    FOREIGN KEY (`session_id`)
    REFERENCES `session` (`session_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_exon_3`
    FOREIGN KEY (`seq_checksum`)
    REFERENCES `sequence` (`seq_checksum`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

CREATE INDEX `fk_exon_2_idx` ON `exon` (`session_id` ASC);

CREATE UNIQUE INDEX `exon_chk` ON `exon` (`exon_checksum` ASC);

CREATE INDEX `fk_exon_3_idx` ON `exon` (`seq_checksum` ASC);

CREATE INDEX `fk_exon_1_idx` ON `exon` (`assembly_id` ASC);

CREATE INDEX `stable_id_version` ON `exon` (`stable_id` ASC, `stable_id_version` ASC);


-- -----------------------------------------------------
-- Table `translation`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `translation` ;

CREATE TABLE IF NOT EXISTS `translation` (
  `translation_id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `stable_id` VARCHAR(64) NOT NULL,
  `stable_id_version` TINYINT UNSIGNED NOT NULL,
  `assembly_id` INT UNSIGNED NULL,
  `loc_start` INT UNSIGNED NULL,
  `loc_end` INT UNSIGNED NULL,
  `loc_strand` TINYINT NULL,
  `loc_region` VARCHAR(42) NULL,
  `loc_checksum` BINARY(20) NULL,
  `translation_checksum` BINARY(20) NULL,
  `seq_checksum` BINARY(20) NULL,
  `session_id` INT UNSIGNED NULL,
  PRIMARY KEY (`translation_id`),
  CONSTRAINT `fk_translation_1`
    FOREIGN KEY (`assembly_id`)
    REFERENCES `assembly` (`assembly_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_translation_2`
    FOREIGN KEY (`session_id`)
    REFERENCES `session` (`session_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_translation_3`
    FOREIGN KEY (`seq_checksum`)
    REFERENCES `sequence` (`seq_checksum`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

CREATE INDEX `fk_translation_2_idx` ON `translation` (`session_id` ASC);

CREATE INDEX `fk_translation_3_idx` ON `translation` (`seq_checksum` ASC);

CREATE INDEX `fk_translation_1_idx` ON `translation` (`assembly_id` ASC);

CREATE INDEX `stable_id_version` ON `translation` (`stable_id` ASC, `stable_id_version` ASC);

CREATE UNIQUE INDEX `translation_chk` ON `translation` (`translation_checksum` ASC);


-- -----------------------------------------------------
-- Table `tagset`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `tagset` ;

CREATE TABLE IF NOT EXISTS `tagset` (
  `tagset_id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `shortname` VARCHAR(45) NULL,
  `description` VARCHAR(255) NULL,
  `version` VARCHAR(20) NULL DEFAULT '1',
  `is_current` TINYINT(1) NULL,
  `session_id` INT UNSIGNED NULL,
  `tagset_checksum` BINARY(20) NULL,
  PRIMARY KEY (`tagset_id`),
  CONSTRAINT `fk_Tagset_1`
    FOREIGN KEY (`session_id`)
    REFERENCES `session` (`session_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

CREATE UNIQUE INDEX `name_version_idx` ON `tagset` (`shortname` ASC, `version` ASC);

CREATE INDEX `fk_Tagset_1_idx` ON `tagset` (`session_id` ASC);

CREATE INDEX `short_name_idx` ON `tagset` (`shortname` ASC);


-- -----------------------------------------------------
-- Table `tag`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `tag` ;

CREATE TABLE IF NOT EXISTS `tag` (
  `transcript_id` INT UNSIGNED NOT NULL,
  `tagset_id` INT UNSIGNED NOT NULL,
  `session_id` INT UNSIGNED NULL,
  PRIMARY KEY (`transcript_id`, `tagset_id`),
  CONSTRAINT `fk_Tag_1`
    FOREIGN KEY (`tagset_id`)
    REFERENCES `tagset` (`tagset_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Tag_2`
    FOREIGN KEY (`session_id`)
    REFERENCES `session` (`session_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Tag_3`
    FOREIGN KEY (`transcript_id`)
    REFERENCES `transcript` (`transcript_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

CREATE INDEX `transcript_id` ON `tag` (`transcript_id` ASC);

CREATE INDEX `fk_Tag_2_idx` ON `tag` (`session_id` ASC);

-- -----------------------------------------------------
-- Table `release_source`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `release_source` ;

CREATE TABLE IF NOT EXISTS `release_source` (
  `source_id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `shortname` VARCHAR(24) NULL,
  `description` VARCHAR(256) NULL,
  PRIMARY KEY (`source_id`)
  )
ENGINE = InnoDB;

CREATE UNIQUE INDEX `shortname_idx` ON `release_source` (`shortname` ASC);

INSERT INTO release_source(`shortname`, `description`) VALUES ('Ensembl', 'Ensembl data imports from Human Core DBs');
INSERT INTO release_source(`shortname`, `description`) VALUES ('RefSeq', 'RefSeq data imports from Human otherfeatures DBs');

-- -----------------------------------------------------
-- Table `release_set`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `release_set` ;

CREATE TABLE IF NOT EXISTS `release_set` (
  `release_id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `shortname` VARCHAR(24) NULL,
  `description` VARCHAR(256) NULL,
  `assembly_id` INT UNSIGNED NULL,
  `release_date` DATE NULL,
  `session_id` INT UNSIGNED NULL,
  `release_checksum` BINARY(20) NULL,
  `source_id` INT UNSIGNED NULL,
  PRIMARY KEY (`release_id`),
  CONSTRAINT `fk_release_1`
    FOREIGN KEY (`assembly_id`)
    REFERENCES `assembly` (`assembly_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_release_2`
    FOREIGN KEY (`session_id`)
    REFERENCES `session` (`session_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_release_3`
    FOREIGN KEY (`source_id`)
    REFERENCES `release_source` (`source_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

CREATE UNIQUE INDEX `shortname_assembly_source_idx` ON `release_set` (`shortname` ASC, `assembly_id` ASC, `source_id` ASC);

CREATE INDEX `fk_release_1_idx` ON `release_set` (`assembly_id` ASC);

CREATE INDEX `fk_release_2_idx` ON `release_set` (`session_id` ASC);

CREATE INDEX `fk_release_3_idx` ON `release_set` (`source_id` ASC);

-- -----------------------------------------------------
-- Table `release_tag`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `release_tag` ;

CREATE TABLE IF NOT EXISTS `release_tag` (
  `feature_id` INT UNSIGNED NOT NULL,
  `feature_type` TINYINT UNSIGNED NOT NULL,
  `release_id` INT UNSIGNED NOT NULL,
  `session_id` INT UNSIGNED NULL,
  PRIMARY KEY (`feature_id`, `feature_type`, `release_id`),
  CONSTRAINT `fk_release_tag_1`
    FOREIGN KEY (`release_id`)
    REFERENCES `release_set` (`release_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_release_tag_2`
    FOREIGN KEY (`session_id`)
    REFERENCES `session` (`session_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

CREATE INDEX `fk_release_tag_1_idx` ON `release_tag` (`release_id` ASC);

CREATE INDEX `fk_release_tag_2_idx` ON `release_tag` (`session_id` ASC);


-- -----------------------------------------------------
-- Table `operon`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `operon` ;

CREATE TABLE IF NOT EXISTS `operon` (
  `operon_id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `stable_id` VARCHAR(64) NULL,
  `stable_id_version` TINYINT UNSIGNED NULL,
  `assembly_id` INT UNSIGNED NULL,
  `loc_start` INT UNSIGNED NULL,
  `loc_end` INT UNSIGNED NULL,
  `loc_strand` TINYINT NULL,
  `loc_region` VARCHAR(42) NULL,
  `operon_checksum` BINARY(20) NULL,
  `seq_checksum` BINARY(20) NULL,
  `session_id` INT UNSIGNED NULL,
  PRIMARY KEY (`operon_id`),
  CONSTRAINT `fk_operon_1`
    FOREIGN KEY (`assembly_id`)
    REFERENCES `assembly` (`assembly_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_operon_2`
    FOREIGN KEY (`seq_checksum`)
    REFERENCES `sequence` (`seq_checksum`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_operon_3`
    FOREIGN KEY (`session_id`)
    REFERENCES `session` (`session_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

CREATE INDEX `stable_id_version_idx` ON `operon` (`stable_id` ASC, `stable_id_version` ASC);

CREATE INDEX `fk_operon_1_idx` ON `operon` (`assembly_id` ASC);

CREATE INDEX `fk_operon_2_idx` ON `operon` (`seq_checksum` ASC);

CREATE INDEX `fk_operon_3_idx` ON `operon` (`session_id` ASC);


-- -----------------------------------------------------
-- Table `operon_transcript`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `operon_transcript` ;

CREATE TABLE IF NOT EXISTS `operon_transcript` (
  `operon_transcript_id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `stable_id` VARCHAR(64) NULL,
  `stable_id_version` INT UNSIGNED NULL,
  `operon_id` INT UNSIGNED NULL,
  `transcript_id` INT UNSIGNED NULL,
  `session_id` INT UNSIGNED NULL,
  PRIMARY KEY (`operon_transcript_id`),
  CONSTRAINT `fk_operon_transcript_1`
    FOREIGN KEY (`operon_id`)
    REFERENCES `operon` (`operon_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_operon_transcript_2`
    FOREIGN KEY (`transcript_id`)
    REFERENCES `transcript` (`transcript_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_operon_transcript_3`
    FOREIGN KEY (`session_id`)
    REFERENCES `session` (`session_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

CREATE INDEX `stable_id_version_idx` ON `operon_transcript` (`stable_id` ASC, `stable_id_version` ASC);

CREATE INDEX `fk_operon_transcript_1_idx` ON `operon_transcript` (`operon_id` ASC);

CREATE INDEX `fk_operon_transcript_2_idx` ON `operon_transcript` (`transcript_id` ASC);

CREATE INDEX `fk_operon_transcript_3_idx` ON `operon_transcript` (`session_id` ASC);

CREATE UNIQUE INDEX `operon_transcript_idx` ON `operon_transcript` (`operon_id` ASC, `transcript_id` ASC);


-- -----------------------------------------------------
-- Table `exon_transcript`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `exon_transcript` ;

CREATE TABLE IF NOT EXISTS `exon_transcript` (
  `exon_transcript_id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `transcript_id` INT UNSIGNED NULL,
  `exon_id` INT UNSIGNED NULL,
  `exon_order` SMALLINT UNSIGNED NULL,
  `session_id` INT UNSIGNED NULL,
  PRIMARY KEY (`exon_transcript_id`),
  CONSTRAINT `fk_exon_transcript_1`
    FOREIGN KEY (`transcript_id`)
    REFERENCES `transcript` (`transcript_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_exon_transcript_2`
    FOREIGN KEY (`exon_id`)
    REFERENCES `exon` (`exon_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_exon_transcript_3`
    FOREIGN KEY (`session_id`)
    REFERENCES `session` (`session_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

CREATE INDEX `fk_exon_transcript_1_idx` ON `exon_transcript` (`transcript_id` ASC);

CREATE INDEX `fk_exon_transcript_2_idx` ON `exon_transcript` (`exon_id` ASC);

CREATE INDEX `fk_exon_transcript_3_idx` ON `exon_transcript` (`session_id` ASC);

CREATE UNIQUE INDEX `transcript_exon_idx` ON `exon_transcript` (`transcript_id` ASC, `exon_id` ASC);


-- -----------------------------------------------------
-- Table `assembly_alias`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `assembly_alias` ;

CREATE TABLE IF NOT EXISTS `assembly_alias` (
  `assembly_alias_id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `alias` VARCHAR(64) NULL,
  `genome_id` INT UNSIGNED NULL,
  `assembly_id` INT UNSIGNED NULL,
  `session_id` INT UNSIGNED NULL,
  PRIMARY KEY (`assembly_alias_id`),
  CONSTRAINT `fk_assembly_alias_1`
    FOREIGN KEY (`assembly_id`)
    REFERENCES `assembly` (`assembly_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_assembly_alias_2`
    FOREIGN KEY (`session_id`)
    REFERENCES `session` (`session_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_assembly_alias_3`
    FOREIGN KEY (`genome_id`)
    REFERENCES `genome` (`genome_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

CREATE UNIQUE INDEX `alias_idx` ON `assembly_alias` (`alias` ASC);

CREATE INDEX `fk_assembly_alias_1_idx` ON `assembly_alias` (`assembly_id` ASC);

CREATE INDEX `fk_assembly_alias_2_idx` ON `assembly_alias` (`session_id` ASC);

CREATE INDEX `fk_assembly_alias_3_idx` ON `assembly_alias` (`genome_id` ASC);


-- -----------------------------------------------------
-- Table `transcript_gene`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `transcript_gene` ;

CREATE TABLE IF NOT EXISTS `transcript_gene` (
  `gene_transcript_id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `gene_id` INT UNSIGNED NULL,
  `transcript_id` INT UNSIGNED NULL,
  `session_id` INT UNSIGNED NULL,
  PRIMARY KEY (`gene_transcript_id`),
  CONSTRAINT `fk_transcript_gene_1`
    FOREIGN KEY (`gene_id`)
    REFERENCES `gene` (`gene_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_transcript_gene_2`
    FOREIGN KEY (`transcript_id`)
    REFERENCES `transcript` (`transcript_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_transcript_gene_3`
    FOREIGN KEY (`session_id`)
    REFERENCES `session` (`session_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

CREATE INDEX `fk_transcript_gene_1_idx` ON `transcript_gene` (`gene_id` ASC);

CREATE INDEX `fk_transcript_gene_2_idx` ON `transcript_gene` (`transcript_id` ASC);

CREATE UNIQUE INDEX `transcript_gene_idx` ON `transcript_gene` (`gene_id` ASC, `transcript_id` ASC);

CREATE INDEX `fk_transcript_gene_3_idx` ON `transcript_gene` (`session_id` ASC);


-- -----------------------------------------------------
-- Table `translation_transcript`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `translation_transcript` ;

CREATE TABLE IF NOT EXISTS `translation_transcript` (
  `transcript_translation_id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `transcript_id` INT UNSIGNED NULL,
  `translation_id` INT UNSIGNED NULL,
  `session_id` INT UNSIGNED NULL,
  PRIMARY KEY (`transcript_translation_id`),
  CONSTRAINT `fk_translation_transcript_1`
    FOREIGN KEY (`transcript_id`)
    REFERENCES `transcript` (`transcript_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_translation_transcript_2`
    FOREIGN KEY (`translation_id`)
    REFERENCES `translation` (`translation_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_translation_transcript_3`
    FOREIGN KEY (`session_id`)
    REFERENCES `session` (`session_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

CREATE INDEX `fk_translation_transcript_1_idx` ON `translation_transcript` (`transcript_id` ASC);

CREATE INDEX `fk_translation_transcript_2_idx` ON `translation_transcript` (`translation_id` ASC);

CREATE INDEX `fk_translation_transcript_3_idx` ON `translation_transcript` (`session_id` ASC);

CREATE UNIQUE INDEX `transcript_translation_idx` ON `translation_transcript` (`transcript_id` ASC, `translation_id` ASC);

-- -----------------------------------------------------
-- Table `gene_release_tag`
-- -----------------------------------------------------

CREATE TABLE `gene_release_tag` (
 `feature_id` int(10) unsigned NOT NULL,
 `release_id` int(10) unsigned NOT NULL,
 `session_id` INT UNSIGNED NULL,
  PRIMARY KEY (`feature_id`,`release_id`),
  CONSTRAINT `fk_gene_release_tag_1` FOREIGN KEY (`feature_id`) REFERENCES `gene` (`gene_id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `fk_gene_release_tag_2` FOREIGN KEY (`release_id`) REFERENCES `release_set` (`release_id`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE INDEX `fk_gene_release_tag_1_idx` ON `gene_release_tag` (`feature_id` ASC);
CREATE INDEX `fk_gene_release_tag_2_idx` ON `gene_release_tag` (`release_id` ASC);

-- -----------------------------------------------------
-- Table `transcript_release_tag`
-- -----------------------------------------------------

CREATE TABLE `transcript_release_tag` (
 `feature_id` int(10) unsigned NOT NULL,
 `release_id` int(10) unsigned NOT NULL,
 `session_id` INT UNSIGNED NULL,
  PRIMARY KEY (`feature_id`,`release_id`),
  CONSTRAINT `fk_transcript_release_tag_1` FOREIGN KEY (`feature_id`) REFERENCES `transcript` (`transcript_id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `fk_transcript_release_tag_2` FOREIGN KEY (`release_id`) REFERENCES `release_set` (`release_id`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE INDEX `fk_transcript_release_tag_1_idx` ON `transcript_release_tag` (`feature_id` ASC);
CREATE INDEX `fk_transcript_release_tag_2_idx` ON `transcript_release_tag` (`release_id` ASC);

-- -----------------------------------------------------
-- Table `translation_release_tag`
-- -----------------------------------------------------

CREATE TABLE `translation_release_tag` (
 `feature_id` int(10) unsigned NOT NULL,
 `release_id` int(10) unsigned NOT NULL,
 `session_id` INT UNSIGNED NULL,
  PRIMARY KEY (`feature_id`,`release_id`),
  CONSTRAINT `fk_translation_release_tag_1` FOREIGN KEY (`feature_id`) REFERENCES `translation` (`translation_id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `fk_translation_release_tag_2` FOREIGN KEY (`release_id`) REFERENCES `release_set` (`release_id`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE INDEX `fk_translation_release_tag_1_idx` ON `translation_release_tag` (`feature_id` ASC);
CREATE INDEX `fk_translation_release_tag_2_idx` ON `translation_release_tag` (`release_id` ASC);

-- -----------------------------------------------------
-- Table `exon_release_tag`
-- -----------------------------------------------------

CREATE TABLE `exon_release_tag` (
 `feature_id` int(10) unsigned NOT NULL,
 `release_id` int(10) unsigned NOT NULL,
 `session_id` INT UNSIGNED NULL,
  PRIMARY KEY (`feature_id`,`release_id`),
  CONSTRAINT `fk_exon_release_tag_1` FOREIGN KEY (`feature_id`) REFERENCES `exon` (`exon_id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `fk_exon_release_tag_2` FOREIGN KEY (`release_id`) REFERENCES `release_set` (`release_id`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=latin1;


CREATE INDEX `fk_exon_release_tag_1_idx` ON `exon_release_tag` (`feature_id` ASC);
CREATE INDEX `fk_exon_release_tag_2_idx` ON `exon_release_tag` (`release_id` ASC);

SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
