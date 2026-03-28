# Family Helper Server

## Stack
- Serverpod 3.2.3
- PostgreSQL
- Serverpod auth (email + JWT refresh)
- Serverpod database-backed file storage + signed private URLs
- FutureCall workers for reminders/media cleanup/privacy

## Environment
Create `config/passwords.yaml` from `config/passwords.yaml.example`, then set env:

- `FAMILY_MEMBER_LIMIT` (default `2`)
- Media signing settings in `config/passwords.yaml`:
  - `mediaUrlSignSecret`
- SMTP settings for email verification / password reset (optional in `development` / `test`):
  - `smtpProvider` (`yandex` enables `smtp.yandex.com:465` with SSL by default)
  - `smtpHost`
  - `smtpPort`
  - `smtpUsername`
  - `smtpPassword`
  - `smtpFromEmail`
  - `smtpFromName`
  - `smtpUseSsl`
  - `smtpAllowInsecure`
- Optional:
  - `SIGN_URL_TTL` (default `900`) to change private download URL TTL in seconds

Recommended local values:

```bash
mediaUrlSignSecret: 'replace-me'
```

Yandex SMTP example in `config/passwords.yaml`:

```yaml
development:
  smtpProvider: 'yandex'
  smtpUsername: 'your-mailbox@yandex.ru'
  smtpPassword: 'replace-me'
  smtpFromEmail: 'your-mailbox@yandex.ru'
  smtpFromName: 'Family Helper'
  smtpAllowInsecure: 'false'
```

With `smtpProvider: 'yandex'`, the server uses `smtp.yandex.com`, port `465`, and SSL automatically. `smtpHost`, `smtpPort`, and `smtpUseSsl` can still be set explicitly if you need to override the preset.

For FCM push, add one of these to `config/passwords.yaml` for the active environment:

```yaml
firebaseServiceAccountJsonPath: './firebase-service-account.json'
```

or

```yaml
firebaseServiceAccountJson: '{"type":"service_account",...}'
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

This starts Postgres and Redis using values from `.env`.
This starts Postgres and Redis for the API. Uploaded media bytes are stored in Postgres through Serverpod's built-in cloud storage tables.

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
- `feature` keys are a public contract and use canonical `snake_case` values
  (example: `money_goals`).

## Sync
`sync.changes(since, familyId, limit)` returns changes/tombstones from `change_feed`.

## Notes
- Money is stored in `*_amount_cents` (`BIGINT`) with ISO-4217 currency (`RUB` default).
- Mutations are idempotent via `clientOperationId` + unique constraints.
