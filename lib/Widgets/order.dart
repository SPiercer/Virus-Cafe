import 'package:flutter/material.dart';
import 'package:my_startup/models/order.dart';

class OrderWidget extends StatelessWidget {
  final Order order;
  OrderWidget(this.order);
  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    return Card(
      elevation: 5,
      child: Container(
        width: screenSize.width,
        height: screenSize.height * 0.15 + 10,
        child: Row(
          children: <Widget>[
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(order.time.toDate().toString(),
                    style: TextStyle(
                      fontSize: 22.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    )),
                Text('${order.totalPrice} L.E',
                    style: TextStyle(
                      fontSize: 18.0,
                      color: Colors.black,
                    )),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
