import 'dart:typed_data';

import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:deniz/constants/constants.dart';
import 'package:deniz/models/address.dart';
import 'package:deniz/models/coffee.dart';
import 'package:deniz/services/api.dart';
import 'package:deniz/utils/size_config.dart';

class CoffeeMenusController extends GetxController {
  RxList<Coffee>? _coffees;
  RxList<Address>? _addresses;
  int currentPage = 0;
  int lastPage = -1;
  Uint8List? markerIcond;

  CoffeeMenusController() {
    getIcon();
  }
  getIcon() async {
    // markerIcond = await getBytesFromCanvas(100, 100, Constants.ugurCoffee);
    markerIcond = await Constants.getBytesFromAsset(
        Constants.ugurCoffee, (SizeConfig.heightMultiplier * 18).toInt());
    // icon = BitmapDescriptor.fromAssetImage(
    //   ImageConfiguration(size: Size(12, 12)),
    //   Constants.ugurCoffee,
    // ) as BitmapDescriptor;
  }

  List<Coffee>? get coffees {
    if (_coffees == null) {
      _coffees = [] as RxList<Coffee>?;
    }
    return _coffees;
  }

  set coffees(List<Coffee>? cofs) {
    _coffees = RxList(cofs ?? []);
  }

  List<Address>? get addresses {
    if (_addresses == null) {
      _addresses = [] as RxList<Address>?;
    }
    return _addresses;
  }

  set addresses(List<Address>? adds) {
    _addresses = RxList(adds ?? []);
  }

  Future<List<Coffee>> setInitials() async {
    final List<Coffee> temp = [];
    final RxList<Address> tempAddresses = RxList();
    // print('current page: $currentPage');
    // print('last page page: $lastPage');
    try {
      if (lastPage != -1) {
        if (currentPage == lastPage) {
          return _coffees ?? [];
        }
      }

      final data = await Api.getCoffeeInitials(currentPage + 1);
      final cat = data[0].data['data'] as List;
      final s = data[0].data['links']['last'].toString().split('=')[1];
      lastPage = int.parse(s);
      // final location = data[1].data;
      // print('location at 0: ' + location[0]);
      cat.forEach(
        (element) {
          final Coffee item = Coffee(
            id: element['id'],
            imgUrl: element['img_url'],
            thumpUrl: element['thumb_url'],
            ingredients: element['ingredients'] == null ||
                    element['ingredients'].length <= 0
                ? {'en': '', 'ru': '', 'tk': ''}
                : element['ingredients'],
            name: element['name'] == null || element['name'].length <= 0
                ? {'en': '', 'ru': '', 'tk': ''}
                : element['name'],
            price: element['price'] == null || element['price'].length <= 0
                ? {'s': '', 'm': '', 'l': ''}
                : element['price'],
          );
          temp.add(item);
        },
      );

      // if (_addresses == null || _addresses.length <= 0) {
      data[1].data.forEach(
        (element) {
          List<String> phones = [];

          element['phones'].forEach((element) {
            phones.add(element);
          });

          final Address address = Address(
            address:
                element['address'] == null || element['address'].length <= 0
                    ? {
                        'en': '',
                        'tk': '',
                        'ru': '',
                      }
                    : element['address'],
            phones: phones,
            // element['phones'],
            // == null || element['phones'].length <= 0
            //     ? []
            //     : element['phones'],
            location: element['location'] != ''
                ? LatLng(double.parse(element['location'].split(',')[0]),
                    double.parse(element['location'].split(',')[1]))
                : LatLng(37.922094, 58.389572),
          );
          tempAddresses.add(address);
        },
      );
      // }
      if (_coffees == null) {
        _coffees = RxList();
      }
      if (_addresses == null) {
        _addresses = RxList();
      }
      _addresses = tempAddresses;
      currentPage++;
      // print('current page: $currentPage');
      // print('done!');

      _coffees?.addAll(temp);

      return _coffees ?? [];
    } catch (e) {
      print('error');
      throw (e);
    }
  }
}
