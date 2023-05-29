import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:rumah_sampah_t_a/app/controllers/auth_controller.dart';

enum RiwayatUserMode { LIST, PAYMENT }

class RiwayatController extends GetxController {
  Rx<RiwayatUserMode> riwayatUserMode = RiwayatUserMode.LIST.obs;
  Map<String, dynamic>? dataDetail;
  var dataIndexEdit = 0.obs;
  var tabC = 1.obs;
  var authC = Get.find<AuthController>();
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  LatLng centerMadiun = LatLng(-7.629039, 111.530110);

  var noHpC = TextEditingController();
  var alamatC = TextEditingController().obs;
  var tanggalC = ''.obs;
  var waktuC = ''.obs;
  var informasiC = TextEditingController();

  @override
  void onInit() {
    setViewMode(RiwayatUserMode.LIST);
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

  void setViewMode(RiwayatUserMode mode) {
    riwayatUserMode.value = mode;
  }

  Stream<QuerySnapshot<Map<String, dynamic>>?> fetchData() async* {
    try {
      yield* FirebaseFirestore.instance.collection('user').doc(authC.currentUser!.uid).collection('pesanan').snapshots();
    } catch (e) {
      print('Error: $e');
    }
  }

  Stream<DocumentSnapshot> fetchDataDetail(String id) {
    return FirebaseFirestore.instance.collection('pesanan').doc(id).snapshots();
  }
}
