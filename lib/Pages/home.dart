import 'package:badges/badges.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:my_startup/Helpers/Auth.dart';
import 'package:my_startup/Pages/cart.dart';
import 'package:my_startup/Pages/inventoryAll.dart';
import 'package:my_startup/providers/cart.dart';
import 'package:my_startup/providers/count.dart';
import '../Helpers/Constants.dart';
import '../Widgets/item.dart';
import '../models/item.dart';
import '../models/user.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'editItems.dart';
import 'inventory.dart';
import 'orders.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  TabController _tabCont;
  int tableNum = 1;
  int priceValue = 0;
  @override
  void initState() {
    _tabCont = new TabController(length: 3, vsync: this);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    CartProvider cartProvider = Provider.of<CartProvider>(context);
    final User _user = Provider.of<User>(context);
    CountProvider countProvider = Provider.of<CountProvider>(context);
    Future showUsers(Widget route, {id}) {
      print(route);
      return showDialog(
          context: context,
          child: StreamBuilder<QuerySnapshot>(
              stream: Firestore.instance.collection('Users').snapshots(),
              builder: (context, snapshot) {
                switch (snapshot.connectionState) {
                  case ConnectionState.waiting:
                    return CircularProgressIndicator();
                    break;
                  case ConnectionState.active:
                    return AlertDialog(
                      title: Text('Please Select User'),
                      content: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Container(
                            height: MediaQuery.of(context).size.height / 4,
                            width: MediaQuery.of(context).size.width,
                            child: GridView.builder(
                                itemCount: snapshot.data.documents.length,
                                gridDelegate:
                                    SliverGridDelegateWithFixedCrossAxisCount(
                                        crossAxisSpacing: 5,
                                        mainAxisSpacing: 5,
                                        crossAxisCount: 3),
                                itemBuilder: (context, index) {
                                  DocumentSnapshot user =
                                      snapshot.data.documents[index];
                                  return Container(
                                    child: RaisedButton(
                                        onPressed: () => Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) => route)),
                                        child: Text(
                                          '${user['name']}',
                                          style: blackSmallTextBold,
                                        )),
                                  );
                                }),
                          ),
                          id != 0
                              ? Container()
                              : FloatingActionButton(
                                  onPressed: () => Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              InventoryAllPage())))
                        ],
                      ),
                    );
                    break;
                  default:
                    return Container();
                }
              }));
    }

    return Scaffold(
      drawer: Drawer(
        child: Column(
          children: [
            Expanded(
              flex: 1,
              child: Stack(
                fit: StackFit.passthrough,
                children: <Widget>[
                  Container(
                    width: MediaQuery.of(context).size.width * 0.85,
                    child: DrawerHeader(
                      decoration: BoxDecoration(
                          image: DecorationImage(
                              image: AssetImage("assets/header.png"),
                              fit: BoxFit.cover)),
                      child: null,
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                          begin: Alignment.topRight,
                          end: Alignment.bottomLeft,
                          colors: [
                            Colors.grey[800].withOpacity(0.8),
                            Colors.white.withOpacity(0.5)
                          ]),
                    ),
                    child: Center(
                      child: ListTile(
                        leading: Icon(Icons.person),
                        title: Text(
                          "Log Out",
                          style: blackLargeTextBold,
                        ),
                        onTap: () async {
                          Map<String, double> count = countProvider.count;
                          count.forEach((key, value) async {
                            await Firestore.instance
                                .collection('Users/${_user.uid}/Items')
                                .document(DateFormat('yyyy-MM-d')
                                    .format(new DateTime.now())
                                    .toString())
                                .setData({
                              'time': Timestamp.now(),
                              key: FieldValue.increment(value),
                            }, merge: true);
                          });
                          /*await Auth().signOut();*/
                        },
                      ),
                    ),
                  )
                ],
              ),
            ),
            Expanded(
              flex: 2,
              child: ListView(
                  children: List.generate(
                5,
                (index) => ListTile(
                  title: Text(
                    "Table ${index + 1}",
                    style: blackSmallTextBold,
                  ),
                  onTap: () {
                    setState(() {
                      tableNum = index + 1;
                      priceValue = 0;
                    });
                    Navigator.of(context).pop();
                  },
                ),
              )),
            ),
            ListTile(
              title: Text(
                "Take-Away",
                style: blackSmallTextBold,
              ),
              onTap: () {
                setState(() {
                  tableNum = 6;
                  priceValue = 0;
                });
                Navigator.of(context).pop();
              },
            ),
            ListTile(
                title: Text(
                  "Staff",
                  style: blackSmallTextBold,
                ),
                onTap: () {
                  setState(() {
                    tableNum = 7;
                    priceValue = 1;
                  });
                  Navigator.of(context).pop();
                }),
            Visibility(
              visible: _user.admin,
              child: ListTile(
                  title: Text(
                    "Edit Items",
                    style: blackSmallTextBold,
                  ),
                  onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => EditItemsPage()))),
            ),
            Visibility(
              visible: _user.admin,
              child: ListTile(
                  title: Text(
                    "Show Orders",
                    style: blackSmallTextBold,
                  ),
                  onTap: () {
                    showDialog(
                        context: context,
                        child: Dialog(
                            child: GridView(
                          shrinkWrap: true,
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2),
                          children: <Widget>[
                            RaisedButton(
                              onPressed: () => showUsers(OrdersListPage(_user)),
                              child: Text(
                                'Users',
                                style: blackLargeTextBold,
                              ),
                              color: Colors.redAccent,
                            ),
                            RaisedButton(
                              onPressed: () =>
                                  showUsers(InventoryPage(_user), id: 0),
                              child: Text(
                                'Items',
                                style: blackLargeTextBold,
                              ),
                              color: Colors.amber,
                            ),
                          ],
                        )));
                  }),
            ),
          ],
        ),
      ),
      appBar: AppBar(
        actions: <Widget>[
          Badge(
              badgeColor: Colors.blueAccent,
              borderRadius: 10.0,
              position: BadgePosition(right: 2, top: 0.5),
              badgeContent: Text(
                cartProvider.cart[tableNum - 1].cartItems.length.toString(),
                style: whiteSmallTextBold,
              ),
              child: IconButton(
                  icon: Icon(Icons.shopping_cart),
                  onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              OrdersPage(tableNum - 1, priceValue))))),
          IconButton(
              onPressed: null,
              icon: Text(
                tableNum.toString(),
                style: whiteLargeTextBold,
              ))
        ],
        title: Text("Welcome ${_user.name}"),
        bottom: TabBar(
          tabs: <Tab>[
            Tab(
              text: 'Hot Drinks',
              icon: Icon(Icons.local_cafe),
            ),
            Tab(
              text: 'Fast Foods',
              icon: Icon(Icons.fastfood),
            ),
            Tab(
              text: 'Cold Drinks',
              icon: Icon(Icons.ac_unit),
            )
          ],
          controller: _tabCont,
        ),
      ),
      body: TabBarView(controller: _tabCont, children: <Widget>[
        StreamBuilder<QuerySnapshot>(
            stream: Firestore.instance.collection('Hot Drinks').snapshots(),
            builder: (context, snapshot) {
              switch (snapshot.connectionState) {
                case ConnectionState.waiting:
                  return CircularProgressIndicator();
                  break;
                case ConnectionState.active:
                  return GridView.builder(
                    itemCount: snapshot.data.documents.length,
                    gridDelegate: new SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2),
                    itemBuilder: (context, index) {
                      Item item =
                          Item.fromJson(snapshot.data.documents[index].data);
                      return ItemWidget(item, tableNum, priceValue);
                    },
                  );
                  break;
                default:
                  return Container();
              }
            }),
        StreamBuilder<QuerySnapshot>(
            stream: Firestore.instance.collection('Fast Foods').snapshots(),
            builder: (context, snapshot) {
              switch (snapshot.connectionState) {
                case ConnectionState.waiting:
                  return CircularProgressIndicator();
                  break;
                case ConnectionState.active:
                  return GridView.builder(
                    itemCount: snapshot.data.documents.length,
                    gridDelegate: new SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2),
                    itemBuilder: (context, index) {
                      Item item =
                          Item.fromJson(snapshot.data.documents[index].data);
                      return ItemWidget(item, tableNum, priceValue);
                    },
                  );
                  break;
                default:
                  return Container();
              }
            }),
        StreamBuilder<QuerySnapshot>(
            stream: Firestore.instance.collection('Cold Drinks').snapshots(),
            builder: (context, snapshot) {
              switch (snapshot.connectionState) {
                case ConnectionState.waiting:
                  return CircularProgressIndicator();
                  break;
                case ConnectionState.active:
                  return GridView.builder(
                    itemCount: snapshot.data.documents.length,
                    gridDelegate: new SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2),
                    itemBuilder: (context, index) {
                      Item item =
                          Item.fromJson(snapshot.data.documents[index].data);
                      return ItemWidget(item, tableNum, priceValue);
                    },
                  );
                  break;
                default:
                  return Container();
              }
            }),
      ]),
    );
  }
}
