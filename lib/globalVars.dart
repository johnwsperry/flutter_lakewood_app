import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:testing/Classes/databaseTables.dart';
import 'package:testing/Classes/houseDatabaseLocation.dart';
import 'package:testing/Classes/likedHousesTable.dart';
import 'package:testing/Classes/mapData.dart';


//<editor-fold desc="Map Vars">

//<editor-fold desc="Map Details">
double mapIconWidth = 30;
double mapIconHeight = 30;
double mapIconSize = 30;

double focusZoom = 19;
double refocusZoom = 16;
int focusAnimationDuration = 500; //ms

//focusmap
double focusMapInitZoom = 20;

//Pin Centering(Very Weird)
//Multiply by 0.000001
double latLongMultiplier = 0.000001;
int wideCenterOffset = -900;
int longCenterOffset = -300;

//Widget Centering
double wideUp = 0.5;
double wideRight = 0.6;

double longUp = 0.6;
double longRight = 0.5;

//Temporary appbar for most pages
final PreferredSizeWidget bar = AppBar(
    backgroundColor: Colors.indigoAccent,
    title: const Text("Lakewood Homes", style: TextStyle(color: Colors.white),),
  );

//</editor-fold>
//<editor-fold desc="Map API Information">
String mapApiUrl = "https://tile.openstreetmap.org/{z}/{x}/{y}.png"; //Change based on url here if default url not good enough https://wiki.openstreetmap.org/wiki/Raster_tile_providers
String userPackageName = "com.lakeridge.app"; //May need changing


//</editor-fold>

//<editor-fold desc="Database Settings">

//Databases are stored in the database path, which can be acquired by getDatabasesPath();
String settingName = "settings.db";
String likedHousesName = "userData/likedHouses.db";
String homesName = "homes.sqlite";
int databaseVersion = 1;

///The creation string fed to Sqlite for creating a database for House Data
String mapDataCreation = "CREATE TABLE MapData("
    "id INTEGER PRIMARY KEY, "
    "name TEXT NOT NULL, "
    "address TEXT NOT NULL, "
    "yearBuilt TEXT NOT NULL, "
    "shortDescription TEXT NOT NULL, "
    "description TEXT NOT NULL, "
    "locationLa REAL NOT NULL, "
    "locationLo REAL NOT NULL, "
    "imageCount INT NOT NULL, "
    "tags TEXT NOT NULL)";

///Takes raw data from a database and converts it into a database for House Data
HouseDatabaseTable parseMapData(List<Map<String, Object?>> unparsed){
  return HouseDatabaseTable([
    for (final {'id': id as int, 'name': name as String, 'address': address as String, 'yearBuilt': yearBuilt as String, 'shortDescription': shortDescription as String, 'description': description as String, 'locationLa': locationLa as double, 'locationLo': locationLo as double, 'imageCount': imageCount as int, 'tags' : tags as String}
    in unparsed)
      MapData(id, name, address, yearBuilt, description, shortDescription, locationLa, locationLo, imageCount, tags)
  ]);
}

///The creation string fed to Sqlite for creating a database for House Database Locations
String houseDbLocationDataCreation = "CREATE TABLE HouseDatabase("
    "id INTEGER PRIMARY KEY, "
    "name TEXT NOT NULL, "
    "description TEXT NOT NULL, "
    "locationLa REAL NOT NULL, "
    "locationLo REAL NOT NULL, "
    "radius REAL NOT NULL, "
    "filepath TEXT NOT NULL, "
    "tags TEXT NOT NULL"
    ")";

///Takes raw data from a database and converts it into a House Database Location Table
HouseDatabaseLocationTable parseHouseDbLocationData(List<Map<String, Object?>> unparsed){
  return HouseDatabaseLocationTable([
    for(final {'id': id as int, 'name': name as String, 'description': description as String, 'locationLa': locationLa as double, 'locationLo': locationLo as double, 'radius' : radius as double, 'filepath' : filepath as String, 'tags' : tags as String}
    in unparsed)
      HouseDatabaseLocation(id, name, description, locationLa, locationLo, radius, filepath, tags)
  ]);
}

///The creation string fed to Sqlite for creating a database for liked houses
String likedHousesDbDataCreation = "CREATE TABLE LikedHousesDatabase("
    "id INTEGER PRIMARY KEY,"
    "databaseId INTEGER NOT NULL,"
    "houseId INTEGER NOT NULL,"
    "likedDate TEXT NOT NULL"
    ")";

///Takes raw data from a database and converts it into a Liked Houses Table
Future<LikedHousesTable> parseLikedHousesData(Future<Database> input) async{
  return LikedHousesTable([
    for(final {'id': id as int, 'databaseId': databaseId as int, 'houseId' : houseId as int, 'likedDate' : likedDate as String} in await (await input).query("LikedHousesDatabase"))
      LikedHouseData(id, databaseId, houseId, inputLikedDate: likedDate)
  ], await input);
}

///A debug function that works sometimes
bool resetAllDatabases = false;
//</editor-fold>
//</editor-fold>