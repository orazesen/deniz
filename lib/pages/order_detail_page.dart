import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:saray_pub/components/my_scroll_behavior.dart';
import 'package:saray_pub/constants/constants.dart';
import 'package:saray_pub/controllers/orders_controller.dart';
import 'package:saray_pub/services/api.dart';
import 'package:saray_pub/style/my_colors.dart';
import 'package:saray_pub/style/text_styles.dart';
import 'package:saray_pub/utils/size_config.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OrderDetailPage extends StatefulWidget {
  static String routeName = '/orderDetailPage';
  // final OrdersController controller;
  // final String phoneString;
  // final String adressString;
  // final String addString;
  // final SharedPreferences pref;
  // OrderDetailPage(
  //     {this.controller,
  //     this.phoneString,
  //     this.adressString,
  //     this.addString,
  //     this.pref});

  @override
  _OrderDetailPageState createState() => _OrderDetailPageState();
}

class _OrderDetailPageState extends State<OrderDetailPage>
    with TickerProviderStateMixin {
  SharedPreferences pref;
  TextEditingController phoneController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController addController = TextEditingController();
  OrdersController controller;
  bool inProgress = false;
  bool hasError = false;
  final _formKey = GlobalKey<FormState>();
  FocusNode phoneFocus = FocusNode();
  bool isFirstCall = true;

  // @override
  // void initState() {
  //   // TODO: implement initState
  //   super.initState();

  // }

  @override
  Widget build(BuildContext context) {
    if (isFirstCall) {
      isFirstCall = false;
      Map args = ModalRoute.of(context).settings.arguments as Map;

      controller = args['controller'];
      pref = args['pref'];
      phoneController.text = args['phoneString'];
      addressController.text = args['addressString'];
      addController.text = args['addString'];
    }
    return Scaffold(
      appBar: AppBar(
        // brightness: Brightness.light,
        elevation: 0.0,
        title: Text(
          'to_order'.tr,
          style: TextStyles.title,
        ),
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
            size: SizeConfig.heightMultiplier * 2.6,
            color: MyColors.darkGreen,
          ),
          onPressed: () {
            Get.back();
          },
        ),
      ),
      body: Builder(
        builder: (context) => ScrollConfiguration(
          behavior: MyBehavior(),
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: SizeConfig.widthMultiplier * 4,
              ),
              child: Form(
                key: _formKey,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                child: Stack(
                  alignment: Alignment.topLeft,
                  children: <Widget>[
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Padding(
                        //   padding: EdgeInsets.only(
                        //     bottom: SizeConfig.heightMultiplier,
                        //     left: SizeConfig.widthMultiplier * 3,
                        //   ),
                        //   child: Text(
                        //     'to_order'.tr,
                        //     style: TextStyles.title.copyWith(
                        //       fontSize: SizeConfig.textMultiplier * 5,
                        //       fontWeight: FontWeight.bold,
                        //     ),
                        //   ),
                        // ),
                        // SizedBox(
                        //   height: SizeConfig.heightMultiplier,
                        // ),
                        Container(
                          padding: EdgeInsets.symmetric(
                            vertical: SizeConfig.widthMultiplier,
                            horizontal: SizeConfig.heightMultiplier * 1.3,
                          ),
                          decoration: BoxDecoration(
                            color: MyColors.background,
                            borderRadius: BorderRadius.circular(
                              SizeConfig.borderRadius,
                            ),
                            border: Border.all(
                              color: hasError
                                  ? MyColors.darkGreen
                                  : Colors.transparent,
                            ),
                          ),
                          child: TextFormField(
                            autofocus:
                                phoneController.text == '' ? true : false,
                            onChanged: (v) {
                              if (v.length == 8) {
                                FocusScopeNode currentFocus =
                                    FocusScope.of(context);
                                if (!currentFocus.hasPrimaryFocus) {
                                  currentFocus.unfocus();
                                }
                              }
                              setState(() {
                                hasError = false;
                              });
                            },
                            controller: phoneController,
                            maxLines: 1,
                            keyboardType: TextInputType.phone,
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: Colors.transparent,
                              border: InputBorder.none,
                              enabledBorder: InputBorder.none,
                              focusedBorder: InputBorder.none,
                              prefixText: '+993 ',
                              prefixStyle: TextStyles.body.copyWith(
                                fontWeight: FontWeight.normal,
                                fontSize: SizeConfig.textMultiplier * 1.8,
                              ),
                              labelStyle: TextStyles.small.copyWith(
                                fontWeight: FontWeight.normal,
                                fontSize: SizeConfig.textMultiplier * 2,
                              ),
                              labelText: 'phone_number'.tr,
                              hintStyle: TextStyles.body,
                              helperStyle: TextStyles.body,
                              errorStyle: TextStyles.small.copyWith(
                                fontWeight: FontWeight.normal,
                                color: Colors.red,
                              ),
                              floatingLabelBehavior:
                                  FloatingLabelBehavior.always,
                              contentPadding: EdgeInsets.fromLTRB(12, 6, 0, 6),
                            ),
                            style: TextStyles.body.copyWith(
                              fontWeight: FontWeight.normal,
                              fontSize: SizeConfig.textMultiplier * 1.8,
                            ),
                          ),
                        ),
                        SizedBox(
                          height: SizeConfig.heightMultiplier * 2,
                        ),
                        Container(
                          padding: EdgeInsets.symmetric(
                            vertical: SizeConfig.widthMultiplier,
                            horizontal: SizeConfig.heightMultiplier * 1.3,
                          ),
                          constraints: BoxConstraints(
                            minHeight: SizeConfig.heightMultiplier * 12,
                          ),
                          decoration: BoxDecoration(
                            color: MyColors.background,
                            borderRadius: BorderRadius.circular(
                              SizeConfig.borderRadius,
                            ),
                          ),
                          child: TextFormField(
                            controller: addressController,
                            keyboardType: TextInputType.multiline,
                            maxLines: null,
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: Colors.transparent,
                              border: InputBorder.none,
                              enabledBorder: InputBorder.none,
                              focusedBorder: InputBorder.none,
                              labelStyle: TextStyles.small.copyWith(
                                fontWeight: FontWeight.normal,
                                fontSize: SizeConfig.textMultiplier * 2,
                              ),
                              labelText: 'my_address'.tr,
                              hintStyle: TextStyles.body,
                              helperStyle: TextStyles.body.copyWith(
                                fontWeight: FontWeight.normal,
                                fontSize: SizeConfig.textMultiplier * 1.8,
                              ),
                              floatingLabelBehavior:
                                  FloatingLabelBehavior.always,
                              contentPadding: EdgeInsets.fromLTRB(12, 6, 0, 6),
                            ),
                            style: TextStyles.body.copyWith(
                              fontWeight: FontWeight.normal,
                              fontSize: SizeConfig.textMultiplier * 1.8,
                            ),
                          ),
                        ),
                        SizedBox(
                          height: SizeConfig.heightMultiplier * 2,
                        ),
                        Container(
                          padding: EdgeInsets.symmetric(
                            vertical: SizeConfig.widthMultiplier,
                            horizontal: SizeConfig.heightMultiplier * 1.3,
                          ),
                          decoration: BoxDecoration(
                            color: MyColors.background,
                            borderRadius: BorderRadius.circular(
                              SizeConfig.borderRadius,
                            ),
                          ),
                          constraints: BoxConstraints(
                            minHeight: SizeConfig.heightMultiplier * 16,
                          ),
                          child: TextFormField(
                            controller: addController,
                            keyboardType: TextInputType.multiline,
                            maxLines: null,
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: Colors.transparent,
                              border: InputBorder.none,
                              enabledBorder: InputBorder.none,
                              focusedBorder: InputBorder.none,
                              labelStyle: TextStyles.small.copyWith(
                                fontWeight: FontWeight.normal,
                                fontSize: SizeConfig.textMultiplier * 2,
                              ),
                              labelText: 'additional'.tr,
                              hintStyle: TextStyles.body,
                              helperStyle: TextStyles.body,
                              floatingLabelBehavior:
                                  FloatingLabelBehavior.always,
                              contentPadding: EdgeInsets.fromLTRB(12, 6, 0, 6),
                            ),
                            style: TextStyles.body.copyWith(
                              fontWeight: FontWeight.normal,
                              fontSize: SizeConfig.textMultiplier * 1.8,
                            ),
                          ),
                        ),
                        SizedBox(
                          height: SizeConfig.heightMultiplier * 2,
                        ),
                        Divider(),
                        Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: SizeConfig.widthMultiplier * 2,
                          ),
                          child: Column(
                            children: [
                              buildRow(
                                'at_basket'.tr,
                                '',
                                '${controller.total - controller.deliveryCost < 0 ? 0 : controller.total - controller.deliveryCost} TMT',
                              ),
                              buildRow(
                                'delivery_cost'.tr,
                                '',
                                '${controller.total <= 0 ? 0 : controller.deliveryCost} TMT',
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
                          height: SizeConfig.heightMultiplier * 2,
                        ),
                        ElevatedButton(
                          style: ButtonStyle(
                            elevation: MaterialStateProperty.all(
                              0.0,
                            ),
                          ),
                          onPressed: () async {
                            if (inProgress) return;

                            await formSubmit(context);
                          },
                          child: Center(
                            child: inProgress
                                ? SpinKitThreeBounce(
                                    color: Colors.white,
                                    size: SizeConfig.heightMultiplier * 3,
                                    controller: AnimationController(
                                      vsync: this,
                                      duration: const Duration(
                                        milliseconds: 1200,
                                      ),
                                    ),
                                  )
                                : Text(
                                    'confirm'.tr,
                                    style: TextStyles.body.copyWith(
                                      color: MyColors.white,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                          ),
                        ),
                        SizedBox(
                          height: SizeConfig.heightMultiplier * 2,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  buildRow(String name, String count, String price, {bool isBold = false}) {
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
                  : TextStyles.body.copyWith(
                      fontWeight: FontWeight.normal,
                    ),
              textAlign: TextAlign.start,
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              price,
              style: isBold
                  ? TextStyles.body.copyWith(fontWeight: FontWeight.bold)
                  : TextStyles.body.copyWith(
                      fontWeight: FontWeight.normal,
                    ),
              textAlign: TextAlign.end,
              maxLines: 1,
            ),
          ),
        ],
      ),
    );
  }

  formSubmit(BuildContext context) async {
    // await Future.delayed(
    //   Duration(seconds: 20),
    // );
    FocusScopeNode currentFocus = FocusScope.of(context);
    if (!currentFocus.hasPrimaryFocus) {
      currentFocus.unfocus();
    }

    if (phoneController.text.length < 8) {
      setState(() {
        hasError = true;
      });
      // print('lesss');
      return;
    }

    if (controller.total < 50) {
      Scaffold.of(context).showSnackBar(
        SnackBar(
          backgroundColor: MyColors.darkGreen,
          content: Text(
            'min_order_price_error'.tr,
            style: TextStyles.body.copyWith(
              color: MyColors.white,
            ),
            textAlign: TextAlign.center,
          ),
          duration: Duration(milliseconds: 2500),
          // shape: RoundedRectangleBorder(
          //   borderRadius: BorderRadius.only(
          //     topLeft: Radius.circular(SizeConfig.borderRadius * 2),
          //     topRight: Radius.circular(SizeConfig.borderRadius * 2),
          //   ),
          // ),
        ),
      );
      return;
    }

    setState(() {
      inProgress = true;
    });

    List<Map<String, dynamic>> dishes = [];
    controller.orders.forEach((element) {
      return dishes.add(element.toMap());
    });

    final Map<String, dynamic> map = {
      'dishes': dishes,
      'phone': phoneController.text,
      'address': addressController.text,
      'wish': addController.text,
    };
    try {
      await Api.postOrders(map);
      final o = controller.orders.toList();
      for (var e in o) {
        await controller.removeById(e.id);
      }

      await pref.setString(Constants.phoneNumber, phoneController.text);
      await pref.setString(Constants.address, addressController.text);
      await pref.setString(Constants.additional, addController.text);

      Get.back();
    } catch (e) {
      setState(() {
        inProgress = false;
      });
      Scaffold.of(context).showSnackBar(
        SnackBar(
          backgroundColor: MyColors.darkGreen,
          content: Text(
            'check_internet'.tr,
            style: TextStyles.body.copyWith(
              color: MyColors.white,
            ),
            textAlign: TextAlign.center,
          ),
          // padding: EdgeInsets.only(
          //   top: SizeConfig.heightMultiplier,
          //   left: SizeConfig.heightMultiplier * 4,
          // ),
          // shape: RoundedRectangleBorder(
          //   borderRadius: BorderRadius.only(
          //     topLeft: Radius.circular(SizeConfig.borderRadius * 4),
          //     topRight: Radius.circular(SizeConfig.borderRadius * 4),
          //   ),
          // ),
          duration: Duration(milliseconds: 1000),
        ),
      );
    }
  }

  @override
  void dispose() {
    phoneController.dispose();
    super.dispose();
  }
}
