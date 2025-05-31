

import 'dart:ui';
import 'package:flutter/material.dart';

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

  late final AssetImage image;

  final String path;

  MapData(this.id, this.name, this.address, this.description, double locationLo, double locationLa, this.path){
    location = LatLng(locationLa, locationLo);
    image = AssetImage(join("assets","houses",path));
  }


  Map<String, Object?> toMap() {
    return {'id' : id, 'name' : name, 'address': address, "description" : description, 'locationLo' : location.longitude, 'locationLa' : location.latitude, 'imagePath' : path};
  }


}