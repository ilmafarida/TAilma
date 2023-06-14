import 'dart:developer';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_place_picker_mb/google_maps_place_picker.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:rumah_sampah_t_a/app/controllers/auth_controller.dart';
import 'package:rumah_sampah_t_a/app/utils/list_color.dart';
import 'package:rumah_sampah_t_a/app/utils/list_text_style.dart';
import 'package:rumah_sampah_t_a/app/utils/utils.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:geolocator/geolocator.dart';

enum AntrianUserMode { LIST, PAYMENT }

class AntrianController extends GetxController {
  Rx<AntrianUserMode> antrianUserMode = AntrianUserMode.LIST.obs;
  var dataDetail = Rxn();
  var dataTotalPoin = ''.obs;
  var dataIndexEdit = ''.obs;
  var authC = Get.find<AuthController>();
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  var fileSampah = Rxn<File>();
  var listMetodePembayaran = ['Poin', 'Tukar dengan Produk'];
  var metode = ''.obs;
  var detailTukarPoin = <Map<String, dynamic>>[];
  var textEditingC = <int>[].obs;
  // var textEditingC = 0.obs;
  var sisaPoin = 0.obs;
  var latLong = LatLng(-7.629039, 111.530110).obs;

  var noHpC = TextEditingController();
  var alamatC = TextEditingController().obs;
  var tanggalC = ''.obs;
  var waktuC = ''.obs;
  var informasiC = TextEditingController();
  String? dateCreated;

  @override
  void onInit() {
    setViewMode(AntrianUserMode.LIST);
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

  void setViewMode(AntrianUserMode mode) {
    antrianUserMode.value = mode;
  }

  Stream<QuerySnapshot<Map<String, dynamic>>?> fetchData() async* {
    try {
      yield* FirebaseFirestore.instance.collection('user').doc(authC.currentUser!.uid).collection('antrian').snapshots();
    } catch (e) {
      print('Error: $e');
    }
  }

  Stream<QuerySnapshot<Map<String, dynamic>>?> fetchDataProduk() async* {
    try {
      yield* FirebaseFirestore.instance.collection('produk').snapshots();
    } catch (e) {
      print('Error: $e');
    }
  }

  Stream<DocumentSnapshot> fetchDataDetail(String id) {
    return FirebaseFirestore.instance.collection('antrian').doc(id).snapshots();
  }

  showDatePicker() async {
    final DateTime? selected = await showDialog(
      context: Get.context!,
      builder: (context) {
        return DatePickerDialog(
          initialDate: DateTime.now(),
          firstDate: DateTime.now(),
          lastDate: DateTime(2024),
          initialEntryMode: DatePickerEntryMode.calendarOnly,
        );
      },
    );
    if (selected != null) {
      String formattedDate = DateFormat('dd-MM-yyyy').format(selected);
      tanggalC.value = formattedDate;
    }
  }

  showWaktuPicker() async {
    final TimeOfDay? selectedTime = await showTimePicker(
      context: Get.context!,
      initialTime: TimeOfDay.now(),
      builder: (context, child) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true),
          child: child!,
        );
      },
    );

    if (selectedTime != null) {
      // Lakukan sesuatu dengan waktu yang dipilih
      print('Waktu yang dipilih: ${selectedTime.hour}:${selectedTime.minute}');
      waktuC.value = '${selectedTime.hour}:${selectedTime.minute}';
    }
  }

  Future<Position> getCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Memeriksa apakah layanan lokasi diaktifkan
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Layanan lokasi tidak diaktifkan, lakukan penanganan yang sesuai
      return Future.error('Layanan lokasi tidak diaktifkan');
    }

    // Memeriksa izin lokasi pengguna
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      // Izin lokasi ditolak, minta izin kepada pengguna
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Izin lokasi ditolak, lakukan penanganan yang sesuai
        return Future.error('Izin lokasi ditolak');
      }
    }

    // Mendapatkan posisi saat ini
    return await Geolocator.getCurrentPosition();
  }

  void getLatLong() async {
    Position res = await getCurrentLocation();
    latLong.value = LatLng(res.latitude, res.longitude);
    print(latLong.value);
    List<Placemark> placemarks = await placemarkFromCoordinates(res.latitude, res.longitude);
    if (placemarks.isNotEmpty) {
      print(placemarks[0].thoroughfare);

      alamatC.value.text = placemarks[0].thoroughfare!;
    }

    // Navigator.push(
    //   Get.context!,
    //   MaterialPageRoute(
    //     builder: (context) => PlacePicker(
    //       apiKey: 'AIzaSyCWNwj2M0PgFyuy83wrgNUKs5FXZbkNUdc',
    //       onPlacePicked: (result) {
    //         print(result);
    //         Navigator.of(context).pop();
    //       },
    //       initialPosition: centerMadiun,
    //       useCurrentLocation: true,
    //       resizeToAvoidBottomInset: false, // only works in page mode, less flickery, remove if wrong offsets
    //     ),
    //   ),
    // );
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
                    decoration: BoxDecoration(color: Color(ListColor.colorButtonGreen), borderRadius: BorderRadius.all(Radius.circular(90))),
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
                          style: ListTextStyle.textStyleGray.copyWith(color: Colors.black),
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
                                child: Icon(Icons.file_present_rounded, color: Colors.white),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 16),
                        Text(
                          "Upload File",
                          style: ListTextStyle.textStyleGray.copyWith(color: Colors.black),
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
    if (pickedFile != null) {
      fileSampah.value = File(pickedFile.path);
      log(fileSampah.value!.path);
    } else {
      // JIKA USER CANCEL UPLOAD
      return;
    }
  }

  void getFromCamera() async {
    XFile? pickedFile = await ImagePicker().pickImage(source: ImageSource.camera);
    if (pickedFile != null) {
      fileSampah.value = File(pickedFile.path);
      log(fileSampah.value!.path);
    } else {
      // JIKA USER CANCEL UPLOAD
      return;
    }
  }

  Future<void> uploadFileToFirestore(String uid) async {
    String fileName = '${authC.userData.fullname}-${DateTime.now()}';
    Reference storageReference = FirebaseStorage.instance.ref().child('fileSampah/$fileName');
    UploadTask uploadTask = storageReference.putFile(fileSampah.value!);
    TaskSnapshot storageSnapshot = await uploadTask.whenComplete(() {});
    String downloadUrl = await storageSnapshot.ref.getDownloadURL();
    log(downloadUrl);
    // Data telah berhasil diunggah ke Firestore
    await firestore.collection('user').doc(uid).collection('penukaran').doc(dataIndexEdit.value.toString()).update({'file': downloadUrl});
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
                  fileSampah.value!,
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

  deleteCart(String idx) {
    showDialog(
      context: Get.context!,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Color(ListColor.colorButtonGray),
          insetPadding: EdgeInsets.symmetric(horizontal: 70),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          content: SizedBox(
            height: 100,
            width: 183,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Apakah kamu yakin\ningin menghapus?',
                  style: ListTextStyle.textStyleBlackW700.copyWith(fontSize: 15, height: 19.5 / 15),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 30),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    GestureDetector(
                      onTap: () => Get.back(),
                      child: Text(
                        'Tidak',
                        style: ListTextStyle.textStyleBlackW700.copyWith(fontSize: 15),
                      ),
                    ),
                    GestureDetector(
                      onTap: () async {
                        firestore.collection('user').doc(authC.currentUser!.uid).collection('antrian').doc(idx).delete();
                        Get.back();
                      },
                      child: Text(
                        'Ya',
                        style: ListTextStyle.textStyleBlackW700.copyWith(fontSize: 15),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        );
      },
    );
  }

  void submitPesanan(List<Map<String, dynamic>?> dataJson) async {
    DateFormat dateFormat = DateFormat('d-M-y', 'id_ID');
    dateCreated = '${Utils.generateRandomString(3)}-${dateFormat.format(DateTime.now())}';
    await firestore.collection("user").doc(authC.currentUser!.uid).collection('pesanan').doc(dateCreated).set({
      "nohp": noHpC.text,
      "tanggal": tanggalC.value,
      "jam": waktuC.value,
      "informasi": informasiC.text,
      "alamat": alamatC.value.text,
      "jenis": 'tukar',
      'status': '1',
      'latlong': '${latLong.value.latitude},${latLong.value.longitude}',
      'metode': metode.value,
      'tukar-dengan': '',
      'file-bukti': '',
      "detail": FieldValue.arrayUnion(dataJson),
      "total_poin": dataTotalPoin.value,
      "total_harga": '',
      'uid': dateCreated,
      'tukar_dengan': detailTukarPoin,
    });

    //MENGHAPUS ISI KERANJANG
    CollectionReference collectionRef = firestore.collection('user').doc(authC.currentUser!.uid).collection('antrian');
    QuerySnapshot querySnapshot = await collectionRef.get();
    for (var doc in querySnapshot.docs) {
      doc.reference.delete();
    }
    await _uploadFileToFirestore(dateCreated!);
  }

  Future<void> _uploadFileToFirestore(String uid) async {
    String fileName = '${authC.userData.fullname}-${DateTime.now()}';
    Reference storageReference = FirebaseStorage.instance.ref().child('file-bukti-pembayaran/$fileName');
    UploadTask uploadTask = storageReference.putFile(fileSampah.value!);
    TaskSnapshot storageSnapshot = await uploadTask.whenComplete(() {});
    String downloadUrl = await storageSnapshot.ref.getDownloadURL();
    log(downloadUrl);
    // Data telah berhasil diunggah ke Firestore
    await firestore.collection('user').doc(authC.currentUser!.uid).collection('pesanan').doc(uid).update({'file-bukti': downloadUrl});
  }
}
