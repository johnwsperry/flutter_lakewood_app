import 'dart:developer';

import 'package:flutter_lakewood_app/globleVars.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_lakewood_app/main.dart';
import 'package:flutter_map_animations/flutter_map_animations.dart';
import 'package:latlong2/latlong.dart';
import 'package:flutter_lakewood_app/Classes/mappointdata.dart';

class Homepage extends StatefulWidget{
  const Homepage({super.key, required this.title});

  final String title;

  @override
  State<Homepage> createState() => HomepageState();
}

class HomepageState extends State<Homepage> with TickerProviderStateMixin{

  late final _animatedMapController = AnimatedMapController(
    vsync: this,
    duration: Duration(milliseconds: focusAnimationDuration),
    curve: Curves.easeOut,
    cancelPreviousAnimations: true,
  );

  LatLng? selectedPin;

  void updateCenter(LatLng center){
    _animatedMapController.centerOnPoint(center, zoom: focusZoom);
  }

  void onPinClickEvent(BuildContext context, LatLng center){
    if(selectedPin == null) {
      updateCenter(center);
      setState(() {
        selectedPin = center;
      });
    }
  }


  @override
  Widget build(BuildContext context) {
    final windowSize = MediaQuery.of(context).size;
    if(windowSize.height > windowSize.width){
      //Phone mode
      return Scaffold(
          appBar: AppBar(
            title: const Text(
                'House Dating Sim UwU' //TODO: Name Here! Change for production.
            ),
          ),
          body: map(context),
      );
    }
    return Scaffold(
      appBar: AppBar(
        title: const Text(
            'House Dating Sim UwU' //TODO: Name Here! Change for production.
        ),
      ),
      body: map(context),
    );
  }

  MarkerLayer getLayer(BuildContext context){
    List<Marker> markers = [];
    List<LatLng> locations = [];
    
    //<Temp>
    locations.add(const LatLng(45.413338, -122.667718));
    locations.add(const LatLng(45.412787, -122.669757));
    locations.add(const LatLng(45.412907, -122.670082));
    locations.add(const LatLng(45.413012, -122.670346));
    locations.add(const LatLng(45.413099, -122.670572));
    //</Temp>

    for (var location in locations) {
      markers.add(Marker(
          point: location,
          width: mapIconWidth,
          height: mapIconHeight,
          alignment: Alignment.topCenter,
          child:GestureDetector(
              onTap: () {
                onPinClickEvent(context, location);
              },
              child: Icon(
                  Icons.location_pin,
                  size: mapIconSize,
                  color: Colors.red)
          )
      ));
    }

    return MarkerLayer(markers: markers);
  }

  MarkerLayer getSinglePin(BuildContext context, LatLng location){
    return MarkerLayer(markers: [Marker(
        point: location,
        width: mapIconWidth,
        height: mapIconHeight,
        alignment: Alignment.topCenter,
        child:GestureDetector(
            onTap: () {
              onPinClickEvent(context, location);
            },
            child: Icon(
                Icons.location_pin,
                size: mapIconSize,
                color: Colors.red)
        )
    )]);
  }

  Widget map(BuildContext context) {
    MarkerLayer layer;
    //Get the pins
    if(selectedPin == null){
      layer = getLayer(context);
    } else{
      layer = getSinglePin(context, selectedPin!);
    }
    //get children
    List<Widget> children = [];
    children.add(openStreetMapTileLayer);
    children.add(layer);

    return FlutterMap(options: const MapOptions(
      initialCameraFit: CameraFit.coordinates(coordinates: [ //used https://www.latlong.net/ DON'T USE GOOGLE MAPS!!!
        LatLng(45.418644, -122.679640), //corner 1
        LatLng(45.404050, -122.651485) //corner 2
      ]),
      interactionOptions:
      InteractionOptions(flags: ~InteractiveFlag.pinchZoom),

    ),
      mapController: _animatedMapController.mapController,
      children: children,
    );
  }
}

TileLayer get openStreetMapTileLayer => TileLayer(
    urlTemplate: mapApiUrl,
    userAgentPackageName: userPackageName
);
