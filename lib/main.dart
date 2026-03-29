import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';

import 'core/constants/hive_keys.dart';
import 'data/models/character_model.dart';
import 'data/repositories/character_repository.dart';
import 'presentation/providers/character_provider.dart';
import 'presentation/providers/favorites_provider.dart';
import 'presentation/screens/main_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Hive
  await Hive.initFlutter();

  // Register adapters
  Hive.registerAdapter(CharacterModelAdapter());
  Hive.registerAdapter(CharacterLocationAdapter());
  Hive.registerAdapter(CharacterOriginAdapter());

  // Open boxes
  await Hive.openBox<CharacterModel>(HiveKeys.charactersBox);
  await Hive.openBox<Map>(HiveKeys.localEditsBox);
  await Hive.openBox<int>(HiveKeys.favoritesBox);
  await Hive.openBox(HiveKeys.metaBox);

  runApp(const RickMortyApp());
}

class RickMortyApp extends StatelessWidget {
  const RickMortyApp({super.key});

  // Created once for the lifetime of the app
  static final _sharedRepo = CharacterRepository();

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => CharacterProvider(repo: _sharedRepo)),
        ChangeNotifierProvider(create: (_) => FavoritesProvider(repo: _sharedRepo)),
      ],
      child: MaterialApp(
        title: 'Rick & Morty',
        debugShowCheckedModeBanner: false,
        theme: _buildTheme(),
        home: const MainScreen(),
      ),
    );
  }

  ThemeData _buildTheme() {
    const primaryGreen = Color(0xFF97CE4C);
    const bgDark = Color(0xFF1A1A2E);
    const bgCard = Color(0xFF16213E);
    const bgSurface = Color(0xFF0F3460);

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: bgDark,
      primaryColor: primaryGreen,
      colorScheme: const ColorScheme.dark(
        primary: primaryGreen,
        secondary: Color(0xFF44281D),
        surface: bgCard,
        onPrimary: Color(0xFF1A1A2E),
        onSurface: Colors.white,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: bgDark,
        elevation: 0,
        centerTitle: false,
        titleTextStyle: TextStyle(
          color: primaryGreen,
          fontSize: 22,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.5,
        ),
        iconTheme: IconThemeData(color: primaryGreen),
      ),
      cardTheme: CardTheme(
        color: bgCard,
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: bgCard,
        selectedItemColor: primaryGreen,
        unselectedItemColor: Colors.white38,
        type: BottomNavigationBarType.fixed,
        elevation: 8,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: bgSurface,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: primaryGreen, width: 1.5),
        ),
        labelStyle: const TextStyle(color: Colors.white60),
        hintStyle: const TextStyle(color: Colors.white38),
      ),
      chipTheme: ChipThemeData(
        backgroundColor: bgSurface,
        selectedColor: primaryGreen,
        labelStyle: const TextStyle(color: Colors.white70, fontSize: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        side: BorderSide.none,
      ),
    );
  }
}
