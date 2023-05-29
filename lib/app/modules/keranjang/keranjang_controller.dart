import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_place_picker_mb/google_maps_place_picker.dart';
import 'package:intl/intl.dart';
import 'package:rumah_sampah_t_a/app/controllers/auth_controller.dart';
import 'package:rumah_sampah_t_a/app/utils/list_color.dart';
import 'package:rumah_sampah_t_a/app/utils/list_text_style.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:geolocator/geolocator.dart';

enum KeranjangUserMode { LIST, PAYMENT }

class KeranjangController extends GetxController {
  Rx<KeranjangUserMode> keranjangUserMode = KeranjangUserMode.LIST.obs;
  var dataDetail = Rxn();
  var dataTotalHarga = ''.obs;
  var dataTotalPoin = ''.obs;
  var dataIndexEdit = 0.obs;
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
    setViewMode(KeranjangUserMode.LIST);
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

  void setViewMode(KeranjangUserMode mode) {
    keranjangUserMode.value = mode;
  }

  Stream<QuerySnapshot<Map<String, dynamic>>?> fetchData() async* {
    try {
      yield* FirebaseFirestore.instance.collection('user').doc(authC.currentUser!.uid).collection('keranjang').snapshots();
    } catch (e) {
      print('Error: $e');
    }
  }

  Stream<DocumentSnapshot> fetchDataDetail(String id) {
    return FirebaseFirestore.instance.collection('keranjang').doc(id).snapshots();
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
    );

    if (selectedTime != null) {
      // Lakukan sesuatu dengan waktu yang dipilih
      print('Waktu yang dipilih: ${selectedTime.format(Get.context!)}');
      waktuC.value = selectedTime.format(Get.context!);
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

    List<Placemark> placemarks = await placemarkFromCoordinates(res.latitude, res.longitude);
    if (placemarks.isNotEmpty) {
      print(placemarks[0].street);
      alamatC.value.text = placemarks[0].street!;
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

  Future<int> getIdKeranjangTerakhir() async {
    int? nextId = 0;
    try {
      FirebaseFirestore firestore = FirebaseFirestore.instance;
      String collectionName = 'user'; // Nama koleksi yang ingin Anda dapatkan ID-nya

      QuerySnapshot querySnapshot = await firestore.collection(collectionName).doc(authC.currentUser!.uid).collection('pembelian').orderBy(FieldPath.documentId, descending: true).limit(1).get();

      String lastDocumentId = querySnapshot.docs.first.id;

      nextId = int.parse(lastDocumentId) + 1;

      print('Next ID: $nextId');
    } catch (e) {
      log('EERROR :$e');
    }
    print('Next ID: $nextId');
    return nextId!;
  }

  deleteCart(int idx) {
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
                        firestore.collection('user').doc(authC.currentUser!.uid).collection('keranjang').doc('$idx').delete();
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
}
