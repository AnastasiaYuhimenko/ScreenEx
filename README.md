# ScreenEx

> iOS-приложение для отслеживания криптовалютного рынка и управления собственным портфелем монет.

ScreenEx показывает топ криптовалют по капитализации, позволяет искать монеты, добавлять их в личный портфель с указанием количества, считать стоимость холдингов и наблюдать за изменением цены за 24 часа. Данные подгружаются из публичного API [CoinGecko](https://www.coingecko.com/en/api), портфель пользователя хранится локально в Core Data.

---

## Скриншоты

<!-- Замените картинки на свои, положив их, например, в папку docs/screenshots/ -->

| Top Coins | 
| :---: | :---: |
| <img width="358" height="694" alt="Снимок экрана 2026-04-27 в 12 28 39 PM" src="https://github.com/user-attachments/assets/25ef2377-cb61-4625-b958-d695e4045b2e" /> |
| <img width="356" height="693" alt="Снимок экрана 2026-04-27 в 12 29 37 PM" src="https://github.com/user-attachments/assets/bbdd657b-262e-459f-902d-7d796ede070c" /> |
| Portfolio (пустой) | Portfolio с монетами | Добавление монеты |
| :---: | :---: | :---: |
| <img width="351" height="734" alt="Снимок экрана 2026-04-27 в 12 32 04 PM" src="https://github.com/user-attachments/assets/bcbb35e0-0d85-4b44-aa9e-4172ced4ca36" /> | <img width="349" height="703" alt="Снимок экрана 2026-04-27 в 12 33 26 PM" src="https://github.com/user-attachments/assets/c377dbb4-5bb6-481e-938f-87abcba626e7" /> | <img width="361" height="714" alt="Снимок экрана 2026-04-27 в 12 33 54 PM" src="https://github.com/user-attachments/assets/20b750a6-c7b6-4de8-9178-670602f74206" /> |
| <img width="380" height="730" alt="Снимок экрана 2026-04-27 в 12 31 30 PM" src="https://github.com/user-attachments/assets/074f5f2b-7a47-4c45-a3b4-38f7e9a66f81" /> | <img width="364" height="715" alt="Снимок экрана 2026-04-27 в 12 35 18 PM" src="https://github.com/user-attachments/assets/67606ecf-c75e-43cb-aba1-cf7f2e3a97c5" />
| <img width="382" height="710" alt="Снимок экрана 2026-04-27 в 12 35 00 PM" src="https://github.com/user-attachments/assets/7e7131ec-a8ee-4dcd-a000-7e6e4666c0d9" />|

---

## Возможности

- Список топ-250 монет по рыночной капитализации (CoinGecko `coins/markets`).
- Полнотекстовый поиск по монетам через эндпоинт `search` с дообогащением рыночными данными.
- Личный портфель: добавление, удаление, отображение количества и текущей стоимости холдингов.
- Локальное персистентное хранилище портфеля на Core Data — данные сохраняются между запусками.
- Кастомный сетевой слой на `async/await` с ретраем для сетевых сбоев и `5xx`/`429`.
- Асинхронная загрузка изображений монет с плейсхолдером и состоянием ошибки.
- Pull-to-refresh, обработка отсутствия интернета (отдельный экран `NoInternerScreen`).

---

## Технологии

| Категория | Что используется |
| --- | --- |
| Язык | Swift |
| UI | SwiftUI, `glassEffect`, `NavigationStack`, `TabView`, `List` со свайпами и `onDelete` |
| Сеть | `URLSession`, кастомный `APIClient` с ретраями, абстракции `Requestable` / `Resource` / `HTTPHeaderKey` |
| Хранение | Core Data (`NSPersistentContainer`, модель `Portfolio.xcdatamodeld`, сущность `Coins`) |
| Архитектура | MVVM |
| Внешний API | [CoinGecko API v3](https://www.coingecko.com/en/api) (эндпоинты `coins/markets`, `search`) |

---

## Архитектура

Проект построен по схеме **MVVM** с тонким слоем сервисов поверх сетевого клиента:

```
SwiftUI View  ──▶  ViewModel  ──▶  Service  ──▶  APIClient  ──▶  CoinGecko
     ▲                │                                        │
     │                └─────── Core Data (Portfolio) ◀─────────┘
     └───────── @EnvironmentObject / @StateObject
```

- **APIClient** (`ScreenEx/Networking/Client/APIClient.swift`) — единая точка выполнения запросов с ретраями (`RetryConfiguration`) и подробным логированием.
- **Resource / Requestable** (`ScreenEx/Networking/`) — обобщённое описание запроса (`path`, `method`, `parameters`, `headers`, `body`, `timeoutInterval`) и способа декодирования ответа.
- **Services** (`ScreenEx/Services/`) — публикуют данные через `@Published`, инкапсулируя работу с API и Core Data.
- **ViewModels** (`ScreenEx/Root/Base/ViewModels/`) — подписываются на сервисы через Combine, прокидывают состояние во `View` и оборачивают изменения в анимации.
- **Views** (`ScreenEx/Root/Base/Views/`) — SwiftUI-экраны и переиспользуемые компоненты (`CoinCell`, `CoinImage`, `LaunchScreen`, `NoInterner`).

Все глобальные зависимости (`BaseViewModel`, `SearchViewModel`, `PortfolioModelView`, `AddCoinsToPortfolioViewModel`, `managedObjectContext`) пробрасываются из точки входа `ScreenExApp.swift` через `environmentObject` и `environment(\.managedObjectContext, …)`.

---

## Структура проекта

```
ScreenEx/
├── ScreenExApp.swift              # @main, инъекция ViewModel'ов и Core Data контекста
├── Info.plist
│
├── Constants/
│   └── AppConstants.swift         # Базовые константы: media-type, ключ CoinGecko Demo API
│
├── Models/
│   ├── ExchangeModel.swift        # DTO монеты с CodingKeys под snake_case + хелперы (rank, currentHoldingsValue)
│   ├── Coins+CoreDataClass.swift  # Core Data сущность Coins (id монеты + количество)
│   └── Coins+CoreDataProperties.swift
│
├── Networking/
│   ├── Client/APIClient.swift     # async/await + ретраи (timeout, 408/429/5xx, network errors)
│   ├── Request/Requestable.swift  # Протокол запроса + дефолтные реализации
│   ├── Request/HTTPHeaderKey.swift
│   ├── Resource/Resource.swift    # Обобщённый Resource<Response, Request>
│   └── Extensions/URLRequest+Requestable.swift
│
├── Services/
│   ├── MarketDataService.swift    # Топ-250 монет (coins/markets)
│   ├── SearchService.swift        # Поиск + дообогащение из coins/markets
│   ├── PortfolioService.swift     # Подгрузка цен по списку id портфеля, состояние loading/success/failed
│   ├── CoinService.swift          # Запрос данных по одной монете
│   ├── CoinImageDataService.swift # Асинхронная загрузка картинки монеты
│   └── PersistenceController.swift# Обёртка над NSPersistentContainer "Portfolio"
│
├── Root/Base/
│   ├── Views/
│   │   ├── MainScreen.swift           # TabView: Portfolio + Top
│   │   ├── Portfolio.swift            # Список портфеля + поиск + onDelete
│   │   ├── TopCoinsScreen.swift       # Список топ монет + поиск
│   │   ├── AddScreen.swift            # Добавление монеты в портфель с указанием количества
│   │   ├── CoinScreen.swift           # Экран отдельной монеты (заготовка под детализацию)
│   │   ├── CoinCell.swift             # Ячейка с ценой и 24h-изменением
│   │   ├── CoinImage.swift            # Обёртка над CoinImageDataService
│   │   └── NoInterner.swift           # View-extension для экрана "нет интернета"
│   └── ViewModels/
│       ├── BaseViewModel.swift              # Топ монет
│       ├── PortfolioModelView.swift         # Состояние портфеля
│       ├── AddCoinsToPortfolioViewModel.swift # CRUD по Core Data
│       ├── SearchViewModel.swift            # debounce 400ms + локальная/серверная фильтрация
│       └── CoinViewModel.swift              # Заготовка под детальный экран
│
├── Extensions/
│   ├── AppColors.swift            # Цвета из Assets (accent, background, prices up/down, …)
│   ├── Formaters.swift            # formatCurrency6(), convertNumberToString2(), convertToProcent()
│   ├── ScreenParametrs.swift      # UIScreen.currentBounds и прочие хелперы
│   ├── CoinPreviewModel.swift     # Моки для #Preview
│   ├── snakeCaseJsonDecoder.swift
│   └── JSONEncoderSnakeCase.swift
│
├── Portfolio.xcdatamodeld/        # Core Data модель (сущность Coins: name: String, count: NSDecimalNumber)
│
└── Assets.xcassets/
    ├── AppIcon.appiconset/
    └──colorsForTheme/            # AccentColor, backgroundColor, colorForPrices(Up/Down), searchGlassColor, secondColor
```


## Заметки по реализации

- **Ретраи**: `APIClient` ждёт `0.5s · 2^attempt` (cap 10s) при сетевых ошибках и retry-able status кодах (`408`, `429`, `5xx`). Ошибки декодинга и не-retryable HTTP-ответы пробрасываются сразу.
- **Поиск**: `SearchViewModel` использует `debounce(400ms)` и `removeDuplicates()` поверх `searchText`, чтобы не спамить API. Если запрос пустой — список очищается.
- **Портфель**: `PortfolioService` отменяет предыдущую in-flight задачу через `fetchTask?.cancel()`, чтобы повторные refresh'ы не дублировали монеты в списке. Уникальность id обеспечивает `uniquePreservingOrder`.
- **Core Data**: модель `Portfolio` содержит одну сущность `Coins` (`name: String` — id монеты в CoinGecko, `count: NSDecimalNumber` — количество). При добавлении проверяется существование записи (`NSPredicate(format: "name == %@", id)`).
- **Анимации**: переходы между состояниями (`isLoading`, `loadError`, обновление списка) обёрнуты в `withAnimation(.easeInOut)` / `.spring()`.

---

## планы 

- [ ] Полноценный детальный экран монеты (`CoinScreen`) со sparkline и метриками.
- [ ] Редактирование количества монеты в портфеле без удаления.
- [ ] Перенос API-ключа в `xcconfig` / Keychain.
- [ ] Юнит-тесты для сервисов и `SearchViewModel` (debounce, фильтрация).
- [ ] Локализация (сейчас интерфейс на английском).

---

## Автор

Anastasia Yukhimenko · 2026
