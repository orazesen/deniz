import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:deniz/constants/constants.dart';
import 'package:deniz/controllers/menus_controller.dart';
import 'package:deniz/style/my_colors.dart';
import 'package:deniz/style/text_styles.dart';
import 'package:deniz/utils/size_config.dart';
import 'package:shimmer/shimmer.dart';

import '../pages/product_detail.dart';
import '../models/menu_item.dart' as MenuItemModel;

class MenuItem extends StatefulWidget {
  final MenuItemModel.MenuItem? menuItem;
  MenuItem({this.menuItem});

  @override
  _MenuItemState createState() => _MenuItemState();
}

class _MenuItemState extends State<MenuItem> {
  final MenusController _menusController = Get.find();

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(
        SizeConfig.borderRadius,
      ),
      onTap: () {
        if (widget.menuItem == null) return;
        Get.toNamed(
          ProductDetail.routeName, arguments: widget.menuItem,
          // ProductDetail(
          //   item: widget.menuItem,
          // ),
        );
      },
      child: widget.menuItem == null
          ? Shimmer.fromColors(
              baseColor: Colors.grey[300]!,
              highlightColor: Colors.grey[100]!,
              enabled: widget.menuItem == null,
              child: buildItem(),
            )
          : buildItem(),
    );
  }

  buildItem() {
    final String locale =
        Get.locale!.languageCode == 'tr' ? 'tk' : Get.locale!.languageCode;
    return Container(
      // padding: EdgeInsets.all(
      //   SizeConfig.widthMultiplier * 4,
      // ),
      height: SizeConfig.heightMultiplier * 100 / 3,
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(
          SizeConfig.borderRadius,
        ),
        color: widget.menuItem == null ? MyColors.white : MyColors.background,
      ),
      child: Stack(
        children: [
          widget.menuItem == null
              ? Container()
              : Column(
                  children: [
                    Expanded(
                      child: Hero(
                        tag: widget.menuItem!.id,
                        child: FadeInImage(
                          placeholder: AssetImage(
                            Constants.placeholder,
                          ),
                          fit: BoxFit.cover,
                          image: NetworkImage(
                            widget.menuItem!.imageUrl,
                          ),
                          width: double.infinity,
                        ),
                      ),
                    ),
                    Container(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            margin: EdgeInsets.only(
                              left: SizeConfig.widthMultiplier * 2,
                            ),
                            width: SizeConfig.widthMultiplier * 50,
                            child: Text(
                              widget.menuItem!.name[locale] ??
                                  widget.menuItem!.name['tk'],
                              style: TextStyles.body,
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 16.0,
                              vertical: 14.0,
                            ),
                            decoration: BoxDecoration(
                              color: MyColors.darkGreen,
                              borderRadius: BorderRadius.circular(
                                SizeConfig.borderRadius,
                              ),
                            ),
                            child: Text(
                              '${widget.menuItem!.price} TMT',
                              style: TextStyles.body.copyWith(
                                color: MyColors.white,
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
          widget.menuItem == null
              ? Container()
              : Positioned(
                  right: SizeConfig.heightMultiplier,
                  top: SizeConfig.heightMultiplier,
                  child: IconButton(
                    onPressed: () {
                      widget.menuItem!.isFavorite
                          ? _menusController.removeFavorite(widget.menuItem!.id)
                          : _menusController.addFavorite(widget.menuItem!);
                    },
                    icon: Icon(
                      widget.menuItem!.isFavorite
                          ? Icons.favorite
                          : Icons.favorite_border,
                      color: MyColors.white,
                      size: SizeConfig.heightMultiplier * 4,
                    ),
                  ),
                ),
        ],
      ),
    );
  }
}
