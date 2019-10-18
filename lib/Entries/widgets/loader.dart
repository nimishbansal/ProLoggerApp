import 'package:flutter/material.dart';

class Loader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Image(
      image: new AssetImage("images/loader.gif"),
    );
  }
}
