import 'dart:math';

import '../Database/databases.dart' as database;
import '../Classes/mapData.dart';



class HouseOfTheDay{

  late int houseToday;

  void displayHouses() async{
    List<MapData> data = await database.DatabaseSingleton.instance.houses;
    if(houseToday == null){
      houseToday = Random(DateTime.timestamp().day).nextInt(data.length);
    }
  }


}