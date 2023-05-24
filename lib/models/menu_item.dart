class MenuItem {
  int id;
  Map<String, dynamic> name;
  String imageUrl;
  String thumbUrl;
  Map<String, dynamic> ingredients;
  int price;
  int categoryId;
  bool isFavorite;

  MenuItem({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.thumbUrl,
    required this.ingredients,
    required this.price,
    this.categoryId = -1,
    this.isFavorite = false,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nameTk': name['tk'],
      'nameRu': name['ru'],
      'nameEn': name['en'],
      'imageUrl': imageUrl,
      'thumbUrl': thumbUrl,
      'tk': ingredients['tk'],
      'ru': ingredients['ru'],
      'en': ingredients['en'],
      'price': price,
      'categoryId': categoryId,
      'isFavorite': 1,
    };
  }

  factory MenuItem.fromMap(Map<String, dynamic> map) {
    return MenuItem(
      id: map['id'],
      name: {
        'tk': map['nameTk'],
        'ru': map['nameRu'],
        'en': map['nameEn'],
      },
      imageUrl: map['imageUrl'],
      thumbUrl: map['thumbUrl'],
      ingredients: {
        'tk': map['tk'],
        'ru': map['ru'],
        'en': map['en'],
      },
      price: map['price'],
      categoryId: map['categoryId'],
      isFavorite: true,
    );
  }
}
