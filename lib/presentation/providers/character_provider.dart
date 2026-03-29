import 'package:flutter/foundation.dart';

import '../../core/network/api_service.dart';
import '../../data/models/character_model.dart';
import '../../data/repositories/character_repository.dart';

enum LoadState { idle, loading, loadingMore, success, error }

class CharacterProvider extends ChangeNotifier {
  final CharacterRepository _repo;

  CharacterProvider({CharacterRepository? repo})
      : _repo = repo ?? CharacterRepository();

  // ─── State ──────────────────────────────────────────────────────────────────

  LoadState _state = LoadState.idle;
  String _errorMessage = '';
  final List<CharacterModel> _characters = [];
  int _currentPage = 1;
  bool _hasMore = true;
  bool _isOffline = false;

  // Search & filter state
  String _searchQuery = '';
  String _statusFilter = '';
  String _speciesFilter = '';

  // ─── Getters ────────────────────────────────────────────────────────────────

  LoadState get state => _state;
  String get errorMessage => _errorMessage;
  List<CharacterModel> get characters => List.unmodifiable(_characters);
  bool get hasMore => _hasMore;
  bool get isOffline => _isOffline;
  String get searchQuery => _searchQuery;
  String get statusFilter => _statusFilter;
  String get speciesFilter => _speciesFilter;
  bool get isLoading => _state == LoadState.loading;
  bool get isLoadingMore => _state == LoadState.loadingMore;
  CharacterRepository get repo => _repo;

  // ─── Public Methods ──────────────────────────────────────────────────────────

  Future<void> loadInitial() async {
    _characters.clear();
    _currentPage = 1;
    _hasMore = true;
    _state = LoadState.loading;
    _errorMessage = '';
    notifyListeners();

    await _fetchPage();
  }

  Future<void> loadMore() async {
    if (!_hasMore || _state == LoadState.loadingMore || _state == LoadState.loading) {
      return;
    }
    _state = LoadState.loadingMore;
    notifyListeners();

    await _fetchPage();
  }

  Future<void> search(String query) async {
    _searchQuery = query;
    await loadInitial();
  }

  Future<void> applyFilter({String? status, String? species}) async {
    _statusFilter = status ?? _statusFilter;
    _speciesFilter = species ?? _speciesFilter;
    await loadInitial();
  }

  Future<void> clearFilters() async {
    _searchQuery = '';
    _statusFilter = '';
    _speciesFilter = '';
    await loadInitial();
  }

  void notifyCharacterUpdated() {
    // Re-apply local edits on current list
    for (int i = 0; i < _characters.length; i++) {
      final cached = _repo.getCachedCharacter(_characters[i].id);
      if (cached != null) {
        _characters[i] = cached;
      }
    }
    notifyListeners();
  }

  // ─── Private Methods ─────────────────────────────────────────────────────────

  Future<void> _fetchPage() async {
    try {
      final result = await _repo.fetchPage(
        page: _currentPage,
        name: _searchQuery.isEmpty ? null : _searchQuery,
        status: _statusFilter.isEmpty ? null : _statusFilter,
        species: _speciesFilter.isEmpty ? null : _speciesFilter,
      );

      _isOffline = false;
      final merged = _repo.mergeListWithLocalEdits(result.characters);
      _characters.addAll(merged);
      _hasMore = result.hasNext;
      _currentPage++;
      _state = LoadState.success;
    } on ApiException catch (e) {
      if (_characters.isEmpty && _searchQuery.isEmpty &&
          _statusFilter.isEmpty && _speciesFilter.isEmpty) {
        // Load from cache when offline and no filters applied
        final cached = _repo.getCachedCharacters();
        if (cached.isNotEmpty) {
          final merged = _repo.mergeListWithLocalEdits(cached);
          _characters.addAll(merged);
          _hasMore = false;
          _isOffline = true;
          _state = LoadState.success;
        } else {
          _errorMessage = e.message;
          _state = LoadState.error;
        }
      } else {
        _errorMessage = e.message;
        _state = _characters.isEmpty ? LoadState.error : LoadState.success;
      }
    } catch (e) {
      _errorMessage = 'Something went wrong. Please try again.';
      _state = _characters.isEmpty ? LoadState.error : LoadState.success;
    }

    notifyListeners();
  }
}
