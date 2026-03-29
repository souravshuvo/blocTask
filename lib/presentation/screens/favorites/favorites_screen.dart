import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/character_provider.dart';
import '../../providers/favorites_provider.dart';
import '../../widgets/character_card.dart';
import '../character_detail/character_detail_screen.dart';

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Favorites'),
      ),
      body: Consumer<FavoritesProvider>(
        builder: (_, favProvider, __) {
          final favorites = favProvider.getFavoriteCharacters();

          if (favorites.isEmpty) {
            return const _EmptyFavorites();
          }

          return GridView.builder(
            padding: const EdgeInsets.all(12),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
              childAspectRatio: 0.72,
            ),
            itemCount: favorites.length,
            itemBuilder: (context, index) {
              final character = favorites[index];
              return CharacterCard(
                character: character,
                isFavorite: true,
                onTap: () async {
                  final repo = context.read<CharacterProvider>().repo;
                  await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => CharacterDetailScreen(
                        characterId: character.id,
                        repo: repo,
                      ),
                    ),
                  );
                  // Refresh after returning from detail
                  if (context.mounted) {
                    context.read<CharacterProvider>().notifyCharacterUpdated();
                  }
                },
                onFavoriteTap: () => favProvider.toggleFavorite(character.id),
              );
            },
          );
        },
      ),
    );
  }
}

class _EmptyFavorites extends StatelessWidget {
  const _EmptyFavorites();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.favorite_outline,
            size: 72,
            color: Colors.white.withOpacity(0.15),
          ),
          const SizedBox(height: 20),
          const Text(
            'No favorites yet',
            style: TextStyle(
              color: Colors.white54,
              fontSize: 18,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Tap the ♥ on any character to save them here',
            style: TextStyle(color: Colors.white38, fontSize: 13),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
