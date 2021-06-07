import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:saray_pub/models/info_window_model.dart';
// import '';

class CustomInfoWindow extends StatefulWidget {
  @override
  _CustomInfoWindowState createState() => _CustomInfoWindowState();
}

class _CustomInfoWindowState extends State<CustomInfoWindow> {
  final LatLng center = LatLng(33, 33);
  final double zoom = 15;
  final double _infoWindowWidth = 200;
  final double _marketOffset = 170;

  GoogleMapController _mapController;
  Set<Marker> _markers = Set<Marker>();

  Map<String, dynamic> list;
  @override
  Widget build(BuildContext context) {
    final providerObject = Provider.of<InfoWindowModel>(context, listen: false);

    list.forEach((key, value) {
      _markers.add(
        Marker(
            markerId: MarkerId(
              value.location,
            ),
            position: value.location,
            onTap: () {
              providerObject.updateInfowindow(
                context,
                _mapController,
                value.location,
                _infoWindowWidth,
                _marketOffset,
              );

              providerObject.updateLocation(value);
              providerObject.updateVisibility(true);
              providerObject.rebuildInfowindow();
            }),
      );
    });
    return Scaffold(
      body: Container(
        child: Consumer(
          builder: (context, model, child) => Stack(
            children: [
              child,
              Positioned(
                child: Visibility(
                  visible: providerObject.showInfoWindow,
                  child: (providerObject.location == null ||
                          !providerObject.showInfoWindow)
                      ? Container()
                      : Container(
                          margin: EdgeInsets.only(
                            left: providerObject.leftMargin,
                            top: providerObject.topMargin,
                          ),
                          child: Column(
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5),
                                ),
                                height: 115,
                                width: 250,
                                padding: EdgeInsets.all(15),
                                child: Row(children: [
                                  Text(
                                    'fuck you',
                                  ),
                                ]),
                              ),
                              // Triangle
                            ],
                          ),
                        ),
                ),
              ),
            ],
          ),
          child: Positioned(
            child: GoogleMap(
              onMapCreated: (GoogleMapController controller) {
                _mapController = controller;
              },
              initialCameraPosition: CameraPosition(
                zoom: zoom,
                target: center,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
