import 'package:flutter/foundation.dart';

import '../../data/models/character_model.dart';
import '../../data/repositories/character_repository.dart';

class FavoritesProvider extends ChangeNotifier {
  final CharacterRepository _repo;

  FavoritesProvider({CharacterRepository? repo})
      : _repo = repo ?? CharacterRepository();

  Set<int> _favoriteIds = {};

  Set<int> get favoriteIds => Set.unmodifiable(_favoriteIds);

  void init() {
    _favoriteIds = _repo.getAllFavoriteIds();
    notifyListeners();
  }

  bool isFavorite(int id) => _favoriteIds.contains(id);

  Future<void> toggleFavorite(int id) async {
    if (_favoriteIds.contains(id)) {
      await _repo.removeFavorite(id);
      _favoriteIds.remove(id);
    } else {
      await _repo.addFavorite(id);
      _favoriteIds.add(id);
    }
    notifyListeners();
  }

  List<CharacterModel> getFavoriteCharacters() {
    return _repo.getFavoriteCharacters();
  }
}
