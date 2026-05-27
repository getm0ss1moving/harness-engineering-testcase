---
last_updated: 2026-05-23
status: active # active | deprecated | draft
owner: m0ss1
---

# Feature Design: Search

## Goal

Provide search across project management resources such as projects, tasks, and members.

## Scope

- Keyword search.
- Filter by resource type.
- Pagination.
- Basic sorting.

## Out of Scope

- Full-text search engine integration.
- Saved searches.
- Ranking personalization.

## Main Concepts

- Search query: the user's input text.
- Filter: structured constraints such as type, status, or owner.
- Result item: a normalized response item pointing to a resource.

## Architecture Notes

- Controllers validate query parameters and delegate to services.
- Services coordinate mapper queries and result normalization.
- Mappers encapsulate SQL or MyBatis-Plus query construction.
- Search must respect auth and project permissions.

## API Candidates

- `GET /api/search?q=keyword&type=project&page=1&pageSize=20`

## Error Codes

- `VALIDATION_FAILED`
- `AUTH_REQUIRED`
- `AUTH_FORBIDDEN`

## Tests

- Returns matching resources for valid query.
- Applies pagination consistently.
- Rejects invalid page parameters.
- Filters results based on user permissions.
