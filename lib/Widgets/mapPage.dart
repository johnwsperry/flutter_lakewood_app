
import 'package:testing/globleVars.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_animations/flutter_map_animations.dart';
import 'package:latlong2/latlong.dart';

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
  OverlayEntry? entry;

  bool gettingCords = true;

  //Use this for updating center cus cleaner
  void updateCenter(LatLng center, double zoom){
    _animatedMapController.centerOnPoint(center, zoom: zoom);
  }

  //The event that is called when the overlay is opened.
  void onPinClickEvent(LatLng center){

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

    //Check for tablet or phone.
    if(size.width >= size.height){
      top = size.height * wideUp;
      right = size.width * wideRight;
    } else{
      top = size.height * longUp;
      right = size.width * longRight;
    }

    entry = OverlayEntry(
      builder: (context) => Positioned(
          height: size.height * 0.25, //TODO: DESIGNER
          width: size.width * 0.25, //TODO: DESIGNER
          right: right,
          top: top,
          child: selectionMenu()
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
    urlTemplate: mapApiUrl,
    userAgentPackageName: userPackageName
);
