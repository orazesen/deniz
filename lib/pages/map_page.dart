import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:deniz/utils/size_config.dart';

class MapPage extends StatelessWidget {
  static String routeName = '/mapPage';
  @override
  Widget build(BuildContext context) {
    colorize();
    return WillPopScope(
      onWillPop: () async {
        return decolorize();
      },
      child: Scaffold(
        body: Stack(
          children: [
            GoogleMap(
              initialCameraPosition: CameraPosition(
                target: LatLng(37.922094, 58.389572),
                zoom: 16,
              ),
              markers: {},
              compassEnabled: true,
              gestureRecognizers: Set()
                ..add(
                  Factory<PanGestureRecognizer>(
                    () => PanGestureRecognizer(),
                  ),
                )
                ..add(
                  Factory<ScaleGestureRecognizer>(
                    () => ScaleGestureRecognizer(),
                  ),
                )
                ..add(
                  Factory<TapGestureRecognizer>(
                    () => TapGestureRecognizer(),
                  ),
                )
                ..add(
                  Factory<VerticalDragGestureRecognizer>(
                    () => VerticalDragGestureRecognizer(),
                  ),
                ),
            ),
            Positioned(
              top: SizeConfig.heightMultiplier * 2,
              child: IconButton(
                icon: Icon(
                  Icons.clear,
                ),
                onPressed: () {
                  decolorize();
                  Get.back();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  colorize() {
    // FlutterStatusbarcolor.setStatusBarWhiteForeground(false);
    // FlutterStatusbarcolor.setStatusBarColor(Colors.transparent);
  }

  decolorize() {
    // FlutterStatusbarcolor.setStatusBarWhiteForeground(false);
    // FlutterStatusbarcolor.setStatusBarColor(Colors.white);
    Get.back();
  }
}
