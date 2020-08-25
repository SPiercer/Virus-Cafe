import 'package:cloud_firestore/cloud_firestore.dart';

class Order {
  final List<dynamic> cart;
  final Timestamp time;
  final int priceValue;
  final double totalPrice;

  Order(this.cart, this.time, this.priceValue, this.totalPrice);

  Order.fromJson(Map<String, dynamic> json)
      : cart = json['cart'],
        time = json['time'],
        priceValue = json['price value'],
        totalPrice = json['Total'];

  Map<String, dynamic> toJson() => {
        'cart': cart,
        'time': time,
        'price value': priceValue,
        'Total': totalPrice
      };
}
