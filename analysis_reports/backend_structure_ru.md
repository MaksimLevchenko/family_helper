# Структура бэка `family_helper_server`

## Общая схема

```text
family_helper_server/
├── bin/
├── config/
├── lib/
│   ├── server.dart
│   └── src/
│       ├── auth/
│       ├── auth_profile/
│       ├── calendar/
│       ├── core/
│       ├── family/
│       ├── generated/
│       ├── greetings/
│       ├── health/
│       ├── lists/
│       ├── media/
│       ├── money_goals/
│       ├── notifications/
│       ├── privacy/
│       ├── realtime/
│       ├── sync/
│       ├── tasks/
│       ├── web/
│       └── workers/
├── migrations/
├── repair-migration/
├── test/
├── tool/
└── web/
```

## Что где находится

- `bin/` — точка запуска серверного приложения.
- `config/` — конфигурация окружений, генерации и шаблонов паролей.
- `lib/server.dart` — главная сборка сервера: инициализация Serverpod, auth, future calls, роутов и сервисов.
- `lib/src/` — основная прикладная логика бэка.
- `migrations/` — обычные миграции Serverpod по версиям.
- `repair-migration/` — repair-миграции для выравнивания схемы.
- `test/` — unit и integration тесты серверной части.
- `tool/` — служебные скрипты.
- `web/` — статические web-ресурсы, legal-файлы, css и html-шаблоны.

## Внутри `lib/src`

### Доменные модули

- `auth/` — email-аутентификация, dispatch кодов, refresh endpoint, auth-модели.
- `auth_profile/` — профиль пользователя: endpoint, сервис, DTO.
- `family/` — семья, участники, приглашения, lifecycle и membership-логика.
- `calendar/` — календарные события, overrides, instances, endpoint и сервис.
- `tasks/` — задачи, история задач, CRUD и вспомогательная логика.
- `lists/` — семейные списки и элементы списков.
- `money_goals/` — финансовые цели, взносы, история прогресса.
- `media/` — загрузка и работа с медиаобъектами и вложениями.
- `notifications/` — настройки уведомлений, reminder-ы, push-токены и inbox.
- `privacy/` — экспорт данных, удаление аккаунта, privacy-статусы.
- `realtime/` — realtime endpoint и модели событий.
- `sync/` — change feed и инкрементальная синхронизация.
- `greetings/` — простой demo/system endpoint.
- `health/` — health-check endpoint.

### Сквозная инфраструктура

- `core/auth/` — auth context и работа с текущим пользователем.
- `core/audit/` — аудит действий.
- `core/clock/` — абстракция времени.
- `core/idempotency/` — защита от повторного применения мутаций.
- `core/rbac/` — проверки ролей и доступа в рамках семьи.
- `core/realtime/` — публикация realtime-событий.
- `core/security/` — security events.
- `core/storage/` — приватное файловое хранилище и выдача доступа.
- `core/sync/` — сервис change feed.
- `core/models/` — общие `.spy.yaml` модели для DTO и row-классов.

### Генерация и фоновые процессы

- `generated/` — сгенерированный код Serverpod. Это производный слой, его не стоит править вручную.
- `workers/` — future calls и их payload-модели для фоновых задач.

### Web-слой

- `web/routes/` — server-side роуты, например runtime config и приватная выдача медиа.
- `web/widgets/` — серверные web-виджеты и страницы.

## Повторяющийся паттерн доменного модуля

В большинстве backend-модулей используется одна и та же структура:

```text
module/
├── endpoints/
├── models/
└── services/
```

- `endpoints/` — публичный RPC-слой Serverpod.
- `models/` — `.spy.yaml` source-of-truth для row и DTO.
- `services/` — основная бизнес-логика.
