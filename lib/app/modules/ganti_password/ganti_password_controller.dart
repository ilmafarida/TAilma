// ignore_for_file: use_build_context_synchronously

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:rumah_sampah_t_a/app/controllers/auth_controller.dart';
import 'package:rumah_sampah_t_a/app/routes/app_pages.dart';
import 'package:rumah_sampah_t_a/app/utils/utils.dart';

enum TypePasswordViewMode { FORM, SUCCESS }

class GantiPasswordController extends GetxController {
  var authC = Get.find<AuthController>();
  var passC = TextEditingController();
  var passConfirmC = TextEditingController();
  var isPassHidden = true.obs;
  var isPassConfirmHidden = true.obs;
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  var typePassword = TypePasswordViewMode.FORM.obs;

  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onClose() {
    super.onClose();
  }

  void submitForm(BuildContext context) async {
    try {
      if (passC.text.isNotEmpty && passConfirmC.text.isNotEmpty) {
        if (passC.text.length < 6 || passConfirmC.text.length < 6) {
          Utils.showNotif(TypeNotif.ERROR, 'Password kurang dari 6');
          return;
        }
        if (passC.text != passConfirmC.text) {
          Utils.showNotif(TypeNotif.ERROR, 'Password tidak sama');
          return;
        }

        print(authC.currentUser!.uid);
        authC.auth.currentUser!.updatePassword(passC.text);
        typePassword.value = TypePasswordViewMode.SUCCESS;
        Utils.showNotif(TypeNotif.ERROR, 'Password berhasil diubah');
        firestore.collection("user").doc(authC.currentUser!.uid).update({"password": passC.text});

        // Navigator.push(context, MaterialPageRoute(builder: (context) =>  Lo()));
      } else {
        Utils.showNotif(TypeNotif.ERROR, 'Ada field yang belum diisi');
      }
    } catch (e) {
      print(e);
    }
  }
}
