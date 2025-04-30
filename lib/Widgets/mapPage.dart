
import 'package:flutter_map_cancellable_tile_provider/flutter_map_cancellable_tile_provider.dart';
import 'package:testing/globleVars.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_animations/flutter_map_animations.dart';
import 'package:latlong2/latlong.dart';
import '../Database/databases.dart' as databases;

class MapPage extends StatefulWidget{
  const MapPage({super.key, required this.title});

  final String title;

  @override
  State<MapPage> createState() => MapPageState();
}

class MapPageState extends State<MapPage> with TickerProviderStateMixin{

  late final _animatedMapController = AnimatedMapController(
    vsync: this,
    duration: Duration(milliseconds: focusAnimationDuration),
    curve: Curves.easeOut,
    cancelPreviousAnimations: true,
  );

  LatLng? selectedPin;
  OverlayEntry? entry;

  bool gettingCords = true;

  //Use this for updating center cus cleaner
  void updateCenter(LatLng center, double zoom){
    _animatedMapController.centerOnPoint(center, zoom: zoom);
  }

  //The event that is called when the overlay is opened.
  void onPinClickEvent(LatLng center){

    //Testing event TODO
    print(databases.localDb.toString());
    //Move and update pin.
    if(selectedPin == null) {
      bool isWide = false;
      try {
        isWide = context.size!.width >= context.size!.height;
      } catch(ignored){
        //Ignored
      }
      LatLng newCenter;
      //Change the pin pos if the window size is long.
      if(isWide) {
        newCenter = LatLng(center.latitude, center.longitude + wideCenterOffset * latLongMultiplier);
        print(center);
      } else {
        newCenter = LatLng(center.latitude + longCenterOffset * latLongMultiplier, center.longitude);
        print(center);
      }

      updateCenter(newCenter, focusZoom);
      setState(() {
        selectedPin = center;
      });
      showOverlay();
    }

  }

  //This should be a button event that closes the overlay
  void closePin(){
    //Recenter TODO: Change settings maybe?
    updateCenter(selectedPin!, refocusZoom);

    setState(() {
      selectedPin = null;
    });
    hideOverlay();
  }

  //Overlay Methods
  void showOverlay(){
    final overlay = Overlay.of(context);
    final renderBox = context.findRenderObject() as RenderBox;
    final size = renderBox.size;

    //TODO: The calculations for top and right are off. Should be fixed by the designer or something idk.
    double top;
    double right;

    double widgetHeight = 0.5;
    double widgetWidth = 0.25;

    //Check for tablet or phone.
    if(size.width >= size.height){
      widgetHeight = 0.5;
      widgetWidth = 0.5;
      top = size.height * wideUp - size.height * widgetHeight / 2;
      right = size.width * wideRight - size.width * widgetWidth / 2;
    } else{
      widgetHeight = 0.5;
      widgetWidth = 0.5;
      top = size.height * longUp - size.height * widgetHeight / 2;
      right = size.width * longRight - size.width * widgetWidth / 2;
    }

    entry = OverlayEntry(
      builder: (context) => Positioned(
          height: size.height * widgetHeight, //TODO: DESIGNER
          width: size.width * widgetWidth, //TODO: DESIGNER
          right: right,
          top: top,
          child: aiMapOverlayMenu()
      ),
    );

    overlay.insert(entry!);
  }

  void hideOverlay(){
    final entry = this.entry;
    if(entry != null){
      entry.remove();
      entry.dispose();
    }
  }

  //Ai test TODO
  Widget aiMapOverlayMenu() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            spreadRadius: 2,
            blurRadius: 5,
          ),
        ],
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Placeholder Image
          Container(
            height: 100, // Adjust height as needed
            width: 150, // Adjust width as needed
            color: Colors.grey[300], // Light grey to represent the placeholder
            child: const Center(
              child: Text(
                "Image Placeholder",
                style: TextStyle(
                  color: Colors.black54,
                  fontSize: 14,
                ),
              ),
            ),
          ),
          const SizedBox(height: 16), // Spacing between image and description

          // Description Text
          const Text(
            "This is a simple map overlay for additional details. "
                "The overlay contains an image placeholder, description, and actions for the user.",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 16), // Spacing between description and buttons

          // Close Button
          ElevatedButton(
            onPressed: closePin,
            child: const Text("Close Overlay"),
          ),
        ],
      ),
    );
  }



  //TODO: The menu for overlay widget. I pray for whoever has to design a good menu 💀💀💀
  Widget selectionMenu(){
    return Container(
      color: Colors.greenAccent,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            "test",
            style: TextStyle(
              fontSize: 25,
            ),
          ),
          const Text(
              "lorum ipson",
            style: TextStyle(
              fontSize: 14,
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextButton(onPressed: closePin, child: const Text("close")),
              TextButton(onPressed: test, child: const Text("button2"))
            ],
          ),
        ],
      ),
    );
  }

  //TODO: REMOVE
  void test(){
    print("Tested!");
  }

  //TODO: REMOVE
  void getTappedCords(TapPosition tapPos, LatLng? location){
    print("called");
    print(location);
  }


  @override
  Widget build(BuildContext context) {
    //TODO: REMOVE
    if(gettingCords){
      return testMap(context);
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
                onPinClickEvent(location);
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
              onPinClickEvent(location);
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

  //This map is for getting cords outputed into console. TODO: REMOVE
  Widget testMap(BuildContext context) {
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

    return FlutterMap(options: MapOptions(
      initialCameraFit: const CameraFit.coordinates(coordinates: [ //used https://www.latlong.net/ DON'T USE GOOGLE MAPS!!!
        LatLng(45.418644, -122.679640), //corner 1
        LatLng(45.404050, -122.651485) //corner 2
      ]),
      onTap: getTappedCords,

    ),
      mapController: _animatedMapController.mapController,
      children: children,
    );
  }
}

TileLayer get openStreetMapTileLayer => TileLayer(
    tileProvider: CancellableNetworkTileProvider(),
    urlTemplate: mapApiUrl,
    userAgentPackageName: userPackageName
);
