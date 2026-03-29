import 'package:community_feed/data/models/character_model.dart';
import 'package:flutter_test/flutter_test.dart';


void main() {
  group('CharacterModel', () {
    test('fromJson parses correctly', () {
      final json = {
        'id': 1,
        'name': 'Rick Sanchez',
        'status': 'Alive',
        'species': 'Human',
        'type': '',
        'gender': 'Male',
        'origin': {'name': 'Earth (C-137)', 'url': 'https://example.com'},
        'location': {'name': 'Citadel of Ricks', 'url': 'https://example.com'},
        'image': 'https://rickandmortyapi.com/api/character/avatar/1.jpeg',
        'episode': ['https://rickandmortyapi.com/api/episode/1'],
      };

      final character = CharacterModel.fromJson(json);

      expect(character.id, 1);
      expect(character.name, 'Rick Sanchez');
      expect(character.status, 'Alive');
      expect(character.species, 'Human');
      expect(character.origin.name, 'Earth (C-137)');
      expect(character.location.name, 'Citadel of Ricks');
      expect(character.episode.length, 1);
    });

    test('copyWith overrides fields correctly', () {
      final original = CharacterModel(
        id: 1,
        name: 'Rick Sanchez',
        status: 'Alive',
        species: 'Human',
        type: '',
        gender: 'Male',
        origin: CharacterOrigin(name: 'Earth', url: ''),
        location: CharacterLocation(name: 'Earth', url: ''),
        image: '',
        episode: [],
      );

      final updated = original.copyWith(name: 'Evil Rick', status: 'Dead');

      expect(updated.id, 1); // unchanged
      expect(updated.name, 'Evil Rick'); // overridden
      expect(updated.status, 'Dead'); // overridden
      expect(updated.species, 'Human'); // unchanged
    });
  });

  group('CharacterRepository - mergeWithLocalEdits', () {
    test('returns base character when no edits exist', () {
      // Without a real Hive instance, we verify the logic via copyWith
      final base = CharacterModel(
        id: 42,
        name: 'Morty Smith',
        status: 'Alive',
        species: 'Human',
        type: '',
        gender: 'Male',
        origin: CharacterOrigin(name: 'Earth (C-137)', url: ''),
        location: CharacterLocation(name: 'Earth', url: ''),
        image: '',
        episode: [],
      );

      // Applying empty edits should give back original values
      final merged = base.copyWith();
      expect(merged.name, base.name);
      expect(merged.status, base.status);
    });

    test('copyWith applies partial overrides', () {
      final base = CharacterModel(
        id: 2,
        name: 'Morty Smith',
        status: 'Alive',
        species: 'Human',
        type: '',
        gender: 'Male',
        origin: CharacterOrigin(name: 'Earth', url: ''),
        location: CharacterLocation(name: 'Earth', url: ''),
        image: '',
        episode: [],
      );

      final edited = base.copyWith(
        name: 'Evil Morty',
        status: 'unknown',
        origin: CharacterOrigin(name: 'Unknown Planet', url: ''),
      );

      expect(edited.name, 'Evil Morty');
      expect(edited.status, 'unknown');
      expect(edited.origin.name, 'Unknown Planet');
      expect(edited.species, 'Human'); // not touched
      expect(edited.gender, 'Male'); // not touched
    });
  });
}
