# Структура фронта `family_helper_flutter`

## Общая схема

```text
family_helper_flutter/
├── android/
├── assets/
├── ios/
├── lib/
│   ├── core/
│   ├── features/
│   ├── l10n/
│   ├── ui_kit/
│   ├── firebase_options.dart
│   ├── firebase_web_push_options.dart
│   └── main.dart
├── test/
├── web/
└── windows/
```

## Что где находится

- `android/`, `ios/`, `web/`, `windows/` — платформенные оболочки Flutter-приложения.
- `assets/` — статические клиентские ресурсы и runtime-конфиг.
- `lib/main.dart` — точка входа Flutter-приложения.
- `lib/` — весь основной код фронта.
- `test/` — клиентские тесты.

## Внутри `lib`

### `core/`

Сквозная инфраструктура приложения, не привязанная к одной фиче:

- `auth/` — сессия, auth-провайдеры, маппинг auth-ошибок, валидация.
- `config/` — дефолтные настройки приложения.
- `di/` — `GetIt`, модули регистрации сервисов и authenticated scope.
- `l10n/` — локализация и синхронизация locale.
- `logging/` — логирование клиентских ошибок.
- `network/` — `AppApiClient`, доступность сервера, URL-резолвинг.
- `offline/` — offline snapshot store, queue, replay и классификация ошибок.
- `realtime/` — подписки на realtime и feature flags.
- `routing/` — роутер и список маршрутов.
- `sync/` — orchestration синхронизации после realtime/операций.
- `theme/` — тема, цвета и управление темой.
- `utils/` — мелкие общие утилиты, например генерация operation id.

### `features/`

Основной feature-first слой приложения. Каждая фича лежит в собственной папке:

- `auth_profile/`
- `calendar/`
- `family_invites/`
- `home_overview/`
- `lists/`
- `media/`
- `money_goals/`
- `notifications/`
- `privacy_security/`
- `tasks/`

Для большинства фич повторяется одна и та же схема:

```text
feature/
├── data/
├── domain/
├── presentation/
└── providers/
```

- `data/` — репозитории и доступ к backend/API.
- `domain/` — формы, локальные доменные модели и client-side преобразования.
- `presentation/` — экраны, секции, sheet-ы и визуальная сборка.
- `providers/` — Cubit/BLoC/state orchestration фичи.

### `presentation/widgets` внутри фич

Для крупных экранов UI вынесен в отдельные маленькие файлы. Это особенно заметно в:

- `home_overview/presentation/widgets/`
- `calendar/presentation/widgets/`
- `money_goals/presentation/widgets/`
- `tasks/presentation/widgets/`

Такой подход держит `*_screen.dart` компактными и оставляет им роль точки входа, а не большого монолитного файла.

### `l10n/`

- `app_ru.arb`, `app_en.arb` — исходники локализаций.
- `app_localizations*.dart` — сгенерированные локализационные классы.

### `ui_kit/`

Переиспользуемые UI-компоненты приложения:

- кнопки, диалоги, поля ввода;
- loading/error/empty states;
- layout-утилиты;
- аватары, money field, date-time picker;
- общий набор базовых визуальных примитивов.

## Практическая модель фронта

Архитектурно фронт делится на четыре слоя:

- `core/` — глобальная инфраструктура приложения.
- `features/` — бизнес-функциональность по предметным областям.
- `l10n/` — локализация интерфейса.
- `ui_kit/` — общий визуальный слой для переиспользования между фичами.
