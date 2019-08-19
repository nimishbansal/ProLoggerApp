import 'package:flutter/foundation.dart';
class Country {
  final String name;
  final String code;
  final String dialCode;
  String extra;
  String flagPath = "";
  String prefix = "+";

  Country(
      {@required this.name,
      @required this.code,
      @required this.dialCode,
      this.extra,
      this.flagPath,
      this.prefix="+"});

  @override
  String toString() {
    return prefix + dialCode + code;
  }
}