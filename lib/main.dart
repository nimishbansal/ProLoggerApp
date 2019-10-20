import 'package:flutter/material.dart';
import 'package:pro_logger/Entries/Screens/LogEntryListScreen.dart';
import 'package:pro_logger/ThemeManager/widgets/CustomThemeChangerWidget.dart';

import 'Auth/Screens/RegistrationScreenPartOne.dart';
import 'Auth/Screens/RegistrationScreenPartThree.dart';
import 'Auth/Screens/RegistrationScreenPartTwo.dart';
import 'Entries/widgets/LogLevelSelectModal.dart';
import 'library_widgets/otp_field.dart';

void main() => runApp(CustomTheme(
      child: MyApp(),
      initialThemeData:
          ThemeData(primaryColor: Color(0xFFFFFF).withAlpha(0xFF)),
    ));

class Choice {
  final title, icon;

  const Choice({this.title, this.icon});
}

class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: RaisedButton(
          child: Text('Open Dialog'),
          onPressed: () {
            showDialog(
              context: context,
              builder: (_) => LogLevelSelectModalWidget(),
            );
          },
        ),
      ),
    );
  }
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: OTPField2()
    );
    return MaterialApp(
      home: RegistrationScreenPartOne(),
      theme: CustomTheme.of(context),
      routes: {
        'phoneInputScreen': (context) => RegistrationScreenPartTwo(),
        'otpInputScreen': (context) => RegistrationScreenPartThree(),
      },
    );
    return MaterialApp(
      title: 'Flutter Demo',
      initialRoute: 'logEntryList',
      routes: {'logEntryList': (context) => LogEntryListScreen()},
      theme: CustomTheme.of(context),
    );
  }
}
