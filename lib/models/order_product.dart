class OrderProduct {
  int id;
  int count;
  OrderProduct({this.id, this.count});

   Map<String, dynamic> toMap() {
    return {
      'id': id,
      'quantity' : count,
    };
  }
}
