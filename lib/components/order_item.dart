import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:get/get.dart';
import 'package:deniz/constants/constants.dart';
import 'package:deniz/controllers/orders_controller.dart';
import 'package:deniz/style/my_colors.dart';
import 'package:deniz/style/text_styles.dart';
import 'package:deniz/utils/size_config.dart';
import 'package:shimmer/shimmer.dart';

class OrderItem extends StatelessWidget {
  final Map<String, dynamic> item;
  final int index;
  // final Animation animation;
  // final Function callback;
  OrderItem({
    this.item,
    this.index,
    this.controller,
    // this.animation,
    // this.callback,
  });
  final OrdersController controller;
  @override
  Widget build(BuildContext context) {
    final String locale =
        Get.locale.languageCode == 'tr' ? 'tk' : Get.locale.languageCode;
    return item == null
        ? Shimmer.fromColors(
            baseColor: Colors.grey[300],
            highlightColor: Colors.grey[100],
            enabled: true,
            child: Container(
              constraints: BoxConstraints(
                maxHeight: MediaQuery.of(context).size.height / 6.5,
              ),
              decoration: BoxDecoration(
                color: MyColors.background,
                borderRadius: BorderRadius.circular(
                  SizeConfig.borderRadius,
                ),
              ),
            ),
          )
        : Slidable(
            actionPane: SlidableBehindActionPane(),
            actionExtentRatio: 0.25,
            secondaryActions: [
              IconSlideAction(
                caption: 'delete'.tr,
                // color: MyColors.darkGreen,
                icon: Icons.delete,
                closeOnTap: false,
                onTap: () {
                  controller.remove(index);
                },
              ),
            ],
            key: Key(item['menu'].id.toString()),
            child: Container(
              constraints: BoxConstraints(
                maxHeight: SizeConfig.heightMultiplier * 15,
              ),
              decoration: BoxDecoration(
                color: MyColors.background,
                borderRadius: BorderRadius.circular(
                  SizeConfig.borderRadius,
                ),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  FadeInImage(
                    placeholder: AssetImage(
                      Constants.placeholder,
                    ),
                    height: double.infinity,
                    fit: BoxFit.cover,
                    image: NetworkImage(item['menu'].imageUrl),
                    width: SizeConfig.widthMultiplier * 30,
                  ),
                  SizedBox(width: SizeConfig.widthMultiplier * 2),
                  Padding(
                    padding: EdgeInsets.only(
                      top: SizeConfig.heightMultiplier * 2,
                      right: SizeConfig.widthMultiplier * 4,
                      bottom: SizeConfig.heightMultiplier * 2,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item['menu'].name[locale] ?? item['menu'].name['tk'],
                          style: TextStyles.body
                              .copyWith(fontWeight: FontWeight.w600),
                        ),
                        Container(
                          width: SizeConfig.widthMultiplier * 56,
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: Colors.black,
                                    width: 0.3,
                                    style: BorderStyle.solid,
                                  ),
                                  borderRadius: BorderRadius.circular(
                                    SizeConfig.borderRadius,
                                  ),
                                ),
                                constraints: BoxConstraints(
                                  minWidth: SizeConfig.widthMultiplier * 20,
                                  maxWidth: SizeConfig.widthMultiplier * 24,
                                ),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    InkWell(
                                      onTap: () {
                                        controller.decrease(index);
                                      },
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Icon(
                                          Icons.remove,
                                          size: SizeConfig.heightMultiplier * 2,
                                        ),
                                      ),
                                    ),
                                    Text(
                                      '${controller.items[index]['count']}',
                                      style: TextStyles.body.copyWith(
                                          fontWeight: FontWeight.w400),
                                    ),
                                    InkWell(
                                      onTap: () {
                                        controller.increase(index);
                                      },
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Icon(
                                          Icons.add,
                                          size: SizeConfig.heightMultiplier * 2,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Text(
                                '${item['menu'].price.toInt() * item['count']} TMT',
                                style: TextStyles.body
                                    .copyWith(fontWeight: FontWeight.w400),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
  }
}
