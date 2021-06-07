import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:deniz/models/menu_item.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../controllers/favorites_controller.dart';

final String databaseName = 'saray.db';

final String tableFavorites = 'favorites';
final String tableOrders = 'orders';

//Favorites
final String columnFId = 'id';
final String columnFNameTk = 'nameTk';
final String columnFNameRu = 'nameRu';
final String columnFNameEn = 'nameEn';
final String columnFImageUrl = 'imageUrl';
final String columnFThumbUrl = 'thumbUrl';
final String columnFIngredientsTk = 'tk';
final String columnFIngredientsRu = 'ru';
final String columnFIngredientsEn = 'en';
final String columnFPrice = 'price';
final String columnFIsFavorite = 'isFavorite';
final String columnFCId = 'categoryId';

//Orders
final String columnId = 'id';
final String columnNameTk = 'nameTk';
final String columnNameRu = 'nameRu';
final String columnNameEn = 'nameEn';
final String columnImageUrl = 'imageUrl';
final String columnThumbUrl = 'thumbUrl';
final String columnIngredientsTk = 'tk';
final String columnIngredientsRu = 'ru';
final String columnIngredientsEn = 'en';
final String columnPrice = 'price';
final String columnCategoryId = 'categoryId';
final String columnIsFavorite = 'isFavorite';
final String columnCount = 'count';

class Helper {
  var database;
  Helper() {
    init();
  }

  init() async {
    WidgetsFlutterBinding.ensureInitialized();
    String path = join(
      await getDatabasesPath(),
      databaseName,
    );
    bool isExist = await databaseFactory.databaseExists(path);
    if (isExist) {
      database = openDatabase(
        path,
        version: 1,
      );
    } else {
      database = openDatabase(
        path,
        version: 1,
        onCreate: (db, version) => _createTabels(db, version),
      );
    }
    Get.find<FavoritesController>().setItems(
      await favorites(),
    );
  }

  void _createTabels(Database db, int newVersion) async {
    await db.execute('''
   create table $tableFavorites (
    $columnFId integer,
    $columnFNameTk text not null,
    $columnFNameRu text not null,
    $columnFNameEn text not null,
    $columnFImageUrl text not null,
    $columnFThumbUrl text not null,
    $columnFIngredientsTk text not null,
    $columnFIngredientsRu text not null,
    $columnFIngredientsEn text not null,
    $columnFPrice integer,
    $columnFIsFavorite integer,
    $columnFCId integer
   )''');

    await db.execute('''
   create table $tableOrders (
    $columnId integer,
    $columnNameTk text not null,
    $columnNameRu text not null,
    $columnNameEn text not null,
    $columnImageUrl text not null,
    $columnThumbUrl text not null,
    $columnIngredientsTk text not null,
    $columnIngredientsRu text not null,
    $columnIngredientsEn text not null,
    $columnPrice integer,
    $columnCategoryId integer,
    $columnIsFavorite integer,
    $columnCount integer
   )''');
  }

  Future<void> insertFavorite(MenuItem item) async {
    final Database db = await database;
    Map<String, dynamic> map = item.toMap();
    try {
      await db.insert(
        tableFavorites,
        map,
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    } catch (e) {
      throw (e);
    }
  }

  Future<List<MenuItem>> favorites({int catId = -1}) async {
    final Database db = await database;
    List<Map<String, dynamic>> maps;
    if (catId == -1) {
      maps = await db.query(tableFavorites);
    } else {
      maps = await db.query(
        tableFavorites,
        where: "$columnFCId = $catId",
      );
    }
    return List.generate(maps.length, (i) {
      return MenuItem().fromMap(maps[i]);
    });
  }

  Future<void> updateFavorite(MenuItem item) async {
    final db = await database;
    await db.update(
      tableFavorites,
      item.toMap(),
      where: "$columnFId = ?",
      whereArgs: [item.id],
    );
  }

  Future<void> deleteFavorite(int id) async {
    final db = await database;
    await db.delete(
      tableFavorites,
      where: "$columnFId = ?",
      whereArgs: [id],
    );
  }

  Future<void> insertOrder(Map<String, dynamic> item) async {
    final Database db = await database;
    final map = {
      columnId: item['menu'].id,
      columnNameTk: item['menu'].name['tk'],
      columnNameRu: item['menu'].name['ru'],
      columnNameEn: item['menu'].name['en'],
      columnImageUrl: item['menu'].imageUrl,
      columnThumbUrl: item['menu'].thumbUrl,
      columnCategoryId: item['menu'].categoryId,
      columnIngredientsTk: item['menu'].ingredients['tk'],
      columnIngredientsRu: item['menu'].ingredients['ru'],
      columnIngredientsEn: item['menu'].ingredients['en'],
      columnPrice: item['menu'].price,
      columnIsFavorite: item['menu'].isFavorite ? 1 : 0,
      columnCount: item['count'],
    };

    await db.insert(
      tableOrders,
      map,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<Map<String, dynamic>>> orders() async {
    final Database db = await database;

    final List<Map<String, dynamic>> maps = await db.query(tableOrders);
    final list = List.generate(
      maps.length,
      (i) {
        return {
          'menu': MenuItem(
            id: maps[i][columnId],
            categoryId: maps[i][columnCategoryId],
            imageUrl: maps[i][columnImageUrl],
            ingredients: {
              'tk': maps[i][columnIngredientsTk],
              'ru': maps[i][columnIngredientsRu],
              'en': maps[i][columnIngredientsEn],
            },
            isFavorite: maps[i][columnIsFavorite] == 1 ? true : false,
            name: {
              'tk': maps[i][columnNameTk],
              'ru': maps[i][columnNameRu],
              'en': maps[i][columnNameEn]
            },
            price: maps[i][columnPrice],
            thumbUrl: maps[i][columnThumbUrl],
          ),
          'count': maps[i][columnCount],
        };
      },
    );
    return list;
  }

  Future<void> updateOrder(Map<String, dynamic> item) async {
    final db = await database;
    final map = {
      columnId: item['menu'].id,
      columnNameTk: item['menu'].name['tk'],
      columnNameRu: item['menu'].name['ru'],
      columnNameEn: item['menu'].name['en'],
      columnImageUrl: item['menu'].imageUrl,
      columnThumbUrl: item['menu'].thumbUrl,
      columnCategoryId: item['menu'].categoryId,
      columnIngredientsTk: item['menu'].ingredients['tk'],
      columnIngredientsRu: item['menu'].ingredients['ru'],
      columnIngredientsEn: item['menu'].ingredients['en'],
      columnPrice: item['menu'].price,
      columnIsFavorite: item['menu'].isFavorite ? 1 : 0,
      columnCount: item['count'],
    };
    await db.update(
      tableOrders,
      map,
      where: "$columnId = ?",
      whereArgs: [item['menu'].id],
    );
  }

  Future<void> deleteOrder(int id) async {
    final db = await database;
    await db.delete(
      tableOrders,
      where: "$columnId = ?",
      whereArgs: [id],
    );
  }
}
