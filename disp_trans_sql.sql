-- phpMyAdmin SQL Dump
-- version 4.9.4
-- https://www.phpmyadmin.net/
--
-- Host: localhost:3306
-- Generation Time: Jan 21, 2021 at 02:21 PM
-- Server version: 5.6.49-cll-lve
-- PHP Version: 7.3.6

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET AUTOCOMMIT = 0;
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `iwaytransca`
--

CREATE DATABASE IF NOT EXISTS `iwaytransca` DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci;
USE `iwaytransca`;


-- --------------------------------------------------------

-- Table structure for table `account_payments`
CREATE TABLE `account_payments` (
  `id` int(150) NOT NULL,
  `pay_id` varchar(100) DEFAULT NULL,
  `account_type` enum('Driver','Supplier') DEFAULT NULL,
  `account_id` varchar(100) DEFAULT NULL,
  `currency` varchar(100) DEFAULT NULL,
  `amount` varchar(100) DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=latin1;


-- --------------------------------------------------------

-- Table structure for table `additionalcharges`
CREATE TABLE `additionalcharges` (
  `id` int(255) NOT NULL,
  `name` varchar(100) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;


-- --------------------------------------------------------

-- Table structure for table `admin`
CREATE TABLE `admin` (
  `id` int(10) NOT NULL,
  `username` varchar(50) NOT NULL,
  `password` varchar(50) NOT NULL,
  `last_login` datetime NOT NULL,
  `name` varchar(50) NOT NULL,
  `phone` varchar(15) NOT NULL,
  `email` varchar(50) NOT NULL,
  `business` varchar(100) NOT NULL,
  `copyright_text` varchar(150) DEFAULT NULL,
  `logo` longtext NOT NULL,
  `currency` varchar(10) NOT NULL,
  `currency_percent` varchar(25) NOT NULL,
  `country_code` varchar(10) NOT NULL,
  `address` varchar(150) NOT NULL,
  `fax` varchar(50) NOT NULL,
  `country` varchar(50) NOT NULL,
  `modified` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `paps_code` varchar(100) NOT NULL,
  `pars_code` varchar(100) NOT NULL,
  `db_email` varchar(100) NOT NULL,
  `start_orders` varchar(100) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;


-- --------------------------------------------------------

-- Table structure for table `advance_filter`
CREATE TABLE `advance_filter` (
  `id` int(11) NOT NULL,
  `user_id` int(11) DEFAULT NULL,
  `filter_name` varchar(255) DEFAULT NULL,
  `order_group_id` int(11) DEFAULT NULL,
  `default_select` int(11) NOT NULL,
  `searching_for` varchar(100) DEFAULT NULL,
  `shipper_state_condition` varchar(100) DEFAULT NULL,
  `shipper_state` text,
  `receiver_state_condition` varchar(100) DEFAULT NULL,
  `receiver_state` text,
  `dispatch_pickup_complete` varchar(50) DEFAULT NULL,
  `orderlane_pickup_complete` varchar(50) DEFAULT NULL,
  `orderlane` varchar(100) NOT NULL,
  `order_dates` varchar(100) DEFAULT NULL,
  `order_start_date` varchar(100) DEFAULT NULL,
  `order_end_date` varchar(100) DEFAULT NULL,
  `pickup_dates` varchar(100) DEFAULT NULL,
  `pickup_start_date` varchar(100) DEFAULT NULL,
  `pickup_end_date` varchar(100) DEFAULT NULL,
  `delivery_dates` varchar(100) DEFAULT NULL,
  `delivery_start_date` varchar(100) DEFAULT NULL,
  `delivery_end_date` varchar(100) DEFAULT NULL,
  `order_lane` varchar(100) DEFAULT NULL,
  `dispatcher` text,
  `contactpersons` text,
  `customers` text,
  `order_progress` varchar(100) DEFAULT NULL,
  `order_status` varchar(100) DEFAULT NULL,
  `load_type` varchar(100) DEFAULT NULL,
  `pickup_name` text,
  `deliver_name` text,
  `csr_email` text,
  `sales_person` text,
  `truck_pickup` varchar(100) DEFAULT NULL,
  `truck_delivery` varchar(100) DEFAULT NULL,
  `csa_fast` varchar(100) DEFAULT NULL,
  `bonded_us` varchar(100) DEFAULT NULL,
  `bonded_canada` varchar(100) DEFAULT NULL,
  `dangerous_goods` varchar(100) DEFAULT NULL,
  `high_value` varchar(100) DEFAULT NULL,
  `team_load` varchar(100) DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=MyISAM DEFAULT CHARSET=latin1;


-- --------------------------------------------------------

-- Table structure for table `api_keys`
CREATE TABLE `api_keys` (
  `id` int(2) NOT NULL,
  `google_maps` varchar(250) NOT NULL,
  `fcm_customer` varchar(250) NOT NULL,
  `fcm_artist` varchar(250) NOT NULL
) ENGINE=MyISAM DEFAULT CHARSET=latin1;


-- --------------------------------------------------------

-- Table structure for table `backup`
CREATE TABLE `backup` (
  `id` int(11) NOT NULL,
  `sql_file` varchar(255) NOT NULL,
  `folder` varchar(255) NOT NULL,
  `created_date_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=MyISAM DEFAULT CHARSET=latin1;


-- --------------------------------------------------------

-- Table structure for table `blogs`
CREATE TABLE `blogs` (
  `id` int(100) NOT NULL,
  `title` varchar(150) NOT NULL,
  `tags` varchar(100) NOT NULL,
  `short_desc` varchar(150) NOT NULL,
  `image` longtext NOT NULL,
  `content` longtext NOT NULL,
  `delete_status` tinyint(4) NOT NULL DEFAULT '0',
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=latin1;


-- --------------------------------------------------------

-- Table structure for table `bookings`
CREATE TABLE `bookings` (
  `id` int(150) NOT NULL,
  `user_id` int(100) NOT NULL,
  `artist_id` int(100) NOT NULL,
  `booking_date` varchar(100) NOT NULL,
  `booking_time` varchar(100) NOT NULL,
  `event_type` varchar(50) NOT NULL,
  `nop` int(10) NOT NULL,
  `noh` varchar(100) NOT NULL,
  `venue_address` varchar(250) NOT NULL,
  `chat_status` int(10) NOT NULL DEFAULT '0',
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=MyISAM DEFAULT CHARSET=latin1;


-- --------------------------------------------------------

-- Table structure for table `category`
CREATE TABLE `category` (
  `id` int(11) NOT NULL,
  `category_name` varchar(100) NOT NULL,
  `parent` int(10) NOT NULL,
  `image` varchar(100) NOT NULL,
  `slug` varchar(250) NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `delete_status` tinyint(1) NOT NULL DEFAULT '0'
) ENGINE=InnoDB DEFAULT CHARSET=latin1;


-- --------------------------------------------------------

-- Table structure for table `cities`
CREATE TABLE `cities` (
  `id` int(11) NOT NULL,
  `name` varchar(30) NOT NULL,
  `state` varchar(11) NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=latin1;


-- --------------------------------------------------------

-- Table structure for table `cities1`
CREATE TABLE `cities1` (
  `id` int(100) NOT NULL,
  `name` varchar(100) DEFAULT NULL,
  `state` varchar(100) NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=MyISAM DEFAULT CHARSET=latin1;


-- --------------------------------------------------------

-- Table structure for table `ci_sessions`
CREATE TABLE `ci_sessions` (
  `id` varchar(40) NOT NULL,
  `ip_address` varchar(45) NOT NULL,
  `timestamp` int(10) UNSIGNED NOT NULL DEFAULT '0',
  `data` blob NOT NULL
) ENGINE=MyISAM DEFAULT CHARSET=latin1;


-- --------------------------------------------------------

-- Table structure for table `codes`
CREATE TABLE `codes` (
  `id` int(11) NOT NULL,
  `name` int(11) NOT NULL,
  `country` varchar(150) NOT NULL,
  `sortname` varchar(3) NOT NULL,
  `continent_id` int(11) DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


-- --------------------------------------------------------

-- Table structure for table `codes1`
CREATE TABLE `codes1` (
  `id` int(100) NOT NULL,
  `name` varchar(100) NOT NULL,
  `country` varchar(50) NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=MyISAM DEFAULT CHARSET=latin1;


-- --------------------------------------------------------

-- Table structure for table `contactpersons`
CREATE TABLE `contactpersons` (
  `id` int(100) NOT NULL,
  `name` varchar(100) NOT NULL,
  `pcode` varchar(25) NOT NULL,
  `phone` varchar(25) NOT NULL,
  `fcode` varchar(25) NOT NULL,
  `fax` varchar(50) NOT NULL,
  `cpcode` varchar(50) NOT NULL,
  `cellphone` varchar(50) NOT NULL,
  `opcode` varchar(50) NOT NULL,
  `ophone` varchar(50) NOT NULL,
  `email` varchar(100) NOT NULL,
  `address` varchar(150) NOT NULL,
  `unit` varchar(100) NOT NULL,
  `latitude` varchar(100) NOT NULL,
  `longitude` varchar(100) NOT NULL,
  `street_no` varchar(50) DEFAULT NULL,
  `street` varchar(100) NOT NULL,
  `city` varchar(100) NOT NULL,
  `district` varchar(100) DEFAULT NULL,
  `state` varchar(100) NOT NULL,
  `country` varchar(100) NOT NULL,
  `zip` varchar(50) NOT NULL,
  `working_for` varchar(100) DEFAULT NULL,
  `customer` varchar(100) DEFAULT NULL,
  `supplier` varchar(100) DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=MyISAM DEFAULT CHARSET=latin1;


-- --------------------------------------------------------

-- Table structure for table `continent`
CREATE TABLE `continent` (
  `id` int(11) NOT NULL,
  `name` varchar(100) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;


-- --------------------------------------------------------

-- Table structure for table `conversation`
CREATE TABLE `conversation` (
  `id` int(100) NOT NULL,
  `from_id` int(100) NOT NULL,
  `to_id` int(100) NOT NULL,
  `sender` enum('CUSTOMER','ARTIST') NOT NULL,
  `reciever` enum('CUSTOMER','ARTIST') NOT NULL,
  `message` varchar(250) NOT NULL,
  `booking_id` int(100) NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=MyISAM DEFAULT CHARSET=latin1;


-- --------------------------------------------------------

-- Table structure for table `countries`
CREATE TABLE `countries` (
  `id` int(11) NOT NULL,
  `sortname` varchar(3) NOT NULL,
  `country` varchar(150) NOT NULL,
  `name` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


-- --------------------------------------------------------

-- Table structure for table `csr`
CREATE TABLE `csr` (
  `id` int(255) NOT NULL,
  `role` varchar(150) DEFAULT NULL,
  `name` varchar(100) NOT NULL,
  `legal_name` varchar(100) NOT NULL,
  `address` varchar(100) NOT NULL,
  `latitude` varchar(50) NOT NULL,
  `longitude` varchar(50) NOT NULL,
  `unit` varchar(50) NOT NULL,
  `street_no` varchar(50) DEFAULT NULL,
  `street` varchar(50) NOT NULL,
  `state` varchar(50) NOT NULL,
  `city` varchar(50) NOT NULL,
  `city_lat` varchar(255) NOT NULL,
  `city_long` varchar(255) NOT NULL,
  `district` varchar(50) DEFAULT NULL,
  `zip` varchar(50) NOT NULL,
  `country` varchar(50) NOT NULL,
  `pcode` varchar(25) NOT NULL,
  `phone` varchar(25) NOT NULL,
  `apcode` varchar(25) NOT NULL,
  `aphone` varchar(25) NOT NULL,
  `email` varchar(100) NOT NULL,
  `website` varchar(100) NOT NULL,
  `timing` varchar(25) NOT NULL,
  `fcode` varchar(25) NOT NULL,
  `fax` varchar(25) NOT NULL,
  `cpname` varchar(100) NOT NULL,
  `cpcode` varchar(25) NOT NULL,
  `cpphone` varchar(50) NOT NULL,
  `payment_term` varchar(25) NOT NULL,
  `credit_limit` varchar(25) NOT NULL,
  `payment_notes` longtext NOT NULL,
  `notes` longtext NOT NULL,
  `rating` varchar(10) NOT NULL,
  `blacklisted` varchar(10) NOT NULL,
  `customer_billing_email` varchar(100) DEFAULT NULL,
  `customer_billing_contact` varchar(100) DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `publish` enum('0','1') DEFAULT '0'
) ENGINE=InnoDB DEFAULT CHARSET=latin1;


-- --------------------------------------------------------

-- Table structure for table `currency`
CREATE TABLE `currency` (
  `id` int(100) NOT NULL,
  `name` varchar(100) NOT NULL,
  `title` varchar(100) NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=MyISAM DEFAULT CHARSET=latin1;


-- --------------------------------------------------------

-- Table structure for table `custombrokers`
CREATE TABLE `custombrokers` (
  `id` int(100) NOT NULL,
  `name` varchar(100) DEFAULT NULL,
  `address` varchar(150) DEFAULT NULL,
  `paps_email` varchar(100) DEFAULT NULL,
  `pars_email` varchar(150) DEFAULT NULL,
  `note` varchar(150) DEFAULT NULL,
  `phone` varchar(100) DEFAULT NULL,
  `fax` varchar(100) DEFAULT NULL,
  `pcode` varchar(50) DEFAULT NULL,
  `fcode` varchar(50) DEFAULT NULL
) ENGINE=MyISAM DEFAULT CHARSET=latin1;


-- --------------------------------------------------------

-- Table structure for table `deductions`
CREATE TABLE `deductions` (
  `id` int(100) NOT NULL,
  `name` varchar(100) NOT NULL,
  `description` varchar(100) NOT NULL,
  `amount` varchar(100) NOT NULL,
  `currency` varchar(100) NOT NULL,
  `saletax` varchar(200) NOT NULL,
  `frequency` varchar(100) NOT NULL,
  `nod` varchar(25) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;


-- --------------------------------------------------------

-- Table structure for table `drivers`
CREATE TABLE `drivers` (
  `id` int(255) NOT NULL,
  `role` varchar(25) NOT NULL,
  `first_name` varchar(50) NOT NULL,
  `middle_name` varchar(50) NOT NULL,
  `last_name` varchar(50) NOT NULL,
  `address` varchar(150) NOT NULL,
  `street_no` varchar(100) DEFAULT NULL,
  `street` varchar(75) NOT NULL,
  `state` varchar(50) NOT NULL,
  `city` varchar(50) NOT NULL,
  `district` varchar(50) DEFAULT NULL,
  `unit` varchar(50) NOT NULL,
  `zip` varchar(50) NOT NULL,
  `latitude` varchar(100) NOT NULL,
  `longitude` varchar(100) NOT NULL,
  `company_name` varchar(100) NOT NULL,
  `country_code` varchar(25) NOT NULL,
  `phone` varchar(100) NOT NULL,
  `cpcode` varchar(10) DEFAULT NULL,
  `cellphone` varchar(50) DEFAULT NULL,
  `email` varchar(150) NOT NULL,
  `password` varchar(100) NOT NULL,
  `password_token` text,
  `sin` varchar(50) NOT NULL,
  `working_as` varchar(50) NOT NULL,
  `suppliers` varchar(50) NOT NULL,
  `vcfep` varchar(100) NOT NULL,
  `vcfef` varchar(100) NOT NULL,
  `vcfevb` varchar(100) NOT NULL,
  `emergency_contact_name` varchar(50) NOT NULL,
  `emergency_contact_phone` varchar(50) NOT NULL,
  `hiring_date` varchar(25) NOT NULL,
  `leaving_date` varchar(25) NOT NULL,
  `picture` varchar(150) NOT NULL,
  `csa_fast_driver` varchar(100) NOT NULL,
  `driver_pay_type` varchar(25) NOT NULL,
  `driver_extrapay_type` varchar(50) NOT NULL,
  `paytype_rate` varchar(100) NOT NULL,
  `extrapaytype_rate` varchar(100) NOT NULL,
  `paytype_currency` varchar(100) NOT NULL,
  `extrapaytype_currency` varchar(100) NOT NULL,
  `safety_documents` varchar(100) NOT NULL,
  `sdissue` varchar(100) NOT NULL,
  `sdexpiry` varchar(100) NOT NULL,
  `sdfile` varchar(100) NOT NULL,
  `sddescription` varchar(100) NOT NULL,
  `sdfrequency` varchar(100) NOT NULL,
  `equipments` varchar(100) NOT NULL,
  `eqdescription` varchar(150) NOT NULL,
  `eqqty` varchar(100) NOT NULL,
  `eqbalance` varchar(100) NOT NULL,
  `deductions` varchar(100) NOT NULL,
  `damt` varchar(100) NOT NULL,
  `dsaletax` varchar(100) NOT NULL,
  `dcurrency` varchar(100) NOT NULL,
  `dfrequency` varchar(100) NOT NULL,
  `dnod` varchar(100) NOT NULL,
  `activation` varchar(10) NOT NULL,
  `publish` enum('0','1') NOT NULL DEFAULT '0',
  `terminal` varchar(50) NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `delete_status` int(10) NOT NULL DEFAULT '0' COMMENT 'if 1 then it is not in use',
  `balance` varchar(100) NOT NULL DEFAULT '0'
) ENGINE=InnoDB DEFAULT CHARSET=latin1;


-- --------------------------------------------------------

-- Table structure for table `drivers_assigned_trips`
CREATE TABLE `drivers_assigned_trips` (
  `id` int(11) NOT NULL,
  `driver_id` int(11) DEFAULT NULL,
  `trip_id` varchar(100) DEFAULT NULL,
  `assigned_date` datetime DEFAULT NULL,
  `assigned_upto` datetime DEFAULT NULL,
  `status` int(10) NOT NULL DEFAULT '0'
) ENGINE=InnoDB DEFAULT CHARSET=latin1;


-- --------------------------------------------------------

-- Table structure for table `drivers_deductions_master`
CREATE TABLE `drivers_deductions_master` (
  `id` int(255) NOT NULL,
  `name` varchar(100) DEFAULT NULL,
  `role` varchar(50) NOT NULL,
  `role_id` varchar(255) NOT NULL,
  `driver_id` int(250) DEFAULT NULL,
  `deduction_name` varchar(255) NOT NULL,
  `currency` varchar(25) NOT NULL,
  `base_amount` varchar(100) NOT NULL,
  `saletax1_name` varchar(255) DEFAULT NULL,
  `saletax2_name` varchar(255) DEFAULT NULL,
  `saletax1` varchar(100) DEFAULT NULL,
  `saletax2` varchar(100) DEFAULT NULL,
  `description` varchar(255) NOT NULL,
  `final_amount` varchar(100) NOT NULL,
  `type` varchar(100) NOT NULL,
  `deduction_date` date DEFAULT NULL,
  `start_date` date DEFAULT NULL,
  `end_date` date DEFAULT NULL,
  `frequency` varchar(100) NOT NULL,
  `instalment` varchar(100) NOT NULL,
  `intervals` varchar(100) NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=latin1;


-- --------------------------------------------------------

-- Table structure for table `driver_activation_history`
CREATE TABLE `driver_activation_history` (
  `id` int(100) NOT NULL,
  `driver_id` varchar(100) NOT NULL,
  `action` enum('0','1') NOT NULL DEFAULT '0',
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=latin1;


-- --------------------------------------------------------

-- Table structure for table `driver_meta_deduction`
CREATE TABLE `driver_meta_deduction` (
  `id` int(250) NOT NULL,
  `driver_id` varchar(100) NOT NULL,
  `deduction` varchar(100) NOT NULL,
  `currency` varchar(100) NOT NULL,
  `amount` varchar(100) NOT NULL,
  `saletax1` varchar(100) NOT NULL,
  `saletax2` varchar(100) NOT NULL,
  `frequency` varchar(100) NOT NULL,
  `nod` varchar(100) NOT NULL,
  `start_date` date DEFAULT NULL,
  `expiry_date` date DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=latin1;


-- --------------------------------------------------------

-- Table structure for table `driver_meta_equipment`
CREATE TABLE `driver_meta_equipment` (
  `id` int(150) NOT NULL,
  `equipment` varchar(100) NOT NULL,
  `role` varchar(50) NOT NULL,
  `driver_id` varchar(100) DEFAULT NULL,
  `employee_id` varchar(100) DEFAULT NULL,
  `shipper_id` varchar(100) DEFAULT NULL,
  `customer_id` varchar(100) DEFAULT NULL,
  `reciever_id` varchar(100) DEFAULT NULL,
  `stock` varchar(100) NOT NULL,
  `issue_date` date DEFAULT NULL,
  `description` varchar(100) NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=latin1;


-- --------------------------------------------------------

-- Table structure for table `driver_meta_extrapaytype`
CREATE TABLE `driver_meta_extrapaytype` (
  `id` int(250) NOT NULL,
  `driver_id` int(250) NOT NULL,
  `extrapay_type` varchar(100) NOT NULL,
  `currency` varchar(10) NOT NULL,
  `rate` varchar(50) NOT NULL,
  `extrapaytype_saletax1` varchar(100) NOT NULL,
  `extrapaytype_saletax2` varchar(100) NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=latin1;


-- --------------------------------------------------------

-- Table structure for table `driver_meta_paytype`
CREATE TABLE `driver_meta_paytype` (
  `id` int(250) NOT NULL,
  `driver_id` varchar(100) NOT NULL,
  `pay_type` varchar(100) NOT NULL,
  `currency` varchar(10) NOT NULL,
  `rate` decimal(10,2) NOT NULL,
  `paytype_saletax1` varchar(100) NOT NULL,
  `paytype_saletax2` varchar(100) NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=latin1;


-- --------------------------------------------------------

-- Table structure for table `driver_meta_safety_doc`
CREATE TABLE `driver_meta_safety_doc` (
  `id` int(250) NOT NULL,
  `driver_id` varchar(100) NOT NULL,
  `safety_document` varchar(50) NOT NULL,
  `issuing_date` date DEFAULT NULL,
  `expiry` varchar(10) NOT NULL,
  `expiry_date` date DEFAULT NULL,
  `file` varchar(250) DEFAULT NULL,
  `description` varchar(100) NOT NULL,
  `frequency` varchar(100) NOT NULL,
  `document_number` varchar(50) NOT NULL,
  `issuing_state` varchar(50) NOT NULL,
  `issuing_country` varchar(50) NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=latin1;


-- --------------------------------------------------------

-- Table structure for table `equipments`
CREATE TABLE `equipments` (
  `id` int(100) NOT NULL,
  `name` varchar(100) NOT NULL,
  `description` varchar(200) NOT NULL,
  `qty` varchar(100) NOT NULL,
  `cost` varchar(25) NOT NULL,
  `currency` varchar(10) NOT NULL,
  `saletax1` varchar(50) NOT NULL,
  `saletax2` varchar(50) NOT NULL,
  `balance` varchar(200) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;


-- --------------------------------------------------------

-- Table structure for table `equipment_return_log`
CREATE TABLE `equipment_return_log` (
  `id` int(100) NOT NULL,
  `eq_id` int(100) NOT NULL,
  `return_qty` int(100) NOT NULL,
  `reason` varchar(150) NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=latin1;


-- --------------------------------------------------------

-- Table structure for table `events`
CREATE TABLE `events` (
  `id` int(11) NOT NULL,
  `event_name` varchar(100) NOT NULL,
  `parent` int(10) NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `delete_status` tinyint(1) NOT NULL DEFAULT '0'
) ENGINE=InnoDB DEFAULT CHARSET=latin1;


-- --------------------------------------------------------

-- Table structure for table `extrapay_types`
CREATE TABLE `extrapay_types` (
  `id` int(100) NOT NULL,
  `type` varchar(100) NOT NULL,
  `rate` varchar(25) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;


-- --------------------------------------------------------

-- Table structure for table `filter`
CREATE TABLE `filter` (
  `id_filter` int(11) NOT NULL,
  `customer_name` varchar(255) NOT NULL,
  `orderlane_id` int(10) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;


-- --------------------------------------------------------

-- Table structure for table `fuel`
CREATE TABLE `fuel` (
  `id` int(11) NOT NULL,
  `company_name` varchar(255) DEFAULT NULL,
  `card` varchar(255) NOT NULL,
  `driver_name` text NOT NULL,
  `unit` varchar(255) NOT NULL,
  `auth_code` varchar(255) NOT NULL,
  `card_group` int(11) NOT NULL,
  `cash` int(11) NOT NULL,
  `comp_name` varchar(255) NOT NULL,
  `def_amt` decimal(10,3) NOT NULL,
  `def_qty` decimal(10,3) NOT NULL,
  `dash_cash` decimal(10,3) NOT NULL,
  `date` varchar(255) NOT NULL,
  `date_t` datetime NOT NULL,
  `def_pre_tax_amt` decimal(10,3) NOT NULL,
  `def_tax_amt` decimal(10,3) NOT NULL,
  `description` text NOT NULL,
  `driver_id` varchar(255) NOT NULL,
  `fee` decimal(10,3) NOT NULL,
  `fuel_amt` decimal(10,3) NOT NULL,
  `fuel_qty` decimal(10,3) NOT NULL,
  `odometer` decimal(10,3) NOT NULL,
  `other_1_amt` decimal(10,3) NOT NULL,
  `other_1_code` varchar(255) NOT NULL,
  `other_id` varchar(255) NOT NULL,
  `other_tax_amt` decimal(10,3) NOT NULL,
  `other_tax_ppu` decimal(10,3) NOT NULL,
  `pretax_final_amt` decimal(10,3) NOT NULL,
  `pretax_reefer` decimal(10,3) NOT NULL,
  `pretax_tractor` decimal(10,3) NOT NULL,
  `state` varchar(255) NOT NULL,
  `state_abb` varchar(10) NOT NULL,
  `reefer_qty` decimal(10,3) NOT NULL,
  `retail_fuel_amt` decimal(10,3) NOT NULL,
  `retail_reefer_amt` decimal(10,3) NOT NULL,
  `retail_tractor_amt` decimal(10,3) NOT NULL,
  `site_num` int(11) NOT NULL,
  `site_city` varchar(255) NOT NULL,
  `site_name` varchar(255) NOT NULL,
  `tchek_veh_num` int(11) NOT NULL,
  `time` time NOT NULL,
  `tractor` varchar(100) NOT NULL,
  `tractor_qty` decimal(10,3) NOT NULL,
  `trailer_num` varchar(100) NOT NULL,
  `trip` varchar(100) NOT NULL,
  `UOM` varchar(50) NOT NULL,
  `unit_num_pos` varchar(100) NOT NULL,
  `billed_price` decimal(10,3) NOT NULL,
  `currency` varchar(10) NOT NULL,
  `discount` decimal(10,3) NOT NULL,
  `discount_rate` decimal(10,3) NOT NULL,
  `exchange_rate` decimal(10,3) NOT NULL,
  `FET` decimal(10,3) NOT NULL,
  `final_amt` decimal(10,3) NOT NULL,
  `fuel_cost` decimal(10,3) NOT NULL,
  `GST` decimal(10,3) NOT NULL,
  `HST` int(11) NOT NULL,
  `PCT` decimal(10,3) NOT NULL,
  `PFT` decimal(10,3) NOT NULL,
  `PST` decimal(10,3) NOT NULL,
  `QST` decimal(10,3) NOT NULL,
  `reefer_amt` decimal(10,3) NOT NULL,
  `retail_price` decimal(10,3) NOT NULL,
  `total_amt` decimal(10,3) NOT NULL,
  `tractor_amt` decimal(10,3) NOT NULL
) ENGINE=MyISAM DEFAULT CHARSET=latin1;


-- --------------------------------------------------------

-- Table structure for table `generate_delivery`
CREATE TABLE `generate_delivery` (
  `id` int(100) NOT NULL,
  `order_id` varchar(100) NOT NULL,
  `delivery_shipper` varchar(100) NOT NULL,
  `delivery_appt` varchar(100) NOT NULL,
  `delivery_date` varchar(100) NOT NULL,
  `delivery_time` time NOT NULL,
  `delivery_ref_no` varchar(100) NOT NULL,
  `delivery_additional_info` varchar(100) NOT NULL,
  `reciever_timing` varchar(100) NOT NULL,
  `reciever_note` varchar(100) NOT NULL,
  `delivery_equipment` varchar(100) NOT NULL,
  `delivery_attributes` varchar(100) DEFAULT NULL,
  `delivery_temperature` varchar(100) NOT NULL,
  `delivery_hazardous` varchar(100) NOT NULL,
  `delivery_custom_broker` varchar(100) NOT NULL
) ENGINE=MyISAM DEFAULT CHARSET=latin1;


-- --------------------------------------------------------

-- Table structure for table `generate_payid`
CREATE TABLE `generate_payid` (
  `id` int(100) NOT NULL,
  `ref_check` varchar(100) DEFAULT NULL,
  `description` varchar(100) DEFAULT NULL,
  `payment_date` varchar(100) DEFAULT NULL,
  `proof` varchar(100) DEFAULT NULL,
  `currency` varchar(100) DEFAULT NULL,
  `total_amount` varchar(100) DEFAULT NULL
) ENGINE=MyISAM DEFAULT CHARSET=latin1;


-- --------------------------------------------------------

-- Table structure for table `group_security_permission`
CREATE TABLE `group_security_permission` (
  `id` int(11) NOT NULL,
  `group_id` int(11) DEFAULT NULL,
  `page_name` varchar(100) DEFAULT NULL,
  `view_permission` tinyint(11) DEFAULT '0',
  `add_permission` tinyint(11) DEFAULT '0',
  `edit_permission` tinyint(11) DEFAULT '0',
  `delete_permission` tinyint(11) DEFAULT '0',
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=MyISAM DEFAULT CHARSET=latin1;


-- --------------------------------------------------------

-- Table structure for table `hr_policy`
CREATE TABLE `hr_policy` (
  `id` int(11) NOT NULL,
  `policy_name` varchar(100) DEFAULT NULL,
  `shift_hours` varchar(100) DEFAULT NULL,
  `break_deduction` varchar(100) DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=MyISAM DEFAULT CHARSET=latin1;


-- --------------------------------------------------------

-- Table structure for table `hr_system`
CREATE TABLE `hr_system` (
  `id` int(11) NOT NULL,
  `driver_id` int(11) DEFAULT NULL,
  `time_stamp` datetime DEFAULT NULL,
  `state` varchar(100) DEFAULT NULL,
  `currency` varchar(100) DEFAULT NULL,
  `hourly_rate` varchar(100) DEFAULT NULL,
  `saletax1` varchar(100) DEFAULT NULL,
  `saletax2` varchar(100) DEFAULT NULL,
  `percent1` int(10) DEFAULT NULL,
  `percent2` int(10) DEFAULT NULL
) ENGINE=MyISAM DEFAULT CHARSET=latin1;


-- --------------------------------------------------------

-- Table structure for table `in_usage`
CREATE TABLE `in_usage` (
  `id` int(100) NOT NULL,
  `type` varchar(50) DEFAULT NULL,
  `element_id` varchar(100) DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=MyISAM DEFAULT CHARSET=latin1;


-- --------------------------------------------------------

-- Table structure for table `leads`
CREATE TABLE `leads` (
  `id` int(100) NOT NULL,
  `name` varchar(100) DEFAULT NULL,
  `phone` varchar(100) DEFAULT NULL,
  `email` varchar(100) DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=MyISAM DEFAULT CHARSET=latin1;


-- --------------------------------------------------------

-- Table structure for table `leg_locations`
CREATE TABLE `leg_locations` (
  `id` int(100) NOT NULL,
  `order_id` varchar(100) DEFAULT NULL,
  `location_type` int(10) DEFAULT NULL,
  `location` longtext,
  `name` varchar(100) DEFAULT NULL,
  `separate` int(10) NOT NULL DEFAULT '0'
) ENGINE=InnoDB DEFAULT CHARSET=latin1;


-- --------------------------------------------------------

-- Table structure for table `leg_parts`
CREATE TABLE `leg_parts` (
  `id` int(100) NOT NULL,
  `order_id` varchar(100) DEFAULT NULL,
  `order_leg_id` varchar(100) DEFAULT NULL,
  `part_id` varchar(100) DEFAULT NULL,
  `type` varchar(100) DEFAULT NULL,
  `nopcs` varchar(100) DEFAULT NULL,
  `trip_status` int(10) NOT NULL DEFAULT '0'
) ENGINE=MyISAM DEFAULT CHARSET=latin1;


-- --------------------------------------------------------

-- Table structure for table `main_message`
CREATE TABLE `main_message` (
  `id` int(11) NOT NULL,
  `subject` text,
  `active_users` text,
  `blocked_users` text,
  `created_by` varchar(11) DEFAULT NULL,
  `created_date` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=MyISAM DEFAULT CHARSET=latin1;


-- --------------------------------------------------------

-- Table structure for table `make_driver_payments`
CREATE TABLE `make_driver_payments` (
  `id` int(100) NOT NULL,
  `driver_id` varchar(100) DEFAULT NULL,
  `amount` varchar(100) DEFAULT NULL,
  `transaction_id` varchar(100) DEFAULT NULL,
  `payment_date` date DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=latin1;


-- --------------------------------------------------------

-- Table structure for table `merchants`
CREATE TABLE `merchants` (
  `id` int(100) NOT NULL,
  `email` varchar(100) NOT NULL,
  `password` varchar(100) NOT NULL,
  `phone` varchar(100) NOT NULL,
  `cat_id` int(50) NOT NULL,
  `artist_name` varchar(150) NOT NULL,
  `verification_code` int(10) DEFAULT NULL,
  `verification_status` int(10) NOT NULL DEFAULT '0',
  `gcm_token` varchar(330) DEFAULT NULL,
  `fixed` varchar(50) NOT NULL,
  `hourly` varchar(50) NOT NULL,
  `concert` varchar(50) NOT NULL,
  `bio` varchar(225) NOT NULL,
  `event_id` varchar(100) NOT NULL,
  `website` varchar(100) NOT NULL,
  `lat` varchar(100) NOT NULL,
  `lng` varchar(100) NOT NULL,
  `type` varchar(100) NOT NULL,
  `approval_status` tinyint(2) NOT NULL DEFAULT '0',
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=MyISAM DEFAULT CHARSET=latin1;


-- --------------------------------------------------------

-- Table structure for table `messages`
CREATE TABLE `messages` (
  `id` int(11) NOT NULL,
  `subject` varchar(255) COLLATE utf8_unicode_ci DEFAULT 'Untitled',
  `message` mediumtext COLLATE utf8_unicode_ci,
  `created_at` datetime DEFAULT NULL,
  `group_id` varchar(100) COLLATE utf8_unicode_ci DEFAULT '0' COMMENT 'message in group',
  `trip_id` varchar(100) COLLATE utf8_unicode_ci DEFAULT '0' COMMENT 'message in trip',
  `user_id` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `status` enum('unread','read') COLLATE utf8_unicode_ci NOT NULL DEFAULT 'unread',
  `message_id` int(11) NOT NULL DEFAULT '0',
  `deleted` int(1) NOT NULL DEFAULT '0',
  `files` longtext COLLATE utf8_unicode_ci,
  `deleted_by_users` text COLLATE utf8_unicode_ci
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;


-- --------------------------------------------------------

-- Table structure for table `news_feed`
CREATE TABLE `news_feed` (
  `id` int(11) NOT NULL,
  `Title` text,
  `RoutingRuleDescription` text,
  `Description` text,
  `SmallImage` varchar(255) DEFAULT NULL,
  `BigImage` varchar(252) DEFAULT NULL,
  `Subject` text,
  `Date` varchar(50) DEFAULT NULL
) ENGINE=MyISAM DEFAULT CHARSET=utf8;


-- --------------------------------------------------------

-- Table structure for table `new_agreed_rate`
CREATE TABLE `new_agreed_rate` (
  `id` int(11) NOT NULL,
  `trip_id` int(11) NOT NULL,
  `start_date` datetime DEFAULT NULL,
  `pay_type` varchar(50) DEFAULT NULL,
  `currency` varchar(50) DEFAULT NULL,
  `amount` varchar(50) DEFAULT NULL,
  `sale_tax1` varchar(50) DEFAULT NULL,
  `sale_tax2` varchar(50) DEFAULT NULL,
  `total` varchar(50) DEFAULT NULL,
  `created_date` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=MyISAM DEFAULT CHARSET=latin1;


-- --------------------------------------------------------

-- Table structure for table `new_event`
CREATE TABLE `new_event` (
  `id` int(255) NOT NULL,
  `trip_id` int(255) DEFAULT NULL,
  `order_part` varchar(11) DEFAULT NULL,
  `trailer_code` text,
  `active_trailer` int(11) DEFAULT NULL,
  `active_truck` int(11) DEFAULT NULL,
  `active_carrier` int(11) DEFAULT NULL,
  `event_code` text NOT NULL,
  `pick_deliver_id` int(255) DEFAULT NULL,
  `s_no` int(11) DEFAULT NULL,
  `event_type` varchar(60) DEFAULT NULL,
  `equipment` varchar(200) DEFAULT NULL,
  `trailer_returning` int(11) DEFAULT NULL,
  `order` varchar(200) DEFAULT NULL,
  `relocate_reason` varchar(255) DEFAULT NULL,
  `relocate_date` datetime DEFAULT NULL,
  `location_type` varchar(200) DEFAULT NULL,
  `location_name` varchar(200) DEFAULT NULL,
  `location_address` varchar(200) DEFAULT NULL,
  `address_lat` double DEFAULT NULL,
  `address_long` double DEFAULT NULL,
  `city` varchar(255) NOT NULL,
  `city_lat` double DEFAULT NULL,
  `city_long` double DEFAULT NULL,
  `city_miles` varchar(255) NOT NULL,
  `state` varchar(255) NOT NULL,
  `start_time` varchar(200) DEFAULT NULL,
  `end_time` varchar(200) DEFAULT NULL,
  `event_status` varchar(200) DEFAULT NULL,
  `miles` double DEFAULT NULL,
  `select_shiment_ids` varchar(255) DEFAULT NULL,
  `no_of_shipment_selected` varchar(255) DEFAULT NULL,
  `activity_type` varchar(10) NOT NULL DEFAULT 'order' COMMENT 'event,order',
  `status` varchar(100) DEFAULT NULL,
  `created_date` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=latin1;


-- --------------------------------------------------------

-- Table structure for table `new_trip`
CREATE TABLE `new_trip` (
  `id` int(250) NOT NULL,
  `assignto` varchar(50) DEFAULT NULL,
  `start_date` datetime DEFAULT NULL,
  `carrier` int(50) DEFAULT NULL,
  `truck_no` varchar(50) DEFAULT NULL,
  `trailer_no` varchar(50) DEFAULT NULL,
  `driver1` varchar(200) DEFAULT NULL,
  `driver1_whopay` varchar(100) NOT NULL,
  `driver1_paytype` varchar(200) NOT NULL,
  `driver1_currency` varchar(255) DEFAULT NULL,
  `driver1_paytype_rate` varchar(200) NOT NULL,
  `driver1_saletax1` varchar(255) DEFAULT NULL,
  `driver1_saletax1_rate` varchar(255) DEFAULT NULL,
  `driver1_saletax2` varchar(255) DEFAULT NULL,
  `driver1_saletax2_rate` varchar(255) DEFAULT NULL,
  `driver2` varchar(200) NOT NULL,
  `driver2_whopay` varchar(200) NOT NULL,
  `driver2_paytype` varchar(200) NOT NULL,
  `driver2_currency` varchar(255) DEFAULT NULL,
  `driver2_paytype_rate` varchar(200) NOT NULL,
  `driver2_saletax1` varchar(255) DEFAULT NULL,
  `driver2_saletax1_rate` varchar(255) DEFAULT NULL,
  `driver2_saletax2` varchar(255) DEFAULT NULL,
  `driver2_saletax2_rate` varchar(255) DEFAULT NULL,
  `is_save` int(11) NOT NULL DEFAULT '0' COMMENT '1=save&publish,0=unsave	',
  `created_date` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `equipments` varchar(50) DEFAULT NULL,
  `trip_status` varchar(255) NOT NULL,
  `user_activity` varchar(255) NOT NULL,
  `user_activity_date` datetime NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;


-- --------------------------------------------------------

-- Table structure for table `omnitrac_gps_data`
CREATE TABLE `omnitrac_gps_data` (
  `id` bigint(20) NOT NULL,
  `tran_id` bigint(20) NOT NULL,
  `tran_companyID` int(255) NOT NULL,
  `company` varchar(20) NOT NULL,
  `tran_auxID` varchar(255) NOT NULL,
  `eventTS_timestamp` datetime NOT NULL,
  `equipment_ID` varchar(255) NOT NULL,
  `equipment_equipType` varchar(255) NOT NULL,
  `equipment_unitAddress` varchar(255) NOT NULL,
  `gps_address` text,
  `gps_city` varchar(100) DEFAULT NULL,
  `gps_state` varchar(50) DEFAULT NULL,
  `position_lon` varchar(255) NOT NULL,
  `position_lat` varchar(255) NOT NULL,
  `position_time_stamp` datetime NOT NULL,
  `proximity_postal` varchar(255) NOT NULL,
  `proximity_country` varchar(255) NOT NULL,
  `proximity_stateProv` varchar(255) NOT NULL,
  `proximity_city` varchar(255) NOT NULL,
  `proximity_direction` varchar(255) NOT NULL,
  `proximity_distance` varchar(255) NOT NULL,
  `proximity_placeType` varchar(255) NOT NULL,
  `proximity2_postal` varchar(255) NOT NULL,
  `proximity2_country` varchar(255) NOT NULL,
  `proximity2_stateProv` varchar(255) NOT NULL,
  `proximity2_city` varchar(255) NOT NULL,
  `proximity2_direction` varchar(255) NOT NULL,
  `proximity2_distance` varchar(255) NOT NULL,
  `proximity2_placeType` varchar(255) NOT NULL,
  `proximity3_postal` varchar(255) NOT NULL,
  `proximity3_country` varchar(255) NOT NULL,
  `proximity3_stateProv` varchar(255) NOT NULL,
  `proximity3_city` varchar(255) NOT NULL,
  `proximity3_direction` varchar(255) NOT NULL,
  `proximity3_distance` varchar(255) NOT NULL,
  `placeType_placeType` varchar(255) NOT NULL,
  `posType` varchar(255) NOT NULL,
  `ignitionStatus` varchar(255) NOT NULL,
  `tripStatus` varchar(255) NOT NULL,
  `ltdDistance` varchar(255) NOT NULL,
  `speed` varchar(255) NOT NULL,
  `odometer` varchar(255) NOT NULL,
  `date_created` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `driver1` varchar(255) NOT NULL,
  `driver2` varchar(255) NOT NULL
) ENGINE=MyISAM DEFAULT CHARSET=latin1;


-- --------------------------------------------------------

-- Table structure for table `orderlane`
CREATE TABLE `orderlane` (
  `id` int(10) NOT NULL,
  `orderlane` varchar(100) NOT NULL,
  `pu_states_included` varchar(255) NOT NULL,
  `pu_states_excluded` varchar(255) NOT NULL,
  `del_states_included` varchar(255) NOT NULL,
  `del_states_excluded` varchar(255) NOT NULL,
  `pu_states_included_or` text NOT NULL,
  `pu_states_excluded_or` text NOT NULL,
  `del_states_included_or` text NOT NULL,
  `del_states_excluded_or` text NOT NULL,
  `orderlane_pickup_complete` varchar(10) NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=latin1;


-- --------------------------------------------------------

-- Table structure for table `orders`
CREATE TABLE `orders` (
  `id` int(255) NOT NULL,
  `Temp_Id` int(255) NOT NULL,
  `customer` int(255) DEFAULT NULL,
  `customer_po` varchar(100) DEFAULT NULL,
  `cust_email` varchar(100) DEFAULT NULL,
  `person_email` varchar(100) DEFAULT NULL,
  `alternate_emails` longtext,
  `booked_with` varchar(100) DEFAULT NULL,
  `order_status` varchar(100) DEFAULT NULL,
  `cancel_reason` text,
  `cancel_by_user` int(11) DEFAULT NULL,
  `cancel_date` datetime DEFAULT NULL,
  `order_progress` varchar(100) DEFAULT NULL,
  `ouf_pickup` varchar(100) DEFAULT NULL,
  `ouf_delivery` varchar(100) DEFAULT NULL,
  `ouf_time_interval` varchar(100) DEFAULT NULL,
  `intervals` varchar(100) DEFAULT NULL,
  `order_steps` tinyint(1) NOT NULL DEFAULT '0',
  `daily` varchar(100) DEFAULT NULL,
  `hourly` varchar(100) DEFAULT NULL,
  `mins` varchar(100) DEFAULT NULL,
  `orcurrency` varchar(100) DEFAULT NULL,
  `order_rate` varchar(100) DEFAULT NULL,
  `orsaletax1` varchar(100) DEFAULT NULL,
  `orsaletax2` varchar(100) DEFAULT NULL,
  `custom_broker` varchar(100) DEFAULT NULL,
  `pars_paps` varchar(100) DEFAULT NULL,
  `csa_fast` tinyint(1) DEFAULT '0',
  `bonded_us` tinyint(1) DEFAULT '0',
  `bonded_canada` tinyint(1) DEFAULT '0',
  `dangerous_goods` tinyint(1) DEFAULT '0',
  `high_value` tinyint(1) DEFAULT '0',
  `team_load` tinyint(1) DEFAULT '0',
  `dispatcher` varchar(100) DEFAULT NULL,
  `salesperson` varchar(100) DEFAULT NULL,
  `salesperson_commission` varchar(100) DEFAULT NULL,
  `com_value` varchar(25) DEFAULT NULL,
  `load_type` varchar(10) DEFAULT NULL,
  `feet` varchar(50) DEFAULT NULL,
  `total_order_miles` varchar(100) DEFAULT NULL,
  `order_price_per_mile` varchar(100) DEFAULT NULL,
  `order_cost_per_mile` varchar(100) DEFAULT NULL,
  `order_leg_price` varchar(100) DEFAULT NULL,
  `order_leg_cost` varchar(100) DEFAULT NULL,
  `order_leg_miles` varchar(100) DEFAULT NULL,
  `order_part_price` varchar(100) DEFAULT NULL,
  `order_part_cost` varchar(100) DEFAULT NULL,
  `order_part_miles` varchar(100) DEFAULT NULL,
  `delete_status` int(10) NOT NULL DEFAULT '0',
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `publish` varchar(10) NOT NULL DEFAULT '0',
  `order_total_charges` varchar(100) DEFAULT NULL,
  `order_base_charges` varchar(100) DEFAULT NULL,
  `trip_status` int(10) NOT NULL DEFAULT '0',
  `order_len` varchar(50) DEFAULT NULL,
  `order_group_id` int(11) DEFAULT NULL,
  `city_for_pickup` varchar(50) DEFAULT NULL,
  `del_for_pickup` varchar(50) DEFAULT NULL,
  `pickups_terminal` varchar(50) DEFAULT NULL,
  `delivery_terminal` varchar(50) DEFAULT NULL,
  `update_once` int(11) NOT NULL DEFAULT '0',
  `add_new_order` int(11) NOT NULL,
  `copy` int(11) NOT NULL DEFAULT '0',
  `order_date` datetime NOT NULL,
  `created_date` timestamp NOT NULL DEFAULT '0000-00-00 00:00:00'
) ENGINE=InnoDB DEFAULT CHARSET=latin1;


-- --------------------------------------------------------

-- Table structure for table `orders_main`
CREATE TABLE `orders_main` (
  `id` int(255) NOT NULL,
  `Temp_Id` int(255) NOT NULL,
  `customer` int(255) DEFAULT NULL,
  `customer_po` varchar(100) DEFAULT NULL,
  `cust_email` varchar(100) DEFAULT NULL,
  `person_email` varchar(100) DEFAULT NULL,
  `alternate_emails` longtext,
  `booked_with` varchar(100) DEFAULT NULL,
  `order_status` varchar(100) DEFAULT NULL,
  `order_progress` varchar(100) DEFAULT NULL,
  `ouf_pickup` varchar(100) DEFAULT NULL,
  `ouf_delivery` varchar(100) DEFAULT NULL,
  `ouf_time_interval` varchar(100) DEFAULT NULL,
  `intervals` varchar(100) DEFAULT NULL,
  `order_steps` tinyint(1) NOT NULL DEFAULT '0',
  `daily` varchar(100) DEFAULT NULL,
  `hourly` varchar(100) DEFAULT NULL,
  `mins` varchar(100) DEFAULT NULL,
  `orcurrency` varchar(100) DEFAULT NULL,
  `order_rate` varchar(100) DEFAULT NULL,
  `orsaletax1` varchar(100) DEFAULT NULL,
  `orsaletax2` varchar(100) DEFAULT NULL,
  `custom_broker` varchar(100) DEFAULT NULL,
  `pars_paps` varchar(100) DEFAULT NULL,
  `csa_fast` tinyint(1) DEFAULT '0',
  `bonded_us` tinyint(1) DEFAULT '0',
  `bonded_canada` tinyint(1) DEFAULT '0',
  `dangerous_goods` tinyint(1) DEFAULT '0',
  `high_value` tinyint(1) DEFAULT '0',
  `team_load` tinyint(1) DEFAULT '0',
  `dispatcher` varchar(100) DEFAULT NULL,
  `salesperson` varchar(100) DEFAULT NULL,
  `salesperson_commission` varchar(100) DEFAULT NULL,
  `com_value` varchar(25) DEFAULT NULL,
  `load_type` varchar(10) DEFAULT NULL,
  `feet` varchar(50) DEFAULT NULL,
  `total_order_miles` varchar(100) DEFAULT NULL,
  `order_price_per_mile` varchar(100) DEFAULT NULL,
  `order_cost_per_mile` varchar(100) DEFAULT NULL,
  `order_leg_price` varchar(100) DEFAULT NULL,
  `order_leg_cost` varchar(100) DEFAULT NULL,
  `order_leg_miles` varchar(100) DEFAULT NULL,
  `order_part_price` varchar(100) DEFAULT NULL,
  `order_part_cost` varchar(100) DEFAULT NULL,
  `order_part_miles` varchar(100) DEFAULT NULL,
  `delete_status` int(10) NOT NULL DEFAULT '0',
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `publish` varchar(10) NOT NULL DEFAULT '0',
  `order_total_charges` varchar(100) DEFAULT NULL,
  `order_base_charges` varchar(100) DEFAULT NULL,
  `trip_status` int(10) NOT NULL DEFAULT '0',
  `order_len` varchar(50) DEFAULT NULL,
  `city_for_pickup` varchar(50) DEFAULT NULL,
  `del_for_pickup` varchar(50) DEFAULT NULL,
  `pickups_terminal` varchar(50) DEFAULT NULL,
  `delivery_terminal` varchar(50) DEFAULT NULL,
  `update_once` int(11) NOT NULL DEFAULT '0',
  `add_new_order` int(11) NOT NULL,
  `copy` int(11) NOT NULL DEFAULT '0'
) ENGINE=InnoDB DEFAULT CHARSET=latin1;


-- --------------------------------------------------------

-- Table structure for table `order_additional_charges`
CREATE TABLE `order_additional_charges` (
  `id` int(100) NOT NULL,
  `order_id` int(250) NOT NULL,
  `additional_charge` varchar(50) NOT NULL,
  `accurrency` varchar(100) NOT NULL,
  `acrate` decimal(10,2) NOT NULL,
  `acsaletax1` varchar(100) NOT NULL,
  `acsaletax2` varchar(100) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;


-- --------------------------------------------------------

-- Table structure for table `order_additional_charges_main`
CREATE TABLE `order_additional_charges_main` (
  `id` int(100) NOT NULL,
  `order_id` int(250) NOT NULL,
  `additional_charge` varchar(100) NOT NULL,
  `accurrency` varchar(100) NOT NULL,
  `acrate` varchar(100) NOT NULL,
  `acsaletax1` varchar(100) NOT NULL,
  `acsaletax2` varchar(100) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;


-- --------------------------------------------------------

-- Table structure for table `order_alt_emails`
CREATE TABLE `order_alt_emails` (
  `id` int(100) NOT NULL,
  `order_id` varchar(100) NOT NULL,
  `alt_email` varchar(100) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;


-- --------------------------------------------------------

-- Table structure for table `order_delivery`
CREATE TABLE `order_delivery` (
  `id` int(255) NOT NULL,
  `order_id` int(255) DEFAULT NULL,
  `redirect_data` int(11) DEFAULT NULL,
  `Temp_delivery_id` int(255) DEFAULT NULL,
  `delivery_shipper` int(255) DEFAULT NULL,
  `shipper_address` varchar(100) DEFAULT NULL,
  `address_lat` double NOT NULL,
  `address_long` double NOT NULL,
  `city` varchar(255) NOT NULL,
  `city_lat` double NOT NULL,
  `city_long` double NOT NULL,
  `state` varchar(255) NOT NULL,
  `delivery_appt` varchar(100) DEFAULT NULL,
  `delivery_date` date DEFAULT NULL,
  `delivery_time` time DEFAULT NULL,
  `delivery_ref_no` varchar(100) DEFAULT NULL,
  `delivery_additional_info` varchar(100) DEFAULT NULL,
  `reciever_timing` varchar(100) DEFAULT NULL,
  `reciever_note` varchar(100) DEFAULT NULL,
  `delivery_equipment` varchar(100) DEFAULT NULL,
  `delivery_attributes` varchar(100) DEFAULT NULL,
  `delivery_temperature` varchar(100) DEFAULT NULL,
  `delivery_hazardous` varchar(100) DEFAULT NULL,
  `delivery_custom_broker` varchar(100) DEFAULT NULL,
  `copy` int(11) NOT NULL DEFAULT '0'
) ENGINE=InnoDB DEFAULT CHARSET=latin1;


-- --------------------------------------------------------

-- Table structure for table `order_delivery_info_meta`
CREATE TABLE `order_delivery_info_meta` (
  `id` int(100) NOT NULL,
  `order_id` varchar(100) DEFAULT NULL,
  `delivery_id` varchar(100) DEFAULT NULL,
  `delivery_uno` varchar(100) DEFAULT NULL,
  `delivery_shipper` varchar(100) DEFAULT NULL,
  `shipper_address` varchar(100) DEFAULT NULL,
  `delivery_appt` varchar(100) DEFAULT NULL,
  `delivery_date` date DEFAULT NULL,
  `delivery_time` time DEFAULT NULL,
  `delivery_ref_no` varchar(100) DEFAULT NULL,
  `delivery_additional_info` varchar(100) DEFAULT NULL,
  `reciever_timing` varchar(100) DEFAULT NULL,
  `reciever_note` varchar(100) DEFAULT NULL,
  `delivery_equipment` varchar(100) DEFAULT NULL,
  `delivery_attributes` varchar(100) DEFAULT NULL,
  `delivery_temperature` varchar(100) DEFAULT NULL,
  `delivery_hazardous` varchar(100) DEFAULT NULL,
  `delivery_custom_broker` varchar(100) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;


-- --------------------------------------------------------

-- Table structure for table `order_delivery_info_meta_main`
CREATE TABLE `order_delivery_info_meta_main` (
  `id` int(100) NOT NULL,
  `order_id` varchar(100) DEFAULT NULL,
  `delivery_id` varchar(100) DEFAULT NULL,
  `delivery_uno` varchar(100) DEFAULT NULL,
  `delivery_shipper` varchar(100) DEFAULT NULL,
  `shipper_address` varchar(100) DEFAULT NULL,
  `delivery_appt` varchar(100) DEFAULT NULL,
  `delivery_date` date DEFAULT NULL,
  `delivery_time` time DEFAULT NULL,
  `delivery_ref_no` varchar(100) DEFAULT NULL,
  `delivery_additional_info` varchar(100) DEFAULT NULL,
  `reciever_timing` varchar(100) DEFAULT NULL,
  `reciever_note` varchar(100) DEFAULT NULL,
  `delivery_equipment` varchar(100) DEFAULT NULL,
  `delivery_attributes` varchar(100) DEFAULT NULL,
  `delivery_temperature` varchar(100) DEFAULT NULL,
  `delivery_hazardous` varchar(100) DEFAULT NULL,
  `delivery_custom_broker` varchar(100) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;


-- --------------------------------------------------------

-- Table structure for table `order_delivery_main`
CREATE TABLE `order_delivery_main` (
  `id` int(255) NOT NULL,
  `Temp_delivery_id` int(255) NOT NULL,
  `order_id` int(255) DEFAULT NULL,
  `delivery_shipper` int(255) DEFAULT NULL,
  `shipper_address` varchar(100) DEFAULT NULL,
  `delivery_appt` varchar(100) DEFAULT NULL,
  `delivery_date` date DEFAULT NULL,
  `delivery_time` time DEFAULT NULL,
  `delivery_ref_no` varchar(100) DEFAULT NULL,
  `delivery_additional_info` varchar(100) DEFAULT NULL,
  `reciever_timing` varchar(100) DEFAULT NULL,
  `reciever_note` varchar(100) DEFAULT NULL,
  `delivery_equipment` varchar(100) DEFAULT NULL,
  `delivery_attributes` varchar(100) DEFAULT NULL,
  `delivery_temperature` varchar(100) DEFAULT NULL,
  `delivery_hazardous` varchar(100) DEFAULT NULL,
  `delivery_custom_broker` varchar(100) DEFAULT NULL,
  `copy` int(11) NOT NULL DEFAULT '0'
) ENGINE=InnoDB DEFAULT CHARSET=latin1;


-- --------------------------------------------------------

-- Table structure for table `order_delivery_new`
CREATE TABLE `order_delivery_new` (
  `id` int(150) NOT NULL,
  `order_id` varchar(100) DEFAULT NULL,
  `delivery_shipper` varchar(100) DEFAULT NULL,
  `delivery_appt` varchar(100) DEFAULT NULL,
  `delivery_date` varchar(100) DEFAULT NULL,
  `delivery_time` varchar(100) DEFAULT NULL,
  `delivery_ref_no` varchar(100) DEFAULT NULL,
  `delivery_additional_info` varchar(100) DEFAULT NULL,
  `reciever_timing` varchar(100) DEFAULT NULL,
  `reciever_note` varchar(100) DEFAULT NULL,
  `delivery_equipment` varchar(100) DEFAULT NULL,
  `delivery_attributes` varchar(100) DEFAULT NULL,
  `delivery_temperature` varchar(100) DEFAULT NULL,
  `delivery_hazardous` varchar(100) DEFAULT NULL,
  `delivery_custom_broker` varchar(100) DEFAULT NULL,
  `skid_shipment_no` varchar(100) DEFAULT NULL,
  `skid_shipment_barcode` varchar(100) DEFAULT NULL,
  `skid_shipment_description` varchar(100) DEFAULT NULL,
  `skid_no_pcs` varchar(100) DEFAULT NULL,
  `skid_stackable` varchar(100) DEFAULT NULL,
  `skid_wmu` varchar(100) DEFAULT NULL,
  `skid_weight` varchar(100) DEFAULT NULL,
  `skid_lwh_mu` varchar(100) DEFAULT NULL,
  `skid_length` varchar(100) DEFAULT NULL,
  `skid_width` varchar(100) DEFAULT NULL,
  `skid_height` varchar(100) DEFAULT NULL,
  `skid_cubic_ft` varchar(100) DEFAULT NULL,
  `skid_linear_ft` varchar(100) DEFAULT NULL,
  `skid_picture` varchar(100) DEFAULT NULL,
  `crate_shipment_no` varchar(100) DEFAULT NULL,
  `crate_shipment_barcode` varchar(100) DEFAULT NULL,
  `crate_shipment_description` varchar(100) DEFAULT NULL,
  `crate_no_pcs` varchar(100) DEFAULT NULL,
  `crate_stackable` varchar(100) DEFAULT NULL,
  `crate_wmu` varchar(100) DEFAULT NULL,
  `crate_weight` varchar(100) DEFAULT NULL,
  `crate_lwh_mu` varchar(100) DEFAULT NULL,
  `crate_length` varchar(100) DEFAULT NULL,
  `crate_width` varchar(100) DEFAULT NULL,
  `crate_height` varchar(100) DEFAULT NULL,
  `crate_cubic_ft` varchar(100) DEFAULT NULL,
  `crate_linear_ft` varchar(100) DEFAULT NULL,
  `crate_picture` varchar(100) DEFAULT NULL,
  `pices_shipment_no` varchar(100) DEFAULT NULL,
  `pices_shipment_barcode` varchar(100) DEFAULT NULL,
  `pices_shipment_description` varchar(100) DEFAULT NULL,
  `pices_no_pcs` varchar(100) DEFAULT NULL,
  `pices_stackable` varchar(100) DEFAULT NULL,
  `pices_wmu` varchar(100) DEFAULT NULL,
  `pices_weight` varchar(100) DEFAULT NULL,
  `pices_lwh_mu` varchar(100) DEFAULT NULL,
  `pices_length` varchar(100) DEFAULT NULL,
  `pices_width` varchar(100) DEFAULT NULL,
  `pices_height` varchar(100) DEFAULT NULL,
  `pices_cubic_ft` varchar(100) DEFAULT NULL,
  `pices_linear_ft` varchar(100) DEFAULT NULL,
  `pices_picture` varchar(100) DEFAULT NULL,
  `box_shipment_no` varchar(100) DEFAULT NULL,
  `box_shipment_barcode` varchar(100) DEFAULT NULL,
  `box_shipment_description` varchar(100) DEFAULT NULL,
  `box_no_pcs` varchar(100) DEFAULT NULL,
  `box_stackable` varchar(100) DEFAULT NULL,
  `box_wmu` varchar(100) DEFAULT NULL,
  `box_weight` varchar(100) DEFAULT NULL,
  `box_lwh_mu` varchar(100) DEFAULT NULL,
  `box_length` varchar(100) DEFAULT NULL,
  `box_width` varchar(100) DEFAULT NULL,
  `box_height` varchar(100) DEFAULT NULL,
  `box_cubic_ft` varchar(100) DEFAULT NULL,
  `box_linear_ft` varchar(100) DEFAULT NULL,
  `box_picture` varchar(100) DEFAULT NULL,
  `tyres_shipment_no` varchar(100) DEFAULT NULL,
  `tyres_shipment_barcode` varchar(100) DEFAULT NULL,
  `tyres_shipment_description` varchar(100) DEFAULT NULL,
  `tyres_no_pcs` varchar(100) DEFAULT NULL,
  `tyres_stackable` varchar(100) DEFAULT NULL,
  `tyres_wmu` varchar(100) DEFAULT NULL,
  `tyres_weight` varchar(100) DEFAULT NULL,
  `tyres_lwh_mu` varchar(100) DEFAULT NULL,
  `tyres_length` varchar(100) DEFAULT NULL,
  `tyres_width` varchar(100) DEFAULT NULL,
  `tyres_height` varchar(100) DEFAULT NULL,
  `tyres_cubic_ft` varchar(100) DEFAULT NULL,
  `tyres_linear_ft` varchar(100) DEFAULT NULL,
  `tyres_picture` varchar(100) DEFAULT NULL,
  `etc_shipment_no` varchar(100) DEFAULT NULL,
  `etc_shipment_barcode` varchar(100) DEFAULT NULL,
  `etc_shipment_description` varchar(100) DEFAULT NULL,
  `etc_no_pcs` varchar(100) DEFAULT NULL,
  `etc_stackable` varchar(100) DEFAULT NULL,
  `etc_wmu` varchar(100) DEFAULT NULL,
  `etc_weight` varchar(100) DEFAULT NULL,
  `etc_lwh_mu` varchar(100) DEFAULT NULL,
  `etc_length` varchar(100) DEFAULT NULL,
  `etc_width` varchar(100) DEFAULT NULL,
  `etc_height` varchar(100) DEFAULT NULL,
  `etc_cubic_ft` varchar(100) DEFAULT NULL,
  `etc_linear_ft` varchar(100) DEFAULT NULL,
  `etc_picture` varchar(100) DEFAULT NULL
) ENGINE=MyISAM DEFAULT CHARSET=latin1;


-- --------------------------------------------------------

-- Table structure for table `order_delivery_shipments`
CREATE TABLE `order_delivery_shipments` (
  `id` int(100) NOT NULL,
  `order_id` varchar(100) DEFAULT NULL,
  `delivery_id` varchar(100) DEFAULT NULL,
  `shipment_no` varchar(100) DEFAULT NULL,
  `delivery_shipment_barcode` varchar(100) DEFAULT NULL,
  `delivery_shipment_description` varchar(100) DEFAULT NULL,
  `delivery_no_pcs` varchar(100) DEFAULT NULL,
  `delivery_stackable` varchar(100) DEFAULT NULL,
  `delivery_wmu` varchar(100) DEFAULT NULL,
  `delivery_weight` varchar(100) DEFAULT NULL,
  `delivery_lwh_mu` varchar(100) DEFAULT NULL,
  `delivery_length` varchar(100) DEFAULT NULL,
  `delivery_width` varchar(100) DEFAULT NULL,
  `delivery_height` varchar(100) DEFAULT NULL,
  `delivery_cubic_ft` varchar(100) DEFAULT NULL,
  `delivery_linear_ft` varchar(100) DEFAULT NULL,
  `delivery_picture` varchar(150) DEFAULT NULL
) ENGINE=MyISAM DEFAULT CHARSET=latin1;


-- --------------------------------------------------------

-- Table structure for table `order_delivery_shipments_main`
CREATE TABLE `order_delivery_shipments_main` (
  `id` int(100) NOT NULL,
  `order_id` varchar(100) DEFAULT NULL,
  `delivery_id` varchar(100) DEFAULT NULL,
  `shipment_no` varchar(100) DEFAULT NULL,
  `delivery_shipment_barcode` varchar(100) DEFAULT NULL,
  `delivery_shipment_description` varchar(100) DEFAULT NULL,
  `delivery_no_pcs` varchar(100) DEFAULT NULL,
  `delivery_stackable` varchar(100) DEFAULT NULL,
  `delivery_wmu` varchar(100) DEFAULT NULL,
  `delivery_weight` varchar(100) DEFAULT NULL,
  `delivery_lwh_mu` varchar(100) DEFAULT NULL,
  `delivery_length` varchar(100) DEFAULT NULL,
  `delivery_width` varchar(100) DEFAULT NULL,
  `delivery_height` varchar(100) DEFAULT NULL,
  `delivery_cubic_ft` varchar(100) DEFAULT NULL,
  `delivery_linear_ft` varchar(100) DEFAULT NULL,
  `delivery_picture` varchar(150) DEFAULT NULL
) ENGINE=MyISAM DEFAULT CHARSET=latin1;


-- --------------------------------------------------------

-- Table structure for table `order_delivery_shipments_meta`
CREATE TABLE `order_delivery_shipments_meta` (
  `id` int(100) NOT NULL,
  `shipment_id` varchar(50) DEFAULT NULL,
  `pickups_id` varchar(50) DEFAULT NULL,
  `order_id` varchar(100) DEFAULT NULL,
  `delivery_id` varchar(100) DEFAULT NULL,
  `key_id` varchar(100) DEFAULT NULL,
  `delivery_uno` varchar(100) DEFAULT NULL,
  `iid` varchar(100) DEFAULT '1',
  `parent_id` varchar(100) DEFAULT '0',
  `shipment_no` varchar(100) NOT NULL,
  `delivery_shipment_barcode` varchar(100) NOT NULL,
  `delivery_shipment_description` varchar(100) NOT NULL,
  `commodity` varchar(100) DEFAULT NULL,
  `delivery_no_pcs` varchar(100) NOT NULL,
  `delivery_stackable` varchar(100) NOT NULL,
  `delivery_wmu` varchar(100) NOT NULL,
  `delivery_weight` varchar(100) NOT NULL,
  `delivery_lwh_mu` varchar(100) NOT NULL,
  `delivery_length` varchar(100) NOT NULL,
  `delivery_width` varchar(100) NOT NULL,
  `delivery_height` varchar(100) NOT NULL,
  `delivery_cubic_ft` varchar(100) NOT NULL,
  `delivery_linear_ft` varchar(100) NOT NULL,
  `delivery_picture` varchar(150) DEFAULT NULL,
  `delivery_shipper` varchar(100) DEFAULT NULL,
  `shipper_address` varchar(100) DEFAULT NULL,
  `delivery_appt` varchar(100) DEFAULT NULL,
  `delivery_date` date DEFAULT NULL,
  `delivery_time` time DEFAULT NULL,
  `delivery_ref_no` varchar(100) DEFAULT NULL,
  `delivery_additional_info` varchar(100) DEFAULT NULL,
  `reciever_timing` varchar(100) DEFAULT NULL,
  `reciever_note` varchar(100) DEFAULT NULL,
  `delivery_equipment` varchar(100) DEFAULT NULL,
  `delivery_attributes` varchar(100) DEFAULT NULL,
  `delivery_temperature` varchar(100) DEFAULT NULL,
  `delivery_hazardous` varchar(100) DEFAULT NULL,
  `delivery_custom_broker` varchar(100) DEFAULT NULL
) ENGINE=MyISAM DEFAULT CHARSET=latin1;


-- --------------------------------------------------------

-- Table structure for table `order_delivery_shipments_meta_main`
CREATE TABLE `order_delivery_shipments_meta_main` (
  `id` int(100) NOT NULL,
  `shipment_id` varchar(50) DEFAULT NULL,
  `pickups_id` varchar(50) DEFAULT NULL,
  `order_id` varchar(100) DEFAULT NULL,
  `delivery_id` varchar(100) DEFAULT NULL,
  `key_id` varchar(100) DEFAULT NULL,
  `delivery_uno` varchar(100) DEFAULT NULL,
  `iid` varchar(100) DEFAULT '1',
  `parent_id` varchar(100) DEFAULT '0',
  `shipment_no` varchar(100) NOT NULL,
  `delivery_shipment_barcode` varchar(100) NOT NULL,
  `delivery_shipment_description` varchar(100) NOT NULL,
  `commodity` varchar(100) DEFAULT NULL,
  `delivery_no_pcs` varchar(100) NOT NULL,
  `delivery_stackable` varchar(100) NOT NULL,
  `delivery_wmu` varchar(100) NOT NULL,
  `delivery_weight` varchar(100) NOT NULL,
  `delivery_lwh_mu` varchar(100) NOT NULL,
  `delivery_length` varchar(100) NOT NULL,
  `delivery_width` varchar(100) NOT NULL,
  `delivery_height` varchar(100) NOT NULL,
  `delivery_cubic_ft` varchar(100) NOT NULL,
  `delivery_linear_ft` varchar(100) NOT NULL,
  `delivery_picture` varchar(150) DEFAULT NULL,
  `delivery_shipper` varchar(100) DEFAULT NULL,
  `shipper_address` varchar(100) DEFAULT NULL,
  `delivery_appt` varchar(100) DEFAULT NULL,
  `delivery_date` date DEFAULT NULL,
  `delivery_time` time DEFAULT NULL,
  `delivery_ref_no` varchar(100) DEFAULT NULL,
  `delivery_additional_info` varchar(100) DEFAULT NULL,
  `reciever_timing` varchar(100) DEFAULT NULL,
  `reciever_note` varchar(100) DEFAULT NULL,
  `delivery_equipment` varchar(100) DEFAULT NULL,
  `delivery_attributes` varchar(100) DEFAULT NULL,
  `delivery_temperature` varchar(100) DEFAULT NULL,
  `delivery_hazardous` varchar(100) DEFAULT NULL,
  `delivery_custom_broker` varchar(100) DEFAULT NULL
) ENGINE=MyISAM DEFAULT CHARSET=latin1;


-- --------------------------------------------------------

-- Table structure for table `order_groups`
CREATE TABLE `order_groups` (
  `id` int(11) NOT NULL,
  `grp_name` varchar(255) DEFAULT NULL,
  `grp_location_type` varchar(255) DEFAULT NULL,
  `grp_location_name` varchar(255) DEFAULT NULL,
  `grp_address` text,
  `grp_lat` double DEFAULT NULL,
  `grp_long` double DEFAULT NULL,
  `grp_city` varchar(100) DEFAULT NULL,
  `grp_state` varchar(100) DEFAULT NULL,
  `grp_phone` varchar(100) DEFAULT NULL,
  `grp_email` varchar(200) DEFAULT NULL,
  `grp_website` varchar(200) DEFAULT NULL,
  `grp_logo` varchar(255) DEFAULT NULL,
  `status` varchar(10) DEFAULT NULL
) ENGINE=MyISAM DEFAULT CHARSET=latin1;


-- --------------------------------------------------------

-- Table structure for table `order_legs`
CREATE TABLE `order_legs` (
  `id` int(100) NOT NULL,
  `order_id` int(100) DEFAULT NULL,
  `leg_order_id` varchar(100) DEFAULT NULL,
  `pickup_location` longtext,
  `drop_location` longtext,
  `pickups_involved` longtext,
  `customer` varchar(100) DEFAULT NULL,
  `customer_po` varchar(100) DEFAULT NULL,
  `cust_email` varchar(100) DEFAULT NULL,
  `person_email` varchar(100) DEFAULT NULL,
  `alternate_emails` longtext,
  `booked_with` varchar(100) DEFAULT NULL,
  `order_status` varchar(100) DEFAULT NULL,
  `order_progress` varchar(100) DEFAULT NULL,
  `ouf_pickup` varchar(100) DEFAULT NULL,
  `ouf_delivery` varchar(100) DEFAULT NULL,
  `ouf_time_interval` varchar(100) DEFAULT NULL,
  `intervals` varchar(100) DEFAULT NULL,
  `order_steps` tinyint(1) NOT NULL DEFAULT '0',
  `daily` varchar(100) DEFAULT NULL,
  `hourly` varchar(100) DEFAULT NULL,
  `mins` varchar(100) DEFAULT NULL,
  `orcurrency` varchar(100) DEFAULT NULL,
  `order_rate` varchar(100) DEFAULT NULL,
  `orsaletax1` varchar(100) DEFAULT NULL,
  `orsaletax2` varchar(100) DEFAULT NULL,
  `custom_broker` varchar(100) DEFAULT NULL,
  `pars_paps` varchar(100) DEFAULT NULL,
  `csa_fast` tinyint(1) DEFAULT '0',
  `bonded_us` tinyint(1) DEFAULT '0',
  `bonded_canada` tinyint(1) DEFAULT '0',
  `dangerous_goods` tinyint(1) DEFAULT '0',
  `high_value` tinyint(1) DEFAULT '0',
  `team_load` tinyint(1) DEFAULT '0',
  `dispatcher` varchar(100) DEFAULT NULL,
  `salesperson` varchar(100) DEFAULT NULL,
  `salesperson_commission` varchar(100) DEFAULT NULL,
  `com_value` varchar(25) DEFAULT NULL,
  `load_type` varchar(10) DEFAULT NULL,
  `feet` varchar(50) DEFAULT NULL,
  `total_order_miles` varchar(100) DEFAULT NULL,
  `order_price_per_mile` varchar(100) DEFAULT NULL,
  `order_cost_per_mile` varchar(100) DEFAULT NULL,
  `order_leg_price` varchar(100) DEFAULT NULL,
  `order_leg_cost` varchar(100) DEFAULT NULL,
  `order_leg_miles` varchar(100) DEFAULT NULL,
  `order_part_price` varchar(100) DEFAULT NULL,
  `order_part_cost` varchar(100) DEFAULT NULL,
  `order_part_miles` varchar(100) DEFAULT NULL,
  `delete_status` int(10) NOT NULL DEFAULT '0',
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `publish` varchar(10) NOT NULL DEFAULT '0',
  `parts_status` int(5) NOT NULL DEFAULT '0',
  `trip_status` int(10) NOT NULL DEFAULT '0'
) ENGINE=MyISAM DEFAULT CHARSET=latin1;


-- --------------------------------------------------------

-- Table structure for table `order_legs2`
CREATE TABLE `order_legs2` (
  `id` int(100) NOT NULL,
  `order_id` int(100) DEFAULT NULL,
  `leg_order_id` varchar(100) DEFAULT NULL,
  `pickup_location` longtext,
  `drop_location` longtext,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=MyISAM DEFAULT CHARSET=latin1;


-- --------------------------------------------------------

-- Table structure for table `order_notes`
CREATE TABLE `order_notes` (
  `id` int(100) NOT NULL,
  `order_id` varchar(100) NOT NULL,
  `order_notes` varchar(100) NOT NULL,
  `added_by` varchar(100) NOT NULL,
  `note_date_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=latin1;


-- --------------------------------------------------------

-- Table structure for table `order_notes_main`
CREATE TABLE `order_notes_main` (
  `id` int(100) NOT NULL,
  `order_id` varchar(100) NOT NULL,
  `order_notes` varchar(100) NOT NULL,
  `added_by` varchar(100) NOT NULL,
  `note_date_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=latin1;


-- --------------------------------------------------------

-- Table structure for table `order_parts`
CREATE TABLE `order_parts` (
  `id` int(100) NOT NULL,
  `order_id` varchar(100) DEFAULT NULL,
  `part_id` varchar(100) DEFAULT NULL,
  `nopcs` varchar(100) DEFAULT NULL,
  `type` varchar(100) DEFAULT NULL,
  `trip_status` int(10) NOT NULL DEFAULT '0'
) ENGINE=MyISAM DEFAULT CHARSET=latin1;


-- --------------------------------------------------------

-- Table structure for table `order_pickups`
CREATE TABLE `order_pickups` (
  `id` int(255) NOT NULL,
  `temp_pickup_id` int(255) NOT NULL,
  `order_id` int(255) DEFAULT NULL,
  `generated_delivery_id` varchar(100) DEFAULT NULL,
  `pickup_shipper` int(255) DEFAULT NULL,
  `shipper_address` varchar(100) DEFAULT NULL,
  `address_lat` double NOT NULL,
  `address_long` double NOT NULL,
  `city` varchar(255) NOT NULL,
  `city_lat` double NOT NULL,
  `city_long` double NOT NULL,
  `state` varchar(255) NOT NULL,
  `pickup_appt` varchar(100) DEFAULT NULL,
  `pickup_date` varchar(100) DEFAULT NULL,
  `pickup_time` time DEFAULT NULL,
  `pickup_ref_no` varchar(100) DEFAULT NULL,
  `pickup_additional_info` varchar(100) DEFAULT NULL,
  `shipper_timing` varchar(100) DEFAULT NULL,
  `shipper_notes` varchar(100) DEFAULT NULL,
  `pickup_equipment` varchar(100) DEFAULT NULL,
  `pickup_attributes` varchar(100) DEFAULT NULL,
  `pickup_temperature` varchar(100) DEFAULT NULL,
  `pickup_hazardous` varchar(100) DEFAULT NULL,
  `pickup_custom_broker` varchar(100) DEFAULT NULL,
  `pickup_shipment_status` varchar(100) DEFAULT NULL,
  `loaded_on` varchar(100) DEFAULT NULL,
  `publish` int(11) NOT NULL DEFAULT '1',
  `copy` int(11) NOT NULL DEFAULT '0'
) ENGINE=InnoDB DEFAULT CHARSET=latin1;


-- --------------------------------------------------------

-- Table structure for table `order_pickups_main`
CREATE TABLE `order_pickups_main` (
  `id` int(255) NOT NULL,
  `temp_pickup_id` int(255) NOT NULL,
  `order_id` int(255) DEFAULT NULL,
  `generated_delivery_id` varchar(100) DEFAULT NULL,
  `pickup_shipper` int(255) DEFAULT NULL,
  `shipper_address` varchar(100) DEFAULT NULL,
  `pickup_appt` varchar(100) DEFAULT NULL,
  `pickup_date` varchar(100) DEFAULT NULL,
  `pickup_time` time DEFAULT NULL,
  `pickup_ref_no` varchar(100) DEFAULT NULL,
  `pickup_additional_info` varchar(100) DEFAULT NULL,
  `shipper_timing` varchar(100) DEFAULT NULL,
  `shipper_notes` varchar(100) DEFAULT NULL,
  `pickup_equipment` varchar(100) DEFAULT NULL,
  `pickup_attributes` varchar(100) DEFAULT NULL,
  `pickup_temperature` varchar(100) DEFAULT NULL,
  `pickup_hazardous` varchar(100) DEFAULT NULL,
  `pickup_custom_broker` varchar(100) DEFAULT NULL,
  `pickup_shipment_status` varchar(100) DEFAULT NULL,
  `loaded_on` varchar(100) DEFAULT NULL,
  `publish` int(11) NOT NULL DEFAULT '1',
  `copy` int(11) NOT NULL DEFAULT '0'
) ENGINE=InnoDB DEFAULT CHARSET=latin1;


-- --------------------------------------------------------

-- Table structure for table `order_pickups_shipment`
CREATE TABLE `order_pickups_shipment` (
  `id` int(255) NOT NULL,
  `pickups_id` int(255) DEFAULT NULL,
  `temp_shipment_id` int(255) NOT NULL,
  `order_id` int(255) DEFAULT NULL,
  `redirect_data` int(11) DEFAULT NULL,
  `pickup_shipment_no` int(255) DEFAULT NULL,
  `pickup_shipment_barcode` varchar(100) DEFAULT NULL,
  `pickup_shipment_description` varchar(100) DEFAULT NULL,
  `commodity` varchar(100) DEFAULT NULL,
  `pickup_no_pcs` varchar(100) DEFAULT NULL,
  `pickup_stackable` varchar(100) DEFAULT NULL,
  `pickup_wmu` varchar(100) DEFAULT NULL,
  `pickup_weight` varchar(100) DEFAULT NULL,
  `pickup_lwh_mu` varchar(100) DEFAULT NULL,
  `pickup_length` varchar(100) DEFAULT NULL,
  `pickup_width` varchar(100) DEFAULT NULL,
  `pickup_height` varchar(100) DEFAULT NULL,
  `pickup_cubic_ft` varchar(100) DEFAULT NULL,
  `pickup_linear_ft` varchar(100) DEFAULT NULL,
  `pickup_picture` varchar(150) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `copy` int(11) NOT NULL DEFAULT '0'
) ENGINE=InnoDB DEFAULT CHARSET=latin1;


-- --------------------------------------------------------

-- Table structure for table `order_pickups_shipment_main`
CREATE TABLE `order_pickups_shipment_main` (
  `id` int(255) NOT NULL,
  `pickups_id` int(255) DEFAULT NULL,
  `temp_shipment_id` int(255) NOT NULL,
  `order_id` int(255) NOT NULL,
  `pickup_shipment_no` int(255) DEFAULT NULL,
  `pickup_shipment_barcode` varchar(100) DEFAULT NULL,
  `pickup_shipment_description` varchar(100) DEFAULT NULL,
  `commodity` varchar(100) DEFAULT NULL,
  `pickup_no_pcs` varchar(100) DEFAULT NULL,
  `pickup_stackable` varchar(100) DEFAULT NULL,
  `pickup_wmu` varchar(100) DEFAULT NULL,
  `pickup_weight` varchar(100) DEFAULT NULL,
  `pickup_lwh_mu` varchar(100) DEFAULT NULL,
  `pickup_length` varchar(100) DEFAULT NULL,
  `pickup_width` varchar(100) DEFAULT NULL,
  `pickup_height` varchar(100) DEFAULT NULL,
  `pickup_cubic_ft` varchar(100) DEFAULT NULL,
  `pickup_linear_ft` varchar(100) DEFAULT NULL,
  `pickup_picture` varchar(150) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `copy` int(11) NOT NULL DEFAULT '0'
) ENGINE=InnoDB DEFAULT CHARSET=latin1;


-- --------------------------------------------------------

-- Table structure for table `order_revenues`
CREATE TABLE `order_revenues` (
  `id` int(100) NOT NULL,
  `key_id` varchar(100) DEFAULT NULL,
  `leg_revenue` varchar(100) DEFAULT NULL,
  `part_revenue` varchar(100) DEFAULT NULL,
  `leg_expense` varchar(100) DEFAULT NULL,
  `part_expense` varchar(100) DEFAULT NULL,
  `loaded_on` varchar(100) DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=latin1;


-- --------------------------------------------------------

-- Table structure for table `order_upload_docs`
CREATE TABLE `order_upload_docs` (
  `id` int(100) NOT NULL,
  `order_id` int(255) DEFAULT NULL,
  `doc_name` varchar(100) DEFAULT NULL,
  `upload_doc` varchar(100) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;


-- --------------------------------------------------------

-- Table structure for table `order_upload_docs_main`
CREATE TABLE `order_upload_docs_main` (
  `id` int(100) NOT NULL,
  `order_id` varchar(100) DEFAULT NULL,
  `doc_name` varchar(100) DEFAULT NULL,
  `upload_doc` varchar(100) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;


-- --------------------------------------------------------

-- Table structure for table `paps_master`
CREATE TABLE `paps_master` (
  `type` varchar(20) NOT NULL DEFAULT 'paps',
  `paps_sequence` int(255) NOT NULL,
  `paps_scac_code` varchar(10) NOT NULL DEFAULT 'IWTO',
  `trip_id` int(255) NOT NULL,
  `border_crossing` varchar(255) NOT NULL,
  `eta_to_border` varchar(255) NOT NULL,
  `document` varchar(255) NOT NULL,
  `broker_name` varchar(255) NOT NULL,
  `ppw_with_coversheet` varchar(255) NOT NULL
) ENGINE=MyISAM DEFAULT CHARSET=latin1;


-- --------------------------------------------------------

-- Table structure for table `paps_pars_generate`
CREATE TABLE `paps_pars_generate` (
  `id` int(250) NOT NULL,
  `trip_id` varchar(250) NOT NULL,
  `type` varchar(250) NOT NULL,
  `total_generate` int(250) NOT NULL,
  `role_id` int(11) NOT NULL,
  `role_type` varchar(255) NOT NULL,
  `employee_name` varchar(255) NOT NULL,
  `created_date` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=MyISAM DEFAULT CHARSET=latin1;


-- --------------------------------------------------------

-- Table structure for table `pars_master`
CREATE TABLE `pars_master` (
  `type` varchar(20) NOT NULL DEFAULT 'pars',
  `pars_sequence` int(255) NOT NULL,
  `pars_scac_code` varchar(10) NOT NULL DEFAULT '16F4PARS',
  `trip_id` int(255) NOT NULL,
  `border_crossing` varchar(255) NOT NULL,
  `eta_to_border` varchar(255) NOT NULL,
  `document` varchar(255) NOT NULL,
  `broker_name` varchar(255) NOT NULL,
  `ppw_with_coversheet` varchar(255) NOT NULL
) ENGINE=MyISAM DEFAULT CHARSET=latin1;


-- --------------------------------------------------------

-- Table structure for table `paysettelment_master_report`
CREATE TABLE `paysettelment_master_report` (
  `id` int(255) NOT NULL,
  `trip_id` int(11) NOT NULL,
  `role_id` int(255) NOT NULL,
  `role` varchar(100) DEFAULT NULL,
  `payer` varchar(100) DEFAULT NULL,
  `type` enum('Earning','Deduction','Payment') DEFAULT NULL,
  `deduction_name` varchar(255) NOT NULL COMMENT 'Description',
  `date_of_log` date DEFAULT NULL,
  `deduction_id` int(255) DEFAULT NULL,
  `pay_id` int(255) DEFAULT NULL,
  `earning_as` varchar(100) DEFAULT NULL,
  `amount` varchar(255) DEFAULT NULL,
  `currency` varchar(10) DEFAULT NULL,
  `tax1amt` double DEFAULT NULL,
  `tax2amt` double DEFAULT NULL,
  `total_amt` double DEFAULT NULL,
  `conversion_rate` float DEFAULT NULL,
  `total_amt_after_convert` double DEFAULT NULL,
  `maintain_balance` varchar(100) DEFAULT NULL,
  `created_date` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=latin1;


-- --------------------------------------------------------

-- Table structure for table `pay_types`
CREATE TABLE `pay_types` (
  `id` int(100) NOT NULL,
  `type` varchar(100) NOT NULL,
  `rate` varchar(25) NOT NULL,
  `manually` int(10) NOT NULL DEFAULT '0'
) ENGINE=MyISAM DEFAULT CHARSET=latin1;


-- --------------------------------------------------------

-- Table structure for table `pickupequipments`
CREATE TABLE `pickupequipments` (
  `id` int(100) NOT NULL,
  `name` varchar(100) NOT NULL
) ENGINE=MyISAM DEFAULT CHARSET=latin1;


-- --------------------------------------------------------

-- Table structure for table `recharges`
CREATE TABLE `recharges` (
  `id` int(11) NOT NULL,
  `card_title` varchar(100) NOT NULL,
  `serial_no` varchar(100) NOT NULL,
  `scratch_code` varchar(100) NOT NULL,
  `amount` varchar(25) NOT NULL,
  `sale_price` varchar(25) NOT NULL,
  `usage_status` int(2) NOT NULL DEFAULT '0',
  `used_by` varchar(25) DEFAULT NULL,
  `usage_timestamp` datetime DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `delete_status` tinyint(1) NOT NULL DEFAULT '0'
) ENGINE=InnoDB DEFAULT CHARSET=latin1;


-- --------------------------------------------------------

-- Table structure for table `repairshops`
CREATE TABLE `repairshops` (
  `id` int(100) NOT NULL,
  `repair_shops_name` varchar(100) DEFAULT NULL,
  `repair_shops_address` varchar(100) DEFAULT NULL,
  `repair_shops_phone` varchar(100) DEFAULT NULL,
  `repair_shops_phone2` varchar(100) DEFAULT NULL,
  `repair_shops_email` varchar(100) DEFAULT NULL,
  `repair_shops_working_hrs` varchar(100) DEFAULT NULL,
  `repair_shops_main_contact_person_name` varchar(100) DEFAULT NULL,
  `repair_shops_comment` varchar(100) DEFAULT NULL,
  `repair_shops_Sale_tax` varchar(100) DEFAULT NULL,
  `repair_shops_Legal_or_corp_name` varchar(100) DEFAULT NULL,
  `repair_shops_owner_director` varchar(100) DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=latin1;


-- --------------------------------------------------------

-- Table structure for table `roles`
CREATE TABLE `roles` (
  `id` int(100) NOT NULL,
  `role` varchar(100) NOT NULL
) ENGINE=MyISAM DEFAULT CHARSET=latin1;


-- --------------------------------------------------------

-- Table structure for table `safetydocs`
CREATE TABLE `safetydocs` (
  `id` int(100) NOT NULL,
  `name` varchar(100) NOT NULL,
  `expiry` varchar(100) NOT NULL,
  `upload` varchar(100) NOT NULL,
  `description` varchar(200) NOT NULL,
  `frequency` varchar(25) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;


-- --------------------------------------------------------

-- Table structure for table `saletax`
CREATE TABLE `saletax` (
  `id` int(100) NOT NULL,
  `name` varchar(100) NOT NULL,
  `rate` varchar(100) NOT NULL,
  `country` varchar(100) NOT NULL,
  `state` varchar(200) NOT NULL,
  `description` varchar(100) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;


-- --------------------------------------------------------

-- Table structure for table `security_groups`
CREATE TABLE `security_groups` (
  `id` int(100) NOT NULL,
  `name` varchar(100) DEFAULT NULL,
  `roles` longtext,
  `parents` varchar(100) DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=MyISAM DEFAULT CHARSET=latin1;


-- --------------------------------------------------------

-- Table structure for table `security_group_users`
CREATE TABLE `security_group_users` (
  `id` int(100) NOT NULL,
  `group_id` int(100) DEFAULT NULL,
  `type` varchar(50) DEFAULT NULL,
  `user_id` int(100) DEFAULT NULL
) ENGINE=MyISAM DEFAULT CHARSET=latin1;


-- --------------------------------------------------------

-- Table structure for table `shipment_full_detail`
CREATE TABLE `shipment_full_detail` (
  `id` int(255) NOT NULL,
  `order_part` int(255) DEFAULT '0',
  `max_lag` int(11) NOT NULL,
  `assigned_trip_id` int(255) NOT NULL DEFAULT '0',
  `trip_id_pickup` varchar(255) NOT NULL,
  `trip_id_delivery` varchar(255) NOT NULL,
  `order_id` int(255) DEFAULT NULL,
  `redirect_data` int(11) DEFAULT NULL,
  `pickups_id` int(255) DEFAULT NULL,
  `delivery_id` int(255) DEFAULT NULL,
  `shipment` int(255) DEFAULT NULL,
  `dock_complete` varchar(50) DEFAULT NULL,
  `trailer_complete` varchar(50) DEFAULT NULL,
  `carrier_complete` varchar(50) DEFAULT NULL,
  `pickup_complete` varchar(255) NOT NULL,
  `delivery_complete` varchar(255) NOT NULL,
  `location_type_complete` varchar(255) DEFAULT NULL,
  `location_name_complete` varchar(255) DEFAULT NULL,
  `location_address_complete` text,
  `pickup_done` varchar(255) NOT NULL,
  `delivery_done` varchar(255) NOT NULL DEFAULT '0',
  `loaded_On_Trailer` varchar(255) NOT NULL,
  `Dropped_at_dock` varchar(255) NOT NULL,
  `lag_status` int(10) NOT NULL DEFAULT '0',
  `receiver_type` varchar(255) NOT NULL,
  `receiver_city` varchar(255) NOT NULL,
  `receiver_state` varchar(255) NOT NULL,
  `receiver_name` varchar(255) NOT NULL,
  `receiver_address` varchar(1000) NOT NULL,
  `Location_Type` varchar(255) NOT NULL,
  `Location_name` varchar(255) NOT NULL,
  `shipper_state` varchar(255) NOT NULL,
  `shipper_city` varchar(255) NOT NULL,
  `Location_add` varchar(255) NOT NULL,
  `Carrier` varchar(255) NOT NULL,
  `delivery_shipment_description` varchar(100) NOT NULL,
  `delivery_no_pcs` int(255) DEFAULT NULL,
  `pcs_total` int(255) DEFAULT NULL,
  `commodity` varchar(100) DEFAULT NULL,
  `delivery_stackable` varchar(100) NOT NULL,
  `delivery_wmu` varchar(100) NOT NULL,
  `delivery_weight` int(100) DEFAULT NULL,
  `delivery_lwh_mu` varchar(100) NOT NULL,
  `delivery_length` int(100) DEFAULT NULL,
  `delivery_height` int(100) DEFAULT NULL,
  `delivery_cubic_ft` int(100) DEFAULT NULL,
  `delivery_linear_ft` int(100) DEFAULT NULL,
  `delivery_picture` varchar(150) DEFAULT NULL,
  `delivery_shipper` int(255) DEFAULT NULL,
  `pu_planned` tinyint(4) NOT NULL,
  `pu_dispatched` tinyint(4) NOT NULL,
  `pu_complete` tinyint(4) NOT NULL,
  `delivery_width` int(100) DEFAULT NULL,
  `del_planned` tinyint(4) NOT NULL,
  `del_dispatched` tinyint(4) NOT NULL,
  `del_complete` tinyint(4) NOT NULL,
  `is_checked` tinyint(4) NOT NULL DEFAULT '0',
  `final_delivery_id` int(255) DEFAULT NULL,
  `key_id` int(255) DEFAULT NULL,
  `delivery_uno` varchar(100) DEFAULT NULL,
  `iid` varchar(100) DEFAULT '1',
  `parent_id` int(255) DEFAULT NULL,
  `shipment_no` int(255) DEFAULT NULL COMMENT 'pc_BarCode',
  `delivery_shipment_barcode` varchar(100) DEFAULT NULL,
  `shipper_address` varchar(100) DEFAULT NULL,
  `delivery_appt` varchar(100) DEFAULT NULL,
  `delivery_date` date DEFAULT NULL,
  `delivery_time` time DEFAULT NULL,
  `delivery_ref_no` varchar(100) DEFAULT NULL,
  `delivery_additional_info` varchar(100) DEFAULT NULL,
  `reciever_timing` varchar(100) DEFAULT NULL,
  `reciever_note` varchar(100) DEFAULT NULL,
  `delivery_equipment` varchar(100) DEFAULT NULL,
  `delivery_attributes` varchar(100) DEFAULT NULL,
  `delivery_temperature` varchar(100) DEFAULT NULL,
  `delivery_hazardous` varchar(100) DEFAULT NULL,
  `delivery_custom_broker` varchar(100) DEFAULT NULL,
  `copy` int(11) NOT NULL DEFAULT '0',
  `POD_received` varchar(255) NOT NULL,
  `POD_note` varchar(255) NOT NULL,
  `Droped_type` varchar(255) NOT NULL,
  `position` varchar(255) NOT NULL,
  `Layer` varchar(255) NOT NULL,
  `Orientation` varchar(255) NOT NULL
) ENGINE=MyISAM DEFAULT CHARSET=latin1;


-- --------------------------------------------------------

-- Table structure for table `shipment_full_detail_main`
CREATE TABLE `shipment_full_detail_main` (
  `id` int(255) NOT NULL,
  `order_part` int(255) NOT NULL DEFAULT '0',
  `assigned_trip_id` int(255) DEFAULT '0',
  `trip_id_pickup` int(255) DEFAULT NULL,
  `trip_id_delivery` int(255) DEFAULT NULL,
  `trip_id_transit` varchar(255) DEFAULT NULL,
  `is_checked` tinyint(4) NOT NULL DEFAULT '0',
  `pu_planned` tinyint(4) NOT NULL DEFAULT '0',
  `pu_dispatched` tinyint(4) NOT NULL DEFAULT '0',
  `pu_complete` tinyint(4) NOT NULL DEFAULT '0',
  `del_planned` tinyint(4) NOT NULL DEFAULT '0',
  `del_dispatched` tinyint(4) NOT NULL DEFAULT '0',
  `del_complete` tinyint(4) NOT NULL DEFAULT '0',
  `pod_received` tinyint(4) NOT NULL DEFAULT '0',
  `shipment` int(255) DEFAULT NULL,
  `final_delivery_id` int(11) DEFAULT NULL,
  `pickups_id` int(255) DEFAULT NULL,
  `order_id` int(255) DEFAULT NULL,
  `delivery_id` int(255) DEFAULT NULL,
  `key_id` int(255) DEFAULT NULL,
  `delivery_uno` varchar(100) DEFAULT NULL,
  `iid` varchar(100) DEFAULT '1',
  `parent_id` varchar(100) DEFAULT '0',
  `shipment_no` int(255) NOT NULL COMMENT 'pc_BarCode',
  `delivery_shipment_barcode` varchar(100) NOT NULL,
  `delivery_shipment_description` varchar(100) NOT NULL,
  `commodity` varchar(100) DEFAULT NULL,
  `delivery_no_pcs` varchar(100) NOT NULL,
  `pcs_total` varchar(50) DEFAULT NULL,
  `delivery_stackable` varchar(100) NOT NULL,
  `delivery_wmu` varchar(100) NOT NULL,
  `delivery_weight` varchar(100) NOT NULL,
  `delivery_lwh_mu` varchar(100) NOT NULL,
  `delivery_length` varchar(100) NOT NULL,
  `delivery_width` varchar(100) NOT NULL,
  `delivery_height` varchar(100) NOT NULL,
  `delivery_cubic_ft` varchar(100) NOT NULL,
  `delivery_linear_ft` varchar(100) NOT NULL,
  `delivery_picture` varchar(150) DEFAULT NULL,
  `delivery_shipper` varchar(100) DEFAULT NULL,
  `shipper_address` varchar(100) DEFAULT NULL,
  `delivery_appt` varchar(100) DEFAULT NULL,
  `delivery_date` date DEFAULT NULL,
  `delivery_time` time DEFAULT NULL,
  `delivery_ref_no` varchar(100) DEFAULT NULL,
  `delivery_additional_info` varchar(100) DEFAULT NULL,
  `reciever_timing` varchar(100) DEFAULT NULL,
  `reciever_note` varchar(100) DEFAULT NULL,
  `delivery_equipment` varchar(100) DEFAULT NULL,
  `delivery_attributes` varchar(100) DEFAULT NULL,
  `delivery_temperature` varchar(100) DEFAULT NULL,
  `delivery_hazardous` varchar(100) DEFAULT NULL,
  `delivery_custom_broker` varchar(100) DEFAULT NULL,
  `copy` int(11) NOT NULL DEFAULT '0'
) ENGINE=MyISAM DEFAULT CHARSET=latin1;


-- --------------------------------------------------------

-- Table structure for table `Ship_Trip_rel`
CREATE TABLE `Ship_Trip_rel` (
  `ID` int(11) NOT NULL,
  `order_part` varchar(11) NOT NULL DEFAULT '0',
  `is_checked` int(11) NOT NULL,
  `lag` varchar(11) DEFAULT '0',
  `order_id` int(255) NOT NULL,
  `redirect_data` int(11) DEFAULT NULL,
  `Trip_ID` int(250) DEFAULT NULL,
  `hooked_code` varchar(10) DEFAULT NULL,
  `drop_code` varchar(10) DEFAULT NULL,
  `ship_trip_code` text,
  `trailer_code` varchar(50) NOT NULL,
  `pickup_code` text NOT NULL,
  `pickups_id` int(11) DEFAULT '0',
  `delivery_id` int(11) DEFAULT NULL,
  `delivery_no_pcs` varchar(50) DEFAULT NULL,
  `Dropped_at_dock` varchar(255) NOT NULL,
  `loaded_On_Trailer` varchar(255) NOT NULL,
  `shipment_full_detail_id` int(11) NOT NULL COMMENT 'shipment_full_details table auto id',
  `delivery_shipment_description` varchar(100) NOT NULL,
  `Ship_ID` int(250) DEFAULT NULL,
  `pcs_total` int(255) DEFAULT NULL,
  `pickup_done` int(11) NOT NULL,
  `delivery_done` int(11) NOT NULL,
  `commodity` varchar(100) DEFAULT NULL,
  `truck_no` int(100) DEFAULT NULL,
  `trailer_no` int(100) DEFAULT NULL,
  `event_status` enum('preplan','planned','dispatched','complete') DEFAULT NULL,
  `event_status_delivery` enum('preplan','planned','dispatched','complete') NOT NULL,
  `start_location_type` text NOT NULL,
  `start_location_name` text NOT NULL,
  `start_location_address` text NOT NULL,
  `start_location_city` text NOT NULL,
  `start_location_state` text NOT NULL,
  `pickup_location_type` text NOT NULL,
  `pickup_location_name` text NOT NULL,
  `pickup_location_address` text NOT NULL,
  `pickup_location_city` text NOT NULL,
  `pickup_location_state` text NOT NULL,
  `pickup_lat` double NOT NULL,
  `pickup_long` double NOT NULL,
  `receiver_location_type` text NOT NULL,
  `receiver_location_name` text NOT NULL,
  `receiver_location_address` text NOT NULL,
  `receiver_location_city` text NOT NULL,
  `receiver_location_state` text NOT NULL,
  `delivery_location_type` text,
  `delivery_location_name` text,
  `delivery_location_address` text,
  `delivery_lat` double DEFAULT NULL,
  `delivery_long` double DEFAULT NULL,
  `delivery_location_city` text,
  `delivery_city_lat` double DEFAULT NULL,
  `delivery_city_long` double DEFAULT NULL,
  `delivery_location_state` text,
  `delivery_wmu` varchar(100) DEFAULT NULL,
  `delivery_weight` varchar(100) DEFAULT NULL,
  `loaded_on` varchar(100) NOT NULL,
  `lag_status` int(10) NOT NULL,
  `trailer_complete` varchar(100) DEFAULT NULL,
  `dock_complete` varchar(100) DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=latin1;


-- --------------------------------------------------------

-- Table structure for table `states`
CREATE TABLE `states` (
  `id` int(11) NOT NULL,
  `name` varchar(30) NOT NULL,
  `country` varchar(11) NOT NULL DEFAULT '1',
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=latin1;


-- --------------------------------------------------------

-- Table structure for table `states1`
CREATE TABLE `states1` (
  `id` int(100) NOT NULL,
  `name` varchar(100) NOT NULL,
  `country` varchar(100) DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=MyISAM DEFAULT CHARSET=latin1;


-- --------------------------------------------------------

-- Table structure for table `suppliers`
CREATE TABLE `suppliers` (
  `id` int(255) NOT NULL,
  `name` varchar(100) DEFAULT NULL,
  `role` varchar(100) NOT NULL,
  `address` varchar(100) DEFAULT NULL,
  `latitude` varchar(100) NOT NULL,
  `longitude` varchar(100) NOT NULL,
  `unit` varchar(50) NOT NULL,
  `street_no` varchar(50) DEFAULT NULL,
  `street` varchar(100) NOT NULL,
  `city` varchar(100) NOT NULL,
  `city_lat` varchar(255) NOT NULL,
  `city_long` varchar(255) NOT NULL,
  `district` varchar(50) DEFAULT NULL,
  `state` varchar(100) NOT NULL,
  `country` varchar(100) NOT NULL,
  `zip` varchar(100) NOT NULL,
  `pcode` varchar(10) NOT NULL,
  `phone` varchar(100) DEFAULT NULL,
  `pcode2` varchar(10) NOT NULL,
  `phone2` varchar(100) DEFAULT NULL,
  `email` varchar(100) DEFAULT NULL,
  `website` varchar(100) NOT NULL,
  `fcode` varchar(10) NOT NULL,
  `fax` varchar(50) NOT NULL,
  `hoo` varchar(100) DEFAULT NULL,
  `contact_person` varchar(100) DEFAULT NULL,
  `payment_term` varchar(100) DEFAULT NULL,
  `payment_notes` varchar(150) NOT NULL,
  `notes` varchar(100) DEFAULT NULL,
  `legal_or_corp_name` varchar(100) DEFAULT NULL,
  `owner_director` varchar(100) DEFAULT NULL,
  `rating` varchar(10) NOT NULL,
  `blacklisted` varchar(10) NOT NULL,
  `mtdtb` varchar(50) NOT NULL,
  `ytdtb` varchar(50) NOT NULL,
  `lci_ed` varchar(50) NOT NULL,
  `factoring_company` varchar(100) NOT NULL,
  `quickpay` varchar(50) NOT NULL,
  `saletax_reg` varchar(50) NOT NULL,
  `stv` varchar(10) NOT NULL,
  `saletax_file` varchar(150) NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `delete_status` int(10) NOT NULL DEFAULT '0',
  `publish` varchar(10) NOT NULL DEFAULT '0',
  `balance` varchar(100) NOT NULL DEFAULT '0'
) ENGINE=InnoDB DEFAULT CHARSET=latin1;


-- --------------------------------------------------------

-- Table structure for table `tasks`
CREATE TABLE `tasks` (
  `id` int(100) NOT NULL,
  `task_name` longtext,
  `task_description` longtext,
  `webpage` varchar(100) DEFAULT NULL,
  `completion_date` date DEFAULT NULL,
  `completion_time` time DEFAULT NULL,
  `freq` varchar(100) DEFAULT NULL,
  `repeat_after` varchar(100) DEFAULT NULL,
  `end_date` date DEFAULT NULL,
  `end_time` time DEFAULT NULL,
  `assigned_to_individual` varchar(100) DEFAULT NULL,
  `assigned_to_group` varchar(100) DEFAULT NULL,
  `assigned_to_user` varchar(100) DEFAULT NULL,
  `assigned_to_when_absent` varchar(100) DEFAULT NULL,
  `task_group` varchar(100) DEFAULT NULL,
  `task_instructions` longtext,
  `task_instructions_question` longtext,
  `task_completed` varchar(100) DEFAULT NULL,
  `proof` varchar(100) DEFAULT NULL,
  `task_priority` varchar(100) NOT NULL,
  `start_date` varchar(100) DEFAULT NULL,
  `send_time` varchar(100) DEFAULT NULL,
  `repeats` varchar(100) DEFAULT NULL,
  `every_week` varchar(100) DEFAULT NULL,
  `sunday` varchar(100) DEFAULT NULL,
  `monday` varchar(100) DEFAULT NULL,
  `tuesday` varchar(100) DEFAULT NULL,
  `wednesday` varchar(100) DEFAULT NULL,
  `thursday` varchar(100) DEFAULT NULL,
  `friday` varchar(100) DEFAULT NULL,
  `saturday` varchar(100) DEFAULT NULL,
  `end_after_messages` varchar(100) DEFAULT NULL,
  `ends_decision` varchar(100) DEFAULT NULL,
  `end_decision_date` varchar(100) DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `last_date_cron_run` varchar(50) DEFAULT NULL,
  `expired_email_send_time` varchar(20) DEFAULT NULL,
  `isemail_send` int(11) NOT NULL DEFAULT '0',
  `next_cron_run_date` varchar(50) DEFAULT NULL,
  `when_cron_again_run_day` varchar(10) DEFAULT NULL,
  `no_cron_run` int(11) NOT NULL DEFAULT '0',
  `isCronEnd` enum('0','1') NOT NULL COMMENT '0 means cron is still going on,1= cron stoped',
  `param_form` text,
  `time_zone` varchar(50) DEFAULT NULL,
  `interval` varchar(50) DEFAULT NULL,
  `auditor` varchar(55) DEFAULT NULL
) ENGINE=MyISAM DEFAULT CHARSET=latin1;


-- --------------------------------------------------------

-- Table structure for table `tasks_frequency`
CREATE TABLE `tasks_frequency` (
  `id` int(11) NOT NULL,
  `task_id` int(11) NOT NULL,
  `user_id` int(11) DEFAULT NULL,
  `task_name` text,
  `task_description` text,
  `webpage` varchar(255) DEFAULT NULL,
  `task_priority` varchar(50) DEFAULT NULL,
  `frequency_type` varchar(50) DEFAULT NULL COMMENT 'onetime,recurring',
  `param_form` text,
  `task_submit_form` text,
  `task_completion_time` varchar(255) DEFAULT NULL,
  `isTaskCompleted` enum('0','1') NOT NULL DEFAULT '0' COMMENT '0=task not completed,1=completed',
  `isTaskExpired` enum('0','1') DEFAULT '0' COMMENT '0=task not expired,1=expired',
  `interval` varchar(55) DEFAULT NULL,
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP COMMENT 'date of task',
  `task_started_time` varchar(55) DEFAULT NULL COMMENT 'task_date',
  `expired_task_time` varchar(20) DEFAULT NULL,
  `expired_email_send_time` varchar(20) DEFAULT NULL,
  `isemail_send` int(11) NOT NULL DEFAULT '0',
  `auditor` varchar(55) DEFAULT NULL,
  `isAudited` enum('0','1') DEFAULT '0',
  `auditResult` varchar(55) DEFAULT NULL,
  `audit_comment` text,
  `isUserRemoved` enum('0','1') NOT NULL COMMENT '1=task has been expired for that user,0 mean task still has been assigned to user'
) ENGINE=MyISAM DEFAULT CHARSET=latin1;


-- --------------------------------------------------------

-- Table structure for table `task_reference`
CREATE TABLE `task_reference` (
  `id` int(11) NOT NULL,
  `main_task_id` int(11) DEFAULT NULL,
  `reference_task_id` int(11) DEFAULT NULL,
  `description` text,
  `type` varchar(100) DEFAULT NULL,
  `created_date` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=MyISAM DEFAULT CHARSET=latin1;


-- --------------------------------------------------------

-- Table structure for table `task_reference_frequency`
CREATE TABLE `task_reference_frequency` (
  `id` int(11) NOT NULL,
  `user_id` varchar(255) DEFAULT NULL,
  `task_reference_steps_id` int(11) DEFAULT NULL COMMENT 'it comes from task_reference table because we need relation',
  `main_task_id` int(11) DEFAULT NULL COMMENT 'id comes from this tasks table',
  `frequency_task_id` int(11) DEFAULT NULL COMMENT 'id comes from this tasks_frequency table',
  `reference_task_id` int(11) DEFAULT NULL COMMENT 'reference id comes from main task id of other task',
  `description` text,
  `frequency_type` varchar(100) DEFAULT NULL COMMENT 'onetime,recurring',
  `type` varchar(100) NOT NULL,
  `status` enum('pending','completed') DEFAULT NULL COMMENT 'completed,pending',
  `task_end_date` varchar(50) DEFAULT NULL,
  `file` varchar(100) DEFAULT NULL,
  `created_date` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=MyISAM DEFAULT CHARSET=latin1;


-- --------------------------------------------------------

-- Table structure for table `terminals`
CREATE TABLE `terminals` (
  `id` int(100) NOT NULL,
  `name` varchar(100) NOT NULL,
  `address` varchar(100) NOT NULL,
  `latitude` varchar(50) NOT NULL,
  `longitude` varchar(50) NOT NULL,
  `city` varchar(100) NOT NULL,
  `city_lat` varchar(255) NOT NULL,
  `city_long` varchar(255) NOT NULL,
  `state` varchar(255) NOT NULL,
  `email` varchar(100) NOT NULL,
  `phone` varchar(100) NOT NULL,
  `info` varchar(200) NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `delete_status` int(10) NOT NULL DEFAULT '0'
) ENGINE=InnoDB DEFAULT CHARSET=latin1;


-- --------------------------------------------------------

-- Table structure for table `trailers`
CREATE TABLE `trailers` (
  `id` int(255) NOT NULL,
  `trip_id` int(255) DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `loaded_on_trailer` varchar(11) NOT NULL DEFAULT '0',
  `vin` varchar(100) NOT NULL,
  `plate_name` varchar(255) NOT NULL,
  `plate_state` varchar(255) NOT NULL,
  `loc_type` varchar(255) DEFAULT NULL,
  `loc_id` varchar(255) DEFAULT NULL,
  `loc_name` varchar(255) DEFAULT NULL,
  `location_lat` double DEFAULT NULL,
  `location_long` double DEFAULT NULL,
  `sother` varchar(255) DEFAULT NULL,
  `sterminals` varchar(255) DEFAULT NULL,
  `scustomers` varchar(255) DEFAULT NULL,
  `ssuppliers` varchar(255) DEFAULT NULL,
  `address` varchar(100) NOT NULL,
  `latitude` varchar(100) DEFAULT NULL,
  `longitude` varchar(100) DEFAULT NULL,
  `city` varchar(100) NOT NULL,
  `city_lat` varchar(255) NOT NULL,
  `city_long` varchar(255) NOT NULL,
  `loc_state` varchar(255) NOT NULL,
  `unit` varchar(50) NOT NULL,
  `make` varchar(50) NOT NULL,
  `model` varchar(50) NOT NULL,
  `year` varchar(50) NOT NULL,
  `purchase_price` varchar(50) NOT NULL,
  `currency` varchar(25) NOT NULL,
  `saletax1` varchar(50) NOT NULL,
  `saletax2` varchar(50) NOT NULL,
  `monthly_payment` varchar(50) NOT NULL,
  `mpcurrency` varchar(25) NOT NULL,
  `mpsaletax1` varchar(50) NOT NULL,
  `mpsaletax2` varchar(50) NOT NULL,
  `trailer_type` varchar(50) NOT NULL,
  `weight_capacity` varchar(50) NOT NULL,
  `tare_weight` varchar(50) NOT NULL,
  `tare_weight_unit` varchar(50) NOT NULL,
  `hub_reading` varchar(50) NOT NULL,
  `hub_reading_unit` varchar(50) NOT NULL,
  `tire_size_steer_axle` varchar(50) NOT NULL,
  `tire_size_drive_axle` varchar(50) NOT NULL,
  `tire_size_drive_axle2` varchar(50) NOT NULL,
  `inside_width` varchar(50) NOT NULL,
  `inside_height` varchar(50) NOT NULL,
  `inside_length` varchar(50) NOT NULL,
  `last_pm_date` date DEFAULT NULL,
  `last_pm_hub_meter` varchar(50) NOT NULL,
  `last_safety_date` date DEFAULT NULL,
  `last_safety_hub_meter` varchar(50) NOT NULL,
  `terminal` varchar(50) NOT NULL,
  `boundry` varchar(50) NOT NULL,
  `nokm` varchar(50) NOT NULL,
  `country` varchar(100) DEFAULT NULL,
  `state` varchar(100) DEFAULT NULL,
  `nacountry` varchar(100) DEFAULT NULL,
  `nastate` varchar(100) DEFAULT NULL,
  `owned_by` varchar(50) NOT NULL,
  `vcfep` varchar(100) NOT NULL,
  `vcfef` varchar(100) NOT NULL,
  `vcfevb` varchar(100) NOT NULL,
  `suppliers` varchar(50) NOT NULL,
  `truckplate` varchar(50) DEFAULT NULL,
  `last_checkup_date` date DEFAULT NULL,
  `last_checkup_hub_meter` varchar(100) NOT NULL,
  `trailer_gps_tracking_unit` varchar(100) NOT NULL,
  `trailer_status` varchar(25) NOT NULL,
  `trailer_status_comment` varchar(100) NOT NULL,
  `publish` enum('0','1') NOT NULL DEFAULT '0',
  `delete_status` int(10) NOT NULL DEFAULT '0',
  `in_trip_status` int(55) NOT NULL DEFAULT '0',
  `event_status` enum('preplan','planned','dispatched','complete') DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;


-- --------------------------------------------------------

-- Table structure for table `trailers_assigned_trips`
CREATE TABLE `trailers_assigned_trips` (
  `id` int(11) NOT NULL,
  `trailer_id` int(11) DEFAULT NULL,
  `trip_id` varchar(100) DEFAULT NULL,
  `assigned_date` datetime DEFAULT NULL,
  `assigned_upto` datetime DEFAULT NULL,
  `status` int(10) NOT NULL DEFAULT '0'
) ENGINE=InnoDB DEFAULT CHARSET=latin1;


-- --------------------------------------------------------

-- Table structure for table `trailer_meta_extrapaytype`
CREATE TABLE `trailer_meta_extrapaytype` (
  `id` int(250) NOT NULL,
  `trailer_id` varchar(100) NOT NULL,
  `extrapay_type` varchar(100) NOT NULL,
  `currency` varchar(10) NOT NULL,
  `rate` varchar(50) NOT NULL,
  `extrapaytype_saletax1` varchar(100) NOT NULL,
  `extrapaytype_saletax2` varchar(100) NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=latin1;


-- --------------------------------------------------------

-- Table structure for table `trailer_meta_paytype`
CREATE TABLE `trailer_meta_paytype` (
  `id` int(250) NOT NULL,
  `trailer_id` varchar(100) NOT NULL,
  `pay_type` varchar(100) NOT NULL,
  `currency` varchar(10) NOT NULL,
  `rate` varchar(50) NOT NULL,
  `paytype_saletax1` varchar(100) NOT NULL,
  `paytype_saletax2` varchar(100) NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=latin1;


-- --------------------------------------------------------

-- Table structure for table `trailer_meta_safety_doc`
CREATE TABLE `trailer_meta_safety_doc` (
  `id` int(250) NOT NULL,
  `trailer_id` varchar(100) NOT NULL,
  `safety_document` varchar(50) NOT NULL,
  `issuing_date` date DEFAULT NULL,
  `expiry` varchar(10) NOT NULL,
  `expiry_date` date DEFAULT NULL,
  `file` varchar(250) DEFAULT NULL,
  `description` varchar(100) NOT NULL,
  `frequency` varchar(100) NOT NULL,
  `document_number` varchar(50) NOT NULL,
  `issuing_state` varchar(50) NOT NULL,
  `issuing_country` varchar(50) NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=latin1;


-- --------------------------------------------------------

-- Table structure for table `transactions`
CREATE TABLE `transactions` (
  `id` int(150) NOT NULL,
  `user_id` int(150) NOT NULL,
  `points` int(150) NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=latin1;


-- --------------------------------------------------------

-- Table structure for table `trips`
CREATE TABLE `trips` (
  `id` int(100) NOT NULL,
  `sl_type` varchar(100) DEFAULT NULL,
  `sterminals` varchar(100) DEFAULT NULL,
  `scustomers` varchar(100) DEFAULT NULL,
  `ssuppliers` varchar(100) DEFAULT NULL,
  `sother` varchar(100) DEFAULT NULL,
  `slat` varchar(100) DEFAULT NULL,
  `slon` varchar(100) DEFAULT NULL,
  `sl_action` varchar(100) DEFAULT NULL,
  `sl_trailer` varchar(100) DEFAULT NULL,
  `el_type` varchar(100) DEFAULT NULL,
  `eterminals` varchar(100) DEFAULT NULL,
  `ecustomers` varchar(100) DEFAULT NULL,
  `esuppliers` varchar(100) DEFAULT NULL,
  `eother` varchar(100) DEFAULT NULL,
  `elat` varchar(100) DEFAULT NULL,
  `elon` varchar(100) DEFAULT NULL,
  `el_action` varchar(100) DEFAULT NULL,
  `el_trailer` varchar(100) DEFAULT NULL,
  `start_date` varchar(100) DEFAULT NULL,
  `start_time` varchar(100) DEFAULT NULL,
  `finish_date` varchar(100) DEFAULT NULL,
  `finish_time` varchar(100) DEFAULT NULL,
  `start_datetime` datetime DEFAULT NULL,
  `finish_datetime` datetime DEFAULT NULL,
  `assigned_to` varchar(100) DEFAULT NULL,
  `trip_expense` varchar(100) DEFAULT NULL,
  `expense_description` varchar(100) DEFAULT NULL,
  `expense_status` varchar(100) DEFAULT NULL,
  `trip_instructions` varchar(100) DEFAULT NULL,
  `paid_by` varchar(25) DEFAULT NULL,
  `dispatcher` varchar(100) DEFAULT NULL,
  `security_group` varchar(100) DEFAULT NULL,
  `truck_id` varchar(100) DEFAULT NULL,
  `truck_current_location` longtext,
  `driver1` varchar(100) DEFAULT NULL,
  `driver2` varchar(100) DEFAULT NULL,
  `whopay1` varchar(100) DEFAULT NULL,
  `whopay2` varchar(100) DEFAULT NULL,
  `truck_paytype` varchar(100) DEFAULT NULL,
  `driver1_paytype` varchar(100) DEFAULT NULL,
  `driver2_paytype` varchar(100) DEFAULT NULL,
  `truck_paytype_unit` varchar(100) DEFAULT NULL,
  `driver1_paytype_unit` varchar(100) DEFAULT NULL,
  `driver2_paytype_unit` varchar(100) DEFAULT NULL,
  `publish` varchar(10) NOT NULL DEFAULT '0',
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `total_km` varchar(100) DEFAULT NULL,
  `total_miles` varchar(50) DEFAULT NULL,
  `end_status` int(10) NOT NULL DEFAULT '0'
) ENGINE=InnoDB DEFAULT CHARSET=latin1;


-- --------------------------------------------------------

-- Table structure for table `trips_assigned_orders`
CREATE TABLE `trips_assigned_orders` (
  `id` int(100) NOT NULL,
  `trip_id` varchar(100) DEFAULT NULL,
  `order_id` varchar(100) DEFAULT NULL,
  `order_shipper` varchar(100) DEFAULT NULL,
  `order_shipper_address` varchar(100) DEFAULT NULL,
  `order_shipper_action` varchar(100) DEFAULT NULL,
  `order_shipper_trailer` varchar(100) DEFAULT NULL,
  `order_shipper_complete` varchar(100) DEFAULT NULL,
  `order_reciever` varchar(100) DEFAULT NULL,
  `order_reciever_address` varchar(100) DEFAULT NULL,
  `order_reciever_action` varchar(100) DEFAULT NULL,
  `order_reciever_trailer` varchar(100) DEFAULT NULL,
  `order_reciever_complete` varchar(100) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;


-- --------------------------------------------------------

-- Table structure for table `trips_assigned_orders1`
CREATE TABLE `trips_assigned_orders1` (
  `id` int(100) NOT NULL,
  `trip_id` varchar(100) DEFAULT NULL,
  `order_id` varchar(100) DEFAULT NULL,
  `role` varchar(100) DEFAULT NULL,
  `shipper` varchar(100) DEFAULT NULL,
  `shipper_address` varchar(100) DEFAULT NULL,
  `shipper_action` varchar(100) DEFAULT NULL,
  `shipper_trailer` varchar(100) DEFAULT NULL,
  `shipper_complete` varchar(100) DEFAULT NULL,
  `sort_order` int(10) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;


-- --------------------------------------------------------

-- Table structure for table `trip_agreed_rate_main`
CREATE TABLE `trip_agreed_rate_main` (
  `id` int(11) NOT NULL,
  `trip_id` int(11) NOT NULL,
  `start_date` datetime DEFAULT NULL,
  `pay_type` varchar(50) DEFAULT NULL,
  `currency` varchar(50) DEFAULT NULL,
  `amount` varchar(50) DEFAULT NULL,
  `sale_tax1` varchar(50) DEFAULT NULL,
  `sale_tax2` varchar(50) DEFAULT NULL,
  `total` varchar(50) DEFAULT NULL,
  `created_date` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=latin1;


-- --------------------------------------------------------

-- Table structure for table `trip_drivers`
CREATE TABLE `trip_drivers` (
  `id` int(255) NOT NULL,
  `trip_id` int(255) NOT NULL,
  `unicode` varchar(255) DEFAULT NULL,
  `event_id` int(255) NOT NULL,
  `truck_no` varchar(255) NOT NULL,
  `driver1` varchar(255) NOT NULL,
  `driver1_whopay` varchar(255) DEFAULT NULL,
  `driver1_paytype` varchar(255) DEFAULT NULL,
  `driver1_currency` varchar(255) DEFAULT NULL,
  `driver1_paytype_rate` varchar(255) DEFAULT NULL,
  `driver1_saletax1` varchar(255) DEFAULT NULL,
  `driver1_saletax1_rate` varchar(255) DEFAULT NULL,
  `driver1_saletax2` varchar(255) DEFAULT NULL,
  `driver1_saletax2_rate` varchar(255) DEFAULT NULL,
  `driver1_unit` double DEFAULT NULL,
  `driver1_miles` double DEFAULT NULL,
  `driver1_start_time` datetime NOT NULL,
  `driver1_end_time` datetime NOT NULL,
  `driver2` varchar(255) NOT NULL,
  `driver2_whopay` varchar(255) DEFAULT NULL,
  `driver2_paytype` varchar(255) DEFAULT NULL,
  `driver2_currency` varchar(255) DEFAULT NULL,
  `driver2_paytype_rate` varchar(255) DEFAULT NULL,
  `driver2_saletax1` varchar(255) DEFAULT NULL,
  `driver2_saletax1_rate` varchar(255) DEFAULT NULL,
  `driver2_saletax2` varchar(255) DEFAULT NULL,
  `driver2_saletax2_rate` varchar(255) DEFAULT NULL,
  `driver2_unit` double DEFAULT NULL,
  `driver2_miles` double DEFAULT NULL,
  `driver2_start_time` datetime NOT NULL,
  `driver2_end_time` datetime NOT NULL,
  `created_date` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=MyISAM DEFAULT CHARSET=latin1;


-- --------------------------------------------------------

-- Table structure for table `trip_event_main`
CREATE TABLE `trip_event_main` (
  `id` int(11) NOT NULL,
  `trip_id` int(11) DEFAULT NULL,
  `pick_deliver_id` int(11) DEFAULT NULL,
  `s_no` int(11) DEFAULT NULL,
  `event_type` varchar(60) DEFAULT NULL,
  `equipment` varchar(200) DEFAULT NULL,
  `order` varchar(200) DEFAULT NULL,
  `location_type` varchar(200) DEFAULT NULL,
  `location_name` varchar(200) DEFAULT NULL,
  `location_address` varchar(200) DEFAULT NULL,
  `address_lat` varchar(200) DEFAULT NULL,
  `address_lang` varchar(200) DEFAULT NULL,
  `city_lat` varchar(200) DEFAULT NULL,
  `city_lang` varchar(200) DEFAULT NULL,
  `start_time` varchar(200) DEFAULT NULL,
  `end_time` varchar(200) DEFAULT NULL,
  `event_status` varchar(200) DEFAULT NULL,
  `miles` varchar(50) DEFAULT NULL,
  `select_shiment_ids` varchar(255) DEFAULT NULL,
  `no_of_shipment_selected` varchar(255) DEFAULT NULL,
  `activity_type` varchar(10) NOT NULL DEFAULT 'order' COMMENT 'event,order',
  `created_date` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=latin1;


-- --------------------------------------------------------

-- Table structure for table `trip_main`
CREATE TABLE `trip_main` (
  `id` int(11) NOT NULL,
  `trip_id` int(11) NOT NULL,
  `assignto` varchar(50) DEFAULT NULL,
  `start_date` datetime DEFAULT NULL,
  `carrier` int(50) DEFAULT NULL,
  `truck_no` varchar(50) DEFAULT NULL,
  `trailer_no` varchar(50) DEFAULT NULL,
  `driver1` varchar(200) DEFAULT NULL,
  `driver2` varchar(200) DEFAULT NULL,
  `created_date` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=latin1;


-- --------------------------------------------------------

-- Table structure for table `trip_master`
CREATE TABLE `trip_master` (
  `id` int(11) NOT NULL,
  `assigned_to` varchar(100) DEFAULT NULL,
  `start_datetime` datetime DEFAULT NULL,
  `carrier_id` int(10) DEFAULT NULL,
  `truck_no` varchar(100) DEFAULT NULL,
  `trailer_no` varchar(100) DEFAULT NULL,
  `driver1` int(10) DEFAULT NULL,
  `driver2` int(10) DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=latin1;


-- --------------------------------------------------------

-- Table structure for table `trip_meta_ept`
CREATE TABLE `trip_meta_ept` (
  `id` int(100) NOT NULL,
  `trip_id` int(100) DEFAULT NULL,
  `role` varchar(25) DEFAULT NULL,
  `ep_id` int(100) DEFAULT NULL,
  `ep_unit` varchar(100) DEFAULT NULL,
  `ep_reason` longtext,
  `ep_status` varchar(100) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;


-- --------------------------------------------------------

-- Table structure for table `trip_rate`
CREATE TABLE `trip_rate` (
  `id` int(11) NOT NULL,
  `trip_id` int(10) DEFAULT NULL,
  `carrier_id` int(11) DEFAULT NULL,
  `pay_type` varchar(100) DEFAULT NULL,
  `pay_currency` varchar(100) DEFAULT NULL,
  `amount` varchar(100) DEFAULT NULL,
  `saletax1` varchar(100) DEFAULT NULL,
  `saletax2` varchar(100) DEFAULT NULL,
  `total` varchar(100) DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=latin1;


-- --------------------------------------------------------

-- Table structure for table `trip_stops`
CREATE TABLE `trip_stops` (
  `id` int(100) NOT NULL,
  `trip_id` varchar(100) DEFAULT NULL,
  `order_id` varchar(100) DEFAULT NULL,
  `role` varchar(25) DEFAULT NULL,
  `stop_location_type` varchar(100) DEFAULT NULL,
  `stop_terminal` varchar(100) DEFAULT NULL,
  `stop_customer` varchar(100) DEFAULT NULL,
  `stop_supplier` varchar(100) DEFAULT NULL,
  `stop_other` varchar(100) DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `sort_order` int(10) NOT NULL DEFAULT '0'
) ENGINE=InnoDB DEFAULT CHARSET=latin1;


-- --------------------------------------------------------

-- Table structure for table `trip_trailer_rel`
CREATE TABLE `trip_trailer_rel` (
  `id` int(11) NOT NULL,
  `trip_id` int(255) NOT NULL DEFAULT '0',
  `trailer_id` int(255) NOT NULL DEFAULT '0',
  `start_time` datetime NOT NULL,
  `end_time` datetime NOT NULL,
  `hooked_status` enum('preplan','planned','dispatched','complete') DEFAULT NULL,
  `event_status` enum('preplan','planned','dispatched','complete') DEFAULT NULL,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=MyISAM DEFAULT CHARSET=latin1;


-- --------------------------------------------------------

-- Table structure for table `trip_truck_paytype`
CREATE TABLE `trip_truck_paytype` (
  `id` int(255) NOT NULL,
  `trip_event_id` int(255) DEFAULT NULL,
  `trip_id` int(255) DEFAULT NULL,
  `truck_id` int(255) DEFAULT NULL,
  `truck_owned_by` varchar(255) DEFAULT NULL,
  `truck_pay_type_mode` varchar(255) DEFAULT NULL,
  `pay_type` varchar(100) DEFAULT NULL,
  `currency` varchar(10) DEFAULT NULL,
  `rate` double DEFAULT NULL,
  `paytype_saletaxname1` varchar(255) DEFAULT NULL,
  `paytype_saletaxname2` varchar(255) DEFAULT NULL,
  `paytype_saletax1` varchar(255) DEFAULT NULL,
  `paytype_saletax2` varchar(100) DEFAULT NULL,
  `pay_unit` varchar(255) DEFAULT NULL,
  `miles` double DEFAULT NULL,
  `extra_paytype_reason` varchar(255) DEFAULT NULL,
  `extra_paytype_status` varchar(255) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=latin1;


-- --------------------------------------------------------

-- Table structure for table `trip_truck_rel`
CREATE TABLE `trip_truck_rel` (
  `id` int(11) NOT NULL,
  `trip_id` int(255) NOT NULL DEFAULT '0',
  `truck_id` int(255) NOT NULL DEFAULT '0',
  `start_time` datetime NOT NULL,
  `end_time` datetime NOT NULL,
  `aquire_status` enum('preplan','planned','dispatched','complete') DEFAULT NULL,
  `event_status` enum('preplan','planned','dispatched','complete') DEFAULT NULL,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=MyISAM DEFAULT CHARSET=latin1;


-- --------------------------------------------------------

-- Table structure for table `truckplates`
CREATE TABLE `truckplates` (
  `id` int(11) NOT NULL,
  `truck_plate` varchar(100) NOT NULL,
  `issue_date` date DEFAULT NULL,
  `expiry_date` date DEFAULT NULL,
  `state` varchar(50) NOT NULL,
  `country` varchar(50) NOT NULL,
  `nastate` varchar(100) NOT NULL,
  `nacountry` varchar(100) NOT NULL,
  `annual_cost` varchar(50) NOT NULL,
  `currency` varchar(25) NOT NULL,
  `saletax1` varchar(25) NOT NULL,
  `saletax2` varchar(25) NOT NULL,
  `type` varchar(25) NOT NULL,
  `nokm` varchar(100) NOT NULL,
  `weight` varchar(25) NOT NULL,
  `unit` varchar(25) NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `delete_status` tinyint(1) NOT NULL DEFAULT '0'
) ENGINE=InnoDB DEFAULT CHARSET=latin1;


-- --------------------------------------------------------

-- Table structure for table `trucks`
CREATE TABLE `trucks` (
  `id` int(255) NOT NULL,
  `trip_id` int(255) DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `vin` varchar(100) NOT NULL,
  `loc_type` varchar(255) DEFAULT NULL,
  `loc_id` varchar(255) DEFAULT NULL,
  `loc_name` varchar(255) DEFAULT NULL,
  `location_lat` double DEFAULT NULL,
  `location_long` double DEFAULT NULL,
  `sother` varchar(255) DEFAULT NULL,
  `sterminals` varchar(255) DEFAULT NULL,
  `scustomers` varchar(255) DEFAULT NULL,
  `ssuppliers` varchar(255) DEFAULT NULL,
  `plate_name` varchar(255) NOT NULL,
  `plate_state` varchar(255) NOT NULL,
  `address` varchar(100) NOT NULL,
  `latitude` varchar(100) DEFAULT NULL,
  `longitude` varchar(100) DEFAULT NULL,
  `city` varchar(100) NOT NULL,
  `city_lat` varchar(255) NOT NULL,
  `city_long` varchar(255) NOT NULL,
  `loc_state` varchar(255) NOT NULL,
  `unit` varchar(50) NOT NULL,
  `make` varchar(50) NOT NULL,
  `model` varchar(50) NOT NULL,
  `year` varchar(50) NOT NULL,
  `purchase_price` varchar(50) NOT NULL,
  `currency` varchar(25) NOT NULL,
  `saletax1` varchar(50) NOT NULL,
  `saletax2` varchar(50) NOT NULL,
  `monthly_payment` varchar(50) NOT NULL,
  `mpcurrency` varchar(25) NOT NULL,
  `mpsaletax1` varchar(50) NOT NULL,
  `mpsaletax2` varchar(50) NOT NULL,
  `truck_type` varchar(50) NOT NULL,
  `weight_capacity` varchar(50) NOT NULL,
  `tare_weight` varchar(50) NOT NULL,
  `tare_weight_unit` varchar(50) NOT NULL,
  `odometer` varchar(50) NOT NULL,
  `odometer_unit` varchar(50) NOT NULL,
  `tire_size_steer_axle` varchar(50) NOT NULL,
  `tire_size_drive_axle` varchar(50) NOT NULL,
  `tire_size_drive_axle2` varchar(50) NOT NULL,
  `default_driver1` varchar(50) NOT NULL,
  `default_driver2` varchar(50) NOT NULL,
  `inside_width` varchar(50) NOT NULL,
  `inside_height` varchar(50) NOT NULL,
  `inside_length` varchar(50) NOT NULL,
  `last_pm_date` date DEFAULT NULL,
  `last_pm_odometer` varchar(50) NOT NULL,
  `last_safety_date` date DEFAULT NULL,
  `last_safety_odometer` varchar(50) NOT NULL,
  `last_oil_change_date` date DEFAULT NULL,
  `last_oil_change_odometer` varchar(50) NOT NULL,
  `terminal` varchar(50) NOT NULL,
  `boundry` varchar(50) NOT NULL,
  `nokm` varchar(50) NOT NULL,
  `country` varchar(100) DEFAULT NULL,
  `state` varchar(100) DEFAULT NULL,
  `nacountry` varchar(100) DEFAULT NULL,
  `nastate` varchar(100) DEFAULT NULL,
  `owned_by` varchar(50) NOT NULL,
  `truck_group` varchar(100) DEFAULT NULL,
  `vcfep` varchar(100) NOT NULL,
  `vcfef` varchar(100) NOT NULL,
  `vcfevb` varchar(100) NOT NULL,
  `suppliers` varchar(50) NOT NULL,
  `truckplate` varchar(50) DEFAULT NULL,
  `last_checkup_date` date DEFAULT NULL,
  `last_checkup_odometer` varchar(100) NOT NULL,
  `truck_engine` varchar(100) NOT NULL,
  `truck_engine_sn` varchar(100) NOT NULL,
  `truck_transmission` varchar(100) NOT NULL,
  `truck_transmission_make` varchar(100) NOT NULL,
  `truck_transmission_speed` varchar(100) NOT NULL,
  `truck_gps_tracking_unit` varchar(100) NOT NULL,
  `truck_status` varchar(25) NOT NULL,
  `truck_status_comment` varchar(100) NOT NULL,
  `publish` enum('0','1') NOT NULL DEFAULT '0',
  `nyhut` varchar(10) NOT NULL,
  `apu` varchar(10) NOT NULL,
  `fridge` varchar(10) NOT NULL,
  `invertor` varchar(10) NOT NULL,
  `microwave` varchar(10) NOT NULL,
  `double_bunk` varchar(10) NOT NULL,
  `in_trip_status` int(10) NOT NULL DEFAULT '0',
  `event_status` enum('preplan','planned','dispatched','complete') DEFAULT NULL,
  `delete_status` int(10) NOT NULL DEFAULT '0' COMMENT 'if 1 then its not in use'
) ENGINE=InnoDB DEFAULT CHARSET=latin1;


-- --------------------------------------------------------

-- Table structure for table `trucks_assigned_trips`
CREATE TABLE `trucks_assigned_trips` (
  `id` int(11) NOT NULL,
  `truck_id` int(11) DEFAULT NULL,
  `trip_id` varchar(100) DEFAULT NULL,
  `assigned_date` datetime DEFAULT NULL,
  `assigned_upto` datetime DEFAULT NULL,
  `status` int(10) NOT NULL DEFAULT '0'
) ENGINE=InnoDB DEFAULT CHARSET=latin1;


-- --------------------------------------------------------

-- Table structure for table `truck_meta_extrapaytype`
CREATE TABLE `truck_meta_extrapaytype` (
  `id` int(250) NOT NULL,
  `truck_id` varchar(100) NOT NULL,
  `extrapay_type` varchar(100) NOT NULL,
  `currency` varchar(10) NOT NULL,
  `rate` varchar(50) NOT NULL,
  `extrapaytype_saletax1` varchar(100) NOT NULL,
  `extrapaytype_saletax2` varchar(100) NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=latin1;


-- --------------------------------------------------------

-- Table structure for table `truck_meta_paytype`
CREATE TABLE `truck_meta_paytype` (
  `id` int(250) NOT NULL,
  `truck_id` varchar(100) NOT NULL,
  `pay_type` varchar(100) NOT NULL,
  `currency` varchar(10) NOT NULL,
  `rate` varchar(50) NOT NULL,
  `paytype_saletax1` varchar(100) NOT NULL,
  `paytype_saletax2` varchar(100) NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=latin1;


-- --------------------------------------------------------

-- Table structure for table `truck_meta_safety_doc`
CREATE TABLE `truck_meta_safety_doc` (
  `id` int(250) NOT NULL,
  `truck_id` varchar(100) NOT NULL,
  `safety_document` varchar(50) NOT NULL,
  `issuing_date` date DEFAULT NULL,
  `expiry` varchar(10) NOT NULL,
  `expiry_date` date DEFAULT NULL,
  `file` varchar(250) DEFAULT NULL,
  `description` varchar(100) NOT NULL,
  `frequency` varchar(100) NOT NULL,
  `document_number` varchar(50) NOT NULL,
  `issuing_state` varchar(50) NOT NULL,
  `issuing_country` varchar(50) NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=latin1;


-- --------------------------------------------------------

-- Table structure for table `uploaddocs`
CREATE TABLE `uploaddocs` (
  `id` int(100) NOT NULL,
  `name` varchar(100) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;


-- --------------------------------------------------------

-- Table structure for table `users`
CREATE TABLE `users` (
  `id` int(100) NOT NULL,
  `email` varchar(100) NOT NULL,
  `password` varchar(100) NOT NULL,
  `full_name` varchar(100) DEFAULT NULL,
  `phone` varchar(50) DEFAULT NULL,
  `address` varchar(150) NOT NULL,
  `profile_picture` varchar(100) DEFAULT NULL,
  `signup_type` enum('NATIVE','GOOGLE','FACEBOOK') DEFAULT 'NATIVE',
  `gcm_token` longtext NOT NULL,
  `govt_id` varchar(150) NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `verification_code` int(10) DEFAULT NULL,
  `verification_status` tinyint(1) DEFAULT '0',
  `delete_status` tinyint(1) NOT NULL DEFAULT '0'
) ENGINE=MyISAM DEFAULT CHARSET=latin1;


-- --------------------------------------------------------

-- Table structure for table `user_activity`
CREATE TABLE `user_activity` (
  `id` int(11) NOT NULL,
  `username` varchar(255) DEFAULT NULL,
  `user_id` int(11) DEFAULT NULL,
  `activity_name` varchar(255) DEFAULT NULL,
  `activity_id` int(11) DEFAULT NULL,
  `email` varchar(100) DEFAULT NULL,
  `phone` varchar(50) DEFAULT NULL,
  `activity_date` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=MyISAM DEFAULT CHARSET=latin1;


-- --------------------------------------------------------

-- Table structure for table `user_attendance`
CREATE TABLE `user_attendance` (
  `id` int(11) NOT NULL,
  `user_role` varchar(100) DEFAULT NULL,
  `user_id` int(11) DEFAULT NULL,
  `paytype` int(10) DEFAULT NULL,
  `policy` int(10) DEFAULT NULL,
  `start_time` datetime NOT NULL,
  `end_time` datetime NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=MyISAM DEFAULT CHARSET=latin1;


-- --------------------------------------------------------

-- Table structure for table `videos`
CREATE TABLE `videos` (
  `id` int(100) NOT NULL,
  `artist_id` int(100) NOT NULL,
  `video` varchar(150) NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=MyISAM DEFAULT CHARSET=latin1;


-- --------------------------------------------------------

-- Table structure for table `zip`
CREATE TABLE `zip` (
  `id` int(100) NOT NULL,
  `name` varchar(100) DEFAULT NULL,
  `city` varchar(100) NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

-- Indexes for dumped tables
--

--
-- Indexes for table `account_payments`
--
ALTER TABLE `account_payments`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `additionalcharges`
--
ALTER TABLE `additionalcharges`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `admin`
--
ALTER TABLE `admin`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `username` (`username`);

--
-- Indexes for table `advance_filter`
--
ALTER TABLE `advance_filter`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `api_keys`
--
ALTER TABLE `api_keys`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `backup`
--
ALTER TABLE `backup`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `blogs`
--
ALTER TABLE `blogs`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `bookings`
--
ALTER TABLE `bookings`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `category`
--
ALTER TABLE `category`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `category_name` (`category_name`),
  ADD UNIQUE KEY `slug` (`slug`);

--
-- Indexes for table `cities`
--
ALTER TABLE `cities`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `cities1`
--
ALTER TABLE `cities1`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `ci_sessions`
--
ALTER TABLE `ci_sessions`
  ADD PRIMARY KEY (`id`),
  ADD KEY `ci_sessions_timestamp` (`timestamp`),
  ADD KEY `id` (`id`),
  ADD KEY `ip_address` (`ip_address`);

--
-- Indexes for table `codes`
--
ALTER TABLE `codes`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `codes1`
--
ALTER TABLE `codes1`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `contactpersons`
--
ALTER TABLE `contactpersons`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `continent`
--
ALTER TABLE `continent`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `conversation`
--
ALTER TABLE `conversation`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `csr`
--
ALTER TABLE `csr`
  ADD PRIMARY KEY (`id`),
  ADD KEY `id` (`id`),
  ADD KEY `name` (`name`),
  ADD KEY `address` (`address`),
  ADD KEY `phone` (`phone`),
  ADD KEY `email` (`email`),
  ADD KEY `role` (`role`),
  ADD KEY `rating` (`rating`),
  ADD KEY `aphone` (`aphone`);

--
-- Indexes for table `currency`
--
ALTER TABLE `currency`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `custombrokers`
--
ALTER TABLE `custombrokers`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `deductions`
--
ALTER TABLE `deductions`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `drivers`
--
ALTER TABLE `drivers`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `drivers_assigned_trips`
--
ALTER TABLE `drivers_assigned_trips`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `drivers_deductions_master`
--
ALTER TABLE `drivers_deductions_master`
  ADD PRIMARY KEY (`id`),
  ADD KEY `Driver_ded_rel` (`driver_id`);

--
-- Indexes for table `driver_activation_history`
--
ALTER TABLE `driver_activation_history`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `driver_meta_deduction`
--
ALTER TABLE `driver_meta_deduction`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `driver_meta_equipment`
--
ALTER TABLE `driver_meta_equipment`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `driver_meta_extrapaytype`
--
ALTER TABLE `driver_meta_extrapaytype`
  ADD PRIMARY KEY (`id`),
  ADD KEY `rel_drivers` (`driver_id`);

--
-- Indexes for table `driver_meta_paytype`
--
ALTER TABLE `driver_meta_paytype`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `driver_meta_safety_doc`
--
ALTER TABLE `driver_meta_safety_doc`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `equipments`
--
ALTER TABLE `equipments`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `equipment_return_log`
--
ALTER TABLE `equipment_return_log`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `events`
--
ALTER TABLE `events`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `category_name` (`event_name`);

--
-- Indexes for table `extrapay_types`
--
ALTER TABLE `extrapay_types`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `filter`
--
ALTER TABLE `filter`
  ADD PRIMARY KEY (`id_filter`);

--
-- Indexes for table `fuel`
--
ALTER TABLE `fuel`
  ADD PRIMARY KEY (`id`) USING BTREE;

--
-- Indexes for table `generate_delivery`
--
ALTER TABLE `generate_delivery`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `generate_payid`
--
ALTER TABLE `generate_payid`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `group_security_permission`
--
ALTER TABLE `group_security_permission`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `hr_policy`
--
ALTER TABLE `hr_policy`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `hr_system`
--
ALTER TABLE `hr_system`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `in_usage`
--
ALTER TABLE `in_usage`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `leads`
--
ALTER TABLE `leads`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `leg_locations`
--
ALTER TABLE `leg_locations`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `leg_parts`
--
ALTER TABLE `leg_parts`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `main_message`
--
ALTER TABLE `main_message`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `make_driver_payments`
--
ALTER TABLE `make_driver_payments`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `merchants`
--
ALTER TABLE `merchants`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `email` (`email`);

--
-- Indexes for table `messages`
--
ALTER TABLE `messages`
  ADD PRIMARY KEY (`id`),
  ADD KEY `message_from` (`user_id`);

--
-- Indexes for table `news_feed`
--
ALTER TABLE `news_feed`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `new_agreed_rate`
--
ALTER TABLE `new_agreed_rate`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `new_event`
--
ALTER TABLE `new_event`
  ADD PRIMARY KEY (`id`),
  ADD KEY `id` (`id`),
  ADD KEY `trip_id` (`trip_id`),
  ADD KEY `order_part` (`order_part`),
  ADD KEY `location_name` (`location_name`),
  ADD KEY `location_address` (`location_address`),
  ADD KEY `event_type` (`event_type`),
  ADD KEY `equipment` (`equipment`),
  ADD KEY `order` (`order`),
  ADD KEY `location_type` (`location_type`),
  ADD KEY `event_status` (`event_status`),
  ADD KEY `miles` (`miles`),
  ADD KEY `no_of_shipment_selected` (`no_of_shipment_selected`),
  ADD KEY `activity_type` (`activity_type`),
  ADD KEY `s_no` (`s_no`);

--
-- Indexes for table `new_trip`
--
ALTER TABLE `new_trip`
  ADD PRIMARY KEY (`id`),
  ADD KEY `id` (`id`),
  ADD KEY `start_date` (`start_date`),
  ADD KEY `carrier` (`carrier`),
  ADD KEY `truck_no` (`truck_no`),
  ADD KEY `driver1` (`driver1`),
  ADD KEY `driver2` (`driver2`),
  ADD KEY `trailer_no` (`trailer_no`);

--
-- Indexes for table `omnitrac_gps_data`
--
ALTER TABLE `omnitrac_gps_data`
  ADD PRIMARY KEY (`id`),
  ADD KEY `position_time_stamp` (`position_time_stamp`),
  ADD KEY `position_lon` (`position_lon`),
  ADD KEY `position_lat` (`position_lat`),
  ADD KEY `equipment_ID` (`equipment_ID`),
  ADD KEY `eventTS_timestamp` (`eventTS_timestamp`),
  ADD KEY `tran_id` (`tran_id`);

--
-- Indexes for table `orderlane`
--
ALTER TABLE `orderlane`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `orders`
--
ALTER TABLE `orders`
  ADD PRIMARY KEY (`id`),
  ADD KEY `id` (`id`),
  ADD KEY `customer` (`customer`);

--
-- Indexes for table `orders_main`
--
ALTER TABLE `orders_main`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `order_additional_charges`
--
ALTER TABLE `order_additional_charges`
  ADD PRIMARY KEY (`id`),
  ADD KEY `order_id` (`order_id`);

--
-- Indexes for table `order_additional_charges_main`
--
ALTER TABLE `order_additional_charges_main`
  ADD PRIMARY KEY (`id`),
  ADD KEY `order_id` (`order_id`);

--
-- Indexes for table `order_alt_emails`
--
ALTER TABLE `order_alt_emails`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `order_delivery`
--
ALTER TABLE `order_delivery`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `order_delivery_info_meta`
--
ALTER TABLE `order_delivery_info_meta`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `order_delivery_info_meta_main`
--
ALTER TABLE `order_delivery_info_meta_main`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `order_delivery_main`
--
ALTER TABLE `order_delivery_main`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `order_delivery_new`
--
ALTER TABLE `order_delivery_new`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `order_delivery_shipments`
--
ALTER TABLE `order_delivery_shipments`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `order_delivery_shipments_main`
--
ALTER TABLE `order_delivery_shipments_main`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `order_delivery_shipments_meta`
--
ALTER TABLE `order_delivery_shipments_meta`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `order_delivery_shipments_meta_main`
--
ALTER TABLE `order_delivery_shipments_meta_main`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `order_groups`
--
ALTER TABLE `order_groups`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `order_legs`
--
ALTER TABLE `order_legs`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `order_legs2`
--
ALTER TABLE `order_legs2`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `order_notes`
--
ALTER TABLE `order_notes`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `order_notes_main`
--
ALTER TABLE `order_notes_main`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `order_parts`
--
ALTER TABLE `order_parts`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `order_pickups`
--
ALTER TABLE `order_pickups`
  ADD PRIMARY KEY (`id`),
  ADD KEY `ord_pickup_rel` (`order_id`),
  ADD KEY `id` (`id`),
  ADD KEY `pickup_shipper` (`pickup_shipper`),
  ADD KEY `shipper_address` (`shipper_address`),
  ADD KEY `order_id` (`order_id`);

--
-- Indexes for table `order_pickups_main`
--
ALTER TABLE `order_pickups_main`
  ADD PRIMARY KEY (`id`),
  ADD KEY `ord_pickup_rel` (`order_id`);

--
-- Indexes for table `order_pickups_shipment`
--
ALTER TABLE `order_pickups_shipment`
  ADD PRIMARY KEY (`id`),
  ADD KEY `id` (`id`),
  ADD KEY `pickups_id` (`pickups_id`),
  ADD KEY `order_id` (`order_id`),
  ADD KEY `pickup_shipment_description` (`pickup_shipment_description`),
  ADD KEY `pickup_no_pcs` (`pickup_no_pcs`),
  ADD KEY `commodity` (`commodity`),
  ADD KEY `pickup_stackable` (`pickup_stackable`),
  ADD KEY `pickup_weight` (`pickup_weight`),
  ADD KEY `pickup_width` (`pickup_width`);

--
-- Indexes for table `order_pickups_shipment_main`
--
ALTER TABLE `order_pickups_shipment_main`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `order_revenues`
--
ALTER TABLE `order_revenues`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `order_upload_docs`
--
ALTER TABLE `order_upload_docs`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `order_upload_docs_main`
--
ALTER TABLE `order_upload_docs_main`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `paps_master`
--
ALTER TABLE `paps_master`
  ADD PRIMARY KEY (`paps_sequence`);

--
-- Indexes for table `paps_pars_generate`
--
ALTER TABLE `paps_pars_generate`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `trip_id` (`trip_id`);

--
-- Indexes for table `pars_master`
--
ALTER TABLE `pars_master`
  ADD PRIMARY KEY (`pars_sequence`);

--
-- Indexes for table `paysettelment_master_report`
--
ALTER TABLE `paysettelment_master_report`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `pay_types`
--
ALTER TABLE `pay_types`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `pickupequipments`
--
ALTER TABLE `pickupequipments`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `recharges`
--
ALTER TABLE `recharges`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `serial_no` (`serial_no`),
  ADD UNIQUE KEY `scratch_code` (`scratch_code`);

--
-- Indexes for table `repairshops`
--
ALTER TABLE `repairshops`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `roles`
--
ALTER TABLE `roles`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `safetydocs`
--
ALTER TABLE `safetydocs`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `saletax`
--
ALTER TABLE `saletax`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `security_groups`
--
ALTER TABLE `security_groups`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `security_group_users`
--
ALTER TABLE `security_group_users`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `shipment_full_detail`
--
ALTER TABLE `shipment_full_detail`
  ADD PRIMARY KEY (`id`),
  ADD KEY `id` (`id`),
  ADD KEY `order_part` (`order_part`),
  ADD KEY `assigned_trip_id` (`assigned_trip_id`),
  ADD KEY `trip_id_pickup` (`trip_id_pickup`),
  ADD KEY `trip_id_delivery` (`trip_id_delivery`),
  ADD KEY `order_id` (`order_id`),
  ADD KEY `pickups_id` (`pickups_id`),
  ADD KEY `delivery_id` (`delivery_id`),
  ADD KEY `pickup_done` (`pickup_done`),
  ADD KEY `delivery_done` (`delivery_done`),
  ADD KEY `receiver_address` (`receiver_address`),
  ADD KEY `delivery_no_pcs` (`delivery_no_pcs`),
  ADD KEY `pcs_total` (`pcs_total`),
  ADD KEY `shipment` (`shipment`),
  ADD KEY `commodity` (`commodity`),
  ADD KEY `pu_planned` (`pu_planned`);

--
-- Indexes for table `shipment_full_detail_main`
--
ALTER TABLE `shipment_full_detail_main`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `Ship_Trip_rel`
--
ALTER TABLE `Ship_Trip_rel`
  ADD PRIMARY KEY (`ID`),
  ADD KEY `ID` (`ID`),
  ADD KEY `order_part` (`order_part`),
  ADD KEY `Trip_ID` (`Trip_ID`),
  ADD KEY `order_id` (`order_id`),
  ADD KEY `pickups_id` (`pickups_id`),
  ADD KEY `delivery_id` (`delivery_id`),
  ADD KEY `delivery_shipment_description` (`delivery_shipment_description`),
  ADD KEY `pcs_total` (`pcs_total`),
  ADD KEY `Dropped_at_dock` (`Dropped_at_dock`),
  ADD KEY `event_status` (`event_status`),
  ADD KEY `pickup_done` (`pickup_done`),
  ADD KEY `delivery_done` (`delivery_done`),
  ADD KEY `truck_no` (`truck_no`),
  ADD KEY `loaded_On_Trailer` (`loaded_On_Trailer`),
  ADD KEY `lag` (`lag`);

--
-- Indexes for table `states`
--
ALTER TABLE `states`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `states1`
--
ALTER TABLE `states1`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `suppliers`
--
ALTER TABLE `suppliers`
  ADD PRIMARY KEY (`id`),
  ADD KEY `id` (`id`),
  ADD KEY `name` (`name`),
  ADD KEY `role` (`role`),
  ADD KEY `address` (`address`),
  ADD KEY `phone` (`phone`),
  ADD KEY `email` (`email`),
  ADD KEY `unit` (`unit`),
  ADD KEY `rating` (`rating`);

--
-- Indexes for table `tasks`
--
ALTER TABLE `tasks`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `tasks_frequency`
--
ALTER TABLE `tasks_frequency`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `task_reference`
--
ALTER TABLE `task_reference`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `task_reference_frequency`
--
ALTER TABLE `task_reference_frequency`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `terminals`
--
ALTER TABLE `terminals`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `trailers`
--
ALTER TABLE `trailers`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `trailers_assigned_trips`
--
ALTER TABLE `trailers_assigned_trips`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `trailer_meta_extrapaytype`
--
ALTER TABLE `trailer_meta_extrapaytype`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `trailer_meta_paytype`
--
ALTER TABLE `trailer_meta_paytype`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `trailer_meta_safety_doc`
--
ALTER TABLE `trailer_meta_safety_doc`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `transactions`
--
ALTER TABLE `transactions`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `trips`
--
ALTER TABLE `trips`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `trips_assigned_orders`
--
ALTER TABLE `trips_assigned_orders`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `trips_assigned_orders1`
--
ALTER TABLE `trips_assigned_orders1`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `trip_agreed_rate_main`
--
ALTER TABLE `trip_agreed_rate_main`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `trip_drivers`
--
ALTER TABLE `trip_drivers`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `trip_event_main`
--
ALTER TABLE `trip_event_main`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `trip_main`
--
ALTER TABLE `trip_main`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `trip_master`
--
ALTER TABLE `trip_master`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `trip_meta_ept`
--
ALTER TABLE `trip_meta_ept`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `trip_rate`
--
ALTER TABLE `trip_rate`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `trip_stops`
--
ALTER TABLE `trip_stops`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `trip_trailer_rel`
--
ALTER TABLE `trip_trailer_rel`
  ADD PRIMARY KEY (`id`),
  ADD KEY `id` (`id`),
  ADD KEY `trip_id` (`trip_id`),
  ADD KEY `trailer_id` (`trailer_id`),
  ADD KEY `start_time` (`start_time`),
  ADD KEY `end_time` (`end_time`),
  ADD KEY `hooked_status` (`hooked_status`),
  ADD KEY `event_status` (`event_status`);

--
-- Indexes for table `trip_truck_paytype`
--
ALTER TABLE `trip_truck_paytype`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `trip_truck_rel`
--
ALTER TABLE `trip_truck_rel`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `truckplates`
--
ALTER TABLE `truckplates`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `trucks`
--
ALTER TABLE `trucks`
  ADD PRIMARY KEY (`id`),
  ADD KEY `unit` (`unit`),
  ADD KEY `id` (`id`),
  ADD KEY `plate_name` (`plate_name`),
  ADD KEY `plate_state` (`plate_state`),
  ADD KEY `vin` (`vin`),
  ADD KEY `make` (`make`),
  ADD KEY `address` (`address`),
  ADD KEY `last_pm_date` (`last_pm_date`),
  ADD KEY `last_safety_date` (`last_safety_date`);

--
-- Indexes for table `trucks_assigned_trips`
--
ALTER TABLE `trucks_assigned_trips`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `truck_meta_extrapaytype`
--
ALTER TABLE `truck_meta_extrapaytype`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `truck_meta_paytype`
--
ALTER TABLE `truck_meta_paytype`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `truck_meta_safety_doc`
--
ALTER TABLE `truck_meta_safety_doc`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `uploaddocs`
--
ALTER TABLE `uploaddocs`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `users`
--
ALTER TABLE `users`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `user_activity`
--
ALTER TABLE `user_activity`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `user_attendance`
--
ALTER TABLE `user_attendance`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `videos`
--
ALTER TABLE `videos`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `zip`
--
ALTER TABLE `zip`
  ADD PRIMARY KEY (`id`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `account_payments`
--
ALTER TABLE `account_payments`
  MODIFY `id` int(150) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `additionalcharges`
--
ALTER TABLE `additionalcharges`
  MODIFY `id` int(255) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `admin`
--
ALTER TABLE `admin`
  MODIFY `id` int(10) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `advance_filter`
--
ALTER TABLE `advance_filter`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `api_keys`
--
ALTER TABLE `api_keys`
  MODIFY `id` int(2) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `backup`
--
ALTER TABLE `backup`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `blogs`
--
ALTER TABLE `blogs`
  MODIFY `id` int(100) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `bookings`
--
ALTER TABLE `bookings`
  MODIFY `id` int(150) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `category`
--
ALTER TABLE `category`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `cities`
--
ALTER TABLE `cities`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `cities1`
--
ALTER TABLE `cities1`
  MODIFY `id` int(100) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `codes`
--
ALTER TABLE `codes`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `codes1`
--
ALTER TABLE `codes1`
  MODIFY `id` int(100) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `contactpersons`
--
ALTER TABLE `contactpersons`
  MODIFY `id` int(100) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `continent`
--
ALTER TABLE `continent`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `conversation`
--
ALTER TABLE `conversation`
  MODIFY `id` int(100) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `csr`
--
ALTER TABLE `csr`
  MODIFY `id` int(255) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `currency`
--
ALTER TABLE `currency`
  MODIFY `id` int(100) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `custombrokers`
--
ALTER TABLE `custombrokers`
  MODIFY `id` int(100) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `deductions`
--
ALTER TABLE `deductions`
  MODIFY `id` int(100) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `drivers`
--
ALTER TABLE `drivers`
  MODIFY `id` int(255) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `drivers_assigned_trips`
--
ALTER TABLE `drivers_assigned_trips`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `drivers_deductions_master`
--
ALTER TABLE `drivers_deductions_master`
  MODIFY `id` int(255) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `driver_activation_history`
--
ALTER TABLE `driver_activation_history`
  MODIFY `id` int(100) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `driver_meta_deduction`
--
ALTER TABLE `driver_meta_deduction`
  MODIFY `id` int(250) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `driver_meta_equipment`
--
ALTER TABLE `driver_meta_equipment`
  MODIFY `id` int(150) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `driver_meta_extrapaytype`
--
ALTER TABLE `driver_meta_extrapaytype`
  MODIFY `id` int(250) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `driver_meta_paytype`
--
ALTER TABLE `driver_meta_paytype`
  MODIFY `id` int(250) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `driver_meta_safety_doc`
--
ALTER TABLE `driver_meta_safety_doc`
  MODIFY `id` int(250) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `equipments`
--
ALTER TABLE `equipments`
  MODIFY `id` int(100) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `equipment_return_log`
--
ALTER TABLE `equipment_return_log`
  MODIFY `id` int(100) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `events`
--
ALTER TABLE `events`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `extrapay_types`
--
ALTER TABLE `extrapay_types`
  MODIFY `id` int(100) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `filter`
--
ALTER TABLE `filter`
  MODIFY `id_filter` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `fuel`
--
ALTER TABLE `fuel`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `generate_delivery`
--
ALTER TABLE `generate_delivery`
  MODIFY `id` int(100) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `generate_payid`
--
ALTER TABLE `generate_payid`
  MODIFY `id` int(100) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `group_security_permission`
--
ALTER TABLE `group_security_permission`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `hr_policy`
--
ALTER TABLE `hr_policy`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `hr_system`
--
ALTER TABLE `hr_system`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `in_usage`
--
ALTER TABLE `in_usage`
  MODIFY `id` int(100) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `leads`
--
ALTER TABLE `leads`
  MODIFY `id` int(100) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `leg_locations`
--
ALTER TABLE `leg_locations`
  MODIFY `id` int(100) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `leg_parts`
--
ALTER TABLE `leg_parts`
  MODIFY `id` int(100) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `main_message`
--
ALTER TABLE `main_message`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `make_driver_payments`
--
ALTER TABLE `make_driver_payments`
  MODIFY `id` int(100) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `merchants`
--
ALTER TABLE `merchants`
  MODIFY `id` int(100) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `messages`
--
ALTER TABLE `messages`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `news_feed`
--
ALTER TABLE `news_feed`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `new_agreed_rate`
--
ALTER TABLE `new_agreed_rate`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `new_event`
--
ALTER TABLE `new_event`
  MODIFY `id` int(255) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `new_trip`
--
ALTER TABLE `new_trip`
  MODIFY `id` int(250) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `omnitrac_gps_data`
--
ALTER TABLE `omnitrac_gps_data`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `orderlane`
--
ALTER TABLE `orderlane`
  MODIFY `id` int(10) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `orders`
--
ALTER TABLE `orders`
  MODIFY `id` int(255) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `order_additional_charges`
--
ALTER TABLE `order_additional_charges`
  MODIFY `id` int(100) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `order_additional_charges_main`
--
ALTER TABLE `order_additional_charges_main`
  MODIFY `id` int(100) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `order_alt_emails`
--
ALTER TABLE `order_alt_emails`
  MODIFY `id` int(100) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `order_delivery`
--
ALTER TABLE `order_delivery`
  MODIFY `id` int(255) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `order_delivery_info_meta`
--
ALTER TABLE `order_delivery_info_meta`
  MODIFY `id` int(100) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `order_delivery_info_meta_main`
--
ALTER TABLE `order_delivery_info_meta_main`
  MODIFY `id` int(100) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `order_delivery_main`
--
ALTER TABLE `order_delivery_main`
  MODIFY `id` int(255) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `order_delivery_new`
--
ALTER TABLE `order_delivery_new`
  MODIFY `id` int(150) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `order_delivery_shipments`
--
ALTER TABLE `order_delivery_shipments`
  MODIFY `id` int(100) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `order_delivery_shipments_main`
--
ALTER TABLE `order_delivery_shipments_main`
  MODIFY `id` int(100) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `order_delivery_shipments_meta`
--
ALTER TABLE `order_delivery_shipments_meta`
  MODIFY `id` int(100) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `order_delivery_shipments_meta_main`
--
ALTER TABLE `order_delivery_shipments_meta_main`
  MODIFY `id` int(100) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `order_groups`
--
ALTER TABLE `order_groups`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `order_legs`
--
ALTER TABLE `order_legs`
  MODIFY `id` int(100) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `order_legs2`
--
ALTER TABLE `order_legs2`
  MODIFY `id` int(100) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `order_notes`
--
ALTER TABLE `order_notes`
  MODIFY `id` int(100) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `order_notes_main`
--
ALTER TABLE `order_notes_main`
  MODIFY `id` int(100) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `order_parts`
--
ALTER TABLE `order_parts`
  MODIFY `id` int(100) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `order_pickups`
--
ALTER TABLE `order_pickups`
  MODIFY `id` int(255) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `order_pickups_main`
--
ALTER TABLE `order_pickups_main`
  MODIFY `id` int(255) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `order_pickups_shipment`
--
ALTER TABLE `order_pickups_shipment`
  MODIFY `id` int(255) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `order_pickups_shipment_main`
--
ALTER TABLE `order_pickups_shipment_main`
  MODIFY `id` int(255) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `order_revenues`
--
ALTER TABLE `order_revenues`
  MODIFY `id` int(100) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `order_upload_docs`
--
ALTER TABLE `order_upload_docs`
  MODIFY `id` int(100) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `order_upload_docs_main`
--
ALTER TABLE `order_upload_docs_main`
  MODIFY `id` int(100) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `paps_master`
--
ALTER TABLE `paps_master`
  MODIFY `paps_sequence` int(255) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `paps_pars_generate`
--
ALTER TABLE `paps_pars_generate`
  MODIFY `id` int(250) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `pars_master`
--
ALTER TABLE `pars_master`
  MODIFY `pars_sequence` int(255) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `paysettelment_master_report`
--
ALTER TABLE `paysettelment_master_report`
  MODIFY `id` int(255) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `pay_types`
--
ALTER TABLE `pay_types`
  MODIFY `id` int(100) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `pickupequipments`
--
ALTER TABLE `pickupequipments`
  MODIFY `id` int(100) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `recharges`
--
ALTER TABLE `recharges`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `repairshops`
--
ALTER TABLE `repairshops`
  MODIFY `id` int(100) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `roles`
--
ALTER TABLE `roles`
  MODIFY `id` int(100) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `safetydocs`
--
ALTER TABLE `safetydocs`
  MODIFY `id` int(100) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `saletax`
--
ALTER TABLE `saletax`
  MODIFY `id` int(100) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `security_groups`
--
ALTER TABLE `security_groups`
  MODIFY `id` int(100) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `security_group_users`
--
ALTER TABLE `security_group_users`
  MODIFY `id` int(100) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `shipment_full_detail`
--
ALTER TABLE `shipment_full_detail`
  MODIFY `id` int(255) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `shipment_full_detail_main`
--
ALTER TABLE `shipment_full_detail_main`
  MODIFY `id` int(255) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `Ship_Trip_rel`
--
ALTER TABLE `Ship_Trip_rel`
  MODIFY `ID` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `states`
--
ALTER TABLE `states`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `states1`
--
ALTER TABLE `states1`
  MODIFY `id` int(100) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `suppliers`
--
ALTER TABLE `suppliers`
  MODIFY `id` int(255) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `tasks`
--
ALTER TABLE `tasks`
  MODIFY `id` int(100) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `tasks_frequency`
--
ALTER TABLE `tasks_frequency`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `task_reference`
--
ALTER TABLE `task_reference`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `task_reference_frequency`
--
ALTER TABLE `task_reference_frequency`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `terminals`
--
ALTER TABLE `terminals`
  MODIFY `id` int(100) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `trailers`
--
ALTER TABLE `trailers`
  MODIFY `id` int(255) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `trailers_assigned_trips`
--
ALTER TABLE `trailers_assigned_trips`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `trailer_meta_extrapaytype`
--
ALTER TABLE `trailer_meta_extrapaytype`
  MODIFY `id` int(250) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `trailer_meta_paytype`
--
ALTER TABLE `trailer_meta_paytype`
  MODIFY `id` int(250) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `trailer_meta_safety_doc`
--
ALTER TABLE `trailer_meta_safety_doc`
  MODIFY `id` int(250) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `transactions`
--
ALTER TABLE `transactions`
  MODIFY `id` int(150) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `trips`
--
ALTER TABLE `trips`
  MODIFY `id` int(100) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `trips_assigned_orders`
--
ALTER TABLE `trips_assigned_orders`
  MODIFY `id` int(100) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `trips_assigned_orders1`
--
ALTER TABLE `trips_assigned_orders1`
  MODIFY `id` int(100) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `trip_agreed_rate_main`
--
ALTER TABLE `trip_agreed_rate_main`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `trip_drivers`
--
ALTER TABLE `trip_drivers`
  MODIFY `id` int(255) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `trip_event_main`
--
ALTER TABLE `trip_event_main`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `trip_main`
--
ALTER TABLE `trip_main`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `trip_master`
--
ALTER TABLE `trip_master`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `trip_meta_ept`
--
ALTER TABLE `trip_meta_ept`
  MODIFY `id` int(100) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `trip_rate`
--
ALTER TABLE `trip_rate`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `trip_stops`
--
ALTER TABLE `trip_stops`
  MODIFY `id` int(100) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `trip_trailer_rel`
--
ALTER TABLE `trip_trailer_rel`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `trip_truck_paytype`
--
ALTER TABLE `trip_truck_paytype`
  MODIFY `id` int(255) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `trip_truck_rel`
--
ALTER TABLE `trip_truck_rel`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `truckplates`
--
ALTER TABLE `truckplates`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `trucks`
--
ALTER TABLE `trucks`
  MODIFY `id` int(255) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `trucks_assigned_trips`
--
ALTER TABLE `trucks_assigned_trips`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `truck_meta_extrapaytype`
--
ALTER TABLE `truck_meta_extrapaytype`
  MODIFY `id` int(250) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `truck_meta_paytype`
--
ALTER TABLE `truck_meta_paytype`
  MODIFY `id` int(250) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `truck_meta_safety_doc`
--
ALTER TABLE `truck_meta_safety_doc`
  MODIFY `id` int(250) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `uploaddocs`
--
ALTER TABLE `uploaddocs`
  MODIFY `id` int(100) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `users`
--
ALTER TABLE `users`
  MODIFY `id` int(100) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `user_activity`
--
ALTER TABLE `user_activity`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `user_attendance`
--
ALTER TABLE `user_attendance`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `videos`
--
ALTER TABLE `videos`
  MODIFY `id` int(100) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `zip`
--
ALTER TABLE `zip`
  MODIFY `id` int(100) NOT NULL AUTO_INCREMENT;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `drivers_deductions_master`
--
ALTER TABLE `drivers_deductions_master`
  ADD CONSTRAINT `Driver_ded_rel` FOREIGN KEY (`driver_id`) REFERENCES `drivers` (`id`);

--
-- Constraints for table `driver_meta_extrapaytype`
--
ALTER TABLE `driver_meta_extrapaytype`
  ADD CONSTRAINT `rel_drivers` FOREIGN KEY (`driver_id`) REFERENCES `drivers` (`id`);

--
-- Constraints for table `filter`
--
ALTER TABLE `filter`
  ADD CONSTRAINT `rel_user` FOREIGN KEY (`id_filter`) REFERENCES `drivers` (`id`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
