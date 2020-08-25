import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:my_startup/Helpers/Constants.dart';

class InventoryAllPage extends StatefulWidget {
  @override
  _InventoryAllPageState createState() => _InventoryAllPageState();
}

class _InventoryAllPageState extends State<InventoryAllPage> {
  Map<String, dynamic> totalMap = {};
  List<DocumentSnapshot> allshit = [];
  Map<String, dynamic> perMap = {};
  Future<void> getShit() async {
    await Firestore.instance.collection('Users').getDocuments().then((value) {
      for (var user in value.documents) {
        Firestore.instance
            .collection('Users/${user.documentID}/Items')
            .getDocuments()
            .then((event) {
          setState(() {
            allshit.addAll(event.documents);
          });
          for (var doc in allshit) {
            for (var i = 0; i < doc.data.keys.length; i++) {
              setState(() {
                perMap.remove('time');
              });
              if (perMap.containsKey(doc.data.keys.toList()[i])) {
                setState(() {
                  perMap.update(doc.data.keys.toList()[i],
                      (value) => value + doc.data.values.toList()[i]);
                });
              } else {
                setState(() {
                  perMap[doc.data.keys.toList()[i]] =
                      doc.data.values.toList()[i];
                });
              }
            }
          }
          
        });
      }
    });
    print(allshit);
  }

  @override
  void initState() {
    getShit();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Items'),
          centerTitle: true,
        ),
        body: ListView(
          shrinkWrap: true,
          children: <Widget>[
            ListView.builder(
              shrinkWrap: true,
              itemCount: allshit.length,
              itemBuilder: (context, index) {
                DocumentSnapshot item = allshit[index];

                return ExpansionTile(
                  title: Text(item.documentID),
                  children: <Widget>[
                    ListView.builder(
                      shrinkWrap: true,
                      itemCount: item.data.keys.length,
                      itemBuilder: (context, index1) {
                        return ListTile(
                            title: Text(
                              item.data.keys.toList()[index1].toString(),
                              style: blackLargeTextBold,
                            ),
                            trailing: IconButton(
                                onPressed: null,
                                icon: Text(
                                  item.data.values.toList()[index1].toString(),
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
                              totalMap.values.toList()[index1].toString(),
                              style: blackLargeTextBold,
                            )));
                  },
                ),
              ],
            ),
          ],
        ));
  }
}
