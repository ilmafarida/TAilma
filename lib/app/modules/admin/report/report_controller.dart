import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'dart:developer';
import 'package:charts_flutter/flutter.dart' as charts;

enum ReportUserMode { ALL, BY_MONTH }

class ReportController extends GetxController {
  var loadingData = true.obs;
  var reportUserMode = Rx(ReportUserMode.ALL);
  var indexDataDetail = 0.obs;
  var indexBulanDetail = "".obs;
  var detailPesanan = <DocumentSnapshot>[].obs;
  var selectedValue = 'Semua'.obs;
  var laporanProduk = [].obs;
  var laporanProdukSeriesList = <Map<String, dynamic>>[].obs;
  var laporanSampah = [].obs;
  var laporanSampahSeriesList = <Map<String, dynamic>>[].obs;
  var laporanPembayaran = {}.obs;
  var laporanPembayaranSeriesList = <Map<String, dynamic>>[].obs;
  var dataDropdown = {};

  Stream<List<QueryDocumentSnapshot>> getDataTukarSampah(String userId) {
    return FirebaseFirestore.instance.collection('user').doc(userId).collection('pesanan').where('status', isEqualTo: '5').where('jenis', isEqualTo: 'tukar').snapshots().map((snapshot) {
      // log("$userId = ${snapshot.docs.length}");
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
    dataDropdown.clear();
    laporanProdukSeriesList.clear();
    laporanProduk.clear();
    QuerySnapshot userSnapshot = await FirebaseFirestore.instance.collection('user').get();

    Map<String, List<dynamic>?> laporanPesananMap = {'Semua': []};
    for (DocumentSnapshot userDoc in userSnapshot.docs) {
      List<QueryDocumentSnapshot> pesananUser = await getDataTerjualdanPembayaran(userDoc.id).first;

      for (QueryDocumentSnapshot pesananDoc in pesananUser) {
        List<dynamic> detailList = pesananDoc['detail'];
        List<Map<String, dynamic>> remappedDetail = [];

        for (var item in detailList) {
          if (item is Map<String, dynamic>) {
            // Perform the remapping on each item in the detail list
            // Example: Changing the key 'jenis' to 'jenisBarang'
            String jenisBarang = item['jenis'];
            remappedDetail.add({
              'jenisBarang': jenisBarang,
              'jumlah': item['jumlah'],
              'harga': item['harga'],
            });
          } else {
            // Handle the case where an item is not of the expected type
          }
        }

        laporanPesananMap['Semua']!.addAll(remappedDetail);

        DateTime tanggal = DateFormat("dd-MM-yyyy").parse((pesananDoc.data() as Map<String, dynamic>)['tanggal']);
        String bulan = DateFormat('MMMM yyyy', 'id_ID').format(tanggal);
        if (!laporanPesananMap.containsKey(bulan)) {
          laporanPesananMap[bulan] = [];
        }
        laporanPesananMap[bulan]!.addAll(remappedDetail);
      }
    }
    // log('$laporanPesananMap');
    // log('${laporanPesananMap[selectedValue.value]}');

    dataDropdown.addAll(laporanPesananMap);
    List<dynamic> dynamicList = laporanPesananMap[selectedValue.value]!;
    List<Map<String, dynamic>> mapList = [];
    for (var item in dynamicList) {
      if (item is Map<String, dynamic>) {
        mapList.add(item);
      } else {
        // Handle the case where an element is not of the expected type
      }
    }
    // Now you can add the elements to laporanPembayaranSeriesList
    laporanProdukSeriesList.addAll(mapList);
  }

  Future<void> getPesananSampah() async {
    laporanProduk.clear();
    laporanSampahSeriesList.clear();
    QuerySnapshot userSnapshot = await FirebaseFirestore.instance.collection('user').get();

    Map<String, List<dynamic>?> laporanPesananMap = {'Semua': []};
    for (DocumentSnapshot userDoc in userSnapshot.docs) {
      List<QueryDocumentSnapshot> pesananUser = await getDataTukarSampah(userDoc.id).first;

      for (QueryDocumentSnapshot pesananDoc in pesananUser) {
        List<dynamic> detailList = pesananDoc['detail'];
        List<Map<String, dynamic>> remappedDetail = [];

        for (var item in detailList) {
          if (item is Map<String, dynamic>) {
            // Perform the remapping on each item in the detail list
            // Example: Changing the key 'jenis' to 'jenisBarang'
            String jenisBarang = item['jenis'];
            remappedDetail.add({
              'jenisBarang': jenisBarang,
              'jumlah': item['jumlah'],
            });
          } else {
            // Handle the case where an item is not of the expected type
          }
        }

        laporanPesananMap['Semua']!.addAll(remappedDetail);

        DateTime tanggal = DateFormat("dd-MM-yyyy").parse((pesananDoc.data() as Map<String, dynamic>)['tanggal']);
        String bulan = DateFormat('MMMM yyyy', 'id_ID').format(tanggal);

        if (!laporanPesananMap.containsKey(bulan)) {
          laporanPesananMap[bulan] = [];
        }

        laporanPesananMap[bulan]!.addAll(remappedDetail);
      }
    }

    // log('$laporanPesananMap');
    // log('${laporanPesananMap[selectedValue.value]}');

    dataDropdown.addAll(laporanPesananMap);
    List<dynamic> dynamicList = laporanPesananMap[selectedValue.value]!;
    List<Map<String, dynamic>> mapList = [];
    for (var item in dynamicList) {
      if (item is Map<String, dynamic>) {
        mapList.add(item);
      } else {
        // Handle the case where an element is not of the expected type
      }
    }
    // Now you can add the elements to laporanPembayaranSeriesList
    laporanSampahSeriesList.addAll(mapList);
  }

  Future<void> getPesananPembayaran() async {
    laporanPembayaran.clear();
    laporanPembayaranSeriesList.clear();
    QuerySnapshot userSnapshot = await FirebaseFirestore.instance.collection('user').get();

    Map<String, List<dynamic>?> laporanPesananMap = {'Semua': []};
    for (DocumentSnapshot userDoc in userSnapshot.docs) {
      List<QueryDocumentSnapshot> pesananUser = await getDataTerjualdanPembayaran(userDoc.id).first;

      for (QueryDocumentSnapshot pesananDoc in pesananUser) {
        // log('${(pesananDoc).data()}');
        Map<String, dynamic> remappedData = {
          'metode': "${pesananDoc['metode']}",
          'total_harga': int.parse(
            pesananDoc['total_harga'],
          )
        };
        laporanPesananMap['Semua']!.add(remappedData);

        DateTime tanggal = DateFormat("dd-MM-yyyy").parse((pesananDoc.data() as Map<String, dynamic>)['tanggal']);
        String bulan = DateFormat('MMMM yyyy', 'id_ID').format(tanggal);

        if (!laporanPesananMap.containsKey(bulan)) {
          laporanPesananMap[bulan] = [];
        }

        laporanPesananMap[bulan]!.add(remappedData);
      }
    }
    List<dynamic> dynamicList = laporanPesananMap[selectedValue.value]!;
    List<Map<String, dynamic>> mapList = [];
    for (var item in dynamicList) {
      if (item is Map<String, dynamic>) {
        mapList.add(item);
      } else {
        // Handle the case where an element is not of the expected type
      }
    }
    // Now you can add the elements to laporanPembayaranSeriesList
    laporanPembayaranSeriesList.addAll(mapList);

    // log('${laporanPesananMap[selectedValue.value].runtimeType}');
    // log('$laporanPembayaranSeriesList');
  }

  @override
  void onInit() {
    super.onInit();
    refreshData();
  }

  Future<void> refreshData() async {
    loadingData.value = true;

    await getPesananProduk();
    await getPesananSampah();
    await getPesananPembayaran();
    loadingData.value = false;
  }

  List<charts.Series<dynamic, String>> createSeriesProdukSampah(List<Map<String, dynamic>> chartData) {
    Map<String, int> jumlahPerJenis = {};
    // Menghitung jumlah per jenis
    for (var map in chartData) {
      Map<String, dynamic> detail = map;
      // log('${detail['jenisBarang']}');
      String? jenis = detail['jenisBarang'];
      dynamic jumlah = detail['jumlah'];

      if (jenis != null && jumlah != null) {
        if (jumlah is int) {
          jumlahPerJenis[jenis] = (jumlahPerJenis[jenis] ?? 0) + jumlah;
        } else if (jumlah is String) {
          jumlahPerJenis[jenis] = (jumlahPerJenis[jenis] ?? 0) + int.parse(jumlah);
        }
      }
    }

    // Membuat list data series
    List<charts.Series<dynamic, String>> seriesList = [
      charts.Series<dynamic, String>(
        id: 'Produk Terjual',
        data: jumlahPerJenis.entries.map((entry) {
          return {
            'jenisBarang': entry.key,
            'jumlah': entry.value,
          };
        }).toList(),
        domainFn: (item, _) => item['jenisBarang'] as String,
        measureFn: (item, _) => item['jumlah'] as int?,
      ),
    ];

    return seriesList;
  }

  List<charts.Series<dynamic, String>> createSeriesPembelian(List<Map<String, dynamic>> chartData) {
    Map<String, int> jumlahPerJenis = {};

    // Menghitung jumlah per jenis
    for (var map in chartData) {
      Map<String, dynamic> detail = map;
      String? metode = detail['metode'];
      dynamic totalHarga = detail['total_harga'];

      if (metode != null && totalHarga != null) {
        if (totalHarga is int) {
          jumlahPerJenis[metode] = (jumlahPerJenis[metode] ?? 0) + totalHarga;
        } else if (totalHarga is String) {
          jumlahPerJenis[metode] = (jumlahPerJenis[metode] ?? 0) + int.parse(totalHarga);
        }
      }
    }

    // Membuat list data series
    List<charts.Series<dynamic, String>> seriesList = [
      charts.Series<dynamic, String>(
        id: 'Produk Terjual',
        data: jumlahPerJenis.entries.map((entry) {
          return {
            'metode': entry.key,
            'total_harga': entry.value,
          };
        }).toList(),
        domainFn: (item, _) => item['metode'] as String,
        measureFn: (item, _) => item['total_harga'] as int?,
      ),
    ];

    return seriesList;
  }

  Widget buildBarChart(List<Map<String, dynamic>> chartData, String id) {
    List<charts.Series<dynamic, String>> seriesList = createSeriesProdukSampah(chartData);

    return charts.BarChart(
      seriesList,
      animate: true,
      // layoutConfig: charts.LayoutConfig(
      //   leftMarginSpec: charts.MarginSpec.fixedPixel(60),
      //   topMarginSpec: charts.MarginSpec.fixedPixel(60),
      //   rightMarginSpec: charts.MarginSpec.fixedPixel(60),
      //   bottomMarginSpec: charts.MarginSpec.fixedPixel(60),
      // ),
      vertical: false,
    );
  }

  Widget buildBarChartPembelian(List<Map<String, dynamic>> chartData, String id) {
    List<charts.Series<dynamic, String>> seriesList = createSeriesPembelian(chartData);

    return charts.BarChart(
      seriesList,
      animate: true,
    );
  }
}
