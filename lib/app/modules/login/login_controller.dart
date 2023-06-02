import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:rumah_sampah_t_a/app/controllers/auth_controller.dart';
import 'package:rumah_sampah_t_a/app/routes/app_pages.dart';
import 'package:rumah_sampah_t_a/app/utils/shared_preference.dart';
import 'package:rumah_sampah_t_a/models/user_data_model.dart';

class LoginController extends GetxController {
  var isPasswordHidden = true.obs;
  TextEditingController emailC = TextEditingController();
  TextEditingController passwordC = TextEditingController();

  var authC = Get.find<AuthController>();
  @override
  void onClose() {
    emailC.dispose();
    passwordC.dispose();
    super.onClose();
  }

  void login() async {
    if (emailC.text.isNotEmpty && passwordC.text.isNotEmpty) {
      try {
        UserCredential userCredential = await authC.auth.signInWithEmailAndPassword(
          email: emailC.text,
          password: passwordC.text,
        );
        print('${userCredential.user?.uid}');
        DocumentSnapshot? snapshot = await FirebaseFirestore.instance.collection('user').doc(userCredential.user?.uid).get();
        if (snapshot.exists) {
          authC.userData = UserData.fromSnapshot(snapshot);
          await SharedPreference.setUserId(authC.userData.uid!);
          if (authC.userData.role == 'user') {
            await SharedPreference.setRoleUser(authC.userData.role!);
            if (authC.userData.status != '-1') {
              Get.offAllNamed(Routes.HOME);
            } else {
              Get.offAllNamed(Routes.WAITING);
            }
          } else if (authC.userData.role == 'admin') {
            await SharedPreference.setRoleUser('admin');
            Get.offAllNamed(Routes.DASHBOARD);
          }
        } else {
          Get.offAllNamed(Routes.WELCOME);
        }
      } on FirebaseAuthException catch (e) {
        if (e.code == 'user-not-found') {
          Get.defaultDialog(title: "Terjadi Kesalahan", middleText: "Email tidak terdaftar");
        } else if (e.code == 'wrong-password') {
          Get.defaultDialog(title: "Terjadi Kesalahan", middleText: "Password salah");
        }
      } catch (e) {
        print("error {$e}");
        Get.defaultDialog(title: "Terjadi Kesalahan", middleText: "Tidak dapat login");
      }
    } else {
      Get.defaultDialog(title: "Terjadi Kesalahan", middleText: "Email dan password harus diisi");
    }
  }
}
