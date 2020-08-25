import 'package:flutter/material.dart';
import 'package:my_startup/Helpers/Constants.dart';
import 'package:my_startup/providers/cart.dart';

import 'Helpers/Auth.dart';
import 'models/user.dart';

import 'wrapper.dart';
import 'package:provider/provider.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        StreamProvider<User>.value(
          value: Auth().user,
        ),
        ChangeNotifierProvider<CartProvider>.value(
          value: CartProvider(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.deepOrange,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: Wrapper(),
      ),
    );
  }
}

class MyDarling extends StatefulWidget {
  @override
  _MyDarlingState createState() => _MyDarlingState();
}

class _MyDarlingState extends State<MyDarling> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'For My Darling',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(primarySwatch: Colors.red),
        home: Scaffold(
          appBar: AppBar(
            centerTitle: true,
            title: Text('FOR MY DARLING'),
          ),
          body: Stack(
            children: <Widget>[
              Container(
                decoration: BoxDecoration(
                    image: DecorationImage(
                  colorFilter:
                      ColorFilter.mode(Colors.black54, BlendMode.colorBurn),
                  image: AssetImage('assets/baby.jpg'),
                )),
              ),
              Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      'I love you',
                      style: whiteSmallTextBold,
                    ),
                    Text(
                      '$_counter',
                      style: Theme.of(context).textTheme.headline4,
                    ),
                    Text(
                      'Times',
                      style: whiteSmallTextBold,
                    ),
                  ],
                ),
              )
            ],
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: _incrementCounter,
            child: Icon(Icons.favorite),
          ),
        ));
  }
}
