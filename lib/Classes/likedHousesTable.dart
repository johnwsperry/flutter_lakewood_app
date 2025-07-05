



import 'package:sqflite/sqflite.dart';
import 'package:testing/main.dart';

class LikedHousesTable{

  List<LikedHouseData> data = [];

  Database database;

  ///Creates the table
  LikedHousesTable(this.data, this.database);

  ///Adds a house to the liked houses data table
  void addHouse(int dbId, int houseId){
    //Check if present
    if(data.any((test) => test.houseId == houseId && test.databaseId == dbId)) return;
    //Add a new one
    LikedHouseData newData = LikedHouseData(data.length, dbId, houseId);
    data.add(newData);
    //Add it to the database as well
    _databaseAddHouse(newData);
  }

  ///Removes a house from the liked houses data table
  void removeHouse(int dbId, int houseId){
    //grab the item if it exists
    int index = data.indexWhere((test) => test.houseId == houseId && test.databaseId == dbId);
    if(index != -1){
      data.removeAt(index);
    }
    //Update the database to match
    _deleteHouse(dbId, houseId);
  }

  ///Checks if it contains a house
  bool containsHouse(int dbId, int houseId){
    //data check
    if(data.any((test) => test.houseId == houseId && test.databaseId == dbId)) return true;
    //else
    return false;
  }

  //Async database functions
  ///A private function that adds a house to the database
  void _databaseAddHouse(LikedHouseData data) async {
    //Adds a house to the liked houses. If a conflict arises, replace the house.
    await database.insert('LikedHousesDatabase', data.toMap(), conflictAlgorithm: ConflictAlgorithm.replace);
  }

  ///A private function that deletes a house from the database
  void _deleteHouse(int dbId, int houseId) async {
    await database.delete('LikedHousesDatabase', where: 'databaseId = ? AND houseId = ?', whereArgs: [dbId, houseId]);
  }

  List<LikedHouseData> getWithDbId(int dbId){
    List<LikedHouseData> returnData = data.toList();
    //Remove data without the id
    returnData.removeWhere((test) => test.databaseId != dbId);
    return returnData;
  }

}

class LikedHouseData{

  ///The id in Sqlite
  int id;
  ///The id of the database
  int databaseId;
  ///The id of the house
  int houseId;
  ///The time it was added to the database
  late DateTime likedDate;

  ///Initializes LikedHouseData with an optional string with microseconds since epoch.
  LikedHouseData(this.id, this.databaseId, this.houseId, {String? inputLikedDate}){
    if(inputLikedDate == null || inputLikedDate.isEmpty){
      //Initialise the time added using the current time
      likedDate = DateTime.now();
      return;
    }
    //Initialise the time added using the inputTime.
    likedDate = DateTime.fromMicrosecondsSinceEpoch(int.parse(inputLikedDate));
  }

  ///The map for serialising the data
  Map<String, Object?> toMap() {
    return {'id' : id, 'databaseId' : databaseId, 'houseId' : houseId, 'likedDate' : likedDate.microsecondsSinceEpoch.toString()};
  }



}