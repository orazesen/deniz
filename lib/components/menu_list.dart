import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../utils/size_config.dart';

import './menu_item.dart';
import '../controllers/menus_controller.dart';

class MenuList extends StatelessWidget {
  final bool isShimmering;

  MenuList({this.isShimmering = false});
  final MenusController _menusController = Get.find();

  @override
  Widget build(BuildContext context) {
    return isShimmering
        ? buildListView(_menusController)
        : GetX<MenusController>(
            builder: (controller) {
              return buildListView(controller);
            },
          );
  }

  buildListView(MenusController controller) {
    return ListView.separated(
      separatorBuilder: (c, index) => SizedBox(
        height: SizeConfig.widthMultiplier * 4,
      ),
      physics: NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: isShimmering ? 8 : controller.menus.length,
      itemBuilder: (ctx, index) {
        return isShimmering
            ? MenuItem()
            : MenuItem(
                menuItem: controller.menus[index],
              );
      },
      padding: EdgeInsets.only(
        left: SizeConfig.widthMultiplier * 4,
        right: SizeConfig.widthMultiplier * 4,
        bottom: 80,
      ),
    );
  }
}
