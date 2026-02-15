# Family Helper Server

## Stack
- Serverpod 3.2.3
- PostgreSQL
- Serverpod auth (email + JWT refresh)
- MinIO/S3 signed URLs
- FutureCall workers for reminders/media cleanup/privacy

## Environment
Create `config/development.yaml` and `config/passwords.yaml` from Serverpod defaults, then set env:

- `FAMILY_MEMBER_LIMIT` (default `2`)
- `MINIO_ENDPOINT`
- `MINIO_BUCKET`
- `MINIO_ACCESS_KEY`
- `MINIO_SECRET_KEY`
- `MINIO_REGION`
- `MINIO_PUBLIC_BASE_URL`
- `FIREBASE_PROJECT_ID`
- `FCM_SERVICE_ACCOUNT_JSON`

## Local Infra
From `family_helper_server/`:

```bash
docker compose up --build -d
```

This starts Postgres (+ Redis from template compose).

## Migrations
Migrations are in `migrations/` and include:
- core/auth/audit/idempotency/change-feed
- family/invites
- calendar
- tasks/history
- lists/history/categories
- money goals/contributions
- notifications/reminders/push tokens
- media/attachments
- privacy/export/deletion

Apply on startup:

```bash
dart bin/main.dart --apply-migrations
```

## Run Server
```bash
dart bin/main.dart
```

## Generate Protocol / Endpoints
```bash
serverpod generate
```

If `serverpod` binary is unavailable globally, use `serverpod_cli` directly from Pub cache.

## Tests
Integration tests are in:
- `test/integration/family/*`
- `test/integration/rbac/*`
- `test/integration/calendar/*`
- `test/integration/tasks/*`
- `test/integration/lists/*`
- `test/integration/money_goals/*`
- `test/integration/notifications/*`
- `test/integration/media/*`
- `test/integration/sync/*`

Run:

```bash
dart test
```

## Realtime
Family invalidation events are published to `family:<familyId>` using:
- `session.messages.postMessage(..., global: false)`

## Sync
`sync.changes(since, familyId, limit)` returns changes/tombstones from `change_feed`.

## Notes
- Money is stored in `*_amount_cents` (`BIGINT`) with ISO-4217 currency (`RUB` default).
- Mutations are idempotent via `clientOperationId` + unique constraints.
