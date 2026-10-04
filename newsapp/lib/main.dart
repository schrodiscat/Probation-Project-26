import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'firebase_options.dart';
import 'auth_provider.dart';
import 'news_provider.dart';
import 'splashscreen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const TheVigilApp());
}

class TheVigilApp extends StatelessWidget {
  const TheVigilApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => NewsProvider()),
      ],
      child: MaterialApp(
        title: 'The Vigil',
        debugShowCheckedModeBanner: false,
        themeMode: ThemeMode.dark,
        darkTheme: ThemeData(
          brightness: Brightness.dark,
          scaffoldBackgroundColor: const Color(0xFF121212),
          primaryColor: const Color(0xFF8A2BE2),
          colorScheme: const ColorScheme.dark(
            primary: Color(0xFF8A2BE2),
            secondary: Color(0xFF6A0DAD),
            surface: Color(0xFF1E1E1E),
          ),
        ),
        home: const SplashScreen(),
      ),
    );
  }
}