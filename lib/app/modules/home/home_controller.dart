import 'dart:developer';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rumah_sampah_t_a/app/controllers/auth_controller.dart';
import 'package:rumah_sampah_t_a/app/utils/list_color.dart';
import 'package:rumah_sampah_t_a/app/utils/list_text_style.dart';
import 'package:rumah_sampah_t_a/app/utils/shared_preference.dart';
import 'package:rumah_sampah_t_a/app/utils/utils.dart';
import 'package:rumah_sampah_t_a/app/widgets/upload_component.dart';

enum HomeMode { USER, ADMIN, EDIT }

class HomeController extends GetxController {
  var authC = Get.find<AuthController>();
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  Rx<HomeMode> homeMode = HomeMode.USER.obs;
  var quoteC = TextEditingController();
  var deskripsiC = TextEditingController();
  var fileC = Rxn<File>();
  UploadComponent uploadComponent = UploadComponent();

  var selectedTab = 0.obs;

  var isUpdate = false.obs;
  var isLoading = false.obs;

  @override
  Future<void> onInit() async {
    var role = await SharedPreference.getUserRole();
    if (role != 'user') {
      setViewMode(HomeMode.ADMIN);
    }
    fetchData();
    super.onInit();
  }

  @override
  void onClose() {
    super.onClose();
  }

  void setViewMode(HomeMode mode) {
    homeMode.value = mode;
  }

  Stream<DocumentSnapshot<Object?>>? fetchData() async* {
    yield* firestore.collection('dashboard').doc('data').snapshots();
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
                                var res = await uploadComponent.getFromCamera(file: fileC);
                                if (res != null) {
                                  isUpdate.value = true;
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
                                var res = await uploadComponent.getFromGallery(file: fileC);
                                if (res != null) {
                                  isUpdate.value = true;
                                }
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

  Future<void> submit() async {
    isLoading.value = true;
    try {
      if (isUpdate.value) {
        await uploadComponent.uploadFileToFirestore(
          database: 'dashboard',
          field: 'image',
          path: 'file-dashboard',
          firestore: firestore,
          uid: 'data',
          file: fileC.value,
        );
      }
      await firestore.collection("dashboard").doc('data').update({
        "quote": quoteC.text,
        "deskripsi": deskripsiC.text,
      });
    } catch (e) {
      log('ERROR :: $e');
    }
    setViewMode(HomeMode.ADMIN);
    isUpdate.value = false;
    isLoading.value = false;
  }
}
