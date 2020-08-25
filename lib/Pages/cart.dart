import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/material.dart';
import 'package:my_startup/Helpers/Constants.dart';
import 'package:my_startup/models/cart.dart';
import 'package:my_startup/models/item.dart';
import 'package:my_startup/models/user.dart';
import 'package:my_startup/providers/cart.dart';
import 'package:my_startup/providers/count.dart';
import 'package:provider/provider.dart';

class OrdersPage extends StatefulWidget {
  final num tableNum;
  final int priceValue;
  OrdersPage(this.tableNum, this.priceValue);
  @override
  _OrdersPageState createState() => _OrdersPageState();
}

class _OrdersPageState extends State<OrdersPage> {
  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    CartProvider cartProvider = Provider.of<CartProvider>(context);
    final String uid = Provider.of<User>(context).uid;
    CountProvider countProvider = Provider.of<CountProvider>(context);
    double getTotal() {
      double total = 0;
      for (var item in cartProvider.cart[widget.tableNum].cartItems) {
        total += item.totalPrice;
      }
      return total;
    }

    return Scaffold(
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.check_circle_outline),
        onPressed: () async {
          if (cartProvider.cart[widget.tableNum].cartItems.isNotEmpty) {
            for (var item in cartProvider.cart[widget.tableNum].cartItems) {
              countProvider.increment(item.name, item.amount);
              /*   await Firestore.instance
                  .collection('Users/$uid/Items')
                  .document(item.name)
                  .setData({'count': FieldValue.increment(item.amount)},
                      merge: true);*/
            }
            /* 
            await Firestore.instance
                .collection('Users/$uid/Orders')
                .document(DateTime.now().toString())
                .setData({
              'cart': Cart(cartProvider.cart[widget.tableNum].cartItems, null)
                  .toListOfJsons(widget.priceValue),
              'price value': widget.priceValue,
              'time': Timestamp.now(),
              'Total': getTotal()
            });
            cartProvider.removeAll(widget.tableNum);

            Navigator.pop(context);*/
          } else {
            showDialog(
                context: context,
                child: AlertDialog(
                  title: Text(
                    'No Order Was Placed, The Cart Is Empty',
                    textAlign: TextAlign.center,
                    style: blackLargeTextBold,
                  ),
                ));
          }
        },
      ),
      appBar: AppBar(
        centerTitle: true,
        title: Text('Table ${widget.tableNum + 1}'),
      ),
      body: Center(
        child: ListView.builder(
          itemCount: cartProvider.cart[widget.tableNum].cartItems.length,
          itemBuilder: (context, index) {
            Item item = cartProvider.cart[widget.tableNum].cartItems[index];
            return Card(
              elevation: 5,
              child: Container(
                width: screenSize.width,
                height: screenSize.height * 0.2,
                child: Row(
                  children: <Widget>[
                    Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(item.name, style: blackLargeTextBold),
                        Text('${item.price[widget.priceValue]}',
                            style: TextStyle(
                              fontSize: 12.0,
                              color: Colors.black,
                            )),
                        Row(
                          children: <Widget>[
                            IconButton(
                                icon: Icon(Icons.add),
                                onPressed: () => cartProvider.increment(
                                    index, widget.tableNum, widget.priceValue)),
                            Text(item.amount.toString(),
                                style: TextStyle(
                                  fontSize: 12.0,
                                  color: Colors.black,
                                )),
                            IconButton(
                                icon: Icon(Icons.remove),
                                onPressed: () => cartProvider.decrement(
                                    index, widget.tableNum, widget.priceValue)),
                          ],
                        ),
                        Text('${item.totalPrice}',
                            style: TextStyle(
                              fontSize: 12.0,
                              color: Colors.black,
                            )),
                      ],
                    ),
                    Expanded(child: Card()),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        IconButton(
                          icon: Icon(Icons.delete),
                          color: Colors.redAccent,
                          onPressed: () =>
                              cartProvider.remove(index, widget.tableNum),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
