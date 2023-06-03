// ignore_for_file: prefer_const_constructors

import 'dart:developer';
import 'dart:io';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:rumah_sampah_t_a/app/controllers/auth_controller.dart';
import 'package:rumah_sampah_t_a/app/utils/list_color.dart';
import 'package:rumah_sampah_t_a/app/utils/list_text_style.dart';
import 'package:rumah_sampah_t_a/app/utils/shared_preference.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../routes/app_pages.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class SignupController extends GetxController {
  TextEditingController emailC = TextEditingController();
  TextEditingController passwordC = TextEditingController();
  TextEditingController fullnameC = TextEditingController();
  TextEditingController kecamatanC = TextEditingController();
  TextEditingController kelurahanC = TextEditingController();
  TextEditingController alamatC = TextEditingController();
  var noHpC = TextEditingController();
  var fileKtp = Rxn<File>();
  var isPasswordHidden = true.obs;

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

  var loadingAPI = false.obs;
  var authC = Get.find<AuthController>();

  FirebaseFirestore firestore = FirebaseFirestore.instance;

  @override
  void onClose() {
    super.onClose();
  }

  @override
  void onInit() async {
    super.onInit();
    // fetchData();
  }

  void signUp() async {
    if (emailC.text.isNotEmpty && passwordC.text.isNotEmpty) {
      try {
        UserCredential userCredential = await authC.auth.createUserWithEmailAndPassword(
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
            "nohp": noHpC.text,
            "kelurahan": kelurahanC.text,
            "alamat": alamatC.text,
            "ktp": '',
            "poin": "",
            "sampah": "",
            "status": '-1',
            "role": 'user',
          });
          await _uploadFileToFirestore(uid!);
        }

        //print(userCredential);
        // await SharedPreference.setRoleUser(authC.userData.role!);

        Get.offAllNamed(Routes.WAITING);
      } on FirebaseAuthException catch (e) {
        if (e.code == 'weak-password') {
          ScaffoldMessenger.of(Get.context!).showSnackBar(const SnackBar(content: Text("Password lemah. Minimal 6 karakter")));
        } else if (e.code == 'email-already-in-use') {
          ScaffoldMessenger.of(Get.context!).showSnackBar(const SnackBar(content: Text("Email sudah digunakan")));
        }
      } catch (e) {
        ScaffoldMessenger.of(Get.context!).showSnackBar(SnackBar(content: Text("$e")));
      }
    } else if (emailC.text.isEmpty || passwordC.text.isEmpty || fullnameC.text.isEmpty || noHpC.text.isEmpty || kecamatanC.text.isEmpty || kelurahanC.text.isEmpty || alamatC.text.isEmpty || fileKtp.value == null) {
      ScaffoldMessenger.of(Get.context!).showSnackBar(SnackBar(content: Text("Field harus diisi semua")));
    } else {
      ScaffoldMessenger.of(Get.context!).showSnackBar(SnackBar(content: Text("Email dan password wajib diisi")));
    }
  }

  void getFromCamera() async {
    XFile? pickedFile = await ImagePicker().pickImage(source: ImageSource.camera);
    if (pickedFile != null) {
      fileKtp.value = File(pickedFile.path);
      log(fileKtp.value!.path);
    } else {
      // JIKA USER CANCEL UPLOAD
      return;
    }
  }

  Future<void> _uploadFileToFirestore(String uid) async {
    String fileName = '${fullnameC.text}-${DateTime.now()}';
    Reference storageReference = FirebaseStorage.instance.ref().child('fileKTP/$fileName');
    UploadTask uploadTask = storageReference.putFile(fileKtp.value!);
    TaskSnapshot storageSnapshot = await uploadTask.whenComplete(() {});
    String downloadUrl = await storageSnapshot.ref.getDownloadURL();
    log(downloadUrl);
    // Data telah berhasil diunggah ke Firestore
    await firestore.collection('user').doc(uid).update({'ktp': downloadUrl});
  }

  previewFile(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) {
        final width = ctx.width;
        final height = ctx.height;
        return AlertDialog(
          content: Stack(
            children: [
              SizedBox(
                width: width * 0.9,
                height: height * 0.7,
                child: Image.file(
                  fileKtp.value!,
                  fit: BoxFit.fill,
                ),
              ),
              GestureDetector(
                onTap: () => Navigator.pop(context),
                child: Padding(
                  padding: const EdgeInsets.all(3.0),
                  child: Container(
                    decoration: BoxDecoration(color: Colors.black.withOpacity(0.5), shape: BoxShape.circle),
                    child: Icon(
                      CupertinoIcons.xmark_circle,
                      color: Colors.white.withOpacity(0.9),
                      size: 40,
                    ),
                  ),
                ),
              )
            ],
          ),
          insetPadding: EdgeInsets.zero,
          contentPadding: EdgeInsets.zero,
          clipBehavior: Clip.antiAliasWithSaveLayer,
        );
      },
    );
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
