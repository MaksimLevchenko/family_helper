# Family Helper (Serverpod + Flutter)

## Monorepo Structure
- `family_helper_server/` - Serverpod backend
- `family_helper_client/` - generated protocol client package
- `family_helper_flutter/` - Flutter app

## Quick Start
1. Start backend infra:

```bash
cd family_helper_server
docker compose up --build -d
```

2. Run server with migrations:

```bash
dart bin/main.dart --apply-migrations
```

3. Run Flutter app:

```bash
cd ../family_helper_flutter
flutter pub get
flutter run
```

## Required Environment
### Server
- DB and Serverpod configs in `family_helper_server/config/*.yaml`
- Copy `family_helper_server/config/passwords.yaml.example` to `family_helper_server/config/passwords.yaml`
- `FAMILY_MEMBER_LIMIT` (default `2`)
- MinIO vars:
  - `MINIO_ENDPOINT`
  - `MINIO_BUCKET`
  - `MINIO_SECRET_KEY`
  - `MINIO_PUBLIC_BASE_URL` (optional)
  - `MINIO_USE_SSL` (optional, default `false`)
  - `SIGN_URL_TTL` (optional, default `900`)
  - `MINIO_FORCE_REAL_IN_TEST` (optional, default `false`; forces real MinIO in test mode)

### Client
- Optional `SERVER_URL` via `--dart-define`
- In Flutter debug on Android emulator, loopback addresses are remapped to `10.0.2.2`

## MinIO Example (docker-compose snippet)
```yaml
services:
  minio:
    image: minio/minio:latest
    command: server /data --console-address ":9001"
    environment:
      MINIO_ROOT_USER: minio
      MINIO_ROOT_PASSWORD: minio123
    ports:
      - "9000:9000"
      - "9001:9001"
```

## Local docker-compose secrets
Set `family_helper_server/.env` from `family_helper_server/.env.example` before running:

```bash
cd family_helper_server
cp .env.example .env
```

## Acceptance Flow (manual)
1. Register/sign in two users.
2. Create family, invite second user by code/email, accept invite.
3. Create recurring calendar event and cancel one occurrence.
4. Create task with `generateOnComplete`, complete it, verify next task appears once.
5. Create shopping list, toggle bought, reorder items.
6. Create money goal, add contributions, verify aggregate.
7. Upload media via presigned flow, complete upload, open signed URL.
8. Set notification preference, schedule reminder, process due reminders.
9. Request privacy export and account deletion.
10. Toggle theme and verify UI; test offline queue replay.

## Docs
- Server setup: `family_helper_server/README.server.md`
- Client setup: `family_helper_flutter/README.client.md`

## Migration Policy
- Apply and repair DB schema only through Serverpod CLI/runtime (`serverpod generate`, `serverpod create-migration` / `create-repair-migration`, `--apply-migrations` / `--apply-repair-migration`).
- Do not hand-edit SQL migration files.
