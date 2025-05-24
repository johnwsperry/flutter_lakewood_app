
import 'package:flutter/cupertino.dart';
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
  final database = openDatabase(
    //Create the path by joining databases path and the normal path.
    join(await getDatabasesPath(), global_vars.settingName),
  );
}

