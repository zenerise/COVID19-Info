import 'package:flutter/material.dart';
import 'package:dio/dio.dart';

class GlobalPage extends StatefulWidget {
  @override
  _GlobalPageState createState() => _GlobalPageState();
}

class _GlobalPageState extends State<GlobalPage> {
  var _recovered, _deaths, _confirmed, _lastUpdate;
  var currentPos;
  var dio = Dio()..options.baseUrl = "https://covid19.mathdro.id/api";

  @override
  void initState() {
    super.initState();
    initialization();
  }

  void initialization() async {
    try {
      Response resp = await dio.get("/");
      if (mounted) {
        setState(() {
          _confirmed = resp.data['confirmed']['value'];
          _recovered = resp.data['recovered']['value'];
          _deaths = resp.data['deaths']['value'];
          _lastUpdate = resp.data['lastUpdate'];
        });
      }
    } catch (err) {
      if (mounted) {
        setState(() {
          _deaths = "Error , connection to server";
          _recovered = "Error , connection to server";
          _confirmed = "Error , connection to server";
        });
      }
    }
  }

  Widget getGlobal(var status) {
    var data;
    status == "Confirmed"
        ? data = _confirmed
        : status == "Recovered"
            ? data = _recovered
            : status == "Deaths" ? data = _deaths : data = null;

    return Padding(
      padding: const EdgeInsets.all(6.5),
      child: Column(
        children: <Widget>[
          Text(
            '$status',
            style: TextStyle(color: Colors.white, fontSize: 17.5),
          ),
          Container(
            height: 2.5,
          ),
          data == null
              ? CircularProgressIndicator(
                  backgroundColor: Colors.white,
                )
              : Text(
                  '$data',
                  style: TextStyle(fontSize: 35, color: Colors.white),
                ),
        ],
      ),
    );
  }

  Widget global() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        getGlobal("Confirmed"),
        getGlobal("Recovered"),
        getGlobal("Deaths"),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          Container(
              child: Card(
                  elevation: 12.5,
                  color: Colors.blue,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(17.5),
                  ),
                  child: _lastUpdate == null
                      ? CircularProgressIndicator(
                          backgroundColor: Colors.white,
                        )
                      : Column(
                          children: <Widget>[
                            Text(
                              "Last Update",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 22.5,
                                  fontWeight: FontWeight.w400),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(7.5),
                              child: Text(
                                _lastUpdate,
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w900),
                              ),
                            )
                          ],
                        ))),
          Container(
              padding: EdgeInsets.fromLTRB(35, 0, 35, 0),
              child: Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(32.5),
                  ),
                  elevation: 12.5,
                  color: Colors.blue,
                  child: global())),
        ],
      ),
    );
  }
}
