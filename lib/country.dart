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
  final TextEditingController _filter = new TextEditingController();
  String _searchText = "";
  List names = new List();
  List filteredNames = new List();
  Icon _searchIcon = new Icon(Icons.search);
  Widget _appBarTitle = new Text('Countries');

  @override
  void initState() {
    super.initState();
    initialization();
  }

  void _searchPressed() {
    setState(() {
      if (this._searchIcon.icon == Icons.search) {
        this._searchIcon = new Icon(Icons.close);
        this._appBarTitle = new TextField(
          controller: _filter,
          style: TextStyle(
            color: Colors.white
          ),
          decoration: new InputDecoration(
            enabledBorder: UnderlineInputBorder(      
                      borderSide: BorderSide(color: Colors.white),   
                      ),  
              focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.white),
                   ),  
            hintStyle: TextStyle(
              color: Colors.white
            ),
            hintText: 'Example : Albania, Indonesia, ...',
          ),
          cursorColor: Colors.white,
        );
      } else {
        this._searchIcon = new Icon(Icons.search);
        this._appBarTitle = new Text('Country List');
        filteredNames = names;
        _filter.clear();
      }
    });
  }

  void initialization() async {
    try {
      Response resp = await dio.get("/countries");
      List tempList = new List();
      setState(() {
        _countries = resp.data;
        for (int i = 0; i < _countries.length; i++) {
          tempList.add(_countries['countries'][i]['name']);
        }
        names = tempList;
        filteredNames = names;
      });
    } catch (err) {
      print(err);
    }
  }

  void getData(String countryName, int index) async {
    try {
      Response e = await dio.get("/countries/" + countryName);
      if (mounted) {
        setState(() {
          _countries['countries'][index][countryName] = e.data;
        });
      }
    } catch (r) {
      setState(() {
        _countries['countries'][index][countryName] = "Error No data : $r";
      });
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
                              fontSize: _countries['countries'][index]['name']
                                          .length >=
                                      19
                                  ? 18.5
                                  : 22.5,
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

  Widget _buildBar(BuildContext context) {
    return new AppBar(
      centerTitle: true,
      title: _appBarTitle,
      leading: new IconButton(
        icon: _searchIcon,
        onPressed: _searchPressed,
      ),
    );
  }

  Widget _buildList() {
    if (_searchText.isNotEmpty) {
      List tempList = new List();
      for (int i = 0; i < filteredNames.length; i++) {
        if (filteredNames[i]['name']
            .toLowerCase()
            .contains(_searchText.toLowerCase())) {
          tempList.add(filteredNames[i]);
        }
      }
      filteredNames = tempList;
    }
    return ListView.builder(
      itemCount: _countries == null ? 0 : _countries['countries'].length,
      itemBuilder: (BuildContext context, int index) {
        return body(index);
        // return new ListTile(
        //   title: Text(filteredNames[index]['name']),
        //   onTap: () => print(filteredNames[index]['name']),
        // );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildBar(context),
      body: Container(
        child: _buildList(),
      ),
      resizeToAvoidBottomPadding: false,
    );
  }
}
