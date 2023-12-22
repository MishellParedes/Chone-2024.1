import 'package:sapo_benefica/ui/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class ToastNotifications {
  static void showGoodNotification({required String msg}) {
    Fluttertoast.showToast(
      msg: msg,
      toastLength: Toast.LENGTH_SHORT,
      webBgColor: "#50a22f",
      textColor: Colors.white,
      timeInSecForIosWeb: 5,
      backgroundColor: ThemeApp.primary,
    );
  }

  static void showBadNotification({required String msg}) {
    Fluttertoast.showToast(
      msg: msg,
      toastLength: Toast.LENGTH_SHORT,
      webBgColor: "#FF3100",
      textColor: Colors.white,
      timeInSecForIosWeb: 5,
      backgroundColor: Colors.redAccent,
      gravity: ToastGravity.TOP,
    );
  }
}
