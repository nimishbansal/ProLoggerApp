import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class AppTourBottomCarousel extends StatefulWidget {
	final int noOfCarouselCircles;
	final int selectedCarouselIndex;
	
	const AppTourBottomCarousel(
		{Key key,
			this.noOfCarouselCircles,
			this.selectedCarouselIndex}) : super(key: key);
	
	@override
	State<StatefulWidget> createState() {
		return AppTourBottomCarouselState();
	}
}

class AppTourBottomCarouselState extends State<AppTourBottomCarousel> {
	Widget build(BuildContext context) {
		List<Widget> carouselCircles = List<Widget>();
		for (int i = 0; i < widget.noOfCarouselCircles; i++) {
			carouselCircles.add(
				new Container(
					width: 10,
					height: 10,
					margin: EdgeInsets.all(6),
					decoration: BoxDecoration(
						shape: BoxShape.circle,
						color: (i==widget.selectedCarouselIndex) ? Colors.pinkAccent : null,
						border: Border.all(color: Colors.pinkAccent)),
				));
			
		}
		return Center(
			child: Container(
				child: Row(
					children: carouselCircles,
					mainAxisAlignment: MainAxisAlignment.center,
				),
				
			),
		);
	}
}
