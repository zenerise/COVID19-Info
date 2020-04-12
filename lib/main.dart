import 'package:covid19info/about.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:covid19info/global.dart';
import 'package:covid19info/country.dart';
// import 'package:covid19info/daily.dart';
import 'package:covid19info/userlocation.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Covid-19 Info',
      theme: ThemeData(canvasColor: Colors.transparent),
      home: Covid19Info(title: 'COVID-19 Info.'),
    );
  }
}

class Covid19Info extends StatefulWidget {
  Covid19Info({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _Covid19InfoState createState() => _Covid19InfoState();
}

class _Covid19InfoState extends State<Covid19Info> {
  var currentPos;

  Widget body() {
    switch (currentPos) {
      case 0:
        return CountryPage();
        break;
      case 1:
        return GlobalPage();
        break;
      case 2:
        return UserLocation();
        break;
      default:
        return GlobalPage();
    }
  }

  Widget bottomNavBar() {
    return CurvedNavigationBar(
      // activeIconColor: Colors.blue,
      // buttonBackgroundColor: Colors.blue,
      color: Colors.blue,
      index: 1,
      backgroundColor: Colors.transparent,
      // circleColor: Colors.white,
      // inactiveIconColor: Colors.white,
      // textColor: Colors.white,
      // initialSelection: 1,
      height: 52.5,
      items: <Widget>[
        Icon(
          Icons.map,
          color: Colors.white,
        ),
        Icon(
          Icons.language,
          color: Colors.white,
        ),
        Icon(Icons.my_location, color: Colors.white)
      ],
      onTap: (position) {
        setState(() {
          currentPos = position;
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        extendBody: true,
        backgroundColor: Colors.white,
        appBar: currentPos == 0
            ? null
            : PreferredSize(
                preferredSize: Size.fromHeight(
                    MediaQuery.of(context).size.height * 8.5 / 100),
                child: AppBar(
                  centerTitle: true,
                  actions: <Widget>[
                    IconButton(
                        icon: Icon(
                          Icons.info,
                          color: Colors.white,
                        ),
                        onPressed: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => AboutPage()))),
                  ],
                  title: Text(widget.title,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      )),
                  elevation: 13.5,
                ),
              ),
        body: body(),
        bottomNavigationBar: bottomNavBar());
  }
}
