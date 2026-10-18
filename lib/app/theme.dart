/// Application theme configuration.

import 'package:flutter/material.dart';

/// Light theme for Citrus.
ThemeData lightTheme = ThemeData(
  useMaterial3: true,
  brightness: Brightness.light,
  colorScheme: ColorScheme.fromSeed(
    seedColor: const Color(0xFFFF8C00), // Citrus orange
    brightness: Brightness.light,
    primary: const Color(0xFFFF8C00),
    onPrimary: Colors.white,
    primaryContainer: const Color(0xFFFFD8A8),
    onPrimaryContainer: const Color(0xFF3D2B00),
    secondary: const Color(0xFFFFB340),
    onSecondary: const Color(0xFF3D2B00),
    secondaryContainer: const Color(0xFFFFE0B2),
    onSecondaryContainer: const Color(0xFF3D2B00),
    tertiary: const Color(0xFF4CAF50),
    onTertiary: Colors.white,
    tertiaryContainer: const Color(0xFFC8E6C9),
    onTertiaryContainer: const Color(0xFF1B5E20),
    error: const Color(0xFFD32F2F),
    onError: Colors.white,
    errorContainer: const Color(0xFFFFCDD2),
    onErrorContainer: const Color(0xFFB71C1C),
    surface: const Color(0xFFFFFBFE),
    onSurface: const Color(0xFF1D1C1B),
    surfaceContainerHighest: const Color(0xFFE8E6E1),
    onSurfaceVariant: const Color(0xFF494541),
    outline: const Color(0xFF797470),
    outlineVariant: const Color(0xFFCAC4C0),
    shadow: Colors.black,
    scrim: Colors.black,
    inverseSurface: const Color(0xFF323130),
    onInverseSurface: const Color(0xFFF5F0EB),
    inversePrimary: const Color(0xFFFFB340),
  ),
  scaffoldBackgroundColor: const Color(0xFFFFFBFE),
  cardColor: const Color(0xFFFFFBFE),
  canvasColor: const Color(0xFFFFFBFE),
  dividerColor: const Color(0xFFCAC4C0),

  // Typography
  textTheme: const TextTheme(
    displayLarge: TextStyle(
      fontSize: 57,
      fontWeight: FontWeight.w400,
      letterSpacing: -0.25,
      color: Color(0xFF1D1C1B),
    ),
    displayMedium: TextStyle(
      fontSize: 45,
      fontWeight: FontWeight.w400,
      letterSpacing: 0,
      color: Color(0xFF1D1C1B),
    ),
    displaySmall: TextStyle(
      fontSize: 36,
      fontWeight: FontWeight.w400,
      letterSpacing: 0,
      color: Color(0xFF1D1C1B),
    ),
    headlineLarge: TextStyle(
      fontSize: 32,
      fontWeight: FontWeight.w600,
      letterSpacing: 0,
      color: Color(0xFF1D1C1B),
    ),
    headlineMedium: TextStyle(
      fontSize: 28,
      fontWeight: FontWeight.w600,
      letterSpacing: 0,
      color: Color(0xFF1D1C1B),
    ),
    headlineSmall: TextStyle(
      fontSize: 24,
      fontWeight: FontWeight.w600,
      letterSpacing: 0,
      color: Color(0xFF1D1C1B),
    ),
    titleLarge: TextStyle(
      fontSize: 22,
      fontWeight: FontWeight.w500,
      letterSpacing: 0,
      color: Color(0xFF1D1C1B),
    ),
    titleMedium: TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w500,
      letterSpacing: 0.15,
      color: Color(0xFF1D1C1B),
    ),
    titleSmall: TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w500,
      letterSpacing: 0.1,
      color: Color(0xFF1D1C1B),
    ),
    bodyLarge: TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w400,
      letterSpacing: 0.5,
      color: Color(0xFF1D1C1B),
    ),
    bodyMedium: TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w400,
      letterSpacing: 0.25,
      color: Color(0xFF1D1C1B),
    ),
    bodySmall: TextStyle(
      fontSize: 12,
      fontWeight: FontWeight.w400,
      letterSpacing: 0.4,
      color: Color(0xFF494541),
    ),
    labelLarge: TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w500,
      letterSpacing: 0.1,
      color: Color(0xFF1D1C1B),
    ),
    labelMedium: TextStyle(
      fontSize: 12,
      fontWeight: FontWeight.w500,
      letterSpacing: 0.5,
      color: Color(0xFF494541),
    ),
    labelSmall: TextStyle(
      fontSize: 11,
      fontWeight: FontWeight.w500,
      letterSpacing: 0.5,
      color: Color(0xFF494541),
    ),
  ),

  // Component themes
  appBarTheme: const AppBarTheme(
    centerTitle: false,
    elevation: 0,
    scrolledUnderElevation: 1,
    surfaceTintColor: Colors.transparent,
    backgroundColor: Colors.transparent,
    foregroundColor: Color(0xFF1D1C1B),
    titleTextStyle: TextStyle(
      fontSize: 20,
      fontWeight: FontWeight.w600,
      color: Color(0xFF1D1C1B),
    ),
  ),

  cardTheme: const CardTheme(
    elevation: 1,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(12)),
      side: BorderSide(color: Color(0xFFE8E6E1), width: 1),
    ),
    color: Color(0xFFFFFBFE),
    surfaceTintColor: Colors.transparent,
    shadowColor: Color(0x0D000000), // 0.05 opacity
  ),

  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      elevation: 0,
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      backgroundColor: const Color(0xFFFF8C00),
      foregroundColor: Colors.white,
      textStyle: const TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w600,
      ),
    ),
  ),

  filledButtonTheme: FilledButtonThemeData(
    style: FilledButton.styleFrom(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      backgroundColor: const Color(0xFFFF8C00),
      foregroundColor: Colors.white,
    ),
  ),

  outlinedButtonTheme: OutlinedButtonThemeData(
    style: OutlinedButton.styleFrom(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      side: const BorderSide(color: Color(0xFFFF8C00), width: 1.5),
      foregroundColor: const Color(0xFFFF8C00),
      textStyle: const TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w600,
      ),
    ),
  ),

  textButtonTheme: TextButtonThemeData(
    style: TextButton.styleFrom(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      foregroundColor: const Color(0xFFFF8C00),
      textStyle: const TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w600,
      ),
    ),
  ),

  inputDecorationTheme: InputDecorationTheme(
    filled: true,
    fillColor: const Color(0xFFF5F0EB),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: const BorderSide(color: Color(0xFFCAC4C0)),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: const BorderSide(color: Color(0xFFCAC4C0)),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: const BorderSide(color: Color(0xFFFF8C00), width: 2),
    ),
    errorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: const BorderSide(color: Color(0xFFD32F2F)),
    ),
    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
    labelStyle: const TextStyle(color: Color(0xFF494541)),
    hintStyle: const TextStyle(color: Color(0xFF797470)),
  ),

  dialogTheme: const DialogTheme(
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(16)),
    ),
    backgroundColor: Color(0xFFFFFBFE),
    surfaceTintColor: Colors.transparent,
    titleTextStyle: TextStyle(
      fontSize: 20,
      fontWeight: FontWeight.w600,
      color: Color(0xFF1D1C1B),
    ),
    contentTextStyle: TextStyle(
      fontSize: 14,
      color: Color(0xFF1D1C1B),
    ),
  ),

  bottomSheetTheme: const BottomSheetThemeData(
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
    ),
    backgroundColor: Color(0xFFFFFBFE),
    surfaceTintColor: Colors.transparent,
    elevation: 8,
  ),

  navigationBarTheme: NavigationBarThemeData(
    height: 64,
    backgroundColor: const Color(0xFFFFFBFE),
    surfaceTintColor: Colors.transparent,
    indicatorColor: const Color(0xFFFFD8A8),
    labelTextStyle: WidgetStateProperty.resolveWith((states) {
      if (states.contains(WidgetState.selected)) {
        return const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: Color(0xFFFF8C00),
        );
      }
      return const TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w400,
        color: Color(0xFF797470),
      );
    }),
  ),

  tabBarTheme: const TabBarTheme(
    labelColor: Color(0xFFFF8C00),
    unselectedLabelColor: Color(0xFF797470),
    indicator: UnderlineTabIndicator(
      borderSide: BorderSide(color: Color(0xFFFF8C00), width: 3),
      insets: EdgeInsets.symmetric(horizontal: 16),
    ),
    labelStyle: TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w600,
    ),
    unselectedLabelStyle: TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w400,
    ),
  ),

  chipTheme: ChipThemeData(
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(20),
    ),
    labelStyle: const TextStyle(
      fontSize: 13,
      fontWeight: FontWeight.w500,
    ),
    backgroundColor: const Color(0xFFF5F0EB),
    selectedColor: const Color(0xFFFFD8A8),
    disabledColor: const Color(0xFFE8E6E1),
    checkmarkColor: const Color(0xFFFF8C00),
    side: const BorderSide(color: Color(0xFFE8E6E1)),
    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
  ),

  dividerTheme: const DividerThemeData(
    color: Color(0xFFE8E6E1),
    thickness: 1,
    space: 1,
  ),

  listTileTheme: ListTileThemeData(
    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
    titleTextStyle: const TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w500,
      color: Color(0xFF1D1C1B),
    ),
    subtitleTextStyle: const TextStyle(
      fontSize: 13,
      fontWeight: FontWeight.w400,
      color: Color(0xFF494541),
    ),
    leadingAndTrailingTextStyle: const TextStyle(
      fontSize: 13,
      fontWeight: FontWeight.w400,
      color: Color(0xFF494541),
    ),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(8),
    ),
    selectedTileColor: const Color(0xFFFFD8A8),
  ),

  progressIndicatorTheme: const ProgressIndicatorThemeData(
    color: Color(0xFFFF8C00),
    linearTrackColor: Color(0xFFFFD8A8),
    circularTrackColor: Color(0xFFFFD8A8),
  ),

  sliderTheme: SliderThemeData(
    activeTrackColor: const Color(0xFFFF8C00),
    inactiveTrackColor: const Color(0xFFFFD8A8),
    thumbColor: const Color(0xFFFF8C00),
    overlayColor: const Color(0xFFFFD8A8),
    valueIndicatorColor: const Color(0xFFFF8C00),
    valueIndicatorTextStyle: const TextStyle(color: Colors.white),
    trackHeight: 4,
    thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 10),
    overlayShape: const RoundSliderOverlayShape(overlayRadius: 20),
  ),

  switchTheme: SwitchThemeData(
    thumbColor: WidgetStateProperty.resolveWith((states) {
      if (states.contains(WidgetState.selected)) {
        return const Color(0xFFFF8C00);
      }
      return Colors.grey.shade400;
    }),
    trackColor: WidgetStateProperty.resolveWith((states) {
      if (states.contains(WidgetState.selected)) {
        return const Color(0xFFFFD8A8);
      }
      return Colors.grey.shade300;
    }),
  ),

  checkboxTheme: CheckboxThemeData(
    fillColor: WidgetStateProperty.resolveWith((states) {
      if (states.contains(WidgetState.selected)) {
        return const Color(0xFFFF8C00);
      }
      return Colors.transparent;
    }),
    checkColor: WidgetStateProperty.all(Colors.white),
    side: const BorderSide(color: Color(0xFFCAC4C0), width: 2),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
  ),

  radioTheme: RadioThemeData(
    fillColor: WidgetStateProperty.resolveWith((states) {
      if (states.contains(WidgetState.selected)) {
        return const Color(0xFFFF8C00);
      }
      return const Color(0xFFCAC4C0);
    }),
  ),

  tooltipTheme: TooltipThemeData(
    decoration: BoxDecoration(
      color: const Color(0xFF323130),
      borderRadius: BorderRadius.circular(8),
    ),
    textStyle: const TextStyle(
      fontSize: 12,
      color: Colors.white,
    ),
    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
    verticalOffset: 8,
  ),

  snackBarTheme: SnackBarThemeData(
    backgroundColor: const Color(0xFF323130),
    contentTextStyle: const TextStyle(color: Colors.white),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(12),
    ),
    behavior: SnackBarBehavior.floating,
    elevation: 4,
  ),

  floatingActionButtonTheme: const FloatingActionButtonThemeData(
    backgroundColor: Color(0xFFFF8C00),
    foregroundColor: Colors.white,
    elevation: 2,
    shape: CircleBorder(),
  ),

  iconTheme: const IconThemeData(
    color: Color(0xFF1D1C1B),
    size: 24,
  ),

  primaryIconTheme: const IconThemeData(
    color: Colors.white,
    size: 24,
  ),
);

/// Dark theme for Citrus.
ThemeData darkTheme = ThemeData(
  useMaterial3: true,
  brightness: Brightness.dark,
  colorScheme: ColorScheme.fromSeed(
    seedColor: const Color(0xFFFF8C00),
    brightness: Brightness.dark,
    primary: const Color(0xFFFFB340),
    onPrimary: const Color(0xFF3D2B00),
    primaryContainer: const Color(0xFF5C3D00),
    onPrimaryContainer: const Color(0xFFFFD8A8),
    secondary: const Color(0xFFFFD8A8),
    onSecondary: const Color(0xFF3D2B00),
    secondaryContainer: const Color(0xFF5C3D00),
    onSecondaryContainer: const Color(0xFFFFD8A8),
    tertiary: const Color(0xFF81C784),
    onTertiary: const Color(0xFF0D3B0D),
    tertiaryContainer: const Color(0xFF1B5E20),
    onTertiaryContainer: const Color(0xFFC8E6C9),
    error: const Color(0xFFEF5350),
    onError: const Color(0xFF3D0D0D),
    errorContainer: const Color(0xFFB71C1C),
    onErrorContainer: const Color(0xFFFFCDD2),
    surface: const Color(0xFF1D1C1B),
    onSurface: const Color(0xFFF5F0EB),
    surfaceContainerHighest: const Color(0xFF323130),
    onSurfaceVariant: const Color(0xFFCAC4C0),
    outline: const Color(0xFF938F8A),
    outlineVariant: const Color(0xFF494541),
    shadow: Colors.black,
    scrim: Colors.black,
    inverseSurface: const Color(0xFFF5F0EB),
    onInverseSurface: const Color(0xFF323130),
    inversePrimary: const Color(0xFFFF8C00),
  ),
  scaffoldBackgroundColor: const Color(0xFF151413),
  cardColor: const Color(0xFF1D1C1B),
  canvasColor: const Color(0xFF151413),
  dividerColor: const Color(0xFF323130),
  textTheme: const TextTheme(
    displayLarge: TextStyle(
      fontSize: 57,
      fontWeight: FontWeight.w400,
      letterSpacing: -0.25,
      color: Color(0xFFF5F0EB),
    ),
    displayMedium: TextStyle(
      fontSize: 45,
      fontWeight: FontWeight.w400,
      letterSpacing: 0,
      color: Color(0xFFF5F0EB),
    ),
    displaySmall: TextStyle(
      fontSize: 36,
      fontWeight: FontWeight.w400,
      letterSpacing: 0,
      color: Color(0xFFF5F0EB),
    ),
    headlineLarge: TextStyle(
      fontSize: 32,
      fontWeight: FontWeight.w600,
      letterSpacing: 0,
      color: Color(0xFFF5F0EB),
    ),
    headlineMedium: TextStyle(
      fontSize: 28,
      fontWeight: FontWeight.w600,
      letterSpacing: 0,
      color: Color(0xFFF5F0EB),
    ),
    headlineSmall: TextStyle(
      fontSize: 24,
      fontWeight: FontWeight.w600,
      letterSpacing: 0,
      color: Color(0xFFF5F0EB),
    ),
    titleLarge: TextStyle(
      fontSize: 22,
      fontWeight: FontWeight.w500,
      letterSpacing: 0,
      color: Color(0xFFF5F0EB),
    ),
    titleMedium: TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w500,
      letterSpacing: 0.15,
      color: Color(0xFFF5F0EB),
    ),
    titleSmall: TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w500,
      letterSpacing: 0.1,
      color: Color(0xFFF5F0EB),
    ),
    bodyLarge: TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w400,
      letterSpacing: 0.5,
      color: Color(0xFFF5F0EB),
    ),
    bodyMedium: TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w400,
      letterSpacing: 0.25,
      color: Color(0xFFF5F0EB),
    ),
    bodySmall: TextStyle(
      fontSize: 12,
      fontWeight: FontWeight.w400,
      letterSpacing: 0.4,
      color: Color(0xFFCAC4C0),
    ),
    labelLarge: TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w500,
      letterSpacing: 0.1,
      color: Color(0xFFF5F0EB),
    ),
    labelMedium: TextStyle(
      fontSize: 12,
      fontWeight: FontWeight.w500,
      letterSpacing: 0.5,
      color: Color(0xFFCAC4C0),
    ),
    labelSmall: TextStyle(
      fontSize: 11,
      fontWeight: FontWeight.w500,
      letterSpacing: 0.5,
      color: Color(0xFFCAC4C0),
    ),
  ),
  appBarTheme: const AppBarTheme(
    centerTitle: false,
    elevation: 0,
    scrolledUnderElevation: 1,
    surfaceTintColor: Colors.transparent,
    backgroundColor: Colors.transparent,
    foregroundColor: Color(0xFFF5F0EB),
    titleTextStyle: TextStyle(
      fontSize: 20,
      fontWeight: FontWeight.w600,
      color: Color(0xFFF5F0EB),
    ),
  ),
  cardTheme: const CardTheme(
    elevation: 1,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(12)),
      side: BorderSide(color: Color(0xFF323130), width: 1),
    ),
    color: Color(0xFF1D1C1B),
    surfaceTintColor: Colors.transparent,
    shadowColor: Color(0x4D000000), // 0.3 opacity
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      elevation: 0,
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      backgroundColor: const Color(0xFFFFB340),
      foregroundColor: const Color(0xFF3D2B00),
      textStyle: const TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w600,
      ),
    ),
  ),
  filledButtonTheme: FilledButtonThemeData(
    style: FilledButton.styleFrom(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      backgroundColor: const Color(0xFFFFB340),
      foregroundColor: const Color(0xFF3D2B00),
    ),
  ),
  outlinedButtonTheme: OutlinedButtonThemeData(
    style: OutlinedButton.styleFrom(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      side: const BorderSide(color: Color(0xFFFFB340), width: 1.5),
      foregroundColor: const Color(0xFFFFB340),
      textStyle: const TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w600,
      ),
    ),
  ),
  textButtonTheme: TextButtonThemeData(
    style: TextButton.styleFrom(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      foregroundColor: const Color(0xFFFFB340),
      textStyle: const TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w600,
      ),
    ),
  ),
  inputDecorationTheme: InputDecorationTheme(
    filled: true,
    fillColor: const Color(0xFF2A2928),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: const BorderSide(color: Color(0xFF494541)),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: const BorderSide(color: Color(0xFF494541)),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: const BorderSide(color: Color(0xFFFFB340), width: 2),
    ),
    errorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: const BorderSide(color: Color(0xFFEF5350)),
    ),
    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
    labelStyle: const TextStyle(color: Color(0xFFCAC4C0)),
    hintStyle: const TextStyle(color: Color(0xFF938F8A)),
  ),
  dialogTheme: const DialogTheme(
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(16)),
    ),
    backgroundColor: Color(0xFF1D1C1B),
    surfaceTintColor: Colors.transparent,
    titleTextStyle: TextStyle(
      fontSize: 20,
      fontWeight: FontWeight.w600,
      color: Color(0xFFF5F0EB),
    ),
    contentTextStyle: TextStyle(
      fontSize: 14,
      color: Color(0xFFF5F0EB),
    ),
  ),
  bottomSheetTheme: const BottomSheetThemeData(
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
    ),
    backgroundColor: const Color(0xFF1D1C1B),
    surfaceTintColor: Colors.transparent,
    elevation: 8,
  ),
  navigationBarTheme: NavigationBarThemeData(
    height: 64,
    backgroundColor: const Color(0xFF1D1C1B),
    surfaceTintColor: Colors.transparent,
    indicatorColor: const Color(0xFF5C3D00),
    labelTextStyle: WidgetStateProperty.resolveWith((states) {
      if (states.contains(WidgetState.selected)) {
        return const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: Color(0xFFFFB340),
        );
      }
      return const TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w400,
        color: Color(0xFF938F8A),
      );
    }),
  ),
  tabBarTheme: const TabBarTheme(
    labelColor: Color(0xFFFFB340),
    unselectedLabelColor: Color(0xFF938F8A),
    indicator: UnderlineTabIndicator(
      borderSide: BorderSide(color: Color(0xFFFFB340), width: 3),
      insets: EdgeInsets.symmetric(horizontal: 16),
    ),
    labelStyle: TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w600,
    ),
    unselectedLabelStyle: TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w400,
    ),
  ),
  chipTheme: ChipThemeData(
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(20),
    ),
    labelStyle: const TextStyle(
      fontSize: 13,
      fontWeight: FontWeight.w500,
    ),
    backgroundColor: const Color(0xFF2A2928),
    selectedColor: const Color(0xFF5C3D00),
    disabledColor: const Color(0xFF323130),
    checkmarkColor: const Color(0xFFFFB340),
    side: const BorderSide(color: Color(0xFF323130)),
    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
  ),
  dividerTheme: const DividerThemeData(
    color: Color(0xFF323130),
    thickness: 1,
    space: 1,
  ),
  listTileTheme: ListTileThemeData(
    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
    titleTextStyle: const TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w500,
      color: Color(0xFFF5F0EB),
    ),
    subtitleTextStyle: const TextStyle(
      fontSize: 13,
      fontWeight: FontWeight.w400,
      color: Color(0xFFCAC4C0),
    ),
    leadingAndTrailingTextStyle: const TextStyle(
      fontSize: 13,
      fontWeight: FontWeight.w400,
      color: Color(0xFFCAC4C0),
    ),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(8),
    ),
    selectedTileColor: const Color(0xFF5C3D00),
  ),
  progressIndicatorTheme: const ProgressIndicatorThemeData(
    color: Color(0xFFFFB340),
    linearTrackColor: Color(0xFF5C3D00),
    circularTrackColor: Color(0xFF5C3D00),
  ),
  sliderTheme: SliderThemeData(
    activeTrackColor: const Color(0xFFFFB340),
    inactiveTrackColor: const Color(0xFF5C3D00),
    thumbColor: const Color(0xFFFFB340),
    overlayColor: const Color(0xFF5C3D00),
    valueIndicatorColor: const Color(0xFFFFB340),
    valueIndicatorTextStyle: const TextStyle(color: Color(0xFF3D2B00)),
    trackHeight: 4,
    thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 10),
    overlayShape: const RoundSliderOverlayShape(overlayRadius: 20),
  ),
  switchTheme: SwitchThemeData(
    thumbColor: WidgetStateProperty.resolveWith((states) {
      if (states.contains(WidgetState.selected)) {
        return const Color(0xFFFFB340);
      }
      return Colors.grey.shade600;
    }),
    trackColor: WidgetStateProperty.resolveWith((states) {
      if (states.contains(WidgetState.selected)) {
        return const Color(0xFF5C3D00);
      }
      return Colors.grey.shade700;
    }),
  ),
  checkboxTheme: CheckboxThemeData(
    fillColor: WidgetStateProperty.resolveWith((states) {
      if (states.contains(WidgetState.selected)) {
        return const Color(0xFFFFB340);
      }
      return Colors.transparent;
    }),
    checkColor: WidgetStateProperty.all(const Color(0xFF3D2B00)),
    side: const BorderSide(color: Color(0xFF494541), width: 2),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
  ),
  radioTheme: RadioThemeData(
    fillColor: WidgetStateProperty.resolveWith((states) {
      if (states.contains(WidgetState.selected)) {
        return const Color(0xFFFFB340);
      }
      return const Color(0xFF494541);
    }),
  ),
  tooltipTheme: TooltipThemeData(
    decoration: BoxDecoration(
      color: const Color(0xFFF5F0EB),
      borderRadius: BorderRadius.circular(8),
    ),
    textStyle: const TextStyle(
      fontSize: 12,
      color: Color(0xFF1D1C1B),
    ),
    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
    verticalOffset: 8,
  ),
  snackBarTheme: SnackBarThemeData(
    backgroundColor: const Color(0xFFF5F0EB),
    contentTextStyle: const TextStyle(color: Color(0xFF1D1C1B)),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(12),
    ),
    behavior: SnackBarBehavior.floating,
    elevation: 4,
  ),
  floatingActionButtonTheme: const FloatingActionButtonThemeData(
    backgroundColor: Color(0xFFFFB340),
    foregroundColor: Color(0xFF3D2B00),
    elevation: 2,
    shape: CircleBorder(),
  ),
  iconTheme: const IconThemeData(
    color: Color(0xFFF5F0EB),
    size: 24,
  ),
  primaryIconTheme: const IconThemeData(
    color: Color(0xFF3D2B00),
    size: 24,
  ),
);
