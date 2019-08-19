import 'package:flutter/material.dart';

import 'Models/country.dart';
import 'Repository/country_codes.dart';

class CountrySelectWidget extends StatefulWidget {
  final List<Map> countryJsonList;

  const CountrySelectWidget({Key key, this.countryJsonList = country_codes})
      : super(key: key);

  @override
  State<StatefulWidget> createState() {
    List<Country> countryInstances = [];
    countryJsonList.forEach((Map countryData) {
      countryInstances.add(Country(
          name: countryData['Name'],
          code: countryData['ISO'],
          dialCode: countryData['Code']));
    });
    return CountrySelectWidgetState(countryInstances);
  }
}

class CountrySelectWidgetState extends State<CountrySelectWidget> {
  List<Country> countryInstances;
  CountrySelectWidgetState(this.countryInstances);
  int selectedIndex;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: ListView.builder(
          itemCount: countryInstances.length,
          itemBuilder: (context, index) {
            return _buildRow(countryInstances[index], index);
          }),
    );
  }

  Widget _buildRow(Country countryInstance, int index) {
    var countryName = countryInstance.name[0].toUpperCase() +
        countryInstance.name.substring(1);
    var flagPath = "images/flags/${countryInstance.code.toLowerCase()}.png";

    return Container(
      decoration: BoxDecoration(
          color: this.selectedIndex == index ? Colors.blueGrey : null),
      child: new ListTile(
        selected: this.selectedIndex == index,
        leading: Container(
            width: 25,
            height: 25,
            child: Image(image: new AssetImage(flagPath))),
        title: new Text(countryName),
        trailing: new Text(
          countryInstance.prefix + countryInstance.dialCode,
          style: TextStyle(
              color: this.selectedIndex == index ? Colors.white : Colors.black),
        ),
        onTap: () {
          setState(() {
            this.selectedIndex = index;
          });
        },
      ),
    );
  }
}
