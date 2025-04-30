import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late Widget homePage;
  late Widget mapPage;
  late List<Widget> widgetOptions;

  List<String> likedHomes = <String>[];
  // probably change the array type to widgets and store widgets here instead
  // or 2d array to put info for houses or whatev

  PreferredSizeWidget bar = AppBar(
    backgroundColor: Colors.indigoAccent,
    title: const Text("Lakewood Homes"),
  );

  int _currentIndex = -1;

  @override
  void initState() {
    super.initState();

    for (int i = 1; i <= 20; i++) {
      likedHomes.add("home $i");
    }


    homePage = Scaffold(
      appBar: bar,

      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/randombg.jpeg'),
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
                  _pageSwitch(1);
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

    Widget mapPage = Scaffold(
      appBar: bar,
      body: Center(
        child: Text("This is the map page!"),
      ),
    );

    Widget likedPage = Scaffold(
      appBar: bar,
      body: Column(
        children: [
          Text("This is the liked homes page!"),
          Flexible(
            child: ListView.separated(
              shrinkWrap: true,
              physics: AlwaysScrollableScrollPhysics(),
              scrollDirection: Axis.vertical,
              padding: const EdgeInsets.all(20),
              itemBuilder: (BuildContext context, int index) {
                return Container(
                  height: 100,
                  color: Colors.lightBlueAccent,
                  child: Center(
                    child: Text('Liked ${likedHomes[index]}'),
                  ),
                );
              },
              separatorBuilder: (BuildContext context, int index) => const Divider(),
              itemCount: likedHomes.length,
            ),
          ),
        ],
      ),
    );

    Widget matchPage = Scaffold(
      appBar: bar,
      body: Center(
        child: Text("This is the matchmaker page!"),
      ),
    );

    Widget settingsPage = Scaffold(
      appBar: bar,
      body: Center(
        child: Text("This is the settings page!"),
      ),
    );

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

  void _pageSwitch(int index) {
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
          currentIndex: 0,
          onTap: _pageSwitch,
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