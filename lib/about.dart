import 'package:flutter/material.dart';

class AboutPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        title: Text("About"),
      ),
      body: Center(
        child: Container(
          height: MediaQuery.of(context).size.height * 50 / 100,
          child: Card(
              elevation: 12.5,
              color: Colors.blue,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text("based on mathdroid's covid 19 API",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        )),
                    Padding(padding: EdgeInsets.all(2.5)),
                    Text("https://github.com/mathdroid/covid19",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        )),
                    Padding(padding: EdgeInsets.only(top: 50.0)),
                    Text("*Note : Data Only Updated On Daily Basis",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ))
                  ],
                ),
              )),
        ),
      ),
    );
  }
}
