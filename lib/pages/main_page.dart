import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:saray_pub/components/custom_error.dart';
import 'package:saray_pub/constants/constants.dart';
import 'package:saray_pub/controllers/categories_controller.dart';
import 'package:saray_pub/controllers/menus_controller.dart';
import 'package:saray_pub/controllers/orders_controller.dart';
import 'package:saray_pub/models/category_item.dart';
import 'package:saray_pub/pages/video_player_page.dart';
import 'package:saray_pub/services/api.dart';
import 'package:saray_pub/utils/size_config.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shimmer/shimmer.dart';
import '../controllers/banners_controller.dart';
import '../components/products_grid.dart';
import '../style/text_styles.dart';
import 'package:flutter_svg/svg.dart';
import '../style/my_colors.dart';
import '../models/banner.dart' as Ban;
import 'dart:io';

class MainPage extends StatefulWidget {
  static String routeName = '/main';
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  final BannersController _bannersController = Get.find();
  final CategoriesController _categoriesController = Get.find();
  final OrdersController _ordersController = Get.find();
  final MenusController _menusController = Get.find();

  bool editingName = false;
  bool editingPhone = false;
  bool editingAddress = false;

  SharedPreferences pref;
  String phoneString;
  String nameString;
  String addressString;
  String language;

  String currentLanguage = 'Türkmençe';
  int currentIndex = 0;

  final _formKey = GlobalKey<State>();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getPrefs();
  }

  getPrefs() async {
    pref = await SharedPreferences.getInstance();
    nameString = pref.getString(Constants.username) ?? '';
    phoneString = pref.getString(Constants.phoneNumber) ?? '';
    addressString = pref.getString(Constants.address) ?? '';
    language = pref.getString(Constants.language) ?? '';
    if (language == 'ru') {
      currentLanguage = 'Русский';
    } else if (language == 'en') {
      currentLanguage = 'English';
    }
  }

  setPrefs() async {
    await pref.setString(Constants.username, nameString);
    await pref.setString(Constants.phoneNumber, phoneString);
    await pref.setString(Constants.address, addressString);
    await pref.setString(Constants.language, language);
    Get.updateLocale(
      Locale(
        language,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark.copyWith(
    //   statusBarColor: Colors.white,
    //   /* set Status bar color in Android devices. */

    //   statusBarIconBrightness: Brightness.light,
    //   /* set Status bar icons color in Android devices.*/

    //   statusBarBrightness: Brightness.light,
    // ) /* set Status bar icon color in iOS. */
    //     );
    return Scaffold(
      appBar: AppBar(
        // brightness: Brightness.dark,
        title: Text(
          'DEŇIZ',
          style: TextStyles.title,
        ),
        centerTitle: false,
        elevation: 0.0,
        // leading: Padding(
        //   padding: EdgeInsets.only(
        //     left: SizeConfig.widthMultiplier * 2,
        //   ),
        //   child: IconButton(
        //     icon: SvgPicture.asset(
        //       Constants.info,
        //       height: SizeConfig.heightMultiplier * 2.7,
        //       color: MyColors.darkGreen,
        //     ),
        //     onPressed: () async {
        //       await showInfo(context);
        //       colorize();
        //     },
        //   ),
        // ),
        // actions: [
        //   Padding(
        //     padding: EdgeInsets.only(
        //       right: SizeConfig.widthMultiplier * 2,
        //     ),
        //     child: IconButton(
        //       icon: SvgPicture.asset(
        //         Constants.filter,
        //         color: MyColors.darkGreen,
        //       ),
        //       onPressed: () async {
        //         await showSettings(context);
        //         colorize();
        //       },
        //     ),
        //   )
        // ],
      ),
      body: (_bannersController.banners != null &&
              _bannersController.banners.length > 0 &&
              _categoriesController.categories != null &&
              _categoriesController.categories.length > 0)
          ? _buildListView(context)
          : FutureBuilder(
              future: Api.getInitials(),
              builder: (_, snapshots) {
                if (snapshots.connectionState == ConnectionState.waiting) {
                  return _buildListView(context, shimmering: true);
                } else if (snapshots.hasError) {
                  return CustomError(
                    message: 'no_internet'.tr,
                    callback: () {
                      setState(() {});
                    },
                    actionMessage: 'try_again'.tr,
                    iconName: Icons.wifi_off,
                  );
                } else {
                  return _buildListView(context);
                }
              },
            ),
    );
  }

  _buildListView(BuildContext context, {bool shimmering = false}) {
    // final List<String> urls = [];
    // // int videoIndex = 0;
    // _bannersController.banners.forEach((element) {
    //   urls.add(element.fileUrl);
    // });
    return RefreshIndicator(
      onRefresh: () async {
        _categoriesController.categories = List<CategoryItem>().obs;
        _bannersController.banners = List<Ban.Banner>().obs;
        _menusController.differentMenus = List<DifferentMenu>().obs;
        setState(() {});
        // await Api.getInitials();
      },
      child: ListView(
        children: [
          GetBuilder<BannersController>(
            init: _bannersController,
            builder: (_) => CarouselSlider.builder(
              itemCount: shimmering || _bannersController.banners.length <= 0
                  ? 1
                  : _bannersController.banners.length,
              itemBuilder: (context, index) {
                return Container(
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: SizeConfig.widthMultiplier * 4,
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(
                        SizeConfig.borderRadius,
                      ),
                      child: shimmering ||
                              _bannersController.banners.length <= 0
                          ? Shimmer.fromColors(
                              baseColor: Colors.grey[300],
                              highlightColor: Colors.grey[100],
                              enabled: true,
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(
                                    SizeConfig.borderRadius,
                                  ),
                                  color: Colors.white,
                                ),
                              ),
                            )
                          : _bannersController.banners[index].fileType ==
                                  'video'
                              ? VideoPlayerPage(
                                  url:
                                      _bannersController.banners[index].fileUrl,
                                )
                              // : FadeInImage.(
                              //     placeholder: 'assets/images/placeholder.png',
                              //     fit: BoxFit.cover,
                              //     width: double.infinity,
                              //     height: double.infinity,
                              //     image:
                              //         _bannersController.banners[index].fileUrl,
                              //   ),
                              : SizedBox.expand(
                                  child: Image.file(
                                    File(
                                      _bannersController.banners[index].fileUrl,
                                    ),
                                    fit: BoxFit.cover,
                                    alignment: Alignment.center,
                                  ),
                                ),
                    ),
                  ),
                );
              },
              options: CarouselOptions(
                enableInfiniteScroll: false,
                viewportFraction: 1,
                // autoPlay: true,
                height: MediaQuery.of(context).size.height / 3.6,
                enlargeCenterPage: false,
                onPageChanged: (index, onPageChangeReason) {
                  setState(() {
                    currentIndex = index;
                  });
                },
              ),
            ),
          ),
          ProductsGrid(
            isShimmering: shimmering,
            categories: _categoriesController.categories,
          ),
          SizedBox(
            height: SizeConfig.heightMultiplier * 10,
          ),
        ],
      ),
    );
  }

  Future<void> showInfo(BuildContext context) {
    decolorize();
    return showDialog(
      context: context,
      barrierDismissible: true,
      builder: (_) {
        return Dialog(
          insetPadding:
              EdgeInsets.symmetric(horizontal: SizeConfig.widthMultiplier * 4),
          child: Container(
            // height: SizeConfig.heightMultiplier * 70,
            // width: SizeConfig.widthMultiplier * 100,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(
                SizeConfig.borderRadius,
              ),
            ),
            padding: EdgeInsets.all(
              SizeConfig.heightMultiplier,
            ),
            child: Wrap(
              children: [
                Column(
                  children: [
                    Image.asset(
                      'assets/icons/icon.png',
                      height: SizeConfig.heightMultiplier * 8,
                    ),
                    // SvgPicture.asset(
                    //   Constants.logo,
                    //   height: SizeConfig.heightMultiplier * 6,
                    // ),
                    Text(
                      'information'.tr,
                      style: TextStyles.button.copyWith(
                        color: MyColors.darkGreen,
                        fontWeight: FontWeight.w600,
                        fontSize: SizeConfig.textMultiplier * 2.5,
                      ),
                    ),
                    SizedBox(
                      height: SizeConfig.heightMultiplier * 1.4,
                    ),
                    buildRow(
                      Constants.order,
                      'min_order'.tr,
                      '50tmt'.tr,
                      spaceBetween: 3.2,
                    ),

                    buildRow(
                      Constants.delivery,
                      'delivery_time'.tr,
                      '45min'.tr,
                      spaceBetween: 2.8,
                    ),
                    buildRow(
                      Constants.deliverCost,
                      'delivery_cost'.tr,
                      _ordersController.deliveryCost.toStringAsFixed(0) +
                          ' ' +
                          'currency'.tr,
                      spaceBetween: 2.2,
                    ),
                    buildRow(
                      Constants.time,
                      'working_hours'.tr,
                      '09:00-23:00',
                      spaceBetween: 2.8,
                      height: 3.2,
                    ),
                    buildRow(
                      Constants.call,
                      'phone'.tr,
                      '+993 65 711811',
                      spaceBetween: 2.8,
                    ),
                    buildRow(
                      Constants.addressIcon,
                      'address'.tr,
                      'address_text'.tr,
                      spaceBetween: 3.6,
                      height: 3,
                    ),

                    SizedBox(
                      height: SizeConfig.heightMultiplier * 1.4,
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  colorize() {
    // FlutterStatusbarcolor.setStatusBarWhiteForeground(false);
    // FlutterStatusbarcolor.setStatusBarColor(Colors.white);
  }

  decolorize() {
    // FlutterStatusbarcolor.setStatusBarWhiteForeground(false);
    // FlutterStatusbarcolor.setStatusBarColor(Colors.transparent);
  }

  Future<void> showSettings(BuildContext context) {
    decolorize();
    return showDialog(
      context: context,
      barrierDismissible: true,
      builder: (_) {
        return Dialog(
          insetPadding:
              EdgeInsets.symmetric(horizontal: SizeConfig.widthMultiplier * 4),
          child: Container(
            // height: SizeConfig.heightMultiplier * 70,
            // width: SizeConfig.widthMultiplier * 100,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(
                SizeConfig.borderRadius,
              ),
            ),
            padding: EdgeInsets.all(
              SizeConfig.heightMultiplier * 3,
            ),
            child: Form(
              key: _formKey,
              child: Wrap(
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Image.asset(
                        'assets/icons/icon.png',
                        height: SizeConfig.heightMultiplier * 8,
                      ),
                      Text(
                        'settings'.tr,
                        style: TextStyles.button.copyWith(
                          color: MyColors.darkGreen,
                          fontWeight: FontWeight.w600,
                          fontSize: SizeConfig.textMultiplier * 2.5,
                        ),
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.person,
                            color: MyColors.darkGreen,
                            size: SizeConfig.heightMultiplier * 4,
                          ),
                          SizedBox(
                            width: SizeConfig.widthMultiplier * 2,
                          ),
                          Expanded(
                            child: TextFormField(
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                hintText: 'name'.tr,
                                hintStyle: TextStyle(
                                  fontSize: SizeConfig.textMultiplier * 2,
                                  color: Color(0xff707070),
                                ),
                                labelStyle: TextStyle(
                                  fontSize: SizeConfig.textMultiplier * 2,
                                  color: Color(0xff707070),
                                ),
                                labelText: 'name'.tr,
                              ),
                              initialValue: nameString,
                              keyboardType: TextInputType.text,
                              onChanged: (value) {
                                nameString = value;
                              },
                              style: TextStyle(
                                fontSize: SizeConfig.textMultiplier * 2,
                                color: Color(0xff707070),
                              ),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SizedBox(
                            width: SizeConfig.widthMultiplier,
                          ),
                          SvgPicture.asset(
                            Constants.call,
                            color: MyColors.darkGreen,
                            width: SizeConfig.heightMultiplier * 2.7,
                          ),
                          SizedBox(
                            width: SizeConfig.widthMultiplier * 3.2,
                          ),
                          Expanded(
                            child: TextFormField(
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                hintText: 'phone'.tr,
                                hintStyle: TextStyle(
                                  fontSize: SizeConfig.textMultiplier * 2,
                                  color: Color(0xff707070),
                                ),
                                labelStyle: TextStyle(
                                  fontSize: SizeConfig.textMultiplier * 2,
                                  color: Color(0xff707070),
                                ),
                                labelText: 'phone'.tr,
                                prefixText: '+993',
                                prefixStyle: TextStyle(
                                  fontSize: SizeConfig.textMultiplier * 2,
                                  color: Color(0xff707070),
                                ),
                              ),
                              style: TextStyle(
                                fontSize: SizeConfig.textMultiplier * 2,
                                color: Color(0xff707070),
                              ),
                              initialValue: phoneString,
                              keyboardType: TextInputType.phone,
                              onChanged: (value) {
                                phoneString = value;
                              },
                            ),
                          ),
                        ],
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SizedBox(
                            width: SizeConfig.widthMultiplier,
                          ),
                          SvgPicture.asset(
                            Constants.addressIcon,
                            color: MyColors.darkGreen,
                            width: SizeConfig.heightMultiplier * 2.6,
                          ),
                          SizedBox(
                            width: SizeConfig.widthMultiplier * 3.2,
                          ),
                          Expanded(
                            child: TextFormField(
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                hintText: 'address'.tr,
                                hintStyle: TextStyle(
                                  fontSize: SizeConfig.textMultiplier * 2,
                                  color: Color(0xff707070),
                                ),
                                labelStyle: TextStyle(
                                  fontSize: SizeConfig.textMultiplier * 2,
                                  color: Color(0xff707070),
                                ),
                                labelText: 'address'.tr,
                              ),
                              initialValue: addressString,
                              keyboardType: TextInputType.text,
                              onChanged: (value) {
                                addressString = value;
                              },
                              style: TextStyle(
                                fontSize: SizeConfig.textMultiplier * 2,
                                color: Color(0xff707070),
                              ),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SizedBox(
                            width: SizeConfig.widthMultiplier,
                          ),
                          SvgPicture.asset(
                            Constants.global,
                            color: MyColors.darkGreen,
                            height: SizeConfig.heightMultiplier * 2.8,
                          ),
                          SizedBox(
                            width: SizeConfig.widthMultiplier * 3.2,
                          ),
                          Expanded(
                            child: Container(
                              padding: EdgeInsets.only(
                                right: SizeConfig.widthMultiplier * 5,
                              ),
                              child: DropdownButtonFormField<String>(
                                decoration: InputDecoration(
                                  border: InputBorder.none,
                                  contentPadding: EdgeInsets.all(
                                    0.0,
                                  ),
                                ),
                                dropdownColor: MyColors.white,
                                elevation: 0,
                                iconEnabledColor: MyColors.darkGreen,
                                items: <String>[
                                  'Türkmençe',
                                  'Русский',
                                  'English'
                                ].map(
                                  (String value) {
                                    return new DropdownMenuItem<String>(
                                      value: value,
                                      child: new Text(
                                        value,
                                        style: TextStyle(
                                          fontSize:
                                              SizeConfig.textMultiplier * 2,
                                          color: Color(0xff707070),
                                        ),
                                      ),
                                    );
                                  },
                                ).toList(),
                                style: TextStyle(
                                  fontFamily: 'Montserrat',
                                  fontSize: SizeConfig.textMultiplier * 2,
                                  color: Color(0xff707070),
                                ),
                                value: currentLanguage,
                                onChanged: (value) {
                                  setState(
                                    () {
                                      currentLanguage = value;
                                      if (currentLanguage == 'Türkmençe') {
                                        language = 'tr';
                                      } else if (currentLanguage == 'English') {
                                        language = 'en';
                                      } else {
                                        language = 'ru';
                                      }
                                    },
                                  );
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: SizeConfig.heightMultiplier * 2,
                      ),
                      TextButton(
                        child: Text(
                          'ok'.tr,
                          style: TextStyles.button,
                        ),
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all(
                            MyColors.darkGreen,
                          ),
                        ),
                        onPressed: () {
                          Get.back();
                          setPrefs();
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  buildRow(
    String icon,
    String name,
    String value, {
    double spaceBetween = 5.0,
    double height = 3,
    double width = 3,
  }) {
    return Padding(
      padding: EdgeInsets.symmetric(
        vertical: SizeConfig.heightMultiplier * 1.4,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SvgPicture.asset(
            icon,
            color: MyColors.darkGreen,
            height: SizeConfig.heightMultiplier * height,
            width: SizeConfig.heightMultiplier * width,
          ),
          SizedBox(
            width: SizeConfig.widthMultiplier * spaceBetween,
          ),
          Expanded(
            flex: 5,
            child: Text(
              name,
              style: TextStyle(
                fontSize: SizeConfig.textMultiplier * 1.8,
                color: Color(0xff707070),
              ),
            ),
          ),
          Expanded(
            flex: 4,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Text(
                    value,
                    style: TextStyle(
                      fontSize: SizeConfig.textMultiplier * 1.8,
                      color: Color(0xff707070),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
