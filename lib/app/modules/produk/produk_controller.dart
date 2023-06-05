import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:rumah_sampah_t_a/app/controllers/auth_controller.dart';

enum ProdukUserMode { LIST, DETAIL }

class ProdukController extends GetxController {
  Rx<ProdukUserMode> produkUserMode = ProdukUserMode.LIST.obs;
  var dataDetail = Rxn();
  var dataIndexEdit = ''.obs;
  var jumlahProduk = 1.obs;
  var authC = Get.find<AuthController>();
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  @override
  void onInit() {
    setViewMode(ProdukUserMode.LIST);

    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

  void setViewMode(ProdukUserMode mode) {
    produkUserMode.value = mode;
  }

  Stream<QuerySnapshot<Map<String, dynamic>>?> fetchData() async* {
    try {
      yield* FirebaseFirestore.instance.collection('produk').snapshots();
    } catch (e) {
      print('Error: $e');
    }
  }

  Stream<DocumentSnapshot> fetchDataDetail(String id) {
    return FirebaseFirestore.instance.collection('produk').doc(id).snapshots();
  }

  Future<void> submitKeranjang([Map<String, dynamic>? dataTambahan]) async {
    print(':::  ${dataIndexEdit.value}');
    firestore.collection("user").doc(authC.currentUser!.uid).collection('keranjang').doc(dataIndexEdit.value).set({
      "gambar": dataTambahan!['gambar'],
      "jenis": dataTambahan['nama'],
      "harga": dataTambahan['harga'],
      "poin": dataTambahan['poin'],
      "jumlah": dataTambahan['jumlah'].toString(),
      "uid": dataIndexEdit.value,
    }).then((value) => setViewMode(ProdukUserMode.LIST));
  }
}
