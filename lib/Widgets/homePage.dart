
import 'package:flutter/material.dart';
import 'package:testing/Widgets/creditsPage.dart';
import 'package:testing/Widgets/settingsPage.dart';
import 'mapPage.dart';
import 'likedPage.dart';
import 'package:testing/globalVars.dart';

///This is the homepage where everything is plonked on top of apparently
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

  @override
  void initState() {
    super.initState();

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

    //Map Page
    Widget mapPage = MapPage(title: "MapPage");

    //Liked Page
    Widget likedPage = LikedPage();

    //Disable the following for now
    Widget matchPage = Scaffold(
      appBar: bar,
      body: Center(
        child: Text("Coming Soon!"),
      ),
    );

    //Settings
    Widget settingsPage = SettingsPage();

    Widget credits = CreditsPage.creditsPage(bar);

    // basic setup for a placeholder page

    // Widget PAGENAME = Scaffold(
    //   appBar: bar,
    //   body: Center(
    //     child: Text("This is the map page!"),
    //   )
    // );

    //Set the options
    widgetOptions = <Widget>[
      homePage,
      mapPage,
      likedPage,
      matchPage,
      credits,
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
        backgroundColor: Theme.of(context).colorScheme.surface,
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
              icon: Icon(Icons.info_outline),
              label: "Credits",
            ),
          ],
        ),
      ),
    );
  }
}