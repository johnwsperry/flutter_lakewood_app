import 'package:flutter/material.dart';
import 'package:testing/globleVars.dart';
import 'package:testing/Classes/house.dart';
import 'housePage.dart';

class LikedPage extends StatefulWidget {
  const LikedPage({super.key});

  @override
  State<LikedPage> createState() => _LikedPageState();
}

class _LikedPageState extends State<LikedPage> {
  @override
  void initState() {
    super.initState();

    // This is for debug-- fills likedHomes with 20 placeholder homes.

    /*
    if (likedHomes.isEmpty) {
    for (int i = 1; i <= 20; i++) {
      likedHomes.add(
        House(
          name: "Home $i",
          address: "${i + 122} Street Rd",
          description: "this is a description of what the house is like",
          image: AssetImage("resources/assets/houseplaceholder${i % 3 + 1}.png"),
        ),
      );
    }}
    */
  }

  void _removeLike(int index) {
    if (likedHomes.isEmpty) return;
    final messenger = ScaffoldMessenger.of(context);
    messenger.removeCurrentSnackBar();
    setState(() {
      messenger.showSnackBar(
        SnackBar(
          content: Text('Removed ${likedHomes[index].getCleanAddress()} from liked homes!'),
          duration: Duration(seconds: 2),
        ),
      );
      likedHomes.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: getBar(),
        body: Column(
          children: [
            Spacer(flex: 1),
            Expanded(
              flex: 1,
              child: Text(
                "This spot is a bar that you can put text in or whatever",
              ),
            ),
            Spacer(flex: 1),
            Flexible(
              flex: 20,
              child:
                  likedHomes.isEmpty
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
                        itemBuilder: (BuildContext context, int index) {
                          final house = likedHomes[index];
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
                                            HousePage(houseIndex: index),
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
                                          image: house.image,
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
                                                    _removeLike(index);
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
                        itemCount: likedHomes.length,
                      ),
            ),
          ],
        ),
      ),
    );
  }
}
