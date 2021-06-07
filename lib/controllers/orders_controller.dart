import 'package:get/get.dart';
import 'package:deniz/controllers/main_page_controller.dart';
import '../models/order_product.dart';
import '../models/menu_item.dart';

import '../services/helper.dart';
import './menus_controller.dart';

class OrdersController extends GetxController {
  RxList<OrderProduct> orders;
  RxList<Map<String, dynamic>> items = List<Map<String, dynamic>>().obs;
  int deliveryCost = 0;
  Helper _helper;

  OrdersController() {
    _helper = Helper();
  }

  final MenusController _menusController = Get.put(MenusController());

  gotoPage(int index) {
    Get.find<MainPageController>().gotoPage(index);
  }

  addOrder(OrderProduct order, MenuItem item) async {
    if (orders != null && orders.any((element) => element.id == order.id)) {
      final o = orders.firstWhere((element) => element.id == order.id);
      o.count += order.count;
      // .count += order.count;
      var mi;
      var updateItem;
      if (_menusController.menus.any((element) => element.id == order.id)) {
        mi = _menusController.menus.firstWhere((e) => e.id == order.id);
      }
      if (mi != null) {
        updateItem = {'menu': mi, 'count': o.count};
      }

      if (mi != null && items.any((element) => element['menu'].id == mi.id)) {
        final i = items.firstWhere((element) => element['menu'].id == mi.id);
        final index = items.indexOf(i);
        items.remove(i);
        print(index);
        items.insert(index, updateItem);
        await _helper.updateOrder(updateItem);
      }
    } else {
      if (orders == null) {
        orders = List<OrderProduct>().obs;
      }
      orders.add(order);
      final mi = MenuItem(
        id: item.id,
        categoryId: item.categoryId,
        imageUrl: item.imageUrl,
        ingredients: item.ingredients,
        isFavorite: item.isFavorite,
        name: item.name,
        price: item.price,
        thumbUrl: item.thumbUrl,
      );
      final updateItem = {'menu': mi, 'count': order.count};
      items.add(updateItem);
      await _helper.insertOrder(updateItem);
    }
  }

  bool isExist(int id) {
    if (orders.any((element) => element.id == id)) {
      return true;
    } else {
      return false;
    }
  }

  Future<List<Map<String, dynamic>>> getItem() async {
    items = List<Map<String, dynamic>>().obs;
    orders = List<OrderProduct>().obs;
    List<Map<String, dynamic>> temps = await _helper.orders();

    temps.forEach(
      (element) {
        orders.add(
          OrderProduct(
            id: element['menu'].id,
            count: element['count'],
          ),
        );
        items.add(
          {
            'menu': element['menu'] as MenuItem,
            'count': element['count'],
          },
        );
      },
    );
    return items;
  }

  get total {
    int sum = 0;
    items.forEach((element) {
      sum += element['menu'].price * element['count'];
    });
    if (sum != 0) {
      sum += deliveryCost;
    }
    return sum;
  }

  increase(int i) async {
    final item = items[i];
    item['count']++;
    items.remove(item);
    items.insert(i, item);
    var or = orders.firstWhere((element) => element.id == items[i]['menu'].id);
    final index = orders.indexOf(or);
    orders.remove(or);
    or.count++;
    orders.insert(index, or);

    final mi = items[i]['menu'];
    final updateItem = {'menu': mi, 'count': or.count};
    await _helper.updateOrder(updateItem);
  }

  decrease(int i) async {
    final item = items[i];
    item['count']--;
    if (item['count'] <= 1) {
      item['count'] = 1;
    }
    items.remove(item);
    items.insert(i, item);
    var or = orders.firstWhere((element) => element.id == items[i]['menu'].id);
    final index = orders.indexOf(or);
    orders.remove(or);
    or.count--;
    if (or.count <= 1) {
      or.count = 1;
    }
    orders.insert(index, or);

    final mi = items[i]['menu'];
    final updateItem = {'menu': mi, 'count': or.count};
    await _helper.updateOrder(updateItem);
  }

  remove(int i) async {
    var or = orders.firstWhere((element) => element.id == items[i]['menu'].id);
    orders.remove(or);
    items.removeAt(i);
    await _helper.deleteOrder(or.id);
  }

  Future<void> removeById(int id) async {
    orders.remove(orders.firstWhere((element) => element.id == id));
    items.remove(items.firstWhere((element) => element['menu'].id == id));
    await _helper.deleteOrder(id);
  }

  getCount(index) {
    return orders
        .firstWhere((element) => element.id == items[index]['menu'].id)
        .count;
  }

  setDeliveryCost(int cost) {
    deliveryCost = cost;
  }
}
