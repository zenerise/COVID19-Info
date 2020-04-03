import 'package:fancy_bottom_navigation/fancy_bottom_navigation.dart';
import 'package:flutter/material.dart';
import 'package:covid19info/global.dart';
import 'package:covid19info/country.dart';
import 'package:covid19info/daily.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Covid-19 Info',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'COVID-19 Info'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  
  var currentPos;

  Widget body(){
    // currentPos == 0 ? CountryPage() : currentPos == 1 ? GlobalPage() : currentPos == 2 ? DailyPage() : null
    switch (currentPos) {
      case 0:
        return CountryPage();
        break;
      case 1:
        return GlobalPage();
        break;
      case 2:
        return DailyPage();
        break;
      default:
        return GlobalPage();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: <Widget>[
          IconButton(
              icon: Icon(
                Icons.info,
                color: Colors.white,
              ),
              onPressed: null),
        ],
        title: Text(widget.title, style: TextStyle(fontWeight: FontWeight.bold,)),
        elevation: 13.5,
      ),
      body: body(),
      bottomNavigationBar: FancyBottomNavigation(
        activeIconColor: Colors.blue,
        barBackgroundColor: Colors.blue,
        circleColor: Colors.white,
        inactiveIconColor: Colors.white,
        textColor: Colors.white,
        initialSelection: 1,
        tabs: [
          TabData(iconData: Icons.map, title: "Countries"),
          TabData(iconData: Icons.people, title: "Global"),
          TabData(iconData: Icons.timer, title: "Daily Data")
      ],
        onTabChangedListener: (position) {
         setState(() {
          currentPos = position;
        });
      },
      ),
    );
  }
}