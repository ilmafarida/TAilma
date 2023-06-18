import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rumah_sampah_t_a/app/controllers/auth_controller.dart';
import 'package:rumah_sampah_t_a/app/utils/utils.dart';

class UbahAlamatController extends GetxController {
  var authC = Get.find<AuthController>();
  var loading = false.obs;
  var kecamatanC = TextEditingController();
  var kelurahanC = TextEditingController();
  var alamatC = RxnString();
  int? idKecamatan;
  int? idKelurahan;
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  var listKecamatan = [
    "Kartoharjo",
    "Manguharjo",
    "Taman",
  ];
  var listKelurahan = [
    "Kanigoro",
    "Kelun",
    "Kartoharjo",
    "Klegen",
    "Oro-Oro Ombo",
    "Pilangbango",
    "Rejomulyo",
    "Sukosari",
    "Tawangrejo",
    "Madiun Lor",
    "Manguharjo",
    "Nambangan Lor",
    "Nambangan Kidul",
    "Ngegong",
    "Pangongangan",
    "Patihan",
    "Sogaten",
    "Winongo",
    "Banjarejo",
    "Demangan",
    "Josenan",
    "Kejuron",
    "Kuncen",
    "Mojorejo",
    "Manisrejo",
    "Pandean",
    "Taman"
  ];

  @override
  void onInit() {
    super.onInit();
    kecamatanC.text = authC.userData.kecamatan.toString();
    if (listKecamatan.contains(kecamatanC.text)) idKecamatan = listKecamatan.indexOf(kecamatanC.text);
    kelurahanC.text = authC.userData.kelurahan.toString();
    if (listKelurahan.contains(kelurahanC.text)) idKelurahan = listKelurahan.indexOf(kelurahanC.text);
    alamatC.value = authC.userData.alamat.toString();
  }

  @override
  void onClose() {
    super.onClose();
  }

  void submit() {
    if (kecamatanC.text.isEmpty || kelurahanC.text.isEmpty || alamatC.value == null) {
      Utils.showNotif(TypeNotif.ERROR, 'Field harus diisi');
      return;
    }
    firestore.collection('user').doc(authC.currentUser!.uid).update({
      'kecamatan': kecamatanC.text,
      'kelurahan': kelurahanC.text,
      'alamat': alamatC.value,
    }).then((value) {
      Get.back();
      Get.back();
      Utils.showNotif(TypeNotif.SUKSES, 'Ubah data berhasil');
    }).onError((error, stackTrace) {
      Get.back();
      Get.back();
      Utils.showNotif(TypeNotif.ERROR, 'Ubah data gagal');
    });
  }
}
