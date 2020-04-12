import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

class DailyPage extends StatefulWidget {
  @override
  _DailyPageState createState() => _DailyPageState();
}

class _DailyPageState extends State<DailyPage> {
  List _countries;
  String _countrySelected;
  List _provincies;
  // String _provinceSelected;
  CalendarController _calendar;
  var _date;
  var _result;
  // var _confirmed, _recovered, _deaths;
  var _dio = Dio()..options.baseUrl = "https://covid19.mathdro.id/api";

  @override
  void initState() {
    super.initState();
    _countries = new List();
    _calendar = new CalendarController();
    _date = DateTime.now();
    initialization();
  }

  @override
  void dispose() {
    _calendar.dispose();
    super.dispose();
  }

  void initialization() async {
    _dio.get("/countries").then((getCountries) {
      if (mounted) {
        for (int i = 0; i < getCountries.data['countries'].length; i++) {
          setState(() {
            _countries.add(getCountries.data['countries'][i]['name']);
          });
        }
      }
    });
  }

  Widget loadingDisplay({@required String type, @required String text}) {
    return Padding(
      padding: const EdgeInsets.all(25.5),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            type == "Circular"
                ? CircularProgressIndicator()
                : LinearProgressIndicator(),
            Text(
              text,
              style: TextStyle(
                color: Colors.blue,
                fontSize: 22.5,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget calendarDisplay() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: TableCalendar(
        calendarController: _calendar,
        calendarStyle: CalendarStyle(
          highlightSelected: true,
        ),
        initialCalendarFormat: CalendarFormat.month,
        onDaySelected: (selectedDay, _) {
          setState(() {
            _date = (selectedDay.day - 1).toString() +
                "-" +
                (selectedDay.month).toString() +
                "-" +
                (selectedDay.year).toString();
          });
        },
      ),
    );
  }

  Widget resultDisplay(BuildContext ctx, int i) {
    return _countrySelected == null
        ? Container(
            height: MediaQuery.of(ctx).size.height * 25 / 100,
            width: MediaQuery.of(ctx).size.width * 75 / 100,
            child: Card(
              elevation: 12,
              color: Colors.blue,
              child: Text("Dont for forget to Select Country & Date !"),
            ),
          )
        : Column(
            children: <Widget>[
              Text(_countrySelected),
              Container(
                child: Card(
                    elevation: 12.5,
                    color: Colors.blue,
                    child: Text(
                      _countrySelected,
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold),
                    )),
              ),
            ],
          );
  }

  Widget locationSelect() {
    return _countries.isEmpty
        ? loadingDisplay(text: "Loading", type: "Linear")
        : Column(
            children: <Widget>[
              // Country DropDownButton
              DropdownButtonHideUnderline(
                child: DropdownButton(
                    iconEnabledColor: Colors.blue,
                    hint: Center(
                      child: Text(
                        "Country",
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.blue),
                      ),
                    ),
                    value: _countrySelected,
                    items: _countries
                        .map((value) => DropdownMenuItem(
                              child: Center(
                                child: Text(
                                  value,
                                  style: TextStyle(color: Colors.blue),
                                ),
                              ),
                              value: value,
                            ))
                        .toList(),
                    onChanged: (value) {
                      setState(() {
                        _countrySelected = value;
                      });
                      fetchCountryData();
                    }),
              ),
              Padding(padding: EdgeInsets.all(2.5)),
              // Province DropDownButton
              // IgnorePointer(
              //   ignoring: true,
              //   child: Container(
              //     decoration: BoxDecoration(
              //         color: Colors.blue,
              //         borderRadius: BorderRadius.all(Radius.circular(18.0))),
              //     child: Card(
              //       shape: RoundedRectangleBorder(
              //         borderRadius: BorderRadius.circular(17.5),
              //       ),
              //       color: Colors.blue,
              //       child: DropdownButtonHideUnderline(
              //         child: DropdownButton(
              //             iconEnabledColor: Colors.white,
              //             iconDisabledColor: Colors.grey,
              //             disabledHint: Text("Select Country First"),
              //             hint: Text(
              //               "Province",
              //               style: TextStyle(color: Colors.white),
              //             ),
              //             value: _countrySelected,
              //             items: _countries
              //                 .map((value) => DropdownMenuItem(
              //                       child: Text(
              //                         value,
              //                         style: TextStyle(color: Colors.white),
              //                       ),
              //                       value: value,
              //                     ))
              //                 .toList(),
              //             onChanged: (value) {
              //               setState(() {
              //                 _countrySelected = value;
              //               });
              //             }),
              //       ),
              //     ),
              //   ),
              // )
            ],
          );
  }

  String parseDate(DateTime dateSelected) {
    var out = dateSelected.day.toString() +
        "-" +
        dateSelected.month.toString() +
        "-" +
        dateSelected.year.toString();
    return out;
  }

  void fetchCountryData() async {
    _date = parseDate(_date);
    _dio.get("/daily" + _date).then((onValue) {
      setState(() {
        _result = onValue.data;
      });
      print(_result[0][2]['countryRegion']);
    });
  }

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: <Widget>[
        SliverToBoxAdapter(
          child: calendarDisplay(),
        ),
        SliverToBoxAdapter(
          child: locationSelect(),
        ),
        _countrySelected == null
            ? SliverToBoxAdapter(
                child: CircularProgressIndicator(),
              )
            : SliverGrid(
                delegate: SliverChildBuilderDelegate((context, i) {
                  return resultDisplay(context, i);
                }),
                gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                    maxCrossAxisExtent: _countrySelected == null ? 1 : 1),
              )
      ],
    );
  }
}
