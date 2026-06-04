-- Step 2 Logistics ERP MySQL 8 extension schema
-- Adds real-world usability, finance, dispatch, maintenance, ELD/HOS,
-- integration, reporting, and collaboration capabilities on top of sample1_date.sql.

USE logistics_erp;

SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

CREATE TABLE IF NOT EXISTS departments (
  department_id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  company_id BIGINT UNSIGNED NOT NULL,
  department_code VARCHAR(40) NOT NULL,
  department_name VARCHAR(120) NOT NULL,
  manager_employee_id BIGINT UNSIGNED NULL,
  cost_center_code VARCHAR(40) NULL,
  status ENUM('ACTIVE','INACTIVE') NOT NULL DEFAULT 'ACTIVE',
  created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (department_id),
  UNIQUE KEY uk_departments_company_code (company_id, department_code),
  KEY idx_departments_manager (manager_employee_id),
  KEY idx_departments_status (company_id, status),
  CONSTRAINT fk_departments_company FOREIGN KEY (company_id) REFERENCES companies(company_id),
  CONSTRAINT fk_departments_manager FOREIGN KEY (manager_employee_id) REFERENCES employees(employee_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS user_preferences (
  user_preference_id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  company_id BIGINT UNSIGNED NOT NULL,
  user_id BIGINT UNSIGNED NOT NULL,
  preference_key VARCHAR(120) NOT NULL,
  preference_value JSON NULL,
  status ENUM('ACTIVE','INACTIVE') NOT NULL DEFAULT 'ACTIVE',
  created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (user_preference_id),
  UNIQUE KEY uk_user_preferences_key (company_id, user_id, preference_key),
  KEY idx_user_preferences_user (user_id),
  KEY idx_user_preferences_status (status),
  CONSTRAINT fk_user_preferences_company FOREIGN KEY (company_id) REFERENCES companies(company_id),
  CONSTRAINT fk_user_preferences_user FOREIGN KEY (user_id) REFERENCES users(user_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS saved_filters (
  saved_filter_id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  company_id BIGINT UNSIGNED NOT NULL,
  user_id BIGINT UNSIGNED NOT NULL,
  module_name VARCHAR(80) NOT NULL,
  filter_name VARCHAR(120) NOT NULL,
  filter_json JSON NOT NULL,
  is_default BOOLEAN NOT NULL DEFAULT FALSE,
  is_shared BOOLEAN NOT NULL DEFAULT FALSE,
  status ENUM('ACTIVE','INACTIVE') NOT NULL DEFAULT 'ACTIVE',
  created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (saved_filter_id),
  UNIQUE KEY uk_saved_filters_user_module_name (company_id, user_id, module_name, filter_name),
  KEY idx_saved_filters_module_shared (company_id, module_name, is_shared),
  KEY idx_saved_filters_status (status),
  CONSTRAINT fk_saved_filters_company FOREIGN KEY (company_id) REFERENCES companies(company_id),
  CONSTRAINT fk_saved_filters_user FOREIGN KEY (user_id) REFERENCES users(user_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS dashboard_widgets (
  dashboard_widget_id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  company_id BIGINT UNSIGNED NOT NULL,
  user_id BIGINT UNSIGNED NULL,
  widget_code VARCHAR(80) NOT NULL,
  widget_title VARCHAR(140) NOT NULL,
  widget_type ENUM('KPI','CHART','LIST','MAP','CALENDAR','ALERT') NOT NULL,
  layout_json JSON NOT NULL,
  config_json JSON NULL,
  display_order INT NOT NULL DEFAULT 0,
  status ENUM('ACTIVE','INACTIVE') NOT NULL DEFAULT 'ACTIVE',
  created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (dashboard_widget_id),
  UNIQUE KEY uk_dashboard_widgets_code (company_id, user_id, widget_code),
  KEY idx_dashboard_widgets_user_order (user_id, display_order),
  KEY idx_dashboard_widgets_status (company_id, status),
  CONSTRAINT fk_dashboard_widgets_company FOREIGN KEY (company_id) REFERENCES companies(company_id),
  CONSTRAINT fk_dashboard_widgets_user FOREIGN KEY (user_id) REFERENCES users(user_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS notifications (
  notification_id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  company_id BIGINT UNSIGNED NOT NULL,
  notification_type ENUM('INFO','WARNING','ERROR','SUCCESS','TASK','APPROVAL','EXPIRY','DISPATCH') NOT NULL,
  title VARCHAR(160) NOT NULL,
  body TEXT NULL,
  entity_type VARCHAR(80) NULL,
  entity_id BIGINT UNSIGNED NULL,
  priority ENUM('LOW','NORMAL','HIGH','URGENT') NOT NULL DEFAULT 'NORMAL',
  status ENUM('ACTIVE','ARCHIVED','EXPIRED') NOT NULL DEFAULT 'ACTIVE',
  created_by_user_id BIGINT UNSIGNED NULL,
  created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  expires_at DATETIME NULL,
  PRIMARY KEY (notification_id),
  KEY idx_notifications_company_status (company_id, status, priority),
  KEY idx_notifications_entity (entity_type, entity_id),
  KEY idx_notifications_created_by (created_by_user_id),
  CONSTRAINT fk_notifications_company FOREIGN KEY (company_id) REFERENCES companies(company_id),
  CONSTRAINT fk_notifications_created_by FOREIGN KEY (created_by_user_id) REFERENCES users(user_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS notification_deliveries (
  notification_delivery_id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  notification_id BIGINT UNSIGNED NOT NULL,
  user_id BIGINT UNSIGNED NOT NULL,
  channel ENUM('IN_APP','EMAIL','SMS','PUSH','WEBHOOK') NOT NULL DEFAULT 'IN_APP',
  delivered_at DATETIME NULL,
  read_at DATETIME NULL,
  status ENUM('PENDING','DELIVERED','READ','FAILED','DISMISSED') NOT NULL DEFAULT 'PENDING',
  error_message TEXT NULL,
  created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (notification_delivery_id),
  UNIQUE KEY uk_notification_deliveries_channel (notification_id, user_id, channel),
  KEY idx_notification_deliveries_user_status (user_id, status),
  KEY idx_notification_deliveries_read (read_at),
  CONSTRAINT fk_notification_deliveries_notification FOREIGN KEY (notification_id) REFERENCES notifications(notification_id),
  CONSTRAINT fk_notification_deliveries_user FOREIGN KEY (user_id) REFERENCES users(user_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS workflow_definitions (
  workflow_definition_id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  company_id BIGINT UNSIGNED NOT NULL,
  workflow_code VARCHAR(80) NOT NULL,
  workflow_name VARCHAR(140) NOT NULL,
  entity_type VARCHAR(80) NOT NULL,
  trigger_event VARCHAR(80) NOT NULL,
  config_json JSON NULL,
  status ENUM('DRAFT','ACTIVE','INACTIVE') NOT NULL DEFAULT 'DRAFT',
  created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (workflow_definition_id),
  UNIQUE KEY uk_workflow_definitions_company_code (company_id, workflow_code),
  KEY idx_workflow_definitions_entity_event (company_id, entity_type, trigger_event),
  KEY idx_workflow_definitions_status (status),
  CONSTRAINT fk_workflow_definitions_company FOREIGN KEY (company_id) REFERENCES companies(company_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS workflow_steps (
  workflow_step_id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  workflow_definition_id BIGINT UNSIGNED NOT NULL,
  step_order SMALLINT UNSIGNED NOT NULL,
  step_name VARCHAR(120) NOT NULL,
  approver_role_id BIGINT UNSIGNED NULL,
  approver_user_id BIGINT UNSIGNED NULL,
  action_type ENUM('APPROVE','REVIEW','NOTIFY','AUTO_STATUS','WEBHOOK') NOT NULL DEFAULT 'APPROVE',
  required_flag BOOLEAN NOT NULL DEFAULT TRUE,
  status ENUM('ACTIVE','INACTIVE') NOT NULL DEFAULT 'ACTIVE',
  created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (workflow_step_id),
  UNIQUE KEY uk_workflow_steps_order (workflow_definition_id, step_order),
  KEY idx_workflow_steps_role (approver_role_id),
  KEY idx_workflow_steps_user (approver_user_id),
  CONSTRAINT fk_workflow_steps_definition FOREIGN KEY (workflow_definition_id) REFERENCES workflow_definitions(workflow_definition_id),
  CONSTRAINT fk_workflow_steps_role FOREIGN KEY (approver_role_id) REFERENCES roles(role_id),
  CONSTRAINT fk_workflow_steps_user FOREIGN KEY (approver_user_id) REFERENCES users(user_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS approval_requests (
  approval_request_id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  company_id BIGINT UNSIGNED NOT NULL,
  workflow_definition_id BIGINT UNSIGNED NULL,
  entity_type VARCHAR(80) NOT NULL,
  entity_id BIGINT UNSIGNED NOT NULL,
  requested_by_user_id BIGINT UNSIGNED NOT NULL,
  current_step_order SMALLINT UNSIGNED NOT NULL DEFAULT 1,
  requested_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  completed_at DATETIME NULL,
  status ENUM('PENDING','APPROVED','REJECTED','CANCELLED','NEEDS_INFO') NOT NULL DEFAULT 'PENDING',
  reason VARCHAR(500) NULL,
  created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (approval_request_id),
  KEY idx_approval_requests_entity (entity_type, entity_id),
  KEY idx_approval_requests_company_status (company_id, status),
  KEY idx_approval_requests_requested_by (requested_by_user_id),
  KEY idx_approval_requests_workflow (workflow_definition_id),
  CONSTRAINT fk_approval_requests_company FOREIGN KEY (company_id) REFERENCES companies(company_id),
  CONSTRAINT fk_approval_requests_workflow FOREIGN KEY (workflow_definition_id) REFERENCES workflow_definitions(workflow_definition_id),
  CONSTRAINT fk_approval_requests_requested_by FOREIGN KEY (requested_by_user_id) REFERENCES users(user_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS approval_actions (
  approval_action_id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  approval_request_id BIGINT UNSIGNED NOT NULL,
  workflow_step_id BIGINT UNSIGNED NULL,
  action_by_user_id BIGINT UNSIGNED NOT NULL,
  action_name ENUM('SUBMIT','APPROVE','REJECT','REQUEST_INFO','CANCEL','COMMENT') NOT NULL,
  action_note VARCHAR(500) NULL,
  action_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  status ENUM('ACTIVE','VOID') NOT NULL DEFAULT 'ACTIVE',
  created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (approval_action_id),
  KEY idx_approval_actions_request_time (approval_request_id, action_at),
  KEY idx_approval_actions_step (workflow_step_id),
  KEY idx_approval_actions_user (action_by_user_id),
  CONSTRAINT fk_approval_actions_request FOREIGN KEY (approval_request_id) REFERENCES approval_requests(approval_request_id),
  CONSTRAINT fk_approval_actions_step FOREIGN KEY (workflow_step_id) REFERENCES workflow_steps(workflow_step_id),
  CONSTRAINT fk_approval_actions_user FOREIGN KEY (action_by_user_id) REFERENCES users(user_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS entity_comments (
  entity_comment_id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  company_id BIGINT UNSIGNED NOT NULL,
  entity_type VARCHAR(80) NOT NULL,
  entity_id BIGINT UNSIGNED NOT NULL,
  parent_comment_id BIGINT UNSIGNED NULL,
  comment_text TEXT NOT NULL,
  visibility ENUM('INTERNAL','CUSTOMER','CARRIER','PUBLIC') NOT NULL DEFAULT 'INTERNAL',
  created_by_user_id BIGINT UNSIGNED NOT NULL,
  status ENUM('ACTIVE','DELETED') NOT NULL DEFAULT 'ACTIVE',
  created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (entity_comment_id),
  KEY idx_entity_comments_entity (company_id, entity_type, entity_id),
  KEY idx_entity_comments_parent (parent_comment_id),
  KEY idx_entity_comments_user (created_by_user_id),
  CONSTRAINT fk_entity_comments_company FOREIGN KEY (company_id) REFERENCES companies(company_id),
  CONSTRAINT fk_entity_comments_parent FOREIGN KEY (parent_comment_id) REFERENCES entity_comments(entity_comment_id),
  CONSTRAINT fk_entity_comments_user FOREIGN KEY (created_by_user_id) REFERENCES users(user_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS task_boards (
  task_board_id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  company_id BIGINT UNSIGNED NOT NULL,
  board_code VARCHAR(60) NOT NULL,
  board_name VARCHAR(140) NOT NULL,
  module_name VARCHAR(80) NOT NULL,
  status ENUM('ACTIVE','INACTIVE') NOT NULL DEFAULT 'ACTIVE',
  created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (task_board_id),
  UNIQUE KEY uk_task_boards_company_code (company_id, board_code),
  KEY idx_task_boards_module (company_id, module_name),
  CONSTRAINT fk_task_boards_company FOREIGN KEY (company_id) REFERENCES companies(company_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS tasks (
  task_id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  company_id BIGINT UNSIGNED NOT NULL,
  task_board_id BIGINT UNSIGNED NULL,
  entity_type VARCHAR(80) NULL,
  entity_id BIGINT UNSIGNED NULL,
  task_title VARCHAR(180) NOT NULL,
  task_description TEXT NULL,
  assigned_to_user_id BIGINT UNSIGNED NULL,
  due_at DATETIME NULL,
  priority ENUM('LOW','NORMAL','HIGH','URGENT') NOT NULL DEFAULT 'NORMAL',
  status ENUM('OPEN','IN_PROGRESS','BLOCKED','DONE','CANCELLED') NOT NULL DEFAULT 'OPEN',
  created_by_user_id BIGINT UNSIGNED NOT NULL,
  created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (task_id),
  KEY idx_tasks_company_status (company_id, status, priority),
  KEY idx_tasks_assigned_due (assigned_to_user_id, due_at),
  KEY idx_tasks_entity (entity_type, entity_id),
  KEY idx_tasks_board (task_board_id),
  CONSTRAINT fk_tasks_company FOREIGN KEY (company_id) REFERENCES companies(company_id),
  CONSTRAINT fk_tasks_board FOREIGN KEY (task_board_id) REFERENCES task_boards(task_board_id),
  CONSTRAINT fk_tasks_assigned_to FOREIGN KEY (assigned_to_user_id) REFERENCES users(user_id),
  CONSTRAINT fk_tasks_created_by FOREIGN KEY (created_by_user_id) REFERENCES users(user_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS tags (
  tag_id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  company_id BIGINT UNSIGNED NOT NULL,
  tag_name VARCHAR(80) NOT NULL,
  color_hex CHAR(7) NULL,
  status ENUM('ACTIVE','INACTIVE') NOT NULL DEFAULT 'ACTIVE',
  created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (tag_id),
  UNIQUE KEY uk_tags_company_name (company_id, tag_name),
  KEY idx_tags_status (company_id, status),
  CONSTRAINT fk_tags_company FOREIGN KEY (company_id) REFERENCES companies(company_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS entity_tags (
  entity_tag_id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  company_id BIGINT UNSIGNED NOT NULL,
  tag_id BIGINT UNSIGNED NOT NULL,
  entity_type VARCHAR(80) NOT NULL,
  entity_id BIGINT UNSIGNED NOT NULL,
  created_by_user_id BIGINT UNSIGNED NULL,
  created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (entity_tag_id),
  UNIQUE KEY uk_entity_tags (tag_id, entity_type, entity_id),
  KEY idx_entity_tags_entity (company_id, entity_type, entity_id),
  KEY idx_entity_tags_user (created_by_user_id),
  CONSTRAINT fk_entity_tags_company FOREIGN KEY (company_id) REFERENCES companies(company_id),
  CONSTRAINT fk_entity_tags_tag FOREIGN KEY (tag_id) REFERENCES tags(tag_id),
  CONSTRAINT fk_entity_tags_user FOREIGN KEY (created_by_user_id) REFERENCES users(user_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS tax_codes (
  tax_code_id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  company_id BIGINT UNSIGNED NOT NULL,
  tax_code VARCHAR(40) NOT NULL,
  tax_name VARCHAR(120) NOT NULL,
  tax_rate DECIMAL(8,5) NOT NULL DEFAULT 0.00000,
  country_code CHAR(2) NOT NULL,
  state_region VARCHAR(80) NULL,
  status ENUM('ACTIVE','INACTIVE') NOT NULL DEFAULT 'ACTIVE',
  created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (tax_code_id),
  UNIQUE KEY uk_tax_codes_company_code (company_id, tax_code),
  KEY idx_tax_codes_geo (country_code, state_region),
  KEY idx_tax_codes_status (company_id, status),
  CONSTRAINT fk_tax_codes_company FOREIGN KEY (company_id) REFERENCES companies(company_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS bank_accounts (
  bank_account_id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  company_id BIGINT UNSIGNED NOT NULL,
  account_name VARCHAR(140) NOT NULL,
  bank_name VARCHAR(140) NOT NULL,
  account_number_masked VARCHAR(60) NOT NULL,
  routing_number_masked VARCHAR(60) NULL,
  currency_id BIGINT UNSIGNED NOT NULL,
  gl_account_id BIGINT UNSIGNED NULL,
  status ENUM('ACTIVE','INACTIVE','CLOSED') NOT NULL DEFAULT 'ACTIVE',
  created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (bank_account_id),
  UNIQUE KEY uk_bank_accounts_company_masked (company_id, account_number_masked),
  KEY idx_bank_accounts_currency (currency_id),
  KEY idx_bank_accounts_gl (gl_account_id),
  KEY idx_bank_accounts_status (company_id, status),
  CONSTRAINT fk_bank_accounts_company FOREIGN KEY (company_id) REFERENCES companies(company_id),
  CONSTRAINT fk_bank_accounts_currency FOREIGN KEY (currency_id) REFERENCES currencies(currency_id),
  CONSTRAINT fk_bank_accounts_gl FOREIGN KEY (gl_account_id) REFERENCES chart_of_accounts(account_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS payments (
  payment_id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  company_id BIGINT UNSIGNED NOT NULL,
  payment_number VARCHAR(50) NOT NULL,
  payment_type ENUM('CUSTOMER_RECEIPT','VENDOR_PAYMENT','DRIVER_PAYMENT','EMPLOYEE_PAYMENT','REFUND') NOT NULL,
  party_id BIGINT UNSIGNED NULL,
  bank_account_id BIGINT UNSIGNED NULL,
  payment_date DATE NOT NULL,
  currency_id BIGINT UNSIGNED NOT NULL,
  amount DECIMAL(14,2) NOT NULL,
  reference_number VARCHAR(100) NULL,
  status ENUM('DRAFT','POSTED','VOID','FAILED','RECONCILED') NOT NULL DEFAULT 'DRAFT',
  created_by_user_id BIGINT UNSIGNED NULL,
  created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (payment_id),
  UNIQUE KEY uk_payments_company_number (company_id, payment_number),
  KEY idx_payments_party_date (party_id, payment_date),
  KEY idx_payments_bank (bank_account_id),
  KEY idx_payments_status (company_id, status),
  CONSTRAINT fk_payments_company FOREIGN KEY (company_id) REFERENCES companies(company_id),
  CONSTRAINT fk_payments_party FOREIGN KEY (party_id) REFERENCES parties(party_id),
  CONSTRAINT fk_payments_bank FOREIGN KEY (bank_account_id) REFERENCES bank_accounts(bank_account_id),
  CONSTRAINT fk_payments_currency FOREIGN KEY (currency_id) REFERENCES currencies(currency_id),
  CONSTRAINT fk_payments_created_by FOREIGN KEY (created_by_user_id) REFERENCES users(user_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS payment_allocations (
  payment_allocation_id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  payment_id BIGINT UNSIGNED NOT NULL,
  target_type ENUM('INVOICE','BILL','SETTLEMENT','PAYROLL','ADJUSTMENT') NOT NULL,
  target_id BIGINT UNSIGNED NOT NULL,
  allocated_amount DECIMAL(14,2) NOT NULL,
  status ENUM('ACTIVE','VOID') NOT NULL DEFAULT 'ACTIVE',
  created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (payment_allocation_id),
  UNIQUE KEY uk_payment_allocations_target (payment_id, target_type, target_id),
  KEY idx_payment_allocations_target_lookup (target_type, target_id),
  CONSTRAINT fk_payment_allocations_payment FOREIGN KEY (payment_id) REFERENCES payments(payment_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS quote_requests (
  quote_request_id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  company_id BIGINT UNSIGNED NOT NULL,
  quote_request_number VARCHAR(50) NOT NULL,
  customer_party_id BIGINT UNSIGNED NOT NULL,
  origin_address_id BIGINT UNSIGNED NULL,
  destination_address_id BIGINT UNSIGNED NULL,
  freight_type ENUM('FTL','LTL','PARTIAL','INTERMODAL') NOT NULL DEFAULT 'FTL',
  requested_pickup_at DATETIME NULL,
  total_weight_lbs DECIMAL(12,2) NOT NULL DEFAULT 0.00,
  status ENUM('DRAFT','REQUESTED','QUOTED','WON','LOST','EXPIRED','CANCELLED') NOT NULL DEFAULT 'DRAFT',
  created_by_user_id BIGINT UNSIGNED NULL,
  created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (quote_request_id),
  UNIQUE KEY uk_quote_requests_company_number (company_id, quote_request_number),
  KEY idx_quote_requests_customer_status (customer_party_id, status),
  KEY idx_quote_requests_addresses (origin_address_id, destination_address_id),
  CONSTRAINT fk_quote_requests_company FOREIGN KEY (company_id) REFERENCES companies(company_id),
  CONSTRAINT fk_quote_requests_customer FOREIGN KEY (customer_party_id) REFERENCES parties(party_id),
  CONSTRAINT fk_quote_requests_origin FOREIGN KEY (origin_address_id) REFERENCES predefined_addresses(predefined_address_id),
  CONSTRAINT fk_quote_requests_destination FOREIGN KEY (destination_address_id) REFERENCES predefined_addresses(predefined_address_id),
  CONSTRAINT fk_quote_requests_created_by FOREIGN KEY (created_by_user_id) REFERENCES users(user_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS quotes (
  quote_id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  company_id BIGINT UNSIGNED NOT NULL,
  quote_request_id BIGINT UNSIGNED NULL,
  quote_number VARCHAR(50) NOT NULL,
  customer_party_id BIGINT UNSIGNED NOT NULL,
  currency_id BIGINT UNSIGNED NOT NULL,
  valid_until DATE NULL,
  subtotal_amount DECIMAL(14,2) NOT NULL DEFAULT 0.00,
  tax_amount DECIMAL(14,2) NOT NULL DEFAULT 0.00,
  total_amount DECIMAL(14,2) NOT NULL DEFAULT 0.00,
  status ENUM('DRAFT','SENT','ACCEPTED','REJECTED','EXPIRED','CANCELLED','CONVERTED') NOT NULL DEFAULT 'DRAFT',
  created_by_user_id BIGINT UNSIGNED NULL,
  created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (quote_id),
  UNIQUE KEY uk_quotes_company_number (company_id, quote_number),
  KEY idx_quotes_request (quote_request_id),
  KEY idx_quotes_customer_status (customer_party_id, status),
  CONSTRAINT fk_quotes_company FOREIGN KEY (company_id) REFERENCES companies(company_id),
  CONSTRAINT fk_quotes_request FOREIGN KEY (quote_request_id) REFERENCES quote_requests(quote_request_id),
  CONSTRAINT fk_quotes_customer FOREIGN KEY (customer_party_id) REFERENCES parties(party_id),
  CONSTRAINT fk_quotes_currency FOREIGN KEY (currency_id) REFERENCES currencies(currency_id),
  CONSTRAINT fk_quotes_created_by FOREIGN KEY (created_by_user_id) REFERENCES users(user_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS quote_lines (
  quote_line_id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  quote_id BIGINT UNSIGNED NOT NULL,
  charge_code VARCHAR(60) NOT NULL,
  description VARCHAR(180) NOT NULL,
  quantity DECIMAL(12,3) NOT NULL DEFAULT 1.000,
  unit_rate DECIMAL(14,4) NOT NULL DEFAULT 0.0000,
  line_amount DECIMAL(14,2) NOT NULL DEFAULT 0.00,
  status ENUM('ACTIVE','VOID') NOT NULL DEFAULT 'ACTIVE',
  created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (quote_line_id),
  KEY idx_quote_lines_quote (quote_id),
  KEY idx_quote_lines_charge (charge_code),
  CONSTRAINT fk_quote_lines_quote FOREIGN KEY (quote_id) REFERENCES quotes(quote_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS customer_contracts (
  customer_contract_id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  company_id BIGINT UNSIGNED NOT NULL,
  customer_party_id BIGINT UNSIGNED NOT NULL,
  contract_number VARCHAR(50) NOT NULL,
  contract_name VARCHAR(160) NOT NULL,
  effective_from DATE NOT NULL,
  effective_to DATE NULL,
  currency_id BIGINT UNSIGNED NOT NULL,
  status ENUM('DRAFT','ACTIVE','EXPIRED','TERMINATED') NOT NULL DEFAULT 'DRAFT',
  created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (customer_contract_id),
  UNIQUE KEY uk_customer_contracts_company_number (company_id, contract_number),
  KEY idx_customer_contracts_customer_dates (customer_party_id, effective_from, effective_to),
  KEY idx_customer_contracts_status (company_id, status),
  CONSTRAINT fk_customer_contracts_company FOREIGN KEY (company_id) REFERENCES companies(company_id),
  CONSTRAINT fk_customer_contracts_customer FOREIGN KEY (customer_party_id) REFERENCES parties(party_id),
  CONSTRAINT fk_customer_contracts_currency FOREIGN KEY (currency_id) REFERENCES currencies(currency_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS contract_lanes (
  contract_lane_id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  customer_contract_id BIGINT UNSIGNED NOT NULL,
  address_lane_id BIGINT UNSIGNED NULL,
  origin_zone VARCHAR(100) NULL,
  destination_zone VARCHAR(100) NULL,
  freight_type ENUM('FTL','LTL','PARTIAL','INTERMODAL') NOT NULL DEFAULT 'FTL',
  rate_type ENUM('FLAT','MILE','WEIGHT','PALLET','CWT') NOT NULL DEFAULT 'FLAT',
  base_rate DECIMAL(14,4) NOT NULL DEFAULT 0.0000,
  fuel_surcharge_percent DECIMAL(8,4) NOT NULL DEFAULT 0.0000,
  status ENUM('ACTIVE','INACTIVE') NOT NULL DEFAULT 'ACTIVE',
  created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (contract_lane_id),
  KEY idx_contract_lanes_contract (customer_contract_id),
  KEY idx_contract_lanes_address_lane (address_lane_id),
  KEY idx_contract_lanes_zones (origin_zone, destination_zone),
  CONSTRAINT fk_contract_lanes_contract FOREIGN KEY (customer_contract_id) REFERENCES customer_contracts(customer_contract_id),
  CONSTRAINT fk_contract_lanes_address_lane FOREIGN KEY (address_lane_id) REFERENCES address_lanes(address_lane_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS carrier_rate_agreements (
  carrier_rate_agreement_id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  company_id BIGINT UNSIGNED NOT NULL,
  carrier_party_id BIGINT UNSIGNED NOT NULL,
  agreement_number VARCHAR(50) NOT NULL,
  effective_from DATE NOT NULL,
  effective_to DATE NULL,
  currency_id BIGINT UNSIGNED NOT NULL,
  status ENUM('DRAFT','ACTIVE','EXPIRED','TERMINATED') NOT NULL DEFAULT 'DRAFT',
  created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (carrier_rate_agreement_id),
  UNIQUE KEY uk_carrier_rate_agreements_company_number (company_id, agreement_number),
  KEY idx_carrier_rate_agreements_carrier_dates (carrier_party_id, effective_from, effective_to),
  KEY idx_carrier_rate_agreements_status (company_id, status),
  CONSTRAINT fk_carrier_rate_agreements_company FOREIGN KEY (company_id) REFERENCES companies(company_id),
  CONSTRAINT fk_carrier_rate_agreements_carrier FOREIGN KEY (carrier_party_id) REFERENCES parties(party_id),
  CONSTRAINT fk_carrier_rate_agreements_currency FOREIGN KEY (currency_id) REFERENCES currencies(currency_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS carrier_rate_lanes (
  carrier_rate_lane_id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  carrier_rate_agreement_id BIGINT UNSIGNED NOT NULL,
  address_lane_id BIGINT UNSIGNED NULL,
  equipment_type ENUM('VAN','REEFER','FLATBED','CONTAINER','CHASSIS','OTHER') NOT NULL DEFAULT 'VAN',
  rate_type ENUM('FLAT','MILE','WEIGHT','PALLET','CWT') NOT NULL DEFAULT 'FLAT',
  base_rate DECIMAL(14,4) NOT NULL DEFAULT 0.0000,
  minimum_amount DECIMAL(14,2) NOT NULL DEFAULT 0.00,
  status ENUM('ACTIVE','INACTIVE') NOT NULL DEFAULT 'ACTIVE',
  created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (carrier_rate_lane_id),
  KEY idx_carrier_rate_lanes_agreement (carrier_rate_agreement_id),
  KEY idx_carrier_rate_lanes_address_lane (address_lane_id),
  KEY idx_carrier_rate_lanes_equipment (equipment_type),
  CONSTRAINT fk_carrier_rate_lanes_agreement FOREIGN KEY (carrier_rate_agreement_id) REFERENCES carrier_rate_agreements(carrier_rate_agreement_id),
  CONSTRAINT fk_carrier_rate_lanes_address_lane FOREIGN KEY (address_lane_id) REFERENCES address_lanes(address_lane_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS load_tenders (
  load_tender_id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  company_id BIGINT UNSIGNED NOT NULL,
  trip_id BIGINT UNSIGNED NULL,
  order_id BIGINT UNSIGNED NULL,
  carrier_party_id BIGINT UNSIGNED NOT NULL,
  tender_number VARCHAR(50) NOT NULL,
  tender_amount DECIMAL(14,2) NOT NULL DEFAULT 0.00,
  currency_id BIGINT UNSIGNED NOT NULL,
  expires_at DATETIME NULL,
  status ENUM('DRAFT','SENT','ACCEPTED','REJECTED','EXPIRED','CANCELLED') NOT NULL DEFAULT 'DRAFT',
  created_by_user_id BIGINT UNSIGNED NULL,
  created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (load_tender_id),
  UNIQUE KEY uk_load_tenders_company_number (company_id, tender_number),
  KEY idx_load_tenders_carrier_status (carrier_party_id, status),
  KEY idx_load_tenders_trip (trip_id),
  KEY idx_load_tenders_order (order_id),
  CONSTRAINT fk_load_tenders_company FOREIGN KEY (company_id) REFERENCES companies(company_id),
  CONSTRAINT fk_load_tenders_trip FOREIGN KEY (trip_id) REFERENCES trips(trip_id),
  CONSTRAINT fk_load_tenders_order FOREIGN KEY (order_id) REFERENCES orders(order_id),
  CONSTRAINT fk_load_tenders_carrier FOREIGN KEY (carrier_party_id) REFERENCES parties(party_id),
  CONSTRAINT fk_load_tenders_currency FOREIGN KEY (currency_id) REFERENCES currencies(currency_id),
  CONSTRAINT fk_load_tenders_created_by FOREIGN KEY (created_by_user_id) REFERENCES users(user_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS tender_responses (
  tender_response_id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  load_tender_id BIGINT UNSIGNED NOT NULL,
  response_by_contact VARCHAR(120) NULL,
  response_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  response_status ENUM('ACCEPTED','REJECTED','COUNTERED','EXPIRED') NOT NULL,
  counter_amount DECIMAL(14,2) NULL,
  notes VARCHAR(500) NULL,
  created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (tender_response_id),
  KEY idx_tender_responses_tender_time (load_tender_id, response_at),
  KEY idx_tender_responses_status (response_status),
  CONSTRAINT fk_tender_responses_tender FOREIGN KEY (load_tender_id) REFERENCES load_tenders(load_tender_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS dock_appointments (
  dock_appointment_id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  company_id BIGINT UNSIGNED NOT NULL,
  terminal_id BIGINT UNSIGNED NOT NULL,
  warehouse_id BIGINT UNSIGNED NULL,
  order_id BIGINT UNSIGNED NULL,
  trip_id BIGINT UNSIGNED NULL,
  appointment_number VARCHAR(50) NOT NULL,
  dock_door VARCHAR(40) NULL,
  appointment_type ENUM('PICKUP','DELIVERY','CROSS_DOCK','PTI','MAINTENANCE') NOT NULL,
  scheduled_start_at DATETIME NOT NULL,
  scheduled_end_at DATETIME NOT NULL,
  actual_start_at DATETIME NULL,
  actual_end_at DATETIME NULL,
  status ENUM('SCHEDULED','CHECKED_IN','IN_PROGRESS','COMPLETED','NO_SHOW','CANCELLED') NOT NULL DEFAULT 'SCHEDULED',
  created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (dock_appointment_id),
  UNIQUE KEY uk_dock_appointments_company_number (company_id, appointment_number),
  KEY idx_dock_appointments_terminal_time (terminal_id, scheduled_start_at),
  KEY idx_dock_appointments_order (order_id),
  KEY idx_dock_appointments_trip (trip_id),
  KEY idx_dock_appointments_status (company_id, status),
  CONSTRAINT fk_dock_appointments_company FOREIGN KEY (company_id) REFERENCES companies(company_id),
  CONSTRAINT fk_dock_appointments_terminal FOREIGN KEY (terminal_id) REFERENCES terminals(terminal_id),
  CONSTRAINT fk_dock_appointments_warehouse FOREIGN KEY (warehouse_id) REFERENCES warehouses(warehouse_id),
  CONSTRAINT fk_dock_appointments_order FOREIGN KEY (order_id) REFERENCES orders(order_id),
  CONSTRAINT fk_dock_appointments_trip FOREIGN KEY (trip_id) REFERENCES trips(trip_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS yard_spots (
  yard_spot_id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  company_id BIGINT UNSIGNED NOT NULL,
  terminal_id BIGINT UNSIGNED NOT NULL,
  spot_code VARCHAR(40) NOT NULL,
  spot_type ENUM('PARKING','DOCK','STAGING','MAINTENANCE','WASH','OTHER') NOT NULL DEFAULT 'PARKING',
  current_equipment_type ENUM('TRUCK','TRAILER','CONTAINER','CHASSIS') NULL,
  current_equipment_id BIGINT UNSIGNED NULL,
  status ENUM('AVAILABLE','OCCUPIED','BLOCKED','MAINTENANCE','INACTIVE') NOT NULL DEFAULT 'AVAILABLE',
  created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (yard_spot_id),
  UNIQUE KEY uk_yard_spots_terminal_code (terminal_id, spot_code),
  KEY idx_yard_spots_company_status (company_id, status),
  KEY idx_yard_spots_equipment (current_equipment_type, current_equipment_id),
  CONSTRAINT fk_yard_spots_company FOREIGN KEY (company_id) REFERENCES companies(company_id),
  CONSTRAINT fk_yard_spots_terminal FOREIGN KEY (terminal_id) REFERENCES terminals(terminal_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS yard_moves (
  yard_move_id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  company_id BIGINT UNSIGNED NOT NULL,
  terminal_id BIGINT UNSIGNED NOT NULL,
  from_yard_spot_id BIGINT UNSIGNED NULL,
  to_yard_spot_id BIGINT UNSIGNED NULL,
  trip_id BIGINT UNSIGNED NULL,
  equipment_type ENUM('TRUCK','TRAILER','CONTAINER','CHASSIS') NOT NULL,
  equipment_id BIGINT UNSIGNED NOT NULL,
  moved_by_user_id BIGINT UNSIGNED NULL,
  moved_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  status ENUM('PLANNED','COMPLETED','CANCELLED') NOT NULL DEFAULT 'COMPLETED',
  notes VARCHAR(500) NULL,
  created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (yard_move_id),
  KEY idx_yard_moves_terminal_time (terminal_id, moved_at),
  KEY idx_yard_moves_equipment (equipment_type, equipment_id),
  KEY idx_yard_moves_trip (trip_id),
  KEY idx_yard_moves_from_to (from_yard_spot_id, to_yard_spot_id),
  CONSTRAINT fk_yard_moves_company FOREIGN KEY (company_id) REFERENCES companies(company_id),
  CONSTRAINT fk_yard_moves_terminal FOREIGN KEY (terminal_id) REFERENCES terminals(terminal_id),
  CONSTRAINT fk_yard_moves_from FOREIGN KEY (from_yard_spot_id) REFERENCES yard_spots(yard_spot_id),
  CONSTRAINT fk_yard_moves_to FOREIGN KEY (to_yard_spot_id) REFERENCES yard_spots(yard_spot_id),
  CONSTRAINT fk_yard_moves_trip FOREIGN KEY (trip_id) REFERENCES trips(trip_id),
  CONSTRAINT fk_yard_moves_user FOREIGN KEY (moved_by_user_id) REFERENCES users(user_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS maintenance_work_orders (
  maintenance_work_order_id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  company_id BIGINT UNSIGNED NOT NULL,
  work_order_number VARCHAR(50) NOT NULL,
  equipment_type ENUM('TRUCK','TRAILER','CONTAINER','CHASSIS') NOT NULL,
  equipment_id BIGINT UNSIGNED NOT NULL,
  vendor_party_id BIGINT UNSIGNED NULL,
  opened_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  closed_at DATETIME NULL,
  odometer_miles DECIMAL(12,2) NULL,
  priority ENUM('LOW','NORMAL','HIGH','URGENT') NOT NULL DEFAULT 'NORMAL',
  status ENUM('OPEN','APPROVED','IN_PROGRESS','COMPLETED','CANCELLED') NOT NULL DEFAULT 'OPEN',
  created_by_user_id BIGINT UNSIGNED NULL,
  created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (maintenance_work_order_id),
  UNIQUE KEY uk_maintenance_work_orders_company_number (company_id, work_order_number),
  KEY idx_maintenance_work_orders_equipment (equipment_type, equipment_id),
  KEY idx_maintenance_work_orders_vendor (vendor_party_id),
  KEY idx_maintenance_work_orders_status (company_id, status, priority),
  CONSTRAINT fk_maintenance_work_orders_company FOREIGN KEY (company_id) REFERENCES companies(company_id),
  CONSTRAINT fk_maintenance_work_orders_vendor FOREIGN KEY (vendor_party_id) REFERENCES parties(party_id),
  CONSTRAINT fk_maintenance_work_orders_created_by FOREIGN KEY (created_by_user_id) REFERENCES users(user_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS maintenance_work_order_lines (
  maintenance_work_order_line_id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  maintenance_work_order_id BIGINT UNSIGNED NOT NULL,
  line_type ENUM('LABOR','PART','SERVICE','FEE','TAX') NOT NULL,
  description VARCHAR(180) NOT NULL,
  inventory_item_id BIGINT UNSIGNED NULL,
  quantity DECIMAL(12,3) NOT NULL DEFAULT 1.000,
  unit_cost DECIMAL(14,4) NOT NULL DEFAULT 0.0000,
  line_amount DECIMAL(14,2) NOT NULL DEFAULT 0.00,
  status ENUM('ACTIVE','VOID') NOT NULL DEFAULT 'ACTIVE',
  created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (maintenance_work_order_line_id),
  KEY idx_maintenance_lines_work_order (maintenance_work_order_id),
  KEY idx_maintenance_lines_inventory_item (inventory_item_id),
  CONSTRAINT fk_maintenance_lines_work_order FOREIGN KEY (maintenance_work_order_id) REFERENCES maintenance_work_orders(maintenance_work_order_id),
  CONSTRAINT fk_maintenance_lines_inventory_item FOREIGN KEY (inventory_item_id) REFERENCES inventory_items(inventory_item_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS service_schedules (
  service_schedule_id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  company_id BIGINT UNSIGNED NOT NULL,
  equipment_type ENUM('TRUCK','TRAILER','CONTAINER','CHASSIS') NOT NULL,
  equipment_id BIGINT UNSIGNED NOT NULL,
  service_type VARCHAR(100) NOT NULL,
  interval_days INT UNSIGNED NULL,
  interval_miles DECIMAL(12,2) NULL,
  last_service_date DATE NULL,
  last_service_miles DECIMAL(12,2) NULL,
  next_due_date DATE NULL,
  next_due_miles DECIMAL(12,2) NULL,
  status ENUM('ACTIVE','DUE','OVERDUE','INACTIVE') NOT NULL DEFAULT 'ACTIVE',
  created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (service_schedule_id),
  KEY idx_service_schedules_equipment (equipment_type, equipment_id),
  KEY idx_service_schedules_due (company_id, status, next_due_date, next_due_miles),
  CONSTRAINT fk_service_schedules_company FOREIGN KEY (company_id) REFERENCES companies(company_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS insurance_policies (
  insurance_policy_id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  company_id BIGINT UNSIGNED NOT NULL,
  policy_number VARCHAR(80) NOT NULL,
  insurer_name VARCHAR(140) NOT NULL,
  policy_type ENUM('AUTO_LIABILITY','CARGO','GENERAL_LIABILITY','WORKERS_COMP','PROPERTY','OTHER') NOT NULL,
  insured_entity_type ENUM('COMPANY','TRUCK','TRAILER','CONTAINER','CHASSIS','DRIVER','ORDER') NOT NULL DEFAULT 'COMPANY',
  insured_entity_id BIGINT UNSIGNED NULL,
  coverage_amount DECIMAL(16,2) NOT NULL DEFAULT 0.00,
  currency_id BIGINT UNSIGNED NOT NULL,
  effective_from DATE NOT NULL,
  effective_to DATE NOT NULL,
  status ENUM('ACTIVE','EXPIRING','EXPIRED','CANCELLED') NOT NULL DEFAULT 'ACTIVE',
  created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (insurance_policy_id),
  UNIQUE KEY uk_insurance_policies_company_number (company_id, policy_number),
  KEY idx_insurance_policies_entity (insured_entity_type, insured_entity_id),
  KEY idx_insurance_policies_expiry (company_id, status, effective_to),
  CONSTRAINT fk_insurance_policies_company FOREIGN KEY (company_id) REFERENCES companies(company_id),
  CONSTRAINT fk_insurance_policies_currency FOREIGN KEY (currency_id) REFERENCES currencies(currency_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS accident_incidents (
  accident_incident_id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  company_id BIGINT UNSIGNED NOT NULL,
  incident_number VARCHAR(50) NOT NULL,
  trip_id BIGINT UNSIGNED NULL,
  order_id BIGINT UNSIGNED NULL,
  driver_id BIGINT UNSIGNED NULL,
  equipment_type ENUM('TRUCK','TRAILER','CONTAINER','CHASSIS') NULL,
  equipment_id BIGINT UNSIGNED NULL,
  incident_at DATETIME NOT NULL,
  location_text VARCHAR(255) NULL,
  severity ENUM('LOW','MEDIUM','HIGH','CRITICAL') NOT NULL DEFAULT 'LOW',
  description TEXT NULL,
  claim_id BIGINT UNSIGNED NULL,
  status ENUM('OPEN','INVESTIGATING','CLAIM_CREATED','CLOSED','CANCELLED') NOT NULL DEFAULT 'OPEN',
  created_by_user_id BIGINT UNSIGNED NULL,
  created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (accident_incident_id),
  UNIQUE KEY uk_accident_incidents_company_number (company_id, incident_number),
  KEY idx_accident_incidents_trip (trip_id),
  KEY idx_accident_incidents_driver (driver_id),
  KEY idx_accident_incidents_equipment (equipment_type, equipment_id),
  KEY idx_accident_incidents_status (company_id, status, severity),
  CONSTRAINT fk_accident_incidents_company FOREIGN KEY (company_id) REFERENCES companies(company_id),
  CONSTRAINT fk_accident_incidents_trip FOREIGN KEY (trip_id) REFERENCES trips(trip_id),
  CONSTRAINT fk_accident_incidents_order FOREIGN KEY (order_id) REFERENCES orders(order_id),
  CONSTRAINT fk_accident_incidents_driver FOREIGN KEY (driver_id) REFERENCES drivers(driver_id),
  CONSTRAINT fk_accident_incidents_claim FOREIGN KEY (claim_id) REFERENCES claims(claim_id),
  CONSTRAINT fk_accident_incidents_created_by FOREIGN KEY (created_by_user_id) REFERENCES users(user_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS driver_hos_logs (
  driver_hos_log_id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  company_id BIGINT UNSIGNED NOT NULL,
  driver_id BIGINT UNSIGNED NOT NULL,
  log_date DATE NOT NULL,
  duty_status ENUM('OFF_DUTY','SLEEPER','DRIVING','ON_DUTY') NOT NULL,
  start_at_utc TIMESTAMP NOT NULL,
  end_at_utc TIMESTAMP NULL,
  total_minutes INT UNSIGNED NOT NULL DEFAULT 0,
  source ENUM('ELD','MOBILE','MANUAL','IMPORT') NOT NULL DEFAULT 'ELD',
  status ENUM('PENDING','CERTIFIED','REJECTED','CORRECTED') NOT NULL DEFAULT 'PENDING',
  created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (driver_hos_log_id),
  KEY idx_driver_hos_logs_driver_date (driver_id, log_date),
  KEY idx_driver_hos_logs_company_status (company_id, status),
  KEY idx_driver_hos_logs_time (start_at_utc, end_at_utc),
  CONSTRAINT fk_driver_hos_logs_company FOREIGN KEY (company_id) REFERENCES companies(company_id),
  CONSTRAINT fk_driver_hos_logs_driver FOREIGN KEY (driver_id) REFERENCES drivers(driver_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS eld_events (
  eld_event_id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  company_id BIGINT UNSIGNED NOT NULL,
  driver_id BIGINT UNSIGNED NOT NULL,
  truck_id BIGINT UNSIGNED NULL,
  event_type ENUM('ENGINE_ON','ENGINE_OFF','LOGIN','LOGOUT','DUTY_CHANGE','MALFUNCTION','DIAGNOSTIC','LOCATION') NOT NULL,
  event_at_utc TIMESTAMP NOT NULL,
  latitude DECIMAL(10,7) NULL,
  longitude DECIMAL(10,7) NULL,
  odometer_miles DECIMAL(12,2) NULL,
  raw_payload JSON NULL,
  status ENUM('IMPORTED','MATCHED','IGNORED','ERROR') NOT NULL DEFAULT 'IMPORTED',
  created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (eld_event_id),
  KEY idx_eld_events_driver_time (driver_id, event_at_utc),
  KEY idx_eld_events_truck_time (truck_id, event_at_utc),
  KEY idx_eld_events_status (company_id, status),
  CONSTRAINT fk_eld_events_company FOREIGN KEY (company_id) REFERENCES companies(company_id),
  CONSTRAINT fk_eld_events_driver FOREIGN KEY (driver_id) REFERENCES drivers(driver_id),
  CONSTRAINT fk_eld_events_truck FOREIGN KEY (truck_id) REFERENCES trucks(truck_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS shipment_tracking_events (
  shipment_tracking_event_id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  company_id BIGINT UNSIGNED NOT NULL,
  order_id BIGINT UNSIGNED NOT NULL,
  trip_id BIGINT UNSIGNED NULL,
  trip_event_id BIGINT UNSIGNED NULL,
  tracking_status ENUM('ORDER_CREATED','PICKUP_SCHEDULED','PICKED_UP','IN_TRANSIT','AT_YARD','OUT_FOR_DELIVERY','DELIVERED','EXCEPTION','RETURNED','DESTROYED') NOT NULL,
  event_at_utc TIMESTAMP NOT NULL,
  location_text VARCHAR(255) NULL,
  latitude DECIMAL(10,7) NULL,
  longitude DECIMAL(10,7) NULL,
  public_note VARCHAR(500) NULL,
  is_customer_visible BOOLEAN NOT NULL DEFAULT TRUE,
  created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (shipment_tracking_event_id),
  KEY idx_tracking_events_order_time (order_id, event_at_utc),
  KEY idx_tracking_events_trip (trip_id),
  KEY idx_tracking_events_status (company_id, tracking_status),
  CONSTRAINT fk_tracking_events_company FOREIGN KEY (company_id) REFERENCES companies(company_id),
  CONSTRAINT fk_tracking_events_order FOREIGN KEY (order_id) REFERENCES orders(order_id),
  CONSTRAINT fk_tracking_events_trip FOREIGN KEY (trip_id) REFERENCES trips(trip_id),
  CONSTRAINT fk_tracking_events_trip_event FOREIGN KEY (trip_event_id) REFERENCES trip_events(trip_event_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS portal_accounts (
  portal_account_id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  company_id BIGINT UNSIGNED NOT NULL,
  party_id BIGINT UNSIGNED NOT NULL,
  user_id BIGINT UNSIGNED NULL,
  portal_type ENUM('CUSTOMER','CARRIER','SUPPLIER','DRIVER') NOT NULL,
  login_email VARCHAR(160) NOT NULL,
  invited_at DATETIME NULL,
  last_login_at DATETIME NULL,
  status ENUM('INVITED','ACTIVE','LOCKED','DISABLED') NOT NULL DEFAULT 'INVITED',
  created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (portal_account_id),
  UNIQUE KEY uk_portal_accounts_email (company_id, portal_type, login_email),
  KEY idx_portal_accounts_party (party_id),
  KEY idx_portal_accounts_user (user_id),
  KEY idx_portal_accounts_status (company_id, status),
  CONSTRAINT fk_portal_accounts_company FOREIGN KEY (company_id) REFERENCES companies(company_id),
  CONSTRAINT fk_portal_accounts_party FOREIGN KEY (party_id) REFERENCES parties(party_id),
  CONSTRAINT fk_portal_accounts_user FOREIGN KEY (user_id) REFERENCES users(user_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS mobile_device_sessions (
  mobile_device_session_id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  company_id BIGINT UNSIGNED NOT NULL,
  user_id BIGINT UNSIGNED NOT NULL,
  device_uuid VARCHAR(120) NOT NULL,
  device_name VARCHAR(120) NULL,
  platform ENUM('IOS','ANDROID','WEB') NOT NULL,
  app_version VARCHAR(40) NULL,
  last_seen_at DATETIME NULL,
  push_token VARCHAR(255) NULL,
  status ENUM('ACTIVE','EXPIRED','REVOKED') NOT NULL DEFAULT 'ACTIVE',
  created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (mobile_device_session_id),
  UNIQUE KEY uk_mobile_device_sessions_device (company_id, user_id, device_uuid),
  KEY idx_mobile_device_sessions_user_status (user_id, status),
  CONSTRAINT fk_mobile_device_sessions_company FOREIGN KEY (company_id) REFERENCES companies(company_id),
  CONSTRAINT fk_mobile_device_sessions_user FOREIGN KEY (user_id) REFERENCES users(user_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS edi_messages (
  edi_message_id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  company_id BIGINT UNSIGNED NOT NULL,
  trading_partner_party_id BIGINT UNSIGNED NULL,
  message_type ENUM('204','210','214','990','997','CUSTOM') NOT NULL,
  direction ENUM('INBOUND','OUTBOUND') NOT NULL,
  control_number VARCHAR(100) NOT NULL,
  related_entity_type VARCHAR(80) NULL,
  related_entity_id BIGINT UNSIGNED NULL,
  payload_path VARCHAR(500) NULL,
  status ENUM('RECEIVED','PARSED','ACCEPTED','REJECTED','SENT','FAILED') NOT NULL DEFAULT 'RECEIVED',
  received_or_sent_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (edi_message_id),
  UNIQUE KEY uk_edi_messages_control (company_id, direction, control_number),
  KEY idx_edi_messages_partner (trading_partner_party_id),
  KEY idx_edi_messages_related (related_entity_type, related_entity_id),
  KEY idx_edi_messages_status (company_id, status),
  CONSTRAINT fk_edi_messages_company FOREIGN KEY (company_id) REFERENCES companies(company_id),
  CONSTRAINT fk_edi_messages_partner FOREIGN KEY (trading_partner_party_id) REFERENCES parties(party_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS document_templates (
  document_template_id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  company_id BIGINT UNSIGNED NOT NULL,
  template_code VARCHAR(60) NOT NULL,
  template_name VARCHAR(140) NOT NULL,
  entity_type VARCHAR(80) NOT NULL,
  template_body MEDIUMTEXT NOT NULL,
  output_format ENUM('PDF','HTML','DOCX','EMAIL') NOT NULL DEFAULT 'PDF',
  status ENUM('DRAFT','ACTIVE','INACTIVE') NOT NULL DEFAULT 'DRAFT',
  created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (document_template_id),
  UNIQUE KEY uk_document_templates_company_code (company_id, template_code),
  KEY idx_document_templates_entity (company_id, entity_type, status),
  CONSTRAINT fk_document_templates_company FOREIGN KEY (company_id) REFERENCES companies(company_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS email_templates (
  email_template_id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  company_id BIGINT UNSIGNED NOT NULL,
  template_code VARCHAR(60) NOT NULL,
  template_name VARCHAR(140) NOT NULL,
  subject_template VARCHAR(255) NOT NULL,
  body_template MEDIUMTEXT NOT NULL,
  status ENUM('DRAFT','ACTIVE','INACTIVE') NOT NULL DEFAULT 'DRAFT',
  created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (email_template_id),
  UNIQUE KEY uk_email_templates_company_code (company_id, template_code),
  KEY idx_email_templates_status (company_id, status),
  CONSTRAINT fk_email_templates_company FOREIGN KEY (company_id) REFERENCES companies(company_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS import_jobs (
  import_job_id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  company_id BIGINT UNSIGNED NOT NULL,
  import_type ENUM('PARTIES','ORDERS','FUEL','INVENTORY','RATES','DRIVERS','TRUCKS','TRAILERS','CUSTOM') NOT NULL,
  source_file_name VARCHAR(180) NULL,
  source_file_path VARCHAR(500) NULL,
  requested_by_user_id BIGINT UNSIGNED NULL,
  total_rows INT UNSIGNED NOT NULL DEFAULT 0,
  success_rows INT UNSIGNED NOT NULL DEFAULT 0,
  error_rows INT UNSIGNED NOT NULL DEFAULT 0,
  status ENUM('PENDING','PROCESSING','COMPLETED','FAILED','PARTIAL','CANCELLED') NOT NULL DEFAULT 'PENDING',
  started_at DATETIME NULL,
  finished_at DATETIME NULL,
  created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (import_job_id),
  KEY idx_import_jobs_company_status (company_id, status, import_type),
  KEY idx_import_jobs_user (requested_by_user_id),
  CONSTRAINT fk_import_jobs_company FOREIGN KEY (company_id) REFERENCES companies(company_id),
  CONSTRAINT fk_import_jobs_user FOREIGN KEY (requested_by_user_id) REFERENCES users(user_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS import_job_errors (
  import_job_error_id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  import_job_id BIGINT UNSIGNED NOT NULL,
  row_number INT UNSIGNED NULL,
  field_name VARCHAR(120) NULL,
  error_code VARCHAR(80) NULL,
  error_message TEXT NOT NULL,
  raw_row_json JSON NULL,
  status ENUM('OPEN','RESOLVED','IGNORED') NOT NULL DEFAULT 'OPEN',
  created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (import_job_error_id),
  KEY idx_import_job_errors_job_status (import_job_id, status),
  KEY idx_import_job_errors_field (field_name),
  CONSTRAINT fk_import_job_errors_job FOREIGN KEY (import_job_id) REFERENCES import_jobs(import_job_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS report_definitions (
  report_definition_id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  company_id BIGINT UNSIGNED NOT NULL,
  report_code VARCHAR(80) NOT NULL,
  report_name VARCHAR(160) NOT NULL,
  module_name VARCHAR(80) NOT NULL,
  query_key VARCHAR(120) NOT NULL,
  default_filters_json JSON NULL,
  status ENUM('DRAFT','ACTIVE','INACTIVE') NOT NULL DEFAULT 'DRAFT',
  created_by_user_id BIGINT UNSIGNED NULL,
  created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (report_definition_id),
  UNIQUE KEY uk_report_definitions_company_code (company_id, report_code),
  KEY idx_report_definitions_module (company_id, module_name, status),
  KEY idx_report_definitions_user (created_by_user_id),
  CONSTRAINT fk_report_definitions_company FOREIGN KEY (company_id) REFERENCES companies(company_id),
  CONSTRAINT fk_report_definitions_user FOREIGN KEY (created_by_user_id) REFERENCES users(user_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS scheduled_reports (
  scheduled_report_id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  company_id BIGINT UNSIGNED NOT NULL,
  report_definition_id BIGINT UNSIGNED NOT NULL,
  schedule_name VARCHAR(140) NOT NULL,
  cron_expression VARCHAR(80) NOT NULL,
  recipient_emails JSON NOT NULL,
  last_run_at DATETIME NULL,
  next_run_at DATETIME NULL,
  status ENUM('ACTIVE','PAUSED','FAILED','INACTIVE') NOT NULL DEFAULT 'ACTIVE',
  created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (scheduled_report_id),
  KEY idx_scheduled_reports_company_status (company_id, status, next_run_at),
  KEY idx_scheduled_reports_definition (report_definition_id),
  CONSTRAINT fk_scheduled_reports_company FOREIGN KEY (company_id) REFERENCES companies(company_id),
  CONSTRAINT fk_scheduled_reports_definition FOREIGN KEY (report_definition_id) REFERENCES report_definitions(report_definition_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS webhooks (
  webhook_id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  company_id BIGINT UNSIGNED NOT NULL,
  webhook_code VARCHAR(80) NOT NULL,
  target_url VARCHAR(500) NOT NULL,
  event_type VARCHAR(120) NOT NULL,
  secret_reference VARCHAR(255) NULL,
  status ENUM('ACTIVE','PAUSED','ERROR','INACTIVE') NOT NULL DEFAULT 'ACTIVE',
  created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (webhook_id),
  UNIQUE KEY uk_webhooks_company_code (company_id, webhook_code),
  KEY idx_webhooks_event_status (company_id, event_type, status),
  CONSTRAINT fk_webhooks_company FOREIGN KEY (company_id) REFERENCES companies(company_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS webhook_deliveries (
  webhook_delivery_id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  webhook_id BIGINT UNSIGNED NOT NULL,
  entity_type VARCHAR(80) NULL,
  entity_id BIGINT UNSIGNED NULL,
  payload_json JSON NOT NULL,
  response_status_code SMALLINT UNSIGNED NULL,
  response_body TEXT NULL,
  attempt_count SMALLINT UNSIGNED NOT NULL DEFAULT 0,
  delivered_at DATETIME NULL,
  next_retry_at DATETIME NULL,
  status ENUM('PENDING','DELIVERED','FAILED','RETRYING','CANCELLED') NOT NULL DEFAULT 'PENDING',
  created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (webhook_delivery_id),
  KEY idx_webhook_deliveries_webhook_status (webhook_id, status, next_retry_at),
  KEY idx_webhook_deliveries_entity (entity_type, entity_id),
  CONSTRAINT fk_webhook_deliveries_webhook FOREIGN KEY (webhook_id) REFERENCES webhooks(webhook_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS barcode_labels (
  barcode_label_id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  company_id BIGINT UNSIGNED NOT NULL,
  entity_type VARCHAR(80) NOT NULL,
  entity_id BIGINT UNSIGNED NOT NULL,
  label_code VARCHAR(100) NOT NULL,
  barcode_format ENUM('CODE128','QR','PDF417','DATAMATRIX') NOT NULL DEFAULT 'QR',
  label_payload VARCHAR(500) NOT NULL,
  printed_at DATETIME NULL,
  status ENUM('ACTIVE','PRINTED','VOID') NOT NULL DEFAULT 'ACTIVE',
  created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (barcode_label_id),
  UNIQUE KEY uk_barcode_labels_company_code (company_id, label_code),
  KEY idx_barcode_labels_entity (company_id, entity_type, entity_id),
  KEY idx_barcode_labels_status (company_id, status),
  CONSTRAINT fk_barcode_labels_company FOREIGN KEY (company_id) REFERENCES companies(company_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

SET FOREIGN_KEY_CHECKS = 1;
