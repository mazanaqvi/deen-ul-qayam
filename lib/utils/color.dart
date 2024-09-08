import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/* Main Color */
const colorPrimary = Color(0xff004AAB);
const colorPrimaryDark = Color(0xff004AAB);
const colorAccent = Color(0xffFF9801);

const white = Color(0xffffffff);
const black = Color(0xff000000);
const lightblack = Color(0xff3D3D3D);
const red = Color(0xffFF0000);
const green = Color(0xff6ACA2F);
const gray = Color(0xff888888);
const comman = Color(0xff0F2E56);
Color transparentColor = Colors.transparent;

/* ============================= Light Theme =============================== */

final ThemeData lightTheme = ThemeData(
  brightness: Brightness.light,
  /* Main Color Start */
  primaryColor: colorPrimary,
  secondaryHeaderColor: colorPrimary.withOpacity(0.08),
  hintColor: colorAccent,
  scaffoldBackgroundColor: white,
  /* Main Color End */
  /* Text Color Start */
  colorScheme: const ColorScheme.light(
    surface: black,
    primary: white,
    onPrimary: white,
    secondary: white,
    onSecondary: white,
  ),
  /* Text Color End */
  appBarTheme: const AppBarTheme(
      color: white,
      systemOverlayStyle: SystemUiOverlayStyle(
          statusBarColor: white,
          statusBarBrightness: Brightness.light,
          statusBarIconBrightness: Brightness.dark)),
  cardColor: white,
  bottomSheetTheme: const BottomSheetThemeData(
    backgroundColor: white,
  ),
);

/* ============================= Dark Theme =============================== */

final ThemeData darkTheme = ThemeData(
  brightness: Brightness.dark,
  /* Main Color Start */
  primaryColor: colorPrimary,
  hintColor: colorAccent,
  secondaryHeaderColor: gray.withOpacity(0.20),
  scaffoldBackgroundColor: black,
  /* Main Color End */
  /* Text Color Start */

  colorScheme: const ColorScheme.dark(
    surface: white,
    primary: white,
    onPrimary: white,
    secondary: white,
    onSecondary: white,
  ),
  /* Text Color End */
  appBarTheme: const AppBarTheme(
    color: black,
    systemOverlayStyle: SystemUiOverlayStyle(
        statusBarColor: black,
        statusBarBrightness: Brightness.dark,
        statusBarIconBrightness: Brightness.light),
  ),
  cardColor: black,
  bottomSheetTheme: const BottomSheetThemeData(
    backgroundColor: black,
  ),
);
