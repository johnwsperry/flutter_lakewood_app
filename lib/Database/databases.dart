
import 'package:flutter/foundation.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:sqflite_common_ffi_web/sqflite_ffi_web.dart';

var localDb;

void init() async {
  print("Running...");
  //check if ran before
  if(localDb != null) return;
  //initialize sqlite
  sqfliteFfiInit();
  //set database factory based on the application type
  if(kIsWeb){
    databaseFactory = databaseFactoryFfiWeb;
  } else {
    databaseFactory = databaseFactoryFfi;
  }


  localDb = await openDatabase('localDatabase.sqllite');

  //test
  print(localDb.toString());
  print("comp");

  List<Map<String, dynamic>> results = await localDb.query('settings');

  for (var row in results) {
    print(row['column_name']);
  }

}