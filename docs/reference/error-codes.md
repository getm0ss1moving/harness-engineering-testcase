---
last_updated: 2026-05-23
status: active # active | deprecated | draft
owner: m0ss1
---

# Error Codes

## General

| Code | HTTP Status | Meaning |
| --- | --- | --- |
| `INTERNAL_ERROR` | 500 | Unexpected server error. |
| `VALIDATION_FAILED` | 400 | Request validation failed. |
| `RESOURCE_NOT_FOUND` | 404 | Requested resource does not exist. |
| `CONFLICT` | 409 | Request conflicts with current resource state. |

## Auth

| Code | HTTP Status | Meaning |
| --- | --- | --- |
| `AUTH_REQUIRED` | 401 | Authentication is required. |
| `AUTH_INVALID_CREDENTIALS` | 401 | Credentials are invalid. |
| `AUTH_TOKEN_EXPIRED` | 401 | Authentication token has expired. |
| `AUTH_FORBIDDEN` | 403 | Caller is authenticated but not allowed to perform the action. |

## Project

| Code | HTTP Status | Meaning |
| --- | --- | --- |
| `PROJECT_NOT_FOUND` | 404 | Project does not exist or is not visible to the caller. |
| `PROJECT_NAME_DUPLICATE` | 409 | Project name already exists in the current scope. |
| `PROJECT_MEMBER_NOT_FOUND` | 404 | Project member does not exist. |

## Search

| Code | HTTP Status | Meaning |
| --- | --- | --- |
| `SEARCH_QUERY_REQUIRED` | 400 | Search query is required. |
| `SEARCH_PAGE_INVALID` | 400 | Page or page size is invalid. |

## Billing

| Code | HTTP Status | Meaning |
| --- | --- | --- |
| `BILLING_ACCOUNT_NOT_FOUND` | 404 | Billing account does not exist. |
| `BILLING_PROVIDER_UNAVAILABLE` | 503 | External billing provider is unavailable. |
| `BILLING_SUBSCRIPTION_INACTIVE` | 409 | Subscription is inactive for the requested operation. |
