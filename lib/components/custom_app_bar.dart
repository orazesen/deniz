import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:deniz/constants/constants.dart';
import 'package:deniz/pages/main_page.dart';
import 'package:deniz/style/my_colors.dart';
import 'package:deniz/utils/size_config.dart';
import '../style/text_styles.dart';
import '../controllers/main_page_controller.dart';

class CustomAppBar extends StatelessWidget with PreferredSizeWidget {
  @override
  final Size preferredSize = AppBar().preferredSize;
  final int index;
  final Function showDetail;

  CustomAppBar({
    this.index,
    this.showDetail,
  });
  @override
  Widget build(BuildContext context) {
    return GetX<MainPageController>(
      builder: (controller) => AppBar(
        centerTitle: true,
        title: Padding(
          padding: EdgeInsets.only(bottom: 2),
          child: Text(
            index == 0
                ? !controller.hasLeading.value
                    ? 'SARAÝ PUB'
                    : ' '
                : 'coffee_title'.tr,
            style: TextStyles.title,
          ),
        ),
        elevation: 0.0,
        leading: controller.hasLeading.value && index == 0
            ? IconButton(
                icon: Icon(
                  Icons.arrow_back_ios,
                  size: SizeConfig.heightMultiplier * 2.6,
                  color: MyColors.darkGreen,
                ),
                onPressed: () {
                  controller.mainPage = MainPage();
                },
              )
            : index == 0
                ? Padding(
                    padding: EdgeInsets.only(
                      left: SizeConfig.widthMultiplier,
                    ),
                    child: IconButton(
                      icon: SvgPicture.asset(
                        Constants.info,
                        height: SizeConfig.heightMultiplier * 2.7,
                        color: MyColors.darkGreen,
                      ),
                      onPressed: () {
                        showDetail(context);
                      },
                    ),
                  )
                : Container(),
        actions: [
          controller.hasLeading.value && index == 0
              ? Container()
              : index == 0
                  ? Padding(
                      padding: const EdgeInsets.only(
                        right: 8.0,
                      ),
                      child: IconButton(
                        icon: SvgPicture.asset(
                          Constants.filter,
                          // height: SizeConfig.heightMultiplier * 2.6,
                          color: MyColors.darkGreen,
                        ),
                        onPressed: () {
                          // showDetail(context);
                        },
                      ),
                    )
                  : Container(),
          // Padding(
          //     padding: const EdgeInsets.only(
          //       right: 8.0,
          //     ),
          //     child: IconButton(
          //       icon: SvgPicture.asset(
          //         Constants.location,
          //         height: SizeConfig.heightMultiplier * 3,
          //         color: MyColors.darkGreen,
          //       ),
          //       onPressed: () {
          //         // showDetail(context);
          //       },
          //     ),
          //   ),
        ],
      ),
    );
  }
}
