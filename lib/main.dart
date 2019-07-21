import 'package:flutter/material.dart';
import 'package:pro_logger/AppTour/Screens/DefaultTourScreen.dart';
import 'package:pro_logger/AppTour/Widgets/AppTourBottomCarousel.dart';
import 'package:pro_logger/AppTour/Widgets/ScreenWithSingleImageForAppTour.dart';
import 'package:pro_logger/utility/logging_utils.dart';

void main() => runApp(MyApp());

class Choice
{
	final title,icon;
	
	const Choice({this.title, this.icon});
}


class MyApp extends StatelessWidget {
	// This widget is the root of your application.
	@override
	Widget build(BuildContext context) {
		return MaterialApp(
			title: 'Flutter Demo',
			theme: ThemeData(
//        primarySwatch: Colors.blue,
				primaryColor:red
			),
			home: DefaultTourScreen(noOfScreens: 5,),
//			home: ScreenWithSingleImageForAppTour(
//				uri: "https://media.idownloadblog.com/wp-content/uploads/2016/05/Seb-Home-screen-may-2016.png",
//				noOfScreens: 1,
//				currentIndex: 0,
//			)
		);
	}
}
