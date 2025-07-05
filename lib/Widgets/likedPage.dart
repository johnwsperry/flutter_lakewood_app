import 'package:flutter/material.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:testing/Classes/house.dart';
import 'package:testing/Classes/likedHousesTable.dart';
import 'package:testing/globalVars.dart';

import 'housePage.dart';
import '../main.dart' as main;

class LikedPage extends StatefulWidget {
  const LikedPage({super.key});

  @override
  State<LikedPage> createState() => _LikedPageState();
}

class _LikedPageState extends State<LikedPage> {
  //WTH
  @override
  void initState() {
    super.initState();
  }

  void _removeLike(int houseId) {
    if (main.likedTable.data.isEmpty) return;
    //Removing the old snackbar
    final messenger = ScaffoldMessenger.of(context);
    messenger.removeCurrentSnackBar();
    //Get the address from the house data table
    String address = main.houseDataTable.getDataByID(houseId).address;
    //updates the state of the widget along with setting a new snackbar
    setState(() {
      messenger.showSnackBar(
        SnackBar(
          content: Text('Removed $address from liked homes!'),
          duration: Duration(seconds: 2),
        ),
      );
      //Remove the house from the table
      main.likedTable.removeHouse(main.activeTable, houseId);
    });
  }

  @override
  Widget build(BuildContext context) {
    return likedMenu();
  }

  ///The menu used when data is correctly parsed!
  Widget likedMenu(){
    //Parse likedHouses

    List<LikedHouseData> data = main.likedTable.getWithDbId(main.activeTable);
    return MaterialApp(
      home: Scaffold(
        appBar: bar,
        body: Column(
          children: [
            Spacer(flex: 1),
            Expanded(
              flex: 1,
              child: Text(
                "Browse your liked homes!",
                //Gee thanks leon
              ),
            ),
            Spacer(flex: 1),
            //Main content depending on the condition of LikedHomes
            Flexible(
              flex: 20,
              child:
              //If statement
              data.isEmpty
                  ? Center(
                child: Padding(
                  padding: EdgeInsets.all(40),
                  child: Container(
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(125, 169, 169, 169),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.black, width: 2),
                    ),
                    child: SizedBox(
                      height: 100,
                      child: Column(
                        children: [
                          Spacer(),
                          Padding(
                            padding: EdgeInsets.all(4),
                            child: Text(
                              "You don't have any liked homes yet! Any building you mark as liked on the map will show up here.", textAlign: TextAlign.center,
                            ),
                          ),
                          Spacer()
                        ],
                      ),
                    ),
                  ),
                ),
              )
                  : ListView.separated(
                shrinkWrap: true,
                physics: AlwaysScrollableScrollPhysics(),
                scrollDirection: Axis.vertical,
                padding: const EdgeInsets.all(20),

                //The creator for each house
                itemBuilder: (BuildContext context, int index) {
                  //Get the house
                  final house = main.houseDataTable.getDataByID(data[index].houseId);
                  return Card(
                    shadowColor: Colors.blueGrey,
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    margin: EdgeInsets.symmetric(
                      vertical: 8,
                      horizontal: 0,
                    ),

                    child: InkWell(
                      borderRadius: BorderRadius.circular(15),
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder:
                                (context) =>
                                HousePage(data: house),
                          ),
                        );
                      },

                      child: SizedBox(
                        height: 134,
                        child: Row(
                          children: [
                            Expanded(
                              flex: 2,
                              child: ClipRRect(
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(15),
                                  bottomLeft: Radius.circular(15),
                                ),
                                child: Image(
                                  image: house.images[0],
                                  fit: BoxFit.cover,
                                  height: double.infinity,
                                ),
                              ),
                            ),

                            Expanded(
                              flex: 3,
                              child: Padding(
                                padding: const EdgeInsets.all(15),
                                child: Column(
                                  crossAxisAlignment:
                                  CrossAxisAlignment.start,
                                  mainAxisAlignment:
                                  MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      house.name,
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontFamily: "robotoSlab",
                                        fontSize: 16,
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    SizedBox(height: 8),
                                    Text(
                                      house.address,
                                      style: TextStyle(
                                        fontStyle: FontStyle.italic,
                                        fontFamily: "robotoSlab",
                                        fontSize: 12,
                                      ),
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    Spacer(),
                                    Align(
                                      alignment: Alignment.bottomRight,
                                      child: Tooltip(
                                        message: "Remove from Liked",

                                        child: FloatingActionButton(
                                          mini: true,
                                          heroTag:
                                          null, // can give this an unique tag for hero animations
                                          child: Icon(Icons.star),
                                          onPressed: () {
                                            //remove the like using the houseId
                                            _removeLike(house.id);
                                          },
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
                separatorBuilder:
                    (BuildContext context, int index) =>
                const Divider(),
                itemCount: data.length,
              ),
            ),
          ],
        ),
      ),
    );
  }

}
