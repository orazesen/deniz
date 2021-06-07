import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:deniz/components/custom_error.dart';
import 'package:deniz/controllers/categories_controller.dart';
import 'package:deniz/style/text_styles.dart';

import '../components/menu_list.dart';
import '../style/my_colors.dart';
import '../utils/size_config.dart';
import '../controllers/menus_controller.dart';
import '../pages/main_page.dart';
import '../controllers/main_page_controller.dart';

class Menu extends StatelessWidget {
  static String routeName = '/menu';
  final int id;
  Menu({this.id = 0});

  final MenusController _menusController = Get.find();
  final CategoriesController _categoriesController = Get.find();

  @override
  Widget build(BuildContext context) {
    // SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark.copyWith(
    //   statusBarColor: Colors.black,
    //   /* set Status bar color in Android devices. */

    //   statusBarIconBrightness: Brightness.light,
    //   /* set Status bar icons color in Android devices.*/

    //   statusBarBrightness: Brightness.light,
    // ) /* set Status bar icon color in iOS. */
    //     );
    _menusController.checkCurrentMenus(id);
    final String locale =
        Get.locale.languageCode == 'tr' ? 'tk' : Get.locale.languageCode;
    return Scaffold(
      appBar: AppBar(
        // brightness: Brightness.dark,
        title: Text(
          _categoriesController.getCategoryName(id)[locale] ??
              _categoriesController.getCategoryName(id)['tk'],
          style: TextStyles.title.copyWith(
            fontSize: SizeConfig.textMultiplier * 3,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: false,
        elevation: 0.0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
            size: SizeConfig.heightMultiplier * 2.6,
            color: MyColors.darkGreen,
          ),
          onPressed: () {
            Get.find<MainPageController>().mainPage = MainPage();
          },
        ),
      ),
      body: _menusController.isIdExist(id)
          ? _menusController.menus.length > 0
              ? buildList()
              : CustomError(
                  message: 'empty_menu'.tr,
                  actionMessage: 'go_menu'.tr,
                  callback: () {
                    Get.find<MainPageController>().mainPage = MainPage();
                  },
                  iconName: Icons.remove_shopping_cart_sharp,
                )
          : FutureBuilder(
              future: _menusController.getDishesById(id),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return buildList(
                    isShimmering: true,
                  );
                } else if (snapshot.hasError) {
                  return CustomError(
                    callback: () {},
                    actionMessage: 'try_again'.tr,
                    iconName: Icons.wifi_off_sharp,
                    message: 'no_internet'.tr,
                  );
                }
                return _menusController.menus.length > 0
                    ? buildList()
                    : CustomError(
                        message: 'empty_menu'.tr,
                        actionMessage: 'go_menu'.tr,
                        callback: () {
                          Get.find<MainPageController>().mainPage = MainPage();
                        },
                        iconName: Icons.remove_shopping_cart_sharp,
                      );
              },
            ),
    );
  }

  buildList({
    bool isShimmering = false,
  }) {
    return ListView(
      children: [
        // isShimmering
        //     ? Shimmer.fromColors(
        //         baseColor: Colors.grey[300],
        //         highlightColor: Colors.grey[100],
        //         enabled: isShimmering,
        //         child: Wrap(
        //           children: [
        //             Container(
        //               width: SizeConfig.widthMultiplier * 70,
        //               height: SizeConfig.textMultiplier * 4,
        //               margin: EdgeInsets.only(
        //                 left: SizeConfig.widthMultiplier * 7,
        //                 bottom: SizeConfig.heightMultiplier,
        //               ),
        //               decoration: BoxDecoration(
        //                 color: Colors.grey.withOpacity(0.5),
        //                 borderRadius: BorderRadius.circular(
        //                   SizeConfig.borderRadius * 2,
        //                 ),
        //               ),
        //             ),
        //           ],
        //         ),
        //       )
        //     : Padding(
        //         padding: EdgeInsets.only(
        //           left: SizeConfig.widthMultiplier * 7,
        //           bottom: SizeConfig.heightMultiplier,
        //         ),
        //         child: Text(
        //           _categoriesController.getCategoryName(id)[locale] ??
        //               _categoriesController.getCategoryName(id)['tk'],
        //           style: TextStyles.title.copyWith(
        //             fontSize: SizeConfig.textMultiplier * 5,
        //             fontWeight: FontWeight.bold,
        //           ),
        //         ),
        //       ),
        MenuList(
          isShimmering: isShimmering,
        )
      ],
    );
  }
}
