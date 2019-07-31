import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'ThemeChangerInheritedWidget.dart';

class LayoutThemeContainer extends StatefulWidget {
  final Widget child;

  const LayoutThemeContainer({Key key, @required this.child}) : super(key: key);

  @override
  LayoutThemeState createState() => LayoutThemeState();

  static LayoutThemeState of(BuildContext context) {
    return (context.inheritFromWidgetOfExactType(InheritedStateContainer)
            as InheritedStateContainer)
        .data;
  }
}

class LayoutThemeState extends State<LayoutThemeContainer> {
  double get spacingUnit => 10.0;

  @override
  Widget build(BuildContext context) {
    return new InheritedStateContainer(
      data: this,
      child: widget.child,
    );
  }
}
