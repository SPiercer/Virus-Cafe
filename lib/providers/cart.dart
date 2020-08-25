import 'package:flutter/material.dart';
import 'package:my_startup/models/cart.dart';
import 'package:my_startup/models/item.dart';

class CartProvider extends ChangeNotifier {
  final List<Cart> _carts = List.generate(7, (index) => Cart([], index));

  List<Cart> get cart => _carts;

  void remove(int index, num cartID) {
    _carts[cartID].cartItems.removeAt(index);
    notifyListeners();
  }

  void removeAll(num cartID) {
    _carts[cartID].cartItems.clear();
  }

  void addToCartByID(Item item, num cartID) {
    _carts[cartID].cartItems.add(item);
    notifyListeners();
  }

  void increment(int index, num cartID, int priceValue) {
    if (cartID == 6) {
      priceValue = 1;
    }
    print(priceValue);
    _carts[cartID].cartItems[index].amount++;
    _carts[cartID].cartItems[index].totalPrice =
        _carts[cartID].cartItems[index].amount *
            _carts[cartID].cartItems[index].price[priceValue];

    notifyListeners();
  }

  void decrement(int index, num cartID, int priceValue) {
    if (cartID == 6) {
      priceValue = 1;
    }
    _carts[cartID].cartItems[index].amount--;
    _carts[cartID].cartItems[index].totalPrice =
        _carts[cartID].cartItems[index].amount *
            _carts[cartID].cartItems[index].price[priceValue];

    notifyListeners();
  }
}
