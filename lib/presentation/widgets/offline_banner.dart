import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/character_provider.dart';

class OfflineBanner extends StatelessWidget {
  const OfflineBanner({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<CharacterProvider>(
      builder: (_, provider, __) {
        if (!provider.isOffline) return const SizedBox.shrink();
        return Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
          color: Colors.orange.withOpacity(0.15),
          child: const Row(
            children: [
              Icon(Icons.wifi_off, size: 16, color: Colors.orange),
              SizedBox(width: 8),
              Text(
                'Offline — showing cached data',
                style: TextStyle(color: Colors.orange, fontSize: 13),
              ),
            ],
          ),
        );
      },
    );
  }
}
