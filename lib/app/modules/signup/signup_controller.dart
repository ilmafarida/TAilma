import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import '../../routes/app_pages.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class SignupController extends GetxController {
  TextEditingController emailC = TextEditingController();
  TextEditingController passwordC = TextEditingController();
  TextEditingController fullnameC = TextEditingController();
  TextEditingController kecamatanC = TextEditingController();
  TextEditingController kelurahanC = TextEditingController();
  TextEditingController alamatC = TextEditingController();
  TextEditingController ktpC = TextEditingController();

  var isPasswordHidden = true.obs;

  FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  var listKecamatan = <String>[].obs;

  @override
  void onClose() {
    emailC.dispose();
    passwordC.dispose();
    super.onClose();
  }

  @override
  void onInit() {
    super.onInit();
    // fetchData();
  }

  void Signup() async {
    if (emailC.text.isNotEmpty && passwordC.text.isNotEmpty) {
      try {
        UserCredential userCredential = await auth.createUserWithEmailAndPassword(
          email: emailC.text,
          password: passwordC.text,
        );

        if (userCredential.user != null) {
          String? uid = userCredential.user?.uid;

          firestore.collection("user").doc(uid).set({
            "uid": uid,
            "email": emailC.text,
            "password": passwordC.text,
            "fullname": fullnameC.text,
            "kecamatan": kecamatanC.text,
            "kelurahan": kelurahanC.text,
            "alamat": alamatC.text,
            "ktp": ktpC.text
          });
        }

        //print(userCredential);

        Get.offAllNamed(Routes.WAITING);
      } on FirebaseAuthException catch (e) {
        if (e.code == 'weak-password') {
          Get.defaultDialog(title: "Terjadi Kesalahan", middleText: "Password lemah, minimal 6 karakter");
        } else if (e.code == 'email-already-in-use') {
          Get.defaultDialog(title: "Terjadi Kesalahan", middleText: "Email sudah digunakan");
        }
      } catch (e) {
        Get.defaultDialog(title: "Terjadi Kesalahan", middleText: "Tidak dapat mendaftar");
      }
    } else {
      Get.defaultDialog(title: "Terjadi Kesalahan", middleText: "Email dan password wajib diisi");
    }
  }

  // Future<void> fetchData() async {
  //   Future.wait([fetchDataKota(), fetchDataKabupaten()]).then((List responses) {
  //     // Mengakses hasil permintaan API di sini
  //     // listKecamatan = responses[0];
  //     print('Response 1: ${responses[0]}');
  //     print('Response 2: ${responses[1]}');
  //     Map<String, dynamic> dataKota = jsonDecode(responses[0]);
  //     Map<String, dynamic> dataKabupaten = jsonDecode(responses[1]);

  //     List<Map<String, dynamic>> listKota = List<Map<String, dynamic>>.from(dataKota['kecamatan']);
  //     List<Map<String, dynamic>> listKabupaten = List<Map<String, dynamic>>.from(dataKabupaten['kecamatan']);

  //     List<String> listDariKota = listKota.map((kecamatan) => kecamatan['nama'].toString()).toList();
  //     List<String> listDariKabupaten = listKabupaten.map((kecamatan) => kecamatan['nama'].toString()).toList();

  //     // Menampilkan nilai "nama" dari setiap kecamatan
  //     for (String dariKota in listDariKota) {
  //       listKecamatan.add(dariKota);
  //     }

  //     for (String dariKabupaten in listDariKabupaten) {
  //       listKecamatan.add(dariKabupaten);
  //     }

  //   }).catchError((error) {
  //     // Tangani kesalahan jika ada
  //     print('Error: $error');
  //   });
  // }

  // Future<String> fetchDataKota() async {
  //   var kotaMadiun = '3577';
  //   var urlKota = 'https://dev.farizdotid.com/api/daerahindonesia/kecamatan?id_kota=$kotaMadiun';

  //   var response = await http.get(Uri.parse(urlKota));

  //   if (response.statusCode == 200) {
  //     return response.body;
  //   } else {
  //     throw Exception('Failed to fetch data Kota Madiun');
  //   }
  // }

  // Future<String> fetchDataKabupaten() async {
  //   var kabMadiun = '3519';

  //   var urlKab = 'https://dev.farizdotid.com/api/daerahindonesia/kecamatan?id_kota=$kabMadiun';

  //   var response = await http.get(Uri.parse(urlKab));

  //   if (response.statusCode == 200) {
  //     return response.body;
  //   } else {
  //     throw Exception('Failed to fetch dari Kabupaten Madiun');
  //   }
  // }
}
