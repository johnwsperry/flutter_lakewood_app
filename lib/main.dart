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



// class _TestPage extends StatelessWidget {
//   int _selectedIndex = 0;
// return MaterialApp(home: MapPage());

//   static const TextStyle optionStyle = TextStyle(fontSize: 30, fontWeight: FontWeight.bold);
//   static const List<Widget> _widgetOptions = <Widget>[
//     Text('Index 0: Home', style: optionStyle),
//     Text('Index 1: Business', style: optionStyle),
//     Text('Index 2: School', style: optionStyle),
//   ];

//   void _pageSwitch(int index) {
//     setState(() {
//       _selectedIndex = index;
//   });
// }

//   @override
//   Widget build(BuildContext context) {
//     return CupertinoPageScaffold(
//       navigationBar: const CupertinoNavigationBar(middle: Text("test text!")),
//       child: Center(
//         child: CupertinoButton(
//           onPressed: () {
            
//           }, 
//           child: Text("button!")),
//       ),
//     );
//   }
// }
