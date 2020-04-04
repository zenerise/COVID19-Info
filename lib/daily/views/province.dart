import 'package:flutter/material.dart';
import 'package:covid19info/daily/models/province.dart';

class ProvinceViews {
  Widget display() {
    return DropdownButton(
      hint: Text("Province"),
      value: ProvinceModel.provinceList == null
          ? null
          : ProvinceModel.provinceList,
      items: ProvinceModel.provinceList == null
          ? null
          : ProvinceModel.provinceList.map((value) {
              return DropdownMenuItem(
                child: Text(value),
                value: value,
              );
            }).toList(),
      onChanged: (value) {
        ProvinceModel.provinceSelected = value;
      },
    );
  }
}
