import 'package:flutter/material.dart';
import 'Pages/login.dart';
import 'models/user.dart';
import 'package:provider/provider.dart';

import 'Pages/home.dart';

class Wrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);

    if (user == null) {
      return LoginPage();
    } else {
      return HomePage();
    }
  }
}
