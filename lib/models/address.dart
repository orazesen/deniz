import 'package:google_maps_flutter/google_maps_flutter.dart';

class Address {
  Map<String, dynamic> address;
  List<String> phones;
  LatLng location;

  Address({this.address, this.phones, this.location});
}
