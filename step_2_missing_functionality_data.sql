-- Step 2 Logistics ERP sample data
-- Run after sample1_date.sql, sample1_date_data.sql, and step_2_missing_functionality.sql.

USE logistics_erp;

SET FOREIGN_KEY_CHECKS = 0;

TRUNCATE TABLE barcode_labels;
TRUNCATE TABLE webhook_deliveries;
TRUNCATE TABLE webhooks;
TRUNCATE TABLE scheduled_reports;
TRUNCATE TABLE report_definitions;
TRUNCATE TABLE import_job_errors;
TRUNCATE TABLE import_jobs;
TRUNCATE TABLE email_templates;
TRUNCATE TABLE document_templates;
TRUNCATE TABLE edi_messages;
TRUNCATE TABLE mobile_device_sessions;
TRUNCATE TABLE portal_accounts;
TRUNCATE TABLE shipment_tracking_events;
TRUNCATE TABLE eld_events;
TRUNCATE TABLE driver_hos_logs;
TRUNCATE TABLE accident_incidents;
TRUNCATE TABLE insurance_policies;
TRUNCATE TABLE service_schedules;
TRUNCATE TABLE maintenance_work_order_lines;
TRUNCATE TABLE maintenance_work_orders;
TRUNCATE TABLE yard_moves;
TRUNCATE TABLE yard_spots;
TRUNCATE TABLE dock_appointments;
TRUNCATE TABLE tender_responses;
TRUNCATE TABLE load_tenders;
TRUNCATE TABLE carrier_rate_lanes;
TRUNCATE TABLE carrier_rate_agreements;
TRUNCATE TABLE contract_lanes;
TRUNCATE TABLE customer_contracts;
TRUNCATE TABLE quote_lines;
TRUNCATE TABLE quotes;
TRUNCATE TABLE quote_requests;
TRUNCATE TABLE payment_allocations;
TRUNCATE TABLE payments;
TRUNCATE TABLE bank_accounts;
TRUNCATE TABLE tax_codes;
TRUNCATE TABLE entity_tags;
TRUNCATE TABLE tags;
TRUNCATE TABLE tasks;
TRUNCATE TABLE task_boards;
TRUNCATE TABLE entity_comments;
TRUNCATE TABLE approval_actions;
TRUNCATE TABLE approval_requests;
TRUNCATE TABLE workflow_steps;
TRUNCATE TABLE workflow_definitions;
TRUNCATE TABLE notification_deliveries;
TRUNCATE TABLE notifications;
TRUNCATE TABLE dashboard_widgets;
TRUNCATE TABLE saved_filters;
TRUNCATE TABLE user_preferences;
TRUNCATE TABLE departments;

SET FOREIGN_KEY_CHECKS = 1;

DROP TEMPORARY TABLE IF EXISTS seed_numbers;
CREATE TEMPORARY TABLE seed_numbers (n INT NOT NULL PRIMARY KEY);
INSERT INTO seed_numbers (n) VALUES
  (1),(2),(3),(4),(5),(6),(7),(8),(9),(10);

INSERT INTO departments (company_id, department_code, department_name, manager_employee_id, cost_center_code, status)
SELECT n, CONCAT('OPS-', LPAD(n, 2, '0')), CONCAT('Operations Department ', n), n, CONCAT('CC-', LPAD(n, 3, '0')), 'ACTIVE'
FROM seed_numbers;

INSERT INTO user_preferences (company_id, user_id, preference_key, preference_value, status)
SELECT n, n, 'dispatch.board.layout', JSON_OBJECT('density','compact','defaultTerminalId',n,'theme','light'), 'ACTIVE'
FROM seed_numbers;

INSERT INTO saved_filters (company_id, user_id, module_name, filter_name, filter_json, is_default, is_shared, status)
SELECT n, n, 'orders', CONCAT('Ready Orders ', n), JSON_OBJECT('status','READY','freightType','FTL','companyId',n), TRUE, FALSE, 'ACTIVE'
FROM seed_numbers;

INSERT INTO dashboard_widgets (company_id, user_id, widget_code, widget_title, widget_type, layout_json, config_json, display_order, status)
SELECT n, n, CONCAT('WGT-', LPAD(n, 2, '0')), CONCAT('Dispatch KPI ', n), 'KPI', JSON_OBJECT('x',0,'y',n,'w',4,'h',2), JSON_OBJECT('metric','readyOrders'), n, 'ACTIVE'
FROM seed_numbers;

INSERT INTO notifications (company_id, notification_type, title, body, entity_type, entity_id, priority, status, created_by_user_id, expires_at)
SELECT n, 'DISPATCH', CONCAT('Trip ', n, ' ready'), 'Trip is ready for dispatcher review.', 'trips', n, 'NORMAL', 'ACTIVE', n, DATE_ADD(CURRENT_TIMESTAMP, INTERVAL 7 DAY)
FROM seed_numbers;

INSERT INTO notification_deliveries (notification_id, user_id, channel, delivered_at, read_at, status)
SELECT n, n, 'IN_APP', TIMESTAMPADD(MINUTE, n, '2026-06-01 08:00:00'), NULL, 'DELIVERED'
FROM seed_numbers;

INSERT INTO workflow_definitions (company_id, workflow_code, workflow_name, entity_type, trigger_event, config_json, status)
SELECT n, CONCAT('WF-TRIP-', LPAD(n, 2, '0')), CONCAT('Trip Accounting Approval ', n), 'trips', 'submit_for_accounting', JSON_OBJECT('requiresDocuments',TRUE,'requiresExpenses',TRUE), 'ACTIVE'
FROM seed_numbers;

INSERT INTO workflow_steps (workflow_definition_id, step_order, step_name, approver_role_id, approver_user_id, action_type, required_flag, status)
SELECT n, 1, 'Accounting Review', n, n, 'APPROVE', TRUE, 'ACTIVE'
FROM seed_numbers;

INSERT INTO approval_requests (company_id, workflow_definition_id, entity_type, entity_id, requested_by_user_id, current_step_order, requested_at, status, reason)
SELECT n, n, 'trips', n, n, 1, TIMESTAMPADD(HOUR, n, '2026-06-01 09:00:00'), 'PENDING', 'Trip needs accounting verification.'
FROM seed_numbers;

INSERT INTO approval_actions (approval_request_id, workflow_step_id, action_by_user_id, action_name, action_note, action_at, status)
SELECT n, n, n, 'SUBMIT', 'Submitted for review.', TIMESTAMPADD(HOUR, n, '2026-06-01 09:15:00'), 'ACTIVE'
FROM seed_numbers;

INSERT INTO entity_comments (company_id, entity_type, entity_id, comment_text, visibility, created_by_user_id, status)
SELECT n, 'orders', n, CONCAT('Customer requested call before pickup for order ', n), 'INTERNAL', n, 'ACTIVE'
FROM seed_numbers;

INSERT INTO task_boards (company_id, board_code, board_name, module_name, status)
SELECT n, CONCAT('BOARD-', LPAD(n, 2, '0')), CONCAT('Dispatch Board ', n), 'dispatch', 'ACTIVE'
FROM seed_numbers;

INSERT INTO tasks (company_id, task_board_id, entity_type, entity_id, task_title, task_description, assigned_to_user_id, due_at, priority, status, created_by_user_id)
SELECT n, n, 'trips', n, CONCAT('Verify trip documents ', n), 'Confirm BOL, POD, and PTI documents before closing.', n, TIMESTAMPADD(DAY, n, '2026-06-01 17:00:00'), 'HIGH', 'OPEN', n
FROM seed_numbers;

INSERT INTO tags (company_id, tag_name, color_hex, status)
SELECT n, CONCAT('Hot Load ', n), '#FF5733', 'ACTIVE'
FROM seed_numbers;

INSERT INTO entity_tags (company_id, tag_id, entity_type, entity_id, created_by_user_id)
SELECT n, n, 'orders', n, n
FROM seed_numbers;

INSERT INTO tax_codes (company_id, tax_code, tax_name, tax_rate, country_code, state_region, status)
SELECT n, CONCAT('HST-', LPAD(n, 2, '0')), CONCAT('Ontario HST ', n), 0.13000, 'CA', 'ON', 'ACTIVE'
FROM seed_numbers;

INSERT INTO bank_accounts (company_id, account_name, bank_name, account_number_masked, routing_number_masked, currency_id, gl_account_id, status)
SELECT n, CONCAT('Operating Account ', n), 'Sample Bank', CONCAT('****', LPAD(n, 4, '0')), CONCAT('***', LPAD(n, 3, '0')), 1, n, 'ACTIVE'
FROM seed_numbers;

INSERT INTO payments (company_id, payment_number, payment_type, party_id, bank_account_id, payment_date, currency_id, amount, reference_number, status, created_by_user_id)
SELECT n, CONCAT('PAYMENT-', LPAD(n, 5, '0')), 'CUSTOMER_RECEIPT', ((n - 1) * 5) + 1, n, DATE_ADD('2026-06-01', INTERVAL n DAY), 1, 500.00 + n, CONCAT('REF-', n), 'POSTED', n
FROM seed_numbers;

INSERT INTO payment_allocations (payment_id, target_type, target_id, allocated_amount, status)
SELECT n, 'INVOICE', n, 500.00 + n, 'ACTIVE'
FROM seed_numbers;

INSERT INTO quote_requests (company_id, quote_request_number, customer_party_id, origin_address_id, destination_address_id, freight_type, requested_pickup_at, total_weight_lbs, status, created_by_user_id)
SELECT n, CONCAT('QR-', LPAD(n, 5, '0')), ((n - 1) * 5) + 1, n, CASE WHEN n = 10 THEN 1 ELSE n + 1 END, CASE WHEN n % 2 = 0 THEN 'LTL' ELSE 'FTL' END, TIMESTAMPADD(DAY, n, '2026-06-10 08:00:00'), 8000.00 + (n * 250), 'REQUESTED', n
FROM seed_numbers;

INSERT INTO quotes (company_id, quote_request_id, quote_number, customer_party_id, currency_id, valid_until, subtotal_amount, tax_amount, total_amount, status, created_by_user_id)
SELECT n, n, CONCAT('QUOTE-', LPAD(n, 5, '0')), ((n - 1) * 5) + 1, 1, DATE_ADD('2026-07-01', INTERVAL n DAY), 1200.00 + n, 156.00 + n, 1356.00 + (n * 2), 'SENT', n
FROM seed_numbers;

INSERT INTO quote_lines (quote_id, charge_code, description, quantity, unit_rate, line_amount, status)
SELECT n, 'LINEHAUL', CONCAT('Quoted linehaul ', n), 1.000, 1200.0000 + n, 1200.00 + n, 'ACTIVE'
FROM seed_numbers;

INSERT INTO customer_contracts (company_id, customer_party_id, contract_number, contract_name, effective_from, effective_to, currency_id, status)
SELECT n, ((n - 1) * 5) + 1, CONCAT('CUST-CON-', LPAD(n, 4, '0')), CONCAT('Customer Contract ', n), '2026-01-01', '2026-12-31', 1, 'ACTIVE'
FROM seed_numbers;

INSERT INTO contract_lanes (customer_contract_id, address_lane_id, origin_zone, destination_zone, freight_type, rate_type, base_rate, fuel_surcharge_percent, status)
SELECT n, n, 'GTA', 'Ontario', 'FTL', 'FLAT', 1450.0000 + n, 18.5000, 'ACTIVE'
FROM seed_numbers;

INSERT INTO carrier_rate_agreements (company_id, carrier_party_id, agreement_number, effective_from, effective_to, currency_id, status)
SELECT n, ((n - 1) * 5) + 5, CONCAT('CAR-CON-', LPAD(n, 4, '0')), '2026-01-01', '2026-12-31', 1, 'ACTIVE'
FROM seed_numbers;

INSERT INTO carrier_rate_lanes (carrier_rate_agreement_id, address_lane_id, equipment_type, rate_type, base_rate, minimum_amount, status)
SELECT n, n, 'VAN', 'MILE', 2.4000 + (n / 100), 600.00 + n, 'ACTIVE'
FROM seed_numbers;

INSERT INTO load_tenders (company_id, trip_id, order_id, carrier_party_id, tender_number, tender_amount, currency_id, expires_at, status, created_by_user_id)
SELECT n, n, n, ((n - 1) * 5) + 5, CONCAT('TENDER-', LPAD(n, 5, '0')), 950.00 + n, 1, TIMESTAMPADD(HOUR, n, '2026-06-02 12:00:00'), 'SENT', n
FROM seed_numbers;

INSERT INTO tender_responses (load_tender_id, response_by_contact, response_at, response_status, counter_amount, notes)
SELECT n, CONCAT('Carrier Contact ', n), TIMESTAMPADD(HOUR, n, '2026-06-02 13:00:00'), CASE WHEN n % 3 = 0 THEN 'COUNTERED' ELSE 'ACCEPTED' END, CASE WHEN n % 3 = 0 THEN 1000.00 + n ELSE NULL END, 'Sample tender response'
FROM seed_numbers;

INSERT INTO dock_appointments (company_id, terminal_id, warehouse_id, order_id, trip_id, appointment_number, dock_door, appointment_type, scheduled_start_at, scheduled_end_at, status)
SELECT n, n, n, n, n, CONCAT('APT-', LPAD(n, 5, '0')), CONCAT('D-', n), 'PICKUP', TIMESTAMPADD(DAY, n, '2026-06-05 08:00:00'), TIMESTAMPADD(DAY, n, '2026-06-05 09:00:00'), 'SCHEDULED'
FROM seed_numbers;

INSERT INTO yard_spots (company_id, terminal_id, spot_code, spot_type, current_equipment_type, current_equipment_id, status)
SELECT n, n, CONCAT('Y-', LPAD(n, 3, '0')), 'PARKING', 'TRAILER', ((n - 1) * 3) + 1, 'OCCUPIED'
FROM seed_numbers;

INSERT INTO yard_moves (company_id, terminal_id, from_yard_spot_id, to_yard_spot_id, trip_id, equipment_type, equipment_id, moved_by_user_id, moved_at, status, notes)
SELECT n, n, NULL, n, n, 'TRAILER', ((n - 1) * 3) + 1, n, TIMESTAMPADD(DAY, n, '2026-06-05 10:00:00'), 'COMPLETED', 'Moved trailer to parking spot.'
FROM seed_numbers;

INSERT INTO maintenance_work_orders (company_id, work_order_number, equipment_type, equipment_id, vendor_party_id, opened_at, odometer_miles, priority, status, created_by_user_id)
SELECT n, CONCAT('MWO-', LPAD(n, 5, '0')), 'TRUCK', n, ((n - 1) * 5) + 4, TIMESTAMPADD(DAY, n, '2026-05-01 08:00:00'), 100000 + (n * 3000), 'NORMAL', 'OPEN', n
FROM seed_numbers;

INSERT INTO maintenance_work_order_lines (maintenance_work_order_id, line_type, description, inventory_item_id, quantity, unit_cost, line_amount, status)
SELECT n, 'PART', CONCAT('Preventive maintenance part ', n), n, 1.000, 75.0000 + n, 75.00 + n, 'ACTIVE'
FROM seed_numbers;

INSERT INTO service_schedules (company_id, equipment_type, equipment_id, service_type, interval_days, interval_miles, last_service_date, last_service_miles, next_due_date, next_due_miles, status)
SELECT n, 'TRUCK', n, 'PM Service', 90, 25000.00, '2026-01-01', 100000.00 + n, DATE_ADD('2026-04-01', INTERVAL n DAY), 125000.00 + n, 'ACTIVE'
FROM seed_numbers;

INSERT INTO insurance_policies (company_id, policy_number, insurer_name, policy_type, insured_entity_type, insured_entity_id, coverage_amount, currency_id, effective_from, effective_to, status)
SELECT n, CONCAT('POL-', LPAD(n, 5, '0')), 'Sample Insurance Co', 'AUTO_LIABILITY', 'TRUCK', n, 2000000.00, 1, '2026-01-01', '2026-12-31', 'ACTIVE'
FROM seed_numbers;

INSERT INTO accident_incidents (company_id, incident_number, trip_id, order_id, driver_id, equipment_type, equipment_id, incident_at, location_text, severity, description, claim_id, status, created_by_user_id)
SELECT n, CONCAT('INC-', LPAD(n, 5, '0')), n, n, n, 'TRUCK', n, TIMESTAMPADD(DAY, n, '2026-06-01 14:00:00'), 'Sample location', 'LOW', 'Minor sample incident for workflow testing.', n, 'OPEN', n
FROM seed_numbers;

INSERT INTO driver_hos_logs (company_id, driver_id, log_date, duty_status, start_at_utc, end_at_utc, total_minutes, source, status)
SELECT n, n, DATE_ADD('2026-06-01', INTERVAL n DAY), 'DRIVING', TIMESTAMPADD(DAY, n, '2026-06-01 08:00:00'), TIMESTAMPADD(DAY, n, '2026-06-01 12:00:00'), 240, 'ELD', 'CERTIFIED'
FROM seed_numbers;

INSERT INTO eld_events (company_id, driver_id, truck_id, event_type, event_at_utc, latitude, longitude, odometer_miles, raw_payload, status)
SELECT n, n, n, 'DUTY_CHANGE', TIMESTAMPADD(DAY, n, '2026-06-01 08:00:00'), 43.6500000 + (n / 1000), -79.3800000 - (n / 1000), 100000.00 + (n * 3000), JSON_OBJECT('source','sample-eld'), 'MATCHED'
FROM seed_numbers;

INSERT INTO shipment_tracking_events (company_id, order_id, trip_id, trip_event_id, tracking_status, event_at_utc, location_text, latitude, longitude, public_note, is_customer_visible)
SELECT n, n, n, ((n - 1) * 3) + 2, 'PICKED_UP', TIMESTAMPADD(DAY, n, '2026-06-03 11:00:00'), 'Pickup completed', 43.6600000 + (n / 1000), -79.3900000 - (n / 1000), 'Shipment picked up.', TRUE
FROM seed_numbers;

INSERT INTO portal_accounts (company_id, party_id, user_id, portal_type, login_email, invited_at, last_login_at, status)
SELECT n, ((n - 1) * 5) + 1, NULL, 'CUSTOMER', CONCAT('portal.customer', n, '@example.com'), TIMESTAMPADD(DAY, n, '2026-06-01 09:00:00'), NULL, 'INVITED'
FROM seed_numbers;

INSERT INTO mobile_device_sessions (company_id, user_id, device_uuid, device_name, platform, app_version, last_seen_at, push_token, status)
SELECT n, n, CONCAT('device-', LPAD(n, 4, '0')), CONCAT('Driver Phone ', n), CASE WHEN n % 2 = 0 THEN 'ANDROID' ELSE 'IOS' END, '1.0.0', TIMESTAMPADD(HOUR, n, '2026-06-01 10:00:00'), CONCAT('push-token-', n), 'ACTIVE'
FROM seed_numbers;

INSERT INTO edi_messages (company_id, trading_partner_party_id, message_type, direction, control_number, related_entity_type, related_entity_id, payload_path, status, received_or_sent_at)
SELECT n, ((n - 1) * 5) + 1, '214', 'OUTBOUND', CONCAT('CTRL-', LPAD(n, 6, '0')), 'orders', n, CONCAT('/edi/company-', n, '/214-', n, '.edi'), 'SENT', TIMESTAMPADD(DAY, n, '2026-06-03 12:00:00')
FROM seed_numbers;

INSERT INTO document_templates (company_id, template_code, template_name, entity_type, template_body, output_format, status)
SELECT n, CONCAT('BOL-', LPAD(n, 2, '0')), CONCAT('Bill of Lading Template ', n), 'orders', '<h1>Bill of Lading {{order_number}}</h1>', 'PDF', 'ACTIVE'
FROM seed_numbers;

INSERT INTO email_templates (company_id, template_code, template_name, subject_template, body_template, status)
SELECT n, CONCAT('EMAIL-', LPAD(n, 2, '0')), CONCAT('Shipment Update Email ', n), 'Shipment {{order_number}} update', 'Your shipment status is {{status}}.', 'ACTIVE'
FROM seed_numbers;

INSERT INTO import_jobs (company_id, import_type, source_file_name, source_file_path, requested_by_user_id, total_rows, success_rows, error_rows, status, started_at, finished_at)
SELECT n, 'ORDERS', CONCAT('orders-import-', n, '.xlsx'), CONCAT('/imports/company-', n, '/orders.xlsx'), n, 100, 98, 2, 'PARTIAL', TIMESTAMPADD(DAY, n, '2026-06-01 06:00:00'), TIMESTAMPADD(DAY, n, '2026-06-01 06:10:00')
FROM seed_numbers;

INSERT INTO import_job_errors (import_job_id, row_number, field_name, error_code, error_message, raw_row_json, status)
SELECT n, n + 1, 'customer_code', 'NOT_FOUND', 'Customer code was not found.', JSON_OBJECT('row',n,'customer_code','BADCODE'), 'OPEN'
FROM seed_numbers;

INSERT INTO report_definitions (company_id, report_code, report_name, module_name, query_key, default_filters_json, status, created_by_user_id)
SELECT n, CONCAT('RPT-', LPAD(n, 2, '0')), CONCAT('Dispatch Profitability ', n), 'dispatch', 'dispatch_profitability', JSON_OBJECT('dateRange','current_month'), 'ACTIVE', n
FROM seed_numbers;

INSERT INTO scheduled_reports (company_id, report_definition_id, schedule_name, cron_expression, recipient_emails, last_run_at, next_run_at, status)
SELECT n, n, CONCAT('Daily Dispatch Report ', n), '0 6 * * *', JSON_ARRAY(CONCAT('ops', n, '@example.com')), TIMESTAMPADD(DAY, n, '2026-06-01 06:00:00'), TIMESTAMPADD(DAY, n + 1, '2026-06-01 06:00:00'), 'ACTIVE'
FROM seed_numbers;

INSERT INTO webhooks (company_id, webhook_code, target_url, event_type, secret_reference, status)
SELECT n, CONCAT('WH-', LPAD(n, 2, '0')), CONCAT('https://webhook.example.com/company/', n), 'shipment.tracking.updated', CONCAT('vault:webhook:', n), 'ACTIVE'
FROM seed_numbers;

INSERT INTO webhook_deliveries (webhook_id, entity_type, entity_id, payload_json, response_status_code, response_body, attempt_count, delivered_at, status)
SELECT n, 'orders', n, JSON_OBJECT('order_id',n,'status','PICKED_UP'), 200, 'OK', 1, TIMESTAMPADD(DAY, n, '2026-06-03 12:05:00'), 'DELIVERED'
FROM seed_numbers;

INSERT INTO barcode_labels (company_id, entity_type, entity_id, label_code, barcode_format, label_payload, printed_at, status)
SELECT n, 'orders', n, CONCAT('LBL-', LPAD(n, 6, '0')), 'QR', CONCAT('ORDER:', n), TIMESTAMPADD(DAY, n, '2026-06-03 07:00:00'), 'PRINTED'
FROM seed_numbers;

DROP TEMPORARY TABLE IF EXISTS seed_numbers;
