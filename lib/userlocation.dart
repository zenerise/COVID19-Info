import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

class UserLocation extends StatefulWidget {
  @override
  _UserLocationState createState() => _UserLocationState();
}

class _UserLocationState extends State<UserLocation> {
  var userCountry;
  var userLocationCases;
  var dio = Dio()..options.baseUrl = "https://covid19.mathdro.id/api/countries";

  @override
  void initState() {
    super.initState();
    initialization();
  }

  initialization() async {
    Geolocator()
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.high)
        .then((value) {
      Geolocator()
          .placemarkFromCoordinates(value.latitude, value.longitude)
          .then((location) {
        Placemark place = location[0];
        if (mounted)
          setState(() {
            userCountry = place.country;
            getUsrLocCases(place.isoCountryCode);
          });
      }).catchError((onError) => print(onError));
    });
  }

  getUsrLocCases(var country) async {
    dio.get("/$country").then((value) {
      if (mounted)
        setState(() {
          userLocationCases = value.data;
        });
    });
  }

  Widget cases(var cases) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(35.0, 8.0, 35.0, 8.0),
      child: Column(
        children: <Widget>[
          Text(
            cases,
            style: TextStyle(
                color: Colors.white,
                fontSize: 27.5,
                fontWeight: FontWeight.bold),
          ),
          userLocationCases == null
              ? CircularProgressIndicator(backgroundColor: Colors.white)
              : Text(userLocationCases[cases]['value'].toString(),
                  style: TextStyle(color: Colors.white, fontSize: 22.5))
        ],
      ),
    );
  }

  Widget location() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: <Widget>[
          Text(
            "Your Location",
            style: TextStyle(
                color: Colors.blue,
                fontWeight: FontWeight.bold,
                fontSize: 22.5),
          ),
          userCountry == null
              ? Padding(
                  padding: const EdgeInsets.fromLTRB(75.0, 2.0, 75.0, 2.0),
                  child: LinearProgressIndicator(backgroundColor: Colors.white),
                )
              : Text(userCountry,
                  style: TextStyle(
                    color: Colors.blue,
                  )),
        ],
      ),
    );
  }

  Widget details() {
    return Container(
      child: Card(
          elevation: 12.5,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(17.5),
          ),
          color: Colors.blue,
          child: Column(
            children: <Widget>[
              cases("confirmed"),
              cases("recovered"),
              cases("deaths"),
            ],
          )),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          location(),
          details(),
        ],
      ),
    );
  }
}
