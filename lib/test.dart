import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:path/path.dart';

import 'package:testing/Database/databases.dart';
import 'package:testing/globleVars.dart' as global_vars;


void testSha() async{
  print("hihihi");

  var data = await rootBundle.load(join('resources','database', 'test1'));
  List<int> bytes = data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
  print(sha256Encrypt(bytes));
  await File(join('resources','database', 'test3')).writeAsBytes(bytes);
}