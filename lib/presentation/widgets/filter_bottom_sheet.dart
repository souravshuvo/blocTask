import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/character_provider.dart';

class FilterBottomSheet extends StatefulWidget {
  const FilterBottomSheet({super.key});

  @override
  State<FilterBottomSheet> createState() => _FilterBottomSheetState();
}

class _FilterBottomSheetState extends State<FilterBottomSheet> {
  static const _statusOptions = ['', 'Alive', 'Dead', 'unknown'];
  static const _speciesOptions = ['', 'Human', 'Alien', 'Humanoid', 'unknown', 'Animal', 'Disease', 'Robot', 'Cronenberg', 'Mythological Creature'];

  late String _selectedStatus;
  late String _selectedSpecies;

  @override
  void initState() {
    super.initState();
    final provider = context.read<CharacterProvider>();
    _selectedStatus = provider.statusFilter;
    _selectedSpecies = provider.speciesFilter;
  }

  void _apply() {
    context.read<CharacterProvider>().applyFilter(
          status: _selectedStatus,
          species: _selectedSpecies,
        );
    Navigator.pop(context);
  }

  void _clearAll() {
    setState(() {
      _selectedStatus = '';
      _selectedSpecies = '';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Color(0xFF16213E),
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 32),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Handle
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.white24,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: 20),

          // Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Filter Characters',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              TextButton(
                onPressed: _clearAll,
                child: const Text('Clear all',
                    style: TextStyle(color: Colors.white54)),
              ),
            ],
          ),
          const SizedBox(height: 20),

          // Status filter
          const Text(
            'STATUS',
            style: TextStyle(
              color: Colors.white38,
              fontSize: 11,
              letterSpacing: 1.2,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 10),
          Wrap(
            spacing: 8,
            children: _statusOptions.map((s) {
              final label = s.isEmpty ? 'Any' : s;
              final isSelected = _selectedStatus == s;
              return ChoiceChip(
                label: Text(label),
                selected: isSelected,
                onSelected: (_) => setState(() => _selectedStatus = s),
                selectedColor: Theme.of(context).colorScheme.primary,
                labelStyle: TextStyle(
                  color: isSelected
                      ? Theme.of(context).colorScheme.onPrimary
                      : Colors.white70,
                  fontWeight:
                      isSelected ? FontWeight.bold : FontWeight.normal,
                ),
              );
            }).toList(),
          ),

          const SizedBox(height: 20),

          // Species filter
          const Text(
            'SPECIES',
            style: TextStyle(
              color: Colors.white38,
              fontSize: 11,
              letterSpacing: 1.2,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 10),
          Wrap(
            spacing: 8,
            runSpacing: 4,
            children: _speciesOptions.map((s) {
              final label = s.isEmpty ? 'Any' : s;
              final isSelected = _selectedSpecies == s;
              return ChoiceChip(
                label: Text(label),
                selected: isSelected,
                onSelected: (_) => setState(() => _selectedSpecies = s),
                selectedColor: Theme.of(context).colorScheme.primary,
                labelStyle: TextStyle(
                  color: isSelected
                      ? Theme.of(context).colorScheme.onPrimary
                      : Colors.white70,
                  fontWeight:
                      isSelected ? FontWeight.bold : FontWeight.normal,
                ),
              );
            }).toList(),
          ),

          const SizedBox(height: 28),

          // Apply button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _apply,
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.primary,
                foregroundColor: Theme.of(context).colorScheme.onPrimary,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: const Text(
                'Apply Filters',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
