import 'package:flutter/material.dart';
import 'package:covid19info/daily/models/country.dart';

class CountryViews {
  Widget display() {
    return DropdownButton(
      hint: Text("Country"),
      value: CountryModel.countryList == null
          ? null
          : CountryModel.countryList,
      items: CountryModel.countryList == null
          ? null
          : CountryModel.countryList.map((value) {
              return DropdownMenuItem(
                child: Text(value),
                value: value,
              );
            }).toList(),
      onChanged: (value) {
        CountryModel.countrySelected = value;
      },
    );
  }
}
