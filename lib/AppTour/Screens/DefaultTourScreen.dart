
import 'package:flutter/material.dart';
import 'package:pro_logger/AppTour/Widgets/AppTourBottomCarousel.dart';
import 'package:pro_logger/AppTour/Widgets/ScreenWithSingleImageForAppTour.dart';

class DefaultTourScreen extends StatefulWidget
{
	final int noOfScreens;
	final int selectedCarouselIndex=0;
	
	const DefaultTourScreen({Key key, this.noOfScreens}) : super(key: key);
	
	
	@override
	State<StatefulWidget> createState() {
		return DefaultTourScreenState();
	}
	
}

class DefaultTourScreenState extends State<DefaultTourScreen>
{
	
	@override
	Widget build(BuildContext context) {
		return Center(
			child: Column(
				children: <Widget>[
					Padding(padding: EdgeInsets.all(5)),
					Container(
						child: ScreenWithSingleImageForAppTour(
								uri: 'https://media.idownloadblog.com/wp-content/uploads/2016/05/Seb-Home-screen-may-2016.png',),
						width: 1.0*MediaQuery.of(context).size.width,
						height: 0.92*MediaQuery.of(context).size.height,
					),
					Padding(padding: EdgeInsets.all(5)),
					AppTourBottomCarousel(
						noOfCarouselCircles:widget.noOfScreens ,
						selectedCarouselIndex: widget.selectedCarouselIndex,)
				],
			),
		);
	}
	
}