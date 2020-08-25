import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:my_startup/Helpers/Constants.dart';
import 'package:path/path.dart' as p;

class EditItemsPage extends StatefulWidget {
  @override
  _EditItemsPageState createState() => _EditItemsPageState();
}

class _EditItemsPageState extends State<EditItemsPage> {
  List priceList = [];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () => showDialog(context: context, child: MyDialog2()),
        child: Icon(Icons.add),
      ),
      appBar: AppBar(
        title: Text('Edit Items'),
        centerTitle: true,
      ),
      body: ListView.builder(
        itemCount: 3,
        itemBuilder: (context, index) {
          List<String> types = ['Cold Drinks', 'Fast Foods', 'Hot Drinks'];
          return ExpansionTile(
            title: Text(types[index]),
            children: <Widget>[
              StreamBuilder<QuerySnapshot>(
                  stream:
                      Firestore.instance.collection(types[index]).snapshots(),
                  builder: (context, snapshot) {
                    switch (snapshot.connectionState) {
                      case ConnectionState.active:
                        return ListView.builder(
                          shrinkWrap: true,
                          itemCount: snapshot.data.documents.length,
                          itemBuilder: (context, index1) {
                            Map<String, dynamic> item =
                                snapshot.data.documents[index1].data;
                            return Dismissible(
                                onDismissed: (DismissDirection direction) {
                                  Firestore.instance
                                      .collection(types[index])
                                      .document(snapshot
                                          .data.documents[index1].documentID)
                                      .delete();
                                },
                                background: Container(color: Colors.red),
                                key: Key(index.toString()),
                                child: ListTile(
                                  title: Text(
                                    item['name'],
                                    style: blackSmallTextBold,
                                  ),
                                  trailing: IconButton(
                                      icon: Icon(Icons.edit),
                                      onPressed: () => showDialog(
                                          context: context,
                                          child: MyDialog(
                                              item,
                                              index,
                                              snapshot.data.documents[index1]
                                                  .documentID))),
                                ));
                          },
                        );
                        break;
                      case ConnectionState.waiting:
                        return CircularProgressIndicator();
                        break;
                      default:
                        return Container();
                    }
                  }),
            ],
          );
        },
      ),
    );
  }
}

class MyDialog extends StatefulWidget {
  final Map<String, dynamic> item;
  final String docID;
  final int index;
  MyDialog(this.item, this.index, this.docID);
  @override
  _MyDialogState createState() => new _MyDialogState();
}

class _MyDialogState extends State<MyDialog> {
  List<double> priceList = [];
  List<String> types = ['Cold Drinks', 'Fast Foods', 'Hot Drinks'];
  File _image;
  Color _color = Colors.white;
  String imgLink;
  @override
  Widget build(BuildContext context) {
    TextEditingController nameCont = new TextEditingController(
        text: widget.item['name'] == null ? '' : widget.item['name']);

    TextEditingController priceCont = new TextEditingController();
    return Dialog(
      child: ListView(
        shrinkWrap: true,
        children: <Widget>[
          ListTile(
            title: TextField(
              controller: nameCont,
              decoration: InputDecoration(
                hintText: 'Name',
              ),
            ),
            trailing: Icon(Icons.speaker_notes),
          ),
          ListTile(
              title: FlatButton.icon(
            label: Text('Browse Image'),
            icon: Icon(Icons.image),
            color: _color,
            onPressed: () async {
              await ImagePicker()
                  .getImage(source: ImageSource.gallery)
                  .then((image) {
                setState(() {
                  _image = File(image.path);
                });
              });
              print(p.basename(_image.path));
              StorageReference storageReference = FirebaseStorage.instance
                  .ref()
                  .child('${p.basename(_image.path)}');
              setState(() {
                _color = Colors.blue;
              });
              StorageUploadTask uploadTask = storageReference.putFile(_image);

              await uploadTask.onComplete;
              if (uploadTask.isSuccessful) {
                setState(() {
                  _color = Colors.green;
                });
                print('File Uploaded');
                storageReference.getDownloadURL().then((fileURL) {
                  print(fileURL.toString().substring(0, 69) +
                      'Resized' +
                      fileURL.toString().substring(69));
                  setState(() {
                    imgLink = fileURL.toString().substring(0, 69) +
                        'Resized' +
                        fileURL.toString().substring(69);
                  });
                });
              } else {
                setState(() {
                  _color = Colors.red;
                });
              }
            },
          )),
          ListTile(
            title: TextField(
              controller: priceCont,
              decoration: InputDecoration(
                hintText: 'Price',
              ),
            ),
            trailing: IconButton(
                icon: Icon(Icons.monetization_on),
                onPressed: () {
                  double price = double.parse(priceCont.text);
                  setState(() {
                    priceList.add(price);
                  });
                }),
            subtitle: Text('$priceList'),
          ),
          Center(
              child: RaisedButton(
            onPressed: () async {
              await Firestore.instance
                  .collection(types[widget.index])
                  .document(widget.docID)
                  .setData(
                {
                  'name': nameCont.text,
                  'img': imgLink == null ? widget.item['img'] : imgLink,
                  'price': priceList
                },
              );
              Navigator.pop(context);
            },
            child: Text('submit'),
          ))
        ],
      ),
    );
  }
}

class MyDialog2 extends StatefulWidget {
  @override
  _MyDialog2State createState() => new _MyDialog2State();
}

class _MyDialog2State extends State<MyDialog2> {
  List<double> priceList = [];
  List<String> types = ['Cold Drinks', 'Fast Foods', 'Hot Drinks'];
  String _value = 'Cold Drinks';
  TextEditingController nameCont = new TextEditingController();
  TextEditingController priceCont = new TextEditingController();
  File _image;
  Color _color = Colors.white;
  String imgLink;
  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: ListView(
        shrinkWrap: true,
        children: <Widget>[
          ListTile(
            title: TextField(
              controller: nameCont,
              decoration: InputDecoration(
                hintText: 'Name',
              ),
            ),
            trailing: Icon(Icons.speaker_notes),
          ),
          ListTile(
              title: FlatButton.icon(
            label: Text('Browse Image'),
            icon: Icon(Icons.image),
            color: _color,
            onPressed: () async {
              await ImagePicker()
                  .getImage(source: ImageSource.gallery)
                  .then((image) {
                setState(() {
                  _image = File(image.path);
                });
              });
              print(p.basename(_image.path));
              StorageReference storageReference = FirebaseStorage.instance
                  .ref()
                  .child('${p.basename(_image.path)}');
              setState(() {
                _color = Colors.blue;
              });
              StorageUploadTask uploadTask = storageReference.putFile(_image);

              await uploadTask.onComplete;
              if (uploadTask.isSuccessful) {
                setState(() {
                  _color = Colors.green;
                });
                print('File Uploaded');
                storageReference.getDownloadURL().then((fileURL) {
                  print(fileURL.toString().substring(0, 69) +
                      'Resized' +
                      fileURL.toString().substring(69));
                  setState(() {
                    imgLink = fileURL.toString().substring(0, 69) +
                        'Resized' +
                        fileURL.toString().substring(69);
                  });
                });
              } else {
                setState(() {
                  _color = Colors.red;
                });
              }
            },
          )),
          ListTile(
            title: DropdownButton(
              value: _value,
              items: types.map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              onChanged: (String val) {
                setState(() {
                  _value = val;
                });
              },
            ),
            trailing: Icon(Icons.category),
          ),
          ListTile(
            title: TextField(
              controller: priceCont,
              decoration: InputDecoration(
                hintText: 'Price',
              ),
            ),
            trailing: IconButton(
                icon: Icon(Icons.monetization_on),
                onPressed: () {
                  double price = double.parse(priceCont.text);
                  setState(() {
                    priceList.add(price);
                  });
                }),
            subtitle: Text('$priceList'),
          ),
          Center(
              child: RaisedButton(
            onPressed: ()async {
             await Firestore.instance.collection(_value).document().setData(
                {'name': nameCont.text, 'img': imgLink, 'price': priceList},
              );
              Navigator.pop(context);
            },
            child: Text('submit'),
          ))
        ],
      ),
    );
  }
}
