import 'dart:developer';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:rumah_sampah_t_a/app/controllers/auth_controller.dart';
import 'package:rumah_sampah_t_a/app/utils/list_color.dart';
import 'package:rumah_sampah_t_a/app/utils/list_text_style.dart';
import 'package:rumah_sampah_t_a/app/utils/utils.dart';

enum ReportUserMode { LIST, DETAIL, DETAIL_DATA }

class ReportController extends GetxController {
  var reportUserMode = Rx(ReportUserMode.LIST);
  var laporanPesanan = {}.obs;
  var indexDataDetail = 0.obs;
  var indexBulanDetail = "".obs;
  var detailPesanan = <DocumentSnapshot>[];

  Stream<List<QueryDocumentSnapshot>> getPesananUserStream(String userId) {
    return FirebaseFirestore.instance.collection('user').doc(userId).collection('pesanan').snapshots().map((snapshot) => snapshot.docs);
  }

  Future<void> getAllPesanan() async {
    QuerySnapshot userSnapshot = await FirebaseFirestore.instance.collection('user').get();

    Map<String, List<DocumentSnapshot>> laporanPesananMap = {};

    for (DocumentSnapshot userDoc in userSnapshot.docs) {
      List<QueryDocumentSnapshot> pesananUser = await getPesananUserStream(userDoc.id).first;

      for (QueryDocumentSnapshot pesananDoc in pesananUser) {
        DateTime tanggal = DateFormat("dd-MM-yyyy").parse((pesananDoc.data() as Map<String, dynamic>)['tanggal']);
        String bulan = DateFormat('MMMM yyyy', 'id_ID').format(tanggal);

        if (!laporanPesananMap.containsKey(bulan)) {
          laporanPesananMap[bulan] = [];
        }

        laporanPesananMap[bulan]!.add(pesananDoc);
      }
    }

    laporanPesanan.assignAll(laporanPesananMap);
  }

  String formatDate(DateTime date) {
    return DateFormat('dd-MM-yyyy').format(date);
  }

  @override
  void onInit() {
    getAllPesanan();
    super.onInit();
  }
}
