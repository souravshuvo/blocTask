import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;

import '../../data/models/character_model.dart';


class ApiException implements Exception {
  final String message;
  final int? statusCode;

  const ApiException(this.message, {this.statusCode});

  @override
  String toString() => message;
}

class CharacterApiService {
  final http.Client _client;

  CharacterApiService({http.Client? client}) : _client = client ?? http.Client();

  Future<Map<String, dynamic>> fetchCharacters({
    int page = 1,
    String? name,
    String? status,
    String? species,
  }) async {
    try {
      final queryParams = <String, String>{
        'page': page.toString(),
        if (name != null && name.isNotEmpty) 'name': name,
        if (status != null && status.isNotEmpty) 'status': status,
        if (species != null && species.isNotEmpty) 'species': species,
      };

      final uri = Uri.parse('https://rickandmortyapi.com/api/character')
          .replace(queryParameters: queryParams);

      final response = await _client.get(uri).timeout(
        const Duration(seconds: 15),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body) as Map<String, dynamic>;
        return data;
      } else if (response.statusCode == 404) {
        // API returns 404 when no results found
        return {'results': [], 'info': {'pages': 0, 'count': 0, 'next': null}};
      } else {
        throw ApiException(
          'Server error: ${response.statusCode}',
          statusCode: response.statusCode,
        );
      }
    } on SocketException {
      throw const ApiException('No internet connection. Showing cached data.');
    } on HttpException {
      throw const ApiException('Failed to connect to server.');
    } on FormatException {
      throw const ApiException('Invalid response format from server.');
    }
  }

  List<CharacterModel> parseCharacters(List<dynamic> results) {
    return results
        .map((json) => CharacterModel.fromJson(json as Map<String, dynamic>))
        .toList();
  }
}
