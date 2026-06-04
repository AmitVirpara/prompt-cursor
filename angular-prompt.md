# Angular Frontend Prompt: Logistics ERP

Create a modern Angular application for the Logistics ERP described in `main-prompt.md`. Use the MySQL schema in `sample1_date.sql` as the data contract and design the UI for high-volume dispatch operations.

## Technical direction

- Use the latest stable Angular with standalone components.
- Use TypeScript strict mode.
- Use lazy-loaded feature routes for performance.
- Use route guards for authentication, company context, and permissions.
- Use reactive forms for all create/edit screens.
- Use virtual scrolling or server-side pagination for large tables.
- Use an API client layer with typed DTOs matching backend responses.
- Store access token/session data securely and refresh through backend endpoints.
- Keep date/time display timezone-aware, but show GPS recorded timestamps as UTC.

## Application shell

- Login page.
- Company selector.
- Sidebar menu driven by `menus`, ordered by display_order.
- Top bar with active company, terminal, notifications, user menu, and quick search.
- Breadcrumbs and page-level actions.
- Global loading indicator and error/toast service.

## Feature modules

1. Administration
   - Companies, company settings, financial years, currencies, daily rates.
   - Users, employees, roles, permissions, role-permissions, user roles.
   - Menu builder with drag/drop display order and permission binding.

2. Master data
   - Terminals, warehouses, predefined addresses, address lanes.
   - Party groups, customers, shippers, receivers, suppliers, carriers.
   - Party contacts and addresses.

3. Fleet
   - Trucks.
   - Trailer assets with asset types TRAILER, CONTAINER, CHASSIS.
   - Drivers.
   - Fuel cards and truck assignment history.
   - GPS device assignment and latest UTC positions.
   - Compliance records and document expiry dashboard.

4. Documents
   - Reusable document upload component.
   - Entity document tabs for trucks, trailer assets, drivers, parties, employees, orders, trips, claims, and PTI.
   - Document type selector, expiry date, verification status, notes, preview/download.

5. Fuel
   - Excel upload screen.
   - BDE/API sync status screen.
   - Fuel transactions list with filters by truck, driver, card, vendor, date, and status.
   - Exception review for unmatched/disputed fuel records.

6. Orders
   - Order list with filters by status, customer, date, freight type.
   - Order wizard: header, parties, pickup/delivery stops, items/dimensions, special conditions, documents, rates, validation summary.
   - Support FTL, LTL, partial, and intermodal.
   - Support multi-pickup/multi-delivery, partial delivery, return, destroy, and cross-dock stops.

7. Dispatch board
   - Ready orders panel.
   - Trip planning panel.
   - Calendar/timeline and map-friendly layout.
   - Assign company truck or carrier trip.
   - Attach drivers, truck, trailer/container/chassis.
   - Manage trip events in ordered sequence.
   - Event editor for acquire truck, hook trailer, pickup load, drop yard, drop dock, drop trailer, hook/drop chassis, lift on/off container, deliver, return, destroy, cross-dock, custom.

8. Trips
   - Trip list by status/accounting status.
   - Trip detail with summary, events, orders, drivers, equipment, expenses, PTI, cross-dock, documents, accounting verification.
   - Calculated planned/actual miles from events.

9. Accounting
   - Chart of accounts.
   - Party accounts.
   - Invoices and invoice lines.
   - Bills and bill lines.
   - Statement runs for drivers, trucks, trailers, carriers, employees, customers, and suppliers.
   - Settlements and settlement lines.
   - Accounting verification queue for trips/events/expenses.

10. HR
    - Employees, designations, pay schedules.
    - Leave types, leave requests, attendance logs, payroll runs.

11. Claims and compliance
    - Claims list/detail/events.
    - Driver and equipment compliance dashboards.
    - Expiring documents widget.

12. Inventory
    - Categories, items, warehouse locations.
    - Stock movements and item assignments to truck/trailer/chassis/container/driver.

13. Integrations and audit
    - API integrations for currency, BDE fuel, GPS, ELD, accounting.
    - Sync logs.
    - Audit log viewer with entity, user, action, and date filters.

## UX requirements

- Lists must support search, filter, sort, column chooser, pagination, export, and saved filters.
- Forms must validate required fields, enum values, duplicate codes, date ranges, and cross-company IDs.
- Use status badges consistently.
- Provide inline create buttons for parties, addresses, documents, and stops where dispatchers need speed.
- Avoid loading all data at once; use server-side APIs and debounced searches.
- Use optimistic UI only for low-risk updates; dispatch and accounting actions should wait for server confirmation.

## Deliverables

- Angular app structure with feature routes.
- Shared components for data table, form field errors, document upload, status badge, confirm dialog, audit trail drawer.
- Typed API DTOs based on schema names.
- Route guards and permission directives.
- Unit tests for guards, services, order form validation, and trip event ordering.

## Step 2 frontend modules

Include the real-world usability modules from `step_2_prompt.md` and `step_2_missing_functionality.sql`:

- User preferences, saved filters, dashboard builder widgets, global search, command palette, keyboard shortcuts, notification center, comments drawer, tags, task boards, and approval inbox.
- Quote request and quote workflow, quote-to-order conversion, customer contracts, carrier rate agreements, rate lookup screens, load tender send/response screens.
- Payment entry, payment allocation, bank account management, tax-code setup, AR/AP reconciliation views.
- Dock appointment calendar, yard spot map/list, yard move workflow, maintenance work orders, preventive service schedules, insurance policy tracker, incident reporting.
- Driver mobile views for HOS logs, ELD events, trip events, POD/PTI/fuel document upload, and offline-friendly task capture.
- Customer/carrier portal screens for shipment tracking, documents, invoices, tenders, and status updates.
- EDI message monitor, import job error review, report builder/scheduled reports, webhook delivery log, document/email template designer, barcode/QR label generation.
- Legacy `disp_trans_sql.sql` migration console for batch progress, source table inventory, field/status mapping review, rejected-row correction, checkpoint restart, and old-ID lookup through `legacy_entity_mappings`.

Every step-2 screen must keep the same UX rules: server-side grids, saved filters, bulk actions, status badges, timeline/audit tabs, drag-and-drop documents, and plain-language validation.
