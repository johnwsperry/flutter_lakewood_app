
import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import 'package:testing/Classes/house.dart';
import 'package:testing/Widgets/settingsPage.dart';
import 'package:testing/globalVars.dart';

import 'likedPage.dart';
import 'mapPage.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  late Widget homePage;
  late Widget mapPage;
  late List<Widget> widgetOptions;

  int _currentIndex = -1;

  Future<void> loadHomes() async {
      List<LatLng> locations = [];

      //TODO: replace this with actually fetching the items from the database lol

      locations.add(const LatLng(45.413338, -122.667718));
      locations.add(const LatLng(45.412787, -122.669757));
      locations.add(const LatLng(45.412907, -122.670082));
      locations.add(const LatLng(45.413012, -122.670346));
      locations.add(const LatLng(45.413099, -122.670572));

      for (LatLng location in locations) {
        allHomes.add(
          House(
            name: "Home",
            address: await getAddress(location.latitude, location.longitude),
            description: "this is a description of what the house is like",
            image: AssetImage("resources/assets/houseplaceholder1.png"),
            location: location,
          ),
        );
      }
    }

  @override
  void initState() {
    super.initState();

    loadHomes();

    homePage = Scaffold(
      appBar: bar,

      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('resources/assets/randombg.jpeg'),
            fit: BoxFit.fitHeight,
          ),
        ),

        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,

          children: [
            Expanded(
              child: SizedBox.expand(
                child: Padding(
                  padding: EdgeInsets.all(40),
                  child: Text(
                    "Welcome to Lakewood",
                    textAlign: TextAlign.center,

                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontFamily: "robotoSlab",
                      color: Colors.white,
                      fontSize: 52,
                    ),
                  ),
                ),
              ),
            ),

            Padding(
              padding: EdgeInsets.all(40),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blueAccent,
                  padding: EdgeInsets.symmetric(horizontal: 50, vertical: 20),
                ),
                onPressed: () {
                  pageSwitch(0);
                },
                child: Text(
                  "Get started",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: "gothicExpanded",

                    color: Colors.white,
                    fontSize: 26,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );

    Widget mapPage = MapPage(title: "Testing");

    Widget likedPage = LikedPage();

    Widget matchPage = Scaffold(
      appBar: bar,
      body: Center(
        child: Text("This is the matchmaker page!"),
      ),
    );

    Widget settingsPage = SettingsPage();

    // basic setup for a placeholder page

    // Widget PAGENAME = Scaffold(
    //   appBar: bar,
    //   body: Center(
    //     child: Text("This is the map page!"),
    //   )
    // );

    widgetOptions = <Widget>[
      homePage,
      mapPage,
      likedPage,
      matchPage,
      settingsPage,
    ];
  }

  void pageSwitch(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: widgetOptions.elementAt(_currentIndex + 1),

        bottomNavigationBar: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          onTap: pageSwitch,
          items: const [
            BottomNavigationBarItem(
                icon: Icon(Icons.map),
                label: "Map"
            ),

            BottomNavigationBarItem(
              icon: Icon(Icons.thumb_up),
              label: "Liked homes",
            ),

            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: "Matchmaker",
            ),

            BottomNavigationBarItem(
              icon: Icon(Icons.settings),
              label: "Settings",
            ),
          ],
        ),
      ),
    );
  }
}