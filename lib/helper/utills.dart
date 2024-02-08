import 'dart:math';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Utils {
  static void showSnackBar(String m, BuildContext context, {Color? color}) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(m),
      backgroundColor: color,
    ));
  }

  static String generateRandomEmployeeId() {
    final random = Random();
    const allChars = "nakorubNAKRUB123456789";
    final randomString =
    List.generate(8, (index) => allChars[random.nextInt(allChars.length)])
        .join();
    return randomString;
  }

  static String getCurrentDate(){
    return DateFormat("dd MMMM yyyy").format(DateTime.now());
  }
}
