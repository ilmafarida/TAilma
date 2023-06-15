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
import 'package:rumah_sampah_t_a/app/utils/utils.dart';
import 'package:rumah_sampah_t_a/app/widgets/display_maps.dart';
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
  var latLong = LatLng(-7.629039, 111.530110).obs;

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
    var res = await Get.to(() => DisplayMaps());
    if (res != null) {
      latLong.value = LatLng(res['lat'], res['long']);
      alamatC.value.text = res['alamat'];
    }
  }

  void submitPesanan(List<Map<String, dynamic>?> dataJson) async {
    DateFormat dateFormat = DateFormat('d-M-y', 'id_ID');
    var dateCreated = '${Utils.generateRandomString(3)}-${dateFormat.format(DateTime.now())}';

    firestore.collection("user").doc(authC.currentUser!.uid).collection('pesanan').doc(dateCreated).set({
      "nohp": noHpC.text,
      "tanggal": tanggalC.value,
      "jam": waktuC.value,
      "informasi": informasiC.text,
      "alamat": alamatC.value.text,
      "jenis": 'beli',
      'status': '1',
      'metode': '',
      'file-bukti': '',
      'latlong': '${latLong.value.latitude},${latLong.value.longitude}',
      "detail": FieldValue.arrayUnion(dataJson),
      "total_poin": dataTotalPoin.value,
      "total_harga": dataTotalHarga.value,
      'uid': dateCreated,
    });
    //MENGHAPUS ISI KERANJANG
    CollectionReference collectionRef = firestore.collection('user').doc(authC.currentUser!.uid).collection('keranjang');
    QuerySnapshot querySnapshot = await collectionRef.get();
    for (var doc in querySnapshot.docs) {
      doc.reference.delete();
    }
  }

  deleteCart(String uid) {
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
                        try {
                          firestore.collection('user').doc(authC.currentUser!.uid).collection('keranjang').doc(uid).delete();
                          Get.back();
                        } catch (e) {
                          print(e);
                        }
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
