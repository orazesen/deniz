import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:deniz/constants/constants.dart';
import 'package:deniz/style/my_colors.dart';
import 'package:deniz/style/text_styles.dart';
import 'package:deniz/utils/size_config.dart';
import '../controllers/main_page_controller.dart';

import '../models/category_item.dart';
import '../pages/menu.dart';

class GridItem extends StatelessWidget {
  final CategoryItem? mainCategory;
  final bool isEffect;
  final int index;

  GridItem({this.mainCategory, this.isEffect = false, required this.index});
  final MainPageController _mainPageController = Get.find();
  late String locale;

  @override
  Widget build(BuildContext context) {
    if (Get.locale != null)
      locale =
          Get.locale!.languageCode == 'tr' ? 'tk' : Get.locale!.languageCode;
    return GestureDetector(
      onTap: () {
        if (isEffect) return;
        _mainPageController.mainPage = Menu(id: mainCategory!.id);
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
                  children: [
                    FadeInImage(
                      placeholder: AssetImage(Constants.placeholderMini),
                      fit: BoxFit.cover,
                      image: NetworkImage(
                        mainCategory!.imageUrl,
                      ),
                      width: double.infinity,
                      height: double.infinity,
                    ),
                    Positioned(
                      bottom: 0.0,
                      left: 0.0,
                      right: 0.0,
                      child: Container(
                        padding: EdgeInsets.all(
                          SizeConfig.widthMultiplier,
                        ),
                        decoration: BoxDecoration(
                          color: MyColors.darkGreen,
                        ),
                        alignment: Alignment.centerLeft,
                        height: SizeConfig.heightMultiplier * 4,
                        child: Text(
                          mainCategory!.name[locale] ??
                              mainCategory!.name['tk'],
                          textAlign: TextAlign.left,
                          style: TextStyles.menu.copyWith(
                            fontSize: SizeConfig.textMultiplier * 1.6,
                            fontWeight: FontWeight.w600,
                            color: MyColors.white,
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
