# Push Notifications: What To Do Next

This guide picks up from the current implementation state in the repo.

What is already in code:
- Server stores richer push tokens and app inbox notifications.
- Server creates inbox notifications for due reminders, family invites, task assignment/completion, and significant calendar changes.
- Server has FCM HTTP v1 dispatch support via `config/passwords.yaml`.
- Flutter registers a real FCM token when Firebase is configured.
- Flutter notifications screen now shows a family inbox plus settings.
- Opening a push/local notification routes into the relevant app section.

What is not yet provisioned:
- Real `google-services.json`.
- Real `GoogleService-Info.plist`.
- Real APNs setup for iOS.
- Real web push VAPID key.

## 1. Create And Configure Firebase

Create one Firebase project for the app and add:
- Android app: `com.familyhelper.app`
- iOS app: `com.familyhelper.app`
- Web app: use the same Firebase project

Enable:
- Firebase Cloud Messaging

For iOS also configure:
- APNs auth key or certificate in Firebase Console
- Push Notifications capability in Xcode
- Background Modes -> `Remote notifications`

## 2. Prepare Server Secret

The server now reads Firebase service account config from `config/passwords.yaml`.

Recommended:
- `firebaseServiceAccountJsonPath: './firebase-service-account.json'`

Also supported:
- `firebaseServiceAccountJson: '{...}'`

Use the Firebase service account JSON from:
- Firebase Console -> Project settings -> Service accounts

Do not commit it to git.

Example `config/passwords.yaml`:

```yaml
development:
  firebaseServiceAccountJsonPath: './firebase-service-account.json'
```

Then start the server:

```powershell
cd family_helper_server
dart bin/main.dart --apply-migrations
```

## 3. Run Serverpod Generation If Models/Endpoints Change Again

If you change notifications models or endpoints further, use:

```powershell
cd family_helper_server
dart pub global run serverpod_cli:serverpod_cli generate
dart pub global run serverpod_cli:serverpod_cli create-migration
dart bin/main.dart --apply-migrations
```

Note:
- On this machine the direct `serverpod` wrapper was unreliable.
- `dart pub global run serverpod_cli:serverpod_cli ...` worked correctly.

## 4. Add Mobile Firebase Files Locally

Add these files locally, without committing secrets:
- Android: `family_helper_flutter/android/app/google-services.json`
- iOS: `family_helper_flutter/ios/Runner/GoogleService-Info.plist`

Current iOS bundle id in the project is already aligned to:
- `com.familyhelper.app`

File:
- [project.pbxproj](d:\GUAP\family_helper\family_helper_flutter\ios\Runner.xcodeproj\project.pbxproj)

## 5. Flutter Firebase Config

Flutter now reads Firebase app config from:
- [firebase_options.dart](d:\GUAP\family_helper\family_helper_flutter\lib\firebase_options.dart)

No `--dart-define` is required for Firebase app initialization anymore.

Run normally:

```powershell
cd family_helper_flutter
flutter run
```

## 6. Finish Web Push Setup

Edit:
- [firebase-messaging-sw.js](d:\GUAP\family_helper\family_helper_flutter\web\firebase-messaging-sw.js)

Firebase web config is already checked into:
- [firebase-messaging-sw.js](d:\GUAP\family_helper\family_helper_flutter\web\firebase-messaging-sw.js)

Still required for web push:
- put your public VAPID key into [firebase_web_push_options.dart](d:\GUAP\family_helper\family_helper_flutter\lib\firebase_web_push_options.dart)

If you serve Flutter web in a different environment, make sure the service worker is available at:
- `/firebase-messaging-sw.js`

## 7. Android Checklist

Verify:
- `google-services.json` is present locally
- app builds successfully
- notification permission is requested on Android 13+
- foreground push shows a local notification
- background and terminated pushes arrive

Suggested smoke test:
1. Run server.
2. Run Android app normally.
3. Sign in and open Settings -> Notifications.
4. Confirm permission is granted.
5. Create a due reminder or trigger another supported notification event.
6. Confirm:
   - inbox item appears
   - push arrives
   - tapping the notification opens the correct screen

## 8. iOS Checklist

Verify in Xcode:
- correct signing team
- bundle id is `com.familyhelper.app`
- Push Notifications capability enabled
- Background Modes -> Remote notifications enabled
- `GoogleService-Info.plist` added to Runner target

Then test:
- foreground push
- background push
- terminated-app push

If iOS push does not arrive:
- first check APNs auth key in Firebase
- then check device logs and Firebase Messaging token generation

## 9. Web Checklist

Verify:
- `firebase-messaging-sw.js` has real values
- `firebase_web_push_options.dart` has a real VAPID key
- browser permission is granted
- clicking a web push opens the app and routes to the expected page

## 10. Supported Notification Sources Right Now

Current first-phase producers:
- due reminders
- family invite created
- family invite accepted
- task assigned
- task completed
- calendar created
- calendar updated
- calendar cancelled

Not included in this phase:
- lists inbox events
- money goals inbox events

## 11. Inbox And Navigation Files

Main client files:
- [notifications_provider.dart](d:\GUAP\family_helper\family_helper_flutter\lib\features\notifications\providers\notifications_provider.dart)
- [notifications_screen.dart](d:\GUAP\family_helper\family_helper_flutter\lib\features\notifications\presentation\notifications_screen.dart)
- [push_notification_service.dart](d:\GUAP\family_helper\family_helper_flutter\lib\features\notifications\data\push_notification_service.dart)
- [notification_navigation_service.dart](d:\GUAP\family_helper\family_helper_flutter\lib\features\notifications\data\notification_navigation_service.dart)

Main server files:
- [notifications_service.dart](d:\GUAP\family_helper\family_helper_server\lib\src\notifications\services\notifications_service.dart)
- [app_notification_service.dart](d:\GUAP\family_helper\family_helper_server\lib\src\notifications\services\app_notification_service.dart)
- [push_dispatch_service.dart](d:\GUAP\family_helper\family_helper_server\lib\src\notifications\services\push_dispatch_service.dart)

## 12. Verification Commands

Flutter:

```powershell
cd family_helper_flutter
flutter analyze
flutter test
```

Server:

```powershell
cd family_helper_server
dart analyze
dart test test/integration/notifications/due_reminders_worker_test.dart test/integration/notifications/replace_reminder_test.dart --reporter compact
```

## 13. Current Known Test Status

Notifications-related checks that passed:
- Flutter analyze
- Flutter test
- Server analyze
- notifications integration tests for due reminders and replace reminder

There are still unrelated pre-existing failures in the full server integration suite. Before calling the whole backend green, fix those separately.

## 14. Recommended Immediate Next Steps

1. Provision Firebase project and APNs.
2. Add local mobile Firebase files.
3. Replace web service worker placeholders.
4. Run Android smoke test.
5. Run iOS smoke test.
6. Run web smoke test.
7. After smoke tests, decide whether to add:
   - unread badge in Settings/Home
   - dedicated inbox polling/realtime refresh
   - notification producers for lists and money goals
