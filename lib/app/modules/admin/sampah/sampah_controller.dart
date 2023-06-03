import 'dart:developer';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:rumah_sampah_t_a/app/controllers/auth_controller.dart';
import 'package:rumah_sampah_t_a/app/utils/list_color.dart';
import 'package:rumah_sampah_t_a/app/utils/list_text_style.dart';
import 'package:path/path.dart' as base;
import 'package:rumah_sampah_t_a/app/utils/utils.dart';
import 'package:rumah_sampah_t_a/app/widgets/upload_component.dart';

enum SampahMode { VIEW, EDIT, CREATE }

class AdminSampahController extends GetxController {
  var authC = Get.find<AuthController>();
  Rx<SampahMode> sampahMode = SampahMode.VIEW.obs;
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  var jenisC = TextEditingController();
  var poinC = TextEditingController();
  var syaratC = TextEditingController();
  var satuanC = TextEditingController();
  var file = Rxn<File>();
  UploadComponent uploadComponent = UploadComponent();

  Stream<QuerySnapshot>? stream;
  var dataEdit = Rxn();
  var dataIndexEdit = ''.obs;

  var isUpload = false.obs;

  void setViewMode(SampahMode mode) {
    sampahMode.value = mode;
  }

  @override
  void onInit() {
    setViewMode(SampahMode.VIEW);
    fetchData();
    super.onInit();
  }

  @override
  void onClose() {
    setViewMode(SampahMode.VIEW);
    isUpload.value = false;
    super.onClose();
  }

  Stream<QuerySnapshot<Map<String, dynamic>>?> fetchData() async* {
    try {
      yield* FirebaseFirestore.instance.collection('sampah').snapshots();
    } catch (e) {
      print('Error: $e');
    }
  }

  Stream<DocumentSnapshot> fetchDataDetail() {
    return FirebaseFirestore.instance.collection('sampah').doc('${dataIndexEdit.value}').snapshots();
  }

  Future<void> prosesSubmit({int? status, String? uid}) async {
    String idProduk = 'SPH-${Utils.generateRandomString(2)}';

    print('UID: $uid');
    setViewMode(SampahMode.VIEW);
    if (status == -1) {
      try {
        await firestore.collection('sampah').doc('$uid').delete();
        ScaffoldMessenger.of(Get.context!).showSnackBar(SnackBar(content: Text("Hapus Berhasil")));
        // print(':::${dataEdit.value['status']}');
      } catch (e) {
        log('ERROR : $e');
      }
    } else if (status == 0) {
      try {
        await firestore.collection('sampah').doc(idProduk).set({
          'syarat': syaratC.text,
          'jenis': jenisC.text,
          'poin': poinC.text,
          'satuan': satuanC.text,
          'uid': idProduk,
          'gambar': '',
        });
        if (isUpload.value) {
          await uploadFileToFirestore(
            database: 'sampah',
            field: 'gambar',
            path: 'file-sampah',
            firestore: firestore,
            uid: idProduk,
            file: file.value,
          );
        }

        ScaffoldMessenger.of(Get.context!).showSnackBar(SnackBar(content: Text("Ubah berhasil")));
        // setViewMode(SampahMode.VIEW);
      } catch (e) {
        log('$e');
      }
    } else {
      try {
        if (isUpload.value) {
          await uploadFileToFirestore(
            database: 'sampah',
            field: 'gambar',
            path: 'file-sampah',
            firestore: firestore,
            uid: dataIndexEdit.value,
            file: file.value,
          );
        }
        await firestore.collection('sampah').doc(dataIndexEdit.value).update({
          'syarat': syaratC.text,
          'jenis': jenisC.text,
          'poin': poinC.text,
        });

        ScaffoldMessenger.of(Get.context!).showSnackBar(SnackBar(content: Text("Ubah berhasil")));
        // setViewMode(SampahMode.VIEW);
      } catch (e) {
        log('$e');
      }
    }
    isUpload.value = false;
    // isLoading.value = false;
  }

  Future getFromGallery({Rxn<File>? file}) async {
    XFile? pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      file!.value = File(pickedFile.path);
      log(base.basename(file.value!.path));
      return pickedFile;
    } else {
      // JIKA USER CANCEL UPLOAD
      return;
    }
  }

  Future getFromCamera({Rxn<File>? file}) async {
    XFile? pickedFile = await ImagePicker().pickImage(source: ImageSource.camera);
    if (pickedFile != null) {
      file!.value = File(pickedFile.path);
      log(base.basename(file.value!.path));
      return pickedFile;
    } else {
      // JIKA USER CANCEL UPLOAD
      return;
    }
  }

  Future<void> uploadFileToFirestore({String? uid, String? path, File? file, FirebaseFirestore? firestore, String? database, String? field}) async {
    String fileName = 'SAMPAH - ${DateTime.now()}';
    Reference storageReference = FirebaseStorage.instance.ref().child('$path/$fileName');
    UploadTask uploadTask = storageReference.putFile(file!);
    TaskSnapshot storageSnapshot = await uploadTask.whenComplete(() {});
    String downloadUrl = await storageSnapshot.ref.getDownloadURL();
    log("DOWNLOAD :: $downloadUrl");
    // Data telah berhasil diunggah ke Firestore
    await firestore!.collection('$database').doc(uid).update({'$field': downloadUrl});
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
                              onTap: () async {
                                Get.back();
                                var res = await uploadComponent.getFromCamera(file: file);
                                if (res != null) {
                                  isUpload.value = true;
                                  file.refresh();
                                }
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
                              onTap: () async {
                                Get.back();
                                var res = await uploadComponent.getFromGallery(
                                  file: file,
                                );
                                if (res != null) {
                                  isUpload.value = true;
                                }
                                file.refresh();
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
}
