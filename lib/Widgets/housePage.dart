
import 'package:flutter/material.dart';
import 'package:testing/globleVars.dart';
import 'package:testing/Classes/house.dart';


class HousePage extends StatelessWidget {
  final int houseIndex;

  const HousePage({super.key, required this.houseIndex});

  @override
  Widget build(BuildContext context) {
    final House house = likedHomes[houseIndex];
    return Scaffold(
      appBar: bar,
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
                  child: Image(image: house.image, fit: BoxFit.cover),
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
                        house.name,
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
                        house.address,
                        style: TextStyle(
                          fontStyle: FontStyle.italic,
                          fontFamily: "robotoSlab",
                          fontSize: 24,
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
                          house.description,
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
