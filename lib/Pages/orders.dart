import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:my_startup/Helpers/Constants.dart';
import 'package:my_startup/Pages/orderDetails.dart';
import 'package:my_startup/Widgets/order.dart';
import 'package:my_startup/models/order.dart';
import 'package:my_startup/models/user.dart';

class OrdersListPage extends StatefulWidget {
  final User user;
  OrdersListPage(this.user);
  @override
  _OrdersListPageState createState() => _OrdersListPageState();
}

class _OrdersListPageState extends State<OrdersListPage> {
  @override
  void initState() {
    super.initState();
  }

  void getQuery() async {
    DateTime from;
    DateTime to;
    await showDatePicker(
            context: context,
            helpText: 'Select First Date',
            initialDate: DateTime.now(),
            firstDate: DateTime(2020),
            lastDate: DateTime(2050))
        .then((value) => setState(() => from = value));
    await showDatePicker(
            context: context,
            helpText: 'Select Second Date',
            initialDate: DateTime.now(),
            firstDate: DateTime(2020),
            lastDate: DateTime(2050))
        .then((value) => setState(() => to = value));
    Stream<QuerySnapshot> firestore;
    firestore = Firestore.instance
        .collection('Users/${widget.user.uid}/Orders')
        .where('time',
            isGreaterThanOrEqualTo: Timestamp.fromDate(from),
            isLessThanOrEqualTo: Timestamp.fromDate(to))
        .snapshots();
    print(firestore);
    setState(() => query = firestore);
  }

  Stream<QuerySnapshot> query;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          actions: <Widget>[
            FlatButton(
              onPressed: getQuery,
              child: Text('Select Date',style: whiteSmallTextBold,),
            )
          ],
          centerTitle: true,
          title: Text("${widget.user.name}'s orders"),
        ),
        body: StreamBuilder<QuerySnapshot>(
            stream: query == null
                ? Firestore.instance
                    .collection('Users/${widget.user.uid}/Orders')
                    .snapshots()
                : query,
            builder: (context, snapshot) {
              switch (snapshot.connectionState) {
                case ConnectionState.waiting:
                  return CircularProgressIndicator();
                  break;
                case ConnectionState.active:
                  return ListView.builder(
                      itemCount: snapshot.data.documents.length,
                      itemBuilder: (context, index) {
                        Map<String, dynamic> order =
                            snapshot.data.documents[index].data;

                        return InkWell(
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    OrderDetailsPage(Order.fromJson(order))),
                          ),
                          child: OrderWidget(Order.fromJson(order)),
                        );
                      });
                  break;
                default:
                  Container();
              }
              return null;
            }));
  }
}
