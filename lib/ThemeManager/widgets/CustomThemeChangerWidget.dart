
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class _CustomThemeInheritedWidget extends InheritedWidget {
    final CustomThemeState data;

    _CustomThemeInheritedWidget({Key key, this.data, @required Widget child})
            : super(key: key, child: child);

    @override
    bool updateShouldNotify(_CustomThemeInheritedWidget oldWidget) {
        return true;
    }
}

class CustomTheme extends StatefulWidget {
    final Widget child;
    final ThemeData initialThemeData;

    const CustomTheme({Key key, this.child, this.initialThemeData})
            : super(key: key);
    @override
    State<StatefulWidget> createState() {
        return new CustomThemeState();
    }

    static ThemeData of(BuildContext context) {
        CustomThemeState customThemeState =
                (context.inheritFromWidgetOfExactType(_CustomThemeInheritedWidget)
                as _CustomThemeInheritedWidget)
                        .data;

        return customThemeState.themeData;
    }

    static CustomThemeState instanceOf(BuildContext context) {
        CustomThemeState customThemeState =
                (context.inheritFromWidgetOfExactType(_CustomThemeInheritedWidget)
                as _CustomThemeInheritedWidget)
                        .data;

        return customThemeState;
    }
}

class CustomThemeState extends State<CustomTheme> {
    ThemeData themeData;

    @override
    Widget build(BuildContext context) {
        return _CustomThemeInheritedWidget(
            data: this,
            child: widget.child,
        );
    }

    @override
    void initState() {
        themeData = widget.initialThemeData;
        super.initState();
    }

    void changeTheme(ThemeData newThemeData) {
        setState(() {
            print("changing theme from ${this.themeData.toString()}");
            print("\n\nchanged to ${newThemeData.toString()}");
            themeData = newThemeData;
        });
    }
}
