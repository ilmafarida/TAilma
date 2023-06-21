import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rumah_sampah_t_a/app/controllers/auth_controller.dart';

enum ViewMode { VIEW, EDIT }

class AkunTerverifikasiController extends GetxController {
  var authC = Get.find<AuthController>();
  Rx<ViewMode> viewMode = ViewMode.VIEW.obs;
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  Stream<QuerySnapshot>? stream;
  var dataEdit = Rxn();

  void setViewMode(ViewMode mode) {
    viewMode.value = mode;
  }

  @override
  void onInit() {
    setViewMode(ViewMode.VIEW);
    fetchData();
    super.onInit();
  }

  Stream<QuerySnapshot<Map<String, dynamic>>?> fetchData() async* {
    try {
      yield* FirebaseFirestore.instance.collection('user').snapshots();
    } catch (e) {
      print('Error: $e');
    }
  }

  previewFile(BuildContext context, String file) {
    showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          content: Stack(
            children: [
              SizedBox(
                child: Image.network(
                  file,
                  fit: BoxFit.contain,
                ),
              ),
              GestureDetector(
                onTap: () => Navigator.pop(context),
                child: Padding(
                  padding: const EdgeInsets.all(3.0),
                  child: Container(
                    decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.5),
                        shape: BoxShape.circle),
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
          clipBehavior: Clip.none,
        );
      },
    );
  }
}
