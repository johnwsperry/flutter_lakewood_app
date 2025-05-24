import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'Widgets/homePage.dart';
import 'Database/databases.dart';
import 'package:testing/Classes/house.dart';
import 'package:latlong2/latlong.dart'; 
import 'package:geocoding/geocoding.dart';

bool debugMode = true; // TURN THIS OFF WHEN WE PUBLISH THE APP

void main() {

  List<LatLng> locations = []; 


  // Remove these locations once we get database w/ locations  
  locations.add(const LatLng(45.413338, -122.667718));
  locations.add(const LatLng(45.412787, -122.669757));
  locations.add(const LatLng(45.412907, -122.670082));
  locations.add(const LatLng(45.413012, -122.670346));
  locations.add(const LatLng(45.413099, -122.670572));

  for (LatLng location in locations) {
    allHouses.add(
      House(
        name: "Home",
        address: "${getPlaceMark(location.latitude, location.longitude)}",
        description: "this is a description of what the house is like",
        image: AssetImage("assets/houseplaceholder1.png"),
        location: location,
      ),
    );
  }

  init();
  runApp(MyApp());
}

Future<String> getPlaceMark(double lat, double long) async {
  String address = "";

  try {
    List<Placemark> placemarks = await placemarkFromCoordinates(lat, long);
    address += placemarks.reversed.last.subLocality ?? '';

    if (placemarks.isNotEmpty) {

      var streets = placemarks.reversed
          .map((placemark) => placemark.street)
          .where((street) => street != null);

      streets = streets.where((street) =>
          street!.toLowerCase() !=
          placemarks.reversed.last.locality!
              .toLowerCase()); 
      streets =
          streets.where((street) => !street!.contains('+')); 

      address += streets.join(', ');

      address += ', ${placemarks.reversed.last.subLocality ?? ''}';
      address += ', ${placemarks.reversed.last.locality ?? ''}';
      address += ', ${placemarks.reversed.last.subAdministrativeArea ?? ''}';
      address += ', ${placemarks.reversed.last.administrativeArea ?? ''}';
      address += ', ${placemarks.reversed.last.postalCode ?? ''}';
      address += ', ${placemarks.reversed.last.country ?? ''}';
    }

    return address;
  } catch (exception) {
    if (debugMode) {
      debugPrint("Encountered problem while running getPlaceMark(): $exception");
    }
    return "";
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(home: HomePage());
  }
}
