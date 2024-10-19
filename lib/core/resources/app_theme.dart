import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'color_file.dart';

class AppTheme {
  static const primaryColor = ColorFile.primaryColor;
  static ThemeData themeData = ThemeData(
    useMaterial3: true,
    primarySwatch: const MaterialColor(
      0xffF16522,
      <int, Color>{
        050: primaryColor,
        100: primaryColor,
        200: primaryColor,
        300: primaryColor,
        400: primaryColor,
        500: primaryColor,
        600: primaryColor,
        700: primaryColor,
        800: primaryColor,
        900: primaryColor,
      },
    ),
    appBarTheme: const AppBarTheme(
      systemOverlayStyle: SystemUiOverlayStyle(
        statusBarColor: ColorFile.darkGrey,
        statusBarBrightness: Brightness.dark,
        statusBarIconBrightness: Brightness.dark,
        systemNavigationBarColor: ColorFile.black,
        systemNavigationBarDividerColor: ColorFile.black,
        systemNavigationBarIconBrightness: Brightness.dark,
      ),
      // backgroundColor: primaryColor,
    ),
    // dividerColor: Colors.transparent,
    primaryColor: primaryColor,
    scaffoldBackgroundColor: primaryColor,
    brightness: Brightness.dark,
    // textTheme: GoogleFonts.poppinsTextTheme(
    //   ThemeData(brightness: Brightness.dark).textTheme,
    // ),
  );
}
