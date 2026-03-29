import '../../core/network/api_service.dart';
import '../../core/storage/local_storage_service.dart';
import '../models/character_model.dart';

class CharacterRepository {
  final CharacterApiService _api;
  final LocalStorageService _storage;

  CharacterRepository({
    CharacterApiService? api,
    LocalStorageService? storage,
  })  : _api = api ?? CharacterApiService(),
        _storage = storage ?? LocalStorageService();

  /// Fetches a page of characters from the API and caches them.
  /// Throws [ApiException] if the request fails.
  Future<({List<CharacterModel> characters, int totalPages, bool hasNext})>
      fetchPage({
    int page = 1,
    String? name,
    String? status,
    String? species,
  }) async {
    final data = await _api.fetchCharacters(
      page: page,
      name: name,
      status: status,
      species: species,
    );

    final results = data['results'] as List<dynamic>? ?? [];
    final info = data['info'] as Map<String, dynamic>? ?? {};

    final characters = _api.parseCharacters(results);
    final totalPages = (info['pages'] as int?) ?? 1;
    final hasNext = info['next'] != null;

    // Cache each character fetched
    if (name == null && status == null && species == null) {
      await _storage.cacheCharacters(characters);
      await _storage.saveTotalPages(totalPages);
    }

    return (
      characters: characters,
      totalPages: totalPages,
      hasNext: hasNext,
    );
  }

  /// Returns cached characters when offline.
  List<CharacterModel> getCachedCharacters() {
    return _storage.getCachedCharacters()
      ..sort((a, b) => a.id.compareTo(b.id));
  }

  /// Applies any local edits on top of the base character data.
  CharacterModel mergeWithLocalEdits(CharacterModel base) {
    final edits = _storage.getLocalEdit(base.id);
    if (edits == null) return base;

    return base.copyWith(
      name: edits['name'] as String?,
      status: edits['status'] as String?,
      species: edits['species'] as String?,
      type: edits['type'] as String?,
      gender: edits['gender'] as String?,
      origin: edits['originName'] != null
          ? CharacterOrigin(name: edits['originName'] as String, url: base.origin.url)
          : null,
      location: edits['locationName'] != null
          ? CharacterLocation(name: edits['locationName'] as String, url: base.location.url)
          : null,
    );
  }

  /// Applies local edits to a list of characters.
  List<CharacterModel> mergeListWithLocalEdits(List<CharacterModel> characters) {
    return characters.map(mergeWithLocalEdits).toList();
  }

  Future<void> saveLocalEdit(int id, Map<String, dynamic> edits) async {
    await _storage.saveLocalEdit(id, edits);
  }

  Future<void> resetLocalEdit(int id) async {
    await _storage.deleteLocalEdit(id);
  }

  bool hasLocalEdit(int id) => _storage.hasLocalEdit(id);

  Map<String, dynamic>? getLocalEdit(int id) => _storage.getLocalEdit(id);

  // Favorites delegation
  bool isFavorite(int id) => _storage.isFavorite(id);
  Set<int> getAllFavoriteIds() => _storage.getAllFavoriteIds();
  Future<void> addFavorite(int id) => _storage.addFavorite(id);
  Future<void> removeFavorite(int id) => _storage.removeFavorite(id);

  CharacterModel? getCachedCharacter(int id) {
    final base = _storage.getCachedCharacter(id);
    if (base == null) return null;
    return mergeWithLocalEdits(base);
  }

  List<CharacterModel> getFavoriteCharacters() {
    final ids = _storage.getAllFavoriteIds();
    final all = _storage.getCachedCharacters();
    return all
        .where((c) => ids.contains(c.id))
        .map(mergeWithLocalEdits)
        .toList()
      ..sort((a, b) => a.id.compareTo(b.id));
  }
}
