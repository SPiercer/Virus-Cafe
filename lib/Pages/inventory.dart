import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:my_startup/Helpers/Constants.dart';
import 'package:my_startup/models/user.dart';

class InventoryPage extends StatefulWidget {
  final User user;
  InventoryPage(this.user);
  @override
  _InventoryPageState createState() => _InventoryPageState();
}

class _InventoryPageState extends State<InventoryPage> {
  Map<String, dynamic> totalMap = {};

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
        .collection('Users/${widget.user.uid}/Items')
        .where('time',
            isGreaterThanOrEqualTo: Timestamp.fromDate(from),
            isLessThanOrEqualTo: Timestamp.fromDate(to))
        .snapshots();
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
            child: Text(
              'Select Date',
              style: whiteSmallTextBold,
            ),
          )
        ],
        title: Text('Items'),
        centerTitle: true,
      ),
      body: StreamBuilder<QuerySnapshot>(
          stream: query == null
              ? Firestore.instance
                  .collection('Users/${widget.user.uid}/Items')
                  .snapshots()
              : query,
          builder: (context, snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.active:
                totalMap = {};
                for (var doc in snapshot.data.documents) {
                  for (var i = 0; i < doc.data.keys.length; i++) {
                    totalMap.remove('time');
                    if (totalMap.containsKey(doc.data.keys.toList()[i])) {
                      totalMap.update(doc.data.keys.toList()[i],
                          (value) => value + doc.data.values.toList()[i]);
                    } else {
                      totalMap[doc.data.keys.toList()[i]] =
                          doc.data.values.toList()[i];
                    }
                  }
                }
                return ListView(
                  shrinkWrap: true,
                  children: <Widget>[
                    ListView.builder(
                      shrinkWrap: true,
                      itemCount: snapshot.data.documents.length,
                      itemBuilder: (context, index) {
                        DocumentSnapshot item = snapshot.data.documents[index];

                        return ExpansionTile(
                          title: Text(item.documentID),
                          children: <Widget>[
                            ListView.builder(
                              shrinkWrap: true,
                              itemCount: item.data.keys.length,
                              itemBuilder: (context, index1) {
                                return ListTile(
                                    title: Text(
                                      item.data.keys
                                          .toList()[index1]
                                          .toString(),
                                      style: blackLargeTextBold,
                                    ),
                                    trailing: IconButton(
                                        onPressed: null,
                                        icon: Text(
                                          item.data.values
                                              .toList()[index1]
                                              .toString(),
                                          style: blackLargeTextBold,
                                        )));
                              },
                            ),
                          ],
                        );
                      },
                    ),
                    ExpansionTile(
                      title: Text('Total'),
                      children: <Widget>[
                        ListView.builder(
                          shrinkWrap: true,
                          itemCount: totalMap.keys.length,
                          itemBuilder: (context, index1) {
                            return ListTile(
                                title: Text(
                                  totalMap.keys.toList()[index1].toString(),
                                  style: blackLargeTextBold,
                                ),
                                trailing: IconButton(
                                    onPressed: null,
                                    icon: Text(
                                      totalMap.values
                                          .toList()[index1]
                                          .toString(),
                                      style: blackLargeTextBold,
                                    )));
                          },
                        ),
                      ],
                    ),
                  ],
                );
                break;
              case ConnectionState.waiting:
                return CircularProgressIndicator();
              default:
                return Container();
            }
          }),
    );
  }
}
