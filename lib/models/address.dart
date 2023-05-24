import 'package:google_maps_flutter/google_maps_flutter.dart';

class Address {
  Map<String, dynamic> address;
  List<String> phones;
  LatLng location;

  Address(
      {required this.address, required this.phones, required this.location});
}
