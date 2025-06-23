import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_color.dart';

final primaryColor = Color(0xFFCCCCCC);

final appTheme = ThemeData(
  appBarTheme: AppBarTheme(
    centerTitle: true,
  ),
  textTheme: GoogleFonts.cairoTextTheme(),
  brightness: Brightness.light,
  colorScheme: ColorScheme.light(
    primary: primaryColor,
  ),
  progressIndicatorTheme: ProgressIndicatorThemeData(color: primaryColor),
  inputDecorationTheme: InputDecorationTheme(
    contentPadding: EdgeInsets.symmetric(horizontal:8, vertical: 8),
    isDense: true,
    filled: true,
    fillColor: Colors.white,
    hintStyle: TextStyle(
      fontSize: 11,
      fontWeight: FontWeight.normal,
      color: Color(0xFF848484),
    ),
    enabledBorder: OutlineInputBorder(
      borderSide: BorderSide(color: Color(0xFFCCCCCC), width: 1),
      borderRadius: BorderRadius.circular(12),
    ),
    focusedBorder: OutlineInputBorder(
      borderSide: BorderSide(color: Color(0xFFCCCCCC), width: 1),
      borderRadius: BorderRadius.circular(12),
    ),
    border: OutlineInputBorder(
      borderSide: BorderSide(color: Color(0xFFCCCCCC), width: 1),
      borderRadius: BorderRadius.circular(12),
    ),
    floatingLabelStyle: TextStyle(
      color: Color(0xFF848484), // Floating label color
    ),
  ),
);
