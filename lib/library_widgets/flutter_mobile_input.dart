import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ola_like_country_picker/ola_like_country_picker.dart';

class MobileInput extends StatefulWidget {
  /// Boolean to set [TextField.autofocus].
  ///
  /// Default to True
  final bool autofocus;

  /// Called when the TextField widget is tapped.
  final VoidCallback onTap;

  final bool focusOnTap;

  const MobileInput({Key key, this.autofocus = true, this.onTap, this.focusOnTap=true})
      : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _MobileInputState();
  }
}

class _MobileInputState extends State<MobileInput> {
  final _controller = TextEditingController(text: "");
  CountryPicker countryPicker;
  final _focusNode = FocusNode();
  bool _prefixTappedFlag = false;
  bool _suffixTappedFlag = false;
  bool _submittedFlag = false;

  Country country;

  void initState() {
    super.initState();
    country = Country.fromJson(countryCodes[0]);
    countryPicker = CountryPicker(onCountrySelected: (Country country) {
      setState(() {
        this.country = country;
      });
      setFocusWithKeyboard();
    });
    _focusNode.addListener(() {
      print("event found with focus ${_focusNode.hasFocus}");
      if ((_focusNode.hasFocus && _prefixTappedFlag) ||
          (_focusNode.hasFocus && _suffixTappedFlag)) {
        if (!_submittedFlag) {
          print("unfocussing");
          _focusNode.unfocus();
        }
      }
      print("event end with focus ${_focusNode.hasFocus}");
      // reset all flags
      _prefixTappedFlag = false;
      _suffixTappedFlag = false;
      _submittedFlag = false;
    });
  }

  Widget getTextFieldPrefixIconWidget() {
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
          style: TextStyle(fontSize: 20),
        ),
        Icon(
          Icons.keyboard_arrow_down,
          color: Colors.grey,
        ),
        Padding(
          padding: EdgeInsets.only(left: 3, right: 3),
        ),
      ],
    );
    GestureDetector prefixWidget = GestureDetector(
        child: prefixIconRow,
        onTap: () {
          _prefixTappedFlag = true;
          removeFocus();
          countryPicker.launch(context);
        });
    return prefixWidget;
  }

  Widget getTextFieldSuffixIconWidget() {
    GestureDetector suffixWidget = GestureDetector(
        child: Container(
            child: Icon(
          Icons.clear,
          color: Colors.grey,
        )),
        onTap: () {
          _suffixTappedFlag = true;
          WidgetsBinding.instance
              .addPostFrameCallback((_) => _controller.clear());
        });
    return suffixWidget;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 300,
      child: TextField(
        autofocus: widget.autofocus,
        onSubmitted: (String val) => _handleSubmitPressed(val, context),
        style: TextStyle(fontSize: 20),
        keyboardType: TextInputType.numberWithOptions(),
        controller: _controller,
        focusNode: _focusNode,
        decoration: InputDecoration(
          hintText: 'Your Number',
          focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.blue, width: 2)),
          enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.blue, width: 2)),
          prefixIcon: getTextFieldPrefixIconWidget(),
          suffixIcon: getTextFieldSuffixIconWidget(),
        ),
      ),
    );
  }

  void _handleSubmitPressed(String value, BuildContext context) {
    _submittedFlag = true;
    setFocusWithoutKeyboard();
  }

  setFocusWithoutKeyboard() {
    print("START: setFocusWithoutKeyboard()");
    print("on submit focus node has focus=${_focusNode.hasFocus}");
    FocusScope.of(context).requestFocus(_focusNode);
    print("executed");
    WidgetsBinding.instance.addPostFrameCallback(
        (_) => SystemChannels.textInput.invokeMethod('TextInput.hide'));
    print("hidden keyboard");
    print("END: setFocusWithoutKeyboard()");
  }

  setFocusWithKeyboard() {
    print("START: in setting focus with keyboard");
    FocusScope.of(context).requestFocus(_focusNode);
    print("END: setting focus without keyboard");
  }

  removeFocus() {
    print("START: removeFocus()");
    _focusNode.unfocus();
    print("END: removeFocus()");
  }

}
