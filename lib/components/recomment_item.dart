import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:deniz/models/menu_item.dart';
import 'package:deniz/controllers/orders_controller.dart';
import 'package:deniz/models/order_product.dart';
import 'package:deniz/style/my_colors.dart';
import 'package:deniz/style/text_styles.dart';
import 'package:deniz/utils/size_config.dart';
import 'package:shimmer/shimmer.dart';

class RecommentItem extends StatefulWidget {
  final MenuItem? item;
  final int? index;
  // final Animation animation;
  // final Function callback;
  RecommentItem({
    this.item,
    this.index,
    this.controller,
    // this.animation,
    // this.callback,
  });

  final OrdersController? controller;

  @override
  _RecommentItemState createState() => _RecommentItemState();
}

class _RecommentItemState extends State<RecommentItem> {
  bool added = false;

  @override
  Widget build(BuildContext context) {
    final String locale =
        Get.locale!.languageCode == 'tr' ? 'tk' : Get.locale!.languageCode;
    return widget.item == null
        ? Shimmer.fromColors(
            baseColor: Colors.grey[300]!,
            highlightColor: Colors.grey[100]!,
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
        : Container(
            constraints: BoxConstraints(
              maxHeight: MediaQuery.of(context).size.height / 6.5,
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
                Expanded(
                  flex: 4,
                  child: ClipRRect(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(
                        SizeConfig.borderRadius,
                      ),
                      bottomLeft: Radius.circular(
                        SizeConfig.borderRadius,
                      ),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        FadeInImage(
                          placeholder: AssetImage(
                            'assets/images/placeholder.png',
                          ),
                          height: MediaQuery.of(context).size.height / 8,
                          fit: BoxFit.fitWidth,
                          image: NetworkImage(widget.item!.imageUrl),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(width: SizeConfig.widthMultiplier * 2),
                Expanded(
                  flex: 6,
                  child: Padding(
                    padding: EdgeInsets.only(
                      top: SizeConfig.heightMultiplier * 2.6,
                      right: SizeConfig.widthMultiplier * 4,
                      bottom: SizeConfig.heightMultiplier * 2.6,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.item!.name[locale] ?? widget.item!.name['tk'],
                          style: TextStyles.body
                              .copyWith(fontWeight: FontWeight.w600),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Flexible(
                              child: Text(
                                '${widget.item!.price.toInt()} TMT',
                                style: TextStyles.body
                                    .copyWith(fontWeight: FontWeight.w400),
                                textAlign: TextAlign.center,
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                if (added) {
                                  return;
                                }
                                widget.controller!.addOrder(
                                  OrderProduct(
                                    id: widget.item!.id,
                                    count: 1,
                                  ),
                                  widget.item!,
                                );
                                setState(() {
                                  added = true;
                                });

                                print('waiting');

                                Future.delayed(
                                  Duration(
                                    seconds: 1,
                                  ),
                                  // () {
                                  //   setState(() {
                                  //     addText = 'add'.tr;
                                  //   });
                                  // },
                                ).then((value) {
                                  setState(() {
                                    added = false;
                                  });

                                  print('all finished');
                                });
                              },
                              child: AnimatedContainer(
                                duration: Duration(
                                  milliseconds: 500,
                                ),
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: Colors.black,
                                    width: 0.3,
                                    style: BorderStyle.solid,
                                  ),
                                  color: added
                                      ? MyColors.darkGreen
                                      : MyColors.white,
                                  borderRadius: BorderRadius.circular(
                                    SizeConfig.borderRadius,
                                  ),
                                ),
                                padding: EdgeInsets.symmetric(
                                  horizontal: SizeConfig.widthMultiplier * 2,
                                  vertical: SizeConfig.heightMultiplier,
                                ),
                                // height: SizeConfig.heightMultiplier * 5,
                                // width: SizeConfig.widthMultiplier * 36,
                                constraints: BoxConstraints(
                                  minWidth: SizeConfig.widthMultiplier * 14,
                                  maxWidth: SizeConfig.widthMultiplier * 28,
                                ),
                                child: Center(
                                  child: Text(
                                    added ? 'added'.tr : 'add'.tr,
                                    style: TextStyles.body.copyWith(
                                      fontWeight: FontWeight.w400,
                                      color: added
                                          ? MyColors.white
                                          : MyColors.darkGreen,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            // ),
          );
  }
}
