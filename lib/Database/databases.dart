
import 'package:sqflite/sqflite.dart';

var localDb;

void init() async {
  localDb = await openDatabase('Database/localDatabase.sqllite');

  //test
  print(localDb.toString());
}