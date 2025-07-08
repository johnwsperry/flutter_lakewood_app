import 'package:flutter/material.dart';
import 'package:testing/Classes/databaseTables.dart';
import 'package:testing/Classes/likedHousesTable.dart';

import 'Util/databases.dart' as database;
import 'globalVars.dart' as global_vars;
import 'Widgets/homePage.dart';

bool debugMode = false; //TODO: TURN THIS OFF WHEN WE PUBLISH THE APP

//Use for only lakewood
late Future<HouseDatabaseTable> _oldDataTable;

late Future<LikedHousesTable> _oldTable;

late HouseDatabaseTable houseDataTable;

late LikedHousesTable likedTable;

int activeTable = 0; //TODO: This is for lakewood. Change later

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  //Query the data table
  _oldDataTable = database.Databases.queryHousesByPath("lakewood-lakeoswego-oregon-unitedstates-earth-milkyway.sqlite");
  //Set the old table
  _oldTable = global_vars.parseLikedHousesData(database.Databases.getLikedHousesDatabase());
  //Run the app
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    //Uses a future builder to init databases
    //init the liked houses database
    return FutureBuilder(future: _oldTable, builder: (context, snapshot){
      if(snapshot.hasData){
        likedTable = snapshot.data!;
        //init the house database
        return FutureBuilder(future: _oldDataTable, builder: (context, snapshot){
          if(snapshot.hasData){
            //Set the database
            houseDataTable = snapshot.data!;
            return MaterialApp(
              home: HomePage(),
              //theme: lightMode,
              //darkTheme: darkMode,
            );
          } else{
            return Center(child: CircularProgressIndicator());
          }
        });
      } else{
        //Loading. Plz wait. System processing. Follow the instructions on the pin pad.
        return Center(child: CircularProgressIndicator());
      }
    });
  }
}