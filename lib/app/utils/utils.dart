import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:latlong2/latlong.dart';
import 'package:rumah_sampah_t_a/app/utils/list_color.dart';

enum TypeNotif { SUKSES, ERROR }

class Utils {
  LatLng centerMadiun = LatLng(-7.629039, 111.530110);

  static String generateRandomString(int len) {
    var r = Random();
    const chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';
    return List.generate(len, (index) => chars[r.nextInt(chars.length)]).join();
  }

  static showNotif(TypeNotif typeNotif, String? alert) {
    if (typeNotif == TypeNotif.ERROR) {
      ScaffoldMessenger.of(Get.context!).showSnackBar(SnackBar(
        content: Text(alert!),
        backgroundColor: Colors.red,
        showCloseIcon: true,
      ));
    } else {
      ScaffoldMessenger.of(Get.context!).showSnackBar(SnackBar(
        content: Text(alert!),
        backgroundColor: Color(ListColor.colorButtonGreen),
        showCloseIcon: true,
      ));
    }
  }

  static String formatUang(double value, {String currency = "Rp", String comaSeparator = "."}) {
    var string = "";
    var convertString = value.toString().split(comaSeparator);
    for (var index = 0; index < convertString[0].length; index++) {
      string = (index % 3 == 2 && index != (convertString[0].length - 1) ? "." : "") + convertString[0][(convertString[0].length - 1 - index)] + string;
    }
    if (convertString.length > 1 && int.parse(convertString[1]) > 0) string += ",${convertString[1]}";
    return "$currency$string";
  }
}
