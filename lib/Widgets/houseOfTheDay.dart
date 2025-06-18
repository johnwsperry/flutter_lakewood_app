//Add code comments
//Were you coding in txt or smth?
import 'package:flutter/material.dart';
import 'dart:math';
import 'package:intl/intl.dart';
import 'package:testing/Classes/mapData.dart';
import '../Classes/house.dart';
import '../Util/databases.dart';

class RandomHouseGenerator extends StatelessWidget {
  const RandomHouseGenerator({super.key});

  Future<MapData> getHouseOfTheDay() async {
    final date = DateFormat('yyyy-MM-dd').format(DateTime.now());
    final hash = date.hashCode;
    var allHouses = (await Databases.queryHousesById(0)).data;
    final index = hash.abs() % allHouses.length;
    return allHouses[index];
  }

  @override
  Widget build(BuildContext context) {
    final house = getHouseOfTheDay();

    return Card(
      margin: const EdgeInsets.all(16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 4,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Image.asset(house, fit: BoxFit.cover),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(house.address,
                    style:
                        const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                Text(house.description),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
