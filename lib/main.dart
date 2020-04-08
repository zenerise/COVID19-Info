import 'package:fancy_bottom_navigation/fancy_bottom_navigation.dart';
import 'package:flutter/material.dart';
import 'package:covid19info/global.dart';
import 'package:covid19info/country.dart';
import 'package:covid19info/daily/daily.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Covid-19 Info',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
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

  Widget body(BuildContext ctx){
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
  
  Widget bottomNavBar(){
    return Padding(
        padding: const EdgeInsets.only(top: 15.5),
        child: FancyBottomNavigation(
          activeIconColor: Colors.blue,
          barBackgroundColor: Colors.blue,
          circleColor: Colors.white,
          inactiveIconColor: Colors.white,
          textColor: Colors.white,
          initialSelection: 1,
          tabs: [
            TabData(iconData: Icons.map, title: "Countries"),
            TabData(iconData: Icons.people, title: "Global"),
            TabData(iconData: Icons.date_range, title: "Daily")
        ],
          onTabChangedListener: (position) {
           setState(() {
            currentPos = position;
          });
        },
        ),
      );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: currentPos == 0 ? null : AppBar(
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
      body: body(context),
      bottomNavigationBar: bottomNavBar()
    );
  }
}