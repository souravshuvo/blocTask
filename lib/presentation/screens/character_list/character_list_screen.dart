import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/character_provider.dart';
import '../../providers/favorites_provider.dart';
import '../../widgets/character_card.dart';
import '../../widgets/filter_bottom_sheet.dart';
import '../../widgets/offline_banner.dart';
import '../character_detail/character_detail_screen.dart';

class CharacterListScreen extends StatefulWidget {
  const CharacterListScreen({super.key});

  @override
  State<CharacterListScreen> createState() => _CharacterListScreenState();
}

class _CharacterListScreenState extends State<CharacterListScreen> {
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    // Rebuild when text changes so the clear (X) button appears/disappears
    _searchController.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 300) {
      context.read<CharacterProvider>().loadMore();
    }
  }

  void _onSearchSubmitted(String query) {
    context.read<CharacterProvider>().search(query);
  }

  void _clearSearch() {
    _searchController.clear();
    context.read<CharacterProvider>().clearFilters();
  }

  void _openFilterSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => const FilterBottomSheet(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Characters'),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list),
            tooltip: 'Filter',
            onPressed: _openFilterSheet,
          ),
          const SizedBox(width: 4),
        ],
      ),
      body: Column(
        children: [
          // Search bar
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 4),
            child: TextField(
              controller: _searchController,
              onSubmitted: _onSearchSubmitted,
              textInputAction: TextInputAction.search,
              decoration: InputDecoration(
                hintText: 'Search characters...',
                prefixIcon: const Icon(Icons.search, color: Colors.white38),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.close, color: Colors.white38),
                        onPressed: _clearSearch,
                      )
                    : null,
              ),
            ),
          ),

          // Active filters chips
          Consumer<CharacterProvider>(
            builder: (_, provider, __) {
              final hasFilters = provider.statusFilter.isNotEmpty ||
                  provider.speciesFilter.isNotEmpty;
              if (!hasFilters) return const SizedBox.shrink();

              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                child: Row(
                  children: [
                    const Text(
                      'Filters: ',
                      style: TextStyle(color: Colors.white54, fontSize: 12),
                    ),
                    if (provider.statusFilter.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.only(right: 6),
                        child: Chip(
                          label: Text(provider.statusFilter),
                          deleteIcon: const Icon(Icons.close, size: 14),
                          onDeleted: () => provider.applyFilter(status: ''),
                        ),
                      ),
                    if (provider.speciesFilter.isNotEmpty)
                      Chip(
                        label: Text(provider.speciesFilter),
                        deleteIcon: const Icon(Icons.close, size: 14),
                        onDeleted: () => provider.applyFilter(species: ''),
                      ),
                  ],
                ),
              );
            },
          ),

          // Offline banner
          const OfflineBanner(),

          // Content
          Expanded(
            child: Consumer<CharacterProvider>(
              builder: (_, provider, __) {
                if (provider.isLoading) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }

                if (provider.state == LoadState.error) {
                  return _buildErrorState(provider);
                }

                if (provider.characters.isEmpty) {
                  return _buildEmptyState();
                }

                return Consumer<FavoritesProvider>(
                  builder: (_, favProvider, __) {
                    return GridView.builder(
                      controller: _scrollController,
                      padding: const EdgeInsets.all(12),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 10,
                        mainAxisSpacing: 10,
                        childAspectRatio: 0.72,
                      ),
                      itemCount: provider.characters.length +
                          (provider.isLoadingMore ? 2 : 0),
                      itemBuilder: (context, index) {
                        if (index >= provider.characters.length) {
                          return const _LoadingCard();
                        }
                        final character = provider.characters[index];
                        return CharacterCard(
                          character: character,
                          isFavorite: favProvider.isFavorite(character.id),
                          onTap: () => _openDetail(character.id),
                          onFavoriteTap: () =>
                              favProvider.toggleFavorite(character.id),
                        );
                      },
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  void _openDetail(int characterId) async {
    final repo = context.read<CharacterProvider>().repo;
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => CharacterDetailScreen(
          characterId: characterId,
          repo: repo,
        ),
      ),
    );
    // Refresh list after returning (edits may have changed)
    if (mounted) {
      context.read<CharacterProvider>().notifyCharacterUpdated();
    }
  }

  Widget _buildErrorState(CharacterProvider provider) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.wifi_off_rounded, size: 64, color: Colors.white24),
            const SizedBox(height: 16),
            Text(
              provider.errorMessage,
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.white54, fontSize: 15),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: provider.loadInitial,
              icon: const Icon(Icons.refresh),
              label: const Text('Retry'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.primary,
                foregroundColor: Theme.of(context).colorScheme.onPrimary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.search_off, size: 64, color: Colors.white24),
          SizedBox(height: 16),
          Text(
            'No characters found',
            style: TextStyle(color: Colors.white54, fontSize: 16),
          ),
          SizedBox(height: 8),
          Text(
            'Try adjusting your search or filters',
            style: TextStyle(color: Colors.white38, fontSize: 13),
          ),
        ],
      ),
    );
  }
}

class _LoadingCard extends StatelessWidget {
  const _LoadingCard();

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: Colors.white.withOpacity(0.05),
        ),
        child: const Center(
          child: CircularProgressIndicator(strokeWidth: 2),
        ),
      ),
    );
  }
}
