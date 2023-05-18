import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:rumah_sampah_t_a/app/modules/home/controllers/home_controller.dart';
import 'package:rumah_sampah_t_a/app/routes/app_pages.dart';
import 'package:rumah_sampah_t_a/app/modules/login/views/login_view.dart';

class LoginController extends GetxController {
  var isPasswordHidden = true.obs;

  TextEditingController emailC = TextEditingController(text: ('aa@gmail.com'));
  TextEditingController passwordC = TextEditingController(text: ('123456'));

  FirebaseAuth auth = FirebaseAuth.instance;

  // @override
  // void onClose() {
  //   emailC.dispose();
  //   passwordC.dispose();
  //   super.onClose();
  // }

  void login() async {
    if (emailC.text.isNotEmpty && passwordC.text.isNotEmpty) {
      try {
        UserCredential userCredential = await auth.signInWithEmailAndPassword(
          email: emailC.text,
          password: passwordC.text,
        );
        //print("log = {$userCredential}");
        Get.offAllNamed(Routes.DASHBOARD);
        // if (userCredential.user != null) {
        //   Get.offAllNamed(Routes.DASHBOARD);
        // }
      } on FirebaseAuthException catch (e) {
        if (e.code == 'user-not-found') {
          Get.defaultDialog(
              title: "Terjadi Kesalahan", middleText: "Email tidak terdaftar");
        } else if (e.code == 'wrong-password') {
          Get.defaultDialog(
              title: "Terjadi Kesalahan", middleText: "Password salah");
        } 
      } catch (e) {
        print("error {$e}");
        Get.defaultDialog(
            title: "Terjadi Kesalahan", middleText: "Tidak dapat login");
      }
    } else {
      Get.defaultDialog(
          title: "Terjadi Kesalahan",
          middleText: "Email dan password harus diisi");
    }
  }
}
