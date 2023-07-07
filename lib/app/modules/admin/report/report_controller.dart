import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'dart:developer';

enum ReportUserMode { ALL, BY_MONTH }

class ReportController extends GetxController {
  var loadingData = false.obs;
  var reportUserMode = Rx(ReportUserMode.ALL);
  var laporanPesanan = {}.obs;
  var laporanPesananByBulan = {}.obs;
  var indexDataDetail = 0.obs;
  var indexBulanDetail = "".obs;
  var detailPesanan = <DocumentSnapshot>[].obs;
  var selectedValue = 'Semua'.obs;

  Stream<List<QueryDocumentSnapshot>> getDataTerjualdanPembayaran(String userId) {
    return FirebaseFirestore.instance.collection('user').doc(userId).collection('pesanan').where('status', isEqualTo: '5').where('jenis', isEqualTo: 'beli').snapshots().map((snapshot) {
      // log("$userId = ${snapshot.docs.length}");
      return snapshot.docs;
    });
  }

  Stream<List<QueryDocumentSnapshot>> getDataTukarSampah(String userId) {
    return FirebaseFirestore.instance.collection('user').doc(userId).collection('pesanan').where('status', isEqualTo: '5').where('jenis', isEqualTo: 'tukar').snapshots().map((snapshot) {
      // log("$userId = ${snapshot.docs.length}");
      return snapshot.docs;
    });
  }

  Future<void> getPesananByBulan() async {
    laporanPesananByBulan.clear();
    QuerySnapshot userSnapshot = await FirebaseFirestore.instance.collection('user').get();

    Map<String, List<DocumentSnapshot>> laporanPesananMap = {'Semua': []};
    for (DocumentSnapshot userDoc in userSnapshot.docs) {
      List<QueryDocumentSnapshot> pesananUser = await getDataTerjualdanPembayaran(userDoc.id).first;

      for (QueryDocumentSnapshot pesananDoc in pesananUser) {
        laporanPesananMap['Semua']!.add(pesananDoc);

        DateTime tanggal = DateFormat("dd-MM-yyyy").parse((pesananDoc.data() as Map<String, dynamic>)['tanggal']);
        String bulan = DateFormat('MMMM yyyy', 'id_ID').format(tanggal);

        if (!laporanPesananMap.containsKey(bulan)) {
          laporanPesananMap[bulan] = [];
        }

        laporanPesananMap[bulan]!.add(pesananDoc);
      }
    }
    laporanPesananByBulan.assignAll(laporanPesananMap);
    log('$laporanPesananByBulan');
  }

  Future<void> getAllPesanan() async {
    laporanPesanan.clear();
    QuerySnapshot userSnapshot = await FirebaseFirestore.instance.collection('user').get();

    Map<String, dynamic>? laporanPesananMap = {};
    for (DocumentSnapshot userDoc in userSnapshot.docs) {
      List<QueryDocumentSnapshot> pesananUser = await getDataTerjualdanPembayaran(userDoc.id).first;
      for (QueryDocumentSnapshot pesananDoc in pesananUser) {
        // log('PESANAN USER :${pesananDoc.data()} :::: ${(userDoc.data() as Map)['uid']}');
        laporanPesananMap.assignAll(pesananDoc.data() as Map<String, dynamic>);
      }
    }
    laporanPesanan.assignAll(laporanPesananMap);
    // log('PESANAN USER :$laporanPesanan');
    // laporanPesanan.forEach((key, value) {
    //   log('$key || ${value.toString()}');
    // });
    // laporanPesanan.value = laporanPesananMap;
  }

  @override
  void onInit() {
    super.onInit();
    getPesananByBulan();
    // getAllPesanan();
  }

  Future<void> onRefresh() {
    // Lakukan operasi refresh yang diperlukan, seperti mengambil ulang data dari Firestore
    // atau melakukan tindakan lain yang sesuai dengan kebutuhan Anda

    // Contoh: mengambil ulang data dengan memanggil metode getData()
    return getAllPesanan().then((_) {
      // Refresh berhasil, tidak perlu mengembalikan nilai
    }).catchError((error) {
      // Meng-handle error jika terjadi
      print('Error: $error');
    });
  }
}
