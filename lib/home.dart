import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:deniz/controllers/coffee_menus_controller.dart';
import 'package:deniz/style/my_colors.dart';
import './pages/main_page.dart';
import './pages/favorites_page.dart';
import 'components/my_scroll_behavior.dart';
import 'controllers/banners_controller.dart';
import 'controllers/categories_controller.dart';
import 'controllers/menus_controller.dart';
import 'controllers/orders_controller.dart';
import 'pages/basket_page.dart';
import './controllers/main_page_controller.dart';
import './controllers/favorites_controller.dart';
import 'pages/settings_page.dart';

class HomePage extends StatefulWidget implements PreferredSizeWidget {
  static String routeName = '/';
  final Size preferredSize = AppBar().preferredSize;
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late MainPageController _mainPageController;
  final BannersController _bannersController = Get.put(BannersController());
  final FavoritesController _favoritesController =
      Get.put(FavoritesController());
  final MenusController _menusController = Get.put(MenusController());
  final OrdersController _ordersController = Get.put(OrdersController());
  final CategoriesController _categoriesController =
      Get.put(CategoriesController());
  final CoffeeMenusController _coffeeMenusController =
      Get.put(CoffeeMenusController());

  int index = 0;
  List<Widget> pages = [
    MainPage(),
    BasketPage(),
    FavoritesPage(),
    SettingsPage(),
  ];
  // PageController _pageController = PageController(
  //   initialPage: 0,
  // );

  gotoPage(int i) {
    setState(() {
      final old = index;
      index = i;
      // if ((old < i && old + 1 == i) || (old > i && old - 1 == i)) {
      //   _pageController.animateToPage(index,
      //       duration: Duration(milliseconds: 500), curve: Curves.easeOut);
      // } else {
      //   _pageController.jumpToPage(index);
      // }
      _mainPageController.mainPage = MainPage();
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _mainPageController = Get.put(
      MainPageController(gotoPage),
    );
  }

  // @override
  // void didUpdateWidget(covariant HomePage oldWidget) {
  //   // TODO: implement didUpdateWidget
  //   super.didUpdateWidget(oldWidget);
  //   SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark.copyWith(
  //     statusBarColor: Colors.white,
  //     /* set Status bar color in Android devices. */

  //     statusBarIconBrightness: Brightness.light,
  //     /* set Status bar icons color in Android devices.*/

  //     statusBarBrightness: Brightness.light,
  //   ) /* set Status bar icon color in iOS. */
  //       );
  // }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark.copyWith(
      statusBarColor: Colors.transparent,
      /* set Status bar color in Android devices. */

      statusBarIconBrightness: Brightness.dark,
      /* set Status bar icons color in Android devices.*/

      statusBarBrightness: Brightness.light,
    ) /* set Status bar icon color in iOS. */
        );
    return WillPopScope(
      onWillPop: () async {
        return _willPop(context);
      },
      child: Scaffold(
        body: ScrollConfiguration(
          behavior: MyBehavior(),
          child: SafeArea(
            child: Stack(
              alignment: Alignment.topCenter,
              children: [
                // SizedBox.expand(
                //   child: PageView(
                //     controller: _pageController,
                //     onPageChanged: (value) {
                //       setState(() {
                //         index = value;
                //       });
                //     },
                //     children: [
                index == 0
                    ? GetX<MainPageController>(builder: (s) => s.mainPage)
                    : pages[index],
                // CoffeePage(),
                // BasketPage(),
                // FavoritesPage(),
                // ],
                // ),
                // ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    height: 40,
                    color: MyColors.white,
                  ),
                ),
                // Align(
                //   alignment: Alignment.bottomCenter,
                //   child: CustomBottomNavigationBar(
                //     items: [
                //       CustomBottomNavigationItem(
                //         name: 'menu'.tr,
                //         icon: SvgPicture.asset(
                //           Constants.menu,
                //           color: MyColors.darkGreen,
                //         ),
                //       ),
                //       CustomBottomNavigationItem(
                //         name: 'coffee'.tr,
                //         icon: SvgPicture.asset(
                //           Constants.coffee,
                //           color: MyColors.darkGreen,
                //         ),
                //       ),
                //       CustomBottomNavigationItem(
                //         name: 'basket'.tr,
                //         icon: SvgPicture.asset(
                //           Constants.basket,
                //           color: MyColors.darkGreen,
                //         ),
                //       ),
                //       CustomBottomNavigationItem(
                //         name: 'favorite'.tr,
                //         icon: SvgPicture.asset(
                //           Constants.favoriteFill,
                //           color: MyColors.darkGreen,
                //         ),
                //       ),
                //     ],
                //     currentIndex: index,
                //     onTap: (i) {
                //       setState(
                //         () {
                //           final old = index;
                //           index = i;
                //           if (i == 0 &&
                //               old == 0 &&
                //               _mainPageController.hasLeading.value) {
                //             _mainPageController.mainPage = MainPage();
                //           }
                //           // if ((old < i && old + 1 == i) ||
                //           //     (old > i && old - 1 == i)) {
                //           //   _pageController.animateToPage(index,
                //           //       duration: Duration(milliseconds: 500),
                //           //       curve: Curves.easeOut);
                //           // } else {
                //           //   _pageController.jumpToPage(index);
                //           // }
                //         },
                //       );
                //     },
                //   ),
                // ),
              ],
            ),
          ),
        ),
        bottomNavigationBar: BottomNavigationBar(
          items: [
            BottomNavigationBarItem(
              icon: Icon(
                Icons.restaurant_menu,
              ),
              label: 'menu'.tr,
            ),
            BottomNavigationBarItem(
              icon: Icon(
                Icons.shopping_basket,
              ),
              label: 'basket'.tr,
            ),
            BottomNavigationBarItem(
              icon: Icon(
                Icons.favorite,
              ),
              label: 'favorite'.tr,
            ),
            BottomNavigationBarItem(
              icon: Icon(
                Icons.settings,
              ),
              label: 'settings'.tr,
            ),
          ],
          currentIndex: index,
          onTap: (i) {
            setState(
              () {
                final old = index;
                index = i;
                if (i == 0 &&
                    old == 0 &&
                    _mainPageController.hasLeading.value) {
                  _mainPageController.mainPage = MainPage();
                }
                // if ((old < i && old + 1 == i) ||
                //     (old > i && old - 1 == i)) {
                //   _pageController.animateToPage(index,
                //       duration: Duration(milliseconds: 500),
                //       curve: Curves.easeOut);
                // } else {
                //   _pageController.jumpToPage(index);
                // }
              },
            );
          },
        ),
      ),
    );
  }

  _willPop(BuildContext context) async {
    if (_mainPageController.hasLeading.value) {
      _mainPageController.mainPage = MainPage();
    } else {
      // final bool willPop = await showDialog(
      //   context: context,
      //   barrierDismissible: true,
      //   builder: (c) => AlertDialog(
      //     actions: [
      //       FlatButton(
      //         child: Text(
      //           'yes'.tr,
      //         ),
      //         onPressed: () {
      //           Navigator.of(context).pop(true);
      //         },
      //       ),
      //       FlatButton(
      //         child: Text(
      //           'no'.tr,
      //         ),
      //         onPressed: () {
      //           Navigator.of(context).pop(false);
      //         },
      //       ),
      //     ],
      //     title: Text(
      //       'exit_confirmation'.tr,
      //     ),
      //   ),
      // );
      // if (willPop)
      await SystemChannels.platform
          .invokeMethod<void>('SystemNavigator.pop', true);
    }
  }
}
