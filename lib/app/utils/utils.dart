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
}
