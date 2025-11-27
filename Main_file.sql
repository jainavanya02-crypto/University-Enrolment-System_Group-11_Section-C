-- MySQL Workbench Forward Engineering

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

-- -----------------------------------------------------
-- Schema mydb
-- -----------------------------------------------------
-- -----------------------------------------------------
-- Schema university_enrollment
-- -----------------------------------------------------

-- -----------------------------------------------------
-- Schema university_enrollment
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `university_enrollment` DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci ;
-- -----------------------------------------------------
-- Schema world2
-- -----------------------------------------------------
USE `university_enrollment` ;

-- -----------------------------------------------------
-- Table `university_enrollment`.`department`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `university_enrollment`.`department` (
  `department_id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `code` VARCHAR(10) NOT NULL,
  `name` VARCHAR(100) NOT NULL,
  `office_phone` VARCHAR(15) NULL DEFAULT NULL,
  PRIMARY KEY (`department_id`),
  UNIQUE INDEX `code` (`code` ASC) VISIBLE)
ENGINE = InnoDB
AUTO_INCREMENT = 11
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_unicode_ci;


-- -----------------------------------------------------
-- Table `university_enrollment`.`academicprogram`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `university_enrollment`.`academicprogram` (
  `program_id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `department_id` INT UNSIGNED NOT NULL,
  `name` VARCHAR(120) NOT NULL,
  `level` ENUM('UG', 'PG', 'PhD') NOT NULL,
  `duration_years` TINYINT UNSIGNED NOT NULL,
  `total_credits` SMALLINT UNSIGNED NOT NULL,
  `is_full_time` TINYINT(1) NOT NULL DEFAULT '1',
  PRIMARY KEY (`program_id`),
  INDEX `fk_program_department` (`department_id` ASC) VISIBLE,
  CONSTRAINT `fk_program_department`
    FOREIGN KEY (`department_id`)
    REFERENCES `university_enrollment`.`department` (`department_id`))
ENGINE = InnoDB
AUTO_INCREMENT = 16
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_unicode_ci;


-- -----------------------------------------------------
-- Table `university_enrollment`.`classroom`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `university_enrollment`.`classroom` (
  `classroom_id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `building` VARCHAR(50) NOT NULL,
  `room_no` VARCHAR(10) NOT NULL,
  `capacity` SMALLINT UNSIGNED NOT NULL,
  `room_type` ENUM('LECTURE', 'LAB', 'SEMINAR', 'ONLINE') NOT NULL,
  PRIMARY KEY (`classroom_id`),
  UNIQUE INDEX `uq_classroom` (`building` ASC, `room_no` ASC) VISIBLE)
ENGINE = InnoDB
AUTO_INCREMENT = 16
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_unicode_ci;


-- -----------------------------------------------------
-- Table `university_enrollment`.`course`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `university_enrollment`.`course` (
  `course_id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `department_id` INT UNSIGNED NOT NULL,
  `code` VARCHAR(15) NOT NULL,
  `title` VARCHAR(120) NOT NULL,
  `credits` TINYINT UNSIGNED NOT NULL,
  `level` ENUM('UG', 'PG') NOT NULL,
  `is_elective` TINYINT(1) NOT NULL DEFAULT '0',
  PRIMARY KEY (`course_id`),
  UNIQUE INDEX `code` (`code` ASC) VISIBLE,
  INDEX `idx_course_dept` (`department_id` ASC) VISIBLE,
  CONSTRAINT `fk_course_department`
    FOREIGN KEY (`department_id`)
    REFERENCES `university_enrollment`.`department` (`department_id`))
ENGINE = InnoDB
AUTO_INCREMENT = 31
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_unicode_ci;


-- -----------------------------------------------------
-- Table `university_enrollment`.`instructor`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `university_enrollment`.`instructor` (
  `instructor_id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `emp_code` VARCHAR(20) NOT NULL,
  `first_name` VARCHAR(40) NOT NULL,
  `last_name` VARCHAR(40) NOT NULL,
  `email` VARCHAR(120) NOT NULL,
  `phone` VARCHAR(15) NULL DEFAULT NULL,
  `hire_date` DATE NOT NULL,
  `department_id` INT UNSIGNED NOT NULL,
  `designation` ENUM('Assistant Professor', 'Associate Professor', 'Professor', 'Visiting') NOT NULL,
  PRIMARY KEY (`instructor_id`),
  UNIQUE INDEX `emp_code` (`emp_code` ASC) VISIBLE,
  UNIQUE INDEX `email` (`email` ASC) VISIBLE,
  INDEX `idx_instructor_department` (`department_id` ASC) VISIBLE,
  CONSTRAINT `fk_instructor_department`
    FOREIGN KEY (`department_id`)
    REFERENCES `university_enrollment`.`department` (`department_id`))
ENGINE = InnoDB
AUTO_INCREMENT = 21
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_unicode_ci;


-- -----------------------------------------------------
-- Table `university_enrollment`.`semester`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `university_enrollment`.`semester` (
  `semester_id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(30) NOT NULL,
  `academic_year` VARCHAR(9) NOT NULL,
  `term` ENUM('ODD', 'EVEN') NOT NULL,
  `start_date` DATE NOT NULL,
  `end_date` DATE NOT NULL,
  PRIMARY KEY (`semester_id`))
ENGINE = InnoDB
AUTO_INCREMENT = 7
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_unicode_ci;


-- -----------------------------------------------------
-- Table `university_enrollment`.`courseoffering`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `university_enrollment`.`courseoffering` (
  `offering_id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `course_id` INT UNSIGNED NOT NULL,
  `semester_id` INT UNSIGNED NOT NULL,
  `instructor_id` INT UNSIGNED NOT NULL,
  `classroom_id` INT UNSIGNED NULL DEFAULT NULL,
  `section` VARCHAR(10) NOT NULL,
  `schedule_info` VARCHAR(100) NULL DEFAULT NULL,
  `medium` ENUM('ONLINE', 'OFFLINE', 'HYBRID') NOT NULL DEFAULT 'OFFLINE',
  `max_seats` SMALLINT UNSIGNED NOT NULL,
  `enrolled_count` SMALLINT UNSIGNED NOT NULL DEFAULT '0',
  PRIMARY KEY (`offering_id`),
  INDEX `fk_offering_instructor` (`instructor_id` ASC) VISIBLE,
  INDEX `fk_offering_classroom` (`classroom_id` ASC) VISIBLE,
  INDEX `idx_offering_course` (`course_id` ASC) VISIBLE,
  INDEX `idx_offering_semester` (`semester_id` ASC) VISIBLE,
  CONSTRAINT `fk_offering_classroom`
    FOREIGN KEY (`classroom_id`)
    REFERENCES `university_enrollment`.`classroom` (`classroom_id`),
  CONSTRAINT `fk_offering_course`
    FOREIGN KEY (`course_id`)
    REFERENCES `university_enrollment`.`course` (`course_id`),
  CONSTRAINT `fk_offering_instructor`
    FOREIGN KEY (`instructor_id`)
    REFERENCES `university_enrollment`.`instructor` (`instructor_id`),
  CONSTRAINT `fk_offering_semester`
    FOREIGN KEY (`semester_id`)
    REFERENCES `university_enrollment`.`semester` (`semester_id`))
ENGINE = InnoDB
AUTO_INCREMENT = 26
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_unicode_ci;


-- -----------------------------------------------------
-- Table `university_enrollment`.`student`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `university_enrollment`.`student` (
  `student_id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `roll_no` VARCHAR(20) NOT NULL,
  `first_name` VARCHAR(40) NOT NULL,
  `last_name` VARCHAR(40) NOT NULL,
  `gender` ENUM('M', 'F', 'O') NOT NULL,
  `dob` DATE NOT NULL,
  `email` VARCHAR(120) NOT NULL,
  `phone` VARCHAR(15) NULL DEFAULT NULL,
  `program_id` INT UNSIGNED NOT NULL,
  `admission_year` YEAR NOT NULL,
  `status` ENUM('ACTIVE', 'GRADUATED', 'DROPPED') NOT NULL DEFAULT 'ACTIVE',
  PRIMARY KEY (`student_id`),
  UNIQUE INDEX `roll_no` (`roll_no` ASC) VISIBLE,
  UNIQUE INDEX `email` (`email` ASC) VISIBLE,
  INDEX `idx_student_program` (`program_id` ASC) VISIBLE,
  CONSTRAINT `fk_student_program`
    FOREIGN KEY (`program_id`)
    REFERENCES `university_enrollment`.`academicprogram` (`program_id`))
ENGINE = InnoDB
AUTO_INCREMENT = 41
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_unicode_ci;


-- -----------------------------------------------------
-- Table `university_enrollment`.`enrollment`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `university_enrollment`.`enrollment` (
  `enrollment_id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `student_id` INT UNSIGNED NOT NULL,
  `offering_id` INT UNSIGNED NOT NULL,
  `enrollment_date` DATE NOT NULL,
  `grade` ENUM('A', 'B', 'C', 'D', 'E', 'F', 'I', 'W') NULL DEFAULT NULL,
  `status` ENUM('ENROLLED', 'COMPLETED', 'DROPPED') NOT NULL DEFAULT 'ENROLLED',
  `attendance_percent` DECIMAL(5,2) NULL DEFAULT NULL,
  PRIMARY KEY (`enrollment_id`),
  UNIQUE INDEX `uq_enrollment` (`student_id` ASC, `offering_id` ASC) VISIBLE,
  INDEX `idx_enrollment_student` (`student_id` ASC) VISIBLE,
  INDEX `idx_enrollment_offering` (`offering_id` ASC) VISIBLE,
  CONSTRAINT `fk_enrollment_offering`
    FOREIGN KEY (`offering_id`)
    REFERENCES `university_enrollment`.`courseoffering` (`offering_id`),
  CONSTRAINT `fk_enrollment_student`
    FOREIGN KEY (`student_id`)
    REFERENCES `university_enrollment`.`student` (`student_id`))
ENGINE = InnoDB
AUTO_INCREMENT = 102
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_unicode_ci;


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
