import 'package:dartis/dartis.dart';
import 'package:flutter/material.dart';
import 'package:pro_logger/Auth/Repositories/auth_repository.dart';
import 'package:pro_logger/Entries/Screens/LogEntryListScreen.dart';
import 'package:pro_logger/ThemeManager/widgets/CustomThemeChangerWidget.dart';

import 'Auth/Screens/RegistrationScreenPartOne.dart';
import 'Auth/Screens/RegistrationScreenPartThree.dart';
import 'Auth/Screens/RegistrationScreenPartTwo.dart';
import 'Entries/Screens/project_detail.dart';
import 'Entries/Screens/project_list.dart';
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
  void hmm() async {
//    final client = await Client.connect('redis://192.168.0.107:6379');
//    print(client.toString());
//    final commands = client.asCommands();
//    commands.set("mynumber", "1234");
//    final pubsub = await PubSub.connect<String, String>("redis://192.168.0.107:6379");
//    pubsub.psubscribe(pattern: "onChat"+"81a8d8783d8737a59cb684e47428d4acba33de87");
//    pubsub.stream.listen((data) {
//      print(data.toString());
//    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: RegistrationScreenPartOne(),
      theme: CustomTheme.of(context),
//      initialRoute: 'phoneInputScreen',
      routes: {
        'phoneInputScreen': (context) => RegistrationScreenPartTwo(),
        'otpInputScreen': (context) => RegistrationScreenPartThree(),
        'HomeScreen': (context) => ProjectsListScreen(),
        'ProjectDetailScreen': (context) => ProjectDetailScreen(),
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
