import 'package:get/get.dart';
import 'package:deniz/models/category_item.dart';

class CategoriesController extends GetxController {
  RxList<CategoryItem> _categories;

  List<CategoryItem> get categories {
    return _categories;
  }

  set categories(List<CategoryItem> cates) {
    _categories = RxList<CategoryItem>(cates);
  }

  Map<String, dynamic> getCategoryName(int id) {
    return _categories.firstWhere((element) => element.id == id).name;
  }

  Future<void> setCategories(dynamic data) async {
    _categories = List<CategoryItem>().obs;
    final RxList<CategoryItem> temp = RxList<CategoryItem>();

    try {
      data.forEach((element) {
        final CategoryItem category = CategoryItem(
          name: element['name'],
          id: element['id'],
          imageUrl: element['img_url'],
          thumbUrl: element['thumb_url'],
        );
        temp.add(category);
      });
    } catch (e) {
      throw (e);
    }

    _categories = temp;
  }
}
