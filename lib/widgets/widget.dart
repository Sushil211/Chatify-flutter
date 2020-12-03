import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

Widget appBarMain(BuildContext context) {
  return AppBar(
    title: Text(
      "ChatIcon",
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
    focusedBorder: UnderlineInputBorder(
      borderSide: BorderSide.none,
    ),
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
      child: TextField(
        controller: controller,
        style: cardInputStyle(20.0),
        decoration: cardInputDecoration(hintText),
      ),
    ),
  );
}
