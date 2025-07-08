import 'package:flutter_map_cancellable_tile_provider/flutter_map_cancellable_tile_provider.dart';
import 'package:testing/Classes/databaseTables.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_animations/flutter_map_animations.dart';
import 'package:latlong2/latlong.dart';
import 'package:testing/Classes/mapData.dart';
import '../globalVars.dart';
import 'housePage.dart';
import '../Util/databases.dart' as databases;
import '../main.dart' as main;

/// This is the map page, responsible for creating and dealing with the map.
class MapPage extends StatefulWidget {
  const MapPage({super.key, required this.title});

  final String title;

  @override
  State<MapPage> createState() => MapPageState();
}

class MapPageState extends State<MapPage> with TickerProviderStateMixin {

  late final _animatedMapController = AnimatedMapController(
    vsync: this,
    duration: Duration(milliseconds: focusAnimationDuration),
    curve: Curves.easeOut,
    cancelPreviousAnimations: true,
  );

  //This is the map
  late Future<MarkerLayer> _mapData;

  ///The current selected pin
  MapData? selectedPin;
  OverlayEntry? entry;

  ///Grabs the data from database. Call on init
  Future<MarkerLayer> _getMarkerDataFromDatabase() async {
    List<Marker> markers = [];

    //Compile the data using the table in databases.
    for (MapData house in (await databases.Databases.queryHousesByPath(
        "lakewood-lakeoswego-oregon-unitedstates-earth-milkyway.sqlite"))
        .data) {
      markers.add(
        Marker(
          point: house.location,
          width: mapIconWidth,
          height: mapIconHeight,
          alignment: Alignment.topCenter,
          child: GestureDetector(
            onTap: () {
              onPinClickEvent(house);
            },
            child: Icon(
              Icons.location_pin,
              size: mapIconSize,
              color: Colors.red,
            ),
          ),
        ),
      );
    }
    //Return the compiled item
    return MarkerLayer(markers: markers);
  }
  
  MarkerLayer getMarkerLayerFromDataTable(HouseDatabaseTable table){
    List<Marker> markers = [];

    //Compile the data using the table in databases.
    for (MapData house in table.data) {
      markers.add(
      Marker(
        point: house.location,
        width: mapIconWidth,
        height: mapIconHeight,
        alignment: Alignment.topCenter,
        child: GestureDetector(
          onTap: () {
          onPinClickEvent(house);
      },
      child: Icon(
        Icons.location_pin,
        size: mapIconSize,
        color: Colors.red,
        ),
          ),
      ),
      );
    }
    //Return the compiled item
    return MarkerLayer(markers: markers);
  }

  //Use this for updating center cus cleaner
  void updateCenter(LatLng center, double zoom) {
    _animatedMapController.centerOnPoint(center, zoom: zoom);
  }

  //The event that is called when the overlay is opened.
  void onPinClickEvent(MapData data) {
    //Move and update pin.
    if (selectedPin == null) {
      bool isWide = false;
      try {
        isWide = context.size!.width >= context.size!.height;
      } catch (ignored) {
        //Ignored
      }
      LatLng newCenter;
      //Change the pin pos if the window size is long.
      if (isWide) {
        newCenter = LatLng(
          data.location.latitude,
          data.location.longitude + wideCenterOffset * latLongMultiplier,
        );
      } else {
        newCenter = LatLng(
          data.location.latitude + longCenterOffset * latLongMultiplier,
          data.location.longitude,
        );
      }

      updateCenter(newCenter, focusZoom);
      setState(() {
        selectedPin = data;
      });
      showOverlay();
    }
  }

  //This should be a button event that closes the overlay
  void closePin() {
    //Recenter TODO: Change settings maybe?
    updateCenter(selectedPin!.location, refocusZoom);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // Don't remove this ^^ ; it's needed for closing the pin while another page is being built
      setState(() {
        selectedPin = null;
      });
    });

    hideOverlay();
  }

  //Overlay Methods
  void showOverlay() {
    final overlay = Overlay.of(context);
    final renderBox = context.findRenderObject() as RenderBox;
    final size = renderBox.size;

    //TODO: The calculations for top and right are off. Should be fixed by the designer or something idk.
    double top;
    double right;

    double widgetHeight = 0.5;
    double widgetWidth = 0.25;

    //Check for tablet or phone.
    if (size.width >= size.height) {
      widgetHeight = 0.5;
      widgetWidth = 0.5;
      top = size.height * wideUp - size.height * widgetHeight / 2;
      right = size.width * wideRight - size.width * widgetWidth / 2;
    } else {
      widgetHeight = 0.5;
      widgetWidth = 0.5;
      top = size.height * longUp - size.height * widgetHeight / 2;
      right = size.width * longRight - size.width * widgetWidth / 2;
    }

    entry = OverlayEntry(
      builder:
          (context) => Positioned(
            height: size.height * widgetHeight, //TODO: DESIGNER
            width: size.width * widgetWidth, //TODO: DESIGNER
            right: right,
            top: top,
            child: StatefulBuilder(builder: (context, setStateOverlay) {
              return mapOverlayMenu(setStateOverlay);
            }),
          ),
    );

    overlay.insert(entry!);
  }

  void hideOverlay() {
    final entry = this.entry;
    if (entry != null) {
      entry.remove();
      entry.dispose();
    }
  }

  //Ai test TODO
  Widget mapOverlayMenu(Function overlaySetState) {

    return DefaultTextStyle(
      style: TextStyle(fontFamily: 'robotoSlab', color: Colors.black),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(),
              spreadRadius: 2,
              blurRadius: 5,
            ),
          ],
        ),
        //Create the stack
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 15, bottom: 15, right: 15),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  //Top box with image
                  SizedBox(
                    height: 150,
                    child: Container(
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: selectedPin!.images[0],
                          fit: BoxFit.fitHeight,
                        ),
                      ),
                    ),
                  ),
                  //Text box with the address
                  const SizedBox(height: 8),
                  Text(
                    selectedPin!.address,
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 24),
                  ),
                  //A button to close the overlay
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: closePin,
                    child: const Text("Close Overlay"),
                  ),
                  //A button to init the HousePage
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          //maintainState: true,
                          builder: (BuildContext context) {
                            closePin();
                            return HousePage(data: selectedPin!, isLiked: false);
                          },
                        ),
                      );
                    },
                    child: const Text("Deep Dive"),
                  ),
                ],
              ),
            ),
            //Notifications?
            Positioned(
              top: 17,
              right: 4,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(shape: CircleBorder()),
                onPressed: () {
                  final messenger = ScaffoldMessenger.of(context);
                  messenger.removeCurrentSnackBar();

                  //Updates the state based on if the pin is liked
                  overlaySetState(() {
                    if (main.likedTable.containsHouse(main.activeTable, selectedPin!.id)) {
                      main.likedTable.removeHouse(main.activeTable, selectedPin!.id);
                      messenger.showSnackBar(
                        SnackBar(
                          content: Text('Removed from liked homes!'),
                          duration: Duration(seconds: 2),
                        ),
                      );
                    } else {
                      main.likedTable.addHouse(main.activeTable, selectedPin!.id);
                      messenger.showSnackBar(
                        SnackBar(
                          content: Text('Added to liked homes!'),
                          duration: Duration(seconds: 2),
                        ),
                      );
                    }
                    print(main.likedTable.containsHouse(main.activeTable, selectedPin!.id));
                  });
                },
                child: Icon(
                  (main.likedTable.containsHouse(main.activeTable, selectedPin!.id))
                      ? Icons.star
                      : Icons.star_border,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }


  //Initialization and caching of Async Data
  @override
  void initState() {
    super.initState();
    _mapData = _getMarkerDataFromDatabase();
    //Get the required data
  }

  //Building the widget
  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: bar, body: map(context, getMarkerLayerFromDataTable(main.houseDataTable)));
  }

  ///Dispose the widget and overlays
  @override
  void dispose() {
    //Hide the overlay
    hideOverlay();
    super.dispose();
  }

  MarkerLayer getSinglePin(BuildContext context, MapData data) {
    return MarkerLayer(
      markers: [
        Marker(
          point: data.location,
          width: mapIconWidth,
          height: mapIconHeight,
          alignment: Alignment.topCenter,
          child: GestureDetector(
            onTap: () {
              onPinClickEvent(data);
            },
            child: Icon(
              Icons.location_pin,
              size: mapIconSize,
              color: Colors.red,
            ),
          ),
        ),
      ],
    );
  }

  Widget map(BuildContext context, MarkerLayer inputLayer) {
    MarkerLayer layer;
    //Get the pins
    if (selectedPin == null) {
      layer = inputLayer;
    } else {
      layer = getSinglePin(context, selectedPin!);
    }
    //get children
    List<Widget> children = [];
    children.add(openStreetMapTileLayer);
    children.add(layer);

    return FlutterMap(
      options: const MapOptions(
        initialCameraFit: CameraFit.coordinates(
          coordinates: [
            //used https://www.latlong.net/ DON'T USE GOOGLE MAPS!!!
            LatLng(45.418644, -122.679640), //corner 1
            LatLng(45.404050, -122.651485), //corner 2
          ],
        ),
        interactionOptions: InteractionOptions(
          flags: ~InteractiveFlag.pinchZoom,
        ),
      ),
      mapController: _animatedMapController.mapController,
      children: children,
    );
  }

}

TileLayer get openStreetMapTileLayer => TileLayer(
  tileProvider: CancellableNetworkTileProvider(),
  urlTemplate: mapApiUrl,
  userAgentPackageName: userPackageName,
);
