import 'package:flutter/material.dart';
import 'package:pro_logger/Auth/Repositories/auth_repository.dart';
import 'package:pro_logger/Entries/Screens/LogEntryListScreen.dart';
import 'package:pro_logger/ThemeManager/widgets/CustomThemeChangerWidget.dart';

import 'Auth/Screens/RegistrationScreenPartOne.dart';
import 'Auth/Screens/RegistrationScreenPartThree.dart';
import 'Auth/Screens/RegistrationScreenPartTwo.dart';
import 'Entries/Screens/home_screen.dart';
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
    storage.read(key: 'token').then((value){
      print(value);
    });
//    return MaterialApp(
//      home: Container(
//        color: Colors.yellowAccent,
//        alignment: Alignment.center,
//        child: Container(
//          color: Colors.amberAccent,
//          width: 300,
//          height: 200,
//          child: OTPField(
//            boxWidth: 40,
//            boxHeight: 40,
//          ),
//          alignment: Alignment.center,
//        ),
//      ),
//    );
    return MaterialApp(
      home: RegistrationScreenPartOne(),
      theme: CustomTheme.of(context),
      routes: {
        'phoneInputScreen': (context) => RegistrationScreenPartTwo(),
        'otpInputScreen': (context) => RegistrationScreenPartThree(),
        'HomeScreen': (context) => HomeScreen(),
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
