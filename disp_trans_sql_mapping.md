# `disp_trans_sql.sql` Migration Mapping

This document maps the legacy `disp_trans_sql.sql` database dump into the normalized Logistics ERP schema created in:

- `sample1_date.sql`
- `step_2_missing_functionality.sql`
- `disp_trans_migration_support.sql`

The legacy dump is a MySQL 5.6/phpMyAdmin export for database `iwaytransca`. It contains 139 tables and no data inserts in the checked-in file. Many tables are denormalized, use `varchar` for amounts/dates/foreign keys, use MyISAM without foreign keys, and contain duplicate working/history tables such as `_main` variants.

## Migration principle

Do not use the legacy tables as production tables in the new ERP. Load `disp_trans_sql.sql` into a staging database, migrate into the canonical ERP tables, and preserve old IDs using `legacy_entity_mappings`.

Recommended staging database name:

```sql
CREATE DATABASE legacy_iwaytransca;
```

Then import the legacy dump into staging and migrate into `logistics_erp`.

## Required migration support

Use `disp_trans_migration_support.sql` for:

- `legacy_migration_batches`
- `legacy_source_table_inventory`
- `legacy_entity_mappings`
- `legacy_field_mappings`
- `legacy_status_mappings`
- `legacy_rejected_rows`
- `legacy_migration_checkpoints`

Use `disp_trans_migration_support_data.sql` for starter mapping rules, status mappings, rejected-row examples, and checkpoint order.

## High-level table categories

### Company, users, security

| Legacy table | Target table(s) | Notes |
| --- | --- | --- |
| `admin` | `companies`, `company_settings`, `users` | Company/admin defaults. Do not migrate plaintext password values. |
| `users` | `users`, `employees`, `user_roles` | User accounts; reset passwords during cutover. |
| `roles` | `roles` | Normalize role names and company scope. |
| `security_groups` | `roles` | Treat security groups as roles. |
| `security_group_users` | `user_roles` | User-role assignments. |
| `group_security_permission` | `permissions`, `role_permissions` | Convert legacy permission flags to module/action keys. |
| `user_activity` | `audit_logs` | Historical activity. |
| `user_attendance` | `attendance_logs` | HR attendance. |
| `advance_filter`, `filter` | `saved_filters` | Convert old filter columns into `filter_json`. |

### Parties, contacts, addresses

| Legacy table | Target table(s) | Notes |
| --- | --- | --- |
| `csr` | `parties`, `party_contacts`, `party_addresses`, `party_accounts` | Customer records with credit limit, payment terms, rating, blacklist. |
| `suppliers` | `parties`, `party_contacts`, `party_addresses`, `party_accounts` | Role determines supplier/carrier/vendor. |
| `contactpersons` | `party_contacts`, `party_addresses` | Link by `customer` or `supplier`. |
| `custombrokers` | `parties`, `party_contacts` | Use party_type `BROKER`. |
| `repairshops` | `parties`, `party_contacts`, `party_addresses` | Use party_type `SUPPLIER`. |
| `terminals` | `terminals`, `predefined_addresses` | Also create address records for dispatch use. |
| `countries`, `states`, `cities`, `zip` | reference data or `predefined_addresses` | Use for address cleanup; do not require as production transactional tables. |

### Orders, stops, shipments

| Legacy table | Target table(s) | Notes |
| --- | --- | --- |
| `orders` | `orders`, `order_rates`, `entity_comments` | Primary active order header. Prefix old ID as `LEG-ORD-{id}` if no order number exists. |
| `orders_main` | archive/reference | Snapshot or alternate order header. Use only if `orders` is incomplete. |
| `order_pickups` | `order_stops`, `dock_appointments` | Create stop_type `PICKUP`. Combine `pickup_date` and `pickup_time`. |
| `order_pickups_main` | archive/reference | Historical or main-copy pickup data. |
| `order_delivery`, `order_delivery_new` | `order_stops`, `dock_appointments` | Create stop_type `DELIVERY`. |
| `order_delivery_main` | archive/reference | Historical or main-copy delivery data. |
| `order_pickups_shipment` | `order_items`, `barcode_labels` | Pickup item/piece data. |
| `order_pickups_shipment_main` | archive/reference | Use only when active shipment rows are missing. |
| `order_delivery_shipments` | `order_items`, `shipment_tracking_events` | Delivery-side shipment data. |
| `order_delivery_shipments_meta` | `order_items` or `entity_comments` | Additional item metadata. |
| `shipment_full_detail` | `order_items`, `trip_event_orders`, `shipment_tracking_events`, `barcode_labels` | Denormalized shipment state; use for reconciliation. |
| `shipment_full_detail_main` | archive/reference | Main-copy shipment snapshot. |
| `order_additional_charges` | `order_rates` | Additional customer charges. |
| `additionalcharges` | charge-code lookup or `order_rates.rate_code` | Normalize common charge names. |
| `order_revenues` | `order_rates`, `trip_expenses`, reports | Use to reconcile profitability, not as source of truth. |
| `order_notes`, `order_notes_main` | `entity_comments` | `visibility = INTERNAL`. |
| `order_upload_docs`, `order_upload_docs_main` | `document_attachments` | Document type can be inferred from filename/name. |
| `order_alt_emails` | `party_contacts` or `entity_comments` | Use for notification recipients. |
| `order_groups`, `orderlane` | `address_lanes`, `saved_filters`, tags | Lanes/groups for dispatch filtering. |

### Trips, events, equipment assignment

| Legacy table | Target table(s) | Notes |
| --- | --- | --- |
| `trips` | `trips`, `trip_drivers`, `trip_equipment`, `trip_expenses` | Legacy trip header. Determine company truck vs carrier by truck/carrier fields. |
| `new_trip`, `trip_main`, `trip_master` | archive/reference or `trips` | Use as fallback if `trips` lacks values. |
| `new_event` | `trip_events`, `trip_event_orders`, `yard_moves`, `shipment_tracking_events` | Most detailed event source. |
| `trip_event_main` | `trip_events`, `trip_event_orders` | Event rows with location, status, miles, shipment references. |
| `trip_stops` | `trip_events`, `predefined_addresses` | Stop location references. |
| `trips_assigned_orders`, `trips_assigned_orders1` | `trip_event_orders`, `trip_events` | Links orders/stops to trips. |
| `Ship_Trip_rel` | `trip_event_orders`, `shipment_tracking_events`, `yard_moves` | Shipment-to-trip relation with pickup/delivery state. |
| `trip_truck_rel` | `trip_equipment`, `trip_events` | Map acquire/drop truck activity. |
| `trip_trailer_rel` | `trip_equipment`, `trip_events` | Map hook/drop trailer activity. |
| `trip_drivers` | `trip_drivers`, `statement_lines` | Driver assignment plus pay detail. |
| `drivers_assigned_trips` | `trip_drivers` | Assignment windows. |
| `trucks_assigned_trips` | `trip_equipment` | Truck assignment windows. |
| `trailers_assigned_trips` | `trip_equipment` | Trailer assignment windows. |
| `trip_rate`, `trip_agreed_rate_main`, `new_agreed_rate` | `bills`, `bill_lines`, `statement_lines`, `carrier_rate_agreements` | Carrier/driver/vendor pay rates. |
| `trip_meta_ept` | `trip_expenses`, `statement_lines` | Extra pay or expense type rows. |
| `trip_truck_paytype` | `statement_lines`, `trip_expenses` | Truck pay type and extra pay details. |

### Fleet, drivers, safety, inventory

| Legacy table | Target table(s) | Notes |
| --- | --- | --- |
| `drivers` | `drivers`, `employees`, `driver_pay_schedules`, `driver_compliance_records`, `document_attachments` | Includes address, pay, equipment, deduction, safety data. |
| `driver_meta_paytype` | `driver_pay_schedules` | Rate type and rate. |
| `driver_meta_extrapaytype` | `statement_lines` or pay schedule extras | Extra driver pay. |
| `driver_meta_safety_doc` | `driver_compliance_records`, `document_attachments` | License/safety docs and expiry. |
| `driver_meta_equipment` | `equipment_item_assignments` | Items issued to drivers/parties. |
| `driver_meta_deduction`, `drivers_deductions_master` | `statement_lines`, `settlement_lines` | Deductions/payroll settlement adjustments. |
| `driver_activation_history` | `audit_logs` | Driver status history. |
| `trucks` | `trucks`, `equipment_compliance_records`, `document_attachments`, `service_schedules` | Truck master and compliance/service values. |
| `truckplates` | `equipment_compliance_records` | Registration/plate details. |
| `truck_meta_paytype`, `truck_meta_extrapaytype` | `statement_lines`, pay schedules/reports | Truck pay/extra pay. |
| `truck_meta_safety_doc` | `equipment_compliance_records`, `document_attachments` | Truck safety documents. |
| `trailers` | `trailer_assets`, `equipment_compliance_records`, `document_attachments`, `service_schedules` | Infer `asset_type` as TRAILER/CONTAINER/CHASSIS from type/unit/name where possible. |
| `trailer_meta_paytype`, `trailer_meta_extrapaytype` | `statement_lines` | Trailer pay and extra pay. |
| `trailer_meta_safety_doc` | `equipment_compliance_records`, `document_attachments` | Trailer compliance documents. |
| `equipments` | `inventory_items`, `inventory_stock_movements` | Inventory master. |
| `equipment_return_log` | `inventory_stock_movements` | Return movement. |
| `in_usage` | `equipment_item_assignments` | Inventory issued to assets/drivers. |
| `pickupequipments` | `order_items` or `inventory_stock_movements` | Equipment required/used at pickup. |

### Finance, fuel, settlements

| Legacy table | Target table(s) | Notes |
| --- | --- | --- |
| `fuel` | `fuel_upload_batches`, `fuel_transactions` | BDE-style fuel detail. Preserve `auth_code` or external transaction ID. |
| `paysettelment_master_report` | `statement_runs`, `statement_lines`, `settlements` | Driver/truck/trailer/carrier settlement details. |
| `make_driver_payments` | `payments`, `payment_allocations` | Driver payment records. |
| `account_payments` | `payments`, `payment_allocations` | Driver/supplier account payments. |
| `deductions` | deduction lookup or `statement_lines` | Settlement deduction type. |
| `recharges` | `statement_lines`, `invoice_lines`, `bill_lines` | Recharge/adjustment entries. |
| `pay_types`, `extrapay_types` | pay schedule/rate lookup | Normalize to enums and reference data. |
| `currency` | `currencies`, `daily_currency_rates` | Normalize currency codes. |
| `saletax` | `tax_codes` | Tax code setup. |

### Documents, tracking, integrations, tasks

| Legacy table | Target table(s) | Notes |
| --- | --- | --- |
| `uploaddocs` | `document_attachments` | General uploaded files. |
| `safetydocs` | `document_types`, compliance records | Safety document catalog. |
| `omnitrac_gps_data` | `gps_devices`, `gps_positions` | GPS data; convert to UTC. |
| `paps_master`, `pars_master`, `paps_pars_generate`, `codes`, `codes1` | `document_attachments`, `entity_comments`, `shipment_tracking_events` | Border/customs references. |
| `messages`, `conversation`, `main_message` | `entity_comments`, `notifications`, `notification_deliveries` | Message history. |
| `tasks`, `tasks_frequency`, `task_reference`, `task_reference_frequency` | `task_boards`, `tasks`, `workflow_definitions`, `workflow_steps` | Recurring and dependent tasks. |
| `api_keys` | `api_integrations` | Store secrets in vault/secret reference, not plain columns. |
| `backup` | archive only | Operational backup metadata. |
| `blogs`, `videos`, `news_feed`, `bookings`, `merchants`, `category` | ignore/archive | Non-logistics or unrelated application tables in the dump. |

## Legacy status mapping

| Legacy status | Canonical status |
| --- | --- |
| `preplan` | `PLANNED` |
| `planned` | `PLANNED` |
| `dispatched` | `DISPATCHED` |
| `complete` | `COMPLETED` |
| `delete_status = 0` | active/available/ready depending on table |
| `delete_status = 1` | inactive/cancelled |
| `pickup_done = 1` | `PICKED_UP` tracking event |
| `delivery_done = 1` | `DELIVERED` tracking event |
| `pod_received = 1` | verified POD document/tracking event |

## Event type normalization

Legacy event labels are free text. Normalize using keyword rules first, then manual review:

| Legacy text contains | Target `trip_events.event_type` |
| --- | --- |
| acquire, truck | `ACQUIRE_TRUCK` |
| hook, trailer | `HOOK_TRAILER` |
| pickup, load, shipper | `PICKUP_LOAD` |
| delivery, receiver, drop load | `DELIVER_LOAD` |
| drop, dock | `DROP_DOCK` |
| yard | `DROP_YARD` |
| chassis, hook | `HOOK_CHASSIS` |
| chassis, drop | `DROP_CHASSIS` |
| lift on, container | `LIFT_ON_CONTAINER` |
| lift off, container | `LIFT_OFF_CONTAINER` |
| return | `RETURN_LOAD` |
| destroy | `DESTROY_LOAD` |
| cross dock | `CROSS_DOCK` |
| unknown | `CUSTOM` plus rejected-row/manual-review task |

## Migration sequence

1. Import `disp_trans_sql.sql` into a staging database.
2. Run `sample1_date.sql`, `sample1_date_data.sql`, `step_2_missing_functionality.sql`, `step_2_missing_functionality_data.sql`, `disp_trans_migration_support.sql`.
3. Insert the mapping seed using `disp_trans_migration_support_data.sql`.
4. Create a `legacy_migration_batches` row for the production migration.
5. Migrate company/security/reference tables.
6. Migrate parties and addresses.
7. Migrate drivers, trucks, trailers, safety documents, inventory.
8. Migrate orders, stops, items, rates, documents, notes.
9. Migrate trips, events, assigned orders, drivers, equipment, yard/dock events.
10. Migrate fuel, settlements, payments, deductions, recharge/extra pay rows.
11. Migrate GPS/tracking, PAPS/PARS, messages, tasks, filters.
12. Reconcile:
    - order counts
    - stop counts
    - shipment item counts
    - trip counts
    - trip-event sequence counts
    - customer AR totals
    - driver/carrier settlement totals
    - fuel gallons and amount totals
    - document counts
13. Freeze legacy writes, rerun delta migration, and cut over users.

## Data quality rules

- Reject rows with unparseable money/date fields unless a safe default is explicitly approved.
- Preserve the raw legacy row in `legacy_rejected_rows.source_payload` for correction.
- Generate placeholder VIN/serial only when needed, and flag the row for review.
- Convert old `varchar` amounts to DECIMAL using strict parsing.
- Convert GPS/ELD/tracking timestamps to UTC.
- Keep old IDs in `legacy_entity_mappings`; do not add legacy ID columns to every production table.
- Keep `_main` tables as fallback/reference unless row counts prove they contain the current record set.
- Keep unrelated non-logistics tables in archive only.

## Real-world application behavior after migration

- Users work only in the new Angular/Laravel/Spring Boot ERP screens.
- Legacy IDs are searchable through a migration lookup endpoint backed by `legacy_entity_mappings`.
- Dispatchers see migrated trips as normal `trips` with ordered `trip_events`.
- Accounting users see migrated charges as invoices, bills, statement lines, settlements, and payments.
- Customers/carriers see migrated documents and tracking events through the portal only if `is_customer_visible = TRUE`.
