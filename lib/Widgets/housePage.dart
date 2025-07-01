import 'package:flutter/material.dart';
import 'package:testing/Classes/house.dart';
import 'package:testing/Classes/mapData.dart';

class HousePage extends StatelessWidget {
  final MapData data;
  final bool isLiked;

  const HousePage({super.key, required this.data, this.isLiked = true});

  @override
  Widget build(BuildContext context) {
    //Create the scaffold using the data from MapData.
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.indigoAccent,
        title: Text(data.address,
        style: TextStyle(color: Colors.white)),
      ),
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            children: <Widget>[
              //potentially replace the image with a series of images
              Expanded(
                flex: 3,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: Image(image: data.images[0], fit: BoxFit.cover),
                ),
              ),
              Divider(),
              Expanded(
                flex: 2,
                child: Column(
                  children: <Widget>[
                    SizedBox(
                      width: double.infinity,
                      child: Text(
                        data.name,
                        textAlign: TextAlign.left,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontFamily: "robotoSlab",
                          fontSize: 32,
                        ),
                      ),
                    ),
                    SizedBox(
                      width: double.infinity,
                      child: Text(
                        data.address,
                        style: TextStyle(
                          fontStyle: FontStyle.italic,
                          fontFamily: "robotoSlab",
                          fontSize: 24,
                        ),
                      ),
                    ),
                    SizedBox(
                      width: double.infinity,
                      child: Text(
                        "Built in ${data.yearBuilt}",
                        style: TextStyle(
                          fontStyle: FontStyle.italic,
                          fontFamily: "robotoSlab",
                          fontSize: 18,
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    Expanded(
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: Color.fromARGB(128, 208, 208, 208),
                          border: Border.all(color: Colors.blueGrey, width: 2),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          data.description,
                          style: TextStyle(
                            fontFamily:
                                "robotoSlab", //IDEALLY FIND A NEW FONT FOR THIS
                            fontSize: 18,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
