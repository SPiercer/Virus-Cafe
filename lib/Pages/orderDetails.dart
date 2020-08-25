import 'package:flutter/material.dart';
import 'package:my_startup/Helpers/Constants.dart';
import 'package:my_startup/models/order.dart';

class OrderDetailsPage extends StatefulWidget {
  final Order order;
  OrderDetailsPage(this.order);
  @override
  _OrderDetailsPageState createState() => _OrderDetailsPageState();
}

class _OrderDetailsPageState extends State<OrderDetailsPage> {
  List items = [];
  var itemsMap = {};

  void modelObject() {
    setState(() {
      itemsMap = {};
      items = [];
    });

    print(widget.order.cart.toSet());
    widget.order.cart.forEach((element) {
      items.add(element['name']);
    });
    items.forEach((element) {
      if (!itemsMap.containsKey(element)) {
        itemsMap[element] = 1;
      } else {
        itemsMap[element] += 1;
      }
    });

    setState(() {
      items = items.toSet().toList();
    });
  }

  @override
  void initState() {
    modelObject();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(widget.order.time.toDate().toString()),
      ),
      body: ListView(
        children: <Widget>[
          Container(
            child: Card(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Text('Order Details', style: blackLargeTextBold),
                  DataTable(
                    columns: [
                      DataColumn(
                          label: Text("item", style: blackSmallTextBold)),
                      DataColumn(
                          label: Text("count", style: blackSmallTextBold)),
                      DataColumn(
                          label: Text("price", style: blackSmallTextBold)),
                      DataColumn(
                          label: Text("total", style: blackSmallTextBold)),
                    ],
                    rows: List.generate(
                        items.length,
                        (index) => DataRow(cells: [
                              DataCell(Text(widget.order.cart[index]['name'])),
                              DataCell(Text("${widget.order.cart[index]['amount']}")),
                              DataCell(Text("${widget.order.cart[index]['price']}")),
                              DataCell(Text("${widget.order.cart[index]['total']}")),
                            ])),
                  ),
                  SizedBox(
                    height: 50,
                  ),
                  Text(
                    'Price Value : ${widget.order.priceValue == 0 ? 'Normal' : 'Staff'}  ',
                    style: blackSmallTextBold,
                  ),
                  Text(
                    "Total Price : ${widget.order.totalPrice} L.E",
                    style: blackLargeTextBold,
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
