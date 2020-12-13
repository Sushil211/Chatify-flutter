import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

Widget appBarMain(BuildContext context) {
  return AppBar(
    title: Text(
      "Chatify",
      style: TextStyle(),
    ),
  );
}

InputDecoration cardInputDecoration(String text) {
  return InputDecoration(
    hintText: text,
    hintStyle: TextStyle(
      color: Colors.white54,
      fontSize: 20.0,
    ),
    border: InputBorder.none,
    focusedBorder: InputBorder.none,
    enabledBorder: InputBorder.none,
    errorBorder: InputBorder.none,
    disabledBorder: InputBorder.none,
  );
}

TextStyle cardInputStyle(double fontSize) {
  return TextStyle(
    color: Colors.white,
    fontSize: fontSize,
    decoration: TextDecoration.none,
  );
}

Card cardInput(String hintText, TextEditingController controller) {
  return Card(
    color: Colors.grey[800],
    margin: EdgeInsets.symmetric(vertical: 8.0),
    clipBehavior: Clip.antiAlias,
    child: Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.0),
      child: Column(
        children: [
          Container(
            height: 50.0,
            child: TextFormField(
              obscureText: hintText == 'password',
              validator: (val) {
                if (hintText == 'username') {
                  return (val.isEmpty || val.length < 3)
                      ? "username must be at least 3 characters"
                      : null;
                } else if (hintText == 'email') {
                  return RegExp(
                              r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?)*$")
                          .hasMatch(val)
                      ? null
                      : "Please provide a valid email address";
                } else {
                  return val.length < 6
                      ? 'Password must be at least 6 characters long'
                      : null;
                }
              },
              controller: controller,
              style: cardInputStyle(20.0),
              decoration: cardInputDecoration(hintText),
            ),
          ),
        ],
      ),
    ),
  );
}
