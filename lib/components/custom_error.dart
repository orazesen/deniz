import 'package:flutter/material.dart';
import '../style/my_colors.dart';
import '../style/text_styles.dart';
import '../utils/size_config.dart';

class CustomError extends StatelessWidget {
  final String message;
  final void Function()? callback;
  final String actionMessage;
  final IconData iconName;
  CustomError(
      {required this.message,
      required this.callback,
      required this.actionMessage,
      required this.iconName});
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Icon(
            Icons.remove_shopping_cart_sharp,
            color: MyColors.darkGreen,
            size: SizeConfig.heightMultiplier * 7,
          ),
          // SvgPicture.asset(
          //   iconName,
          //   color: MyColors.darkGreen,
          //   height: SizeConfig.heightMultiplier * 5,
          // ),
          SizedBox(
            height: SizeConfig.heightMultiplier,
          ),
          Text(
            message,
            style: TextStyles.button.copyWith(
              color: MyColors.iconInactive,
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(
            height: SizeConfig.heightMultiplier * 2,
          ),
          callback == null
              ? Container()
              : Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: SizeConfig.widthMultiplier * 1,
                  ),
                  child: ElevatedButton(
                    style: ButtonStyle(
                      elevation: MaterialStateProperty.all(0),
                    ),
                    onPressed: callback,
                    child: Center(
                      child: Text(actionMessage, style: TextStyles.button),
                    ),
                  ),
                ),
          SizedBox(
            height: callback == null ? SizeConfig.heightMultiplier * 19 : 0,
          ),
        ],
      ),
    );
  }
}
