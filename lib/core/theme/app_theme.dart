// lib/core/theme/app_theme.dart
import 'package:flutter/material.dart';

class AppTheme {
  // ✅ CORES PRINCIPAIS - DOURADO E PRETO
  static const Color seed = Color(0xFFFBAF2A);
  static const Color accentPrimary = Color(0xFFFBAF2A);
  static const Color accentSecondary = Color(0xFFFF8C42);

  // ✅ CORES DARK - PRETO COM GRADIENTES SUAVES
  static const Color backgroundPrimary = Color(0xFF0A0A0A);
  static const Color backgroundSecondary = Color(0xFF1A1A1A);
  static const Color backgroundTertiary = Color(0xFF2A2A2A);
  static const Color surfaceDark = Color(0xFF151515);
  static const Color divider = Color(0xFF2A2A2A);

  // ✅ CORES DE TEXTO - GETTERS CORRIGIDOS
  static Color get textPrimary => Colors.white;
  static Color get textSecondary => Colors.white.withValues(alpha: 0.7);
  static Color get textTertiary => Colors.white.withValues(alpha: 0.6);

  // ✅ DARK COLOR SCHEME - SEM DEPRECATED PROPERTIES
  static final ColorScheme darkScheme = ColorScheme.fromSeed(
    seedColor: seed,
    brightness: Brightness.dark,
  ).copyWith(
    surface: backgroundPrimary,
    surfaceContainerHighest: backgroundSecondary,
    onSurface: Colors.white,
    primary: accentPrimary,
    onPrimary: Colors.black,
    secondary: accentSecondary,
    onSecondary: Colors.black,
    // ✅ REMOVIDO: background, onBackground (deprecated)
  );

  // ✅ LIGHT COLOR SCHEME
  static final ColorScheme lightScheme = ColorScheme.fromSeed(
    seedColor: seed,
    brightness: Brightness.light,
  ).copyWith(
    surface: const Color(0xFFFAFBFC),
    surfaceContainerHighest: const Color(0xFFF1F3F4),
    onSurface: const Color(0xFF1C1C1E),
    primary: accentPrimary,
  );

  // ✅ TEXT THEME
  static const TextTheme textTheme = TextTheme(
    displayLarge: TextStyle(
      fontFamily: 'Oswald',
      fontWeight: FontWeight.w700,
      letterSpacing: 1.15,
      color: Colors.white,
      fontSize: 36,
    ),
    headlineLarge: TextStyle(
      fontFamily: 'Oswald',
      fontWeight: FontWeight.w700,
      letterSpacing: 1.0,
      color: Colors.white,
      fontSize: 32,
    ),
    headlineMedium: TextStyle(
      fontFamily: 'Oswald',
      fontWeight: FontWeight.w600,
      color: accentPrimary,
      fontSize: 24,
    ),
    titleLarge: TextStyle(
      fontFamily: 'Oswald',
      fontWeight: FontWeight.w700,
      color: Colors.white,
      fontSize: 20,
    ),
    bodyLarge: TextStyle(
      fontFamily: 'Lato',
      height: 1.5,
      color: Colors.white70,
      fontSize: 16,
    ),
    bodyMedium: TextStyle(
      fontFamily: 'Lato',
      height: 1.4,
      color: Colors.white60,
      fontSize: 14,
    ),
    labelLarge: TextStyle(
      fontFamily: 'Lato',
      fontWeight: FontWeight.w700,
      color: Colors.white,
      fontSize: 14,
    ),
  );

  // ✅ DARK THEME
  static final ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    colorScheme: darkScheme,
    textTheme: textTheme,
    scaffoldBackgroundColor: backgroundPrimary,

    appBarTheme: AppBarTheme(
      backgroundColor: Colors.transparent,
      foregroundColor: Colors.white,
      elevation: 0,
      titleTextStyle: textTheme.titleLarge,
      iconTheme: const IconThemeData(color: Colors.white),
    ),

    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(
        backgroundColor: accentPrimary,
        foregroundColor: Colors.black,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        textStyle: const TextStyle(
          fontFamily: 'Oswald',
          fontWeight: FontWeight.w700,
          fontSize: 16,
        ),
      ),
    ),

    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: accentPrimary,
        foregroundColor: Colors.black,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        textStyle: const TextStyle(
          fontFamily: 'Oswald',
          fontWeight: FontWeight.w700,
          fontSize: 16,
        ),
      ),
    ),

    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: accentPrimary,
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        textStyle: const TextStyle(
          fontFamily: 'Lato',
          fontWeight: FontWeight.w600,
          fontSize: 14,
        ),
      ),
    ),

    cardTheme: CardThemeData(
      color: backgroundSecondary,
      elevation: 0,
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      surfaceTintColor: Colors.transparent,
    ),

    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: backgroundSecondary,
      selectedItemColor: accentPrimary,
      unselectedItemColor: Colors.white60,
      type: BottomNavigationBarType.fixed,
      elevation: 0,
    ),

    drawerTheme: DrawerThemeData(
      backgroundColor: backgroundPrimary,
      scrimColor: Colors.black.withValues(alpha: 0.7),
      elevation: 0,
      shadowColor: Colors.black,
      surfaceTintColor: Colors.transparent,
    ),

    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: backgroundSecondary,
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.white.withValues(alpha: 0.2)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: accentPrimary, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Colors.red, width: 1),
      ),
      labelStyle: TextStyle(color: Colors.white.withValues(alpha: 0.8)),
      hintStyle: TextStyle(color: Colors.white.withValues(alpha: 0.6)),
      prefixIconColor: Colors.white.withValues(alpha: 0.8),
    ),
  );

  // ✅ LIGHT THEME
  static final ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    colorScheme: lightScheme,
    textTheme: textTheme,
    scaffoldBackgroundColor: lightScheme.surface,
    appBarTheme: AppBarTheme(
      backgroundColor: lightScheme.surface,
      foregroundColor: lightScheme.onSurface,
      elevation: 0,
    ),
  );

  // ✅ GRADIENTES
  static Gradient get backgroundGradient => const LinearGradient(
    colors: [
      Color(0xFF0A0A0A),
      Color(0xFF1A1A1A),
      Color(0xFF0F0F0F),
    ],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    stops: [0.0, 0.7, 1.0],
  );

  static Gradient get cardGradient => LinearGradient(
    colors: [
      backgroundSecondary,
      backgroundTertiary.withValues(alpha: 0.8),
    ],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static Gradient get accentGradient => const LinearGradient(
    colors: [
      accentPrimary,
      accentSecondary,
    ],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}
