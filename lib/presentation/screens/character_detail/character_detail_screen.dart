import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../data/models/character_model.dart';
import '../../../data/repositories/character_repository.dart';
import '../../providers/favorites_provider.dart';
import '../../widgets/status_badge.dart';
import 'edit_character_screen.dart';

class CharacterDetailScreen extends StatefulWidget {
  final int characterId;
  final CharacterRepository repo;

  CharacterDetailScreen({
    super.key,
    required this.characterId,
    CharacterRepository? repo,
  }) : repo = repo ?? CharacterRepository();

  @override
  State<CharacterDetailScreen> createState() => _CharacterDetailScreenState();
}

class _CharacterDetailScreenState extends State<CharacterDetailScreen> {
  CharacterRepository get _repo => widget.repo;
  CharacterModel? _character;

  @override
  void initState() {
    super.initState();
    _loadCharacter();
  }

  void _loadCharacter() {
    final character = _repo.getCachedCharacter(widget.characterId);
    if (mounted) {
      setState(() => _character = character);
    }
  }

  @override
  Widget build(BuildContext context) {
    final character = _character;

    if (character == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Character')),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    return Consumer<FavoritesProvider>(
      builder: (_, favProvider, __) {
        final isFav = favProvider.isFavorite(character.id);
        return Scaffold(
          body: CustomScrollView(
            slivers: [
              _buildSliverAppBar(character, isFav, favProvider),
              SliverToBoxAdapter(
                child: _buildBody(character),
              ),
            ],
          ),
          floatingActionButton: FloatingActionButton.extended(
            onPressed: () => _openEdit(character),
            icon: const Icon(Icons.edit_outlined),
            label: const Text('Edit'),
            backgroundColor: Theme.of(context).colorScheme.primary,
            foregroundColor: Theme.of(context).colorScheme.onPrimary,
          ),
        );
      },
    );
  }

  SliverAppBar _buildSliverAppBar(
    CharacterModel character,
    bool isFav,
    FavoritesProvider favProvider,
  ) {
    return SliverAppBar(
      expandedHeight: 300,
      pinned: true,
      stretch: true,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back_ios_new),
        onPressed: () => Navigator.pop(context),
      ),
      actions: [
        // Reset edits button (only if there are local edits)
        if (_repo.hasLocalEdit(character.id))
          IconButton(
            icon: const Icon(Icons.restore_rounded),
            tooltip: 'Reset to API data',
            onPressed: _confirmReset,
          ),
        // Favorite toggle
        IconButton(
          icon: Icon(
            isFav ? Icons.favorite : Icons.favorite_outline,
            color: isFav ? Colors.redAccent : null,
          ),
          onPressed: () => favProvider.toggleFavorite(character.id),
        ),
        const SizedBox(width: 4),
      ],
      flexibleSpace: FlexibleSpaceBar(
        background: CachedNetworkImage(
          imageUrl: character.image,
          fit: BoxFit.cover,
          placeholder: (_, __) => Container(
            color: const Color(0xFF16213E),
            child: const Center(child: CircularProgressIndicator()),
          ),
          errorWidget: (_, __, ___) => Container(
            color: const Color(0xFF16213E),
            child: const Icon(Icons.person, size: 80, color: Colors.white24),
          ),
        ),
        stretchModes: const [
          StretchMode.zoomBackground,
          StretchMode.blurBackground,
        ],
      ),
    );
  }

  Widget _buildBody(CharacterModel character) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Name + status
          Center(
            child: Column(
              children: [
                Text(
                  character.name,
                  style: const TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0.3,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                StatusBadge(status: character.status),
                if (_repo.hasLocalEdit(character.id)) ...[
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.orange.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                          color: Colors.orange.withOpacity(0.4), width: 1),
                    ),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.edit, size: 12, color: Colors.orange),
                        SizedBox(width: 4),
                        Text(
                          'Locally edited',
                          style: TextStyle(
                              color: Colors.orange, fontSize: 11),
                        ),
                      ],
                    ),
                  ),
                ],
              ],
            ),
          ),

          const SizedBox(height: 28),

          // Info rows
          _buildSection('Details', [
            _InfoRow(label: 'Species', value: character.species),
            _InfoRow(
              label: 'Type',
              value:
                  character.type.isEmpty ? 'Unknown' : character.type,
            ),
            _InfoRow(label: 'Gender', value: character.gender),
          ]),

          const SizedBox(height: 16),

          _buildSection('Origin', [
            _InfoRow(label: 'Name', value: character.origin.name),
          ]),

          const SizedBox(height: 16),

          _buildSection('Last Known Location', [
            _InfoRow(label: 'Name', value: character.location.name),
          ]),

          const SizedBox(height: 16),

          _buildSection('Episodes', [
            _InfoRow(
              label: 'Appeared in',
              value: '${character.episode.length} episode${character.episode.length == 1 ? '' : 's'}',
            ),
          ]),

          const SizedBox(height: 80), // Space for FAB
        ],
      ),
    );
  }

  Widget _buildSection(String title, List<Widget> children) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title.toUpperCase(),
          style: const TextStyle(
            color: Colors.white38,
            fontSize: 11,
            fontWeight: FontWeight.w600,
            letterSpacing: 1.2,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: const Color(0xFF16213E),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            children: children
                .expand((w) sync* {
                  yield w;
                  if (w != children.last) {
                    yield const Divider(
                        height: 1, indent: 16, endIndent: 16,
                        color: Colors.white10);
                  }
                })
                .toList(),
          ),
        ),
      ],
    );
  }

  Future<void> _openEdit(CharacterModel character) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => EditCharacterScreen(character: character, repo: _repo),
      ),
    );
    // Reload after editing
    _loadCharacter();
  }

  Future<void> _confirmReset() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: const Color(0xFF16213E),
        title: const Text('Reset to API data?'),
        content: const Text(
          'This will discard all your local edits for this character.',
          style: TextStyle(color: Colors.white70),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text(
              'Reset',
              style: TextStyle(color: Colors.redAccent),
            ),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      await _repo.resetLocalEdit(widget.characterId);
      _loadCharacter();
    }
  }
}

class _InfoRow extends StatelessWidget {
  final String label;
  final String value;

  const _InfoRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(color: Colors.white54, fontSize: 14),
          ),
          Flexible(
            child: Text(
              value,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.end,
            ),
          ),
        ],
      ),
    );
  }
}
