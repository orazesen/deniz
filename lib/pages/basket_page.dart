import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:deniz/components/custom_error.dart';
import 'package:deniz/constants/constants.dart';
import 'package:deniz/style/my_colors.dart';
import 'package:deniz/style/text_styles.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../components/order_item.dart';
import 'package:deniz/utils/size_config.dart';
import '../controllers/orders_controller.dart';
import '../pages/order_detail_page.dart';

class BasketPage extends StatelessWidget {
  static String routeName = '/cart';

  // List<Map<String, dynamic>> item;
  final OrdersController _ordersController = Get.find();
  // final GlobalKey<AnimatedListState> _listKey = GlobalKey<AnimatedListState>();

  // void _removeItem(int _index) {
  //   _listKey.currentState
  //       .removeItem(_index, (context, animation) => Container());

  //   /// what I'm supposed to do here
  // }
  late SharedPreferences pref;
  String phoneString = '';
  String adressString = '';
  String addString = '';

  getPrefs() async {
    pref = await SharedPreferences.getInstance();
    phoneString = pref.getString(Constants.phoneNumber)!;
    adressString = pref.getString(Constants.address)!;
    addString = pref.getString(Constants.additional)!;
  }

  @override
  Widget build(BuildContext context) {
    getPrefs();
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'basket'.tr,
          style: TextStyles.title.copyWith(
            fontSize: SizeConfig.textMultiplier * 3,
            fontWeight: FontWeight.bold,
          ),
        ),
        // brightness: Brightness.light,
        elevation: 0.0,
      ),
      body: SafeArea(
        child: _ordersController.orders != null
            ? buildList()
            : FutureBuilder(
                future: _ordersController.getItem(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return buildList(isShimmering: true);
                  } else if (snapshot.connectionState == ConnectionState.done) {
                    if (!snapshot.hasData) {
                      return CustomError(
                        actionMessage: 'go_menu'.tr,
                        callback: () {
                          _ordersController.gotoPage(0);
                        },
                        iconName: Icons.remove_shopping_cart_sharp,
                        message: 'empty_basket'.tr,
                      );
                    } else if (snapshot.data!.isNotEmpty) {
                      return buildList();
                    } else {
                      return CustomError(
                        actionMessage: 'go_menu'.tr,
                        callback: () {
                          _ordersController.gotoPage(0);
                        },
                        iconName: Icons.remove_shopping_cart_sharp,
                        message: 'empty_basket'.tr,
                      );
                    }
                  } else {
                    return CustomError(
                      actionMessage: 'go_menu'.tr,
                      callback: () {
                        _ordersController.gotoPage(0);
                      },
                      iconName: Icons.remove_shopping_cart_sharp,
                      message: 'empty_basket'.tr,
                    );
                  }
                },
              ),
      ),
    );
  }

  buildList({bool isShimmering = false}) {
    return isShimmering
        ? buildListView()
        : GetX<OrdersController>(
            builder: (controller) => controller.items.length > 0
                ? buildListView(controller: controller)
                : CustomError(
                    actionMessage: 'go_menu'.tr,
                    callback: () {
                      _ordersController.gotoPage(0);
                    },
                    iconName: Icons.remove_shopping_cart_sharp,
                    message: 'empty_basket'.tr,
                  ),
          );
  }

  ListView buildListView({OrdersController? controller}) {
    final int count = controller == null ? 8 : controller.items.length;
    final bool isShimmering = controller == null;
    return ListView.separated(
      separatorBuilder: (context, index) {
        return SizedBox(
          height: SizeConfig.widthMultiplier * 4,
        );
      },
      padding: EdgeInsets.only(
        left: SizeConfig.widthMultiplier * 4,
        right: SizeConfig.widthMultiplier * 4,
        bottom: 80,
      ),
      itemCount: count,
      itemBuilder: (context, index) {
        if (index < count) if (index == 0)
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              isShimmering
                  ? OrderItem()
                  : OrderItem(
                      // animation: animation,
                      item: controller.items[index],
                      index: index,
                      controller: controller,
                      // callback: _removeItem,
                    ),
              if (count == 1 && !isShimmering)
                buildDetail(
                  controller,
                  controller.items,
                ),
            ],
          );
        else
          return Column(
            children: [
              isShimmering
                  ? OrderItem()
                  : OrderItem(
                      // animation: animation,
                      item: controller.items[index],
                      index: index,
                      controller: controller,
                      // callback: _removeItem,
                    ),
              if (index == count - 1 && !isShimmering)
                buildDetail(
                  controller,
                  controller.items,
                ),
            ],
          );
        return Container();
      },
    );
  }

  buildRow(String name, String count, String price,
      {bool isBold = false, TextStyle? style}) {
    return Padding(
      padding: EdgeInsets.symmetric(
        vertical: SizeConfig.widthMultiplier,
      ),
      child: Row(
        children: [
          Expanded(
            flex: 5,
            child: Text(
              name,
              style: isBold
                  ? TextStyles.body.copyWith(fontWeight: FontWeight.bold)
                  : style == null
                      ? TextStyles.body
                      : style,
              textAlign: TextAlign.start,
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              price,
              style: isBold
                  ? TextStyles.body.copyWith(fontWeight: FontWeight.bold)
                  : TextStyles.body,
              textAlign: TextAlign.end,
              maxLines: 1,
            ),
          ),
        ],
      ),
    );
  }

  buildDetail(OrdersController controller, List<Map<String, dynamic>> item) {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(
            horizontal: SizeConfig.widthMultiplier * 2,
          ),
          child: Column(
            children: [
              SizedBox(
                height: SizeConfig.heightMultiplier * 2,
              ),
              Divider(),
              buildRow(
                'at_basket'.tr,
                '',
                '${controller.total - controller.deliveryCost} TMT',
                style: TextStyles.body.copyWith(
                  fontWeight: FontWeight.w500,
                ),
              ),
              buildRow(
                'delivery_cost'.tr,
                '',
                '${controller.deliveryCost} TMT',
                style: TextStyles.body.copyWith(
                  fontWeight: FontWeight.w500,
                ),
              ),
              buildRow(
                'total'.tr,
                '',
                '${controller.total} TMT',
                isBold: true,
              ),
            ],
          ),
        ),
        SizedBox(
          height: SizeConfig.heightMultiplier * 4,
        ),
        ElevatedButton(
          style: ButtonStyle(
            elevation: MaterialStateProperty.all(
              0.0,
            ),
            minimumSize: MaterialStateProperty.all(
              Size(
                double.infinity,
                SizeConfig.heightMultiplier * 6.4,
              ),
            ),
          ),
          onPressed: () {
            Map<String, dynamic> args = {
              'controller': controller,
              'pref': pref,
              'phoneString': phoneString,
              'addString': addString,
              'addressString': adressString,
            };
            Get.toNamed(
              OrderDetailPage.routeName,
              arguments: args,
            );
          },
          child: Center(
            child: Text(
              'order'.tr,
              style: TextStyles.body.copyWith(
                color: MyColors.white,
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ],
    );
  }
}
