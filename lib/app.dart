import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:saray_pub/pages/coffee_detail_page.dart';
import 'package:saray_pub/pages/map_page.dart';
import 'package:saray_pub/pages/video_player_page.dart';
import 'package:saray_pub/style/my_theme.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter/rendering.dart';
import './home.dart';

import './pages/menu.dart';
import './pages/product_detail.dart';
import './pages/coffee_page.dart';
import './pages/favorites_page.dart';
import 'pages/basket_page.dart';
import './pages/main_page.dart';
import './utils/size_config.dart';
import 'constants/constants.dart';
import 'localization/messages.dart';
import './pages/order_detail_page.dart';
import 'style/my_colors.dart';

class App extends StatefulWidget {
  @override
  _AppState createState() => _AppState();
}

class _AppState extends State<App> {
  init() async {
    final prefs = await SharedPreferences.getInstance();
    Locale _locale;
    if (prefs.containsKey(Constants.language)) {
      _locale = Locale(prefs.getString(Constants.language));
    } else {
      _locale = Locale('tr');
    }

    Get.updateLocale(_locale);
    await prefs.setString(Constants.language, Get.locale.languageCode);

    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light);
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarBrightness: Brightness.dark,
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
      ),
    );

    // FlutterStatusbarcolor.setStatusBarWhiteForeground(false);
    // FlutterStatusbarcolor.setStatusBarColor(Colors.red);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    init();
  }

  @override
  Widget build(BuildContext context) {
    // FlutterStatusbarcolor.setStatusBarWhiteForeground(false);
    // FlutterStatusbarcolor.setStatusBarColor(Colors.white);
    return LayoutBuilder(
      builder: (context, constraints) {
        SizeConfig().init(constraints);
        return GetMaterialApp(
          title: 'Saray',
          theme: MyTheme.lightTheme,
          // home: VideoPlayerPage(),
          initialRoute: HomePage.routeName,
          getPages: [
            GetPage(
              name: HomePage.routeName,
              page: () => HomePage(),
              transition: Transition.fade,
            ),
            GetPage(
              name: MainPage.routeName,
              page: () => MainPage(),
              transition: Transition.fade,
            ),
            GetPage(
              name: CoffeePage.routeName,
              page: () => CoffeePage(),
              transition: Transition.fade,
            ),
            GetPage(
              name: BasketPage.routeName,
              page: () => BasketPage(),
              transition: Transition.fade,
            ),
            GetPage(
              name: FavoritesPage.routeName,
              page: () => FavoritesPage(),
              transition: Transition.fade,
            ),
            GetPage(
              name: Menu.routeName,
              page: () => Menu(),
              transition: Transition.fade,
            ),
            GetPage(
              name: ProductDetail.routeName,
              page: () => ProductDetail(),
              transition: Transition.fade,
            ),
            GetPage(
              name: OrderDetailPage.routeName,
              page: () => OrderDetailPage(),
              transition: Transition.fade,
            ),
            GetPage(
              name: CoffeeDetail.routeName,
              page: () => CoffeeDetail(),
              transition: Transition.fade,
            ),
            GetPage(
              name: MapPage.routeName,
              page: () => MapPage(),
              transition: Transition.fade,
            ),
          ],
          debugShowCheckedModeBanner: false,
          translations: Messages(),
          // locale: _locale,
          // fallbackLocale: Locale('ru'),

          supportedLocales: [
            const Locale('tr'), // Turkmen
            const Locale('ru'), // Russian
            const Locale('en'), // English
          ],
          localizationsDelegates: [
            GlobalMaterialLocalizations.delegate,
            DefaultCupertinoLocalizations.delegate,
            DefaultMaterialLocalizations.delegate,
            DefaultWidgetsLocalizations.delegate,
          ],
        );
      },
    );
  }
}
