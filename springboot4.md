# Spring Boot 4 Backend Prompt: Logistics ERP API

Build a Spring Boot 4 backend API for the Logistics ERP described in `main-prompt.md`. Use MySQL 8 and the schema in `sample1_date.sql` as the database contract. Demo data is in `sample1_date_data.sql`.

## Technical direction

- Use Spring Boot 4, Java 25 or the latest supported LTS/runtime for Spring Boot 4, Spring Web, Spring Security, Spring Data JPA, Bean Validation, Flyway or Liquibase, MySQL Connector/J, scheduling, and async jobs.
- Expose REST APIs for an Angular SPA.
- Implement JWT or opaque token authentication.
- Enforce company context on all reads and writes.
- Use method security for permissions.
- Use database transactions for aggregate workflows.
- Keep entity mappings aligned with `sample1_date.sql` table names, columns, statuses, unique keys, and indexes.
- Store documents through a storage abstraction and keep metadata in `document_attachments`.

## Architecture

- `domain`: JPA entities and enums.
- `repository`: Spring Data repositories with company-scoped query methods.
- `service`: transactional business workflows.
- `web`: REST controllers and request/response DTOs.
- `security`: authentication, authorization, permission evaluation, company context.
- `integration`: currency, BDE fuel, GPS, ELD, accounting providers.
- `audit`: audit logging and entity-change capture.
- `jobs`: scheduled sync/import/statement/document-expiry jobs.

## Required modules

1. Security and company context
   - Login/logout/session.
   - Current user, roles, permissions, menus.
   - Active company resolver and request filter.
   - Permission evaluator using roles, role_permissions, user_roles.

2. Administration
   - Companies, settings, financial years.
   - Currencies and daily currency rates.
   - Roles, permissions, users, menus, designations.
   - Scheduled currency rate sync via provider interface.

3. Parties and addresses
   - Party groups, parties, party contacts, party addresses.
   - Predefined addresses and address lanes with miles/duration/tolls.

4. Fleet and assets
   - Trucks.
   - Trailer assets with TRAILER, CONTAINER, CHASSIS.
   - Drivers.
   - Fuel cards and assignments.
   - GPS devices and UTC GPS positions.
   - Equipment and driver compliance records.

5. Documents
   - Upload/download/verify/reject/expire endpoints.
   - Entity document listing by entity type and ID.
   - Expiry reports and scheduled expiry checks.

6. Fuel
   - Excel import service.
   - BDE API sync service.
   - Fuel transaction matching by truck, driver, fuel card, odometer, and external transaction ID.
   - Import batch status and sync log reporting.

7. Orders
   - Order aggregate create/update: header, stops, items, rates, documents.
   - Support FTL, LTL, partial, intermodal.
   - Multi-pickup/multi-delivery, partial pickup/delivery, return, destroy, cross-dock, and yard stops.
   - Shipment calculators for weight, volume, dimensions, and totals.
   - Status transition service.

8. Trips and dispatch
   - Create company truck trips and carrier trips.
   - Assign drivers and pay rates.
   - Attach trucks, trailers, containers, chassis.
   - Ordered event management for acquire truck, hook trailer, pickup load, drop yard, drop dock, drop trailer, hook/drop chassis, lift on/off containers, deliver, return, destroy, cross-dock, custom.
   - Link events to orders and order stops.
   - Track event miles, expenses, extra pay, address, terminal, planner, status, planned time, actual time.
   - Calculate trip totals from events.
   - PTI, expenses, cross-dock jobs, documents, and accounting verification.

9. Accounting
   - Chart of accounts and party accounts.
   - Invoices and invoice lines.
   - Bills and bill lines.
   - Statement runs and lines for drivers, trucks, trailers, carriers, employees, customers, and suppliers.
   - Settlements and settlement lines.
   - Accounting verification status APIs.

10. HR
    - Employees, designations, pay schedules.
    - Leave types, leave requests, attendance logs.
    - Payroll runs and payroll lines.

11. Claims and compliance
    - Claims and claim events.
    - Safety and compliance dashboards.
    - Document and compliance expiry alerts.

12. Inventory
    - Inventory categories, items, warehouse locations.
    - Stock movements and assignments to trucks, trailers, chassis, containers, drivers.

13. Integrations and audit
    - API integrations and sync logs.
    - Audit logs for all create/update/delete/status changes.

## API requirements

- All list endpoints support pagination, sorting, filters, and optional export.
- All write endpoints validate enum values, company ownership, status transitions, date ranges, and unique codes.
- Return consistent error responses using Problem Details or a standard JSON error envelope.
- Use DTOs instead of exposing entities directly.
- Use optimistic locking or version columns if added later; for now use transactional updates and status checks.
- Add OpenAPI documentation.

## Testing requirements

- Integration tests with Testcontainers MySQL.
- Security tests for company scoping and permissions.
- Service tests for order creation, trip event ordering, fuel import, document expiry, invoice generation, statement generation, settlement approval, inventory assignment.
- Repository tests for indexed query paths and filters.
