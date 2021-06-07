import 'package:get/get.dart';
import 'package:deniz/controllers/menus_controller.dart';
import '../models/menu_item.dart';
import '../services/helper.dart';

class FavoritesController extends GetxController {
  RxList<MenuItem> items;
  MenusController _menusController;

  Helper helper;
  FavoritesController() {
    helper = Helper();
  }

  Future<List<MenuItem>> getItems() async {
    _menusController = Get.put(MenusController());
    return items.toList();
  }

  setItems(List<MenuItem> its) {
    items = RxList<MenuItem>(its);
  }

  addFavorite(MenuItem item) async {
    final MenuItem i = MenuItem(
      categoryId: item.categoryId,
      id: item.id,
      imageUrl: item.imageUrl,
      ingredients: item.ingredients,
      isFavorite: true,
      name: item.name,
      price: item.price,
      thumbUrl: item.thumbUrl,
    );
    items.add(i);
    await helper.insertFavorite(i);
  }

  removeFromItemList(id) {
    print(items.length);
    _menusController = Get.put(MenusController());
    if (items.any((element) => element.id == id)) {
      final MenuItem item = items.firstWhere((element) => element.id == id);
      items.remove(item);
      if (_menusController.differentMenus != null &&
          _menusController.differentMenus
              .any((element) => element.id == item.categoryId)) {
        DifferentMenu fItem = _menusController.differentMenus.firstWhere(
          (element) => element.id == item.categoryId,
        );

        if (fItem.items.any((element) => element.id == item.id)) {
          final MenuItem i = fItem.items.firstWhere(
            (element) => element.id == id,
          );
          final int index = fItem.items.indexOf(i);
          fItem.items.remove(i);
          fItem.items.insert(
            index,
            MenuItem(
              id: i.id,
              categoryId: i.categoryId,
              imageUrl: i.imageUrl,
              ingredients: i.ingredients,
              isFavorite: false,
              name: i.name,
              price: i.price,
              thumbUrl: i.thumbUrl,
            ),
          );
        }
      }
    }
  }

  deleteFavorite(int id) async {
    removeFromItemList(id);
    await helper.deleteFavorite(id);
  }

  bool isFavorite(int id) {
    final i = items.firstWhere((element) => element.id == id,
        orElse: () => MenuItem());
    return i.isFavorite ?? false;
  }
}
