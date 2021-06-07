import 'package:dio/dio.dart';
import 'package:get/get.dart' as GetX;
import 'package:mime/mime.dart';
import 'package:path_provider/path_provider.dart';
import 'package:saray_pub/controllers/categories_controller.dart';
import 'package:saray_pub/controllers/orders_controller.dart';
import 'package:saray_pub/models/banner.dart';
import 'package:saray_pub/models/menu_item.dart';
import '../controllers/banners_controller.dart';
import 'dart:io';

class Api {
  static String url = 'http://saraypub.com:8085/';
  static CategoriesController _categoriesController = GetX.Get.find();
  static BannersController _bannersController = GetX.Get.find();
  static OrdersController _ordersController = GetX.Get.find();

  static Future<bool> getInitials() async {
    final String capi = 'api/v1/categories';
    final String bapi = 'api/v1/banners';
    final String delPrice = 'api/v1/venue';
    Dio dio = Dio();
    try {
      var response = await Future.wait([
        dio.get(url + capi),
        dio.get(url + bapi),
        dio.get(url + delPrice),
      ]);

      final data = response[1].data as List;
      saveAsync(data);
      print('finished');

      _categoriesController.setCategories(response[0].data as List);
      _ordersController.setDeliveryCost(response[2].data['delivery_cost']);

      return true;
    } catch (e) {
      throw (e);
    }
  }

  static Future<List<Banner>> saveAsync(var data) async {
    var dir = await getApplicationDocumentsDirectory();
    print("path ${dir.path}");
    Dio dio = Dio();
    try {
      final GetX.RxList<Banner> temp = GetX.RxList<Banner>();
      // final prefs = await SharedPreferences.getInstance();
      // String locations = prefs.getString(Constants.fileLocations);
      print('start saving');
      await Future.forEach(data, (element) async {
        final String url = element['file_url'];
        final mimeType = lookupMimeType(url);
        // print(mimeType);
        final String id = url.split('.')[1].split('/')[2];

        // print('id: $id');
        final String fileName = id + '.' + mimeType.split('/')[1];
        // print(fileName);

        if (FileSystemEntity.typeSync(dir.path + '/' + fileName) !=
            FileSystemEntityType.notFound) {
          // List<String> locs = locations.split(',');
          // for (int i = 0; i < locs.length; i++) {
          //   if (File(locs[i]).existsSync()) {
          //     File(locs[i]).deleteSync(
          //       recursive: true,
          //     );
          //   }
          //   locations.replaceAll(locs[i] + '', '');
          // }
          print('file exist');
        } else {
          print('not found');
          // final result =
          await dio.download(url, dir.path + '/' + fileName);
          // locations += dir.path + '/' + fileName + ',';
          // print('result: ' + result.data.toString());
        }
        // prefs.setString(Constants.fileLocations, locations);

        final Banner banner = Banner(
          id: element['id'],
          fileUrl: dir.path + '/' + fileName,
          fileType: mimeType.split('/')[0],
        );
        temp.add(banner);
      });

      print('end saving');

      _bannersController.setBanners(temp);
      return temp;
    } catch (e) {
      throw (e);
    }
  }

//Getting categories
  static Future<List<dynamic>> getCategories() async {
    final String api = 'api/v1/categories';

    try {
      Response response = await Dio().get(url + api);
      return response.data as List;
    } catch (e) {
      throw e;
    }
  }

//Getting menus by category id
  static Future<List<dynamic>> getMenus(int id) async {
    String api = 'api/v1/dishes?category=$id';
    try {
      Response response = await Dio().get(url + api);
      return response.data['data'] as List;
    } catch (e) {
      throw e;
    }
  }

  static Future<List<dynamic>> getBanners() async {
    String api = 'api/v1/banners';
    try {
      Response response = await Dio().get(url + api);
      return response.data as List;
    } catch (e) {
      throw e;
    }
  }

  static Future<dynamic> postOrders(Map<String, dynamic> map) async {
    String api = 'api/v1/orders';
    try {
      Response response = await Dio().post(
        url + api,
        queryParameters: map,
      );
    } catch (e) {
      throw (e);
    }
  }

  static getCoffeeInitials(int page) async {
    final String capi = 'api/v1/coffees?page=$page';
    final String aapi = 'api/v1/coffees/addresses';
    Dio dio = Dio();
    try {
      var response = await Future.wait([
        dio.get(url + capi),
        dio.get(url + aapi),
      ]);
      return response;
    } catch (e) {
      throw (e);
    }
  }

  static Future<List<MenuItem>> getRecommendedDishes(int dishId) async {
    print('get recommended dishes');
    final String rapi = 'api/v1/dishes/$dishId/recommends';
    Dio dio = Dio();
    try {
      var response = await dio.get(url + rapi);
      List<MenuItem> items = List<MenuItem>();
      final data = response.data as List;
      print(data);
      data.forEach(
        (element) {
          items.add(
            MenuItem(
              name: element['name'],
              id: element['id'],
              price: element['price'],
              //use 'thumb_url' for more detailed picture
              imageUrl: element['img_url'],
              thumbUrl: element['thumb_url'],
              ingredients: element['ingredients'].length <= 0
                  ? {'en': '', 'tk': '', 'ru': ''}
                  : element['ingredients'],
              // categoryId: categoryId,
              // isFavorite: _favoritesController.isFavorite(element['id']),
            ),
          );
        },
      );
      print(items[0].name);
      return items;
    } catch (e) {
      throw (e);
    }
  }
}

// http://saraypub.test/api/v1/categories?lang=tk
// http://saraypub.test/api/v1/dishes?lang=tk
// http://saraypub.test/api/v1/dishes?category=1&lang=tk
// http://saraypub.test/api/v1/dishes?keyword=king&lang=tk
// http://saraypub.test/api/v1/dishes?category=1&keyword=king&lang=tk
// http://saraypub.test/api/v1/dishes/1?lang=tk

// Post http://saraypub.test/api/v1/orders
// BODY
// {
// "dishes": [
//    {
//      "id": 1,
//      "quantity": 3
//    },
//    {
//      "id": 2,
//      "quantity": 1
//    }
// ],
// "phone": "+99364856177",
// "address": "bos goyup bolyar"
// }
