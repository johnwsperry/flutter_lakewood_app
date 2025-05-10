import 'package:flutter/material.dart';
import 'package:testing/globleVars.dart';

class HouseInfoPage extends StatelessWidget {
  final int houseIndex;
  const HouseInfoPage({
    super.key,
    required this.houseIndex,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: bar,
      body: Center(
        child: Column(
          children: <Widget>[
            Expanded(
              flex: 2,
              child: Image(image: likedHomes[houseIndex].image),
            ),
            Expanded(
              flex: 1,
              child: Text(likedHomes[houseIndex].description)
            ),
          ],
        ),
      ),
    );
  }
}