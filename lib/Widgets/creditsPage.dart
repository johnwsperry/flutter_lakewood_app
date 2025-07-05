
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CreditsPage{

  String imageFolder = "resources/assets/credits";

  Widget creditsPage = Scaffold(
      body: Center(
        child: Text("This is the map page!"),
      )
  );


  //Data
  List<String> names = [
    "Alvin Wang",
    "CJ Hanson",
  ];
  List<String> descriptions = [
    "Placeholder",
    "High school student, app contributor"
  ];
  List<String> imagePaths = [
    "AlvinWang-Credits-0",
    "CJHanson-Credits-0"
  ];

}