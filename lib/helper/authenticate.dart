import 'package:chaticon/views/signin.dart';
import 'package:chaticon/views/signup.dart';
import 'package:flutter/material.dart';

class Authenticate extends StatefulWidget {
  @override
  _AuthenticateState createState() => _AuthenticateState();
}

class _AuthenticateState extends State<Authenticate> {
  bool showSignIn = true;

  void toggleView() {
    setState(() {
      showSignIn = !showSignIn;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (showSignIn) {
      return SignIn(
        toggle: toggleView,
      );
    } else {
      return SignUp(
        toggle: toggleView,
      );
    }
  }
}
