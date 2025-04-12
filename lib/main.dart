import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.indigoAccent,
          title: const Text("Home Page"),
        ),

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
                      print('button pressed!');
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

        bottomNavigationBar: BottomNavigationBar(
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: "Button 1",
              tooltip: "Testing button",
            ),

            BottomNavigationBarItem(
              icon: Icon(Icons.lightbulb_circle_outlined),
              label: "Button 2",
            ),

            BottomNavigationBarItem(icon: Icon(Icons.map), label: "Button 3"),
          ],
        ),
      ),
    );
  }
}
