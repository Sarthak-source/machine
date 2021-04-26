import 'package:flutter/material.dart';
import 'package:machineweb/screens/admin/userside/beforesign%20in/regester.dart';
import 'package:machineweb/screens/admin/userside/beforesign%20in/sign.dart';

class Authenticate extends StatefulWidget {
  static String route = '\authroute';
  @override
  _AuthenticateState createState() => _AuthenticateState();
}

class _AuthenticateState extends State<Authenticate> {
  bool showSignIn = true;
  void toggleView() {
    //print(showSignIn.toString());
    setState(() => showSignIn = !showSignIn);
  }

  @override
  Widget build(BuildContext context) {
    if (showSignIn) {
      return SignIn(toggleView: toggleView);
    } else {
      return Register(toggleView: toggleView);
    }
  }
}
