import 'package:hive/hive.dart';

import '../../data/models/character_model.dart';
import '../constants/hive_keys.dart';

class LocalStorageService {
  Box<CharacterModel> get _charactersBox => Hive.box<CharacterModel>(HiveKeys.charactersBox);
  Box<Map> get _editsBox => Hive.box<Map>(HiveKeys.localEditsBox);
  Box<int> get _favoritesBox => Hive.box<int>(HiveKeys.favoritesBox);
  Box get _metaBox => Hive.box(HiveKeys.metaBox);

  // ─── Characters Cache ───────────────────────────────────────────────────────

  Future<void> cacheCharacters(List<CharacterModel> characters) async {
    final Map<int, CharacterModel> map = {
      for (final c in characters) c.id: c,
    };
    await _charactersBox.putAll(map.map(
      (key, value) => MapEntry(key.toString(), value),
    ));
  }

  List<CharacterModel> getCachedCharacters() {
    return _charactersBox.values.toList();
  }

  CharacterModel? getCachedCharacter(int id) {
    return _charactersBox.get(id.toString());
  }

  // ─── Local Edits ────────────────────────────────────────────────────────────

  Future<void> saveLocalEdit(int characterId, Map<String, dynamic> edits) async {
    await _editsBox.put(characterId.toString(), edits);
  }

  Map<String, dynamic>? getLocalEdit(int characterId) {
    final raw = _editsBox.get(characterId.toString());
    if (raw == null) return null;
    return Map<String, dynamic>.from(raw);
  }

  Future<void> deleteLocalEdit(int characterId) async {
    await _editsBox.delete(characterId.toString());
  }

  bool hasLocalEdit(int characterId) {
    return _editsBox.containsKey(characterId.toString());
  }

  Map<int, Map<String, dynamic>> getAllLocalEdits() {
    final result = <int, Map<String, dynamic>>{};
    for (final key in _editsBox.keys) {
      final raw = _editsBox.get(key);
      if (raw != null) {
        result[int.parse(key.toString())] = Map<String, dynamic>.from(raw);
      }
    }
    return result;
  }

  // ─── Favorites ──────────────────────────────────────────────────────────────

  Future<void> addFavorite(int characterId) async {
    await _favoritesBox.put(characterId.toString(), characterId);
  }

  Future<void> removeFavorite(int characterId) async {
    await _favoritesBox.delete(characterId.toString());
  }

  bool isFavorite(int characterId) {
    return _favoritesBox.containsKey(characterId.toString());
  }

  Set<int> getAllFavoriteIds() {
    return _favoritesBox.values.toSet();
  }

  // ─── Pagination Meta ────────────────────────────────────────────────────────

  Future<void> saveTotalPages(int pages) async {
    await _metaBox.put(HiveKeys.totalPages, pages);
  }

  int getTotalPages() {
    return _metaBox.get(HiveKeys.totalPages, defaultValue: 1) as int;
  }
}
