# Main Prompt: Scalable Logistics ERP / Dispatch System

Build a scalable, fast-loading Logistics ERP for multi-company dispatch operations. The application must support high-volume order entry, trip planning, fleet management, accounting verification, HR, compliance, claims, inventory, GPS, fuel integrations, and document management.

Use the MySQL schema in `sample1_date.sql` as the database contract and `sample1_date_data.sql` as demo data. Treat all IDs, statuses, unique keys, indexes, and relationships in the schema as required.

## Core product requirements

1. Multi-company setup
   - Each user works inside a company context.
   - Companies have base currency, timezone, fiscal year settings, terminals, warehouses, and financial years.
   - Base currency example: CAD. Store daily exchange rates for CAD to USD, INR, EUR, GBP, and other currencies.

2. Security and navigation
   - Implement users, employees, roles, permissions, role-permissions, user-roles, and designations.
   - Build menu management with display order, module menus, page menus, option/action menus, icons, visibility, route path, and permission binding.
   - Every write action must create an audit log with logged-in user, company, entity, action, old values, new values, IP, and user agent.

3. Parties and addresses
   - Manage customers, shippers, receivers, suppliers, carriers, brokers, and other parties.
   - Support contacts, billing/shipping/pickup/delivery/yard addresses, predefined addresses, and address lanes.
   - Address lanes must store miles, duration, toll amount, and active/inactive status.

4. Fleet and assets
   - Manage trucks, trailer assets, containers, chassis, drivers, GPS devices, GPS UTC positions, fuel cards, and fuel card assignments.
   - Trailer asset table must support asset_type values: TRAILER, CONTAINER, CHASSIS.
   - Container/chassis workflows must support empty/loaded states and hook/drop/lift events.

5. Documents
   - Implement a reusable document attachment system for trucks, trailers, drivers, customers, suppliers, employees, carriers, orders, trips, claims, and compliance.
   - Store document type, file metadata, issue date, expiry date, verification status, uploader, and notes.

6. Fuel
   - Support Excel fuel imports and API sync from BDE or other providers.
   - Track batches, external transaction IDs, truck, driver, fuel card, gallons, price, total, odometer, vendor, currency, and import status.

7. Orders
   - Support FTL, LTL, partial, and intermodal orders.
   - Orders include customer, shipper, receiver, requested pickup/delivery dates, total shipment weight/volume, special conditions, temperature requirements, packing support, documents, rates, items, and stops.
   - Stops must support multi-pickup/multi-delivery, partial delivery, return, destroy, cross-dock, and yard movement.

8. Trips and dispatch events
   - Create trips from ready orders.
   - Trip types: company truck trips and carrier trips.
   - Attach drivers, pay rates, trucks, trailers, containers, chassis, terminals, cross-dock jobs, PTI documents, expenses, documents, and accounting verification.
   - Event types include acquire truck, hook trailer, pickup load, drop yard, drop dock, drop trailer, hook chassis, lift on container, lift off container, drop chassis, deliver load, return load, destroy load, cross-dock, and custom.
   - Events must track event order, planner, address, terminal, miles, expense amount, extra pay, related orders/stops, status, planned time, actual time, and notes.
   - Trip totals should be calculated from events and verified by accounting.

9. Accounting and statements
   - Maintain chart of accounts and party accounts.
   - Generate invoices, invoice lines, bills, bill lines, statement runs, statement lines, settlements, and settlement lines.
   - Statements must support drivers, trucks, trailers, carriers, employees, customers, and suppliers with pay schedules where applicable.

10. HR
    - Manage employees, designations, pay schedules, leave types, leave requests, attendance logs, payroll runs, and payroll lines.
    - HR records must be company-scoped and auditable.

11. Safety, compliance, and claims
    - Manage truck/trailer/container/chassis compliance, driver compliance, document expiry, PTI, safety records, and claims.
    - Claims must support damage, shortage, accident, late delivery, theft, and other workflows with events.

12. Inventory
    - Track daily-use items by category, SKU, warehouse location, stock movements, and assignments to trucks, trailers, chassis, containers, or drivers.
    - Inventory movement must support receipt, issue, transfer, adjustment, and return.

13. Integrations
    - Add API integration configuration for currency rates, BDE fuel, GPS, ELD, accounting, and other providers.
    - Add sync logs with record counts and error messages.

## Quality requirements

- Use company_id filtering everywhere.
- Add pagination, sorting, filtering, and export on all list screens.
- Validate statuses and enums at API boundary.
- Keep all time-sensitive GPS timestamps in UTC.
- Use soft workflow statuses instead of deleting operational records.
- Prefer database indexes shown in `sample1_date.sql` for query paths.
- Implement role-based route guards and API authorization.
- Create automated tests for authentication, company scoping, order creation, trip event sequencing, fuel import, document expiry, and accounting verification.
