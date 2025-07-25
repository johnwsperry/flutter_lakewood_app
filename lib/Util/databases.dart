
import 'dart:collection';
import 'dart:io';

import 'package:crypto/crypto.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:path/path.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:sqflite_common_ffi_web/sqflite_ffi_web.dart';
import 'package:testing/globalVars.dart' as global_vars;

import '../Classes/databaseTables.dart';
import '../Classes/houseDatabaseLocation.dart';


class Databases {

  //Create and access databases

  //Variables

  //Public
  static HashMap<String, HouseDatabaseTable> cachedData = HashMap();

  static HashMap<String, Database> openedDatabases = HashMap();

  //Private
  static bool _factorySet = false;

  static HouseDatabaseLocationTable? _houseDatabases;

  //Get Databases
  static Future<List<Database>> getAllHouseDatabasesFromName(String name) async {
    List<Database> returnList = [];
    Iterable<HouseDatabaseLocation>? matchingData = (await queryDatabaseLocationTable()).getAllDataByName(name);
    if(matchingData == null || matchingData.isEmpty) return returnList;
    for(HouseDatabaseLocation filePath in matchingData){
      returnList.add(await getHouseDatabase(filePath.filepath));
    }

    return returnList;
  }

  ///Gets the house database from an id.
  static Future<Database> getHouseDatabaseFromId(int id) async {
    HouseDatabaseLocationTable houseDatabases = await queryDatabaseLocationTable();
    //Get the database
    if(houseDatabases.data.length >= id) {
      return await getHouseDatabase(houseDatabases.getDataByID(0).filepath);
    }

    return await getHouseDatabase(houseDatabases.getDataByID(id).filepath);
  }

  ///Gets the house database using the path
  static Future<Database> getHouseDatabase(String path) async {
    setFactory();
    //Open the database
    Database database = await _openHouseDatabase("homeData/$path");
    return database;
  }

  ///Gets the liked houses database
  static Future<Database> getLikedHousesDatabase() async{
    return _openDatabase(global_vars.likedHousesName, global_vars.likedHousesDbDataCreation, updateFromResources: false);
  }


  //Query Data
  static Future<HouseDatabaseLocationTable> queryDatabaseLocationTable() async {
    //Check if database has been cached
    if(_houseDatabases == null){
      //Open the houses database
      Database housesDatabase = await _openDatabase(global_vars.homesName, global_vars.houseDbLocationDataCreation);
      //Save it and close it
      final List<Map<String, Object?>> databases = await housesDatabase.query('HouseDatabase');

      //Parse
      _houseDatabases = global_vars.parseHouseDbLocationData(databases);

      housesDatabase.close();
    }

    return _houseDatabases!;
  }

  /// Query the HouseDataTable through a path. Paths can be found in https://docs.google.com/spreadsheets/d/1qSCx8z4FAC2crFKanxImvWnods6QUimWa4G1mcOSMc4/edit?gid=503268534#gid=503268534
  static Future<HouseDatabaseTable> queryHousesByPath(String path) async{
    return queryHouses(await getHouseDatabase(path));
  }

  /// Query the HouseDataTable through an id. IDs can be found in https://docs.google.com/spreadsheets/d/1qSCx8z4FAC2crFKanxImvWnods6QUimWa4G1mcOSMc4/edit?gid=503268534#gid=503268534
  static Future<HouseDatabaseTable> queryHousesById(int id) async {
    return await queryHouses(await getHouseDatabaseFromId(id));
  }

  ///Query the HouseDataTable using a database. Use other functions in the Databases class, such as getHouseDatabase(String path), to get a database to parse through here.
  static Future<HouseDatabaseTable> queryHouses(Database db) async {
    //Check if data is cached
    if(cachedData.containsKey(db.path)){
      return cachedData[db.path]!;
    }
    //If data is not cached, cache it and open it
    //query the houses
    final List<Map<String, Object?>> houses = await db.query('MapData');

    var dataTable = global_vars.parseMapData(houses);
    //Cache and return
    cachedData[db.path] = dataTable;
    return dataTable;
  }

  //Private Functions
  static Future<Database> _openHouseDatabase(String path) async {

    return _openDatabase(path, global_vars.mapDataCreation);
  }

  //TODO: This causes a race condition. Look into it.
  static Future<Database> _openDatabase(String path, String? createFunction, {bool updateFromResources = true}) async {
    //Check if cached
    if(openedDatabases.containsKey(path)){
      return openedDatabases[path]!;
    }
    //Set databaseFactory
    setFactory();

    //Check if the database needs to be updated...
    if(updateFromResources) {
      await cloneHouse(path);
    }


    //Return the database
    String createFunctionReal;

    if(createFunction == null){
      createFunctionReal = "";
    } else{
      createFunctionReal = createFunction;
    }

    //Cache the database and return it

    var database = await openDatabase(
        join(await getDatabasesPath(), path),
        onCreate: (db, version) {
          return db.execute(createFunctionReal);
        },
        version: global_vars.databaseVersion
    );
    openedDatabases[path] = database;

    return database;
  }



  //Util Functions
  static void setFactory(){
    //Tries to set a factory
    if(!_factorySet){
      if (kIsWeb) {
        databaseFactory = databaseFactoryFfiWeb;
      } else if (Platform.isMacOS || Platform.isWindows){
        databaseFactory = databaseFactoryFfi;
      }
      //Don't set for mobile.
      _factorySet = true;
    }
  }

  static Future<void> cloneHouse(String path) async {
    setFactory();

    //Create the paths
    String databasePath = join(await getDatabasesPath(), path);

    bool fileExists = FileSystemEntity.typeSync(databasePath) != FileSystemEntityType.notFound;

    //Check for testing
    if(global_vars.resetAllDatabases){
      //when resetting all databases, have the program delete the files than exit. This will create new, empty databases.
      if(fileExists){
        File fileToDelete = File(databasePath);
        await fileToDelete.delete();
      }
      return;
    }

    var data = await rootBundle.load("resources/databases/$path");
    List<int> bytes = data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);

    //Check if exist
    if(fileExists){
      var oldData = File(databasePath);
      var sha256old = sha256Encrypt(await getBytesFromFile(oldData));
      var sha256new = sha256Encrypt(bytes);
      if(sha256new == sha256old) return;
    }

    //Create dirs
    await File(databasePath).create(recursive: true);
    //Save File
    await File(databasePath).writeAsBytes(bytes);

  }

  static Digest sha256Encrypt(List<int> bytes){
    return sha256.convert(bytes);
  }

  static Future<List<int>> getBytesFromFile(File file) async{
    var bytes = await file.readAsBytes();
    var byteData = ByteData.view(bytes.buffer);
    Uint8List byteDataBytes = byteData.buffer.asUint8List(byteData.offsetInBytes, byteData.lengthInBytes);
    return byteDataBytes;
  }
}

