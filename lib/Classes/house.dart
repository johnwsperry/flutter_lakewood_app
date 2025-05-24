import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';

class House {

  // eventually replace image with a List<AssetImage> of images if we get more

  final String name;
  final String address;
  final String description;
  final AssetImage image;
  final LatLng location;

  const House({
    required this.name,
    required this.address,
    required this.description,
    required this.image,
    LatLng? location
  }) : location = location ?? const LatLng(0, 0);
}

List<House> likedHomes = [];

List<House> allHouses = [];