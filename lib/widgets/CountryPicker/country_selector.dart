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
  bool openCountryListView = true;
  Country selectedCountry;
  TextEditingController phoneNoEditController;

  @override
  void initState() {
    super.initState();
    phoneNoEditController = new TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    if (openCountryListView)
      return Column(
        children: <Widget>[
          Container(
            height: 30,
            margin: EdgeInsets.all(6),
          ),
          Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: const EdgeInsets.only(top: 8.0, left: 8.0, bottom: 12.0),
              child: Text(
                'Select Your Country',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
          ),
          Container(
            height: MediaQuery.of(context).size.height - 93,
            child: ListView.builder(
                itemCount: countryInstances.length,
                itemBuilder: (context, index) {
                  return _buildRow(countryInstances[index], index);
                }),
          ),
        ],
      );
    else {
      var flagPath =
          "images/flags/${this.selectedCountry.code.toLowerCase()}.png";
      return Column(children: [
        Container(
          height: 100,
          width: 100,
        ),
        Container(
            padding: EdgeInsets.all(12),
            child: Container(
              width: 304,
              decoration: BoxDecoration(
                  border: Border(
                      bottom: BorderSide(color: Colors.blue[600], width: 2))),
              child: Row(
                children: <Widget>[
                  GestureDetector(
                    child: Container(
                      child: Row(
                        children: <Widget>[
                          Container(
                            width: 35,
                            height: 35,
                            child: Image(
                              image: new AssetImage(flagPath),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(1.0),
                            child: Text(
                              " " +
                                  this.selectedCountry.prefix +
                                  this.selectedCountry.dialCode,
                              style: TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 22,
                              ),
                            ),
                          ),
                          Icon(
                            Icons.arrow_drop_down,
                            color: Colors.grey,
                          ),
                        ],
                      ),
                    ),
                    onTap: () {
                      setState(() {
                        this.openCountryListView = true;
                      });
                    },
                  ),
                  Container(
                    padding: EdgeInsets.all(6),
                    child: TextFormField(
                      style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 22,
                          letterSpacing: 1),
                      keyboardType: TextInputType.number,
                      cursorWidth: 3,
                      decoration: new InputDecoration(
                        border: InputBorder.none,
                        suffixIcon: IconButton(
                          onPressed: () {
                            setState(() {
//                              phoneNoEditController.clear();
                            });
                          },
                          icon: Icon(
                            Icons.close,
                            color: Colors.grey[400],
                          ),
                        ),
                        hintText: 'Your number',
                        hintStyle: TextStyle(
                            fontFamily: 'Roboto',
                            fontSize: 22,
                            letterSpacing: 0,
                            fontWeight: FontWeight.normal,
                            color: Colors.grey),
                      ),
                    ),
                    width: 200,
                  )
                ],
              ),
            ))
      ]);
    }
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
            this.openCountryListView = false;
            this.selectedCountry = countryInstance;
          });
        },
      ),
    );
  }
}
