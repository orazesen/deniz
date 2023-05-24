class Coffee {
  final int id;
  final Map<String, dynamic> name;
  final Map<String, dynamic> ingredients;
  final Map<String, dynamic> price;
  final String imgUrl;
  final String thumpUrl;

  Coffee({
    required this.id,
    required this.name,
    required this.ingredients,
    required this.price,
    required this.imgUrl,
    required this.thumpUrl,
  });
}
