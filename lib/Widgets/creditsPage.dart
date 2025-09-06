
import 'package:flutter/material.dart';

class CreditsPage{

  static String imageFolder = "resources/assets/credits/";

  static Widget creditsPage(PreferredSizeWidget bar){
    return Scaffold(
      appBar: bar,
        body: Column(
          children: [
            Spacer(flex: 2),
            Expanded(
              flex: 1,
              child: Text(
                "The people who made this app possible...",
                style: TextStyle(fontSize: 15),
                //Gee thanks leon
              ),
            ),
            Spacer(flex: 1),
            //Main content depending on the condition of LikedHomes
            Flexible(
              flex: 20,
              child:
             ListView.separated(
                shrinkWrap: true,
                physics: AlwaysScrollableScrollPhysics(),
                scrollDirection: Axis.vertical,
                padding: const EdgeInsets.all(20),

                //The creator for each house
                itemBuilder: (BuildContext context, int index) {
                  //Create a card
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
                      //No on tap functionality yet
                      /*onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder:
                                (context) =>
                                HousePage(data: house),
                          ),
                        );
                      },

                       */

                      child: SizedBox(
                        height: 134*3,
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
                                  image: AssetImage(imageFolder + imagePaths[index]),
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
                                      names[index],
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
                                      descriptions[index],
                                      style: TextStyle(
                                        fontStyle: FontStyle.italic,
                                        fontFamily: "robotoSlab",
                                        fontSize: 12,
                                      ),
                                      maxLines: 5,
                                      overflow: TextOverflow.ellipsis,
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
                itemCount: names.length
              ),
            ),
          ],
        ),
    );
  }


  //Data
  static List<String> names = [
    "Alvin Wang",
    "Leon Li",
    "CJ Hanson",
    "Allan Wang",
    "Matthew Rodrigano"
  ];
  static List<String> descriptions = [
    "High School Student.\nGuy who worked on most of the backend.\nAlso the IT guy.",
    "I accidentally became the frontend developer lmao\nit's not a bug, it's a FEATURE!!",
    "High school student, app contributor",
    "App development collaborator, UI design, and a little front end",
    "Matthew is a senior at Lakeridge High School. "
        "Outside of school and coding, he runs cross country and track, "
        "participates in math competitions, volunteers with local organizations,"
        " and spends time with family and friends."
  ];
  static List<String> imagePaths = [
    "AlvinWang-Credits-0.png",
    "LeonLi-Credits-0.png",
    "CJHanson-Credits-0.png",
    "AllanWang-Credits-0.png",
    "MatthewRodrigano-Credits-0.jpeg"
  ];

}