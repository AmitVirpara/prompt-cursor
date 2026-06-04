-- Migration support tables for disp_trans_sql.sql
-- These tables let a real application migrate the legacy iwaytransca dispatch
-- database into the normalized Logistics ERP schema without keeping duplicate
-- order/trip/payment/document production tables.

USE logistics_erp;

SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

CREATE TABLE IF NOT EXISTS legacy_migration_batches (
  legacy_migration_batch_id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  company_id BIGINT UNSIGNED NOT NULL,
  source_database VARCHAR(120) NOT NULL DEFAULT 'iwaytransca',
  source_file_name VARCHAR(180) NOT NULL DEFAULT 'disp_trans_sql.sql',
  batch_code VARCHAR(80) NOT NULL,
  started_by_user_id BIGINT UNSIGNED NULL,
  started_at DATETIME NULL,
  finished_at DATETIME NULL,
  status ENUM('DRAFT','RUNNING','COMPLETED','FAILED','PARTIAL','CANCELLED') NOT NULL DEFAULT 'DRAFT',
  notes VARCHAR(500) NULL,
  created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (legacy_migration_batch_id),
  UNIQUE KEY uk_legacy_migration_batches_code (company_id, batch_code),
  KEY idx_legacy_migration_batches_status (company_id, status),
  KEY idx_legacy_migration_batches_user (started_by_user_id),
  CONSTRAINT fk_legacy_migration_batches_company FOREIGN KEY (company_id) REFERENCES companies(company_id),
  CONSTRAINT fk_legacy_migration_batches_user FOREIGN KEY (started_by_user_id) REFERENCES users(user_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS legacy_source_table_inventory (
  legacy_source_table_inventory_id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  legacy_migration_batch_id BIGINT UNSIGNED NOT NULL,
  source_table VARCHAR(120) NOT NULL,
  source_category ENUM('ADMIN','PARTY','ORDER','TRIP','ASSET','FINANCE','FUEL','DOCUMENT','TASK','GEO','INTEGRATION','NOISE','UNKNOWN') NOT NULL DEFAULT 'UNKNOWN',
  row_count BIGINT UNSIGNED NULL,
  target_strategy ENUM('MIGRATE','REFERENCE','ARCHIVE','IGNORE','MANUAL_REVIEW') NOT NULL DEFAULT 'MANUAL_REVIEW',
  target_tables JSON NULL,
  notes VARCHAR(500) NULL,
  status ENUM('PENDING','MAPPED','MIGRATED','SKIPPED','ERROR') NOT NULL DEFAULT 'PENDING',
  created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (legacy_source_table_inventory_id),
  UNIQUE KEY uk_legacy_source_inventory_table (legacy_migration_batch_id, source_table),
  KEY idx_legacy_source_inventory_category (source_category, target_strategy),
  KEY idx_legacy_source_inventory_status (status),
  CONSTRAINT fk_legacy_source_inventory_batch FOREIGN KEY (legacy_migration_batch_id) REFERENCES legacy_migration_batches(legacy_migration_batch_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS legacy_entity_mappings (
  legacy_entity_mapping_id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  legacy_migration_batch_id BIGINT UNSIGNED NOT NULL,
  company_id BIGINT UNSIGNED NOT NULL,
  source_table VARCHAR(120) NOT NULL,
  source_pk VARCHAR(120) NOT NULL,
  source_natural_key VARCHAR(180) NULL,
  target_table VARCHAR(120) NOT NULL,
  target_pk BIGINT UNSIGNED NOT NULL,
  source_hash CHAR(64) NULL,
  migration_status ENUM('MAPPED','INSERTED','UPDATED','SKIPPED','ERROR') NOT NULL DEFAULT 'MAPPED',
  error_message TEXT NULL,
  created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (legacy_entity_mapping_id),
  UNIQUE KEY uk_legacy_entity_source_target (legacy_migration_batch_id, source_table, source_pk, target_table),
  KEY idx_legacy_entity_target (target_table, target_pk),
  KEY idx_legacy_entity_company_status (company_id, migration_status),
  CONSTRAINT fk_legacy_entity_mappings_batch FOREIGN KEY (legacy_migration_batch_id) REFERENCES legacy_migration_batches(legacy_migration_batch_id),
  CONSTRAINT fk_legacy_entity_mappings_company FOREIGN KEY (company_id) REFERENCES companies(company_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS legacy_field_mappings (
  legacy_field_mapping_id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  source_table VARCHAR(120) NOT NULL,
  source_column VARCHAR(120) NOT NULL,
  target_table VARCHAR(120) NOT NULL,
  target_column VARCHAR(120) NOT NULL,
  transform_rule VARCHAR(500) NULL,
  required_flag BOOLEAN NOT NULL DEFAULT FALSE,
  mapping_priority SMALLINT UNSIGNED NOT NULL DEFAULT 100,
  status ENUM('ACTIVE','INACTIVE','REVIEW') NOT NULL DEFAULT 'ACTIVE',
  created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (legacy_field_mapping_id),
  UNIQUE KEY uk_legacy_field_mappings (source_table, source_column, target_table, target_column),
  KEY idx_legacy_field_mappings_target (target_table, target_column),
  KEY idx_legacy_field_mappings_status (status)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS legacy_status_mappings (
  legacy_status_mapping_id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  source_table VARCHAR(120) NOT NULL,
  source_column VARCHAR(120) NOT NULL,
  source_value VARCHAR(120) NOT NULL,
  target_table VARCHAR(120) NOT NULL,
  target_column VARCHAR(120) NOT NULL,
  target_value VARCHAR(120) NOT NULL,
  notes VARCHAR(500) NULL,
  status ENUM('ACTIVE','INACTIVE','REVIEW') NOT NULL DEFAULT 'ACTIVE',
  created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (legacy_status_mapping_id),
  UNIQUE KEY uk_legacy_status_mappings (source_table, source_column, source_value, target_table, target_column),
  KEY idx_legacy_status_mappings_target (target_table, target_column, target_value),
  KEY idx_legacy_status_mappings_status (status)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS legacy_rejected_rows (
  legacy_rejected_row_id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  legacy_migration_batch_id BIGINT UNSIGNED NOT NULL,
  source_table VARCHAR(120) NOT NULL,
  source_pk VARCHAR(120) NULL,
  target_table VARCHAR(120) NULL,
  error_code VARCHAR(80) NOT NULL,
  error_message TEXT NOT NULL,
  source_payload JSON NULL,
  resolution_note VARCHAR(500) NULL,
  status ENUM('OPEN','RESOLVED','IGNORED','RETRY_READY') NOT NULL DEFAULT 'OPEN',
  created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (legacy_rejected_row_id),
  KEY idx_legacy_rejected_rows_batch_status (legacy_migration_batch_id, status),
  KEY idx_legacy_rejected_rows_source (source_table, source_pk),
  KEY idx_legacy_rejected_rows_target (target_table),
  CONSTRAINT fk_legacy_rejected_rows_batch FOREIGN KEY (legacy_migration_batch_id) REFERENCES legacy_migration_batches(legacy_migration_batch_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS legacy_migration_checkpoints (
  legacy_migration_checkpoint_id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  legacy_migration_batch_id BIGINT UNSIGNED NOT NULL,
  step_code VARCHAR(80) NOT NULL,
  step_name VARCHAR(160) NOT NULL,
  source_table VARCHAR(120) NULL,
  last_source_pk VARCHAR(120) NULL,
  processed_rows BIGINT UNSIGNED NOT NULL DEFAULT 0,
  inserted_rows BIGINT UNSIGNED NOT NULL DEFAULT 0,
  updated_rows BIGINT UNSIGNED NOT NULL DEFAULT 0,
  rejected_rows BIGINT UNSIGNED NOT NULL DEFAULT 0,
  status ENUM('PENDING','RUNNING','COMPLETED','FAILED','SKIPPED') NOT NULL DEFAULT 'PENDING',
  started_at DATETIME NULL,
  finished_at DATETIME NULL,
  error_message TEXT NULL,
  created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (legacy_migration_checkpoint_id),
  UNIQUE KEY uk_legacy_migration_checkpoints_step (legacy_migration_batch_id, step_code),
  KEY idx_legacy_migration_checkpoints_status (legacy_migration_batch_id, status),
  KEY idx_legacy_migration_checkpoints_source (source_table, last_source_pk),
  CONSTRAINT fk_legacy_migration_checkpoints_batch FOREIGN KEY (legacy_migration_batch_id) REFERENCES legacy_migration_batches(legacy_migration_batch_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

SET FOREIGN_KEY_CHECKS = 1;
