import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';

import '../Enums/sortTag.dart';

class MapData {
  final int id;

  final String name;
  final String address;
  final String yearBuilt;
  final String shortDescription;
  final String description;
  late final LatLng location;

  late final List<AssetImage> images;

  final int imageCount;
  late final List<SortTag> tags;

  MapData(
    this.id,
    this.name,
    this.address,
    this.yearBuilt,
    this.shortDescription,
    this.description,
    double locationLa,
    double locationLo,
    this.imageCount,
    String inputTags,
  ) {
    location = LatLng(locationLa, locationLo);
    images = [];
    for (int i = 0; i < imageCount; i++) {
      images.add(AssetImage("assets/houses/$id-$i.png"));
    }
    tags = stringToTags(inputTags);
  }

  Map<String, Object?> toMap() {
    return {
      'id': id,
      'name': name,
      'address': address,
      'yearBuilt': yearBuilt,
      'shortDescription': shortDescription,
      "description": description,
      'locationLa': location.latitude,
      'locationLo': location.longitude,
      'imageCount': imageCount,
      'tags': tagsToString(tags),
    };
  }

  List<SortTag> stringToTags(String input) {
    List<String> numbers = ["1", "2", "3", "4", "5", "6", "7", "8", "9", "0"];
    //String must be formated as #,#,#...
    List<SortTag> returnTags = [];
    String currentNumber = "";
    for (int i = 0; i < input.length; i++) {
      //Check every char
      String currentChar = input[i];
      if (currentChar == "," && currentNumber.isNotEmpty) {
        //check for commas
        int number = int.parse(currentNumber);
        currentNumber = "";
        if (number < 0 || number >= SortTag.values.length) continue;
        returnTags.add(SortTag.values[number]);
      }
      //Check if a valid number
      if (!numbers.contains(currentChar)) continue;
      currentNumber += currentChar;
    }

    if (currentNumber.isNotEmpty) {
      int number = int.parse(currentNumber);
      currentNumber = "";
      if (number < 0 || number >= SortTag.values.length) return returnTags;
      returnTags.add(SortTag.values[number]);
    }

    return returnTags;
  }

  String tagsToString(List<SortTag> tags) {
    String returnString = "";
    for (SortTag tag in tags) {
      //Convert tags
      returnString += "${tag.index}, ";
    }
    return returnString;
  }
}
