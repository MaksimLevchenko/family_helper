# Family Helper Server

## Stack
- Serverpod 3.2.3
- PostgreSQL
- Serverpod auth (email + JWT refresh)
- MinIO/S3 signed URLs
- FutureCall workers for reminders/media cleanup/privacy

## Environment
Create `config/passwords.yaml` from `config/passwords.yaml.example`, then set env:

- `FAMILY_MEMBER_LIMIT` (default `2`)
- MinIO settings in `config/passwords.yaml`:
  - `minioEndpoint`
  - `minioBucket`
  - `minioAccessKey`
  - `minioSecretKey`
  - `minioPublicBaseUrl`
  - `minioUseSsl`
  - `minioSignUrlTtl`
- Optional for test runs:
  - `MINIO_FORCE_REAL_IN_TEST=true` to disable mock storage fallback in `test` mode

Recommended local values:

```bash
minioEndpoint: 'localhost:9000'
minioBucket: 'family-helper'
minioAccessKey: 'replace-me'
minioSecretKey: 'replace-me'
minioPublicBaseUrl: 'http://localhost:9000'
minioUseSsl: 'false'
minioSignUrlTtl: '900'
```

## Local Infra
From `family_helper_server/`:

```bash
docker compose up --build -d
```

Before running compose, create `.env`:

```bash
cp .env.example .env
```

This starts Postgres, Redis, and MinIO using values from `.env`.
It also starts MinIO on:
- API: `http://localhost:9000`
- Console: `http://localhost:9001`

`minio_init` bootstraps:
- bucket `${MINIO_BUCKET}` (default `family-helper`)
- CORS for local web origins
- private bucket for presigned upload/download flows

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

Migration policy for this repo: use only Serverpod CLI flow.

```bash
# 1) Regenerate protocol/endpoints/tables after model changes
serverpod generate

# 2) Create migration (or repair migration when needed)
serverpod create-migration
# or
serverpod create-repair-migration

# 3) Apply migrations through Serverpod runtime
dart bin/main.dart --apply-migrations
# or
dart bin/main.dart --apply-repair-migration
```

## Run Server
```bash
dart bin/main.dart
```

MinIO root user/password for Docker bootstrap are read from `.env` by `docker compose`.

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
