
import 'dart:io';
import 'dart:nativewrappers/_internal/vm/lib/typed_data_patch.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:testing/globleVars.dart' as global_vars;
import 'package:sqflite/sqflite.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

import 'package:flutter/widgets.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';


void main() async {
  //Insure this is init
  WidgetsFlutterBinding.ensureInitialized();
  // Get the database
  final houseDb = openDatabase(
    //Create the path by joining databases path and the normal path.
    join(await getDatabasesPath(), global_vars.homesName),
  );

}

void cloneHouses() async {
  String databasePath = join(await getDatabasesPath(), global_vars.homesName);

  //Check if exist
  if(FileSystemEntity.typeSync(databasePath) != FileSystemEntityType.notFound) return;

  //clone the database into resources
  var data = await rootBundle.load(join('resources','database', global_vars.homesName));
  List<int> bytes = data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);

  //Save File
  await File(databasePath).writeAsBytes(bytes);

}

