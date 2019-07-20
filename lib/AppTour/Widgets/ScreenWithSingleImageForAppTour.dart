
import 'package:flutter/material.dart';

class ScreenWithSingleImageForAppTour extends StatefulWidget
{
	final String uri;
	final int noOfScreens;
	final int currentIndex;
	
	const ScreenWithSingleImageForAppTour({Key key, this.uri, this.noOfScreens, this.currentIndex}) : super(key: key);
	
	@override
	State<StatefulWidget> createState() {
		return ScreenWithSingleImageForAppTourState();
	}
	
}

class ScreenWithSingleImageForAppTourState extends State<ScreenWithSingleImageForAppTour>
{
	@override
	Widget build(BuildContext context) {
		return Image.network(widget.uri);
	}
	
}