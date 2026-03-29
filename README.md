# Rick & Morty Character Explorer 🛸

A Flutter application that explores the [Rick and Morty API](https://rickandmortyapi.com/) with offline-first support, local editing, and favorites — built cleanly with Provider state management and Hive persistence.

---

## 📱 Screenshots

The app features a dark theme inspired by the show's aesthetic, with a grid character list, detail view, and favorites screen.

---

## 🚀 Setup Instructions

### Prerequisites
- Flutter SDK (latest stable — 3.x)
- Dart SDK (comes with Flutter)
- Android Studio / VS Code with Flutter extension
- A connected device or emulator

### Steps

```bash
# 1. Clone the repo
git clone https://github.com/souravshuvo/blocTask.git
cd blocTask

# 2. Install dependencies
flutter pub get

# 3. Run the app
flutter run
```

> **Note:** The Hive type adapters (`character_model.g.dart`) are already pre-generated in the repo. If you ever change the model, regenerate with:
> ```bash
> flutter pub run build_runner build --delete-conflicting-outputs
> ```

---

## 🧠 State Management — Provider

**Why Provider?**

Provider was chosen because it strikes the right balance for this project:

- **Simple and explicit** — no boilerplate generators, no complex DSLs. The data flow is easy to trace: `Repository → Provider → Widget`.
- **Flutter-native** — built on `InheritedWidget`, it integrates naturally with the widget tree and `BuildContext`.
- **Fits the scope** — this app has three independent concerns (character list, favorites, edit state). Provider's `MultiProvider` + `ChangeNotifier` pattern handles this cleanly without over-engineering.
- **Testable** — providers can be injected with mock repositories in tests.

The app uses three providers:
| Provider | Responsibility |
|---|---|
| `CharacterProvider` | Paginated character list, search, filters, offline fallback |
| `FavoritesProvider` | Tracking and toggling favorite character IDs |
| `EditProvider` | Per-screen edit state when editing a character |

---

## 💾 Storage Approach — Hive

**Why Hive?**

- **Fast** — Hive is a pure-Dart, key-value store that is significantly faster than SQLite for simple read/write operations.
- **No native dependencies** — unlike `sqflite`, Hive runs on all platforms without native bindings, making setup simpler.
- **Type-safe** — with generated adapters, model serialization is handled cleanly.
- **Sufficient for this data shape** — characters are stored by ID, edits are stored as maps by ID, and favorites are a simple set of IDs. There's no need for relational queries.

### Box Structure

| Box | Key | Value | Purpose |
|---|---|---|---|
| `characters_box` | `"<id>"` | `CharacterModel` | API response cache |
| `local_edits_box` | `"<id>"` | `Map<String, dynamic>` | User's local overrides |
| `favorites_box` | `"<id>"` | `int` (id) | Favorite character IDs |
| `meta_box` | `"total_pages"` | `int` | Pagination metadata |

### Data Merge Strategy

At runtime, the `CharacterRepository.mergeWithLocalEdits()` method is called whenever a character is displayed:

```
API Base Data  ──┐
                  ├─→  merge()  ──→  Display Model
Local Edits   ──┘
```

- If no local edits exist → base API data is shown as-is.
- If local edits exist → they override only the edited fields; unedited fields keep their API values.
- The API data is never mutated; edits are always stored separately.
- "Reset to API data" simply deletes the edit record from Hive.

---

## ✅ Features Implemented

- [x] Paginated character list with infinite scroll
- [x] Character grid (image, name, species, status)
- [x] Character detail view (all fields)
- [x] Add/remove favorites with persistence
- [x] Favorites screen with empty state
- [x] Local editing of all required fields
- [x] Edits persist across app restarts
- [x] Edited values shown in list AND detail view
- [x] Offline support — cached data shown when offline
- [x] Offline banner indicator
- [x] Loading states (initial + pagination skeleton)
- [x] Error state with retry button
- [x] Empty state (no results found)
- [x] Search by character name
- [x] Filter by status and species (bonus)
- [x] Reset to API data (bonus)
- [x] Status badge with color-coded dot

---

## ⚠️ Known Limitations

- **Images are not cached offline** — `CachedNetworkImage` caches images to disk, but on first load an internet connection is needed. Character data (text fields) is fully cached.
- **Search + offline** — when offline, search/filter is not available (API is needed). The app shows a message in that case.
- **No pagination resume** — when returning from offline mode, the page counter resets to 1 and re-fetches cleanly.
- **Edit provider scope** — `EditProvider` is not in the global MultiProvider; it's instantiated directly in the edit screen to keep it lightweight and scoped.

---

## 📁 Project Structure

```
lib/
├── main.dart                        # App entry, Hive init, theme
├── core/
│   ├── constants/
│   │   ├── api_constants.dart       # Base URL
│   │   └── hive_keys.dart           # Hive box/key names
│   ├── network/
│   │   └── api_service.dart         # HTTP calls, error handling
│   └── storage/
│       └── local_storage_service.dart  # Hive read/write operations
├── data/
│   ├── models/
│   │   ├── character_model.dart     # Data model + Hive annotations
│   │   └── character_model.g.dart   # Generated Hive adapters
│   └── repositories/
│       └── character_repository.dart  # Merges API + local data
└── presentation/
    ├── providers/
    │   ├── character_provider.dart  # List state, pagination, search
    │   ├── favorites_provider.dart  # Favorites state
    │   └── edit_provider.dart       # Edit state (per screen)
    ├── screens/
    │   ├── main_screen.dart         # Bottom nav host
    │   ├── character_list/
    │   │   └── character_list_screen.dart
    │   ├── character_detail/
    │   │   ├── character_detail_screen.dart
    │   │   └── edit_character_screen.dart
    │   └── favorites/
    │       └── favorites_screen.dart
    └── widgets/
        ├── character_card.dart      # Grid card
        ├── status_badge.dart        # Alive/Dead/unknown dot badge
        ├── offline_banner.dart      # Offline indicator strip
        └── filter_bottom_sheet.dart # Status/species filter sheet
```
