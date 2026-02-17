# Arc Raiders Library - Architecture Diagrams

## 1. Clean Architecture Layers

```mermaid
graph TB
    subgraph "Presentation Layer"
        UI[UI Widgets]
        BLOC[BLoC/Cubit]
    end

    subgraph "Domain Layer"
        UC[Use Cases]
        REPO_INT[Repository Interface]
        ENT[Entities]
    end

    subgraph "Data Layer"
        REPO_IMPL[Repository Implementation]
        REMOTE[Remote Data Source]
        LOCAL[Local Data Source]
        MODEL[Models & DTOs]
    end

    subgraph "External"
        API[MetaForge API]
        ASSETS[JSON Assets]
        CACHE[SharedPreferences]
    end

    UI --> BLOC
    BLOC --> UC
    UC --> REPO_INT
    REPO_INT -.implements.- REPO_IMPL
    REPO_IMPL --> REMOTE
    REPO_IMPL --> LOCAL
    REMOTE --> API
    LOCAL --> ASSETS
    LOCAL --> CACHE
    MODEL --> ENT

    style "Presentation Layer" fill:#e1f5ff
    style "Domain Layer" fill:#fff4e1
    style "Data Layer" fill:#f0f0f0
    style "External" fill:#ffe1e1
```

## 2. Data Flow - Online Mode

```mermaid
sequenceDiagram
    participant UI
    participant BLoC
    participant UseCase
    participant Repository
    participant Remote
    participant API
    participant Local
    participant Cache

    UI->>BLoC: Load Items Event
    BLoC->>UseCase: call()
    UseCase->>Repository: getAllItems()

    Repository->>Repository: Check Network
    alt Network Available
        Repository->>Remote: getAllItems()
        Remote->>API: GET /items
        API-->>Remote: JSON Response
        Remote-->>Repository: List<ItemModel>

        Repository->>Local: cacheItems()
        Local->>Cache: Save to SharedPreferences

        Repository->>Repository: Convert to Entities
        Repository-->>UseCase: Right(List<Item>)
    else Network Unavailable
        Repository->>Local: getAllItems()
        Local->>Cache: Load from Cache
        Cache-->>Local: Cached JSON
        alt Cache Available
            Local-->>Repository: List<ItemModel>
            Repository-->>UseCase: Right(List<Item>)
        else Cache Miss
            Local->>Assets: Load from Bundle
            Assets-->>Local: Bundled JSON
            Local-->>Repository: List<ItemModel>
            Repository-->>UseCase: Right(List<Item>)
        end
    end

    UseCase-->>BLoC: Either<Failure, List<Item>>
    BLoC->>BLoC: Emit State
    BLoC-->>UI: ItemsLoaded State
    UI->>UI: Render Items
```

## 3. Offline-First Strategy Flow

```mermaid
flowchart TD
    Start([User Requests Items]) --> CheckNetwork{Network<br/>Available?}

    CheckNetwork -->|Yes| FetchRemote[Fetch from API]
    CheckNetwork -->|No| UseLocal[Use Local Data]

    FetchRemote --> RemoteSuccess{Success?}
    RemoteSuccess -->|Yes| SaveCache[Save to Cache]
    RemoteSuccess -->|No| UseLocal

    SaveCache --> ConvertEntity[Convert to Entities]

    UseLocal --> CheckCache{Cache<br/>Available?}
    CheckCache -->|Yes| LoadCache[Load from Cache]
    CheckCache -->|No| LoadAssets[Load from Assets]

    LoadCache --> ConvertEntity
    LoadAssets --> ConvertEntity

    ConvertEntity --> ApplyFilters[Apply Filters]
    ApplyFilters --> ReturnData[Return Right(Items)]

    ReturnData --> End([Display to User])

    style CheckNetwork fill:#fff4cc
    style RemoteSuccess fill:#fff4cc
    style CheckCache fill:#fff4cc
    style SaveCache fill:#ccf5cc
    style LoadCache fill:#ccf5cc
    style LoadAssets fill:#ccf5cc
    style ConvertEntity fill:#cce5ff
    style ReturnData fill:#e1ccff
```

## 4. Feature Module Structure

```mermaid
graph LR
    subgraph "Items Feature"
        direction TB
        I_PRES[Presentation]
        I_DOMAIN[Domain]
        I_DATA[Data]

        I_PRES --> I_DOMAIN
        I_DOMAIN --> I_DATA
    end

    subgraph "Quests Feature"
        direction TB
        Q_PRES[Presentation]
        Q_DOMAIN[Domain]
        Q_DATA[Data]

        Q_PRES --> Q_DOMAIN
        Q_DOMAIN --> Q_DATA
    end

    subgraph "Weapons Feature"
        direction TB
        W_PRES[Presentation]
        W_DOMAIN[Domain]
        W_DATA[Data]

        W_PRES --> W_DOMAIN
        W_DOMAIN --> W_DATA
    end

    subgraph "Core"
        NETWORK[Network]
        ERROR[Error Handling]
        DI[Dependency Injection]
    end

    I_DATA --> Core
    Q_DATA --> Core
    W_DATA --> Core

    style "Items Feature" fill:#e1f5ff
    style "Quests Feature" fill:#ffe1f5
    style "Weapons Feature" fill:#f5ffe1
    style "Core" fill:#fff4e1
```

## 5. Error Handling with fpdart

```mermaid
flowchart LR
    subgraph "Repository Layer"
        REPO[Repository Method]
    end

    subgraph "Try Remote"
        TRY_REMOTE[Fetch from API]
        SUCCESS_REMOTE{Success?}
        REMOTE_DATA[ItemModels]

        TRY_REMOTE --> SUCCESS_REMOTE
        SUCCESS_REMOTE -->|Yes| REMOTE_DATA
        SUCCESS_REMOTE -->|No| EXCEPTION_REMOTE[ServerException]
    end

    subgraph "Fallback Local"
        TRY_LOCAL[Fetch from Local]
        SUCCESS_LOCAL{Success?}
        LOCAL_DATA[ItemModels]

        TRY_LOCAL --> SUCCESS_LOCAL
        SUCCESS_LOCAL -->|Yes| LOCAL_DATA
        SUCCESS_LOCAL -->|No| EXCEPTION_LOCAL[CacheException]
    end

    subgraph "Either Result"
        RIGHT[Right&lt;List&lt;Item&gt;&gt;]
        LEFT[Left&lt;Failure&gt;]
    end

    REPO --> TRY_REMOTE
    EXCEPTION_REMOTE --> TRY_LOCAL
    REMOTE_DATA --> RIGHT
    LOCAL_DATA --> RIGHT
    EXCEPTION_LOCAL --> LEFT

    RIGHT --> USECASE[Use Case]
    LEFT --> USECASE

    style RIGHT fill:#ccf5cc
    style LEFT fill:#ffcccc
    style EXCEPTION_REMOTE fill:#ffd9cc
    style EXCEPTION_LOCAL fill:#ffd9cc
```

## 6. BLoC State Management

```mermaid
stateDiagram-v2
    [*] --> Initial

    Initial --> Loading : LoadRequested Event
    Loading --> Loaded : Success
    Loading --> Error : Failure

    Loaded --> Loading : FilterChanged Event
    Loaded --> Loading : SearchRequested Event
    Loaded --> Detail : DetailRequested Event
    Loaded --> Refreshing : RefreshRequested Event

    Refreshing --> Loaded : Refresh Complete
    Refreshing --> Error : Refresh Failed

    Error --> Loading : Retry
    Detail --> Loaded : Back

    state Loaded {
        [*] --> DisplayItems
        DisplayItems --> DisplayFiltered : Apply Filter
        DisplayFiltered --> DisplayItems : Clear Filter
    }

    note right of Loaded
        Contains:
        - List of Items
        - isOffline flag
        - Applied filters
    end note
```

## 7. Dependency Injection Flow

```mermaid
graph TD
    MAIN[main.dart] --> SETUP[setupDI]

    SETUP --> EXT[External Dependencies]
    SETUP --> CORE[Core Services]
    SETUP --> FEATURES[Feature Modules]

    EXT --> CONN[Connectivity]
    EXT --> BUNDLE[AssetBundle]
    EXT --> PREFS[SharedPreferences]

    CORE --> NETWORK[NetworkInfo]
    CORE --> API[ApiClient]
    CORE --> STORAGE[LocalStorage]

    FEATURES --> ITEMS_DS[Items DataSources]
    FEATURES --> ITEMS_REPO[Items Repository]
    FEATURES --> ITEMS_UC[Items UseCases]
    FEATURES --> ITEMS_BLOC[Items BLoC]

    ITEMS_DS --> REMOTE_DS[RemoteDataSource]
    ITEMS_DS --> LOCAL_DS[LocalDataSource]

    REMOTE_DS -.depends on.-> API
    LOCAL_DS -.depends on.-> BUNDLE
    LOCAL_DS -.depends on.-> STORAGE

    ITEMS_REPO -.depends on.-> REMOTE_DS
    ITEMS_REPO -.depends on.-> LOCAL_DS
    ITEMS_REPO -.depends on.-> NETWORK

    ITEMS_UC -.depends on.-> ITEMS_REPO
    ITEMS_BLOC -.depends on.-> ITEMS_UC

    style MAIN fill:#ffe1e1
    style EXT fill:#e1f5ff
    style CORE fill:#fff4e1
    style FEATURES fill:#f0e1ff
```

## 8. Multi-Language Support

```mermaid
flowchart LR
    subgraph "JSON Data"
        JSON[Item JSON]
        NAMES["name: {<br/>en: 'Guitar',<br/>es: 'Guitarra',<br/>fr: 'Guitare'<br/>}"]
        JSON --> NAMES
    end

    subgraph "Model Layer"
        MODEL[ItemModel]
        MAP[Map&lt;String, String&gt;]
        MODEL --> MAP
    end

    subgraph "Entity Layer"
        ENTITY[Item Entity]
        NAME_MAP[name: Map&lt;String, String&gt;]
        ENTITY --> NAME_MAP
    end

    subgraph "Presentation"
        WIDGET[Widget]
        LOCALE[Get Current Locale]
        HELPER[getLocalizedName]

        WIDGET --> LOCALE
        WIDGET --> HELPER
    end

    JSON --> MODEL
    MODEL --> ENTITY
    ENTITY --> WIDGET

    HELPER --> DISPLAY[Display Localized Text]

    style JSON fill:#e1f5ff
    style MODEL fill:#fff4e1
    style ENTITY fill:#ffe1f5
    style DISPLAY fill:#ccf5cc
```

## 9. Testing Strategy

```mermaid
graph TB
    subgraph "Testing Pyramid"
        UI_TESTS[Widget Tests<br/>E2E Tests]
        INTEGRATION[Integration Tests<br/>Feature Tests]
        UNIT[Unit Tests<br/>Mock Tests]

        UNIT --> INTEGRATION
        INTEGRATION --> UI_TESTS
    end

    subgraph "Unit Test Coverage"
        UC_TEST[UseCase Tests]
        REPO_TEST[Repository Tests]
        DS_TEST[DataSource Tests]
        BLOC_TEST[BLoC Tests]
    end

    subgraph "Integration Tests"
        API_INT[API Integration]
        CACHE_INT[Cache Integration]
        E2E[End-to-End Flow]
    end

    UNIT --> UC_TEST
    UNIT --> REPO_TEST
    UNIT --> DS_TEST
    UNIT --> BLOC_TEST

    INTEGRATION --> API_INT
    INTEGRATION --> CACHE_INT
    INTEGRATION --> E2E

    style UNIT fill:#ccf5cc
    style INTEGRATION fill:#fff4cc
    style UI_TESTS fill:#ffcccc
```

## 10. Performance Optimization Flow

```mermaid
flowchart TD
    REQUEST[User Request] --> MEMORY{In Memory<br/>Cache?}

    MEMORY -->|Yes| RETURN_MEMORY[Return Immediately]
    MEMORY -->|No| CHECK_TIME{Cache<br/>Expired?}

    CHECK_TIME -->|No| DISK[Load from Disk]
    CHECK_TIME -->|Yes| NETWORK{Network<br/>Available?}

    NETWORK -->|Yes| FETCH[Fetch from API]
    NETWORK -->|No| DISK

    FETCH --> PAGINATE{Paginated?}
    PAGINATE -->|Yes| LOAD_PAGE[Load Single Page]
    PAGINATE -->|No| LOAD_ALL[Load All]

    LOAD_PAGE --> CACHE_UPDATE[Update Cache]
    LOAD_ALL --> CACHE_UPDATE

    DISK --> FILTER[Apply Filters]
    CACHE_UPDATE --> FILTER

    FILTER --> MEMORY_STORE[Store in Memory]
    MEMORY_STORE --> RETURN[Return to User]
    RETURN_MEMORY --> RETURN

    style MEMORY fill:#ccf5cc
    style FETCH fill:#e1f5ff
    style CACHE_UPDATE fill:#fff4cc
    style RETURN fill:#e1ccff
```

## Key Benefits

### 1. Separation of Concerns
- Each layer has a single responsibility
- Easy to modify, extend, and test
- Clear boundaries between layers

### 2. Testability
- Mock dependencies at boundaries
- Test each layer independently
- High test coverage achievable

### 3. Flexibility
- Easy to swap implementations
- Add new data sources without affecting business logic
- Change UI framework without touching domain

### 4. Offline-First
- Works without internet
- Graceful degradation
- Automatic synchronization

### 5. Type Safety
- fpdart Either for error handling
- No runtime surprises
- Compile-time guarantees

### 6. Scalability
- Modular feature structure
- Easy to add new features
- Team can work in parallel

### 7. Maintainability
- SOLID principles
- Clean code practices
- Self-documenting architecture
