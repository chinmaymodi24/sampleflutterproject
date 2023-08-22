import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class AppToast {
  static msg(String msg) {
    Fluttertoast.showToast(
      msg: msg,
      backgroundColor: Colors.black,
      textColor: Colors.white,
    );
  }
}
