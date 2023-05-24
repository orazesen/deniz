import 'package:flutter/material.dart';
import '../utils/size_config.dart';
import './text_styles.dart';
import '../style/my_colors.dart';

class MyTheme {
  static ThemeData lightTheme = ThemeData(
    scaffoldBackgroundColor: MyColors.white,
    brightness: Brightness.light,
    primaryColor: MyColors.white,
    backgroundColor: MyColors.background,
    iconTheme: IconThemeData(
      color: MyColors.darkGreen,
    ),
    fontFamily: 'Montserrat',
    floatingActionButtonTheme:
        FloatingActionButtonThemeData(backgroundColor: MyColors.darkGreen),
    buttonTheme: ButtonThemeData(
      buttonColor: MyColors.darkGreen,
      height: SizeConfig.heightMultiplier * 7,
      shape: shapeBorder,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all(
          MyColors.darkGreen,
        ),
        shape: MaterialStateProperty.all(
          shapeBorder,
        ),
        minimumSize: MaterialStateProperty.all(
          Size(
            double.infinity,
            SizeConfig.heightMultiplier * 7,
          ),
        ),
      ),
    ),
    cardTheme: CardTheme(
      color: MyColors.background,
      shape: shapeBorder,
    ),
    dialogTheme: DialogTheme(
      backgroundColor: MyColors.background,
      contentTextStyle: TextStyles.small,
      titleTextStyle: TextStyles.body,
      shape: shapeBorder,
    ),
    errorColor: MyColors.darkGreen,
    // inputDecorationTheme: lightInputTheme,
    unselectedWidgetColor: MyColors.white,
    appBarTheme: AppBarTheme(
      color: MyColors.white,
      elevation: 3,
      iconTheme: IconThemeData(color: MyColors.darkGreen),
    ),
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: MyColors.background,
      type: BottomNavigationBarType.fixed,
      selectedItemColor: MyColors.darkGreen,
      unselectedItemColor: MyColors.iconInactive,
      elevation: 10.0,
    ),
    bottomSheetTheme: BottomSheetThemeData(
      backgroundColor: MyColors.background,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(
            SizeConfig.borderRadius,
          ),
        ),
      ),
    ),
  );

  static OutlinedBorder shapeBorder = RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(
      SizeConfig.borderRadius,
    ),
  );

  static InputDecorationTheme lightInputTheme = InputDecorationTheme(
    enabledBorder: lightInputBorder,
    focusedBorder: lightInputBorder,
    fillColor: MyColors.white,
    contentPadding: EdgeInsets.all(SizeConfig.textMultiplier * 2.4),
    floatingLabelBehavior: FloatingLabelBehavior.never,
    labelStyle: TextStyles.body,
    hintStyle: TextStyles.body,
    prefixStyle: TextStyles.body,
    suffixStyle: TextStyles.body,
    counterStyle: TextStyles.small,
    helperStyle: TextStyles.body,
    isDense: true,
    border: lightInputBorder,
    filled: true,
  );

  static InputDecorationTheme darkInputTheme = lightInputTheme.copyWith(
    enabledBorder: darkInputBorder,
    focusedBorder: darkInputBorder,
    fillColor: MyColors.white,
    border: darkInputBorder,
    filled: true,
  );

  static InputBorder lightInputBorder = OutlineInputBorder(
    borderSide: BorderSide(
      color: MyColors.darkGreen,
      width: 0.5,
    ),
    borderRadius: BorderRadius.circular(
      SizeConfig.borderRadius,
    ),
  );

  static InputBorder darkInputBorder = OutlineInputBorder(
    borderSide: BorderSide(
      color: Colors.transparent,
      width: 0.5,
    ),
    borderRadius: BorderRadius.circular(
      SizeConfig.borderRadius,
    ),
  );
}
