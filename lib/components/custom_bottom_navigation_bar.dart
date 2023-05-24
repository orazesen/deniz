import 'package:flutter/material.dart';
import 'package:deniz/style/my_colors.dart';
import 'package:deniz/style/text_styles.dart';
import 'package:deniz/utils/size_config.dart';

import '../models/custom_navigation_item.dart';

class CustomBottomNavigationBar extends StatelessWidget {
  final List<CustomBottomNavigationItem> items;
  final int currentIndex;
  final Function onTap;

  CustomBottomNavigationBar(
      {required this.items, required this.currentIndex, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: SizeConfig.widthMultiplier * 4,
        bottom: SizeConfig.widthMultiplier * 2,
        right: SizeConfig.widthMultiplier * 4,
      ),
      child: Container(
        constraints: BoxConstraints(
          maxHeight: SizeConfig.heightMultiplier * 8,
          minHeight: SizeConfig.heightMultiplier * 8,
          minWidth: double.infinity,
        ),
        decoration: BoxDecoration(
          color: MyColors.background,
          borderRadius: BorderRadius.circular(
            SizeConfig.borderRadius,
          ),
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: SizeConfig.widthMultiplier,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.baseline,
            children: [
              AnimatedContainer(
                child: (0 == currentIndex)
                    ? AnimatedOpacity(
                        opacity: 0 == currentIndex ? 1 : 0,
                        duration: Duration(milliseconds: 500),
                        child: GestureDetector(
                          onTap: () {
                            onTap(0);
                          },
                          child: Container(
                            // color: Colors.grey,
                            constraints: BoxConstraints(
                              minWidth: SizeConfig.widthMultiplier * 20,
                              // maxHeight: SizeConfig.heightMultiplier * 3,
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  items[0].name,
                                  style: TextStyles.small,
                                ),
                                SizedBox(
                                  height: SizeConfig.widthMultiplier,
                                ),
                                Container(
                                  height: SizeConfig.widthMultiplier * 2,
                                  width: SizeConfig.widthMultiplier * 2,
                                  decoration: BoxDecoration(
                                    color: MyColors.darkGreen,
                                    borderRadius: BorderRadius.circular(
                                      SizeConfig.borderRadius,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      )
                    : AnimatedOpacity(
                        opacity: 0 == currentIndex ? 0 : 1,
                        duration: Duration(milliseconds: 500),
                        child: Container(
                          // color: Colors.grey,
                          constraints: BoxConstraints(
                            minWidth: SizeConfig.widthMultiplier * 20,
                            maxHeight: SizeConfig.heightMultiplier * 4.4,
                          ),
                          child: IconButton(
                            highlightColor: Colors.transparent,
                            splashColor: Colors.transparent,
                            icon: Container(
                              child: items[0].icon,
                              height: SizeConfig.heightMultiplier * 4.4,
                            ),
                            // color: MyColors.iconInactive,
                            onPressed: () {
                              onTap(0);
                            },
                          ),
                        ),
                      ),
                duration: Duration(milliseconds: 50),
                alignment: Alignment.center,
                // layoutBuilder:
                //     (topChild, topChildKey, bottomChild, bottomChildKey) {
                //   return AnimatedOpacity(
                //     opacity: 1,
                //     duration: Duration(milliseconds: 300),
                //   );
                // },
              ),
              AnimatedContainer(
                child: (1 == currentIndex)
                    ? AnimatedOpacity(
                        opacity: 1 == currentIndex ? 1 : 0,
                        duration: Duration(milliseconds: 500),
                        child: Container(
                          // color: Colors.grey,
                          constraints: BoxConstraints(
                            minWidth: SizeConfig.widthMultiplier * 20,
                            //maxHeight: 24,
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                items[1].name,
                                style: TextStyles.small,
                              ),
                              SizedBox(
                                height: SizeConfig.widthMultiplier,
                              ),
                              Container(
                                height: SizeConfig.widthMultiplier * 2,
                                width: SizeConfig.widthMultiplier * 2,
                                decoration: BoxDecoration(
                                  color: MyColors.darkGreen,
                                  borderRadius: BorderRadius.circular(
                                    SizeConfig.borderRadius,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
                    : AnimatedOpacity(
                        opacity: 1 == currentIndex ? 0 : 1,
                        duration: Duration(milliseconds: 500),
                        child: Container(
                          // color: Colors.grey,
                          constraints: BoxConstraints(
                            minWidth: SizeConfig.widthMultiplier * 20,
                            maxHeight: SizeConfig.heightMultiplier * 4.6,
                          ),
                          child: IconButton(
                            highlightColor: Colors.transparent,
                            splashColor: Colors.transparent,
                            icon: Container(
                              child: items[1].icon,
                              height: SizeConfig.heightMultiplier * 4.6,
                            ),
                            // color: MyColors.iconInactive,
                            onPressed: () {
                              onTap(1);
                            },
                          ),
                        ),
                      ),
                duration: Duration(milliseconds: 50),
                alignment: Alignment.center,
                // layoutBuilder:
                //     (topChild, topChildKey, bottomChild, bottomChildKey) {
                //   return AnimatedOpacity(
                //     opacity: 1,
                //     duration: Duration(milliseconds: 300),
                //   );
                // },
              ),
              AnimatedContainer(
                child: (2 == currentIndex)
                    ? AnimatedOpacity(
                        opacity: 2 == currentIndex ? 1 : 0,
                        duration: Duration(milliseconds: 500),
                        child: Container(
                          // color: Colors.grey,
                          constraints: BoxConstraints(
                            minWidth: SizeConfig.widthMultiplier * 20,
                            //maxHeight: 24,
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                items[2].name,
                                style: TextStyles.small,
                              ),
                              SizedBox(
                                height: SizeConfig.widthMultiplier,
                              ),
                              Container(
                                height: SizeConfig.widthMultiplier * 2,
                                width: SizeConfig.widthMultiplier * 2,
                                decoration: BoxDecoration(
                                  color: MyColors.darkGreen,
                                  borderRadius: BorderRadius.circular(
                                    SizeConfig.borderRadius,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
                    : AnimatedOpacity(
                        opacity: 2 == currentIndex ? 0 : 1,
                        duration: Duration(milliseconds: 500),
                        child: Container(
                          // color: Colors.grey,
                          constraints: BoxConstraints(
                            minWidth: SizeConfig.widthMultiplier * 20,
                            maxHeight: SizeConfig.heightMultiplier * 4.4,
                          ),
                          child: IconButton(
                            highlightColor: Colors.transparent,
                            splashColor: Colors.transparent,
                            icon: Container(
                              child: items[2].icon,
                              height: SizeConfig.heightMultiplier * 4.4,
                            ),
                            // color: MyColors.iconInactive,
                            onPressed: () {
                              onTap(2);
                            },
                          ),
                        ),
                      ),
                duration: Duration(milliseconds: 50),
                alignment: Alignment.center,
                // layoutBuilder:
                //     (topChild, topChildKey, bottomChild, bottomChildKey) {
                //   return AnimatedOpacity(
                //     opacity: 1,
                //     duration: Duration(milliseconds: 300),
                //   );
                // },
              ),
              AnimatedContainer(
                child: (3 == currentIndex)
                    ? AnimatedOpacity(
                        opacity: 3 == currentIndex ? 1 : 0,
                        duration: Duration(milliseconds: 500),
                        child: Container(
                          // color: Colors.grey,
                          constraints: BoxConstraints(
                            minWidth: SizeConfig.widthMultiplier * 20,
                            //maxHeight: 24,
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                items[3].name,
                                style: TextStyles.small,
                              ),
                              SizedBox(
                                height: SizeConfig.widthMultiplier,
                              ),
                              Container(
                                height: SizeConfig.widthMultiplier * 2,
                                width: SizeConfig.widthMultiplier * 2,
                                decoration: BoxDecoration(
                                  color: MyColors.darkGreen,
                                  borderRadius: BorderRadius.circular(
                                    SizeConfig.borderRadius,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
                    : AnimatedOpacity(
                        opacity: 3 == currentIndex ? 0 : 1,
                        duration: Duration(milliseconds: 500),
                        child: Container(
                          // color: Colors.grey,
                          constraints: BoxConstraints(
                            minWidth: SizeConfig.widthMultiplier * 20,
                            maxHeight: SizeConfig.heightMultiplier * 4.4,
                          ),
                          child: IconButton(
                            highlightColor: Colors.transparent,
                            splashColor: Colors.transparent,
                            icon: Container(
                              child: items[3].icon,
                              height: SizeConfig.heightMultiplier * 4.4,
                            ),
                            // color: MyColors.iconInactive,
                            onPressed: () {
                              onTap(3);
                            },
                          ),
                        ),
                      ),
                duration: Duration(milliseconds: 50),
                alignment: Alignment.center,
                // layoutBuilder:
                //     (topChild, topChildKey, bottomChild, bottomChildKey) {
                //   return AnimatedOpacity(
                //     opacity: 1,
                //     duration: Duration(milliseconds: 300),
                //   );
                // },
              ),
            ], //navigationItems(items),
          ),
        ),
      ),
    );
  }

  List<Widget> navigationItems(List<CustomBottomNavigationItem> items) {
    List<Widget> widgets = [];
    items.forEach(
      (element) {
        widgets.add(
          AnimatedContainer(
            child: (element == items[currentIndex])
                ? AnimatedOpacity(
                    opacity: element == items[currentIndex] ? 1 : 0,
                    duration: Duration(milliseconds: 500),
                    child: Container(
                      // color: Colors.grey,
                      constraints: BoxConstraints(
                        minWidth: SizeConfig.widthMultiplier * 20,
                        //maxHeight: 24,
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            element.name,
                            style: TextStyles.small,
                          ),
                          SizedBox(
                            height: SizeConfig.widthMultiplier,
                          ),
                          Container(
                            height: SizeConfig.widthMultiplier * 2,
                            width: SizeConfig.widthMultiplier * 2,
                            decoration: BoxDecoration(
                              color: MyColors.darkGreen,
                              borderRadius: BorderRadius.circular(
                                4,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                : AnimatedOpacity(
                    opacity: element == items[currentIndex] ? 0 : 1,
                    duration: Duration(milliseconds: 500),
                    child: Container(
                      // color: Colors.grey,
                      constraints: BoxConstraints(
                        minWidth: SizeConfig.widthMultiplier * 20,
                        maxHeight: 36,
                      ),
                      child: IconButton(
                        highlightColor: Colors.transparent,
                        splashColor: Colors.transparent,
                        icon: Container(
                          child: element.icon,
                          height: SizeConfig.heightMultiplier * 3,
                        ),
                        // color: MyColors.iconInactive,
                        onPressed: () {
                          onTap(items.indexOf(element));
                        },
                      ),
                    ),
                  ),
            duration: Duration(milliseconds: 50),
            alignment: Alignment.center,
            // layoutBuilder:
            //     (topChild, topChildKey, bottomChild, bottomChildKey) {
            //   return AnimatedOpacity(
            //     opacity: 1,
            //     duration: Duration(milliseconds: 300),
            //   );
            // },
          ),
        );
        // } else {
        //   widgets.add(
        //     IconButton(
        //       highlightColor: Colors.transparent,
        //       icon: Container(
        //         child: element.icon,
        //         height: SizeConfig.heightMultiplier * 3,
        //       ),
        //       // color: MyColors.iconInactive,
        //       onPressed: () {
        //         widget.onTap(items.indexOf(element));
        //       },
        //     ),
        //   );
        // }
      },
    );
    return widgets;
  }
}
