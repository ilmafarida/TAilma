import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:rumah_sampah_t_a/app/controllers/auth_controller.dart';

enum TukarSampahViewMode { LIST, DETAIL }

class TukarSampahController extends GetxController {
  Rx<TukarSampahViewMode> tukarSampahViewMode = TukarSampahViewMode.LIST.obs;
  var dataDetail = Rxn();
  var dataIndexEdit = 0.obs;
  var jumlahTukarSampah = 1.obs;
  var authC = Get.find<AuthController>();
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  @override
  void onInit() {
    setViewMode(TukarSampahViewMode.LIST);

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

  void setViewMode(TukarSampahViewMode mode) {
    tukarSampahViewMode.value = mode;
  }

  Stream<QuerySnapshot<Map<String, dynamic>>?> fetchData() async* {
    try {
      yield* FirebaseFirestore.instance.collection('sampah').snapshots();
    } catch (e) {
      print('Error: $e');
    }
  }

  Stream<DocumentSnapshot> fetchDataDetail(String id) {
    return FirebaseFirestore.instance.collection('sampah').doc(id).snapshots();
  }

  Future<void> submitKeranjang([Map<String, dynamic>? dataTambahan]) async {
    print(':::  ${dataIndexEdit.value}');
    try {
      firestore.collection("user").doc(authC.currentUser!.uid).collection('antrian').doc('${dataIndexEdit.value}').set({
        "jenis": dataTambahan!['jenis'],
        "poin": dataTambahan['poin'],
        "jumlah": dataTambahan['jumlah'].toString(),
      });
    } catch (e) {
      print('ERRORD :$e');
    }
  }

  Future<int> getIdKeranjangTerakhir() async {
    int? nextId = 0;
    try {
      FirebaseFirestore firestore = FirebaseFirestore.instance;
      String collectionName = 'user'; // Nama koleksi yang ingin Anda dapatkan ID-nya

      QuerySnapshot querySnapshot = await firestore.collection(collectionName).doc(authC.currentUser!.uid).collection('keranjang').orderBy(FieldPath.documentId, descending: true).limit(1).get();

      String lastDocumentId = querySnapshot.docs.first.id;

      nextId = int.parse(lastDocumentId) + 1;

      print('Next ID: $nextId');
    } catch (e) {
      log('EERROR :$e');
    }
    print('Next ID: $nextId');
    return nextId!;
  }
}
