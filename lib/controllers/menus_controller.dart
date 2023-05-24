import 'package:get/get.dart';
import '../models/menu_item.dart';
import '../services/api.dart';
import './favorites_controller.dart';

class MenusController extends GetxController {
  RxList<MenuItem> _menus = RxList();
  RxList<DifferentMenu> differentMenus = RxList();
  late FavoritesController _favoritesController;
  int currentPage = 0;
  int lastPage = 0;

  List<MenuItem> get menus {
    return [..._menus];
  }

  //Do not set on your own
  set menus(List<MenuItem> menu) {
    _menus.value = menu;
  }

  checkCurrentMenus(int id) {
    print(id);
    if (isIdExist(id)) {
      print('exist');
      print(differentMenus.length);
      DifferentMenu dm =
          differentMenus.firstWhere((element) => element.id == id);
      print(dm.id);
      print(dm.items.length);

      dm.items.forEach((e) => print(e.name['tk']));
      menus = dm.items;
      currentPage = dm.currentPage!;
      lastPage = dm.lastPage!;
    }
  }

  bool isIdExist(int id) {
    return differentMenus.any((element) => element.id == id);
  }

  Future<void> getDishesById(int categoryId) async {
    print('get dishes by id');
    print(categoryId);
    _favoritesController = Get.find();
    final List<MenuItem> m = [];
    menus = RxList();
    try {
      final data = await Api.getMenus(categoryId);

      data.forEach((element) {
        final MenuItem temp = MenuItem(
          name: element['name'],
          id: element['id'],
          price: element['price'],
          //use 'thumb_url' for more detailed picture
          imageUrl: element['img_url'],
          thumbUrl: element['thumb_url'],
          ingredients: element['ingredients'].length <= 0
              ? {'en': '', 'tk': '', 'ru': ''}
              : element['ingredients'],
          categoryId: categoryId,
          isFavorite: _favoritesController.isFavorite(element['id']),
        );
        m.add(temp);
      });
      _menus.addAll(m);
      if (!isIdExist(categoryId)) {
        differentMenus.add(DifferentMenu(
          id: categoryId,
          items: _menus,
        ));
      }
    } catch (e) {
      throw (e);
    }
  }

  addFavorite(MenuItem item) async {
    final m = _menus.firstWhere((element) => element.id == item.id);
    final int index = _menus.indexOf(m);
    _menus.remove(m);
    final MenuItem i = MenuItem(
      id: m.id,
      categoryId: m.categoryId,
      imageUrl: m.imageUrl,
      ingredients: m.ingredients,
      isFavorite: true,
      name: m.name,
      price: m.price,
      thumbUrl: m.thumbUrl,
    );
    _menus.insert(index, i);
    _favoritesController.addFavorite(item);
  }

  removeFavorite(int id) async {
    final m = _menus.firstWhere((element) => element.id == id);
    final int index = _menus.indexOf(m);
    _menus.remove(m);
    final MenuItem i = MenuItem(
      id: m.id,
      categoryId: m.categoryId,
      imageUrl: m.imageUrl,
      ingredients: m.ingredients,
      isFavorite: false,
      name: m.name,
      price: m.price,
      thumbUrl: m.thumbUrl,
    );
    _menus.insert(index, i);
    _favoritesController.deleteFavorite(id);
  }
}

class DifferentMenu {
  final List<MenuItem> items;
  final int id;
  final int? currentPage;
  final int? lastPage;
  const DifferentMenu({
    required this.items,
    required this.id,
    this.currentPage,
    this.lastPage,
  });
}
