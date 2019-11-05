import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pro_logger/library_widgets/flutter_mobile_input.dart';
import 'package:pro_logger/utility/LogLevel.dart';
import 'dart:math';

class RegistrationScreenPartOne extends StatelessWidget {

  @override
  StatelessElement createElement() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp
    ]);
    return super.createElement();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Container(
        color: white,
        height: MediaQuery.of(context).size.height+20,
        child: Column(
          children: <Widget>[
            Container(
              margin: EdgeInsets.only(top: 10),
            ),

            //App Icon and App name
            Align(
              alignment: Alignment.center,
              child: Container(
                padding: const EdgeInsets.only(top: 20.0,),
                child: Image(
                  image: new AssetImage(
                    "images/applogo.png",
                  ),
                  width: 0.5*MediaQuery.of(context).size.width,
                  height: 0.5*MediaQuery.of(context).size.width,
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
                        width: 0.75*MediaQuery.of(context).size.width,
                        image: AssetImage(
                          "images/image1.png",
                        ),
                      ),
                    ),

                  SizedBox(height: 0.5*sqrt(MediaQuery.of(context).size.height,)),
                    Container(
                      padding: EdgeInsets.only(left: 15, right: 15),
                      child: Image(
                        width: MediaQuery.of(context).size.width,
                        image: AssetImage(
                          "images/coverimage.png",
                        ),
                      ),
                    ),

                    SizedBox(height: 0.04*MediaQuery.of(context).size.height,),

                  ],
                ),
              ],
            ),
            //Mobile Input

            Expanded(
              child: Container(
                  padding: EdgeInsets.only(bottom: 0.03*MediaQuery.of(context).size.height),
                  alignment: Alignment.bottomCenter,
                child: GestureDetector(
                  child: AbsorbPointer(child: MobileInput(autofocus: false,)),
                  onTap: () {
                    print("whole widget tapped");
                    Navigator.of(context).pushNamed('phoneInputScreen');
                  },
                ),
              ),
            ),

          ],
        ),
      ),
    );
  }
}
