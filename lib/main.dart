import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'data/app_data.dart';
import 'screens/splash_screen.dart';
import 'theme/app_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await AppData.load();
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    statusBarIconBrightness: Brightness.dark,
  ));
  runApp(const EPayApp());
}

class EPayApp extends StatelessWidget {
  const EPayApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ePay',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.theme,
      home: const SplashScreen(),
    );
  }
}
