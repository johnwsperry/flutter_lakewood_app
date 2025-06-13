
import 'package:latlong2/latlong.dart';

import '../Enums/databaseTag.dart';

class HouseDatabaseLocation{
  final int id;
  final String name;
  final String description;
  late final LatLng center;
  final double radius;
  final String filepath;
  late final List<DatabaseTag> tags;

  HouseDatabaseLocation(this.id, this.name, this.description, double lat, double long, this.radius, this.filepath, String tags){
    center = LatLng(lat, long);
    this.tags = stringToTags(tags);
  }

  List<DatabaseTag> stringToTags(String input){
    List<String> numbers = ["1", "2", "3", "4", "5", "6", "7", "8", "9", "0"];
    //String must be formated as #,#,#...
    List<DatabaseTag> returnTags = [];
    String currentNumber = "";
    for(int i = 0; i < input.length; i++){
      //Check every char
      String currentChar = input[i];
      if(currentChar == "," && currentNumber.isNotEmpty){
        //check for commas
        int number = int.parse(currentNumber);
        currentNumber = "";
        if(number < 0 || number >= DatabaseTag.values.length) continue;
        returnTags.add(DatabaseTag.values[number]);
      }
      //Check if a valid number
      if(!numbers.contains(currentChar)) continue;
      currentNumber += currentChar;
    }

    if(currentNumber.isNotEmpty){
      int number = int.parse(currentNumber);
      currentNumber = "";
      if(number < 0 || number >= DatabaseTag.values.length) return returnTags;
      returnTags.add(DatabaseTag.values[number]);
    }

    return returnTags;
  }

  String tagsToString(List<DatabaseTag> tags){
    String returnString = "";
    for(DatabaseTag tag in tags){
      //Convert tags
      returnString += "${tag.index}, ";
    }
    return returnString;
  }
}