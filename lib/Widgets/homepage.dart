import 'dart:ffi';
import 'package:flutter_lakewood_app/globleVars.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_lakewood_app/main.dart';
import 'package:latlong2/latlong.dart';
import 'package:flutter_lakewood_app/Classes/mappointdata.dart';

class Homepage extends StatefulWidget{
  const Homepage({super.key, required this.title});

  final String title;

  @override
  State<Homepage> createState() => HomepageState();
}

class HomepageState extends State<Homepage>{

  MapPointData? currentData;

  void updateCenter(LatLng center){
    controller.moveAndRotate(center, focusZoom, 0);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
            'House Dating Sim UwU' //TODO: Name Here! Change for production.
        ),
      ),
      body: map(),
    );
  }

  Widget map() {
    List<Widget> children = [];
    children.add(openStreetMapTileLayer);
    children.add(hotSingleHouses);

    if(currentData != null){
      //Add the basic overview screen.

    }

    return FlutterMap(options: const MapOptions(
      initialCameraFit: CameraFit.coordinates(coordinates: [ //used https://www.latlong.net/ DON'T USE GOOGLE MAPS!!!
        LatLng(45.418644, -122.679640), //corner 1
        LatLng(45.404050, -122.651485) //corner 2
      ]),
      interactionOptions:
      InteractionOptions(flags: ~InteractiveFlag.pinchZoom),

    ),
      mapController: controller,
      children: [
        openStreetMapTileLayer,
        hotSingleHouses
      ],
    );
  }
}

TileLayer get openStreetMapTileLayer => TileLayer(
    urlTemplate: mapApiUrl,
    userAgentPackageName: userPackageName
);

MarkerLayer get hotSingleHouses => MarkerLayer(markers: [
  //Use code to parse a database into markers.
  Marker(
      point: const LatLng(45.413338, -122.667718),
      width: mapIconWidth,
      height: mapIconHeight,
      alignment: Alignment.centerLeft,
      child:GestureDetector(
          onTap: () {
            //Create a webpage using args specified in the database.
          },
          child: Icon(
              Icons.location_pin,
              size: mapIconSize,
              color: Colors.red)
      )
  )
]);

MapController get controller => MapController();