import 'item.dart';

class Cart {
  final List<Item> cartItems;
  final num cartID;
  Cart(this.cartItems, this.cartID);

  List<Map<String, dynamic>> toListOfJsons(int priceValue) {
    List<Map<String, dynamic>> list = [];
    Map<String, dynamic> item = {};
    for (int i = 0; i < cartItems.length; i++) {
      item['name'] = cartItems[i].name;
      item['amount'] = cartItems[i].amount;
      item['price'] = cartItems[i].price[priceValue];
      item['total'] = cartItems[i].totalPrice;
      list.add(item);
      item = {};
    }
    print(list);
    return list;
  }
}
