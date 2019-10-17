import 'package:flutter/material.dart';
import 'package:ola_like_country_picker/ola_like_country_picker.dart';

class MobileInput extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _MobileInputState();
  }
}

class _MobileInputState extends State<MobileInput> {
  CountryPicker countryPicker;
  Country country;
  final TextEditingController _controller = new TextEditingController();
  TextStyle textFont;

  @override
  void initState() {
    super.initState();
    country = Country.fromJson(countryCodes[200]);
    countryPicker = new CountryPicker(onCountrySelected: (selectedCountry) {
      setState(() {
        this.country = selectedCountry;
      });
    });
    textFont = new TextStyle(
      fontSize: 20,
    );
  }

  Widget getPrefixWidget(BuildContext context) {
    Row prefixIconRow = Row(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Container(
          height: 20,
          width: 20,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage(country.flagUri,
                  package: 'ola_like_country_picker'),
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.only(left: 3, right: 3),
        ),
        Text(
          "+" + country.dialCode,
          style: textFont,
        ),
        Icon(Icons.keyboard_arrow_down),
        Padding(
          padding: EdgeInsets.only(left: 3, right: 3),
        ),
      ],
    );
    return GestureDetector(
      child: prefixIconRow,
      onTap: () => _launchCountryPicker(context),
    );
  }

  Widget getSuffixWidget(BuildContext context) {
    return Icon(
      Icons.clear,
      color: Colors.grey,
    );
  }

  @override
  Widget build(BuildContext context) {
    double width = 300;
    double prefixWidth = 80;
    double suffixWidth = 20;

    Widget prefixWidget = getPrefixWidget(context);
    Widget suffixWidget = getSuffixWidget(context);

    return Material(
      child: Center(
        child: Stack(
          children: <Widget>[
            Row(
              children: <Widget>[
                Container(
                  child: TextField(
                    controller: _controller,
                    autofocus: true,
                    style: textFont,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                        hintText: 'Your number',
                        suffixIcon: suffixWidget,
                        prefixIcon: prefixWidget),
                  ),
                  width: width,
                ),
              ],
            ),
            Row(
              children: <Widget>[
                GestureDetector(
                  child: Container(
                    height: 50,
                    width: prefixWidth,
                    color: Colors.orange.withOpacity(0.5),
                  ),
                  onTap: () {
                    countryPicker.launch(context);
                  },
                ),
                SizedBox(
                  height: 50,
                  width: width - prefixWidth - suffixWidth,
                ),
                GestureDetector(
                  child: Container(
                    height: 50,
                    width: suffixWidth,
                    color: Colors.green.withOpacity(0.5),
                  ),
                  onTap: () {
                    _controller.clear();
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  _launchCountryPicker(BuildContext context) {
    countryPicker.launch(context);
  }
}
