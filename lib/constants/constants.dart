import 'dart:async';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/services.dart';

class Constants {
  //Prefs
  static String language = 'Language';
  static String phoneNumber = 'phoneNumber';
  static String address = 'adress';
  static String additional = 'additional';
  static String username = 'username';
  static String fileLocations = 'fileLocations';

  //icons and images
  static String addressIcon = 'assets/icons/address_icon.svg';
  static String basket = 'assets/icons/basket.svg';
  static String call = 'assets/icons/call.svg';
  static String coffee = 'assets/icons/coffee.svg';
  static String coffeeComingSoon = 'assets/icons/coming_soon_coffee.svg';
  static String deliverCost = 'assets/icons/deliver_fee.svg';
  static String delivery = 'assets/icons/delivery.svg';
  static String direction = 'assets/icons/direction.svg';
  static String dropdownArrow = 'assets/icons/dropdown_arrow.svg';
  static String basketEmpty = 'assets/icons/empty_basket.svg';
  static String favoriteEmpty = 'assets/icons/empty_favorite.svg';
  static String favoriteBorder = 'assets/icons/favorite_border.svg';
  static String favoriteFill = 'assets/icons/favorite_fill.svg';
  // static String favorite = 'assets/icons/favorite.svg';
  static String filter = 'assets/icons/filter.svg';
  static String global = 'assets/icons/global.svg';
  static String info = 'assets/icons/info.svg';
  static String location = 'assets/icons/location.svg';
  static String logo = 'assets/icons/logo.svg';
  static String menu = 'assets/icons/menu.svg';
  static String internetError = 'assets/icons/no_internet.svg';
  static String order = 'assets/icons/order.svg';
  static String profile = 'assets/icons/profile.svg';
  static String time = 'assets/icons/time.svg';
  static String placeholder = 'assets/images/placeholder.png';
  static String placeholderMini = 'assets/images/placeholder_mini.png';
  static String coffeePlaceholder = 'assets/images/coffee_placeholder.png';
  static String ugurCoffee = 'assets/icons/ugur_coffee.png';

  static Future<Uint8List> getBytesFromAsset(String path, int width) async {
    ByteData data = await rootBundle.load(path);
    ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(),
        targetWidth: width);
    ui.FrameInfo fi = await codec.getNextFrame();
    return (await fi.image.toByteData(format: ui.ImageByteFormat.png))!
        .buffer
        .asUint8List();
  }
}
