import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pro_logger/utility/LogLevel.dart';

class TopWaveClipper extends CustomClipper<Path> {
  List<List<double>> getListOfControlAndEndPoints(
      int noOfEndpoints, double endpointGapX, Size size) {
    List<List<double>> result = [
      [0, size.height, 0, 0]
    ];

    for (var i = 1; i < noOfEndpoints; i++) {
      var endPointX = 0 + endpointGapX * i;
//      var endPointY = size.height - (size.height / size.width) * endPointX;
      var slope = (size.height / size.width) + 0.22;
      var endPointY = size.height - slope * endPointX;
      var controlPointX = (endPointX + result.last[0]) / 2;
      var controlPointY = (endPointY + result.last[1]) / 2;
      if (i % 2 == 0)
        result.add([controlPointX, controlPointY + 20, endPointX, endPointY]);
      else
        result.add([
          controlPointX,
          controlPointY - 20,
          endPointX,
          endPointY,
        ]);
    }
    return result;
  }

  @override
  Path getClip(Size size) {
    var noOfEndpoints = 9;
    var distanceBetweenEndpointsXCords = size.width / (noOfEndpoints - 1);
    var controlAndEndpoints = getListOfControlAndEndPoints(
        noOfEndpoints, distanceBetweenEndpointsXCords, size);

    var path = Path();
    path.moveTo(0, size.height);

    for (var k = 1; k < controlAndEndpoints.length; k++) {
      path.quadraticBezierTo(
          controlAndEndpoints[k][0],
          controlAndEndpoints[k][1],
          controlAndEndpoints[k][2],
          controlAndEndpoints[k][3]);
    }
    path.lineTo(size.width, size.height);
//    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => true;
}

class RegistrationScreenPartOne extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Material(
      child: Container(
        color: white,
        height: MediaQuery.of(context).size.height,
        child: Column(
          children: <Widget>[
            Container(
              margin: EdgeInsets.only(top: 10),
            ),

            //App Icon and App name

            Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: const EdgeInsets.only(top: 30.0, left: 30),
                child: Image(
                  image: new AssetImage(
                    "images/applogo.png",
                  ),
                  width: 125,
                ),
              ),
            ),

            //CoverImage, and overlay Text
            Stack(
              children: <Widget>[
                ClipPath(
                  clipper: TopWaveClipper(),
                  child: Column(
                    children: <Widget>[
                      Container(height: 40),
                      Container(
                        height: 280,
                        padding: EdgeInsets.only(left: 15),
                        child: FittedBox(
                          child: Image(
                            image: new AssetImage(
                              "images/coverimage.png",
                            ),
                          ),
                          fit: BoxFit.fill,
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 8, right: 8, bottom: 30),
                  child: Text(
                    "welcome\naboard",
                    style: TextStyle(
                        color: Colors.black54,
                        fontSize: 50,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
