import 'package:flutter/material.dart';
import 'Widgets/homePage.dart';
import 'Util/databases.dart' as database;


bool debugMode = true; // TURN THIS OFF WHEN WE PUBLISH THE APP

void main() {
  database.DatabaseSingleton.queryHousesById(0);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(home: HomePage());
  }
}