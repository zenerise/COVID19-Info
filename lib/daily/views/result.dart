import 'package:flutter/material.dart';
import 'package:covid19info/daily/models/province.dart';

class ResultViews {
  Widget display() {
    return ListView.builder(
        itemCount: 1, //_data[0].length,
        itemBuilder: (BuildContext context, int i) {
          return Container(
            child: Card(
              elevation: 12.5,
              color: Colors.blue,
              child: ProvinceModel.provinceList[i]['provinceState'] != null
                  ? Text(
                      ProvinceModel.provinceList[i]['provinceState'],
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold),
                    )
                  : Text(
                      ProvinceModel.provinceList[i]['countryRegion'],
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold),
                    ),
            ),
          );
        });
  }
}
