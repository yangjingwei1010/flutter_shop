import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter/material.dart';

class MessageToast {
  static showToast() {
    Fluttertoast.showToast(
        msg: "练习toast",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIos: 1,
        backgroundColor: Colors.pink,
        textColor: Colors.white,
        fontSize: 16.0
    );
  }
}