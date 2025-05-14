import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'Widgets/homePage.dart';
import 'Widgets/mapPage.dart';
import 'Database/databases.dart';

void main() {
  init();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(home: HomePage());
    return MaterialApp(home: MapPage(title: 'hi',));
  }
}
