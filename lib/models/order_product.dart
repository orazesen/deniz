class OrderProduct {
  int id;
  int count;
  OrderProduct({required this.id, required this.count});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'quantity': count,
    };
  }
}
