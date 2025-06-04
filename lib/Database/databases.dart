
import 'dart:convert';
import 'dart:io';
import 'package:crypto/crypto.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:sqflite_common_ffi_web/sqflite_ffi_web.dart';
import 'package:testing/Classes/mapData.dart';
import 'package:testing/globleVars.dart' as global_vars;
import 'package:sqflite/sqflite.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

import 'package:path/path.dart';


class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();
  static Database? _database;

  DatabaseHelper._privateConstructor();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    if (kIsWeb) {
      databaseFactory = databaseFactoryFfiWeb;
    } else {
      databaseFactory = databaseFactoryFfi;
    }

    //cloneHouses();

    var path = join(await getDatabasesPath(), global_vars.homesName);

    return await openDatabase(
      path,
      onCreate: (db, version) {
        return db.execute(
          "CREATE TABLE MapData(id INTEGER PRIMARY KEY, name TEXT NOT NULL, address TEXT NOT NULL, description TEXT NOT NULL, locationLa REAL NOT NULL, locationLo REAL NOT NULL, imageCount INT NOT NULL, tags TEXT NOT NULL)",
        );
      },
      version: global_vars.homeDatabaseVersion,
    );
  }
}


Future<List<MapData>> houses() async {
  // Get a reference to the database.

  var db = await DatabaseHelper.instance.database;

  //query the houses
  final List<Map<String, Object?>> houses = await db.query('MapData');


  // Convert to list
  return [
    for (final {'id': id as int, 'name': name as String, 'address': address as String, 'description': description as String, 'locationLa': locationLa as double, 'locationLo': locationLo as double, 'imageCount': imageCount as int, 'tags' : tags as String}
    in houses)
      MapData(id, name, address, description, locationLa, locationLo, imageCount, tags),
  ];
}

void cloneHouses() async {
  String databasePath = join(await getDatabasesPath(), global_vars.homesName);

  var data = await rootBundle.load("resources/databases/${global_vars.homesName}");
  List<int> bytes = data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);

  //Check if exist
  if(FileSystemEntity.typeSync(databasePath) != FileSystemEntityType.notFound){
    var oldData = File(databasePath);
    var sha256old = sha256Encrypt(await getBytesFromFile(oldData));
    var sha256new = sha256Encrypt(bytes);
    if(sha256new == sha256old) return;
  }


  //Save File
  await File(databasePath).writeAsBytes(bytes);

}

Digest sha256Encrypt(List<int> bytes){
  return sha256.convert(bytes);
}

Future<List<int>> getBytesFromFile(File file) async{
  var bytes = await file.readAsBytes();
  var byteData = ByteData.view(bytes.buffer);
  Uint8List byteDataBytes = byteData.buffer.asUint8List(byteData.offsetInBytes, byteData.lengthInBytes);
  return byteDataBytes;
}

void test(){

}

