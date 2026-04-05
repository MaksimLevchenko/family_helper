# Family Helper: подробное описание проекта

## Общее описание
`Family Helper` — это монорепо семейного планировщика на связке `Serverpod + Flutter` с тремя основными пакетами:
- `family_helper_server` — backend, API, модели БД, миграции, фоновые воркеры и web-роуты.
- `family_helper_client` — сгенерированный Dart-клиент и протокол Serverpod.
- `family_helper_flutter` — основной Flutter-клиент для mobile, web и desktop.

По структуре это семейный productivity-hub с общим контуром семьи, доменными модулями и системными сервисами:
- общий семейный контур: семья, участники, приглашения, роли;
- доменные модули: календарь, задачи, списки, финансовые цели, медиа, уведомления, приватность;
- системные модули: auth, realtime, sync, offline cache/queue, health-check, signed media URLs, background jobs.

## Основные фичи

### 1. Аутентификация и профиль
Этот блок отвечает за личный вход пользователя в приложение и за его персональные настройки. С точки зрения продукта он нужен для того, чтобы у каждого участника семьи была собственная учётная запись, свой профиль, свои уведомления и понятная история действий.

- Email-based auth через Serverpod Auth IDP:
  - старт регистрации;
  - подтверждение кода;
  - завершение регистрации с паролем;
  - логин;
  - reset password через email-код;
  - JWT refresh.
- Профиль пользователя:
  - получение `me`;
  - изменение `displayName`;
  - смена `timezone`;
  - установка и сброс `avatarMediaId`;
  - флаг `analyticsOptIn`.
- В `development` и `test` код подтверждения может логироваться, если SMTP не настроен.

Что это даёт на практике:
- пользователь может зарегистрироваться без отдельного внешнего провайдера вроде Google или Apple;
- вход и восстановление доступа остаются простыми и понятными для семейного приложения;
- имя, аватар и часовой пояс позволяют персонализировать интерфейс и корректно показывать дедлайны, события и напоминания;
- `analyticsOptIn` даёт базу для privacy-aware поведения, где пользователь явно контролирует согласие на аналитику.

Типичные сценарии:
- новый пользователь получает код на email, подтверждает его и создаёт пароль;
- уже зарегистрированный пользователь входит в приложение и продолжает работу со своей семьёй;
- пользователь забывает пароль и восстанавливает доступ через код;
- пользователь обновляет имя, фото и временную зону, чтобы интерфейс и семейные данные отображались корректно.

Детали реализации:
- На сервере auth поднимается в [server.dart](d:\GUAP\family_helper\family_helper_server\lib\server.dart) через `initializeAuthServices(...)`.
- В качестве identity provider используется email-провайдер из `serverpod_auth_idp_server`, а refresh-токены обслуживаются отдельным endpoint-ом `JwtRefreshEndpoint`.
- Основные серверные точки входа:
  - [email_idp_endpoint.dart](d:\GUAP\family_helper\family_helper_server\lib\src\auth\email_idp_endpoint.dart)
  - [jwt_refresh_endpoint.dart](d:\GUAP\family_helper\family_helper_server\lib\src\auth\jwt_refresh_endpoint.dart)
  - [profile_endpoint.dart](d:\GUAP\family_helper\family_helper_server\lib\src\auth_profile\endpoints\profile_endpoint.dart)
- Рассылка verification/reset кодов вынесена в [email_code_dispatcher.dart](d:\GUAP\family_helper\family_helper_server\lib\src\auth\email_code_dispatcher.dart), где есть SMTP-конфигурация и dev/test fallback.
- На клиенте состояние сессии живёт в [auth_session.dart](d:\GUAP\family_helper\family_helper_flutter\lib\core\auth\auth_session.dart): там происходит восстановление auth после старта, sign-in, sign-out и загрузка профиля.
- Клиентский `AppApiClient` создаёт Serverpod `Client`, подключает `FlutterConnectivityMonitor` и `FlutterAuthSessionManager`, а затем вызывает `client.auth.restore()`.
- Профиль редактируется через `profile.me()` и `profile.update(...)`, а DTO приходят из generated-пакета `family_helper_client`.

### 2. Семья и участники
Это центральный доменный модуль всего проекта. Он задаёт саму идею приложения: Family Helper не просто набор личных списков, а совместное пространство семьи, где участники работают с общими календарями, задачами, списками и финансовыми целями.

- Создание семьи.
- Получение текущей семьи и конкретной семьи по `familyId`.
- Переименование семьи.
- Получение списка участников семьи.
- Приглашения:
  - по коду;
  - по email.
- Принятие приглашения по `tokenOrCode`.
- Передача владения семьёй другому участнику.
- Выход из семьи.
- Ограничение числа участников настраивается через `FAMILY_MEMBER_LIMIT`.

Зачем это нужно:
- объединяет пользователей вокруг одной общей сущности семьи;
- даёт понятную модель доступа: кто вообще может видеть семейные данные;
- позволяет управлять жизненным циклом семьи без ручной админки;
- приглашения по коду и email делают onboarding гибким для разных сценариев.

Что можно делать:
- создать новую семью как точку входа в совместную работу;
- пригласить супруга, ребёнка или другого участника через код или email;
- принять приглашение уже существующим аккаунтом;
- переименовать семью, если меняется её название или контекст;
- передать ownership другому участнику;
- покинуть семью, если пользователь больше не должен в ней участвовать.

С продуктовой точки зрения именно этот модуль открывает доступ к остальным feature-модулям. Пока семья не выбрана или не создана, значительная часть функциональности остаётся недоступной.

Детали реализации:
- Публичный API семейного домена собран в [family_endpoint.dart](d:\GUAP\family_helper\family_helper_server\lib\src\family\endpoints\family_endpoint.dart).
- Основная логика разнесена по сервисам:
  - [family_service.dart](d:\GUAP\family_helper\family_helper_server\lib\src\family\services\family_service.dart)
  - [family_service_lifecycle.dart](d:\GUAP\family_helper\family_helper_server\lib\src\family\services\family_service_lifecycle.dart)
  - [family_service_membership.dart](d:\GUAP\family_helper\family_helper_server\lib\src\family\services\family_service_membership.dart)
  - [family_service_invites.dart](d:\GUAP\family_helper\family_helper_server\lib\src\family\services\family_service_invites.dart)
- Email-приглашения обслуживаются отдельным dispatcher-ом [family_invite_email_dispatcher.dart](d:\GUAP\family_helper\family_helper_server\lib\src\family\services\family_invite_email_dispatcher.dart).
- Модели семьи описаны в `.spy.yaml` и затем генерируются в протокол:
  - `family_row`
  - `family_member_row`
  - `family_invite_row`
  - DTO для чтения.
- На клиенте состояние текущей семьи и списка участников живёт в `FamilySelectionCubit` и `FamilyMembersCubit` внутри [family_provider.dart](d:\GUAP\family_helper\family_helper_flutter\lib\features\family_invites\providers\family_provider.dart).
- Семейный выбор влияет на routing: без выбранной семьи роутер блокирует переход в семейные разделы календаря, задач, списков и целей.

### 3. Домашний экран / overview
Домашний экран — это обзорная точка входа в ежедневное использование. Он нужен не для редактирования данных как таковых, а для быстрого понимания: что происходит в семье сейчас, что скоро случится и что требует внимания.

- Сводный dashboard по семье.
- Карточки с агрегатами по:
  - задачам;
  - календарю;
  - спискам;
  - финансовым целям.
- Виджеты `Coming up`, `Needs attention`, spotlight по целям и спискам.
- Быстрая навигация по основным разделам.
- Отображение состава семьи и статуса кешированных данных.

Зачем он полезен:
- снижает необходимость вручную открывать каждый раздел;
- помогает быстро увидеть ближайшие события, важные задачи и прогресс по накоплениям;
- делает приложение более “живым”, показывая состояние семьи как единого пространства;
- подсказывает, где пользователь может продолжить работу в один тап.

Что пользователь получает на этом экране:
- summary по задачам, календарю, спискам и финансовым целям;
- акцент на ближайших событиях;
- акцент на задачах, которым нужно уделить внимание;
- spotlight по активной цели и текущему списку;
- быстрые переходы в нужные разделы;
- индикатор, что данные могут быть показаны из кеша, а не только в live-режиме.

Детали реализации:
- Экран собран в [home_overview_screen.dart](d:\GUAP\family_helper\family_helper_flutter\lib\features\home_overview\presentation\home_overview_screen.dart).
- Он не имеет собственного backend endpoint-а, а агрегирует уже загруженное состояние нескольких feature cubit-ов:
  - `TasksCubit`
  - `CalendarCubit`
  - `ListsCubit`
  - `MoneyGoalsCubit`
  - `NotificationsCubit`
  - `FamilyMembersCubit`
- Вычисление overview-данных вынесено в провайдерный слой `home_overview_provider`.
- Домашний экран использует `CachedDataStatus`, чтобы показывать, что источник данных может быть offline snapshot, а не только свежий ответ сервера.
- По сути это composition layer над доменными фичами, а не отдельный источник правды.

### 4. Календарь
Календарный модуль отвечает за координацию времени внутри семьи. Это не просто список событий, а инструмент для совместного планирования рутины, праздников, встреч, домашних дел и повторяющихся событий.

- CRUD для событий календаря.
- Повторяющиеся события через `rrule`.
- Scope-мутации:
  - только одно событие;
  - все будущие;
  - вся серия.
- Overrides для отдельных инстансов:
  - перенос времени;
  - изменение названия;
  - отмена одного экземпляра;
  - override reminder.
- Просмотр инстансов в диапазоне дат.
- Напоминания по событиям.
- На UI реализован month/agenda сценарий на базе `table_calendar`.

Зачем он нужен:
- позволяет держать семейный график в одном месте;
- поддерживает как одноразовые, так и повторяющиеся события;
- решает реальную бытовую проблему, когда один recurring event нужно частично изменить, но не сломать всю серию;
- помогает не забывать о важных датах и бытовых событиях благодаря напоминаниям.

Что поддерживается по сценариям:
- добавить разовое событие;
- настроить повтор по правилу;
- изменить только один экземпляр события;
- изменить этот и все будущие экземпляры;
- изменить всю серию;
- отменить отдельное повторение без удаления всей серии;
- просматривать события в разрезе месяца и выбранного дня;
- получать напоминания по важным событиям.

В продуктовой модели это один из ключевых shared-модулей, потому что календарь естественно используется всей семьёй, а не отдельным пользователем.

Детали реализации:
- Публичные методы backend-а находятся в [calendar_endpoint.dart](d:\GUAP\family_helper\family_helper_server\lib\src\calendar\endpoints\calendar_endpoint.dart).
- Доменная логика живёт в [calendar_service.dart](d:\GUAP\family_helper\family_helper_server\lib\src\calendar\services\calendar_service.dart).
- Для календаря есть несколько типов моделей:
  - `calendar_event_row` — базовое событие;
  - `calendar_event_override_row` — переопределение конкретного occurrence;
  - `calendar_instance_dto` — уже развёрнутый экземпляр события для UI.
- Такое разделение важно: сервер хранит правило серии и overrides отдельно, а клиент получает уже готовые экземпляры в диапазоне дат.
- Клиентский экран находится в [calendar_screen.dart](d:\GUAP\family_helper\family_helper_flutter\lib\features\calendar\presentation\calendar_screen.dart), а orchestration состояния — в [calendar_provider.dart](d:\GUAP\family_helper\family_helper_flutter\lib\features\calendar\providers\calendar_provider.dart).
- Для редактирования используется `CalendarEventForm`, который отделяет UI-форму от backend DTO.
- Напоминания календаря интегрированы с notifications-модулем, а не реализованы как полностью автономная подсистема.

### 5. Задачи
Модуль задач нужен для распределения бытовых и личных дел внутри семейного пространства. Он сочетает индивидуальные задачи и семейные, чтобы приложение подходило как для личного планирования, так и для координации между участниками.

- Создание и редактирование задач.
- Поля задач:
  - `title` и `description`;
  - personal vs family task;
  - `priority`;
  - due date;
  - due offset mode;
  - recurrence;
  - `assignee`.
- Список задач по семье.
- История задачи.
- Завершение задачи.
- Удаление задачи.
- В acceptance-flow README уже зафиксирован сценарий с recurring-task логикой после completion.

Что даёт этот модуль:
- помогает фиксировать договорённости и не держать их “в голове”;
- позволяет разделять личные и общие задачи;
- даёт приоритеты и дедлайны для наведения порядка;
- поддерживает повторяющиеся сценарии, что особенно полезно для семейной рутины.

Какие сценарии поддерживаются:
- поставить семейную задачу вроде покупки бытовых вещей;
- создать личную задачу, которая остаётся в общем приложении, но логически относится к конкретному участнику;
- назначить исполнителя;
- отметить задачу выполненной;
- посмотреть историю изменений или выполнения;
- использовать recurring task для повторяющихся домашних дел.

С точки зрения продукта это один из модулей, которые напрямую повышают повседневную полезность приложения: календарь отвечает на вопрос “когда”, а задачи — “что нужно сделать”.

Детали реализации:
- Backend API модуля — [tasks_endpoint.dart](d:\GUAP\family_helper\family_helper_server\lib\src\tasks\endpoints\tasks_endpoint.dart).
- Основная серверная логика разнесена по:
  - [tasks_service.dart](d:\GUAP\family_helper\family_helper_server\lib\src\tasks\services\tasks_service.dart)
  - [tasks_service_crud.dart](d:\GUAP\family_helper\family_helper_server\lib\src\tasks\services\tasks_service_crud.dart)
  - [tasks_service_helpers.dart](d:\GUAP\family_helper\family_helper_server\lib\src\tasks\services\tasks_service_helpers.dart)
- Модельный слой включает:
  - `task_row`
  - `task_history_row`
  - `task_history_entry_dto`
  - `task_dto`
- История задачи выделена как отдельная сущность, а не просто как поле внутри задачи. Это упрощает аудит изменений и просмотр timeline.
- Клиентская работа с задачами организована через:
  - [tasks_repository.dart](d:\GUAP\family_helper\family_helper_flutter\lib\features\tasks\data\tasks_repository.dart)
  - [tasks_provider.dart](d:\GUAP\family_helper\family_helper_flutter\lib\features\tasks\providers\tasks_provider.dart)
  - экран [tasks_screen.dart](d:\GUAP\family_helper\family_helper_flutter\lib\features\tasks\presentation\tasks_screen.dart)
- Для редактирования используется отдельная форма `TaskForm`, а UI-редактор вынесен в `task_editor_sheet`.

### 6. Списки
Списки решают повседневные операционные сценарии семьи: поход в магазин, домашние мелочи, короткие чек-листы, списки покупок и совместные todo-подборки. Это быстрый и лёгкий модуль, который часто используется чаще, чем более “тяжёлые” разделы.

- Семейные списки типов `shopping` и `todo`.
- Создание, редактирование и удаление списка.
- Элементы списка:
  - `title`;
  - `qty` и `unit`;
  - `note`;
  - `priceCents`;
  - `category`.
- Переключение статуса `bought`.
- Удаление элемента.
- Reorder элементов.
- Просмотр items списка.
- В моделях есть history-сущности для списков и элементов.

Зачем этот блок нужен:
- позволяет быстро фиксировать вещи “на бегу”;
- хорошо подходит для совместного использования несколькими участниками;
- цена, категория и количество делают список ближе к реальным shopping-сценариям;
- reorder и переключение `bought` улучшают бытовой UX.

Что можно делать:
- создать список покупок;
- создать общий todo-список;
- добавлять позиции с количеством, единицами, заметкой и ценой;
- помечать позицию купленной;
- менять порядок элементов;
- удалять элементы и целые списки.

Это один из самых приземлённых и прикладных модулей: он не про абстрактное планирование, а про конкретные бытовые действия.

Детали реализации:
- API модуля находится в [lists_endpoint.dart](d:\GUAP\family_helper\family_helper_server\lib\src\lists\endpoints\lists_endpoint.dart).
- Логика разделена на подчасти:
  - [lists_service.dart](d:\GUAP\family_helper\family_helper_server\lib\src\lists\services\lists_service.dart)
  - [lists_service_lists.dart](d:\GUAP\family_helper\family_helper_server\lib\src\lists\services\lists_service_lists.dart)
  - [lists_service_items.dart](d:\GUAP\family_helper\family_helper_server\lib\src\lists\services\lists_service_items.dart)
- В модели есть как список (`family_list_row`), так и элемент (`list_item_row`), плюс история элемента (`list_item_history_row`).
- Отдельный endpoint `reorderItems(...)` показывает, что порядок элементов является частью доменной модели, а не только клиентской сортировкой.
- На Flutter-стороне работа идёт через [lists_repository.dart](d:\GUAP\family_helper\family_helper_flutter\lib\features\lists\data\lists_repository.dart) и [lists_provider.dart](d:\GUAP\family_helper\family_helper_flutter\lib\features\lists\providers\lists_provider.dart).
- Для списков дополнительно виден слой кеширования провайдера: [lists_provider_cache.dart](d:\GUAP\family_helper\family_helper_flutter\lib\features\lists\providers\lists_provider_cache.dart).

### 7. Финансовые цели
Финансовые цели превращают приложение из просто семейного органайзера в инструмент совместного движения к крупным покупкам или планам. Это не полноценный банковский модуль, а именно трекер накоплений и вкладов.

- Создание и редактирование финансовой цели.
- Поля:
  - `title` и `description`;
  - `targetAmountCents`;
  - `currency`;
  - `deadline`.
- Пополнение цели.
- Снятие средств.
- Архивация цели.
- Удаление цели.
- История изменений и вкладов.
- Деньги хранятся в `*_amount_cents`, валюта строкой, по умолчанию используется `RUB`.

Зачем это нужно:
- помогает семье видеть общий прогресс по накоплениям;
- делает совместные цели прозрачными;
- позволяет фиксировать как пополнения, так и снятия;
- история даёт понятность, откуда взялся текущий баланс.

Поддерживаемые сценарии:
- создать цель “отпуск”, “ремонт”, “техника”, “детская покупка”;
- указывать сумму цели и дедлайн;
- вносить вклад;
- забирать часть средств обратно;
- архивировать завершённую или больше неактуальную цель;
- просматривать историю операций.

Хранение в cents вместо дробных денег — важное инженерное решение, которое одновременно полезно и продукту: оно минимизирует ошибки округления в финансовых сценариях.

Детали реализации:
- Серверный API описан в [money_goals_endpoint.dart](d:\GUAP\family_helper\family_helper_server\lib\src\money_goals\endpoints\money_goals_endpoint.dart).
- Бизнес-логика разбита на:
  - [money_goals_service.dart](d:\GUAP\family_helper\family_helper_server\lib\src\money_goals\services\money_goals_service.dart)
  - [money_goals_service_crud.dart](d:\GUAP\family_helper\family_helper_server\lib\src\money_goals\services\money_goals_service_crud.dart)
  - [money_goals_service_helpers.dart](d:\GUAP\family_helper\family_helper_server\lib\src\money_goals\services\money_goals_service_helpers.dart)
- Сущности разделены на:
  - цель (`money_goal_row`);
  - вклад/снятие (`money_contribution_row`);
  - DTO для чтения;
  - history entry.
- Пополнение и снятие сделаны отдельными серверными методами, а не одной общей мутацией с разными знаками суммы. Это упрощает читаемость и бизнес-валидацию.
- На клиенте используются [money_goals_repository.dart](d:\GUAP\family_helper\family_helper_flutter\lib\features\money_goals\data\money_goals_repository.dart), [money_goals_provider.dart](d:\GUAP\family_helper\family_helper_flutter\lib\features\money_goals\providers\money_goals_provider.dart) и экран [money_goals_screen.dart](d:\GUAP\family_helper\family_helper_flutter\lib\features\money_goals\presentation\money_goals_screen.dart).

### 8. Медиа и аватары
Медиа-модуль отвечает за работу с файлами и изображениями. На пользовательском уровне это нужно в первую очередь для аватаров и связанного с ними UX, но архитектурно модуль заложен шире и поддерживает приватную работу с медиаконтентом.

- Создание upload session.
- Direct upload в Serverpod storage.
- Завершение загрузки.
- Получение signed download URL.
- Просмотр списка медиа.
- Soft delete.
- Приватное хранилище с HMAC-подписанными ссылками и TTL.
- На клиенте есть flow pick -> crop -> upload изображения, включая аватары.

Что здесь важно:
- загрузка разбита на отдельные шаги, что удобнее и безопаснее с точки зрения backend flow;
- прямой upload разгружает серверное приложение;
- signed URL позволяет безопасно открывать приватные файлы;
- crop на клиенте улучшает UX для аватаров и уменьшает мусорные загрузки.

Что пользователь может делать:
- выбрать изображение;
- обрезать его перед загрузкой;
- загрузить медиаобъект;
- использовать его как аватар;
- получить доступ к загруженному объекту через подписанный URL;
- удалять больше не нужные медиаобъекты.

С точки зрения безопасности это один из важных модулей, потому что он работает с приватными файлами и не делает их публичными по умолчанию.

Детали реализации:
- Серверный входной слой — [media_endpoint.dart](d:\GUAP\family_helper\family_helper_server\lib\src\media\endpoints\media_endpoint.dart).
- Основная логика лежит в [media_service.dart](d:\GUAP\family_helper\family_helper_server\lib\src\media\services\media_service.dart).
- Для приватных файлов используется [private_media_storage_service.dart](d:\GUAP\family_helper\family_helper_server\lib\src\core\storage\private_media_storage_service.dart), который:
  - создаёт direct upload URL;
  - проверяет факт загрузки;
  - генерирует signed download URL;
  - валидирует подпись и срок действия ссылки.
- Подписание сделано через HMAC SHA-256, а срок жизни URL регулируется TTL.
- На клиенте медиа-поток реализован через [media_repository.dart](d:\GUAP\family_helper\family_helper_flutter\lib\features\media\data\media_repository.dart), где используются `image_picker`, `image_cropper` и `dio`.
- Экран для ручного тестирования и просмотра медиа находится в [media_screen.dart](d:\GUAP\family_helper\family_helper_flutter\lib\features\media\presentation\media_screen.dart).
- Аватары также интегрированы в профиль и семейный UI через компонент `FamilyMemberAvatar`.

### 9. Уведомления
Модуль уведомлений нужен, чтобы приложение не было пассивным хранилищем данных. Он возвращает пользователя в контекст семейных дел: напоминает о событиях, задачах и изменениях, а также показывает внутренний inbox прямо в приложении.

- Регистрация push token устройства.
- Отправка test push.
- Пользовательские notification preferences.
- Quiet hours.
- Планирование reminder.
- Replace и cancel reminder.
- Inbox приложенческих уведомлений.
- `markRead`, `markAllRead`, `unreadCount`.
- На клиенте поддерживаются:
  - локальные уведомления;
  - FCM push;
  - обработка foreground, background и open flows;
  - web/browser notification path.

Зачем это нужно:
- снижает риск забыть о важном;
- делает семейное приложение реально полезным в ежедневной жизни;
- даёт контроль пользователю через preferences и quiet hours;
- позволяет сочетать локальные и удалённые каналы уведомлений.

Какие сценарии поддерживаются:
- зарегистрировать устройство на push;
- включать и выключать отдельные типы уведомлений;
- задавать quiet hours;
- планировать напоминания по сущностям;
- заменять уже существующее reminder;
- открывать inbox приложения и отмечать уведомления прочитанными;
- тестировать доставку push на реальном устройстве.

На уровне продукта это критичный модуль, потому что без уведомлений многие функции календаря и задач перестают быть достаточно “оперативными”.

Детали реализации:
- Backend API находится в [notifications_endpoint.dart](d:\GUAP\family_helper\family_helper_server\lib\src\notifications\endpoints\notifications_endpoint.dart).
- Сервисный слой разбит на несколько частей:
  - [notifications_service.dart](d:\GUAP\family_helper\family_helper_server\lib\src\notifications\services\notifications_service.dart)
  - `notifications_service_preferences`
  - `notifications_service_reminders`
  - `notifications_service_tokens`
  - [app_notification_service.dart](d:\GUAP\family_helper\family_helper_server\lib\src\notifications\services\app_notification_service.dart)
  - [push_dispatch_service.dart](d:\GUAP\family_helper\family_helper_server\lib\src\notifications\services\push_dispatch_service.dart)
- Это означает, что внутри модуля логика разделена по ответственности: токены, reminder-расписание, пользовательские preferences, inbox-уведомления и фактическая push-доставка.
- Доставка в FCM идёт через HTTP v1 API и service account credentials, загружаемые из `passwords.yaml`.
- На клиенте есть два канала:
  - [local_notification_service.dart](d:\GUAP\family_helper\family_helper_flutter\lib\features\notifications\data\local_notification_service.dart) для on-device уведомлений;
  - [push_notification_service.dart](d:\GUAP\family_helper\family_helper_flutter\lib\features\notifications\data\push_notification_service.dart) для Firebase Messaging.
- Есть отдельный слой навигации по клику на уведомление: [notification_navigation_service.dart](d:\GUAP\family_helper\family_helper_flutter\lib\features\notifications\data\notification_navigation_service.dart).
- UI разделён на центр уведомлений и настройки, а состояние живёт в [notifications_provider.dart](d:\GUAP\family_helper\family_helper_flutter\lib\features\notifications\providers\notifications_provider.dart).

### 10. Privacy / Security
Privacy-блок закрывает вопросы прозрачности и доверия. Для семейного приложения это особенно важно, потому что оно работает с персональными профилями, семейными данными, расписанием, вложениями и историей действий.

- Запрос экспорта персональных данных.
- Получение статуса экспорта.
- Запрос удаления аккаунта.
- Отмена удаления.
- Hard deletion и export processing вынесены во внутренние worker-процессы.
- Есть core-модели для:
  - audit log;
  - security events;
  - idempotency keys;
  - change feed;
  - app profile.

Зачем это нужно:
- даёт пользователю контроль над собственными данными;
- делает систему ближе к privacy-by-design подходу;
- снижает зависимость от ручной поддержки со стороны разработчиков;
- создаёт фундамент для дальнейшей прозрачности и compliance-процессов.

Практические сценарии:
- запросить экспорт накопленных данных;
- проверить статус экспорта;
- скачать готовый результат, пока он доступен;
- запросить удаление аккаунта;
- отменить удаление, если пользователь передумал.

Отдельно важно, что тяжёлые privacy-операции вынесены в воркеры, а не выполняются синхронно в пользовательском запросе. Это делает UX устойчивее и лучше подходит для реального production-поведения.

Детали реализации:
- Публичный API описан в [privacy_endpoint.dart](d:\GUAP\family_helper\family_helper_server\lib\src\privacy\endpoints\privacy_endpoint.dart).
- Основная логика находится в [privacy_service.dart](d:\GUAP\family_helper\family_helper_server\lib\src\privacy\services\privacy_service.dart).
- Для privacy-операций есть отдельные модели:
  - `privacy_export_job_row`
  - `privacy_export_job_dto`
  - `account_deletion_request_row`
  - `account_deletion_status_dto`
  - `privacy_status_dto`
- Тяжёлые отложенные операции вынесены в FutureCall workers:
  - [privacy_export_call.dart](d:\GUAP\family_helper\family_helper_server\lib\src\workers\privacy_export_call.dart)
  - [account_deletion_call.dart](d:\GUAP\family_helper\family_helper_server\lib\src\workers\account_deletion_call.dart)
- Клиентская работа с privacy вынесена в [privacy_repository.dart](d:\GUAP\family_helper\family_helper_flutter\lib\features\privacy_security\data\privacy_repository.dart) и [privacy_provider.dart](d:\GUAP\family_helper\family_helper_flutter\lib\features\privacy_security\providers\privacy_provider.dart).
- Экран [privacy_security_screen.dart](d:\GUAP\family_helper\family_helper_flutter\lib\features\privacy_security\presentation\privacy_security_screen.dart) также связывает privacy-status с legal/document links через `url_launcher`.

### 11. Realtime, sync и offline
Этот блок отвечает за ощущение “живого” и устойчивого приложения. Он нужен, чтобы несколько участников семьи могли видеть актуальные изменения, а пользователь не терял полезность приложения при нестабильной сети.

- Realtime stream `watchFamilyEvents(familyId)`.
- После realtime invalidation клиент вызывает `sync.changes(...)`.
- Есть change feed для синхронизации изменений и tombstone-подобного поведения.
- На клиенте реализованы:
  - offline operation queue;
  - offline snapshot store;
  - replay manager с backoff;
  - cached-data indicators в UI.
- Серверная доступность проверяется через `health.ping`.
- Для Android emulator есть адаптация loopback URL на `10.0.2.2`.

Что это даёт:
- изменения, сделанные одним участником, могут быстро появляться у других;
- приложение не обязано каждый раз полностью перезагружать все данные;
- данные могут кэшироваться локально;
- операции можно аккуратно повторять после восстановления сети;
- пользователь видит, когда интерфейс работает из кеша.

Сценарии, которые это поддерживает:
- один участник создал задачу, другой видит обновление без ручного перезапуска;
- приложение временно теряет связь с сервером, но пользователь всё равно видит последние доступные данные;
- queued операции могут быть повторены позже;
- health-check помогает интерфейсу понять, онлайн сейчас backend или нет.

Это одна из самых важных архитектурных особенностей проекта: здесь заметен фокус не только на наборе экранов, но и на качестве повседневного использования.

Детали реализации:
- Серверный realtime endpoint — [realtime_endpoint.dart](d:\GUAP\family_helper\family_helper_server\lib\src\realtime\endpoints\realtime_endpoint.dart).
- Он использует `session.messages.createStream(...)` и публикует события по family-каналу через [realtime_publisher.dart](d:\GUAP\family_helper\family_helper_server\lib\src\core\realtime\realtime_publisher.dart).
- Перед подпиской применяется RBAC-проверка через [ensure_family_role_service.dart](d:\GUAP\family_helper\family_helper_server\lib\src\core\rbac\ensure_family_role_service.dart).
- Серверный sync endpoint — [sync_endpoint.dart](d:\GUAP\family_helper\family_helper_server\lib\src\sync\endpoints\sync_endpoint.dart), а логика change feed сосредоточена в:
  - [sync_service.dart](d:\GUAP\family_helper\family_helper_server\lib\src\sync\services\sync_service.dart)
  - [change_feed_service.dart](d:\GUAP\family_helper\family_helper_server\lib\src\core\sync\change_feed_service.dart)
- На клиенте realtime и sync разделены:
  - [realtime_subscription_manager.dart](d:\GUAP\family_helper\family_helper_flutter\lib\core\realtime\realtime_subscription_manager.dart) отвечает за stream subscription;
  - [sync_controller.dart](d:\GUAP\family_helper\family_helper_flutter\lib\core\sync\sync_controller.dart) отвечает за pull-based получение изменений.
- Offline-слой тоже разнесён по ответственности:
  - [sqlite_offline_operation_queue.dart](d:\GUAP\family_helper\family_helper_flutter\lib\core\offline\sqlite_offline_operation_queue.dart) — очередь pending операций;
  - [sqlite_offline_snapshot_store.dart](d:\GUAP\family_helper\family_helper_flutter\lib\core\offline\sqlite_offline_snapshot_store.dart) — кеш снимков данных;
  - [offline_queue_manager.dart](d:\GUAP\family_helper\family_helper_flutter\lib\core\offline\offline_queue_manager.dart) — replay и backoff.
- Доступность сервера проверяет [server_availability_cubit.dart](d:\GUAP\family_helper\family_helper_flutter\lib\core\network\server_availability_cubit.dart), который периодически вызывает `health.ping()`.

### 12. Web и служебные сценарии
Проект не ограничивается только мобильным приложением. Серверная web-часть и служебные маршруты нужны для развёртывания Flutter Web, runtime-конфигурации, юридических документов и приватной доставки медиа.

- Сервер умеет:
  - отдавать Flutter web app под `/app`;
  - отдавать runtime `config.json` с API URL;
  - обслуживать `/private-media`;
  - раздавать legal PDF и static assets.
- Если web build отсутствует, сервер показывает fallback page.
- Есть `greeting` endpoint и `health` endpoint как служебные точки.

Зачем это полезно:
- позволяет использовать один backend не только как API, но и как точку выдачи web-клиента;
- упрощает web-деплой;
- делает возможной runtime-подстановку API URL для собранного клиента;
- хранит legal-материалы рядом с приложением;
- даёт отдельный защищённый маршрут для приватных файлов.

Практически это означает, что проект уже заложен не как чисто локальный mobile prototype, а как сервис, который можно разворачивать и использовать в более “настоящем” окружении.

Детали реализации:
- Серверная инициализация web-маршрутов находится в [server.dart](d:\GUAP\family_helper\family_helper_server\lib\server.dart).
- Для runtime-конфига есть отдельный маршрут [app_config_route.dart](d:\GUAP\family_helper\family_helper_server\lib\src\web\routes\app_config_route.dart), который отдаёт JSON с API URL для web-клиента.
- Для приватных файлов используется [private_media_route.dart](d:\GUAP\family_helper\family_helper_server\lib\src\web\routes\private_media_route.dart).
- Корневой веб-маршрут оформлен в [root.dart](d:\GUAP\family_helper\family_helper_server\lib\src\web\routes\root.dart).
- Если Flutter web build существует в `web/app`, сервер раздаёт его через `FlutterRoute`; если нет, отдаётся fallback page `build_flutter_app.html`.
- Статические legal-файлы и изображения лежат в `family_helper_server/web/static/...` и обслуживаются как обычные static routes.

## Зависимости и зачем они нужны

### Backend: `family_helper_server`
- `serverpod`:
  - база backend-а;
  - RPC endpoints;
  - ORM и таблицы;
  - migrations;
  - file storage;
  - message streams;
  - FutureCall workers.
- `serverpod_auth_idp_server`:
  - email identity provider;
  - registration, login, reset password;
  - интеграция auth flow с JWT.
- `serverpod_auth_core_server`:
  - core auth-модели и server-side auth context.
- `crypto`:
  - HMAC SHA-256 для signed private media URLs;
  - дополнительные crypto-операции в auth flow.
- `googleapis_auth`:
  - service-account авторизация к Firebase Cloud Messaging HTTP v1 API.
- `http`:
  - HTTP-клиент для отправки FCM push.
- `mailer`:
  - SMTP-отправка email-кодов регистрации, reset и email-приглашений.

### Flutter app: `family_helper_flutter`
- `flutter` и `cupertino_icons`:
  - базовый UI.
- `firebase_core`:
  - инициализация Firebase.
- `firebase_messaging`:
  - FCM push, token refresh, background/open handling.
- `flutter_bloc`:
  - основной state management в текущем коде.
- `get_it`:
  - service locator и DI.
- `go_router`:
  - декларативный роутинг и guarded navigation.
- `dio`:
  - HTTP-пробы и прямые upload/download сценарии вне стандартного Serverpod RPC.
- `connectivity_plus`:
  - мониторинг connectivity через `FlutterConnectivityMonitor`.
- `flutter_secure_storage`:
  - хранение чувствительных локальных значений и системных флагов.
- `uuid`:
  - генерация `clientOperationId` для идемпотентных мутаций.
- `sqflite`:
  - локальная offline queue и offline snapshot storage.
- `path` и `path_provider`:
  - вычисление и размещение путей локальных SQLite-баз.
- `flutter_local_notifications`:
  - локальные reminder и inbox notifications на устройстве.
- `timezone`:
  - корректное планирование локальных уведомлений по времени.
- `image_picker`:
  - выбор изображений пользователем.
- `image_cropper`:
  - обрезка изображения перед upload.
- `url_launcher`:
  - открытие privacy, legal и export links.
- `table_calendar`:
  - month/calendar UI.
- `serverpod_flutter`:
  - клиент Serverpod, transport и connectivity monitor.
- `serverpod_auth_core_flutter`:
  - хранение и восстановление auth session на клиенте.
- `serverpod_auth_idp_client`:
  - typed client-side auth exceptions и models.
- `serverpod_auth_idp_flutter`:
  - Flutter-side integration для auth IDP flow.
- `family_helper_client`:
  - локальный пакет со сгенерированным Serverpod protocol/client.

### Generated client package: `family_helper_client`
- `serverpod_client`:
  - базовый Serverpod RPC client.
- `serverpod_auth_idp_client`:
  - auth IDP client types.

### Внешняя инфраструктура
- `PostgreSQL`:
  - основная БД для бизнес-данных, auth, storage metadata, audit и change feed.
- `Redis`:
  - нужен Serverpod для realtime, message и future-call инфраструктуры.
- `Docker Compose`:
  - локальный запуск Postgres и Redis.
- `Firebase / FCM`:
  - удалённые push-уведомления.
- `SMTP`:
  - email-коды и email-приглашения.
- `Serverpod storage`:
  - хранение приватных файлов; media bytes сохраняются в built-in cloud storage tables.

## Архитектурные наблюдения
- Flutter-клиент организован по feature-first схеме: `domain/data/providers/presentation`.
- Сервер также разбит на доменные модули: `family`, `calendar`, `tasks`, `lists`, `money_goals`, `media`, `notifications`, `privacy`.
- Почти все мутации принимают `clientOperationId`, то есть проект построен вокруг идемпотентности.
- Realtime и sync работают в связке: invalidation event -> `sync.changes(...)` -> обновление feature state.
- Фоновые процессы оформлены через `FutureCallRegistry`: reminders, media cleanup, privacy export, account deletion.
- В клиентском README раньше было указано `Riverpod + BLoC`, но фактически основной runtime-стек состояния сейчас — `BLoC/Cubit + GetIt`.

Дополнительные детали реализации:
- Значительная часть серверной схемы описывается через `.spy.yaml`, после чего генерируется Serverpod-код для protocol, row-типов, endpoint dispatch и клиентского пакета.
- [generator.yaml](d:\GUAP\family_helper\family_helper_server\config\generator.yaml) связывает сервер с локальным клиентским пакетом `family_helper_client`.
- Generated-файлы в `family_helper_server/lib/src/generated` и `family_helper_client/lib/src/protocol` являются производными артефактами и отражают контракт между backend и Flutter-клиентом.
- На сервере повторяется устойчивый паттерн: `endpoint -> service -> helper/service split -> generated models`.
- На клиенте повторяется паттерн: `repository -> cubit/bloc -> presentation`, а DI выполняется через [service_locator.dart](d:\GUAP\family_helper\family_helper_flutter\lib\core\di\service_locator.dart) и модули регистрации сервисов.
- Routing централизован в [app_router.dart](d:\GUAP\family_helper\family_helper_flutter\lib\core\routing\app_router.dart), а bootstrap приложения — в [main.dart](d:\GUAP\family_helper\family_helper_flutter\lib\main.dart).
- Для background/periodic серверной работы используется [future_call_registry.dart](d:\GUAP\family_helper\family_helper_server\lib\src\workers\future_call_registry.dart), который регистрирует и планирует повторяющиеся job-ы после старта сервера.

## Подробно об архитектуре

### 1. Архитектура монорепозитория
Проект организован как единый монорепозиторий, где backend, generated client и Flutter app живут рядом и развиваются синхронно. Это важное архитектурное решение: контракт между сервером и клиентом не хранится в отдельном внешнем сервисе или вручную поддерживаемом SDK, а генерируется из одного источника правды внутри того же репозитория.

Слои монорепозитория:
- `family_helper_server`:
  - исходная серверная логика;
  - endpoint-ы;
  - модели `.spy.yaml`;
  - миграции;
  - web-маршруты;
  - фоновые задачи.
- `family_helper_client`:
  - generated protocol;
  - generated endpoint client;
  - DTO и row-типы для использования на клиенте.
- `family_helper_flutter`:
  - пользовательский интерфейс;
  - состояние приложения;
  - интеграция с generated client;
  - offline/realtime/notification-инфраструктура.

Преимущество такой схемы:
- backend и Flutter-клиент синхронизируются через генерацию, а не ручное копирование API-контрактов;
- проще контролировать совместимость изменений;
- миграции, protocol-модели и конечный UI развиваются в одном контексте;
- меньше риска расхождения серверного API и клиентских ожиданий.

### 2. Серверная архитектура
Backend построен вокруг `Serverpod` и использует типичную для него схему:
- endpoint layer;
- service layer;
- generated protocol/models;
- database/storage/realtime инфраструктура;
- background workers.

#### 2.1 Endpoint layer
Endpoint-ы — это публичная RPC-поверхность приложения. Они определяют, какие методы доступны клиенту, с какими параметрами и какими возвращаемыми типами. Почти все бизнес-функции открываются не через REST-контроллеры, а через Serverpod endpoint methods.

Основные endpoint-ы:
- auth/profile:
  - `emailIdp`
  - `jwtRefresh`
  - `profile`
- доменные:
  - `family`
  - `calendar`
  - `tasks`
  - `lists`
  - `moneyGoals`
  - `media`
  - `notifications`
  - `privacy`
- системные:
  - `realtime`
  - `sync`
  - `health`
  - `greeting`

Характерная черта: endpoint-ы в проекте в основном тонкие. Они не перегружены логикой, а делегируют выполнение сервисам. Это правильно разделяет публичный API и внутреннюю доменную реализацию.

#### 2.2 Service layer
Service layer — главное место бизнес-логики. Именно здесь принимаются решения:
- кто имеет доступ;
- можно ли выполнить операцию;
- как изменяются данные;
- какие побочные эффекты нужно запустить;
- какие realtime/sync/audit события нужно записать.

Во многих доменах сервисы дополнительно разбиты на подмодули:
- lifecycle;
- membership;
- invites;
- CRUD;
- helpers;
- reminders/preferences/tokens и т.д.

Такое дробление полезно по двум причинам:
- уменьшает размер одного файла и локализует ответственность;
- позволяет отделять “ядро” модуля от вторичных утилит и вспомогательной логики.

#### 2.3 Модельный слой и генерация
Модели на сервере описываются через `.spy.yaml`, а затем `serverpod generate` превращает их в:
- server-side row классы;
- protocol DTO;
- endpoint dispatch код;
- клиентские типы в `family_helper_client`.

Это означает, что сервер использует два уровня моделей:
- persistence models:
  - строки таблиц;
  - служат для ORM и БД;
- transport models:
  - DTO;
  - служат для передачи данных клиенту.

Такое разделение особенно полезно в сложных доменах:
- calendar:
  - базовое событие;
  - override;
  - instance DTO;
- tasks:
  - row;
  - history row;
  - history DTO;
- privacy:
  - job rows;
  - status DTO.

#### 2.4 Инфраструктурные серверные сервисы
Кроме доменных сервисов на сервере есть сквозные инфраструктурные подсистемы:
- auth context;
- RBAC;
- audit;
- security events;
- idempotency;
- sync change feed;
- realtime publisher;
- private media storage;
- background worker registry.

Это архитектурно важно, потому что проект не ограничивается CRUD-логикой. В нём есть слой cross-cutting concerns, который обеспечивает:
- безопасность;
- устойчивость;
- согласованность изменений;
- повторяемость операций;
- наблюдаемость и трассируемость.

### 3. Клиентская архитектура Flutter
Flutter-приложение организовано по feature-first подходу. Вместо того чтобы группировать код по техническим типам на уровне всего приложения, проект группирует его по предметным областям.

Типичная структура feature:
- `domain`
- `data`
- `providers`
- `presentation`

Это даёт несколько преимуществ:
- проще ориентироваться в коде конкретной фичи;
- UI, состояние и доступ к данным лежат рядом;
- развитие новых модулей не требует расползания по десяткам общих папок.

#### 3.1 Presentation layer
Слой `presentation` содержит экраны, листы, диалоги, layout helper-ы и визуальные компоненты feature-уровня. Он отвечает за:
- сборку интерфейса;
- пользовательские взаимодействия;
- вызов команд состояния;
- показ loading/error/cached states.

Общая UI-инфраструктура, которая переиспользуется между экранами, вынесена в `lib/ui_kit`.

#### 3.2 State layer
В рантайме приложение опирается на `BLoC/Cubit`, а не на Riverpod.
Основные задачи state layer:
- загрузка данных;
- вызов мутаций;
- хранение loading/error flags;
- orchestration после user actions;
- реакция на offline/realtime/sync события.

У проекта есть два типа состояния:
- feature state:
  - `TasksCubit`
  - `CalendarCubit`
  - `ListsCubit`
  - `MoneyGoalsCubit`
  - `NotificationsCubit`
  - `PrivacyCubit`
  - `FamilyMembersCubit`
  - и т.д.
- global state:
  - `AuthCubit`
  - `ThemeCubit`
  - `ServerAvailabilityCubit`
  - семейный selection state.

#### 3.3 Data layer
Слой `data` отвечает за общение с backend и локальной инфраструктурой. В типичной фиче repository:
- обращается к generated client;
- иногда работает с offline snapshot store;
- преобразует данные для feature state;
- централизует сетевые ошибки.

Это означает, что presentation не зависит напрямую от endpoint-вызовов, а работает через feature repository и cubit/bloc.

#### 3.4 DI и bootstrap
DI построен на `GetIt`.
При старте:
- создаётся `AppApiClient`;
- поднимаются offline queue и snapshot store;
- инициализируются notification services;
- регистрируются repositories;
- создаются global cubit-ы.

Это даёт аккуратное разделение:
- сервисы инфраструктуры;
- repositories;
- global state;
- feature state внутри authenticated scope.

### 4. Слой контракта между сервером и клиентом
Один из самых важных архитектурных элементов проекта — это generated client package `family_helper_client`.

Он выполняет роль промежуточного контракта между:
- server-side endpoint/method definitions;
- protocol-моделями;
- Flutter UI-кодом.

Поток выглядит так:
1. Модели и endpoint-ы определяются в серверном пакете.
2. `serverpod generate` создаёт:
   - server generated code;
   - client generated package.
3. Flutter подключает `family_helper_client` как локальную зависимость.
4. Репозитории и cubit-ы работают уже с типизированным client API.

Это снижает риск ошибок:
- меньше ручной сериализации;
- нет дублирования DTO между backend и frontend;
- типы параметров и ответов жёстко контролируются.

### 5. Поток данных в приложении
Архитектурно полезно смотреть на проект как на несколько повторяющихся data flow цепочек.

#### 5.1 Обычный read flow
1. Пользователь открывает экран.
2. Экран вызывает метод cubit/bloc.
3. Cubit обращается к repository.
4. Repository вызывает generated client endpoint.
5. Server endpoint делегирует запрос service layer.
6. Service layer читает БД и возвращает DTO.
7. DTO приходит в Flutter и записывается в feature state.
8. UI перестраивается.

#### 5.2 Mutation flow
1. Пользователь нажимает действие в UI.
2. Cubit формирует команду и `clientOperationId`.
3. Repository вызывает backend mutation.
4. Server service:
   - валидирует доступ;
   - применяет изменения;
   - пишет idempotency/check feed/audit при необходимости;
   - публикует realtime invalidation.
5. Клиент получает результат мутации.
6. Далее состояние может обновиться:
   - напрямую из ответа;
   - через последующий reload;
   - через realtime + sync.

#### 5.3 Realtime + sync flow
1. Один клиент меняет данные.
2. Сервер фиксирует изменение и публикует family event.
3. Другой клиент получает realtime событие.
4. Клиент вызывает `sync.changes(...)`.
5. Получает инкрементальные изменения из change feed.
6. Инвалидирует или обновляет feature state.

#### 5.4 Offline flow
1. Клиент временно не может обратиться к серверу.
2. Последние snapshots продолжают использоваться для чтения.
3. Некоторые операции могут попадать в offline queue.
4. После восстановления сети queue replay manager повторяет операции.
5. UI показывает cached-data status и доступность сервера.

### 6. Идемпотентность как архитектурный принцип
Во многих доменных мутациях используется `clientOperationId`.
Это означает, что система проектировалась с расчётом на:
- повторные отправки запросов;
- нестабильную сеть;
- replay операций;
- защиту от случайного дублирования изменений.

Практический смысл:
- если клиент повторно отправит команду, сервер может распознать, что операция уже применялась;
- это особенно важно для:
  - создания сущностей;
  - финансовых операций;
  - изменения recurring данных;
  - offline replay.

С архитектурной точки зрения это делает проект заметно более production-ready.

### 7. Realtime и sync как два разных механизма
Важно, что realtime в проекте не пытается быть единственным источником данных. Он не переносит полный state, а служит триггером на обновление.

Разделение выглядит так:
- realtime:
  - быстрый сигнал, что что-то изменилось;
  - работает через message streams;
  - лёгкий по payload.
- sync:
  - фактическое получение изменений;
  - работает через change feed;
  - возвращает уже структурированные изменения.

Это архитектурно хорошее решение:
- realtime остаётся дешёвым и простым;
- sync отвечает за согласованность данных;
- клиент не зависит от полного snapshot payload в realtime-событии.

### 8. Offline-архитектура
Offline в проекте тоже разделён на два независимых слоя:
- snapshot store;
- operation queue.

#### 8.1 Snapshot store
Нужен для чтения уже известных данных, когда сеть пропадает.
Он отвечает за:
- кеширование payload;
- хранение времени последнего обновления;
- показ cached state в UI.

#### 8.2 Operation queue
Нужна для отложенного выполнения мутаций.
Она хранит:
- feature;
- action;
- payload;
- время создания;
- attempt counter.

Повторное выполнение управляется через `OfflineQueueManager`, который использует backoff. Это значит, что проект проектировался не просто как “кешировать ответ”, а как система с частичной устойчивостью к сетевым сбоям.

### 9. Архитектура уведомлений
Уведомления в проекте реализованы как многоуровневая система:
- серверный reminder/inbox/push слой;
- локальный on-device слой;
- navigation слой после открытия уведомления;
- пользовательские preferences.

Сервер отвечает за:
- хранение reminder schedule;
- построение app notifications;
- доставку remote push.

Клиент отвечает за:
- системные permissions;
- локальное планирование;
- foreground presentation;
- open-action routing.

Это разделение важно, потому что не вся ответственность за уведомления лежит на Firebase. Firebase тут только транспорт для remote push, а сама доменная модель уведомлений принадлежит приложению.

### 10. Архитектура медиа и приватных файлов
Медиа-часть тоже реализована как отдельный архитектурный контур:
- модель media-object;
- direct upload flow;
- завершение загрузки как отдельный шаг;
- signed private access;
- soft delete;
- cleanup worker.

Почему это важно:
- приложение не делает файлы публичными напрямую;
- загрузка и чтение файлов контролируются сервером;
- ссылки короткоживущие;
- можно ввести фоновую уборку и lifecycle management файлов.

Это уже архитектура уровня реального сервиса, а не просто загрузка картинки в UI.

### 11. Background workers и отложенные процессы
В проекте явно выделен слой фоновых задач через `FutureCallRegistry`.
Сейчас туда входят:
- due reminders;
- media cleanup;
- privacy export;
- account deletion.

Архитектурная польза такого решения:
- тяжёлые или периодические операции не блокируют пользовательские запросы;
- сервер может планировать повторяющиеся job-ы при старте;
- бизнес-операции можно делать надёжнее и предсказуемее;
- privacy и cleanup процессы не “живут” внутри обычных endpoint-ов.

Это особенно важно для production-сценариев, где запрос пользователя не должен ждать долгую background-работу.

### 12. Web-архитектура и раздача клиента
Сервер выступает не только как API, но и как hosting layer для Flutter Web.
В результате проект сочетает:
- API server;
- static file server;
- app config server;
- private file gateway.

Это даёт гибкую архитектуру деплоя:
- можно раздавать frontend и backend вместе;
- можно генерировать runtime-конфиг без пересборки всех URL;
- legal assets и web app лежат рядом;
- приватные медиа обслуживаются через отдельный защищённый путь.

### 13. Сильные стороны архитектуры
Сильные стороны текущей архитектуры:
- чёткое разделение backend, generated contract и UI;
- хорошая модульность по доменам;
- наличие offline/realtime/sync инфраструктуры;
- идемпотентность как системный паттерн;
- background job-слой;
- приватное хранение медиа;
- типобезопасный контракт между сервером и Flutter.

### 14. Практические ограничения текущей архитектуры
По коду видно и несколько естественных ограничений:
- часть документации пока отстаёт от фактической реализации;
- overview агрегирует состояние из нескольких cubit-ов и может расти в сложности по мере расширения продукта;
- offline replay описан инфраструктурно, но не обязательно одинаково глубоко интегрирован во все feature-модули;
- generated слой удобен, но требует дисциплины вокруг `serverpod generate` и миграций.

Это не критика архитектуры, а скорее реальное описание её текущей зрелости: проект уже существенно сложнее учебного CRUD-приложения, но всё ещё продолжает оформляться как полноценная платформа.

## Источники описания
- Корневой `README.md`.
- `family_helper_server/README.server.md`.
- `family_helper_flutter/README.client.md`.
- `pubspec.yaml` всех трёх пакетов.
- Серверные endpoint-ы и сервисы.
- DI, routing, offline, realtime, notification и media-модули Flutter.
- `docker-compose.yaml` и `config/generator.yaml`.

## Ограничения описания
- Описание основано на коде, README и сигнатурах API.
- Приложение и тесты не запускались во время подготовки этого документа.
- Generated-файлы Serverpod не перечислялись поштучно, а рассматривались как часть общей схемы.
