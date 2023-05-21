// ignore_for_file: prefer_const_constructors

import 'dart:developer';
import 'dart:io';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
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

  FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  @override
  void onClose() {
    emailC.dispose();
    passwordC.dispose();
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
            "nohp": noHpC.text,
            "kelurahan": kelurahanC.text,
            "alamat": alamatC.text,
            "ktp": '',
            "status": '-1',
            "role": 'user',
          });
          await _uploadFileToFirestore(uid!);
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
        Get.defaultDialog(title: "Terjadi Kesalahan", middleText: "'${e.toString()}'");
      }
    } else {
      Get.defaultDialog(title: "Terjadi Kesalahan", middleText: "Email dan password wajib diisi");
    }
  }

  showUpload(BuildContext context) {
    showModalBottomSheet(
        isScrollControlled: true,
        enableDrag: true,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.only(topLeft: Radius.circular(25), topRight: Radius.circular(25))),
        backgroundColor: Colors.white,
        context: context,
        builder: (context) {
          FocusManager.instance.primaryFocus?.unfocus();
          FocusScope.of(context).unfocus();
          return Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                  margin: EdgeInsets.only(top: 8, bottom: 18),
                  child: Container(
                    width: 94,
                    height: 5,
                    decoration: BoxDecoration(color: Colors.grey, borderRadius: BorderRadius.all(Radius.circular(90))),
                  )),
              Container(
                margin: EdgeInsets.only(bottom: 24),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          height: 64,
                          width: 64,
                          decoration: BoxDecoration(
                            color: Color(ListColor.colorButtonGreen),
                            borderRadius: BorderRadius.circular(50),
                          ),
                          child: Material(
                            borderRadius: BorderRadius.circular(50),
                            color: Colors.transparent,
                            child: InkWell(
                              customBorder: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(50),
                              ),
                              onTap: () {
                                Get.back();
                                getFromCamera();
                              },
                              child: Container(padding: EdgeInsets.all(20), child: Icon(Icons.camera, color: Colors.white)),
                            ),
                          ),
                        ),
                        SizedBox(height: 16),
                        Text(
                          "Ambil Foto",
                          style: ListTextStyle.textStyleGray.copyWith(color: Colors.white),
                        ),
                      ],
                    ),
                    SizedBox(width: 84),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          height: 64,
                          width: 64,
                          decoration: BoxDecoration(
                            color: Color(ListColor.colorButtonGreen),
                            borderRadius: BorderRadius.circular(50),
                          ),
                          child: Material(
                            borderRadius: BorderRadius.circular(50),
                            color: Colors.transparent,
                            child: InkWell(
                              customBorder: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(50),
                              ),
                              onTap: () {
                                Get.back();
                                getFromGallery();
                              },
                              child: Container(
                                padding: EdgeInsets.all(20),
                                child: Icon(Icons.browse_gallery),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 16),
                        Text(
                          "Upload File",
                          style: ListTextStyle.textStyleGray.copyWith(color: Colors.white),
                        ),
                      ],
                    ),
                  ],
                ),
              )
            ],
          );
        });
  }

  void getFromGallery() async {
    XFile? pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {}
  }

  void getFromCamera() async {
    XFile? pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {}
  }

  Future<void> uploadKtp() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();

    if (result != null) {
      // JIKA ADA FILE
      fileKtp.value = File(result.files.single.path!);
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
