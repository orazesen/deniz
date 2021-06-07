import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:deniz/constants/constants.dart';
import 'package:deniz/models/coffee.dart';
import 'package:deniz/pages/coffee_detail_page.dart';
import 'package:deniz/style/my_colors.dart';
import 'package:deniz/style/text_styles.dart';
import 'package:deniz/utils/size_config.dart';

class CoffeeGridItem extends StatelessWidget {
  final Coffee coffee;
  final bool isEffect;
  final int index;

  CoffeeGridItem({this.coffee, this.isEffect = false, this.index});

  @override
  Widget build(BuildContext context) {
    final String locale =
        Get.locale.languageCode == 'tr' ? 'tk' : Get.locale.languageCode;
    return GestureDetector(
      onTap: () {
        if (isEffect) return;
        Get.toNamed(
          CoffeeDetail.routeName, arguments: coffee,
          // CoffeeDetail(
          //   coffee: coffee,
          // ),
        );
      },
      child: Container(
        margin: EdgeInsets.fromLTRB(
          index % 2 == 0
              ? SizeConfig.widthMultiplier * 4
              : SizeConfig.widthMultiplier * 2,
          SizeConfig.widthMultiplier,
          index % 2 == 1
              ? SizeConfig.widthMultiplier * 4
              : SizeConfig.widthMultiplier * 2,
          SizeConfig.widthMultiplier * 3,
        ),
        decoration: BoxDecoration(
          color: MyColors.background,
          borderRadius: BorderRadius.circular(
            SizeConfig.borderRadius,
          ),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(
            SizeConfig.borderRadius,
          ),
          child: isEffect
              ? Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(
                      SizeConfig.borderRadius,
                    ),
                    color: Colors.grey,
                  ),
                )
              : Stack(
                  alignment: Alignment.topCenter,
                  children: [
                    Align(
                      alignment: Alignment.topCenter,
                      child: Padding(
                        padding: EdgeInsets.only(
                            top: SizeConfig.heightMultiplier * 2),
                        child: FadeInImage(
                          placeholder: AssetImage(Constants.coffeePlaceholder),
                          fit: BoxFit.scaleDown,
                          height: SizeConfig.widthMultiplier * 30,
                          image: NetworkImage(
                            coffee.imgUrl,
                          ),
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: SizeConfig.widthMultiplier * 3,
                          vertical: SizeConfig.heightMultiplier,
                        ),
                        child: Text(
                          coffee.name[locale] ?? coffee.name['tk'],
                          textAlign: TextAlign.center,
                          style: TextStyles.menu.copyWith(
                            fontSize: SizeConfig.textMultiplier * 1.6,
                            fontWeight: FontWeight.w600,
                            color: MyColors.darkGreen,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}
