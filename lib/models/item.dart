class Item {
  final String name;
  final String img;
  final List price;
  double amount;
  double totalPrice;
  Item({this.name, this.img, this.price, this.amount, this.totalPrice});

  Item.fromJson(Map<String, dynamic> json)
      : name = json['name'],
        img = json['img'],
        price = json['price'];
  Map<String, dynamic> toJson() => {
        'name': name,
        'price': price,
        'amount': amount,
        'total price': totalPrice
      };
}
