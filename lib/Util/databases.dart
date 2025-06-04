
import 'dart:collection';
import 'dart:io';
import 'package:crypto/crypto.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:sqflite_common_ffi_web/sqflite_ffi_web.dart';
import 'package:testing/Classes/mapData.dart';
import 'package:testing/globleVars.dart' as global_vars;
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:path/path.dart';
import '../Classes/houseDatabaseLocation.dart';
import '../Classes/databaseTables.dart';


class DatabaseSingleton {

  //Create and access databases

  //Variables
  static HouseDatabaseLocationTable? _houseDatabases;

  static HashMap<String, HouseDatabaseTable> cachedData = HashMap();

  static HashMap<String, Database> openedDatabases = HashMap();

  static bool factorySet = false;
  
  static Future<List<Database>> getAllDatabasesFromName(String name) async {
    List<Database> returnList = [];
    Iterable<HouseDatabaseLocation>? matchingData = (await getHouseDatabaseLocationTable()).getAllDataByName(name);
    if(matchingData == null || matchingData.isEmpty) return returnList;
    for(HouseDatabaseLocation filePath in matchingData){
      returnList.add(await getDatabase(filePath.filepath));
    }
    
    return returnList;
  }

  static Future<Database> getDatabaseFromId(int id) async {
    HouseDatabaseLocationTable houseDatabases = await getHouseDatabaseLocationTable();
    //Get the database
    if(houseDatabases.data.length >= id) {
      return await getDatabase(houseDatabases.getDataByID(0).filepath);
    }

    return await getDatabase(houseDatabases.getDataByID(id).filepath);
  }

  static Future<Database> getDatabase(String path) async {
    //Check if opened
    if(openedDatabases.containsKey(join(await getDatabasesPath(), path))){
      return openedDatabases[join(await getDatabasesPath(), path)]!;
    }

    //If not opened, open it
    Database database = await _openHouseDatabase("homeData/$path");
    openedDatabases[join(await getDatabasesPath(), path)] = database;

    return database;
  }

  static Future<Database> _openHouseDatabase(String path) async {
    setFactory();

    cloneHouse(path);

    String createFunction =
        "CREATE TABLE MapData(id INTEGER PRIMARY KEY, name TEXT NOT NULL, address TEXT NOT NULL, yearBuilt TEXT NOT NULL, shortDescription TEXT NOT NULL, description TEXT NOT NULL, locationLa REAL NOT NULL, locationLo REAL NOT NULL, imageCount INT NOT NULL, tags TEXT NOT NULL)";

    return _openDatabase(path, createFunction);
  }

  static Future<Database> _openDatabase(String path, String? createFunction) async {
    //Set databaseFactory
    setFactory();


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
        version: global_vars.homeDatabaseVersion
    );
  }

  static Future<HouseDatabaseTable> queryHousesById(int id) async {
    print((await queryHouses(await getDatabaseFromId(id))));
    print((await getDatabaseFromId(id)).path);
    return await queryHouses(await getDatabaseFromId(id));
  }

  static Future<HouseDatabaseTable> queryHouses(Database db) async {
    //Check if data is cached
    if(cachedData.containsKey(db.path)){
      return cachedData[db.path]!;
    }
    //If data is not cached, cache it and open it
    //query the houses
    final List<Map<String, Object?>> houses = await db.query('MapData');


    //Parse Information
    List<MapData> data = [
      for (final {'id': id as int, 'name': name as String, 'address': address as String, 'yearBuilt': yearBuilt as String, 'shortDescription': shortDescription as String, 'description': description as String, 'locationLa': locationLa as double, 'locationLo': locationLo as double, 'imageCount': imageCount as int, 'tags' : tags as String}
      in houses)
        MapData(id, name, address, yearBuilt, description, shortDescription, locationLa, locationLo, imageCount, tags)
    ];

    var dataTable = HouseDatabaseTable(data);
    //Cache and return
    cachedData[db.path] = dataTable;
    return dataTable;
  }

  //Util Functions
  static Future<HouseDatabaseLocationTable> getHouseDatabaseLocationTable() async {
    //Check if database has been cached
    if(_houseDatabases == null){
      String createFunction =
          "CREATE TABLE HouseDatabase(id INTEGER PRIMARY KEY, name TEXT NOT NULL, description TEXT NOT NULL, locationLa REAL NOT NULL, locationLo REAL NOT NULL, radius REAL NOT NULL, filepath TEXT NOT NULL, tags TEXT NOT NULL)";

      //Open the houses database
      cloneHouse(global_vars.homesName);
      Database housesDatabase = await _openDatabase(global_vars.homesName, createFunction);
      //Save it and close it
      final List<Map<String, Object?>> databases = await housesDatabase.query('HouseDatabase');

      //Parse
      _houseDatabases = HouseDatabaseLocationTable([
        for(final {'id': id as int, 'name': name as String, 'description': description as String, 'locationLa': locationLa as double, 'locationLo': locationLo as double, 'radius' : radius as double, 'filepath' : filepath as String, 'tags' : tags as String}
        in databases)
          HouseDatabaseLocation(id, name, description, locationLa, locationLo, radius, filepath, tags)
      ]);

      housesDatabase.close();
    }

    return _houseDatabases!;
  }
  
  static void setFactory(){
    //Tries to set a factory
    if(!factorySet){
      if (kIsWeb) {
        databaseFactory = databaseFactoryFfiWeb;
      } else {
        databaseFactory = databaseFactoryFfi;
      }
      factorySet = true;
    }
  }

  static void cloneHouse(String path) async {
    setFactory();
    //Create the paths
    String databasePath = join(await getDatabasesPath(), path);

    var data = await rootBundle.load("resources/databases/$path");
    List<int> bytes = data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);

    //Check if exist
    if(FileSystemEntity.typeSync(databasePath) != FileSystemEntityType.notFound){
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

