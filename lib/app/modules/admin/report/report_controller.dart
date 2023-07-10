import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'dart:developer';
import 'package:charts_flutter/flutter.dart' as charts;

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
  var laporanProduk = [].obs;
  var laporanProdukSeriesList = [];
  var laporanSampah = [].obs;
  var laporanSampahSeriesList = [];

  Stream<List<QueryDocumentSnapshot>> getDataTukarSampah(String userId) {
    return FirebaseFirestore.instance.collection('user').doc(userId).collection('pesanan').where('status', isEqualTo: '5').where('jenis', isEqualTo: 'tukar').snapshots().map((snapshot) {
      log("$userId = ${snapshot.docs.length}");
      return snapshot.docs;
    });
  }

  Stream<List<QueryDocumentSnapshot>> getDataTerjualdanPembayaran(String userId) {
    return FirebaseFirestore.instance.collection('user').doc(userId).collection('pesanan').where('status', isEqualTo: '5').where('jenis', isEqualTo: 'beli').snapshots().map((snapshot) {
      // log("$userId = ${snapshot.docs.length}");
      return snapshot.docs;
    });
  }

  Future<void> getPesananProduk() async {
    laporanPesananByBulan.clear();
    laporanProdukSeriesList.clear();
    laporanProduk.clear();
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

    Map<String, dynamic> mapProdukTerjual = {};
    laporanPesananByBulan.forEach((key, value) {
      value.forEach((DocumentSnapshot<Object?>? snapshot) {
        var data = snapshot!.data() as Map<String, dynamic>?;
        dynamic nilai = data?['detail'];
        if (nilai != null) {
          mapProdukTerjual.putIfAbsent('detail', () => nilai);
          // mapProdukTerjual.map((key, value) => null)
        }
        laporanProduk.add(mapProdukTerjual);
      });
    });
    log('$laporanProduk');
    List<Map<String, dynamic>> chartData = laporanProduk.map((laporan) {
      List<Map<String, dynamic>> detail = (laporan['detail'] as List<dynamic>)
          .map((item) => {
                'jenis': item['jenis'],
                'jumlah': item['jumlah'],
                'harga': item['harga'],
              })
          .toList();
      return {'detail': detail};
    }).toList();

    // log('$chartData');
    laporanProdukSeriesList = chartData;
  }

  Future<void> getPesananSampah() async {
    laporanPesananByBulan.clear();
    laporanProduk.clear();
    laporanSampahSeriesList.clear();
    QuerySnapshot userSnapshot = await FirebaseFirestore.instance.collection('user').get();

    Map<String, List<DocumentSnapshot>> laporanPesananMap = {'Semua': []};
    for (DocumentSnapshot userDoc in userSnapshot.docs) {
      List<QueryDocumentSnapshot> pesananUser = await getDataTukarSampah(userDoc.id).first;

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

    Map<String, dynamic> mapProdukTerjual = {};
    laporanPesananByBulan.forEach((key, value) {
      value.forEach((DocumentSnapshot<Object?>? snapshot) {
        var data = snapshot!.data() as Map<String, dynamic>?;
        dynamic nilai = data?['detail'];
        if (nilai != null) {
          mapProdukTerjual.putIfAbsent('detail', () => nilai);
          // mapProdukTerjual.map((key, value) => null)
        }
        laporanSampah.add(mapProdukTerjual);
      });
    });
    log('$laporanSampah');
    List<Map<String, dynamic>> chartData = laporanSampah.map((laporan) {
      List<Map<String, dynamic>> detail = (laporan['detail'] as List<dynamic>)
          .map((item) => {
                'jenis': item['jenis'],
                'jumlah': item['jumlah'],
                'harga': item['harga'],
              })
          .toList();
      return {'detail': detail};
    }).toList();

    // log('$chartData');
    laporanSampahSeriesList = chartData;
  }

  @override
  void onInit() {
    super.onInit();
    getPesananProduk();
    getPesananSampah();
  }

  List<charts.Series<dynamic, String>> createSeries(List<Map<String, dynamic>> chartData) {
    Map<String, int> jumlahPerJenis = {};

    // Menghitung jumlah per jenis
    for (var map in chartData) {
      List<Map<String, dynamic>> detail = map['detail'];
      for (var item in detail) {
        String? jenis = item['jenis'];
        dynamic jumlah = item['jumlah'];

        if (jenis != null && jumlah != null) {
          if (jumlah is int) {
            jumlahPerJenis[jenis] = (jumlahPerJenis[jenis] ?? 0) + jumlah;
          } else if (jumlah is String) {
            jumlahPerJenis[jenis] = (jumlahPerJenis[jenis] ?? 0) + int.parse(jumlah);
          }
        }
      }
    }

    // Membuat list data series
    List<charts.Series<dynamic, String>> seriesList = [
      charts.Series<dynamic, String>(
        id: 'Produk Terjual',
        data: jumlahPerJenis.entries.map((entry) {
          return {
            'jenis': entry.key,
            'jumlah': entry.value,
          };
        }).toList(),
        domainFn: (item, _) => item['jenis'] as String,
        measureFn: (item, _) => item['jumlah'] as int?,
      ),
    ];

    return seriesList;
  }

  Widget buildBarChart(List<Map<String, dynamic>> chartData, String id) {
    // List<charts.Series<dynamic, String>> seriesList = [
    //   charts.Series<dynamic, String>(
    //     id: id,
    //     // data: chartData[0]['detail'],
    //     data: chartData[0]['detail'],
    //     domainFn: (item, _) => item['jenis'] as String,
    //     measureFn: (item, _) => num.parse(item['jumlah']),
    //   ),
    // ];

    List<charts.Series<dynamic, String>> seriesList = createSeries(chartData);

    return charts.BarChart(
      seriesList,
      animate: true,
    );
  }
}
