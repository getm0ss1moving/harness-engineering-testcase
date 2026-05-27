---
last_updated: 2026-05-23
status: active # active | deprecated | draft
owner: m0ss1
---

# Feature Design: Billing

## Goal

Support billing-related workflows for organizations using the platform.

## Scope

- Billing account lookup.
- Subscription status display.
- Invoice list display.
- Payment provider integration through an injected API client abstraction.

## Out of Scope

- Raw card data handling.
- Custom payment processor implementation.
- Accounting ledger design.

## Main Concepts

- Billing account: payment owner for an organization.
- Subscription: current plan and renewal state.
- Invoice: historical or pending billing document.
- Payment provider: external billing system accessed through `ApiClient`.

## Architecture Notes

- Do not call external payment APIs with raw `RestTemplate` or `HttpURLConnection`.
- Use an injected `ApiClient` abstraction.
- Never log full payment data.
- Billing services should translate provider failures into application error codes.

## API Candidates

- `GET /api/billing/account`
- `GET /api/billing/subscription`
- `GET /api/billing/invoices`

## Error Codes

- `BILLING_ACCOUNT_NOT_FOUND`
- `BILLING_PROVIDER_UNAVAILABLE`
- `AUTH_REQUIRED`
- `AUTH_FORBIDDEN`

## Tests

- Returns billing account for authorized user.
- Rejects access for unauthorized user.
- Maps provider timeout to `BILLING_PROVIDER_UNAVAILABLE`.
- Does not expose provider internals in API errors.
