import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/app_state.dart';
import 'screens/auth_screen.dart';
import 'screens/dashboard_screen.dart';
import 'screens/board_screen.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AppState()),
      ],
      child: const RiteHandApp(),
    ),
  );
}

class RiteHandApp extends StatelessWidget {
  const RiteHandApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'RiteHand',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: const Color(0xFF1a202c),
        scaffoldBackgroundColor: const Color(0xFFf4f7f9),
        colorScheme: const ColorScheme(
          primary: Color(0xFF1a202c),
          primaryContainer: Color(0xFF111827),
          secondary: Color(0xFFf4f7f9),
          secondaryContainer: Color(0xFFf4f7f9),
          surface: Colors.white,
          background: Color(0xFFf4f7f9),
          error: Colors.red,
          onPrimary: Colors.white,
          onSecondary: Color(0xFF1a202c),
          onSurface: Color(0xFF1a202c),
          onBackground: Color(0xFF1a202c),
          onError: Colors.white,
          brightness: Brightness.light,
        ),
        fontFamily: 'Inter',
        textTheme: const TextTheme(
          displayLarge: TextStyle(fontSize: 32, fontWeight: FontWeight.w700),
          displayMedium: TextStyle(fontSize: 28, fontWeight: FontWeight.w600),
          displaySmall: TextStyle(fontSize: 24, fontWeight: FontWeight.w600),
          headlineMedium: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
          headlineSmall: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
          titleLarge: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          bodyLarge: TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
          bodyMedium: TextStyle(fontSize: 14, fontWeight: FontWeight.w400),
          bodySmall: TextStyle(fontSize: 12, fontWeight: FontWeight.w400),
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF1a202c),
          foregroundColor: Colors.white,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF1a202c),
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          focusedBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Color(0xFF1a202c)),
          ),
        ),
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const AuthScreen(),
        '/dashboard': (context) => const DashboardScreen(),
        '/board': (context) => const BoardScreen(),
      },
    );
  }
}