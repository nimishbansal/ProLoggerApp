import 'dart:ui';

import 'package:flutter/material.dart';

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
                result.add(
                        [controlPointX, controlPointY - 10, endPointX, endPointY - 15]);
            else
                result.add([
                    controlPointX,
                    controlPointY - 15,
                    endPointX - 10,
                    endPointY + 15,
                ]);
        }
        return result;
    }

    @override
    Path getClip(Size size) {
        var noOfEndpoints = 4;
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
