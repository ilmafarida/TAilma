import 'dart:developer';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:rumah_sampah_t_a/app/controllers/auth_controller.dart';
import 'package:rumah_sampah_t_a/app/utils/list_color.dart';
import 'package:rumah_sampah_t_a/app/utils/list_text_style.dart';
import 'package:rumah_sampah_t_a/app/utils/utils.dart';

enum PesananUserMode { LIST, PAYMENT }

class PesananController extends GetxController {
  Rx<PesananUserMode> riwayatUserMode = PesananUserMode.LIST.obs;
  Map<String, dynamic>? dataDetail;
  var dataIndexEdit = 0.obs;
  var tabC = 1.obs;
  var tabList = ['Antrian', 'Proses', 'Selesai'];
  var listMetodePembayaran = ['Poin', 'Transfer', 'Bayar Ditempat'];
  var fileBuktiPembayaran = Rxn<File>();
  var authC = Get.find<AuthController>();
  var metode = ''.obs;
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  LatLng latLng = LatLng(-7.629039, 111.530110);

  var noHpC = TextEditingController();
  var alamatC = TextEditingController().obs;
  var tanggalC = ''.obs;
  var waktuC = ''.obs;
  var informasiC = TextEditingController();

  @override
  void onInit() {
    setViewMode(PesananUserMode.LIST);
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

  void setViewMode(PesananUserMode mode) {
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
      fileBuktiPembayaran.value = File(pickedFile.path);
      log(fileBuktiPembayaran.value!.path);
    } else {
      // JIKA USER CANCEL UPLOAD
      return;
    }
  }

  void getFromCamera() async {
    XFile? pickedFile = await ImagePicker().pickImage(source: ImageSource.camera);
    if (pickedFile != null) {
      fileBuktiPembayaran.value = File(pickedFile.path);
      log(fileBuktiPembayaran.value!.path);
    } else {
      // JIKA USER CANCEL UPLOAD
      return;
    }
  }

  Future<void> _uploadFileToFirestore(String uid) async {
    String fileName = '${authC.userData.fullname}-${DateTime.now()}';
    Reference storageReference = FirebaseStorage.instance.ref().child('file-bukti-pembayaran/$fileName');
    UploadTask uploadTask = storageReference.putFile(fileBuktiPembayaran.value!);
    TaskSnapshot storageSnapshot = await uploadTask.whenComplete(() {});
    String downloadUrl = await storageSnapshot.ref.getDownloadURL();
    log(downloadUrl);
    // Data telah berhasil diunggah ke Firestore
    await firestore.collection('user').doc(authC.currentUser!.uid).collection('pesanan').doc(uid).update({'file-bukti': downloadUrl});
  }

  previewFile(BuildContext context, int type) {
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
                child: type == 1
                    ? Image.network(dataDetail!['file-bukti'])
                    : Image.file(
                        fileBuktiPembayaran.value!,
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

  void bayarPesanan() {
    try {
      if (metode.value == 'Poin') {
        var minus = (int.parse(authC.userData.poin!) - int.parse(dataDetail!['total_poin'])).toString();
        print(minus);
        firestore.collection('user').doc(authC.auth.currentUser!.uid.toString()).update({
          'poin': minus,
        });
      }
      if (metode.value == 'Transfer') {
        _uploadFileToFirestore(dataDetail!['uid']);
      }
      firestore.collection('user').doc(authC.auth.currentUser!.uid.toString()).collection('pesanan').doc(dataDetail!['uid']).update({
        'status': '3',
        'metode': metode.value,
      });
      setViewMode(PesananUserMode.LIST);
      tabC.value = 3;
      Utils.showNotif(TypeNotif.SUKSES, 'Pembayaran berhasil');
    } catch (e) {
      Utils.showNotif(TypeNotif.ERROR, '$e');
      print(e);
    }
  }
}
