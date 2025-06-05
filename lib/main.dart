import 'package:flutter/material.dart';

import 'Util/databases.dart' as database;
import 'Widgets/homePage.dart';


bool debugMode = true; // TURN THIS OFF WHEN WE PUBLISH THE APP

void main() {
  database.Databases.queryHousesByPath("lakewood-lakeoswego-oregon-unitedstates-earth-milkyway.sqlite");
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(home: HomePage());
  }
}