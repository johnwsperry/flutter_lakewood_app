import 'package:latlong2/latlong.dart';

@Deprecated("Use MapData")
class MapPointData {
  //Stores data about a location
  LatLng location;

  String image1FilePath;
  String image2FilePath;

  String locationName;
  String locationDescription;

  int locationTime; //The time in Unix Timestamp. Displayed Somewhere idk.

  DateTime getDateTime(){
    return DateTime.fromMicrosecondsSinceEpoch(locationTime);
  }


  MapPointData(this.location, this.image1FilePath, this.image2FilePath, this.locationDescription, this.locationName, this.locationTime);
}