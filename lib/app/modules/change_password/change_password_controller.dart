import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rumah_sampah_t_a/app/controllers/auth_controller.dart';
import 'package:rumah_sampah_t_a/app/utils/utils.dart';

import '../../routes/app_pages.dart';

class ChangePasswordController extends GetxController {
  var authC = Get.find<AuthController>();
  var passC = TextEditingController();
  var isPassHidden = true.obs;
  var passNewC = TextEditingController();
  var isPassNewHidden = true.obs;

  @override
  void onInit() {
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

  submit() async {
    try {
      if (passC.text.isEmpty || passNewC.text.isEmpty) {
        ScaffoldMessenger.of(Get.context!)
            .showSnackBar(SnackBar(content: Text("Field harus diisi")));
      } else if (passC.text != passNewC.text) {
        ScaffoldMessenger.of(Get.context!)
            .showSnackBar(SnackBar(content: Text("Password tidak sama")));
      }
      await authC.auth.currentUser!.updatePassword(passNewC.text).then((value) {
        Get.offNamed(Routes.LOGIN);
        Utils.showNotif(TypeNotif.SUKSES, 'Password telah diperbarui');
      });
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        ScaffoldMessenger.of(Get.context!)
            .showSnackBar(SnackBar(content: Text("Password kurang dari 6")));
      } else if (e.code == 'requires-recent-login') {
        ScaffoldMessenger.of(Get.context!).showSnackBar(
            SnackBar(content: Text("User harus login terlebih dahulu")));
      }
    } catch (e) {
      ScaffoldMessenger.of(Get.context!)
          .showSnackBar(SnackBar(content: Text("Kesalahan server")));
    }
  }
}
