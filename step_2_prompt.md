# Step 2 Prompt: Real-World Easy-to-Use Logistics ERP

Extend the Logistics ERP from `main-prompt.md`, `sample1_date.sql`, and `sample1_date_data.sql` into a production-ready, easy-to-use system. Use `step_2_missing_functionality.sql`, `step_2_missing_functionality_data.sql`, `disp_trans_sql_mapping.md`, and `disp_trans_migration_support.sql` for missing real-world modules and legacy dispatch migration.

Important source note: `disp_trans_sql.sql` is now included as a legacy MySQL 5.6/phpMyAdmin dispatch database dump for `iwaytransca`. Treat it as a staging/migration source only. Use `disp_trans_sql_mapping.md` and `disp_trans_migration_support.sql` to map its tables/columns into the canonical schema instead of building a second duplicate transaction model.

## Product goal

Create a fast, simple, scalable ERP where dispatchers, accounting users, drivers, managers, customers, and carriers can complete daily work with minimum clicks. The system must work for real transport companies that manage many orders, trips, trucks, trailers, chassis, containers, yards, documents, rates, invoices, settlements, fuel transactions, and compliance items.

## Step-2 missing functionality to add

1. Easy user experience
   - User preferences for theme, density, default terminal, default filters, saved columns, and dispatch board layout.
   - Saved filters for every list screen.
   - Dashboard widgets per user and company.
   - Fast global search by order, trip, truck, trailer, driver, customer, carrier, invoice, bill, claim, and document.
   - Command palette for quick actions: create order, create trip, upload POD, add fuel, check truck, approve trip.
   - Keyboard shortcuts for dispatch board.

2. Notifications and collaboration
   - Notification center with in-app, email, SMS, push, and webhook channels.
   - Tasks linked to orders, trips, claims, maintenance, documents, and accounting items.
   - Entity comments with internal/customer/carrier visibility.
   - Tags for priority loads, hot loads, claims, compliance issues, and VIP customers.

3. Approvals and workflows
   - Configurable workflow definitions and workflow steps.
   - Approval requests and approval actions for trip accounting verification, invoice approval, settlement approval, maintenance approval, claim approval, and fuel exception approval.
   - Workflow status must be visible on list screens and detail screens.

4. Real accounting and payments
   - Tax codes by country/state.
   - Bank accounts and GL account link.
   - Customer receipt, vendor payment, driver payment, employee payment, and refund records.
   - Payment allocations against invoices, bills, settlements, payroll, and adjustments.
   - Reconciliation status for posted payments.

5. Quotes, contracts, and rates
   - Quote requests before order creation.
   - Quotes and quote lines.
   - Convert accepted quote to order.
   - Customer contracts and contract lanes.
   - Carrier rate agreements and carrier rate lanes.
   - Rate lookup rules: customer contract first, then quote, then spot rate, then manual override.

6. Carrier tendering
   - Load tenders for carrier trips.
   - Tender response tracking: accepted, rejected, countered, expired.
   - Expiry notifications and automatic tender status updates.

7. Yard, dock, and appointment scheduling
   - Dock appointments for pickup, delivery, cross-dock, PTI, and maintenance.
   - Yard spots with availability, occupancy, blocked, and maintenance status.
   - Yard moves for trucks, trailers, containers, and chassis.
   - Appointment calendar and yard map UI.

8. Maintenance and service
   - Maintenance work orders and work order lines.
   - Preventive service schedules based on days and miles.
   - Maintenance cost capture linked to inventory items, suppliers, and documents.
   - Automatic reminders for due/overdue service.

9. Insurance, incidents, safety
   - Insurance policies by company/equipment/driver/order.
   - Accident and incident records linked to trip, order, driver, equipment, and claim.
   - Incident workflow from open to investigation to claim to closed.

10. Driver HOS and ELD
    - Driver HOS logs with UTC start/end times.
    - ELD events for engine, login, duty change, malfunction, diagnostic, and location.
    - HOS certification and correction workflow.

11. Shipment visibility and portals
    - Customer-visible shipment tracking events.
    - Portal accounts for customers, carriers, suppliers, and drivers.
    - Customer portal: quotes, orders, tracking, documents, invoices.
    - Carrier portal: tenders, trip documents, status updates, invoices/bills.
    - Driver mobile: trip events, GPS, POD upload, PTI, fuel receipt upload, HOS summary.

12. EDI and integrations
    - EDI 204 tender, 990 response, 214 tracking, 210 invoice, and 997 acknowledgement.
    - Webhook subscriptions and webhook delivery retry logs.
    - Import jobs and import row errors for Excel/CSV/API imports.
    - Scheduled report delivery.

13. Templates, labels, and documents
    - Document templates for BOL, rate confirmation, invoice, POD, settlement, inspection, claim letter.
    - Email templates for shipment updates, tender, invoice, payment, document expiry, claim updates.
    - Barcode/QR labels for orders, pallets, trailers, containers, inventory, and documents.

14. Reporting
    - Report definitions with filters and scheduled reports.
    - Reports required: dispatch profitability, on-time pickup/delivery, driver pay, carrier pay, fuel cost, maintenance cost, claims, compliance expiry, AR aging, AP aging, inventory valuation.

## Legacy dispatch transaction SQL mapping rules

Use `disp_trans_sql.sql` as follows:

1. Inventory its tables and columns.
2. Identify dispatch transaction concepts:
   - Loads/orders map to `orders`, `order_stops`, `order_items`, `order_rates`.
   - Trips/dispatches map to `trips`, `trip_drivers`, `trip_equipment`, `trip_events`, `trip_event_orders`.
   - Driver/truck/trailer movements map to `trip_events`, `yard_moves`, `shipment_tracking_events`.
   - Payments/charges map to `order_rates`, `trip_expenses`, `invoices`, `bills`, `statement_runs`, `payments`.
   - Documents map to `document_attachments`.
   - Status history maps to `audit_logs`, `shipment_tracking_events`, or `entity_comments`.
3. Preserve useful legacy codes in external reference fields or add migration mapping tables if required.
4. Do not keep duplicate order/trip/payment tables unless a table is strictly needed as a staging table.
5. Write migration scripts that can be rerun safely in a staging database.
6. Preserve every legacy source ID through `legacy_entity_mappings`, and capture rejected rows in `legacy_rejected_rows`.

## Easy-to-use UI rules

- One search box should find any important record.
- Every list page must have saved filters, column chooser, export, and bulk actions.
- Every detail page must have a timeline tab showing comments, documents, status changes, events, and audit entries.
- Dispatchers should be able to create an order and plan a trip without leaving the dispatch board.
- Uploading POD, BOL, fuel receipt, PTI, insurance, and compliance documents must be drag-and-drop.
- Show warnings before users make accounting-impacting changes.
- Show plain-language validation messages.
- Use status badges and next-action buttons.
- Make default values intelligent: company, terminal, currency, user, date, truck, driver, and common charges.
- Do not load huge tables into the browser; all grids must use server-side paging and filters.

## Backend rules

- Every table must be company-scoped where operationally relevant.
- Every create/update/status transition must write `audit_logs`.
- All monetary values must use DECIMAL and currency_id.
- All external integrations must log sync attempts and errors.
- Use UTC for GPS, ELD, and tracking event timestamps.
- Use transactions for multi-table workflows.
- Validate status transitions centrally.
- Add idempotency keys for imports, webhooks, EDI, payment posting, and carrier tender callbacks.

## Required step-2 workflows

1. Quote to order
   - Create quote request.
   - Add quote and quote lines.
   - Send quote.
   - Customer accepts quote.
   - Convert quote to order and copy rates.

2. Order to trip to invoice
   - Create order.
   - Validate stops/items/rates.
   - Plan trip.
   - Add trip events.
   - Upload POD and PTI.
   - Submit trip for accounting approval.
   - Generate invoice and bill.
   - Receive/payment allocation.

3. Carrier tender
   - Create carrier trip.
   - Send load tender.
   - Receive accept/reject/counter.
   - Update trip carrier and rate.
   - Generate carrier bill/settlement after POD.

4. Yard and dock
   - Create appointment.
   - Check in truck/trailer/container/chassis.
   - Assign yard spot.
   - Perform yard move.
   - Complete dock/cross-dock event.

5. Maintenance
   - Create service schedule.
   - Generate work order when due.
   - Add parts/labor.
   - Upload vendor invoice/document.
   - Close work order and update equipment status.

6. Incident to claim
   - Create accident incident.
   - Attach driver/truck/order/trip.
   - Create claim.
   - Add documents/comments/tasks.
   - Approve settlement or close claim.

## Deliverables

- Keep step-1 SQL and prompts.
- Add `step_2_missing_functionality.sql`.
- Add `step_2_missing_functionality_data.sql`.
- Add this `step_2_prompt.md`.
- Add `disp_trans_sql_mapping.md`.
- Add `disp_trans_migration_support.sql` and `disp_trans_migration_support_data.sql`.
- Update Angular, Laravel, and Spring Boot prompts so generated apps include the step-2 modules.
- Use `disp_trans_sql.sql` only as the legacy source/staging model; production code must use the normalized ERP schema.
