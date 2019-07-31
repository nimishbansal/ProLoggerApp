import 'package:flutter/widgets.dart';

import 'ThemeSwitcherWidget.dart';

class InheritedStateContainer extends InheritedWidget {
  final LayoutThemeState data;

  InheritedStateContainer({
                             Key key,
                             @required this.data,
                             @required Widget child,
                           }) : super(key: key, child: child);

  @override
  bool updateShouldNotify(InheritedStateContainer old) => true;
}