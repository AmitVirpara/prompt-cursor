# Laravel 12 Backend Prompt: Logistics ERP API

Build a Laravel 12 backend API for the Logistics ERP described in `main-prompt.md`. Use MySQL 8 and the schema in `sample1_date.sql` as the database contract. Seed/demo data is provided in `sample1_date_data.sql`.

## Technical direction

- Use Laravel 12, PHP 8.3+, MySQL 8, queues, scheduler, policies, form requests, API resources, and events/listeners.
- Implement token-based authentication suitable for SPA use.
- Every request must resolve active company context and enforce `company_id` scoping.
- Use policies/permissions for module actions.
- Use transactions for multi-table workflows such as order creation, trip planning, invoice generation, fuel import, and settlement approval.
- Use database indexes from the SQL schema; do not bypass company/status filters on large tables.
- Store files in object storage or local disk abstraction and record metadata in `document_attachments`.

## Modules and API resources

1. Auth and company context
   - Login, logout, refresh/session endpoint.
   - Current user profile, roles, permissions, available companies.
   - Select active company.

2. Administration
   - CRUD: companies, company_settings, financial_years.
   - CRUD: currencies and daily_currency_rates.
   - Scheduled currency-rate sync using a pluggable provider interface.
   - CRUD: roles, permissions, role_permissions, users, user_roles, menus, designations.

3. Parties and addresses
   - CRUD: party_groups, parties, party_contacts, party_addresses.
   - CRUD: predefined_addresses and address_lanes.
   - Validation: party code unique by company; address lane unique by company/from/to.

4. Fleet
   - CRUD: trucks, trailer_assets, drivers.
   - CRUD: fuel_cards and truck_fuel_card_assignments.
   - CRUD: gps_devices and read APIs for gps_positions.
   - CRUD: equipment_compliance_records and driver_compliance_records.

5. Documents
   - Upload, download, verify, reject, expire.
   - Entity document listing by `entity_type` and `entity_id`.
   - Document expiry report.
   - Validate file type and size.

6. Fuel
   - Excel upload endpoint that creates `fuel_upload_batches`.
   - Parser service that imports `fuel_transactions`.
   - BDE API sync job using `api_integrations` and `integration_sync_logs`.
   - Matching logic for truck, driver, fuel card, odometer, and external transaction ID.

7. Orders
   - Create/update orders with header, stops, items, documents, and rates in one transaction.
   - Validate FTL/LTL/partial/intermodal order rules.
   - Validate pickup/delivery sequence and partial/return/destroy scenarios.
   - Endpoints to transition statuses: draft, validating, ready, planned, in_transit, partial_delivered, delivered, returned, destroyed, cancelled, closed.

8. Trips and dispatch
   - Create company truck trip or carrier trip from ready orders.
   - Assign drivers, truck, trailer/container/chassis.
   - Manage ordered `trip_events` and related `trip_event_orders`.
   - Event workflow endpoints for acquire truck, hook/drop trailer, pickup, drop yard/dock, hook/drop chassis, lift on/off container, deliver, return, destroy, cross-dock.
   - Calculate trip planned and actual miles from event miles.
   - Manage trip expenses, PTI records, cross-dock jobs, documents, and accounting verification.

9. Accounting
   - CRUD: chart_of_accounts and party_accounts.
   - Generate invoices from approved order rates.
   - Generate bills from carrier trips and approved expenses.
   - Generate statement runs/lines for drivers, trucks, trailers, carriers, employees, customers, and suppliers.
   - Generate settlements from approved statements.
   - Accounting verification queue for trips, events, expenses, and PTI.

10. HR
    - CRUD: employees, designations, employee_pay_schedules.
    - CRUD: leave types, leave requests, attendance logs.
    - Payroll run generation and approval.

11. Claims and compliance
    - CRUD: claims and claim_events.
    - Claim status transitions.
    - Compliance expiry dashboards.

12. Inventory
    - CRUD: inventory_categories, inventory_items, inventory_locations.
    - Post inventory_stock_movements.
    - Assign inventory items to trucks, trailers, chassis, containers, and drivers.

13. Integrations and audit
    - CRUD: api_integrations.
    - Sync log reporting.
    - Middleware/listeners for `audit_logs`.

## Cross-cutting implementation rules

- Use FormRequest classes for validation.
- Use API Resource classes for output transformation.
- Use enums or constants matching SQL enum values.
- Use service classes for business workflows; keep controllers thin.
- Use policies or gates for every mutation.
- Return consistent JSON: `data`, `meta`, `links`, `errors`.
- Use cursor or page pagination for list endpoints.
- Add filters for company, status, date range, code/number, party, truck, driver, and accounting status where relevant.
- Use queued jobs for imports, API sync, document processing, statement generation, and notification tasks.
- Add audit logs after successful create/update/delete/status transition.

## Testing requirements

- Feature tests for auth, company scoping, RBAC, order creation, trip creation, trip event sequencing, fuel upload, document upload, accounting verification, statement generation.
- Unit tests for calculators: shipment weight/volume, trip miles, order totals, invoice totals, settlement totals.
- Database tests must use migrations matching `sample1_date.sql`.

## Step 2 backend modules

Implement the extension schema and workflows from `step_2_prompt.md` and `step_2_missing_functionality.sql`:

- Preferences, saved filters, dashboard widgets, notifications, deliveries, comments, task boards, tasks, tags, approvals, and workflow definitions.
- Tax codes, bank accounts, payments, payment allocations, quote requests, quotes, quote lines, customer contracts, contract lanes, carrier rate agreements, carrier rate lanes, load tenders, and tender responses.
- Dock appointments, yard spots, yard moves, maintenance work orders, service schedules, insurance policies, accident incidents, HOS logs, ELD events, shipment tracking events, portal accounts, mobile device sessions, EDI messages, templates, import jobs/errors, reports, scheduled reports, webhooks, webhook deliveries, and barcode labels.
- Jobs for notification delivery, tender expiry, service reminders, insurance/compliance expiry, import processing, EDI processing, report scheduling, webhook retries, and shipment tracking publication.
- Implement the `disp_trans_sql.sql` migration layer using `disp_trans_sql_mapping.md`, `disp_trans_migration_support.sql`, and `disp_trans_migration_support_data.sql`. It must load legacy `iwaytransca` rows from staging, write crosswalks to `legacy_entity_mappings`, convert dispatch transactions into `orders`, `order_stops`, `order_items`, `trips`, `trip_events`, `trip_event_orders`, `trip_equipment`, `trip_drivers`, `trip_expenses`, `invoices`, `bills`, `payments`, `document_attachments`, and capture bad rows in `legacy_rejected_rows`.

Add feature tests for quote-to-order, carrier tender response, dock appointment check-in, yard move, work order close, payment allocation, approval workflow, HOS certification, shipment tracking event visibility, import error handling, webhook retry, and EDI 214 generation.
