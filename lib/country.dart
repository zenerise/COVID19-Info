import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:expandable/expandable.dart';

class CountryPage extends StatefulWidget {
  @override
  _CountryPageState createState() => _CountryPageState();
}

class _CountryPageState extends State<CountryPage> {
  var _countries;
  var dio = Dio()..options.baseUrl = "https://covid19.mathdro.id/api";

  @override
  void initState() {
    super.initState();
    initialization();
  }

  void initialization() async {
    try {
      Response resp = await dio.get("/countries");
      setState(() {
        _countries = resp.data;
      });
    } catch (err) {}
  }

  void getData(String countryName, int index) async {
    try {
      Response e = await dio.get("/countries/" + countryName);
      setState(() {
        _countries['countries'][index][countryName] = e.data;
      });
    } catch (r) {
      setState(() {});
    }
  }

  Widget body(int index) {
    var countryName = _countries['countries'][index]['name'];
    getData(countryName, index);
    return _countries['countries'][index][countryName] == null
        ? Padding(
            padding: const EdgeInsets.fromLTRB(75.5, 8.0, 75.5, 8.0),
            child: LinearProgressIndicator(),
          )
        : Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              child: Card(
                color: Colors.blue,
                elevation: 12,
                child: ExpandablePanel(
                  header: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.fromLTRB(42.5, 8.0, 8.0, 8.0),
                        child: Text(
                          _countries['countries'][index]['name'],
                          style: TextStyle(
                              fontSize: _countries['countries'][index]['name'].length >= 19 ? 18.5 : 22.5,
                              color: Colors.white,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                  expanded: Center(
                    child: _countries['countries'][index][countryName] == null
                        ? CircularProgressIndicator()
                        : Column(
                            children: <Widget>[
                              Text(
                                "Confirmed : ${_countries['countries'][index][countryName]['confirmed']['value']}",
                                // softWrap: true,
                                maxLines: 1,
                                style: TextStyle(
                                    fontSize: 17.5, color: Colors.white),
                              ),
                              Text(
                                "Recovered : ${_countries['countries'][index][countryName]['recovered']['value']}",
                                style: TextStyle(
                                    fontSize: 17.5, color: Colors.white),
                              ),
                              Text(
                                "Deaths : ${_countries['countries'][index][countryName]['deaths']['value']}",
                                style: TextStyle(
                                    fontSize: 17.5, color: Colors.white),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(15.5),
                                child: Column(
                                  children: <Widget>[
                                    Text(
                                      "Last Update on",
                                      style: TextStyle(
                                          fontSize: 17.5, color: Colors.white),
                                    ),
                                    Text(
                                      _countries['countries'][index]
                                          [countryName]['lastUpdate'],
                                      style: TextStyle(
                                          fontSize: 15.5, color: Colors.white),
                                    ),
                                  ],
                                ),
                              )
                            ],
                          ),
                  ),
                ),
              ),
            ),
          );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: ListView.builder(
          itemCount:
              _countries == null ? 0 : _countries['countries'].length,
          itemBuilder: (BuildContext context, int index) {
            return body(index);
          }),
    );
  }
}
