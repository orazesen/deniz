import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:path/path.dart';
import 'package:saray_pub/constants/constants.dart';
import 'package:saray_pub/models/coffee.dart';
import 'package:saray_pub/pages/coffee_detail_page.dart';
import 'package:saray_pub/pages/product_detail.dart';
import 'package:saray_pub/style/my_colors.dart';
import 'package:saray_pub/style/text_styles.dart';
import 'package:saray_pub/utils/size_config.dart';
import '../controllers/main_page_controller.dart';

import '../models/category_item.dart';
import '../pages/menu.dart';

class CoffeeGridItem extends StatelessWidget {
  final Coffee coffee;
  final bool isEffect;
  final int index;

  CoffeeGridItem({this.coffee, this.isEffect = false, this.index});
  final MainPageController _mainPageController = Get.find();

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
