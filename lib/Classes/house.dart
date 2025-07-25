import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:latlong2/latlong.dart';
import 'package:testing/Classes/mapData.dart';

@Deprecated("Use mapData! Will be removed soon!")
class House {

  // eventually replace image with a List<AssetImage> of images if we get more

  final int id;
  final String name;
  final String address;
  final String description;
  final AssetImage image;
  final LatLng location;
  final int yearBuilt;
  final String type;

  const House({
    this.id = 0,
    required this.name,
    required this.address,
    required this.description,
    required this.image,
    this.location = const LatLng(0, 0),
    this.yearBuilt = 1990,
    this.type = "House",
  });

  String getCleanAddress() {
    return address.split(",")[0];
  }

}
@Deprecated("Use mapData! Will be removed soon!")
List<MapData> likedHomes = [];

@Deprecated("Use mapData! Will be removed soon!")
List<MapData> allHomes = [];

@Deprecated("Use mapData! Will be removed soon!")
int findHouse(LatLng? loc) {
  if (loc != null) {
    for (int index = 0; index < allHomes.length; index++) {
      if (allHomes[index].location == loc) {
        return index;
      }
    }
  }
  return -1;
}

@Deprecated("Use mapData! Will be removed soon!")
Future<String> getAddress(double lat, double long, {bool clean = false}) async {
  List<Placemark> placemarks = await placemarkFromCoordinates(lat, long);
  return "${placemarks[0].street}, ${placemarks[0].locality}";

  /*
    Here are the options for an example location coord (45.413338, -122.667718):
    Each can be accessed through the object (ex: placemarkObj.postalCode would get you 97034). Docs: https://pub.dev/documentation/geocoding_platform_interface/latest/geocoding_platform_interface/Placemark-class.html

        Name: 323 Middlecrest Rd,
        Street: 323 Middlecrest Rd,
        ISO Country Code: US,
        Country: United States,
        Postal code: 97034,
        Administrative area: OR,
        Subadministrative area: Clackamas County,
        Locality: Lake Oswego,
        Sublocality: Lakewood,
        Thoroughfare: Middlecrest Rd,
        Subthoroughfare: 323
  */
}