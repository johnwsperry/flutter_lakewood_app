
import 'dart:collection';
import 'dart:io';

import 'package:crypto/crypto.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:path/path.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:sqflite_common_ffi_web/sqflite_ffi_web.dart';
import 'package:testing/Classes/house.dart';
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

  static Future<Database> getHouseDatabaseFromId(int id) async {
    HouseDatabaseLocationTable houseDatabases = await queryDatabaseLocationTable();
    //Get the database
    if(houseDatabases.data.length >= id) {
      return await getHouseDatabase(houseDatabases.getDataByID(0).filepath);
    }

    return await getHouseDatabase(houseDatabases.getDataByID(id).filepath);
  }

  static Future<Database> getHouseDatabase(String path) async {
    setFactory();
    //Check if opened
    if(openedDatabases.containsKey(join(await getDatabasesPath(), path))){
      return openedDatabases[join(await getDatabasesPath(), path)]!;
    }

    //If not opened, open it
    Database database = await _openHouseDatabase("homeData/$path");
    openedDatabases[join(await getDatabasesPath(), path)] = database;

    return database;
  }


  //Query Data
  static Future<HouseDatabaseLocationTable> queryDatabaseLocationTable() async {
    //Check if database has been cached
    if(_houseDatabases == null){
      String createFunction =
          "CREATE TABLE HouseDatabase(id INTEGER PRIMARY KEY, name TEXT NOT NULL, description TEXT NOT NULL, locationLa REAL NOT NULL, locationLo REAL NOT NULL, radius REAL NOT NULL, filepath TEXT NOT NULL, tags TEXT NOT NULL)";

      //Open the houses database
      cloneHouse(global_vars.homesName);
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
    setFactory();

    cloneHouse(path);

    return _openDatabase(path, global_vars.mapDataCreation);
  }

  static Future<Database> _openDatabase(String path, String? createFunction) async {
    //Set databaseFactory
    setFactory();

    cloneHouse(path);


    //Return the database
    String createFunctionReal;

    if(createFunction == null){
      createFunctionReal = "";
    } else{
      createFunctionReal = createFunction;
    }

    return await openDatabase(
        join(await getDatabasesPath(), path),
        onCreate: (db, version) {
          return db.execute(createFunctionReal);
        },
        version: global_vars.databaseVersion
    );
  }


  //Util Functions
  static void setFactory(){
    //Tries to set a factory
    if(!_factorySet){
      if (kIsWeb) {
        databaseFactory = databaseFactoryFfiWeb;
      } else {
        databaseFactory = databaseFactoryFfi;
      }
      _factorySet = true;
    }
  }

  static void cloneHouse(String path) async {
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

