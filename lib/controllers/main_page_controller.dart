import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:saray_pub/pages/main_page.dart';

class MainPageController extends GetxController {
  Rx<Widget> _mainPage = Rx<Widget>();
  RxBool hasLeading = false.obs;

  Function gotoPage;

  MainPageController(Function gotoPage) {
    mainPage = MainPage();
    this.gotoPage = gotoPage;
  }

  get mainPage {
    return _mainPage;
  }

  set mainPage(Widget page) {
    _mainPage.value = page;
    if (page.toString() == 'Menu') {
      hasLeading.value = true;
    } else {
      hasLeading.value = false;
    }
  }
}
