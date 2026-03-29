import 'package:flutter/foundation.dart';

import '../../data/models/character_model.dart';
import '../../data/repositories/character_repository.dart';

class EditProvider extends ChangeNotifier {
  final CharacterRepository _repo;
  final int characterId;

  EditProvider({required this.characterId, CharacterRepository? repo})
      : _repo = repo ?? CharacterRepository();

  bool get hasLocalEdit => _repo.hasLocalEdit(characterId);

  Map<String, dynamic>? get currentEdits => _repo.getLocalEdit(characterId);

  Future<CharacterModel> saveEdits(CharacterModel base, Map<String, dynamic> edits) async {
    await _repo.saveLocalEdit(characterId, edits);
    notifyListeners();
    return _repo.mergeWithLocalEdits(base);
  }

  Future<void> resetEdits() async {
    await _repo.resetLocalEdit(characterId);
    notifyListeners();
  }

  CharacterModel getMerged(CharacterModel base) {
    return _repo.mergeWithLocalEdits(base);
  }
}
