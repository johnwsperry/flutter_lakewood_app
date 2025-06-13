import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:testing/Theme/themes.dart';
import 'Widgets/homePage.dart';
import 'Database/databases.dart';

bool debugMode = true; // TURN THIS OFF WHEN WE PUBLISH THE APP

void main() {
  database.houses();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: HomePage(),
      theme: lightMode,
      darkTheme: darkMode,
    );
  }
}