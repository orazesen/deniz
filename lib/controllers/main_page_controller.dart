import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:deniz/pages/main_page.dart';

class MainPageController extends GetxController {
  late Rx<Widget> _mainPage;
  RxBool hasLeading = false.obs;

  late Function gotoPage;

  MainPageController(Function gotoPage) {
    mainPage = MainPage();
    this.gotoPage = gotoPage;
  }

  Widget get mainPage {
    return _mainPage.value;
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
