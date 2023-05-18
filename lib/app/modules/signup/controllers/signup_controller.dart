import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import '../../../routes/app_pages.dart';

class SignupController extends GetxController {
  TextEditingController emailC = TextEditingController();
  TextEditingController passwordC = TextEditingController();
  TextEditingController fullnameC = TextEditingController();
  TextEditingController kecamatanC = TextEditingController();
  TextEditingController kelurahanC = TextEditingController();
  TextEditingController alamatC = TextEditingController();
  TextEditingController ktpC = TextEditingController();

  var isPasswordHidden = true.obs;

  FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  @override
  // void onClose() {
  //   emailC.dispose();
  //   passwordC.dispose();
  //   super.onClose();
  // }
  void Signup() async {
    if (emailC.text.isNotEmpty && passwordC.text.isNotEmpty) {
      try {
        UserCredential userCredential =
            await auth.createUserWithEmailAndPassword(
          email: emailC.text,
          password: passwordC.text,
        );

        if (userCredential.user != null) {
          String? uid = userCredential.user?.uid;

          firestore.collection("user").doc(uid).set({
            "uid": uid,
            "email": emailC.text,
            "password": passwordC.text,
            "fullname": fullnameC.text,
            "kecamatan": kecamatanC.text,
            "kelurahan": kelurahanC.text,
            "alamat": alamatC.text,
            "ktp": ktpC.text
          });
        }

        //print(userCredential);

        Get.offAllNamed(Routes.WAITING);
      } on FirebaseAuthException catch (e) {
        if (e.code == 'weak-password') {
          Get.defaultDialog(
              title: "Terjadi Kesalahan",
              middleText: "Password lemah, minimal 6 karakter");
        } else if (e.code == 'email-already-in-use') {
          Get.defaultDialog(
              title: "Terjadi Kesalahan", middleText: "Email sudah digunakan");
        }
      } catch (e) {
        Get.defaultDialog(
            title: "Terjadi Kesalahan", middleText: "Tidak dapat mendaftar");
      }
    } else {
      Get.defaultDialog(
          title: "Terjadi Kesalahan",
          middleText: "Email dan password wajib diisi");
    }
  }
}
