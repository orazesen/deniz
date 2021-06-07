import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:saray_pub/components/my_scroll_behavior.dart';
import 'package:saray_pub/components/recomment_item.dart';
import 'package:saray_pub/services/api.dart';
import 'package:saray_pub/style/my_colors.dart';
import 'package:saray_pub/style/text_styles.dart';
import 'package:saray_pub/utils/size_config.dart';
import 'package:shimmer/shimmer.dart';
import '../models/order_product.dart';
import '../models/menu_item.dart';
import '../controllers/categories_controller.dart';
import '../controllers/orders_controller.dart';

class ProductDetail extends StatefulWidget {
  static String routeName = '/productDetail';
  // final MenuItem item;

  // ProductDetail({this.item});
  @override
  _ProductDetailState createState() => _ProductDetailState();
}

class _ProductDetailState extends State<ProductDetail>
    with TickerProviderStateMixin {
  int count = 1;

  final CategoriesController _categoriesController = Get.find();
  final OrdersController _ordersController = Get.find();
  List<MenuItem> snapshot = List<MenuItem>();
  MenuItem item;
  String locale;
  bool loadingRecommends = true;
  bool isFirstCall = true;
  // @override
  // void initState() {
  //   // TODO: implement initState
  //   super.initState();

  //   // FlutterStatusbarcolor.setStatusBarWhiteForeground(false);
  //   // FlutterStatusbarcolor.setStatusBarColor(Colors.transparent);
  //   // getRecommends();
  // }

  getRecommends() async {
    try {
      snapshot = await Api.getRecommendedDishes(item.id);
    } catch (e) {
      // print(e);
    }

    setState(() {
      loadingRecommends = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (isFirstCall) {
      isFirstCall = false;
      locale = Get.locale.languageCode == 'tr' ? 'tk' : Get.locale.languageCode;
      item = ModalRoute.of(context).settings.arguments as MenuItem;
      getRecommends();
    }

    return Scaffold(
      body: Stack(
        children: [
          Padding(
            padding: EdgeInsets.only(
              top: SizeConfig.heightMultiplier * 30,
            ),
            child: ScrollConfiguration(
              behavior: MyBehavior(),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    SizedBox(
                      height: SizeConfig.heightMultiplier * 10,
                    ),
                    // Stack(
                    //   children: [
                    //     Container(
                    //       height: SizeConfig.heightMultiplier * 40,
                    //       width: double.infinity,
                    //       decoration: BoxDecoration(
                    //         borderRadius: BorderRadius.only(
                    //           bottomRight: Radius.circular(
                    //             SizeConfig.heightMultiplier * 6,
                    //           ),
                    //         ),
                    //         color: MyColors.background,
                    //       ),
                    //       child: ClipRRect(
                    //         borderRadius: BorderRadius.only(
                    //           bottomRight: Radius.circular(
                    //             SizeConfig.heightMultiplier * 6,
                    //           ),
                    //         ),
                    //         child: Hero(
                    //           tag: item.id,
                    //           child: FadeInImage(
                    //             image: NetworkImage(
                    //               item.imageUrl,
                    //             ),
                    //             placeholder: AssetImage(
                    //               'assets/images/placeholder.png',
                    //             ),
                    //             alignment: Alignment.center,
                    //             fit: BoxFit.scaleDown,
                    //           ),
                    //         ),
                    //       ),
                    //     ),
                    //     Positioned(
                    //       top: SizeConfig.heightMultiplier * 4.4,
                    //       left: 4,
                    //       child: IconButton(
                    //         icon: Icon(
                    //           Icons.arrow_back_ios,
                    //           size: SizeConfig.heightMultiplier * 2.6,
                    //           color: MyColors.darkGreen,
                    //         ),
                    //         onPressed: () {
                    //           // FlutterStatusbarcolor.setStatusBarWhiteForeground(false);
                    //           // FlutterStatusbarcolor.setStatusBarColor(Colors.white);
                    //           Navigator.of(context).pop();
                    //         },
                    //       ),
                    //     ),
                    //   ],
                    // ),
                    Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: SizeConfig.widthMultiplier * 4,
                        vertical: SizeConfig.heightMultiplier * 2,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            item.name[locale] ?? item.name['tk'],
                            style: TextStyles.header,
                          ),
                          SizedBox(
                            height: SizeConfig.heightMultiplier * 1.6,
                          ),
                          Text(
                            _categoriesController
                                    .getCategoryName(item.categoryId)[locale] ??
                                _categoriesController
                                    .getCategoryName(item.categoryId)['tk'],
                            style: TextStyles.body,
                          ),
                          SizedBox(
                            height: SizeConfig.heightMultiplier * 1.6,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                width: SizeConfig.widthMultiplier * 45,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(
                                    SizeConfig.borderRadius,
                                  ),
                                  color: MyColors.background,
                                ),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    IconButton(
                                      onPressed: () {
                                        if (count == 1) {
                                          return;
                                        }
                                        setState(() {
                                          count--;
                                        });
                                      },
                                      icon: Icon(
                                        Icons.remove,
                                        size: SizeConfig.heightMultiplier * 2.5,
                                      ),
                                      highlightColor: Colors.transparent,
                                      splashColor: Colors.transparent,
                                    ),
                                    Text(
                                      count.toString(),
                                      style: TextStyles.orderCount,
                                    ),
                                    IconButton(
                                      onPressed: () {
                                        setState(() {
                                          count++;
                                        });
                                      },
                                      icon: Icon(
                                        Icons.add,
                                        size: SizeConfig.heightMultiplier * 2.5,
                                      ),
                                      highlightColor: Colors.transparent,
                                      splashColor: Colors.transparent,
                                    ),
                                  ],
                                ),
                              ),
                              Text(
                                '${item.price * count} TMT',
                                style: TextStyles.header,
                              ),
                            ],
                          ),
                          SizedBox(
                            height: SizeConfig.heightMultiplier * 3,
                          ),
                          Text(
                            'ingredients'.tr,
                            style: TextStyles.body,
                          ),
                          SizedBox(
                            height: SizeConfig.heightMultiplier * 1.4,
                          ),
                          Text(
                            item.ingredients[locale] ??
                                item.ingredients['tk'] ??
                                '',
                            style: TextStyles.body.copyWith(
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          SizedBox(
                            height: SizeConfig.heightMultiplier * 3,
                          ),
                          loadingRecommends
                              ? Column(
                                  children: [
                                    Shimmer.fromColors(
                                      baseColor: Colors.grey[300],
                                      highlightColor: Colors.grey[100],
                                      enabled: true,
                                      child: Container(
                                        constraints: BoxConstraints(
                                          maxHeight:
                                              TextStyles.body.fontSize * 1.6,
                                        ),
                                        decoration: BoxDecoration(
                                          color: MyColors.background,
                                          borderRadius: BorderRadius.circular(
                                            SizeConfig.borderRadius,
                                          ),
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      height: SizeConfig.heightMultiplier,
                                    ),
                                    RecommentItem(),
                                  ],
                                )
                              : snapshot.length > 0
                                  ? buildListView()
                                  : Container(),
                          SizedBox(
                            height: 64,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Wrap(
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: MyColors.white,
                  ),
                  height: SizeConfig.heightMultiplier * 6,
                  width: double.infinity,
                ),
              ],
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Wrap(
              children: [
                Padding(
                  padding: EdgeInsets.only(
                    left: SizeConfig.widthMultiplier * 4,
                    bottom: SizeConfig.widthMultiplier * 6,
                    right: SizeConfig.widthMultiplier * 4,
                  ),
                  child: RaisedButton(
                    onPressed: () async {
                      _ordersController.addOrder(
                        OrderProduct(
                          id: item.id,
                          count: count,
                        ),
                        item,
                      );
                      Get.back();
                    },
                    child: Center(
                      child: Text(
                        'add_to_basket'.tr,
                        style: TextStyles.body.copyWith(
                          color: MyColors.white,
                          fontWeight: FontWeight.w600,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Container(
            height: SizeConfig.heightMultiplier * 40,
            width: double.infinity,
            // decoration: BoxDecoration(
            //   borderRadius: BorderRadius.only(
            //     bottomRight: Radius.circular(
            //       SizeConfig.borderRadius * 6,
            //     ),
            //   ),
            //   color: MyColors.background,
            // ),
            child: ClipRRect(
              // borderRadius: BorderRadius.only(
              //   bottomRight: Radius.circular(
              //     SizeConfig.borderRadius * 6,
              //   ),
              // ),
              child: Hero(
                tag: item.id,
                child: FadeInImage(
                  image: NetworkImage(
                    item.imageUrl,
                  ),
                  placeholder: AssetImage(
                    'assets/images/placeholder.png',
                  ),
                  alignment: Alignment.center,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          Positioned(
            top: SizeConfig.heightMultiplier * 4.4,
            left: 4,
            child: IconButton(
              icon: Icon(
                Icons.arrow_back_ios,
                size: SizeConfig.heightMultiplier * 2.6,
                color: MyColors.darkGreen,
              ),
              onPressed: () {
                // FlutterStatusbarcolor.setStatusBarWhiteForeground(false);
                // FlutterStatusbarcolor.setStatusBarColor(Colors.white);
                Navigator.of(context).pop();
              },
            ),
          ),
        ],
      ),
    );
  }

  buildListView() {
    return ListView.separated(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            index == 0
                ? Text(
                    'this_could_be_good_with'.tr,
                    style: TextStyles.body,
                  )
                : Container(),
            index == 0
                ? SizedBox(
                    height: SizeConfig.heightMultiplier * 1.8,
                  )
                : Container(),
            RecommentItem(
              controller: _ordersController,
              index: index,
              item: snapshot[index],
            ),
          ],
        );
      },
      separatorBuilder: (context, index) {
        return SizedBox(
          height: SizeConfig.heightMultiplier,
        );
      },
      itemCount: snapshot.length,
    );
  }
}
