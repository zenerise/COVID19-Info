
import 'package:flutter/material.dart';
import 'package:covid19info/util/api.dart';
import 'package:covid19info/daily/models/calendar.dart';
import 'package:covid19info/daily/models/province.dart';
import 'package:covid19info/daily/models/country.dart';
// import 'package:covid19info/daily/views/result.dart';
import 'package:covid19info/daily/views/province.dart';
import 'package:covid19info/daily/views/country.dart';
import 'package:covid19info/daily/views/calendar.dart';
import 'package:covid19info/daily/controllers/country.dart';
import 'package:covid19info/daily/controllers/province.dart';
// import 'package:covid19info/daily/controllers/calendar.dart';


class DailyPage extends StatefulWidget {
  @override
  _DailyPageState createState() => _DailyPageState();
}

class _DailyPageState extends State<DailyPage> {
  // var _confirmed, _recovered, _deaths;
  var _date, year, month, day;

  void initState() {
    super.initState();
    year = DateTime.now().toUtc().year;
    month = DateTime.now().toUtc().month;
    day = DateTime.now().toUtc().day - 1;
    _date = day.toString() + "-" + month.toString() + "-" + year.toString();
    initialization();
  }

  @override
  void dispose() {
    CalendarModel.calendar.dispose();
    super.dispose();
  }

  void initialization() async {
      var daily = Covid19API().getData("/daily/" + _date);
      var country = await Covid19API().getData("/countries");
        // for (int i = 0; i < respDaily.data.length; i++) {
        //   ProvinceController().addProvince(ProvinceModel.provinceList, respDaily.data[i]['provinceState']);
        // print(ProvinceModel.provinceList);
        // }
        for (int i = 0; i < country['countries'].length; i++) {
          CountryController().addCountry(CountryModel.countryList, country['countries'][i]['name']);
        }
        // print(country);
        // print(CountryModel.countryList.map((v){
        //   print("map: $v");
        // }).toList());
    
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: true,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            CalendarViews().display(),
            // CountryViews().display(),
            // ProvinceViews().display(),
            // ResultViews().display(),
          ],
        ),
      ),
    );
  }
}
