

import 'dart:ui';
import 'package:flutter/material.dart';
import '../Enums/sortTags.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:latlong2/latlong.dart';
import 'package:path/path.dart';

class MapData{

  final int id;

  final String name;
  final String address;
  final String description;
  late final LatLng location;

  late final List<AssetImage> images;

  final int count;
  late final List<SortTags> tags;

  MapData(this.id, this.name, this.address, this.description, double locationLa, double locationLo, this.count, String inputTags){
    location = LatLng(locationLa, locationLo);
    images = [];
    for(int i = 0; i < count; i++){
      images.add(AssetImage("assets/houses/$id-$i.png"));
    }
    tags = stringToTags(inputTags);
  }


  Map<String, Object?> toMap() {
    return {'id' : id, 'name' : name, 'address': address, "description" : description, 'locationLa' : location.latitude, 'locationLo' : location.longitude, 'imageCount' : count, 'tags' : tagsToString(tags)};
  }

  List<SortTags> stringToTags(String input){
    List<String> numbers = ["1", "2", "3", "4", "5", "6", "7", "8", "9", "0"];
    //String must be formated as #,#,#...
    List<SortTags> returnTags = [];
    String currentNumber = "";
    for(int i = 0; i < input.length; i++){
      //Check every char
      String currentChar = input[i];
      if(currentChar == "," && currentNumber.isNotEmpty){
        //check for commas
        int number = int.parse(currentNumber);
        currentNumber = "";
        if(number < 0 || number >= SortTags.values.length) continue;
        returnTags.add(SortTags.values[number]);
      }
      //Check if a valid number
      if(!numbers.contains(currentChar)) continue;
      currentNumber += currentChar;
    }

    if(currentNumber.isNotEmpty){
      int number = int.parse(currentNumber);
      currentNumber = "";
      if(number < 0 || number >= SortTags.values.length) return returnTags;
      returnTags.add(SortTags.values[number]);
    }
    
    return returnTags;
  }

  String tagsToString(List<SortTags> tags){
    String returnString = "";
    for(SortTags tag in tags){
      //Convert tags
      returnString += "${tag.index}, ";
    }
    return returnString;
  }


}