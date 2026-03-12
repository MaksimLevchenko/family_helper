# Family Helper Flutter Client

## Architecture
- Feature-first modules: `lib/features/<feature>/{domain,data,providers,presentation}`
- Core modules: `lib/core/{network,auth,routing,realtime,offline,theme,sync,utils}`
- Reusable UI only in `lib/ui_kit`
- State: Riverpod + BLoC (feature state in BLoC where migrated)

## Setup
From `family_helper_flutter/`:

```bash
flutter pub get
```

Run app:

```bash
flutter run
```

Optional server URL:

```bash
flutter run --dart-define=SERVER_URL=http://<host>:8080/
```

## Notifications
The app schedules local reminders on-device. No Firebase setup is required.

## Offline Queue
- Interface: `OfflineOperationQueue`
- SQLite impl: `SqliteOfflineOperationQueue`
- Replay manager: `OfflineQueueManager`

Current behavior:
- Queue supports enqueue/list/retry/remove
- Replay is FIFO
- Integration with every mutation flow can be extended per feature

## Realtime + Sync
- Realtime stream: `realtime.watchFamilyEvents(familyId)`
- On invalidation event client triggers `sync.changes(...)`
- Feature providers are invalidated after sync

## Main Screens
- Sign in
- Home overview
- Calendar
- Tasks
- Lists
- Goals
- Settings:
  - Profile
  - Family
  - Notifications
  - Privacy
  - Appearance

## Tests
Run:

```bash
flutter test
```

Included tests:
- `test/features/auth_profile/profile_bloc_test.dart`
- `test/core/offline/offline_queue_manager_test.dart`
