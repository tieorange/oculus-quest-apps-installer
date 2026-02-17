# Technical Prompt: Build Arc Raiders Dart/Flutter Library

## Project Overview

Create a production-ready Dart/Flutter library named `arc_raiders_dart` that provides unified access to Arc Raiders game data through both **online** (arcdata.mahcks.com community API) and **offline** (static JSON bundled assets) modes. The library implements Clean Architecture, uses flutter_bloc for state management, and fpdart for functional error handling.

> **Data Attribution**: All game data originates from the community project [RaidTheory/arcraiders-data](https://github.com/RaidTheory/arcraiders-data) (MIT) and [arctracker.io](https://arctracker.io). This data is from Arc Raiders Tech Test 2 and is not officially endorsed by Embark Studios AB. Attribution is required in your README and code comments.

---

## Core Requirements

### 1. Architecture Pattern

Implement **Clean Architecture** with three distinct layers:

```
Presentation Layer → Domain Layer → Data Layer → External Sources
```

**Mandatory Principles:**
- Single Responsibility Principle (SRP)
- Open/Closed Principle (OCP)
- Liskov Substitution Principle (LSP)
- Interface Segregation Principle (ISP)
- Dependency Inversion Principle (DIP)

---

### 2. Data Sources

#### Primary Online Source: arcdata.mahcks.com (Preferred)

- **Base URL**: `https://arcdata.mahcks.com`
- **License**: MIT — no auth required, CORS open
- **Caching**: 1-hour fresh, 24-hour stale-while-revalidate
- **Note**: This is a Cloudflare Workers proxy of RaidTheory/arcraiders-data. No bot protection.

**Endpoints:**

```
# Single-file (full dataset, no pagination needed):
GET /v1/bots           → full bots array
GET /v1/maps           → full maps array
GET /v1/projects       → full projects array
GET /v1/skill-nodes    → full skill nodes array
GET /v1/trades         → full trades array

# Collection endpoints (paginated via ?full=true):
GET /v1/items                               → list of {id, url} objects (514 items)
GET /v1/items?full=true&limit=45&offset=0   → first 45 items with full JSON
GET /v1/items?full=true&limit=45&offset=45  → next 45 items
GET /v1/items/{item_id}                     → single item

GET /v1/quests                              → list of {id, url} objects (80 quests)
GET /v1/quests?full=true                    → all quests with full JSON
GET /v1/quests/{quest_id}                   → single quest

GET /v1/hideout                             → list of hideout module IDs
GET /v1/hideout?full=true                   → all 9 modules with full JSON
GET /v1/hideout/{module_id}                 → single hideout module

GET /v1/map-events                          → all map events
GET /v1/map-events?full=true                → full map events with schedule
```

**Collection list response format:**
```json
{
  "type": "items",
  "count": 514,
  "items": [
    { "id": "acoustic_guitar", "url": "/v1/items/acoustic_guitar" }
  ]
}
```

**Collection paginated full response:**
```json
{
  "type": "items",
  "total": 514,
  "count": 45,
  "offset": 0,
  "limit": 45,
  "items": [ ... ],
  "next": "/v1/items?full=true&offset=45&limit=45"
}
```

> **IMPORTANT**: The Cloudflare free tier limits subrequests to 50 per request. `?full=true` triggers one subrequest per item. Maximum safe `limit` is **45** per request. Implement offset-based pagination loop.

#### Secondary Online Source: MetaForge API (Fallback Only)

- **Base URL**: `https://metaforge.app/api/arc-raiders`
- **Warning**: Protected by Cloudflare bot detection — frequently returns 403
- **Use only as last resort fallback.** Do not treat as primary source.
- Endpoints: `GET /items`, `GET /items/:id`, `GET /quests`, `GET /traders`, `GET /game-map-data?map=<map-name>`

#### Offline Source: Static JSON Files (Bundled Assets)

Download files from [RaidTheory/arcraiders-data](https://github.com/RaidTheory/arcraiders-data) and bundle in `assets/data/`.

**Real repository structure (verified):**
```
arcraiders-data/
├── items/          ← 514 individual JSON files (one per item)
├── quests/         ← 80 individual JSON files (one per quest)
├── hideout/        ← 9 JSON files (equipment_bench, explosives_bench,
│                     med_station, refiner, scrappy, stash,
│                     utility_bench, weapon_bench, workbench)
├── map-events/
│   └── map-events.json
├── bots.json       ← 19 bot types
├── maps.json       ← 6 maps
├── trades.json     ← trader inventory
├── skillNodes.json ← skill tree nodes
└── projects.json   ← seasonal projects
```

> **NO manifest.json exists in the repo.** You must generate `assets/data/items/manifest.json` and `assets/data/quests/manifest.json` as part of your build/setup script by listing the files.

**Asset structure for the library:**
```
assets/
└── data/
    ├── items/
    │   ├── manifest.json          ← GENERATED: ["acoustic_guitar.json", ...]
    │   └── *.json                 ← 514 item files
    ├── quests/
    │   ├── manifest.json          ← GENERATED: ["a_first_foothold.json", ...]
    │   └── *.json                 ← 80 quest files
    ├── hideout/
    │   └── *.json                 ← 9 station files
    ├── map-events/
    │   └── map-events.json
    ├── bots.json
    ├── maps.json
    ├── trades.json
    ├── skillNodes.json
    └── projects.json
```

---

### 3. Real JSON Schemas (Verified from Repo)

#### Item Schema (`items/acoustic_guitar.json`)

```json
{
  "id": "acoustic_guitar",
  "name": { "en": "Acoustic Guitar", "de": "...", ... },
  "description": { "en": "A playable acoustic guitar...", ... },
  "type": "Quick Use",
  "rarity": "Legendary",
  "value": 7000,
  "weightKg": 1,
  "stackSize": 1,
  "recyclesInto": { "metal_parts": 4, "wires": 6 },
  "salvagesInto": { "wires": 3 },
  "imageFilename": "https://cdn.arctracker.io/items/acoustic_guitar.png",
  "updatedAt": "01/13/2026"
}
```

**Weapon item additional fields** (e.g., `items/aphelion.json`):
```json
{
  "isWeapon": true,
  "blueprintLocked": true,
  "effects": {
    "Ammo Type": {
      "value": "Energy Clip",
      "en": "Ammo Type", "de": "Munitionstyp", ...
    },
    "Firing Mode": { "value": "Fully-Automatic", "en": "Firing Mode", ... },
    "Durability": { "value": "100/100", "en": "Durability", ... },
    "ARC Armor Penetration": { "value": "Very Strong", ... }
  },
  "craftBench": "weapon_bench",
  "stationLevelRequired": 3,
  "recipe": {
    "complex_gun_parts": 3,
    "magnetic_accelerator": 3,
    "matriarch_reactor": 1
  }
}
```

**All possible item fields (union of all 514 items):**

| Field | Type | Notes |
|---|---|---|
| `id` | `String` | Required |
| `name` | `Map<String,String>` | 20 langs, required |
| `description` | `Map<String,String>` | 20 langs, required |
| `type` | `String` | See ItemType enum below |
| `rarity` | `String` | See ItemRarity enum |
| `value` | `int` | Sell value in coins |
| `weightKg` | `double` | Weight |
| `stackSize` | `int` | Max stack |
| `recyclesInto` | `Map<String,int>?` | Flat map: itemId→quantity |
| `salvagesInto` | `Map<String,int>?` | Flat map: itemId→quantity |
| `imageFilename` | `String?` | CDN URL |
| `updatedAt` | `String?` | Date string |
| `isWeapon` | `bool?` | True for weapons |
| `blueprintLocked` | `bool?` | Requires blueprint |
| `effects` | `Map<String,dynamic>?` | Localized weapon stats |
| `craftBench` | `String?` | Hideout station ID |
| `stationLevelRequired` | `int?` | Required station level |
| `recipe` | `Map<String,int>?` | Flat map: itemId→quantity |
| `craftQuantity` | `int?` | Output quantity when crafted |
| `damage` | `num?` | Weapon damage |
| `fireRate` | `num?` | Shots per minute |
| `range` | `num?` | Effective range |
| `stability` | `num?` | Recoil control |
| `stealth` | `num?` | Noise level |
| `agility` | `num?` | Movement modifier |
| `damageMitigation` | `num?` | Armor protection |
| `shieldCharge` | `num?` | Shield capacity |
| `durability` | `num?` | Max durability |
| `movementSpeedModifier` | `num?` | Speed modifier |
| `repairCost` | `num?` | Cost to repair |
| `repairDurability` | `num?` | Durability restored |
| `repairMaterials` | `Map<String,int>?` | Materials for repair |
| `questItem` | `bool?` | Quest-only item |
| `foundIn` | `List<String>?` | Location hints |
| `tip` | `Map<String,String>?` | Localized tip |
| `compatibleWith` | `List<String>?` | Compatible item IDs |
| `upgradeCost` | `dynamic?` | Upgrade cost data |
| `increasedFireRate` | `num?` | Fire rate modifier |
| `reducedDurabilityBurnRate` | `num?` | Durability modifier |
| `reducedReloadTime` | `num?` | Reload modifier |

**ItemType enum (complete list from real data):**
```dart
enum ItemType {
  ammunition('Ammunition'),
  assaultRifle('Assault Rifle'),
  augment('Augment'),
  backpackCharm('Backpack Charm'),
  basicMaterial('Basic Material'),
  battleRifle('Battle Rifle'),
  blueprint('Blueprint'),
  cosmetic('Cosmetic'),
  handCannon('Hand Cannon'),
  key('Key'),
  lmg('LMG'),
  misc('Misc'),
  modification('Modification'),
  nature('Nature'),
  outfit('Outfit'),
  pistol('Pistol'),
  quickUse('Quick Use'),
  recyclable('Recyclable'),
  refinedMaterial('Refined Material'),
  smg('SMG'),
  shield('Shield'),
  shotgun('Shotgun'),
  sniperRifle('Sniper Rifle'),
  special('Special'),
  topsideMaterial('Topside Material'),
  trinket('Trinket');

  final String displayName;
  const ItemType(this.displayName);

  static ItemType? fromString(String value) =>
    ItemType.values.firstWhere(
      (t) => t.displayName.toLowerCase() == value.toLowerCase(),
      orElse: () => ItemType.misc,
    );
}
```

**ItemRarity enum:**
```dart
enum ItemRarity {
  common('Common'),
  uncommon('Uncommon'),
  rare('Rare'),
  epic('Epic'),
  legendary('Legendary');

  final String displayName;
  const ItemRarity(this.displayName);

  static ItemRarity fromString(String value) =>
    ItemRarity.values.firstWhere(
      (r) => r.name.toLowerCase() == value.toLowerCase(),
      orElse: () => ItemRarity.common,
    );
}
```

**Languages (exactly 20):** `da, de, en, es, fr, he, hr, it, ja, kr, no, pl, pt, pt-BR, ru, sr, tr, uk, zh-CN, zh-TW`

---

#### Quest Schema (`quests/a_first_foothold.json`)

```json
{
  "id": "ss11",
  "name": { "en": "A First Foothold", "de": "...", ... },
  "description": { "en": "We've only just finished...", ... },
  "map": ["the_blue_gate"],
  "trader": "Shani",
  "otherRequirements": ["18x Raids"],
  "grantedItemIds": [
    { "itemId": "noisemaker", "quantity": 2 }
  ],
  "objectives": [
    { "en": "Stabilize the observation deck near the Ridgeline", "de": "...", ... },
    { "en": "Enable the comms terminal near the Olive Grove", "de": "...", ... }
  ],
  "rewardItemIds": [
    { "itemId": "shrapnel_grenade", "quantity": 3 },
    { "itemId": "snap_blast_grenade", "quantity": 3 }
  ],
  "xp": 0,
  "previousQuestIds": [],
  "nextQuestIds": ["ss11a"],
  "updatedAt": "01/13/2026"
}
```

> **Note**: Quest `id` is an internal ID (e.g., "ss11"), NOT the filename. The filename is the snake_case quest name. Objectives are multilingual objects, not plain strings. `map` is always an array (a quest can span multiple maps). Traders: `Celeste`, `Shani`, `Tian Wen`, `Apollo`, `Lance`.

---

#### Map Schema (`maps.json`)

```json
[
  {
    "id": "dam_battlegrounds",
    "name": { "en": "Dam Battlegrounds", "de": "Damm-Schlachtfelder", ... },
    "image": "https://cdn.arctracker.io/maps/dam_battlegrounds.png"
  }
]
```

**6 maps:** `dam_battlegrounds`, `the_spaceport`, `buried_city`, `the_blue_gate`, `stella_montis_upper`, `stella_montis_lower`

> **IMPORTANT**: Maps have NO coordinates or POIs in the data. Only `id`, localized `name`, and `image` URL.

---

#### Trades Schema (`trades.json`)

```json
[
  {
    "trader": "Celeste",
    "itemId": "chemicals",
    "quantity": 1,
    "cost": { "itemId": "assorted_seeds", "quantity": 1 },
    "dailyLimit": null
  }
]
```

**Traders:** `Celeste`, `Shani`, `Tian Wen`, `Apollo`, `Lance`
**`dailyLimit`:** `null` (unlimited) or integer (1–10)

---

#### Bots Schema (`bots.json`)

```json
[
  {
    "id": "arc_bastion",
    "name": "BASTION",
    "type": "Heavy Assault",
    "threat": "Critical",
    "description": "Massive, crab-like machines...",
    "weakness": "Destroy the canister on his rear...",
    "maps": ["dam_battlegrounds", "the_spaceport", ...],
    "destroyXp": 500,
    "lootXp": 250,
    "drops": ["arc_alloy", "arc_powercell", "bastion_cell"],
    "image": "https://cdn.arctracker.io/bots/arc_bastion.png"
  }
]
```

**19 bot types.** `threat` values: `Low`, `Moderate`, `High`, `Critical`, `Extreme`

---

#### Hideout Schema (`hideout/weapon_bench.json`)

```json
{
  "id": "weapon_bench",
  "name": { "en": "Gunsmith", "de": "Waffenstation", ... },
  "maxLevel": 3,
  "levels": [
    {
      "level": 1,
      "requirementItemIds": [
        { "itemId": "metal_parts", "quantity": 20 },
        { "itemId": "rubber_parts", "quantity": 30 }
      ]
    }
  ]
}
```

**9 hideout stations:** `equipment_bench`, `explosives_bench`, `med_station`, `refiner`, `scrappy`, `stash`, `utility_bench`, `weapon_bench`, `workbench`

---

#### Skill Nodes Schema (`skillNodes.json`)

```json
[
  {
    "id": "cond_1",
    "name": { "en": "Used To The Weight", ... },
    "category": "CONDITIONING",
    "isMajor": true,
    "description": { "en": "Wearing a shield doesn't slow you down as much.", ... },
    "maxPoints": 5,
    "impactedSkill": { "en": "Movement Speed", ... },
    "knownValue": [],
    "position": { "x": 25, "y": 75 },
    "prerequisiteNodeIds": [],
    "iconName": "used_to_the_weight.png"
  }
]
```

**Categories:** `CONDITIONING`, `MOBILITY`, `SURVIVAL`

---

### 4. Technology Stack

**Required Dependencies:**
```yaml
dependencies:
  flutter:
    sdk: flutter

  # State Management
  flutter_bloc: ^8.1.6
  equatable: ^2.0.5

  # Functional Programming & Error Handling
  fpdart: ^1.1.0

  # Networking
  dio: ^5.7.0
  connectivity_plus: ^6.0.3

  # Local Storage
  shared_preferences: ^2.3.2

  # JSON Serialization
  freezed_annotation: ^2.4.4
  json_annotation: ^4.9.0

  # Dependency Injection
  get_it: ^8.0.0

  # UI Utilities
  cached_network_image: ^3.4.1

  # Logging
  logger: ^2.4.0

dev_dependencies:
  flutter_test:
    sdk: flutter

  # Code Generation
  build_runner: ^2.4.13
  freezed: ^2.5.7
  json_serializable: ^6.8.0

  # Testing
  mocktail: ^1.0.4
  bloc_test: ^9.1.7
```

---

## Implementation Specifications

### Layer 1: Domain Layer (Business Logic)

#### 1.1 Entities

**`lib/features/items/domain/entities/item.dart`**
```dart
class Item extends Equatable {
  final String id;
  final Map<String, String> name;
  final Map<String, String> description;
  final ItemRarity rarity;
  final ItemType type;
  final int value;
  final double weightKg;
  final int stackSize;
  final Map<String, int>? recyclesInto;   // flat: itemId → quantity
  final Map<String, int>? salvagesInto;   // flat: itemId → quantity
  final Map<String, int>? recipe;         // flat: itemId → quantity
  final String? imageUrl;
  final String? updatedAt;
  final bool isWeapon;
  final bool blueprintLocked;
  final String? craftBench;               // hideout station ID
  final int? stationLevelRequired;
  final Map<String, dynamic>? effects;    // weapon effects (localized)

  const Item({
    required this.id,
    required this.name,
    required this.description,
    required this.rarity,
    required this.type,
    required this.value,
    required this.weightKg,
    required this.stackSize,
    this.recyclesInto,
    this.salvagesInto,
    this.recipe,
    this.imageUrl,
    this.updatedAt,
    this.isWeapon = false,
    this.blueprintLocked = false,
    this.craftBench,
    this.stationLevelRequired,
    this.effects,
  });

  String getLocalizedName(String locale) =>
    name[locale] ?? name['en'] ?? id;

  String getLocalizedDescription(String locale) =>
    description[locale] ?? description['en'] ?? '';

  @override
  List<Object?> get props => [id, rarity, type, value];
}
```

**`lib/features/quests/domain/entities/quest.dart`**
```dart
class QuestItem extends Equatable {
  final String itemId;
  final int quantity;
  // ...
}

class Quest extends Equatable {
  final String id;                              // internal ID e.g. "ss11"
  final Map<String, String> name;
  final Map<String, String> description;
  final List<String> maps;                      // map IDs (can be multiple)
  final String? trader;                         // "Celeste", "Shani", etc.
  final List<String> otherRequirements;         // e.g. ["18x Raids"]
  final List<QuestItem> grantedItemIds;         // items given to start quest
  final List<Map<String, String>> objectives;   // multilingual objective list
  final List<QuestItem> rewardItemIds;
  final int xp;
  final List<String> previousQuestIds;
  final List<String> nextQuestIds;
  final String? updatedAt;
  // ...
}
```

**`lib/features/maps/domain/entities/game_map.dart`**
```dart
class GameMap extends Equatable {
  final String id;
  final Map<String, String> name;
  final String imageUrl;   // CDN URL

  // NO coordinates or POIs — the data doesn't have them
  // ...
}
```

**`lib/features/bots/domain/entities/bot.dart`**
```dart
enum BotThreat { low, moderate, high, critical, extreme }

class Bot extends Equatable {
  final String id;
  final String name;           // flat string (not localized)
  final String type;           // e.g. "Heavy Assault"
  final BotThreat threat;
  final String description;
  final String weakness;
  final List<String> maps;     // map IDs
  final int destroyXp;
  final int lootXp;
  final List<String> drops;    // item IDs
  final String imageUrl;
  // ...
}
```

**`lib/features/hideout/domain/entities/hideout_station.dart`**
```dart
class HideoutRequirement {
  final String itemId;
  final int quantity;
}

class HideoutLevel {
  final int level;
  final List<HideoutRequirement> requirementItemIds;
}

class HideoutStation extends Equatable {
  final String id;
  final Map<String, String> name;
  final int maxLevel;
  final List<HideoutLevel> levels;
  // ...
}
```

**`lib/features/traders/domain/entities/trade.dart`**
```dart
class Trade extends Equatable {
  final String trader;         // "Celeste", "Shani", "Tian Wen", "Apollo", "Lance"
  final String itemId;
  final int quantity;
  final String costItemId;
  final int costQuantity;
  final int? dailyLimit;       // null = unlimited
  // ...
}
```

**`lib/features/skills/domain/entities/skill_node.dart`**
```dart
enum SkillCategory { conditioning, mobility, survival }

class SkillNode extends Equatable {
  final String id;
  final Map<String, String> name;
  final SkillCategory category;
  final bool isMajor;
  final Map<String, String> description;
  final int maxPoints;
  final Map<String, String> impactedSkill;
  final List<dynamic> knownValue;
  final Map<String, int> position;       // {x, y}
  final List<String> prerequisiteNodeIds;
  final String iconName;
  // ...
}
```

#### 1.2 Repository Interfaces

```dart
// lib/features/items/domain/repositories/items_repository.dart
abstract class ItemsRepository {
  Future<Either<Failure, List<Item>>> getAllItems({
    ItemRarity? rarity,
    ItemType? type,
    String? search,
  });
  Future<Either<Failure, Item>> getItemById(String id);
  Future<Either<Failure, List<Item>>> searchItems(String query);
  Future<Either<Failure, Unit>> refreshCache();
  Future<bool> isCached();
}

// lib/features/quests/domain/repositories/quests_repository.dart
abstract class QuestsRepository {
  Future<Either<Failure, List<Quest>>> getAllQuests();
  Future<Either<Failure, Quest>> getQuestById(String id);
  Future<Either<Failure, List<Quest>>> getQuestsByTrader(String trader);
  Future<Either<Failure, List<Quest>>> getQuestsByMap(String mapId);
}

// lib/features/bots/domain/repositories/bots_repository.dart
abstract class BotsRepository {
  Future<Either<Failure, List<Bot>>> getAllBots();
  Future<Either<Failure, List<Bot>>> getBotsByMap(String mapId);
  Future<Either<Failure, Bot>> getBotById(String id);
}

// lib/features/hideout/domain/repositories/hideout_repository.dart
abstract class HideoutRepository {
  Future<Either<Failure, List<HideoutStation>>> getAllStations();
  Future<Either<Failure, HideoutStation>> getStationById(String id);
}

// lib/features/traders/domain/repositories/trades_repository.dart
abstract class TradesRepository {
  Future<Either<Failure, List<Trade>>> getAllTrades();
  Future<Either<Failure, List<Trade>>> getTradesByTrader(String trader);
}
```

#### 1.3 Use Cases

```dart
// Required use cases per feature:

// Items:
class GetAllItems       // with optional rarity/type/search filters
class GetItemById
class SearchItems
class GetCraftableItems // items with recipe field
class RefreshItemsCache

// Quests:
class GetAllQuests
class GetQuestById
class GetQuestsByTrader
class GetQuestsByMap

// Bots:
class GetAllBots
class GetBotsByMap
class GetBotById

// Hideout:
class GetAllHideoutStations
class GetHideoutStationById

// Trades:
class GetAllTrades
class GetTradesByTrader

// Maps:
class GetAllMaps

// Skills:
class GetAllSkillNodes
class GetSkillNodesByCategory

// Projects:
class GetAllProjects
```

---

### Layer 2: Data Layer

#### 2.1 Models with JSON Serialization

**`lib/features/items/data/models/item_model.dart`**
```dart
@freezed
class ItemModel with _$ItemModel {
  const factory ItemModel({
    required String id,
    required Map<String, String> name,
    required Map<String, String> description,
    required String rarity,
    required String type,
    required int value,
    required double weightKg,
    required int stackSize,
    Map<String, int>? recyclesInto,
    Map<String, int>? salvagesInto,
    Map<String, int>? recipe,
    String? imageFilename,
    String? updatedAt,
    @Default(false) bool isWeapon,
    @Default(false) bool blueprintLocked,
    Map<String, dynamic>? effects,
    String? craftBench,
    int? stationLevelRequired,
    int? craftQuantity,
    bool? questItem,
  }) = _ItemModel;

  factory ItemModel.fromJson(Map<String, dynamic> json) =>
      _$ItemModelFromJson(json);
}
```

**`lib/features/quests/data/models/quest_model.dart`**
```dart
@freezed
class QuestItemModel with _$QuestItemModel {
  const factory QuestItemModel({
    required String itemId,
    required int quantity,
  }) = _QuestItemModel;

  factory QuestItemModel.fromJson(Map<String, dynamic> json) =>
      _$QuestItemModelFromJson(json);
}

@freezed
class QuestModel with _$QuestModel {
  const factory QuestModel({
    required String id,
    required Map<String, String> name,
    required Map<String, String> description,
    @Default([]) List<String> map,
    String? trader,
    @Default([]) List<String> otherRequirements,
    @Default([]) List<QuestItemModel> grantedItemIds,
    @Default([]) List<Map<String, String>> objectives,  // multilingual objects
    @Default([]) List<QuestItemModel> rewardItemIds,
    @Default(0) int xp,
    @Default([]) List<String> previousQuestIds,
    @Default([]) List<String> nextQuestIds,
    String? updatedAt,
  }) = _QuestModel;

  factory QuestModel.fromJson(Map<String, dynamic> json) =>
      _$QuestModelFromJson(json);
}
```

#### 2.2 Remote Data Source

**Strategy:** Try arcdata.mahcks.com first. If it fails (network error, 5xx), fall back to MetaForge API. If both fail, use local assets.

```dart
class ItemsRemoteDataSourceImpl implements ItemsRemoteDataSource {
  final ApiClient _primaryClient;   // arcdata.mahcks.com
  final ApiClient _fallbackClient;  // metaforge.app

  // Fetching all 514 items requires pagination:
  // GET /v1/items?full=true&limit=45&offset=0
  // GET /v1/items?full=true&limit=45&offset=45
  // ... until all items fetched
  @override
  Future<List<ItemModel>> getAllItems({
    ItemRarity? rarity,
    ItemType? type,
    String? search,
  }) async {
    final allItems = <ItemModel>[];
    int offset = 0;
    const limit = 45; // max safe limit for Cloudflare free tier

    while (true) {
      final response = await _primaryClient.get(
        '/v1/items',
        queryParameters: {'full': 'true', 'limit': limit, 'offset': offset},
      );

      final data = response.data;
      final items = (data['items'] as List)
          .map((j) => ItemModel.fromJson(j))
          .toList();
      allItems.addAll(items);

      // Check if more pages exist
      final total = data['total'] as int;
      offset += items.length;
      if (offset >= total) break;
    }

    return _applyFilters(allItems, rarity: rarity, type: type, search: search);
  }
}
```

#### 2.3 Local Data Source

```dart
class ItemsLocalDataSourceImpl implements ItemsLocalDataSource {
  static const String itemsAssetPath =
      'packages/arc_raiders_dart/assets/data/items/';
  static const String manifestPath = '${itemsAssetPath}manifest.json';

  // Load manifest.json (list of filenames), then load each JSON file
  // manifest.json is GENERATED during setup, not part of the source repo
  Future<List<ItemModel>> _loadFromAssets() async {
    final manifestJson = await rootBundle.loadString(manifestPath);
    final manifest = jsonDecode(manifestJson) as List<dynamic>;

    final items = <ItemModel>[];
    for (final filename in manifest.cast<String>()) {
      try {
        final json = await rootBundle.loadString('$itemsAssetPath$filename');
        items.add(ItemModel.fromJson(jsonDecode(json)));
      } catch (_) {
        // Skip malformed files gracefully
        continue;
      }
    }
    return items;
  }
}
```

**Manifest generation script** (run during setup/CI):
```bash
#!/bin/bash
# scripts/generate_manifests.sh
ls assets/data/items/*.json | xargs -I{} basename {} | \
  python3 -c "import sys,json; print(json.dumps([l.strip() for l in sys.stdin]))" \
  > assets/data/items/manifest.json

ls assets/data/quests/*.json | xargs -I{} basename {} | \
  python3 -c "import sys,json; print(json.dumps([l.strip() for l in sys.stdin]))" \
  > assets/data/quests/manifest.json
```

#### 2.4 Repository Implementation (Offline-First)

```
Strategy:
1. Check connectivity
2. Online: Try arcdata.mahcks.com → on success, cache → return
           On failure: try MetaForge API
           Both failed: use local cache/assets
3. Offline: Local cache → bundled assets
```

```dart
class ItemsRepositoryImpl implements ItemsRepository {
  final ItemsRemoteDataSource remoteDataSource;   // arcdata.mahcks.com + metaforge fallback
  final ItemsLocalDataSource localDataSource;
  final NetworkInfo networkInfo;

  @override
  Future<Either<Failure, List<Item>>> getAllItems({
    ItemRarity? rarity,
    ItemType? type,
    String? search,
  }) async {
    if (await networkInfo.isConnected) {
      try {
        final models = await remoteDataSource.getAllItems(
          rarity: rarity, type: type, search: search,
        );
        await localDataSource.cacheItems(models);
        return right(models.map((m) => m.toEntity()).toList());
      } on ServerException catch (e) {
        return _getFromLocal(rarity: rarity, type: type, search: search);
      }
    } else {
      return _getFromLocal(rarity: rarity, type: type, search: search);
    }
  }
}
```

---

### Layer 3: Presentation Layer

#### 3.1 BLoC Implementation

**Events:**
```dart
@freezed
class ItemsEvent with _$ItemsEvent {
  const factory ItemsEvent.loadRequested({
    ItemRarity? rarity,
    ItemType? type,
  }) = ItemsLoadRequested;

  const factory ItemsEvent.filterChanged({
    ItemRarity? rarity,
    ItemType? type,
  }) = ItemsFilterChanged;

  const factory ItemsEvent.searchRequested(String query) = ItemsSearchRequested;
  const factory ItemsEvent.detailRequested(String itemId) = ItemDetailRequested;
  const factory ItemsEvent.cacheRefreshRequested() = ItemsCacheRefreshRequested;
}
```

**States:**
```dart
@freezed
class ItemsState with _$ItemsState {
  const factory ItemsState.initial() = ItemsInitial;
  const factory ItemsState.loading() = ItemsLoading;
  const factory ItemsState.loaded({
    required List<Item> items,
    @Default(false) bool isOffline,
  }) = ItemsLoaded;
  const factory ItemsState.detail(Item item) = ItemsDetail;
  const factory ItemsState.error(String message) = ItemsError;
  const factory ItemsState.refreshing() = ItemsRefreshing;
}
```

---

### Core Components

#### 4.1 Error Handling

```dart
// lib/core/error/failures.dart
abstract class Failure extends Equatable {
  final String message;
  const Failure({required this.message});
  @override List<Object?> get props => [message];
}

class ServerFailure extends Failure {
  final int? statusCode;
  const ServerFailure({required super.message, this.statusCode});
  @override List<Object?> get props => [message, statusCode];
}

class CacheFailure extends Failure {
  const CacheFailure({required super.message});
}

class NetworkFailure extends Failure {
  const NetworkFailure({required super.message});
}

class CloudflareBlockedFailure extends Failure {
  const CloudflareBlockedFailure()
    : super(message: 'Request blocked by Cloudflare. Falling back to offline data.');
}
```

```dart
// lib/core/error/exceptions.dart
class ServerException implements Exception {
  final String message;
  final int? statusCode;
  ServerException({required this.message, this.statusCode});
}

class CacheException implements Exception {
  final String message;
  CacheException({required this.message});
}

class CloudflareException implements Exception {
  CloudflareException();
}
```

#### 4.2 Network Info

```dart
abstract class NetworkInfo {
  Future<bool> get isConnected;
  Stream<bool> get onConnectivityChanged;
}

class NetworkInfoImpl implements NetworkInfo {
  final Connectivity connectivity;

  @override
  Future<bool> get isConnected async {
    final result = await connectivity.checkConnectivity();
    return result.any((r) => r != ConnectivityResult.none);
  }

  @override
  Stream<bool> get onConnectivityChanged =>
    connectivity.onConnectivityChanged.map(
      (results) => results.any((r) => r != ConnectivityResult.none),
    );
}
```

#### 4.3 API Client (Dual-Source)

```dart
class ArcDataApiClient {
  final Dio _dio;
  static const String baseUrl = 'https://arcdata.mahcks.com';

  ArcDataApiClient() : _dio = Dio(BaseOptions(
    baseUrl: baseUrl,
    connectTimeout: const Duration(seconds: 15),
    receiveTimeout: const Duration(seconds: 30),
    headers: {'Accept': 'application/json'},
  )) {
    _dio.interceptors.add(InterceptorsWrapper(
      onError: (error, handler) {
        if (error.response?.statusCode == 403) {
          // Cloudflare block — propagate as CloudflareException
          handler.reject(DioException(
            requestOptions: error.requestOptions,
            error: CloudflareException(),
          ));
        } else {
          handler.next(error);
        }
      },
    ));

    if (kDebugMode) {
      _dio.interceptors.add(LogInterceptor(
        requestBody: false,
        responseBody: false, // avoid logging 514 items
      ));
    }
  }

  Future<Response> get(String path, {Map<String, dynamic>? queryParameters}) =>
    _dio.get(path, queryParameters: queryParameters);
}
```

#### 4.4 Dependency Injection

```dart
final getIt = GetIt.instance;

Future<void> setupDependencyInjection() async {
  // External
  getIt.registerLazySingleton(() => Connectivity());

  // Core
  getIt.registerLazySingleton<NetworkInfo>(
    () => NetworkInfoImpl(getIt()),
  );
  getIt.registerLazySingleton(() => ArcDataApiClient());

  final prefs = await SharedPreferences.getInstance();
  getIt.registerLazySingleton<LocalStorage>(
    () => LocalStorageImpl(prefs),
  );

  // Features
  await _setupItemsFeature();
  await _setupQuestsFeature();
  await _setupBotsFeature();
  await _setupHideoutFeature();
  await _setupTradesFeature();
  await _setupMapsFeature();
  await _setupSkillsFeature();
}
```

---

## File Structure

```
arc_raiders_dart/
├── lib/
│   ├── core/
│   │   ├── error/
│   │   │   ├── failures.dart
│   │   │   └── exceptions.dart
│   │   ├── network/
│   │   │   ├── network_info.dart
│   │   │   └── api_client.dart        # arcdata.mahcks.com client
│   │   ├── storage/
│   │   │   └── local_storage.dart
│   │   └── di/
│   │       └── injection.dart
│   │
│   ├── features/
│   │   ├── items/                     # 514 items, full field set
│   │   ├── quests/                    # 80 quests with chain support
│   │   ├── bots/                      # 19 enemy types
│   │   ├── hideout/                   # 9 craft stations
│   │   ├── traders/                   # trades by Celeste/Shani/etc.
│   │   ├── maps/                      # 6 maps (id + name + image only)
│   │   ├── skills/                    # skill tree nodes
│   │   └── projects/                  # seasonal projects
│   │
│   └── arc_raiders.dart
│
├── assets/
│   └── data/
│       ├── items/
│       │   ├── manifest.json          ← GENERATED (not in source repo)
│       │   └── *.json                 ← 514 downloaded item files
│       ├── quests/
│       │   ├── manifest.json          ← GENERATED
│       │   └── *.json                 ← 80 downloaded quest files
│       ├── hideout/
│       │   └── *.json                 ← 9 station files
│       ├── map-events/
│       │   └── map-events.json
│       ├── bots.json
│       ├── maps.json
│       ├── trades.json
│       ├── skillNodes.json
│       └── projects.json
│
├── scripts/
│   ├── download_assets.sh             ← downloads JSON from arcraiders-data
│   └── generate_manifests.sh         ← generates manifest.json files
│
├── test/
├── example/
├── pubspec.yaml
└── README.md
```

---

## Testing Requirements

### Unit Tests (target: 70%+ coverage)

Test all layers independently:

```dart
// test/features/items/domain/usecases/get_all_items_test.dart
void main() {
  late GetAllItems useCase;
  late MockItemsRepository mockRepository;

  setUp(() {
    mockRepository = MockItemsRepository();
    useCase = GetAllItems(mockRepository);
  });

  group('GetAllItems', () {
    test('returns items list on success', () async {
      final tItems = [
        Item(
          id: 'acoustic_guitar',
          name: {'en': 'Acoustic Guitar'},
          description: {'en': 'A playable guitar'},
          rarity: ItemRarity.legendary,
          type: ItemType.quickUse,
          value: 7000,
          weightKg: 1.0,
          stackSize: 1,
        ),
      ];
      when(() => mockRepository.getAllItems())
          .thenAnswer((_) async => right(tItems));

      final result = await useCase();

      expect(result, right(tItems));
      verify(() => mockRepository.getAllItems()).called(1);
    });

    test('returns CacheFailure when offline and no cache', () async {
      when(() => mockRepository.getAllItems())
          .thenAnswer((_) async => left(const CacheFailure(message: 'No cache')));

      final result = await useCase();

      expect(result.isLeft(), true);
    });
  });
}
```

**Required test coverage:**
- All use cases (100%)
- All repository methods (100%)
- All data sources (100%)
- All BLoC events/states (100%)
- JSON serialization for all models
- Offline fallback logic
- Cloudflare 403 handling

### Integration Tests

```dart
testWidgets('shows items from local assets when offline', (tester) async {
  final mockNetworkInfo = MockNetworkInfo();
  when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => false);

  await tester.pumpWidget(const MyApp());
  await tester.pumpAndSettle();

  expect(find.byType(ListTile), findsWidgets);
});
```

---

## Performance Requirements

- **Pagination**: Fetch items in batches of 45 (arcdata.mahcks.com limit)
- **Infinite scroll**: Load-on-demand for item lists
- **Search debounce**: 500ms
- **Image caching**: `cached_network_image`, 7-day TTL, CDN: `cdn.arctracker.io`
- **Local load**: Items manifest → parallel load with error skip
- **Cache TTL**: 24 hours for local cache
- **Background sync**: Every 6 hours when app is active

---

## Acceptance Criteria

### Functional
- Fetch all 514 items from arcdata.mahcks.com with offset pagination
- Load items from 514 bundled JSON files offline
- Automatic fallback: arcdata.mahcks.com → MetaForge → local assets
- Filter items by rarity (5 levels) and type (26 types)
- Search items across 20 languages by name/description
- Load all 80 quests with chain navigation (previousQuestIds/nextQuestIds)
- Load all 6 maps (id + name + image only — no coordinates)
- Load all trades grouped by trader (Celeste, Shani, Tian Wen, Apollo, Lance)
- Load all 19 bots with threat levels and map assignments
- Load all 9 hideout stations with upgrade requirements
- Load skill tree nodes by category (CONDITIONING/MOBILITY/SURVIVAL)
- Handle Cloudflare 403 from MetaForge gracefully with fallback

### Non-Functional
- Clean Architecture implementation
- SOLID principles
- Type-safe error handling with fpdart Either
- Reactive state management with flutter_bloc
- 70%+ unit test coverage
- Generated code via freezed/json_serializable

---

## Important Notes

1. **No manifest.json in source repo** — Generate it as a build step. Download all JSONs from `RaidTheory/arcraiders-data`, then run `generate_manifests.sh`.

2. **MetaForge API is unreliable** — Has Cloudflare bot protection. Use `arcdata.mahcks.com` as primary. Handle 403 with `CloudflareBlockedFailure`.

3. **Quest IDs are internal** — The quest `id` field (e.g., "ss11") differs from the filename. Use the internal `id` for quest chains.

4. **Quests objectives are multilingual objects** — Each objective is a `Map<String, String>` with locale keys, not a plain string.

5. **recyclesInto/salvagesInto/recipe are flat maps** — Format: `{"item_id": quantity}` (not `[{itemId, quantity}]`). But `grantedItemIds`, `rewardItemIds`, and hideout `requirementItemIds` ARE `[{itemId, quantity}]` objects.

6. **Maps have no POIs** — Do not model coordinates. Only `id`, `name` (20 langs), and `image` URL.

7. **Item types are specific** — 26 types including weapon types (Assault Rifle, Battle Rifle, etc.). Use the full `ItemType` enum.

8. **Language support: exactly 20** — da, de, en, es, fr, he, hr, it, ja, kr, no, pl, pt, pt-BR, ru, sr, tr, uk, zh-CN, zh-TW

9. **Attribution required** — Link to `github.com/RaidTheory/arcraiders-data` and `arctracker.io` in README and code comments. Data is community-maintained from Tech Test 2, not official.

10. **arcdata.mahcks.com limit** — Maximum 45 items per `?full=true` request due to Cloudflare Workers free tier subrequest limit.

---

## Setup Script

```bash
#!/bin/bash
# scripts/download_assets.sh
# Run once to download all game data

BASE="https://raw.githubusercontent.com/RaidTheory/arcraiders-data/main"
DEST="assets/data"

mkdir -p "$DEST/items" "$DEST/quests" "$DEST/hideout" "$DEST/map-events"

# Download single files
for f in bots.json maps.json trades.json skillNodes.json projects.json; do
  curl -s "$BASE/$f" -o "$DEST/$f"
done

# Download map-events
curl -s "$BASE/map-events/map-events.json" -o "$DEST/map-events/map-events.json"

# Download all items (514 files)
ITEM_LIST=$(curl -s "https://arcdata.mahcks.com/v1/items" | python3 -c \
  "import sys,json; [print(x['id']) for x in json.load(sys.stdin)['items']]")

for id in $ITEM_LIST; do
  curl -s "$BASE/items/$id.json" -o "$DEST/items/$id.json"
done

# Download all quests (80 files)
QUEST_LIST=$(curl -s "https://arcdata.mahcks.com/v1/quests" | python3 -c \
  "import sys,json; [print(x['id']) for x in json.load(sys.stdin)['items']]")

for id in $QUEST_LIST; do
  curl -s "$BASE/quests/$id.json" -o "$DEST/quests/$id.json"
done

# Download hideout stations
for station in equipment_bench explosives_bench med_station refiner scrappy stash utility_bench weapon_bench workbench; do
  curl -s "$BASE/hideout/$station.json" -o "$DEST/hideout/$station.json"
done

# Generate manifests
ls "$DEST/items/"*.json | xargs -I{} basename {} | \
  python3 -c "import sys,json; print(json.dumps([l.strip() for l in sys.stdin]))" \
  > "$DEST/items/manifest.json"

ls "$DEST/quests/"*.json | xargs -I{} basename {} | \
  python3 -c "import sys,json; print(json.dumps([l.strip() for l in sys.stdin]))" \
  > "$DEST/quests/manifest.json"

echo "Done. $(ls $DEST/items/*.json | wc -l) items, $(ls $DEST/quests/*.json | wc -l) quests downloaded."
```

---

## References

- **Primary data source**: https://github.com/RaidTheory/arcraiders-data (MIT)
- **Community API**: https://arcdata.mahcks.com — source: https://github.com/Mahcks/arcraiders-data-api (MIT)
- **TypeScript SDK** (reference only): https://github.com/justinjd00/arc-raiders-wrapper (MIT)
- **Image CDN**: https://cdn.arctracker.io
- **Clean Architecture**: https://blog.cleancoder.com/uncle-bob/2012/08/13/the-clean-architecture.html
- **flutter_bloc**: https://bloclibrary.dev/
- **fpdart**: https://pub.dev/packages/fpdart
- **freezed**: https://pub.dev/packages/freezed
- **get_it**: https://pub.dev/packages/get_it
- **Arc Raiders official**: https://arcraiders.com/
- **Community Discord**: https://discord.gg/pAtQ4Aw8em

---

## Expected Deliverables

1. Complete Dart package with all 8 features (items, quests, bots, hideout, traders, maps, skills, projects)
2. Unit tests (70%+ coverage)
3. Integration tests (offline/online scenarios)
4. Example Flutter app demonstrating all features
5. README with attribution, setup instructions, usage examples
6. API documentation (dartdoc)
7. `pubspec.yaml` ready for pub.dev
8. `scripts/download_assets.sh` and `scripts/generate_manifests.sh`

## Success Metrics

- **Code Quality**: Passes `flutter analyze` with zero warnings
- **Test Coverage**: >70% overall
- **Performance**: Initial load from local assets < 2s for 514 items
- **Offline Support**: 100% functional without internet
- **API Success Rate**: >95% for arcdata.mahcks.com requests
- **Cloudflare Resilience**: Falls back to offline gracefully on 403
