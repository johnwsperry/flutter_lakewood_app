import 'package:latlong2/latlong.dart';

import 'mapData.dart';
import 'houseDatabaseLocation.dart';
import '../Enums/sortTag.dart';

class HouseDatabaseTable{
  //Contains data and allows for it to be queried.
  final List<MapData> data;

  HouseDatabaseTable(this.data);


  //Getters
  List<MapData> getAllData(){
    return data;
  }

  MapData getDataByID(int id){
    return data[id];
  }

  Iterable<MapData>? getAllDataByName(String name){
    //Tries to get the data using firstWhere
    try {
      return data.where((item) => item.name == name);
    } catch(e){
      return null;
    }
  }

  Iterable<MapData>? getAllDataByAddress(String address){
    //Tries to get the data using firstWhere
    try {
      return data.where((item) => item.address == address);
    } catch(e){
      return null;
    }
  }

  Iterable<MapData>? getAllDataByYearBuilt(String yearBuilt){
    //Tries to get the data using firstWhere
    try {
      return data.where((item) => item.yearBuilt == yearBuilt);
    } catch(e){
      return null;
    }
  }

  Iterable<MapData>? getAllDataByShortDescription(String shortDescription){
    //Tries to get the data using firstWhere
    try {
      return data.where((item) => item.shortDescription == shortDescription);
    } catch(e){
      return null;
    }
  }

  Iterable<MapData>? getAllDataByDescription(String description){
    //Tries to get the data using firstWhere
    try {
      return data.where((item) => item.description == description);
    } catch(e){
      return null;
    }
  }

  Iterable<MapData>? getAllDataByLocation(LatLng location){
    //Tries to get the data using firstWhere
    try {
      return data.where((item) => item.location == location);
    } catch(e){
      return null;
    }
  }

  Iterable<MapData>? getAllDataByImageCount(int imageCount){
    //Tries to get the data using firstWhere
    try {
      return data.where((item) => item.imageCount == imageCount);
    } catch(e){
      return null;
    }
  }

  Iterable<MapData>? getAllDataBySortTag(SortTag tag){
    //Tries to get the data using firstWhere
    try {
      return data.where((item) => item.tags.contains(tag));
    } catch(e){
      return null;
    }
  }

  //Overrides
  @override
  String toString(){
    String returnValue = "";
    //Add the first value
    returnValue += data[0].toMap().toString();
    //In a loop, add up all of the values
    for(int i = 1; i < data.length; i++){
      returnValue += "\n";
      returnValue += data[i].toMap().toString();
    }
    return returnValue;
  }

}

class HouseDatabaseLocationTable{
  //Contains data and allows for it to be queried.
  final List<HouseDatabaseLocation> data;

  HouseDatabaseLocationTable(this.data);

  //Getters
  List<HouseDatabaseLocation> getAllData(){
    return data;
  }

  HouseDatabaseLocation getDataByID(int id){
    return data[id];
  }

  Iterable<HouseDatabaseLocation>? getAllDataByName(String name){
    //Tries to get the data using firstWhere
    try {
      return data.where((item) => item.name == name);
    } catch(e){
      return null;
    }
  }

  Iterable<HouseDatabaseLocation>? getAllDataByDescription(String description){
    //Tries to get the data using firstWhere
    try {
      return data.where((item) => item.description == description);
    } catch(e){
      return null;
    }
  }

  Iterable<HouseDatabaseLocation>? getAllDataByCenter(LatLng center){
    //Tries to get the data using firstWhere
    try {
      return data.where((item) => item.center == center);
    } catch(e){
      return null;
    }
  }

  Iterable<HouseDatabaseLocation>? getAllDataByRadius(double radius){
    //Tries to get the data using firstWhere
    try {
      return data.where((item) => item.radius == radius);
    } catch(e){
      return null;
    }
  }

  HouseDatabaseLocation? getDataByFilepath(String filepath){
    //Tries to get the data using firstWhere
    try {
      return data.firstWhere((item) => item.filepath == filepath);
    } catch(e){
      return null;
    }
  }
}