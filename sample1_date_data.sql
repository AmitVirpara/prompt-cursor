-- Logistics ERP sample data for sample1_date.sql
-- Run after sample1_date.sql on MySQL 8. This script reseeds tables with 10 to 50
-- sample rows per table so foreign-key examples stay deterministic.

USE logistics_erp;

SET FOREIGN_KEY_CHECKS = 0;

TRUNCATE TABLE audit_logs;
TRUNCATE TABLE integration_sync_logs;
TRUNCATE TABLE api_integrations;
TRUNCATE TABLE payroll_lines;
TRUNCATE TABLE payroll_runs;
TRUNCATE TABLE attendance_logs;
TRUNCATE TABLE hr_leave_requests;
TRUNCATE TABLE hr_leave_types;
TRUNCATE TABLE equipment_item_assignments;
TRUNCATE TABLE inventory_stock_movements;
TRUNCATE TABLE inventory_locations;
TRUNCATE TABLE inventory_items;
TRUNCATE TABLE inventory_categories;
TRUNCATE TABLE claim_events;
TRUNCATE TABLE claims;
TRUNCATE TABLE settlement_lines;
TRUNCATE TABLE settlements;
TRUNCATE TABLE statement_lines;
TRUNCATE TABLE statement_runs;
TRUNCATE TABLE bill_lines;
TRUNCATE TABLE bills;
TRUNCATE TABLE invoice_lines;
TRUNCATE TABLE invoices;
TRUNCATE TABLE cross_dock_jobs;
TRUNCATE TABLE trip_account_verifications;
TRUNCATE TABLE trip_pti_records;
TRUNCATE TABLE trip_expenses;
TRUNCATE TABLE trip_event_orders;
TRUNCATE TABLE trip_events;
TRUNCATE TABLE trip_equipment;
TRUNCATE TABLE trip_drivers;
TRUNCATE TABLE trips;
TRUNCATE TABLE order_rates;
TRUNCATE TABLE order_items;
TRUNCATE TABLE order_stops;
TRUNCATE TABLE orders;
TRUNCATE TABLE driver_compliance_records;
TRUNCATE TABLE equipment_compliance_records;
TRUNCATE TABLE carrier_pay_schedules;
TRUNCATE TABLE employee_pay_schedules;
TRUNCATE TABLE driver_pay_schedules;
TRUNCATE TABLE document_attachments;
TRUNCATE TABLE document_types;
TRUNCATE TABLE gps_positions;
TRUNCATE TABLE gps_devices;
TRUNCATE TABLE fuel_transactions;
TRUNCATE TABLE fuel_upload_batches;
TRUNCATE TABLE truck_fuel_card_assignments;
TRUNCATE TABLE fuel_cards;
TRUNCATE TABLE trailer_assets;
TRUNCATE TABLE trucks;
TRUNCATE TABLE drivers;
TRUNCATE TABLE party_accounts;
TRUNCATE TABLE chart_of_accounts;
TRUNCATE TABLE address_lanes;
TRUNCATE TABLE predefined_addresses;
TRUNCATE TABLE party_addresses;
TRUNCATE TABLE party_contacts;
TRUNCATE TABLE parties;
TRUNCATE TABLE party_groups;
TRUNCATE TABLE menus;
TRUNCATE TABLE user_roles;
TRUNCATE TABLE users;
TRUNCATE TABLE employees;
TRUNCATE TABLE designations;
TRUNCATE TABLE role_permissions;
TRUNCATE TABLE permissions;
TRUNCATE TABLE roles;
TRUNCATE TABLE warehouses;
TRUNCATE TABLE terminals;
TRUNCATE TABLE financial_years;
TRUNCATE TABLE daily_currency_rates;
TRUNCATE TABLE company_settings;
TRUNCATE TABLE companies;
TRUNCATE TABLE currencies;

SET FOREIGN_KEY_CHECKS = 1;

DROP TEMPORARY TABLE IF EXISTS seed_numbers;
CREATE TEMPORARY TABLE seed_numbers (n INT NOT NULL PRIMARY KEY);
INSERT INTO seed_numbers (n) VALUES
  (1),(2),(3),(4),(5),(6),(7),(8),(9),(10);

INSERT INTO currencies (code, name, symbol, decimal_places, is_base_default, status) VALUES
  ('CAD','Canadian Dollar','$',2,TRUE,'ACTIVE'),
  ('USD','US Dollar','$',2,FALSE,'ACTIVE'),
  ('INR','Indian Rupee','Rs',2,FALSE,'ACTIVE'),
  ('EUR','Euro','EUR',2,FALSE,'ACTIVE'),
  ('GBP','British Pound','GBP',2,FALSE,'ACTIVE'),
  ('MXN','Mexican Peso','$',2,FALSE,'ACTIVE'),
  ('AUD','Australian Dollar','$',2,FALSE,'ACTIVE'),
  ('JPY','Japanese Yen','JPY',0,FALSE,'ACTIVE'),
  ('CNY','Chinese Yuan','CNY',2,FALSE,'ACTIVE'),
  ('AED','UAE Dirham','AED',2,FALSE,'ACTIVE');

INSERT INTO companies (legal_name, display_name, tax_number, base_currency_id, timezone, fiscal_year_start_month, status)
SELECT
  CONCAT('Logistics Company ', LPAD(n, 2, '0'), ' Inc.'),
  CONCAT('LC', LPAD(n, 2, '0')),
  CONCAT('BN', LPAD(n, 8, '0')),
  1,
  'America/Toronto',
  1,
  'ACTIVE'
FROM seed_numbers;

INSERT INTO company_settings (company_id, setting_key, setting_value, status)
SELECT n, 'dispatch.defaults', JSON_OBJECT('baseCurrency','CAD','gpsTimezone','UTC','enableCrossDock',TRUE), 'ACTIVE'
FROM seed_numbers;

INSERT INTO daily_currency_rates (company_id, base_currency_id, quote_currency_id, rate_date, rate, source, status)
SELECT 1, 1, n, CURRENT_DATE, CASE WHEN n = 1 THEN 1.00000000 ELSE ROUND(0.65000000 + (n * 0.12500000), 8) END, 'OPEN_EXCHANGE', 'ACTIVE'
FROM seed_numbers;

INSERT INTO financial_years (company_id, year_code, start_date, end_date, is_closed, status)
SELECT n, CONCAT('FY2026-C', LPAD(n, 2, '0')), '2026-01-01', '2026-12-31', FALSE, 'OPEN'
FROM seed_numbers;

INSERT INTO terminals (company_id, terminal_code, name, timezone, address_line1, city, state_region, postal_code, country_code, latitude, longitude, status)
SELECT
  n,
  CONCAT('TERM-', LPAD(n, 2, '0')),
  CONCAT('Main Terminal ', n),
  'America/Toronto',
  CONCAT(100 + n, ' Terminal Road'),
  CASE WHEN n % 2 = 0 THEN 'Mississauga' ELSE 'Brampton' END,
  'ON',
  CONCAT('L', n, 'T 1A', n),
  'CA',
  43.6000000 + (n / 1000),
  -79.6500000 - (n / 1000),
  'ACTIVE'
FROM seed_numbers;

INSERT INTO warehouses (company_id, terminal_id, warehouse_code, name, warehouse_type, status)
SELECT n, n, CONCAT('WH-', LPAD(n, 2, '0')), CONCAT('Cross Dock Warehouse ', n), 'CROSS_DOCK', 'ACTIVE'
FROM seed_numbers;

INSERT INTO roles (company_id, role_code, role_name, description, status)
SELECT n, CONCAT('OPS-', LPAD(n, 2, '0')), CONCAT('Operations Role ', n), 'Sample operations role', 'ACTIVE'
FROM seed_numbers;

INSERT INTO permissions (permission_key, module_name, action_name, description, status) VALUES
  ('dashboard.view','Dashboard','view','View dashboard','ACTIVE'),
  ('orders.create','Orders','create','Create orders','ACTIVE'),
  ('orders.dispatch','Orders','dispatch','Dispatch orders','ACTIVE'),
  ('trips.update','Trips','update','Update trips','ACTIVE'),
  ('fleet.manage','Fleet','manage','Manage fleet','ACTIVE'),
  ('accounting.verify','Accounting','verify','Verify accounting','ACTIVE'),
  ('hr.manage','HR','manage','Manage HR','ACTIVE'),
  ('inventory.manage','Inventory','manage','Manage inventory','ACTIVE'),
  ('claims.manage','Claims','manage','Manage claims','ACTIVE'),
  ('admin.manage','Administration','manage','Manage administration','ACTIVE');

INSERT INTO role_permissions (role_id, permission_id, status)
SELECT n, n, 'ACTIVE'
FROM seed_numbers;

INSERT INTO designations (company_id, designation_code, designation_name, department, status)
SELECT n, CONCAT('DES-', LPAD(n, 2, '0')), CONCAT('Dispatcher Level ', n), 'Operations', 'ACTIVE'
FROM seed_numbers;

INSERT INTO employees (company_id, employee_code, designation_id, home_terminal_id, first_name, last_name, email, phone, hire_date, employment_type, status)
SELECT
  n,
  CONCAT('EMP-', LPAD(n, 4, '0')),
  n,
  n,
  CONCAT('Employee', n),
  'Sample',
  CONCAT('employee', n, '@example.com'),
  CONCAT('+1-416-555-', LPAD(n, 4, '0')),
  DATE_ADD('2024-01-01', INTERVAL n DAY),
  'FULL_TIME',
  'ACTIVE'
FROM seed_numbers;

INSERT INTO users (company_id, employee_id, username, email, password_hash, last_login_at, status)
SELECT
  n,
  n,
  CONCAT('user', LPAD(n, 2, '0')),
  CONCAT('user', n, '@example.com'),
  '$2y$12$samplehashforpromptonlynotapassword',
  TIMESTAMPADD(HOUR, n, '2026-06-01 08:00:00'),
  'ACTIVE'
FROM seed_numbers;

INSERT INTO user_roles (user_id, role_id, company_id, status)
SELECT n, n, n, 'ACTIVE'
FROM seed_numbers;

INSERT INTO menus (company_id, parent_menu_id, permission_id, menu_code, menu_label, menu_type, route_path, icon_name, display_order, is_visible, status)
SELECT
  n,
  NULL,
  n,
  CONCAT('MENU-', LPAD(n, 2, '0')),
  CONCAT('Menu ', n),
  CASE WHEN n IN (1,5,10) THEN 'MODULE' ELSE 'PAGE' END,
  CONCAT('/app/menu-', n),
  'menu',
  n * 10,
  TRUE,
  'ACTIVE'
FROM seed_numbers;

INSERT INTO party_groups (company_id, group_code, group_name, status)
SELECT n, CONCAT('PG-', LPAD(n, 2, '0')), CONCAT('Default Party Group ', n), 'ACTIVE'
FROM seed_numbers;

INSERT INTO parties (company_id, party_group_id, party_code, party_name, party_type, tax_number, credit_limit, payment_terms_days, default_currency_id, account_status)
SELECT
  s.n,
  s.n,
  CONCAT(pt.code_prefix, '-', LPAD(s.n, 2, '0')),
  CONCAT(pt.label_name, ' ', s.n),
  pt.party_type,
  CONCAT('TAX-', pt.code_prefix, '-', LPAD(s.n, 5, '0')),
  10000.00 + (s.n * 1000.00),
  30,
  1,
  'ACTIVE'
FROM seed_numbers s
JOIN (
  SELECT 1 AS sort_order, 'CUS' AS code_prefix, 'Customer' AS label_name, 'CUSTOMER' AS party_type
  UNION ALL SELECT 2, 'SHP', 'Shipper', 'SHIPPER'
  UNION ALL SELECT 3, 'RCV', 'Receiver', 'RECEIVER'
  UNION ALL SELECT 4, 'SUP', 'Supplier', 'SUPPLIER'
  UNION ALL SELECT 5, 'CAR', 'Carrier', 'CARRIER'
) pt
ORDER BY s.n, pt.sort_order;

INSERT INTO party_contacts (party_id, contact_name, title, email, phone, is_primary, status)
SELECT
  party_id,
  CONCAT('Contact ', party_id),
  'Operations',
  CONCAT('contact', party_id, '@example.com'),
  CONCAT('+1-905-555-', LPAD(party_id, 4, '0')),
  TRUE,
  'ACTIVE'
FROM parties;

INSERT INTO party_addresses (party_id, address_type, address_line1, city, state_region, postal_code, country_code, latitude, longitude, is_primary, status)
SELECT
  party_id,
  CASE party_type WHEN 'SHIPPER' THEN 'PICKUP' WHEN 'RECEIVER' THEN 'DELIVERY' ELSE 'BILLING' END,
  CONCAT(200 + party_id, ' Commerce Street'),
  CASE WHEN party_id % 2 = 0 THEN 'Toronto' ELSE 'Vaughan' END,
  'ON',
  CONCAT('M', party_id % 9, 'A 1B', party_id % 9),
  'CA',
  43.7000000 + (party_id / 10000),
  -79.4000000 - (party_id / 10000),
  TRUE,
  'ACTIVE'
FROM parties;

INSERT INTO predefined_addresses (company_id, address_code, name, address_line1, city, state_region, postal_code, country_code, latitude, longitude, status)
SELECT
  n,
  CONCAT('ADDR-', LPAD(n, 2, '0')),
  CONCAT('Known Yard ', n),
  CONCAT(300 + n, ' Yard Avenue'),
  'Toronto',
  'ON',
  CONCAT('M5V 2T', n % 10),
  'CA',
  43.6400000 + (n / 1000),
  -79.3800000 - (n / 1000),
  'ACTIVE'
FROM seed_numbers;

INSERT INTO address_lanes (company_id, from_address_id, to_address_id, distance_miles, expected_duration_minutes, toll_amount, status)
SELECT n, n, CASE WHEN n = 10 THEN 1 ELSE n + 1 END, 25.00 + n, 45 + (n * 3), 5.00 + n, 'ACTIVE'
FROM seed_numbers;

INSERT INTO chart_of_accounts (company_id, account_code, account_name, account_type, normal_balance, currency_id, status)
SELECT n, CONCAT('400', LPAD(n, 2, '0')), CONCAT('Freight Revenue ', n), 'REVENUE', 'CREDIT', 1, 'ACTIVE'
FROM seed_numbers;

INSERT INTO party_accounts (company_id, party_id, account_id, account_role, status)
SELECT
  p.company_id,
  p.party_id,
  p.company_id,
  CASE WHEN p.party_type IN ('CUSTOMER','SHIPPER','RECEIVER') THEN 'AR' ELSE 'AP' END,
  'ACTIVE'
FROM parties p;

INSERT INTO drivers (company_id, employee_id, driver_code, first_name, last_name, phone, email, license_number, license_state, license_expiry_date, driver_type, pay_type, status)
SELECT
  n,
  n,
  CONCAT('DRV-', LPAD(n, 4, '0')),
  CONCAT('Driver', n),
  'Sample',
  CONCAT('+1-647-555-', LPAD(n, 4, '0')),
  CONCAT('driver', n, '@example.com'),
  CONCAT('LIC', LPAD(n, 7, '0')),
  'ON',
  DATE_ADD('2028-01-01', INTERVAL n DAY),
  'COMPANY',
  'MILE',
  'ACTIVE'
FROM seed_numbers;

INSERT INTO trucks (company_id, terminal_id, truck_number, vin, plate_number, make, model, model_year, ownership_type, current_odometer_miles, status)
SELECT
  n,
  n,
  CONCAT('TRK-', LPAD(n, 3, '0')),
  CONCAT('VINTRUCK', LPAD(n, 10, '0')),
  CONCAT('ONTRK', LPAD(n, 3, '0')),
  'Freightliner',
  'Cascadia',
  2020 + (n % 5),
  'COMPANY',
  100000 + (n * 2500),
  'AVAILABLE'
FROM seed_numbers;

INSERT INTO trailer_assets (company_id, terminal_id, asset_number, asset_type, vin_or_serial, plate_number, length_feet, max_weight_lbs, container_load_status, ownership_type, status)
SELECT
  s.n,
  s.n,
  CONCAT(ta.asset_prefix, '-', LPAD(s.n, 3, '0')),
  ta.asset_type,
  CONCAT(ta.asset_prefix, 'SER', LPAD(s.n, 10, '0')),
  CONCAT('ON', ta.asset_prefix, LPAD(s.n, 3, '0')),
  CASE WHEN ta.asset_type = 'CHASSIS' THEN 40 ELSE 53 END,
  CASE WHEN ta.asset_type = 'CONTAINER' THEN 67000 ELSE 45000 END,
  CASE WHEN ta.asset_type = 'CONTAINER' THEN 'EMPTY' ELSE NULL END,
  'COMPANY',
  'AVAILABLE'
FROM seed_numbers s
JOIN (
  SELECT 1 AS sort_order, 'TRL' AS asset_prefix, 'TRAILER' AS asset_type
  UNION ALL SELECT 2, 'CON', 'CONTAINER'
  UNION ALL SELECT 3, 'CHS', 'CHASSIS'
) ta
ORDER BY s.n, ta.sort_order;

INSERT INTO fuel_cards (company_id, provider_name, card_number_masked, external_card_id, status, issued_at, expires_at)
SELECT n, 'BDE Fuel', CONCAT('****-****-****-', LPAD(n, 4, '0')), CONCAT('BDE-CARD-', n), 'ACTIVE', '2025-01-01', '2028-12-31'
FROM seed_numbers;

INSERT INTO truck_fuel_card_assignments (truck_id, fuel_card_id, assigned_at, status)
SELECT n, n, TIMESTAMPADD(DAY, n, '2026-01-01 08:00:00'), 'ACTIVE'
FROM seed_numbers;

INSERT INTO fuel_upload_batches (company_id, source, source_file_name, external_batch_id, uploaded_by_user_id, uploaded_at, status)
SELECT n, CASE WHEN n % 2 = 0 THEN 'BDE_API' ELSE 'EXCEL' END, CONCAT('fuel-batch-', n, '.xlsx'), CONCAT('BDE-BATCH-', n), n, TIMESTAMPADD(DAY, n, '2026-02-01 09:00:00'), 'COMPLETED'
FROM seed_numbers;

INSERT INTO fuel_transactions (company_id, fuel_upload_batch_id, truck_id, driver_id, fuel_card_id, transaction_at, vendor_name, city, state_region, gallons, price_per_gallon, total_amount, currency_id, odometer_miles, external_transaction_id, status)
SELECT
  n,
  n,
  n,
  n,
  n,
  TIMESTAMPADD(DAY, n, '2026-02-01 10:00:00'),
  'Sample Fuel Stop',
  'Toronto',
  'ON',
  80.000 + n,
  1.5000 + (n / 100),
  ROUND((80.000 + n) * (1.5000 + (n / 100)), 2),
  1,
  100000 + (n * 2600),
  CONCAT('BDE-TXN-', n),
  'MATCHED'
FROM seed_numbers;

INSERT INTO gps_devices (company_id, device_imei, provider_name, entity_type, entity_id, timezone, status)
SELECT n, CONCAT('35976209999', LPAD(n, 4, '0')), 'Samsara', 'TRUCK', n, 'UTC', 'ACTIVE'
FROM seed_numbers;

INSERT INTO gps_positions (gps_device_id, recorded_at_utc, latitude, longitude, speed_mph, heading_degrees, odometer_miles, engine_hours, raw_payload)
SELECT n, TIMESTAMPADD(MINUTE, n * 5, '2026-06-01 00:00:00'), 43.6500000 + (n / 1000), -79.3900000 - (n / 1000), 55.00 + n, 90 + n, 100000 + (n * 2650), 5000 + n, JSON_OBJECT('source','sample','timezone','UTC')
FROM seed_numbers;

INSERT INTO document_types (company_id, document_type_code, document_type_name, applies_to_entity, requires_expiry_date, status)
SELECT n, CONCAT('DOC-', LPAD(n, 2, '0')), CONCAT('Compliance Document ', n), CASE WHEN n <= 3 THEN 'TRUCK' WHEN n <= 6 THEN 'DRIVER' ELSE 'PARTY' END, TRUE, 'ACTIVE'
FROM seed_numbers;

INSERT INTO document_attachments (company_id, document_type_id, entity_type, entity_id, file_name, file_path, mime_type, file_size_bytes, issue_date, expiry_date, verification_status, uploaded_by_user_id, notes)
SELECT
  n,
  n,
  CASE WHEN n <= 3 THEN 'TRUCK' WHEN n <= 6 THEN 'DRIVER' ELSE 'PARTY' END,
  n,
  CONCAT('sample-document-', n, '.pdf'),
  CONCAT('/documents/company-', n, '/sample-document-', n, '.pdf'),
  'application/pdf',
  102400 + n,
  '2026-01-01',
  DATE_ADD('2027-01-01', INTERVAL n DAY),
  'VERIFIED',
  n,
  'Sample verified document'
FROM seed_numbers;

INSERT INTO driver_pay_schedules (company_id, driver_id, pay_frequency, rate_type, base_rate, effective_from, status)
SELECT n, n, 'WEEKLY', 'MILE', 0.6000 + (n / 100), '2026-01-01', 'ACTIVE'
FROM seed_numbers;

INSERT INTO employee_pay_schedules (company_id, employee_id, pay_frequency, salary_type, rate_amount, effective_from, status)
SELECT n, n, 'BIWEEKLY', 'SALARY', 65000.00 + (n * 1000), '2026-01-01', 'ACTIVE'
FROM seed_numbers;

INSERT INTO carrier_pay_schedules (company_id, carrier_party_id, pay_frequency, rate_type, base_rate, effective_from, status)
SELECT n, ((n - 1) * 5) + 5, 'WEEKLY', 'MILE', 2.2500 + (n / 100), '2026-01-01', 'ACTIVE'
FROM seed_numbers;

INSERT INTO equipment_compliance_records (company_id, equipment_type, equipment_id, compliance_type, reference_number, issue_date, expiry_date, amount, status)
SELECT n, 'TRUCK', n, 'ANNUAL_INSPECTION', CONCAT('INSP-', n), '2026-01-01', DATE_ADD('2027-01-01', INTERVAL n DAY), 250.00 + n, 'VALID'
FROM seed_numbers;

INSERT INTO driver_compliance_records (company_id, driver_id, compliance_type, reference_number, issue_date, expiry_date, status)
SELECT n, n, 'MEDICAL', CONCAT('MED-', n), '2026-01-01', DATE_ADD('2027-01-01', INTERVAL n DAY), 'VALID'
FROM seed_numbers;

INSERT INTO orders (company_id, order_number, customer_party_id, shipper_party_id, receiver_party_id, freight_type, temperature_requirement, special_conditions, packing_support, total_weight_lbs, total_volume_cuft, requested_pickup_at, requested_delivery_at, currency_id, status, created_by_user_id)
SELECT
  n,
  CONCAT('ORD-', LPAD(n, 5, '0')),
  ((n - 1) * 5) + 1,
  ((n - 1) * 5) + 2,
  ((n - 1) * 5) + 3,
  CASE WHEN n % 2 = 0 THEN 'LTL' ELSE 'FTL' END,
  CASE WHEN n % 3 = 0 THEN 'Keep cool 35F-45F' ELSE NULL END,
  'Protect from weather; call before arrival',
  'Pallet jack support available',
  10000.00 + (n * 500),
  1200.00 + (n * 50),
  TIMESTAMPADD(DAY, n, '2026-03-01 08:00:00'),
  TIMESTAMPADD(DAY, n + 2, '2026-03-01 17:00:00'),
  1,
  'READY',
  n
FROM seed_numbers;

INSERT INTO order_stops (order_id, stop_number, stop_type, party_id, party_address_id, scheduled_from, scheduled_to, quantity_planned, quantity_actual, status, notes)
SELECT
  s.n,
  st.stop_number,
  st.stop_type,
  CASE WHEN st.stop_number = 1 THEN ((s.n - 1) * 5) + 2 ELSE ((s.n - 1) * 5) + 3 END,
  CASE WHEN st.stop_number = 1 THEN ((s.n - 1) * 5) + 2 ELSE ((s.n - 1) * 5) + 3 END,
  TIMESTAMPADD(DAY, s.n + st.stop_number, '2026-03-01 08:00:00'),
  TIMESTAMPADD(DAY, s.n + st.stop_number, '2026-03-01 12:00:00'),
  10.00,
  0.00,
  'PLANNED',
  CONCAT('Sample ', LOWER(st.stop_type), ' stop')
FROM seed_numbers s
JOIN (
  SELECT 1 AS stop_number, 'PICKUP' AS stop_type
  UNION ALL SELECT 2, 'DELIVERY'
) st
ORDER BY s.n, st.stop_number;

INSERT INTO order_items (order_id, item_description, commodity_code, package_type, quantity, weight_lbs, length_in, width_in, height_in, hazmat_flag, temperature_min_f, temperature_max_f, status)
SELECT n, CONCAT('General freight item ', n), CONCAT('CMD-', n), 'PALLET', 10.00 + n, 1000.00 + (n * 100), 48.00, 40.00, 60.00, FALSE, NULL, NULL, 'ACTIVE'
FROM seed_numbers;

INSERT INTO order_rates (order_id, rate_code, description, quantity, unit_rate, amount, currency_id, bill_to_party_id, status)
SELECT n, 'LINEHAUL', CONCAT('Linehaul charge ', n), 1.000, 1500.0000 + (n * 25), 1500.00 + (n * 25), 1, ((n - 1) * 5) + 1, 'APPROVED'
FROM seed_numbers;

INSERT INTO trips (company_id, trip_number, trip_type, carrier_party_id, truck_id, origin_terminal_id, destination_terminal_id, planned_start_at, planned_end_at, total_planned_miles, total_actual_miles, status, accounting_status, created_by_user_id)
SELECT
  n,
  CONCAT('TRIP-', LPAD(n, 5, '0')),
  CASE WHEN n % 2 = 0 THEN 'CARRIER' ELSE 'COMPANY_TRUCK' END,
  CASE WHEN n % 2 = 0 THEN ((n - 1) * 5) + 5 ELSE NULL END,
  CASE WHEN n % 2 = 0 THEN NULL ELSE n END,
  n,
  CASE WHEN n = 10 THEN 1 ELSE n + 1 END,
  TIMESTAMPADD(DAY, n, '2026-03-01 06:00:00'),
  TIMESTAMPADD(DAY, n + 3, '2026-03-01 18:00:00'),
  500.00 + (n * 10),
  0.00,
  'PLANNED',
  'NOT_READY',
  n
FROM seed_numbers;

INSERT INTO trip_drivers (trip_id, driver_id, driver_role, pay_rate_type, pay_rate, status)
SELECT n, n, 'PRIMARY', 'MILE', 0.6500 + (n / 100), 'ASSIGNED'
FROM seed_numbers;

INSERT INTO trip_equipment (trip_id, equipment_type, truck_id, trailer_asset_id, attached_at, status)
SELECT n, 'TRUCK', n, NULL, TIMESTAMPADD(DAY, n, '2026-03-01 06:30:00'), 'ATTACHED'
FROM seed_numbers
UNION ALL
SELECT n, 'TRAILER', NULL, ((n - 1) * 3) + 1, TIMESTAMPADD(DAY, n, '2026-03-01 07:00:00'), 'ATTACHED'
FROM seed_numbers;

INSERT INTO trip_events (trip_id, event_order, event_type, planner_user_id, terminal_id, predefined_address_id, planned_at, event_miles, expense_amount, extra_pay_amount, currency_id, event_status, notes)
SELECT
  s.n,
  ev.event_order,
  ev.event_type,
  s.n,
  s.n,
  s.n,
  TIMESTAMPADD(HOUR, (s.n * 6) + ev.event_order, '2026-03-01 00:00:00'),
  CASE ev.event_order WHEN 1 THEN 0.00 WHEN 2 THEN 250.00 ELSE 250.00 END,
  CASE ev.event_order WHEN 2 THEN 25.00 ELSE 0.00 END,
  CASE ev.event_order WHEN 3 THEN 50.00 ELSE 0.00 END,
  1,
  'PLANNED',
  CONCAT('Sample trip event ', ev.event_order)
FROM seed_numbers s
JOIN (
  SELECT 1 AS event_order, 'ACQUIRE_TRUCK' AS event_type
  UNION ALL SELECT 2, 'PICKUP_LOAD'
  UNION ALL SELECT 3, 'DELIVER_LOAD'
) ev
ORDER BY s.n, ev.event_order;

INSERT INTO trip_event_orders (trip_event_id, order_id, order_stop_id, quantity_handled, status)
SELECT
  ((s.n - 1) * 3) + ev.event_order,
  s.n,
  CASE ev.event_order WHEN 2 THEN ((s.n - 1) * 2) + 1 WHEN 3 THEN ((s.n - 1) * 2) + 2 ELSE NULL END,
  CASE ev.event_order WHEN 1 THEN 0.00 ELSE 10.00 END,
  'PLANNED'
FROM seed_numbers s
JOIN (
  SELECT 1 AS event_order
  UNION ALL SELECT 2
  UNION ALL SELECT 3
) ev
ORDER BY s.n, ev.event_order;

INSERT INTO trip_expenses (trip_id, trip_event_id, expense_type, amount, currency_id, paid_by, reimbursable, verification_status, created_by_user_id)
SELECT n, ((n - 1) * 3) + 2, 'LUMPER', 75.00 + n, 1, 'DRIVER', TRUE, 'PENDING', n
FROM seed_numbers;

INSERT INTO trip_pti_records (trip_id, equipment_type, equipment_id, inspection_at, inspected_by_user_id, amount, document_attachment_id, status, notes)
SELECT n, 'TRUCK', n, TIMESTAMPADD(DAY, n, '2026-03-01 05:30:00'), n, 35.00 + n, n, 'PASSED', 'Sample PTI passed'
FROM seed_numbers;

INSERT INTO trip_account_verifications (trip_id, verified_by_user_id, verified_at, verification_status, notes)
SELECT n, n, TIMESTAMPADD(DAY, n, '2026-03-05 09:00:00'), 'PENDING', 'Awaiting trip completion'
FROM seed_numbers;

INSERT INTO cross_dock_jobs (company_id, trip_id, trip_event_id, terminal_id, inbound_order_id, outbound_order_id, dock_door, handling_units, status)
SELECT n, n, ((n - 1) * 3) + 2, n, n, n, CONCAT('DOOR-', n), 10.00 + n, 'PLANNED'
FROM seed_numbers;

INSERT INTO invoices (company_id, invoice_number, customer_party_id, order_id, invoice_date, due_date, currency_id, subtotal_amount, tax_amount, total_amount, paid_amount, status)
SELECT n, CONCAT('INV-', LPAD(n, 5, '0')), ((n - 1) * 5) + 1, n, DATE_ADD('2026-03-10', INTERVAL n DAY), DATE_ADD('2026-04-10', INTERVAL n DAY), 1, 1500.00 + (n * 25), 195.00 + n, 1695.00 + (n * 26), 0.00, 'APPROVED'
FROM seed_numbers;

INSERT INTO invoice_lines (invoice_id, order_rate_id, line_description, quantity, unit_price, line_amount, tax_amount, status)
SELECT n, n, CONCAT('Invoice linehaul ', n), 1.000, 1500.0000 + (n * 25), 1500.00 + (n * 25), 195.00 + n, 'ACTIVE'
FROM seed_numbers;

INSERT INTO bills (company_id, bill_number, vendor_party_id, trip_id, bill_date, due_date, currency_id, subtotal_amount, tax_amount, total_amount, paid_amount, status)
SELECT n, CONCAT('BILL-', LPAD(n, 5, '0')), ((n - 1) * 5) + 5, n, DATE_ADD('2026-03-11', INTERVAL n DAY), DATE_ADD('2026-04-11', INTERVAL n DAY), 1, 900.00 + (n * 20), 117.00 + n, 1017.00 + (n * 21), 0.00, 'APPROVED'
FROM seed_numbers;

INSERT INTO bill_lines (bill_id, trip_expense_id, line_description, quantity, unit_price, line_amount, tax_amount, status)
SELECT n, n, CONCAT('Carrier or expense payable ', n), 1.000, 900.0000 + (n * 20), 900.00 + (n * 20), 117.00 + n, 'ACTIVE'
FROM seed_numbers;

INSERT INTO statement_runs (company_id, statement_number, statement_entity_type, entity_id, period_start, period_end, currency_id, gross_amount, deduction_amount, net_amount, status)
SELECT n, CONCAT('STMT-', LPAD(n, 5, '0')), 'DRIVER', n, '2026-03-01', '2026-03-15', 1, 1200.00 + n, 100.00, 1100.00 + n, 'DRAFT'
FROM seed_numbers;

INSERT INTO statement_lines (statement_run_id, source_type, source_id, line_description, amount, status)
SELECT n, 'TRIP', n, CONCAT('Trip pay line ', n), 1100.00 + n, 'ACTIVE'
FROM seed_numbers;

INSERT INTO settlements (company_id, settlement_number, payee_type, payee_id, statement_run_id, settlement_date, currency_id, total_amount, status)
SELECT n, CONCAT('SET-', LPAD(n, 5, '0')), 'DRIVER', n, n, DATE_ADD('2026-03-16', INTERVAL n DAY), 1, 1100.00 + n, 'APPROVED'
FROM seed_numbers;

INSERT INTO settlement_lines (settlement_id, statement_line_id, line_description, amount, status)
SELECT n, n, CONCAT('Settlement line ', n), 1100.00 + n, 'ACTIVE'
FROM seed_numbers;

INSERT INTO claims (company_id, claim_number, order_id, trip_id, claimant_party_id, claim_type, claim_amount, currency_id, incident_date, status)
SELECT n, CONCAT('CLM-', LPAD(n, 5, '0')), n, n, ((n - 1) * 5) + 1, CASE WHEN n % 2 = 0 THEN 'DAMAGE' ELSE 'SHORTAGE' END, 250.00 + n, 1, DATE_ADD('2026-03-04', INTERVAL n DAY), 'OPEN'
FROM seed_numbers;

INSERT INTO claim_events (claim_id, event_type, event_note, event_by_user_id, event_at, status)
SELECT n, 'CREATED', CONCAT('Claim opened for sample order ', n), n, TIMESTAMPADD(DAY, n, '2026-03-05 10:00:00'), 'ACTIVE'
FROM seed_numbers;

INSERT INTO inventory_categories (company_id, category_code, category_name, status)
SELECT n, CONCAT('CAT-', LPAD(n, 2, '0')), CONCAT('Daily Use Category ', n), 'ACTIVE'
FROM seed_numbers;

INSERT INTO inventory_items (company_id, inventory_category_id, sku, item_name, unit_of_measure, reorder_level, status)
SELECT n, n, CONCAT('SKU-', LPAD(n, 5, '0')), CONCAT('Strap or seal item ', n), 'EA', 25.00, 'ACTIVE'
FROM seed_numbers;

INSERT INTO inventory_locations (company_id, warehouse_id, location_code, location_name, status)
SELECT n, n, CONCAT('LOC-', LPAD(n, 2, '0')), CONCAT('Parts Bin ', n), 'ACTIVE'
FROM seed_numbers;

INSERT INTO inventory_stock_movements (company_id, inventory_item_id, inventory_location_id, movement_type, quantity, unit_cost, reference_type, reference_id, moved_by_user_id, moved_at, status)
SELECT n, n, n, 'RECEIPT', 100.00 + n, 2.5000 + (n / 10), 'MANUAL', NULL, n, TIMESTAMPADD(DAY, n, '2026-02-01 08:00:00'), 'POSTED'
FROM seed_numbers;

INSERT INTO equipment_item_assignments (company_id, inventory_item_id, assigned_entity_type, assigned_entity_id, quantity, assigned_at, status)
SELECT n, n, CASE WHEN n % 2 = 0 THEN 'TRAILER' ELSE 'TRUCK' END, n, 2.00, TIMESTAMPADD(DAY, n, '2026-02-10 08:00:00'), 'ASSIGNED'
FROM seed_numbers;

INSERT INTO hr_leave_types (company_id, leave_code, leave_name, annual_days, paid_flag, status)
SELECT n, CONCAT('VAC-', LPAD(n, 2, '0')), CONCAT('Vacation Type ', n), 10.00 + n, TRUE, 'ACTIVE'
FROM seed_numbers;

INSERT INTO hr_leave_requests (company_id, employee_id, leave_type_id, start_date, end_date, total_days, reason, approved_by_user_id, status)
SELECT n, n, n, DATE_ADD('2026-07-01', INTERVAL n DAY), DATE_ADD('2026-07-02', INTERVAL n DAY), 2.00, 'Sample vacation request', n, 'APPROVED'
FROM seed_numbers;

INSERT INTO attendance_logs (company_id, employee_id, work_date, clock_in_at, clock_out_at, total_hours, source, status)
SELECT n, n, DATE_ADD('2026-06-01', INTERVAL n DAY), TIMESTAMPADD(DAY, n, '2026-06-01 08:00:00'), TIMESTAMPADD(DAY, n, '2026-06-01 17:00:00'), 8.00, 'WEB', 'APPROVED'
FROM seed_numbers;

INSERT INTO payroll_runs (company_id, payroll_number, period_start, period_end, pay_date, currency_id, gross_amount, deduction_amount, net_amount, status)
SELECT n, CONCAT('PAY-', LPAD(n, 5, '0')), '2026-06-01', '2026-06-15', '2026-06-20', 1, 3000.00 + n, 500.00, 2500.00 + n, 'APPROVED'
FROM seed_numbers;

INSERT INTO payroll_lines (payroll_run_id, employee_id, gross_amount, deduction_amount, net_amount, status)
SELECT n, n, 3000.00 + n, 500.00, 2500.00 + n, 'ACTIVE'
FROM seed_numbers;

INSERT INTO api_integrations (company_id, integration_code, integration_name, provider_type, base_url, credential_reference, sync_frequency_minutes, last_sync_at, status)
SELECT
  n,
  CONCAT('INT-', LPAD(n, 2, '0')),
  CASE WHEN n % 2 = 0 THEN 'BDE Fuel API' ELSE 'Currency Rate API' END,
  CASE WHEN n % 2 = 0 THEN 'FUEL_BDE' ELSE 'CURRENCY_RATE' END,
  CASE WHEN n % 2 = 0 THEN 'https://api.example-bde.test' ELSE 'https://api.exchangerate.test' END,
  CONCAT('vault:company-', n, ':integration'),
  CASE WHEN n % 2 = 0 THEN 60 ELSE 1440 END,
  TIMESTAMPADD(HOUR, n, '2026-06-01 00:00:00'),
  'ACTIVE'
FROM seed_numbers;

INSERT INTO integration_sync_logs (api_integration_id, sync_started_at, sync_finished_at, status, records_read, records_inserted, records_updated, error_message)
SELECT n, TIMESTAMPADD(HOUR, n, '2026-06-01 01:00:00'), TIMESTAMPADD(HOUR, n, '2026-06-01 01:05:00'), 'SUCCESS', 100 + n, 10 + n, 5 + n, NULL
FROM seed_numbers;

INSERT INTO audit_logs (company_id, user_id, entity_type, entity_id, action_name, old_values, new_values, ip_address, user_agent, status)
SELECT n, n, 'orders', n, 'CREATE', NULL, JSON_OBJECT('orderNumber', CONCAT('ORD-', LPAD(n, 5, '0'))), CONCAT('10.0.0.', n), 'Sample Browser', 'SUCCESS'
FROM seed_numbers;

DROP TEMPORARY TABLE IF EXISTS seed_numbers;
