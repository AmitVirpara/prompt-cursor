-- Sample migration mapping data for disp_trans_sql.sql
-- Run after sample1_date.sql, sample1_date_data.sql, and disp_trans_migration_support.sql.

USE logistics_erp;

SET FOREIGN_KEY_CHECKS = 0;

TRUNCATE TABLE legacy_migration_checkpoints;
TRUNCATE TABLE legacy_rejected_rows;
TRUNCATE TABLE legacy_status_mappings;
TRUNCATE TABLE legacy_field_mappings;
TRUNCATE TABLE legacy_entity_mappings;
TRUNCATE TABLE legacy_source_table_inventory;
TRUNCATE TABLE legacy_migration_batches;

SET FOREIGN_KEY_CHECKS = 1;

INSERT INTO legacy_migration_batches (
  company_id,
  source_database,
  source_file_name,
  batch_code,
  started_by_user_id,
  started_at,
  status,
  notes
) VALUES
  (1, 'iwaytransca', 'disp_trans_sql.sql', 'DISP-TRANS-BASELINE-001', 1, '2026-06-04 18:00:00', 'DRAFT', 'Baseline legacy dispatch migration mapping for real-world ERP conversion.');

INSERT INTO legacy_source_table_inventory (
  legacy_migration_batch_id,
  source_table,
  source_category,
  target_strategy,
  target_tables,
  notes,
  status
) VALUES
  (1, 'admin', 'ADMIN', 'MIGRATE', JSON_ARRAY('companies','company_settings','users'), 'Legacy company/admin defaults; do not migrate plain-text password values.', 'MAPPED'),
  (1, 'csr', 'PARTY', 'MIGRATE', JSON_ARRAY('parties','party_contacts','party_addresses','party_accounts'), 'Customer records with credit and payment terms.', 'MAPPED'),
  (1, 'suppliers', 'PARTY', 'MIGRATE', JSON_ARRAY('parties','party_contacts','party_addresses','party_accounts'), 'Supplier/carrier/vendor style records; use role to choose party_type.', 'MAPPED'),
  (1, 'contactpersons', 'PARTY', 'MIGRATE', JSON_ARRAY('party_contacts','party_addresses'), 'Legacy contact persons linked to customer/supplier IDs.', 'MAPPED'),
  (1, 'drivers', 'ASSET', 'MIGRATE', JSON_ARRAY('drivers','employees','driver_pay_schedules','driver_compliance_records','document_attachments'), 'Driver master, pay, deductions, equipment, and safety details.', 'MAPPED'),
  (1, 'trucks', 'ASSET', 'MIGRATE', JSON_ARRAY('trucks','equipment_compliance_records','document_attachments','service_schedules'), 'Truck master with plate, safety, GPS, ownership, and PM information.', 'MAPPED'),
  (1, 'trailers', 'ASSET', 'MIGRATE', JSON_ARRAY('trailer_assets','equipment_compliance_records','document_attachments','service_schedules'), 'Trailer master; infer TRAILER/CONTAINER/CHASSIS from type fields when possible.', 'MAPPED'),
  (1, 'orders', 'ORDER', 'MIGRATE', JSON_ARRAY('orders','order_rates','entity_comments','document_attachments'), 'Primary legacy order header.', 'MAPPED'),
  (1, 'order_pickups', 'ORDER', 'MIGRATE', JSON_ARRAY('order_stops','dock_appointments'), 'Pickup stops and pickup appointment data.', 'MAPPED'),
  (1, 'order_delivery', 'ORDER', 'MIGRATE', JSON_ARRAY('order_stops','dock_appointments'), 'Delivery stops and appointment data.', 'MAPPED'),
  (1, 'order_pickups_shipment', 'ORDER', 'MIGRATE', JSON_ARRAY('order_items','barcode_labels'), 'Pickup shipment pieces/dimensions/barcodes.', 'MAPPED'),
  (1, 'shipment_full_detail', 'ORDER', 'MIGRATE', JSON_ARRAY('order_items','trip_event_orders','shipment_tracking_events','barcode_labels'), 'Denormalized shipment snapshot; use for reconciliation and tracking event detail.', 'MAPPED'),
  (1, 'trips', 'TRIP', 'MIGRATE', JSON_ARRAY('trips','trip_drivers','trip_equipment','trip_expenses'), 'Legacy trip header and start/end information.', 'MAPPED'),
  (1, 'new_event', 'TRIP', 'MIGRATE', JSON_ARRAY('trip_events','trip_event_orders','yard_moves','shipment_tracking_events'), 'Detailed dispatch event rows.', 'MAPPED'),
  (1, 'trip_event_main', 'TRIP', 'MIGRATE', JSON_ARRAY('trip_events','trip_event_orders'), 'Simpler trip event rows.', 'MAPPED'),
  (1, 'Ship_Trip_rel', 'TRIP', 'MIGRATE', JSON_ARRAY('trip_event_orders','shipment_tracking_events','yard_moves'), 'Shipment/trip relation with pickup/delivery event status.', 'MAPPED'),
  (1, 'trip_drivers', 'TRIP', 'MIGRATE', JSON_ARRAY('trip_drivers','statement_lines'), 'Driver assignment and pay information.', 'MAPPED'),
  (1, 'trip_truck_rel', 'TRIP', 'MIGRATE', JSON_ARRAY('trip_equipment','trip_events'), 'Truck acquire/drop timing and event status.', 'MAPPED'),
  (1, 'trip_trailer_rel', 'TRIP', 'MIGRATE', JSON_ARRAY('trip_equipment','trip_events'), 'Trailer hook/drop timing and event status.', 'MAPPED'),
  (1, 'fuel', 'FUEL', 'MIGRATE', JSON_ARRAY('fuel_upload_batches','fuel_transactions'), 'Legacy BDE/fuel import style table.', 'MAPPED'),
  (1, 'paysettelment_master_report', 'FINANCE', 'MIGRATE', JSON_ARRAY('statement_runs','statement_lines','settlements'), 'Driver/truck/trailer settlement calculations.', 'MAPPED'),
  (1, 'make_driver_payments', 'FINANCE', 'MIGRATE', JSON_ARRAY('payments','payment_allocations'), 'Driver payment records.', 'MAPPED'),
  (1, 'account_payments', 'FINANCE', 'MIGRATE', JSON_ARRAY('payments','payment_allocations'), 'Driver/supplier account payments.', 'MAPPED'),
  (1, 'order_upload_docs', 'DOCUMENT', 'MIGRATE', JSON_ARRAY('document_attachments'), 'Order-level uploaded documents.', 'MAPPED'),
  (1, 'uploaddocs', 'DOCUMENT', 'MIGRATE', JSON_ARRAY('document_attachments'), 'General uploaded documents.', 'MAPPED'),
  (1, 'advance_filter', 'ADMIN', 'MIGRATE', JSON_ARRAY('saved_filters'), 'User saved/advanced order filters.', 'MAPPED'),
  (1, 'tasks', 'TASK', 'MIGRATE', JSON_ARRAY('task_boards','tasks','workflow_definitions'), 'Legacy task definitions and recurring task settings.', 'MAPPED'),
  (1, 'tasks_frequency', 'TASK', 'MIGRATE', JSON_ARRAY('tasks','task_boards'), 'Generated/recurring task instances.', 'MAPPED'),
  (1, 'omnitrac_gps_data', 'INTEGRATION', 'MIGRATE', JSON_ARRAY('gps_devices','gps_positions'), 'Legacy Omnitracs GPS payloads.', 'MAPPED'),
  (1, 'blogs', 'NOISE', 'IGNORE', JSON_ARRAY(), 'Non-ERP marketing/content table; keep only in archive if needed.', 'MAPPED');

INSERT INTO legacy_field_mappings (
  source_table,
  source_column,
  target_table,
  target_column,
  transform_rule,
  required_flag,
  mapping_priority,
  status
) VALUES
  ('orders', 'id', 'orders', 'order_number', 'prefix legacy ID with LEG-ORD- and keep original in legacy_entity_mappings', TRUE, 10, 'ACTIVE'),
  ('orders', 'customer', 'orders', 'customer_party_id', 'lookup legacy csr/suppliers/contactpersons through legacy_entity_mappings', TRUE, 20, 'ACTIVE'),
  ('orders', 'customer_po', 'entity_comments', 'comment_text', 'store as customer PO note when target has no dedicated PO column', FALSE, 100, 'ACTIVE'),
  ('orders', 'order_rate', 'order_rates', 'amount', 'cast varchar to DECIMAL(14,2); reject non-numeric values', FALSE, 30, 'ACTIVE'),
  ('orders', 'load_type', 'orders', 'freight_type', 'map TL/FTL to FTL, LTL to LTL, otherwise PARTIAL', FALSE, 40, 'ACTIVE'),
  ('order_pickups', 'pickup_shipper', 'order_stops', 'party_id', 'lookup shipper party mapping', TRUE, 20, 'ACTIVE'),
  ('order_pickups', 'pickup_date', 'order_stops', 'scheduled_from', 'combine pickup_date and pickup_time', FALSE, 30, 'ACTIVE'),
  ('order_delivery', 'delivery_shipper', 'order_stops', 'party_id', 'lookup receiver party mapping', TRUE, 20, 'ACTIVE'),
  ('order_delivery', 'delivery_date', 'order_stops', 'scheduled_from', 'combine delivery_date and delivery_time', FALSE, 30, 'ACTIVE'),
  ('order_pickups_shipment', 'pickup_shipment_description', 'order_items', 'item_description', 'use fallback General freight when blank', TRUE, 20, 'ACTIVE'),
  ('order_pickups_shipment', 'pickup_weight', 'order_items', 'weight_lbs', 'cast varchar to DECIMAL(12,2)', FALSE, 30, 'ACTIVE'),
  ('order_pickups_shipment', 'pickup_length', 'order_items', 'length_in', 'cast varchar to DECIMAL(10,2)', FALSE, 40, 'ACTIVE'),
  ('trips', 'id', 'trips', 'trip_number', 'prefix legacy ID with LEG-TRIP-', TRUE, 10, 'ACTIVE'),
  ('trips', 'start_datetime', 'trips', 'planned_start_at', 'copy datetime after timezone review', FALSE, 20, 'ACTIVE'),
  ('trips', 'finish_datetime', 'trips', 'planned_end_at', 'copy datetime after timezone review', FALSE, 30, 'ACTIVE'),
  ('trips', 'truck_id', 'trips', 'truck_id', 'lookup truck mapping; blank means carrier trip if carrier exists', FALSE, 40, 'ACTIVE'),
  ('new_event', 'event_type', 'trip_events', 'event_type', 'normalize to canonical trip event enum', TRUE, 10, 'ACTIVE'),
  ('new_event', 's_no', 'trip_events', 'event_order', 'use event sequence, fallback row order by id', TRUE, 20, 'ACTIVE'),
  ('new_event', 'miles', 'trip_events', 'event_miles', 'cast varchar to DECIMAL(12,2)', FALSE, 30, 'ACTIVE'),
  ('Ship_Trip_rel', 'shipment_full_detail_id', 'trip_event_orders', 'order_item_id', 'lookup order item produced from shipment_full_detail/order_pickups_shipment', FALSE, 40, 'REVIEW'),
  ('drivers', 'first_name', 'drivers', 'first_name', 'trim string', TRUE, 10, 'ACTIVE'),
  ('drivers', 'last_name', 'drivers', 'last_name', 'trim string', TRUE, 10, 'ACTIVE'),
  ('drivers', 'driver_pay_type', 'driver_pay_schedules', 'rate_type', 'normalize legacy pay type to MILE/HOUR/PERCENTAGE/FLAT', FALSE, 20, 'ACTIVE'),
  ('trucks', 'vin', 'trucks', 'vin', 'use UNKNOWN-TRUCK-id when blank but flag for review', TRUE, 10, 'ACTIVE'),
  ('trailers', 'vin', 'trailer_assets', 'vin_or_serial', 'use UNKNOWN-ASSET-id when blank but flag for review', TRUE, 10, 'ACTIVE'),
  ('fuel', 'date_t', 'fuel_transactions', 'transaction_at', 'copy datetime as UTC or company timezone according to import setting', TRUE, 10, 'ACTIVE'),
  ('fuel', 'fuel_qty', 'fuel_transactions', 'gallons', 'cast DECIMAL(12,3)', TRUE, 20, 'ACTIVE'),
  ('fuel', 'total_amt', 'fuel_transactions', 'total_amount', 'cast DECIMAL(14,2)', TRUE, 30, 'ACTIVE'),
  ('order_upload_docs', 'upload_doc', 'document_attachments', 'file_path', 'prefix with legacy document storage path', TRUE, 10, 'ACTIVE'),
  ('advance_filter', 'filter_name', 'saved_filters', 'filter_name', 'copy and convert criteria columns to filter_json', TRUE, 10, 'ACTIVE');

INSERT INTO legacy_status_mappings (
  source_table,
  source_column,
  source_value,
  target_table,
  target_column,
  target_value,
  notes,
  status
) VALUES
  ('orders', 'delete_status', '0', 'orders', 'status', 'READY', 'Active legacy order; final status still refined from order_status/order_progress.', 'ACTIVE'),
  ('orders', 'delete_status', '1', 'orders', 'status', 'CANCELLED', 'Deleted legacy order maps to cancelled unless accounting history says closed.', 'ACTIVE'),
  ('orders', 'load_type', 'FTL', 'orders', 'freight_type', 'FTL', 'Full truckload.', 'ACTIVE'),
  ('orders', 'load_type', 'LTL', 'orders', 'freight_type', 'LTL', 'Less-than-truckload.', 'ACTIVE'),
  ('orders', 'load_type', 'TL', 'orders', 'freight_type', 'FTL', 'Legacy TL synonym.', 'ACTIVE'),
  ('Ship_Trip_rel', 'event_status', 'preplan', 'trip_events', 'event_status', 'PLANNED', 'Legacy preplan status.', 'ACTIVE'),
  ('Ship_Trip_rel', 'event_status', 'planned', 'trip_events', 'event_status', 'PLANNED', 'Legacy planned status.', 'ACTIVE'),
  ('Ship_Trip_rel', 'event_status', 'dispatched', 'trip_events', 'event_status', 'DISPATCHED', 'Legacy dispatched status.', 'ACTIVE'),
  ('Ship_Trip_rel', 'event_status', 'complete', 'trip_events', 'event_status', 'COMPLETED', 'Legacy complete status.', 'ACTIVE'),
  ('trip_truck_rel', 'aquire_status', 'complete', 'trip_events', 'event_status', 'COMPLETED', 'Truck acquired.', 'ACTIVE'),
  ('trip_trailer_rel', 'hooked_status', 'complete', 'trip_events', 'event_status', 'COMPLETED', 'Trailer hooked.', 'ACTIVE'),
  ('shipment_full_detail', 'pickup_done', '1', 'shipment_tracking_events', 'tracking_status', 'PICKED_UP', 'Pickup finished for shipment.', 'ACTIVE'),
  ('shipment_full_detail', 'delivery_done', '1', 'shipment_tracking_events', 'tracking_status', 'DELIVERED', 'Delivery finished for shipment.', 'ACTIVE'),
  ('drivers', 'delete_status', '0', 'drivers', 'status', 'ACTIVE', 'Driver active.', 'ACTIVE'),
  ('drivers', 'delete_status', '1', 'drivers', 'status', 'INACTIVE', 'Driver deleted/inactive.', 'ACTIVE'),
  ('trucks', 'delete_status', '0', 'trucks', 'status', 'AVAILABLE', 'Truck active; current trip may override status.', 'ACTIVE'),
  ('trucks', 'delete_status', '1', 'trucks', 'status', 'INACTIVE', 'Truck deleted/inactive.', 'ACTIVE'),
  ('trailers', 'delete_status', '0', 'trailer_assets', 'status', 'AVAILABLE', 'Asset active; current trip may override status.', 'ACTIVE'),
  ('trailers', 'delete_status', '1', 'trailer_assets', 'status', 'INACTIVE', 'Asset deleted/inactive.', 'ACTIVE'),
  ('tasks_frequency', 'isTaskCompleted', '1', 'tasks', 'status', 'DONE', 'Completed generated task.', 'ACTIVE');

INSERT INTO legacy_entity_mappings (
  legacy_migration_batch_id,
  company_id,
  source_table,
  source_pk,
  source_natural_key,
  target_table,
  target_pk,
  source_hash,
  migration_status
) VALUES
  (1, 1, 'orders', '1', 'LEG-ORD-1', 'orders', 1, SHA2('orders:1', 256), 'MAPPED'),
  (1, 1, 'trips', '1', 'LEG-TRIP-1', 'trips', 1, SHA2('trips:1', 256), 'MAPPED'),
  (1, 1, 'drivers', '1', 'LEG-DRV-1', 'drivers', 1, SHA2('drivers:1', 256), 'MAPPED'),
  (1, 1, 'trucks', '1', 'LEG-TRK-1', 'trucks', 1, SHA2('trucks:1', 256), 'MAPPED'),
  (1, 1, 'trailers', '1', 'LEG-TRL-1', 'trailer_assets', 1, SHA2('trailers:1', 256), 'MAPPED'),
  (1, 1, 'csr', '1', 'LEG-CUS-1', 'parties', 1, SHA2('csr:1', 256), 'MAPPED'),
  (1, 1, 'suppliers', '1', 'LEG-SUP-1', 'parties', 4, SHA2('suppliers:1', 256), 'MAPPED'),
  (1, 1, 'order_pickups', '1', 'LEG-PU-1', 'order_stops', 1, SHA2('order_pickups:1', 256), 'MAPPED'),
  (1, 1, 'order_delivery', '1', 'LEG-DEL-1', 'order_stops', 2, SHA2('order_delivery:1', 256), 'MAPPED'),
  (1, 1, 'new_event', '1', 'LEG-EVT-1', 'trip_events', 1, SHA2('new_event:1', 256), 'MAPPED');

INSERT INTO legacy_rejected_rows (
  legacy_migration_batch_id,
  source_table,
  source_pk,
  target_table,
  error_code,
  error_message,
  source_payload,
  status
) VALUES
  (1, 'orders', 'SAMPLE-BAD-DATE', 'orders', 'INVALID_DATE', 'Order date was blank or not parseable.', JSON_OBJECT('order_date',''), 'OPEN'),
  (1, 'order_pickups_shipment', 'SAMPLE-BAD-WEIGHT', 'order_items', 'INVALID_DECIMAL', 'Weight could not be converted to a decimal value.', JSON_OBJECT('pickup_weight','abc'), 'OPEN'),
  (1, 'trucks', 'SAMPLE-BLANK-VIN', 'trucks', 'MISSING_REQUIRED', 'VIN was blank; generated placeholder requires review.', JSON_OBJECT('vin',''), 'RETRY_READY'),
  (1, 'trailers', 'SAMPLE-BLANK-SERIAL', 'trailer_assets', 'MISSING_REQUIRED', 'VIN/serial was blank; generated placeholder requires review.', JSON_OBJECT('vin',''), 'RETRY_READY'),
  (1, 'new_event', 'SAMPLE-BAD-EVENT', 'trip_events', 'UNKNOWN_EVENT_TYPE', 'Event type was not recognized.', JSON_OBJECT('event_type','unknown'), 'OPEN'),
  (1, 'fuel', 'SAMPLE-BAD-AMOUNT', 'fuel_transactions', 'INVALID_DECIMAL', 'Fuel amount could not be converted to decimal.', JSON_OBJECT('total_amt','n/a'), 'OPEN'),
  (1, 'drivers', 'SAMPLE-NO-NAME', 'drivers', 'MISSING_REQUIRED', 'Driver first and last name are both blank.', JSON_OBJECT('first_name','','last_name',''), 'OPEN'),
  (1, 'csr', 'SAMPLE-DUP-CUSTOMER', 'parties', 'DUPLICATE_CODE', 'Customer natural key matched more than one target party.', JSON_OBJECT('name','Duplicate Customer'), 'OPEN'),
  (1, 'Ship_Trip_rel', 'SAMPLE-NO-SHIPMENT', 'trip_event_orders', 'MISSING_MAPPING', 'Referenced shipment_full_detail row has no target item mapping.', JSON_OBJECT('shipment_full_detail_id',999), 'OPEN'),
  (1, 'order_upload_docs', 'SAMPLE-NO-FILE', 'document_attachments', 'MISSING_FILE', 'Legacy file path was empty or file missing from archive.', JSON_OBJECT('upload_doc',''), 'OPEN');

INSERT INTO legacy_migration_checkpoints (
  legacy_migration_batch_id,
  step_code,
  step_name,
  source_table,
  processed_rows,
  inserted_rows,
  updated_rows,
  rejected_rows,
  status
) VALUES
  (1, '01_COMPANY_SECURITY', 'Migrate company, users, roles, and permissions', 'admin', 0, 0, 0, 0, 'PENDING'),
  (1, '02_PARTIES', 'Migrate customers, suppliers, contact persons, brokers, terminals', 'csr', 0, 0, 0, 0, 'PENDING'),
  (1, '03_ASSETS', 'Migrate drivers, trucks, trailers, safety docs, pay settings', 'drivers', 0, 0, 0, 0, 'PENDING'),
  (1, '04_ORDERS', 'Migrate orders, stops, items, rates, notes, documents', 'orders', 0, 0, 0, 0, 'PENDING'),
  (1, '05_TRIPS', 'Migrate trips, equipment, drivers, events, shipment relations', 'trips', 0, 0, 0, 0, 'PENDING'),
  (1, '06_FINANCE', 'Migrate settlements, payments, fuel, charges, deductions', 'paysettelment_master_report', 0, 0, 0, 0, 'PENDING'),
  (1, '07_TRACKING', 'Migrate GPS, shipment tracking, PAPS/PARS, documents', 'omnitrac_gps_data', 0, 0, 0, 0, 'PENDING'),
  (1, '08_TASKS_FILTERS', 'Migrate tasks, messages, saved filters, user preferences', 'tasks', 0, 0, 0, 0, 'PENDING'),
  (1, '09_RECONCILE', 'Run row counts, financial totals, and shipment status reconciliation', NULL, 0, 0, 0, 0, 'PENDING'),
  (1, '10_CUTOVER', 'Freeze legacy writes, rerun delta migration, and switch users', NULL, 0, 0, 0, 0, 'PENDING');
