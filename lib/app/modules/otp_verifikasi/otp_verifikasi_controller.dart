// ignore_for_file: use_build_context_synchronously

import 'package:email_otp/email_otp.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:rumah_sampah_t_a/app/routes/app_pages.dart';

class OtpVerifikasiController extends GetxController {
  RxList<TextEditingController> otpController = [
    TextEditingController(),
    TextEditingController(),
    TextEditingController(),
    TextEditingController(),
    TextEditingController(),
    TextEditingController(),
  ].obs;

  RxList<FocusNode> otpFocusNode = [
    FocusNode(),
    FocusNode(),
    FocusNode(),
    FocusNode(),
    FocusNode(),
    FocusNode(),
  ].obs;
  int otpLength = 6;
  var errorOtp = false.obs;
  EmailOTP? myAuth;

  FirebaseAuth auth = FirebaseAuth.instance;
  @override
  void onInit() {
    super.onInit();
    myAuth = Get.arguments;
  }

  @override
  void onClose() {
    super.onClose();
  }

  void submitOtp(BuildContext context) async {
    try {
      if (await myAuth!.verifyOTP(otp: otpController[0].text + otpController[1].text + otpController[2].text + otpController[3].text + otpController[4].text + otpController[5].text) == true) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text("OTP is verified"),
        ));
        Get.offNamed(Routes.LOGIN);
        // Navigator.push(context, MaterialPageRoute(builder: (context) =>  Lo()));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text("Invalid OTP"),
        ));
      }
    } catch (e) {}
  }
}
