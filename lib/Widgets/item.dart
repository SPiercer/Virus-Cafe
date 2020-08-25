import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:my_startup/Helpers/Constants.dart';
import 'package:my_startup/models/item.dart';
import 'package:my_startup/providers/cart.dart';
import 'package:provider/provider.dart';

class ItemWidget extends StatelessWidget {
  final Item item;
  final int tableNum;
  final int priceValue;
  final TextEditingController amountCont = new TextEditingController();
  ItemWidget(this.item, this.tableNum, this.priceValue);
  @override
  Widget build(BuildContext context) {
    CartProvider cartProvider = Provider.of<CartProvider>(context);
    return Container(
        child: InkWell(
      onTap: () {
        showDialog(
            context: context,
            child: AlertDialog(
                title: Text('Select Amount'),
                content: Container(
                  height: MediaQuery.of(context).size.height / 4,
                  width: MediaQuery.of(context).size.width / 2,
                  child: Column(
                    children: <Widget>[
                      Center(
                        child: TextField(
                          decoration: new InputDecoration(
                            labelText: "Enter the amount of ${item.name}",
                          ),
                          keyboardType: TextInputType.number,
                          controller: amountCont,
                        ),
                      ),
                      RaisedButton(
                        onPressed: () {
                          Item cartItem = Item(
                              amount: double.parse(amountCont.text),
                              name: item.name,
                              price: item.price,
                              totalPrice: double.parse(amountCont.text) *
                                  item.price[priceValue]);
                          cartProvider.addToCartByID(cartItem, tableNum - 1);
                          print(cartProvider.cart[0].cartItems[0].name);
                          Navigator.pop(context);
                        },
                        child: Text('Sumbit'),
                      ),
                    ],
                  ),
                )));
      },
      child: Card(
        color: Colors.redAccent,
        child: Column(
          children: <Widget>[
            Image.network(item.img),
            Expanded(
              child: Container(
                width: MediaQuery.of(context).size.width,
                color: Colors.blueGrey,
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        '${item.price[priceValue]} L.E',
                        style: blackLargeTextBold,
                      ),
                      Text(
                        item.name,
                        style: blackSmallTextBold,
                      ),
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    ));
  }
}
