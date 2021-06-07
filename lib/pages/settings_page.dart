import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:saray_pub/constants/constants.dart';
import 'package:saray_pub/style/my_colors.dart';
import 'package:saray_pub/utils/size_config.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'settings'.tr,
        ),
        elevation: 0.0,
      ),
      body: ListView(
        children: [
          ListTile(
            leading: Icon(
              Icons.language,
            ),
            title: Text(
              'language'.tr,
            ),
            onTap: () async {
              final Locale locale = await showModalBottomSheet(
                backgroundColor: Colors.transparent,
                context: context,
                builder: (context) {
                  return Container(
                    height: SizeConfig.heightMultiplier * 24,
                    decoration: BoxDecoration(
                      color: MyColors.white,
                    ),
                    child: Column(
                      children: [
                        ListTile(
                          title: Text('Türkmençe'),
                          onTap: () {
                            Get.back(
                              result: Locale(
                                'tr',
                                'TR',
                              ),
                            );
                          },
                        ),
                        Divider(
                          height: SizeConfig.widthMultiplier,
                        ),
                        ListTile(
                          title: Text('Русский'),
                          onTap: () {
                            Get.back(
                              result: Locale(
                                'ru',
                                'RU',
                              ),
                            );
                          },
                        ),
                        Divider(
                          height: SizeConfig.widthMultiplier,
                        ),
                        ListTile(
                          title: Text('English'),
                          onTap: () {
                            Get.back(
                              result: Locale(
                                'en',
                                'EN',
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  );
                },
              );

              if (locale != null) {
                Get.updateLocale(locale);
                SharedPreferences pref = await SharedPreferences.getInstance();
                await pref.setString(Constants.language, locale.languageCode);
              }
            },
          ),
        ],
      ),
    );
  }
}
