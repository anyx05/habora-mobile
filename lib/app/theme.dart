import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// Design tokens — single source of truth for all color/spacing constants
const Color navyDeep    = Color(0xFF0D1F3C);
const Color navyLight   = Color(0xFF162845);
const Color tealPrimary = Color(0xFF0B8B72);
const Color tealLight   = Color(0xFF12A688);
const Color tealPale    = Color(0xFFE8F5F2);
const Color amber       = Color(0xFFE8961E);
const Color slateGrey   = Color(0xFF6B7A8D);
const Color slateLight  = Color(0xFFA8B4C0);
const Color borderColor = Color(0xFFE4E8EE);
const Color offWhite    = Color(0xFFF7F8FA);
const Color dangerRed   = Color(0xFFE83A3A);

// Border radius constants
const double radiusCard       = 16;
const double radiusChip       = 20;
const double radiusButton     = 14;
const double radiusBottomSheet = 24;

// DM Mono text style — used for confirmation codes, specs, prices
TextStyle dmMono({
  double fontSize = 14,
  FontWeight fontWeight = FontWeight.w400,
  Color color = navyDeep,
}) =>
    GoogleFonts.dmMono(fontSize: fontSize, fontWeight: fontWeight, color: color);

ThemeData buildAppTheme() {
  final base = ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(
      seedColor: tealPrimary,
      primary: tealPrimary,
      onPrimary: Colors.white,
      secondary: amber,
      surface: Colors.white,
      onSurface: navyDeep,
      error: dangerRed,
    ),
  );

  return base.copyWith(
    scaffoldBackgroundColor: offWhite,
    textTheme: GoogleFonts.dmSansTextTheme(base.textTheme).copyWith(
      displayLarge: GoogleFonts.dmSans(
        fontSize: 32, fontWeight: FontWeight.w700, color: navyDeep,
      ),
      headlineMedium: GoogleFonts.dmSans(
        fontSize: 20, fontWeight: FontWeight.w700, color: navyDeep,
      ),
      titleMedium: GoogleFonts.dmSans(
        fontSize: 16, fontWeight: FontWeight.w600, color: navyDeep,
      ),
      bodyLarge: GoogleFonts.dmSans(
        fontSize: 15, fontWeight: FontWeight.w400, color: navyDeep,
      ),
      bodyMedium: GoogleFonts.dmSans(
        fontSize: 13, fontWeight: FontWeight.w400, color: slateGrey,
      ),
      labelSmall: GoogleFonts.dmSans(
        fontSize: 11, fontWeight: FontWeight.w500, color: slateLight,
        letterSpacing: 1.0,
      ),
    ),
    cardTheme: CardThemeData(
      elevation: 0,
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(radiusCard),
        side: const BorderSide(color: borderColor),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: offWhite,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: borderColor),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: borderColor),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: tealPrimary, width: 1.5),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: dangerRed),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: dangerRed, width: 1.5),
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: tealPrimary,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radiusButton),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
        textStyle: GoogleFonts.dmSans(fontSize: 15, fontWeight: FontWeight.w600),
      ),
    ),
    appBarTheme: AppBarTheme(
      backgroundColor: navyDeep,
      foregroundColor: Colors.white,
      elevation: 0,
      titleTextStyle: GoogleFonts.dmSans(
        fontSize: 17, fontWeight: FontWeight.w600, color: Colors.white,
      ),
    ),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: Colors.white,
      selectedItemColor: tealPrimary,
      unselectedItemColor: slateLight,
      elevation: 0,
      type: BottomNavigationBarType.fixed,
    ),
    dividerTheme: const DividerThemeData(color: borderColor, thickness: 1),
    chipTheme: ChipThemeData(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(radiusChip)),
      side: const BorderSide(color: borderColor),
      backgroundColor: offWhite,
      labelStyle: GoogleFonts.dmSans(fontSize: 12, color: slateGrey),
    ),
  );
}
