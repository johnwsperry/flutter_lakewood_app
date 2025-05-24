

import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:latlong2/latlong.dart';

class MapData{

  final int id;

  final String name;
  final String address;
  final String description;
  final LatLng location;

  final Image image;

  MapData(this.id, this.name, this.address, this.description, this.location, this.image);
}