import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

ThemeData lightTheme = ThemeData(
  primarySwatch: Colors.red,
  fontFamily: 'saraff',
  textTheme: const TextTheme(
    bodyText1: TextStyle(
      fontSize: 36,
      color: Colors.black,
      fontWeight: FontWeight.bold,
    ),
    bodyText2: TextStyle(
      // fontFamily: 'saraff',
      fontSize: 20,
      color: Colors.black,
    ),
    button: TextStyle(
      fontSize: 16,
      color: Colors.black,
      fontWeight: FontWeight.bold,
    ),
  ),
  appBarTheme: const AppBarTheme(
    color: Colors.white60,
    centerTitle: true,
    actionsIconTheme: IconThemeData(color: Colors.red),
    titleTextStyle: TextStyle(
      color: Colors.red,
      fontWeight: FontWeight.bold,
      fontSize: 20.0,
    ),
    systemOverlayStyle: SystemUiOverlayStyle(
        statusBarColor: Colors.red, statusBarIconBrightness: Brightness.light),
  ),
  bottomNavigationBarTheme: const BottomNavigationBarThemeData(
    type: BottomNavigationBarType.fixed,
    backgroundColor: Colors.white70,
    elevation: 25.0,
    selectedItemColor: Colors.red,
    unselectedItemColor: Colors.black26,
  ),
);
//====================================================
ThemeData darkTheme = ThemeData(
  primarySwatch: Colors.red,
  scaffoldBackgroundColor: Colors.black,
  fontFamily: 'saraff',
  textTheme: const TextTheme(
    bodyText1: TextStyle(
      fontSize: 36,
      color: Colors.white,
      fontWeight: FontWeight.bold,
    ),
    bodyText2: TextStyle(
      // fontFamily: 'saraff',
      fontSize: 20,
      color: Colors.white,
    ),
    subtitle1: TextStyle(color: Colors.white),
    button: TextStyle(
      fontSize: 16,
      color: Colors.white,
      fontWeight: FontWeight.bold,
    ),
  ),
  appBarTheme: const AppBarTheme(
    color: Colors.white12,
    centerTitle: true,
    actionsIconTheme: IconThemeData(color: Colors.red),
    titleTextStyle: TextStyle(
      color: Colors.red,
      fontWeight: FontWeight.bold,
      fontSize: 20.0,
    ),
    systemOverlayStyle: SystemUiOverlayStyle(
        statusBarColor: Colors.black,
        statusBarIconBrightness: Brightness.light),
  ),
  bottomNavigationBarTheme: const BottomNavigationBarThemeData(
    type: BottomNavigationBarType.fixed,
    backgroundColor: Colors.white12,
    elevation: 25.0,
    selectedItemColor: Colors.red,
    unselectedItemColor: Colors.white70,
  ),
);
