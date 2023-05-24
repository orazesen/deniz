import 'package:flutter/material.dart';

class SizeConfig {
  static late double _screenWidth;
  static late double _screenHeight;
  static late double _blockWidth = 0;
  static late double _blockHeight = 0;

  static late double textMultiplier;
  static late double imageSizeMultiplier;
  static late double heightMultiplier;
  static late double widthMultiplier;
  static late bool isMobilePortrait = false;
  static late double borderRadius;

  void init(BoxConstraints constraints) {
    _screenWidth = constraints.maxWidth;
    _screenHeight = constraints.maxHeight;
    if (_screenWidth < 450) {
      isMobilePortrait = true;
    }
    _blockWidth = _screenWidth / 100;
    _blockHeight = _screenHeight / 100;

    textMultiplier = _blockHeight;
    imageSizeMultiplier = _blockWidth;
    heightMultiplier = _blockHeight;
    widthMultiplier = _blockWidth;
    borderRadius = 0.0;
  }
}
