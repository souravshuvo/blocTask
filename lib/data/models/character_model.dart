import 'package:hive/hive.dart';

part 'character_model.g.dart';

@HiveType(typeId: 0)
class CharacterModel extends HiveObject {
  @HiveField(0)
  final int id;

  @HiveField(1)
  final String name;

  @HiveField(2)
  final String status;

  @HiveField(3)
  final String species;

  @HiveField(4)
  final String type;

  @HiveField(5)
  final String gender;

  @HiveField(6)
  final CharacterOrigin origin;

  @HiveField(7)
  final CharacterLocation location;

  @HiveField(8)
  final String image;

  @HiveField(9)
  final List<String> episode;

  CharacterModel({
    required this.id,
    required this.name,
    required this.status,
    required this.species,
    required this.type,
    required this.gender,
    required this.origin,
    required this.location,
    required this.image,
    required this.episode,
  });

  factory CharacterModel.fromJson(Map<String, dynamic> json) {
    return CharacterModel(
      id: json['id'] as int,
      name: json['name'] as String,
      status: json['status'] as String,
      species: json['species'] as String,
      type: json['type'] as String,
      gender: json['gender'] as String,
      origin: CharacterOrigin.fromJson(json['origin'] as Map<String, dynamic>),
      location: CharacterLocation.fromJson(json['location'] as Map<String, dynamic>),
      image: json['image'] as String,
      episode: List<String>.from(json['episode'] as List),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'status': status,
      'species': species,
      'type': type,
      'gender': gender,
      'origin': {'name': origin.name, 'url': origin.url},
      'location': {'name': location.name, 'url': location.url},
      'image': image,
      'episode': episode,
    };
  }

  CharacterModel copyWith({
    String? name,
    String? status,
    String? species,
    String? type,
    String? gender,
    CharacterOrigin? origin,
    CharacterLocation? location,
  }) {
    return CharacterModel(
      id: id,
      name: name ?? this.name,
      status: status ?? this.status,
      species: species ?? this.species,
      type: type ?? this.type,
      gender: gender ?? this.gender,
      origin: origin ?? this.origin,
      location: location ?? this.location,
      image: image,
      episode: episode,
    );
  }
}

@HiveType(typeId: 1)
class CharacterOrigin extends HiveObject {
  @HiveField(0)
  final String name;

  @HiveField(1)
  final String url;

  CharacterOrigin({required this.name, required this.url});

  factory CharacterOrigin.fromJson(Map<String, dynamic> json) {
    return CharacterOrigin(
      name: json['name'] as String,
      url: json['url'] as String,
    );
  }
}

@HiveType(typeId: 2)
class CharacterLocation extends HiveObject {
  @HiveField(0)
  final String name;

  @HiveField(1)
  final String url;

  CharacterLocation({required this.name, required this.url});

  factory CharacterLocation.fromJson(Map<String, dynamic> json) {
    return CharacterLocation(
      name: json['name'] as String,
      url: json['url'] as String,
    );
  }
}
