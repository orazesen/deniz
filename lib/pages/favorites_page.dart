import 'package:flutter/material.dart';
import 'package:deniz/components/favorite_item.dart';
import 'package:deniz/controllers/orders_controller.dart';
import 'package:deniz/models/menu_item.dart';
import '../style/text_styles.dart';
import '../utils/size_config.dart';
import '../components/custom_error.dart';
import 'package:get/get.dart';
import '../controllers/favorites_controller.dart';

class FavoritesPage extends StatelessWidget {
  static String routeName = '/favorites';
  final FavoritesController _favoritesController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // brightness: Brightness.light,
        title: Text(
          'favorites'.tr,
          style: TextStyles.title.copyWith(
            fontSize: SizeConfig.textMultiplier * 3,
            fontWeight: FontWeight.bold,
            letterSpacing: -1,
          ),
        ),
        elevation: 0.0,
      ),
      body: SafeArea(
        child: _favoritesController.items != null
            ? GetX<FavoritesController>(
                builder: (controller) {
                  return controller.items.length > 0
                      ? buildListView(
                          items: controller.items,
                          // isShimmering: true,
                        )
                      : Center(
                          child: CustomError(
                            actionMessage: 'go_menu'.tr,
                            callback: () {
                              Get.find<OrdersController>().gotoPage(0);
                            },
                            iconName: Icons.highlight_off_sharp,
                            message: 'empty_favorite'.tr,
                          ),
                        );
                },
              )
            : FutureBuilder(
                future: _favoritesController.getItems(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return buildListView(isShimmering: true);
                  } else if (snapshot.connectionState == ConnectionState.done) {
                    return GetX<FavoritesController>(
                      builder: (controller) {
                        return controller.items.length > 0
                            ? buildListView(
                                items: controller.items,
                              )
                            : Center(
                                child: CustomError(
                                  actionMessage: 'go_menu'.tr,
                                  callback: () {
                                    Get.find<OrdersController>().gotoPage(0);
                                  },
                                  iconName: Icons.highlight_off_sharp,
                                  message: 'empty_favorite'.tr,
                                ),
                              );
                      },
                    );
                  } else {
                    return Center(
                      child: CustomError(
                        actionMessage: 'go_menu'.tr,
                        callback: () {
                          Get.find<OrdersController>().gotoPage(0);
                        },
                        iconName: Icons.highlight_off_sharp,
                        message: 'empty_favorite'.tr,
                      ),
                    );
                  }
                },
              ),
      ),
    );
  }

  ListView buildListView({List<MenuItem>? items, bool isShimmering = false}) {
    return ListView.separated(
      separatorBuilder: (c, index) {
        return SizedBox(
          height: SizeConfig.widthMultiplier * 4,
        );
      },
      itemCount: isShimmering ? 8 : items?.length ?? 0,
      itemBuilder: (ctx, index) {
        return index == 0
            ? Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Padding(
                  //   padding: EdgeInsets.only(
                  //     bottom: SizeConfig.heightMultiplier,
                  //   ),
                  //   child: isShimmering
                  //       ? Shimmer.fromColors(
                  //           baseColor: Colors.grey[300],
                  //           highlightColor: Colors.grey[100],
                  //           enabled: isShimmering,
                  //           child: Container(
                  //             width: SizeConfig.widthMultiplier * 70,
                  //             height: TextStyles.header.fontSize,
                  //             decoration: BoxDecoration(
                  //               color: Colors.grey.withOpacity(0.5),
                  //               borderRadius: BorderRadius.circular(
                  //                 SizeConfig.borderRadius * 2,
                  //               ),
                  //             ),
                  //           ),
                  //         )
                  //       : Padding(
                  //           padding: EdgeInsets.only(
                  //             bottom: SizeConfig.heightMultiplier,
                  //             left: SizeConfig.widthMultiplier * 3,
                  //           ),
                  //           child: Text(
                  //             'favorites'.tr,
                  //             style: TextStyles.title.copyWith(
                  //               fontSize: SizeConfig.textMultiplier * 3,
                  //               fontWeight: FontWeight.bold,
                  //               letterSpacing: -1,
                  //             ),
                  //           ),
                  //         ),
                  // ),
                  isShimmering
                      ? FavoriteItem()
                      : FavoriteItem(
                          key: UniqueKey(),
                          menuItem: items![index],
                        ),
                ],
              )
            : isShimmering
                ? FavoriteItem()
                : FavoriteItem(
                    key: UniqueKey(),
                    menuItem: items![index],
                  );
      },
      padding: EdgeInsets.only(
        left: SizeConfig.widthMultiplier * 4,
        right: SizeConfig.widthMultiplier * 4,
        bottom: 80,
        // top: SizeConfig.heightMultiplier * 3,
      ),
    );
  }
}
