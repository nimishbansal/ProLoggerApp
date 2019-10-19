import 'package:flutter/material.dart';
import 'package:pro_logger/library_widgets/flutter_mobile_input.dart';
import 'package:pro_logger/utility/LogLevel.dart';

class RegistrationScreenPartOne extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Material(
      child: Container(
        color: white,
        height: MediaQuery.of(context).size.height + 20,
        child: Column(
          children: <Widget>[
            Container(
              margin: EdgeInsets.only(top: 10),
            ),

            //App Icon and App name
            Align(
              alignment: Alignment.center,
              child: Padding(
                padding: const EdgeInsets.only(top: 30.0),
                child: Image(
                  image: new AssetImage(
                    "images/applogo.png",
                  ),
                  width: 200,
                ),
              ),
            ),

            //CoverImage, and overlay Text
            Stack(
              children: <Widget>[
                Column(
                  mainAxisSize: MainAxisSize.max,
                  children: <Widget>[
                    Container(
                      padding: EdgeInsets.only(left: 15, right: 15),
                      child: Image(
                        width: MediaQuery.of(context).size.width,
                        image: AssetImage(
                          "images/image1.png",
                        ),
                      ),
                    ),

                  SizedBox(height: 0.02*MediaQuery.of(context).size.height,),
                    Container(
                      padding: EdgeInsets.only(left: 15, right: 15),
                      child: Image(
                        width: MediaQuery.of(context).size.width,
                        image: AssetImage(
                          "images/coverimage.png",
                        ),
                      ),
                    ),

                    SizedBox(height: 0.2*MediaQuery.of(context).size.height,),

                  ],
                ),
              ],
            ),
            //Mobile Input
            GestureDetector(
              child: AbsorbPointer(child: MobileInput(autofocus: false,)),
              onTap: () {
                print("whole widget tapped");
                Navigator.of(context).pushNamed('phoneInputScreen');
              },
            ),

          ],
        ),
      ),
    );
  }
}
