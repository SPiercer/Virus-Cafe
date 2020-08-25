import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:my_startup/models/user.dart';
import '../Helpers/Auth.dart';
import '../Helpers/Constants.dart';

class LoginPage extends StatefulWidget {
  LoginPage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController emailCont = new TextEditingController();
  TextEditingController passCont = new TextEditingController();

  Auth _auth = Auth();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          Container(
            decoration: BoxDecoration(
                image: DecorationImage(
                    image: AssetImage('assets/login.jpg'), fit: BoxFit.cover)),
            child: Container(
              height: MediaQuery.of(context).size.height,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                    begin: Alignment.topRight,
                    end: Alignment.bottomLeft,
                    colors: [
                      Colors.grey[800].withOpacity(0.8),
                      Colors.black.withOpacity(0.5)
                    ]),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(bottom: 50),
                    child: Text(
                      'Welcome To Virus Cafe \n Please Login',
                      style: whiteLargeTextBold,
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                        borderRadius:
                            const BorderRadius.all(Radius.circular(5)),
                        border: Border.all(
                            width: 1.5,
                            color: Colors.grey[200],
                            style: BorderStyle.solid)),
                    child: TextField(
                      controller: emailCont,
                      style: whiteLargeTextBold,
                      decoration: const InputDecoration(
                          hintText: 'Username',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(5)),
                          )),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                        borderRadius:
                            const BorderRadius.all(Radius.circular(5)),
                        border: Border.all(
                            width: 1.5,
                            color: Colors.grey[200],
                            style: BorderStyle.solid)),
                    child: TextField(
                      controller: passCont,
                      obscureText: true,
                      style: whiteLargeTextBold,
                      decoration: const InputDecoration(
                          hintText: 'Password',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(5)),
                          )),
                    ),
                  ),
                  RaisedButton(onPressed: ()async{
                     await Firestore.instance
                  .collection('Users')
                  .add({'name': 'result.name', 'admin': 'result.admin'}).whenComplete(()=>print('done'));
                  })
                ],
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          if (emailCont.text != '' && passCont.text != '') {
            User result = await _auth.signIn(
                email: emailCont.text, password: passCont.text);
            if (result == null) {
              print('Error Signing IN');
            } else {
              await Firestore.instance
                  .collection('Users')
                  .document(result.uid)
                  .setData({'name': result.name, 'admin': result.admin}).catchError((e)=>print(e));
              print('done');
            }
          }
        },
        tooltip: 'Login',
        child: const Icon(Icons.subdirectory_arrow_right),
      ),
    );
  }
}
