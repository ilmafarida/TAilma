import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rumah_sampah_t_a/app/controllers/auth_controller.dart';

class DashboardController extends GetxController {
  final _firestore = FirebaseFirestore.instance;
  var authC = AuthController();
  var jumlahPesanan = Rxn();
  var jumlahPenukaran = Rxn();
  var jumlahSampah = RxInt(0);
  var jumlahProduk = RxInt(0);
  List<QueryDocumentSnapshot> pesananDocuments = [];
  List<QueryDocumentSnapshot> antrianDocuments = [];

  @override
  void onInit() async {
    handleData();
    super.onInit();
  }

  handleData() async {
    jumlahSampah.value = 0;
    jumlahProduk.value = 0;
    pesananDocuments.clear();
    antrianDocuments.clear();
    await getDataSampah().then((List<QueryDocumentSnapshot> documents) {
      // Meng-handle data di sini
      for (var document in documents) {
        // Akses data di dalam dokumen
        Map<String, dynamic>? data = document.data() as Map<String, dynamic>;
        // print('DATA : $data');
        List<Map<String, dynamic>> detailData = List<Map<String, dynamic>>.from(data['detail']);
        // Perulangan untuk mengakses nilai dari kunci 'jumlah'
        for (var detail in detailData) {
          int jumlah = int.parse(detail['jumlah']);
          jumlahSampah.value += jumlah;
        }
        print('JUMLAH KG :${jumlahSampah.value}');

        // Lakukan sesuatu dengan data tersebut
      }
      // print('DATA: $documents');
    }).catchError((error) {
      // Meng-handle error jika terjadi
      print('Error Sampah: $error');
    });
    await getDataProdukTerjual().then((List<QueryDocumentSnapshot> documents) {
      // Meng-handle data di sini
      for (var document in documents) {
        // Akses data di dalam dokumen
        Map<String, dynamic>? data = document.data() as Map<String, dynamic>;
        print('DATA : $data');
        List<Map<String, dynamic>> detailData = List<Map<String, dynamic>>.from(data['detail']);
        // Perulangan untuk mengakses nilai dari kunci 'jumlah'
        for (var detail in detailData) {
          int jumlah = int.parse(detail['jumlah']);
          jumlahProduk.value += jumlah;
        }
        print('JUMLAH  PRODUK:${jumlahProduk.value}');

        // Lakukan sesuatu dengan data tersebut
      }
      // print('DATA: $documents');
    }).catchError((error) {
      // Meng-handle error jika terjadi
      print('Error Sampah: $error');
    });
  }

  Future<List<QueryDocumentSnapshot>> getDataPesanan() async {
    QuerySnapshot querySnapshot = await _firestore.collection('user').get();
    List<QueryDocumentSnapshot> documents = querySnapshot.docs;

    for (var document in documents) {
      QuerySnapshot pesananQuerySnapshot = await _firestore.collection('user').doc(document.id).collection('pesanan').where('jenis', isEqualTo: 'beli').where('status', isGreaterThanOrEqualTo: '1').get();
      pesananDocuments.addAll(pesananQuerySnapshot.docs);
    }
    jumlahPesanan.value = pesananDocuments.length;
    return pesananDocuments;
  }

  Future<List<QueryDocumentSnapshot>> getDataAntrian() async {
    QuerySnapshot querySnapshot = await _firestore.collection('user').get();
    List<QueryDocumentSnapshot> documents = querySnapshot.docs;

    for (var document in documents) {
      QuerySnapshot antrianQuerySnapshot = await _firestore.collection('user').doc(document.id).collection('pesanan').where('jenis', isEqualTo: 'tukar').get();
      antrianDocuments.addAll(antrianQuerySnapshot.docs);
    }
    jumlahPenukaran.value = antrianDocuments.length;
    return antrianDocuments;
  }

  Future<List<QueryDocumentSnapshot>> getDataSampah() async {
    QuerySnapshot querySnapshot = await _firestore.collection('user').get();
    List<QueryDocumentSnapshot> documents = querySnapshot.docs;
    List<QueryDocumentSnapshot> sampahDocument = [];
    for (var document in documents) {
      QuerySnapshot antrianQuerySnapshot = await _firestore.collection('user').doc(document.id).collection('pesanan').where('jenis', isEqualTo: 'tukar').where('status', isEqualTo: '5').get();
      sampahDocument.addAll(antrianQuerySnapshot.docs);
    }
    // print(sampahDocument);
    return sampahDocument;
  }

  Future<List<QueryDocumentSnapshot>> getDataProdukTerjual() async {
    QuerySnapshot querySnapshot = await _firestore.collection('user').get();
    List<QueryDocumentSnapshot> documents = querySnapshot.docs;
    List<QueryDocumentSnapshot> produkDocument = [];
    for (var document in documents) {
      QuerySnapshot produkQuerySnapshot = await _firestore.collection('user').doc(document.id).collection('pesanan').where('jenis', isEqualTo: 'beli').where('status', isEqualTo: '5').get();
      produkDocument.addAll(produkQuerySnapshot.docs);
    }
    print(produkDocument);
    return produkDocument;
  }

  Future<void> onRefresh() {
    // Lakukan operasi refresh yang diperlukan, seperti mengambil ulang data dari Firestore
    // atau melakukan tindakan lain yang sesuai dengan kebutuhan Anda

    // Contoh: mengambil ulang data dengan memanggil metode getData()
    return handleData().then((_) {
      // Refresh berhasil, tidak perlu mengembalikan nilai
    }).catchError((error) {
      // Meng-handle error jika terjadi
      print('Error: $error');
    });
  }
}
