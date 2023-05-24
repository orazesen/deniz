import 'package:flutter/material.dart';

import '../utils/size_config.dart';
import 'my_theme.dart';
import 'my_colors.dart';

class TextStyles {
  late MyTheme theme;
  TextStyles(MyTheme theme) {
    this.theme = theme;
  }

// All titles
  static TextStyle title = TextStyle(
    color: Colors.black,
    fontSize: SizeConfig.textMultiplier * 3, //SizeConfig.textMultiplier * 3.6,
    fontWeight: FontWeight.w800,
  );

  static TextStyle orderCount = TextStyle(
    color: Colors.black,
    fontSize: SizeConfig.textMultiplier * 2.6,
  );

// All category texts
  static TextStyle header = TextStyle(
    color: Colors.black,
    fontSize: SizeConfig.textMultiplier * 2.8,
    fontWeight: FontWeight.w600,
  );

// All header texts
  static TextStyle menu = TextStyle(
    fontSize: SizeConfig.textMultiplier * 2, //SizeConfig.textMultiplier * 2.7,
    color: MyColors.white,
  );

  static TextStyle priceDetail = TextStyle(
    fontWeight: FontWeight.w600,
    fontSize: SizeConfig.textMultiplier * 1.8,
    color: Colors.black,
  );

  static TextStyle button = TextStyle(
    fontSize: SizeConfig.textMultiplier * 1.7,
    fontWeight: FontWeight.w700,
    color: MyColors.white,
  );

// All medium sized texts
  static TextStyle body = TextStyle(
    fontSize: SizeConfig.textMultiplier * 1.8,
    fontWeight: FontWeight.w600,
    color: Colors.black,
  );

  static TextStyle coffeeHint = TextStyle(
    fontSize: SizeConfig.textMultiplier * 1.7,
    color: Colors.black,
  );

  static TextStyle detail = TextStyle(
    fontSize: SizeConfig.textMultiplier * 1.4,
    color: Colors.black,
  );

  static TextStyle coffeeMenu = TextStyle(
    fontSize: SizeConfig.textMultiplier * 1.6,
    color: Colors.black,
  );

// Very tiny texts like language
  static TextStyle small = TextStyle(
    fontSize: SizeConfig.textMultiplier * 1.2,
    fontWeight: FontWeight.w800,
    color: Colors.black,
  );
  static TextStyle tiny = TextStyle(
    fontSize: SizeConfig.textMultiplier * 1.4,
    color: Colors.black,
  );
}
