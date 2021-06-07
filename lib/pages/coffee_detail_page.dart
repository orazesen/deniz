import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:deniz/components/my_scroll_behavior.dart';
import 'package:deniz/constants/constants.dart';
import 'package:deniz/models/coffee.dart';
import 'package:deniz/style/my_colors.dart';
import 'package:deniz/style/text_styles.dart';
import 'package:deniz/utils/size_config.dart';
import 'package:url_launcher/url_launcher.dart';

class CoffeeDetail extends StatefulWidget {
  static String routeName = '/coffeeDetail';
  // final Coffee coffee;

  // CoffeeDetail({this.coffee});
  @override
  _CoffeeDetailState createState() => _CoffeeDetailState();
}

class _CoffeeDetailState extends State<CoffeeDetail> {
  String size = 's';

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // FlutterStatusbarcolor.setStatusBarWhiteForeground(false);
    // FlutterStatusbarcolor.setStatusBarColor(Colors.transparent);
  }

  @override
  Widget build(BuildContext context) {
    final String locale =
        Get.locale.languageCode == 'tr' ? 'tk' : Get.locale.languageCode;
    final Coffee coffee = ModalRoute.of(context).settings.arguments as Coffee;
    return Scaffold(
      body: Stack(
        children: [
          ScrollConfiguration(
            behavior: MyBehavior(),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                    height: SizeConfig.heightMultiplier * 40,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                        bottomRight: Radius.circular(
                          SizeConfig.heightMultiplier * 6,
                        ),
                      ),
                      color: MyColors.background,
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.only(
                        bottomRight: Radius.circular(
                          SizeConfig.heightMultiplier * 6,
                        ),
                      ),
                      child: Stack(
                        alignment: Alignment.bottomCenter,
                        children: [
                          Padding(
                            padding: EdgeInsets.symmetric(
                              vertical: SizeConfig.heightMultiplier * 2,
                            ),
                            child: Hero(
                              tag: coffee.id,
                              child: FadeInImage(
                                image: NetworkImage(coffee.imgUrl),
                                placeholder: AssetImage(
                                  Constants.coffeePlaceholder,
                                ),
                                alignment: Alignment.center,
                                fit: BoxFit.scaleDown,
                                height: SizeConfig.heightMultiplier * 30,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: SizeConfig.widthMultiplier * 4,
                      vertical: SizeConfig.heightMultiplier * 2,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          coffee.name[locale] ?? coffee.name['tk'],
                          style: TextStyles.header,
                        ),
                        SizedBox(
                          height: SizeConfig.heightMultiplier * 2.6,
                        ),
                        // Text(
                        //   'take_away_coffee'.tr, //widget.coffee.name['tk'],
                        //   style: TextStyles.body,
                        // ),
                        // SizedBox(
                        //   height: SizeConfig.heightMultiplier * 1.5,
                        // ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              width: SizeConfig.widthMultiplier * 45,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(
                                  TextStyles.title.fontSize,
                                ),
                                color: MyColors.background,
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    flex: 1,
                                    child: AnimatedContainer(
                                      duration: Duration(microseconds: 900),
                                      decoration: BoxDecoration(
                                        color: size == 's'
                                            ? MyColors.darkGreen
                                            : Colors.transparent,
                                        borderRadius: BorderRadius.circular(
                                          SizeConfig.borderRadius,
                                        ),
                                      ),
                                      child: IconButton(
                                        onPressed: () {
                                          setState(() {
                                            size = 's';
                                          });
                                        },
                                        icon: Text(
                                          's'.tr,
                                          style: TextStyle(
                                            color: size == 's'
                                                ? MyColors.white
                                                : MyColors.darkGreen,
                                            fontSize:
                                                SizeConfig.textMultiplier * 2.6,
                                          ),
                                        ),
                                        highlightColor: Colors.transparent,
                                        splashColor: Colors.transparent,
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    flex: 1,
                                    child: AnimatedContainer(
                                      duration: Duration(microseconds: 900),
                                      decoration: BoxDecoration(
                                        color: size == 'm'
                                            ? MyColors.darkGreen
                                            : Colors.transparent,
                                        borderRadius: BorderRadius.circular(
                                          SizeConfig.borderRadius,
                                        ),
                                      ),
                                      child: IconButton(
                                        onPressed: () {
                                          setState(() {
                                            size = 'm';
                                          });
                                        },
                                        icon: Text(
                                          'm'.tr,
                                          style: TextStyle(
                                            color: size == 'm'
                                                ? MyColors.white
                                                : MyColors.darkGreen,
                                            fontSize:
                                                SizeConfig.textMultiplier * 2.6,
                                          ),
                                        ),
                                        highlightColor: Colors.transparent,
                                        splashColor: Colors.transparent,
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    flex: 1,
                                    child: AnimatedContainer(
                                      duration: Duration(microseconds: 900),
                                      decoration: BoxDecoration(
                                        color: size == 'l'
                                            ? MyColors.darkGreen
                                            : Colors.transparent,
                                        borderRadius: BorderRadius.circular(
                                          SizeConfig.borderRadius,
                                        ),
                                      ),
                                      child: IconButton(
                                        onPressed: () {
                                          setState(() {
                                            size = 'l';
                                          });
                                        },
                                        icon: Text(
                                          'l'.tr,
                                          style: TextStyle(
                                            color: size == 'l'
                                                ? MyColors.white
                                                : MyColors.darkGreen,
                                            fontSize:
                                                SizeConfig.textMultiplier * 2.6,
                                          ),
                                        ),
                                        highlightColor: Colors.transparent,
                                        splashColor: Colors.transparent,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Text(
                              '${coffee.price[size]} TMT',
                              style: TextStyles.header,
                            ),
                          ],
                        ),
                        SizedBox(
                          height: SizeConfig.heightMultiplier * 3,
                        ),
                        Text('ingredients'.tr, style: TextStyles.body),
                        SizedBox(
                          height: SizeConfig.heightMultiplier,
                        ),
                        Text(
                          coffee.ingredients[locale] ??
                              coffee.ingredients['tk'] ??
                              '',
                          style: TextStyles.detail,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
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
                      launch('tel:+99365711811');
                      // Get.back();
                    },
                    child: Center(
                      child: Text(
                        'make_a_call'.tr,
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
          Positioned(
            top: SizeConfig.heightMultiplier * 4,
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
}
