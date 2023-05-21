// ignore_for_file: prefer_const_constructors

import 'dart:math';

import 'package:email_auth/email_auth.dart';
import 'package:email_otp/email_otp.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:rumah_sampah_t_a/app/controllers/auth_controller.dart';
import 'package:rumah_sampah_t_a/app/routes/app_pages.dart';

class LupaPasswordController extends GetxController {
  var authC = Get.find<AuthController>();
  var isPasswordHidden = true.obs;
  var codeOtp = RxnString();
  TextEditingController emailC = TextEditingController();
  // EmailOTP myauth = EmailOTP();
  EmailAuth emailAuth = EmailAuth(sessionName: 'Rumah Sampah');

  var loading = false.obs;

  @override
  void onInit() {
    super.onInit();
    // myauth.setConfig(
    //   appEmail: "com.ilmahannun.rumah_sampah_t_a",
    //   appName: "rumah_sampah_t_a",
    //   userEmail: emailC.text,
    //   otpLength: 4,
    //   otpType: OTPType.digitsOnly,
    // );
  }

  @override
  void onClose() {
    emailC.dispose();
    super.onClose();
  }

  // Future<void> sendEmailWithCode(BuildContext context) async {
  //   loading.value = true;
  //   if (emailC.text.isNotEmpty) {
  //     try {
  //       if (await myauth.sendOTP() == true) {
  //         ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
  //           content: Text("OTP has been sent"),
  //         ));
  //         print('Email sent: ${emailC.text.toString()}');
  //         Get.toNamed(Routes.OTP_VERIFIKASI, arguments: myauth);
  //       } else {
  //         ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
  //           content: Text("Oops, OTP send failed"),
  //         ));
  //       }
  //       loading.value = false;
  //     } catch (e) {
  //       print('Error sending email: $e');
  //       loading.value = false;
  //     }
  //   } else {
  //     // ScaffoldMessenger.of(Get.context).showSnackBar(SnackBar(content: Text('Email harus diisi')));
  //     loading.value = false;
  //   }
  // }

  void sendOtpCode(BuildContext context) async {
    if (emailC.text.isNotEmpty) {
      try {
        var res = await authC.auth.sendPasswordResetEmail(email: emailC.text);
        // OTP telah dikirim ke alamat email pengguna
        Get.toNamed(Routes.OTP_VERIFIKASI);
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Berhasil mengirim OTP ke ${emailC.text}')));
      } on FirebaseAuthException catch (e) {
        if (e.code == 'user-not-found') {
          // Get.defaultDialog(title: "Terjadi Kesalahan", middleText: "Email tidak terdaftar");
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Email tidak terdaftar')));
        }
        if (e.code == 'invalid-email') {
          // Get.defaultDialog(title: "Terjadi Kesalahan", middleText: "Email tidak terdaftar");
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Email tidak valid')));
        }
      } catch (e) {
        print("error {$e}");
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error pada aplikasi kami')));
        // Get.defaultDialog(title: "Terjadi Kesalahan", middleText: "Kesalahan pada aplikasi kami");
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Email harus diisi')));
      // Get.defaultDialog(title: "Terjadi Kesalahan", middleText: "Email harus diisi");
    }
  }
  // void sendOtpCode(BuildContext context) async {
  //   if (emailC.text.isNotEmpty) {
  //     try {
  //       var res = await emailAuth.sendOtp(recipientMail: emailC.text,otpLength: 4);
  //       if (res) {
  //         // OTP telah dikirim ke alamat email pengguna
  //         Get.toNamed(Routes.OTP_VERIFIKASI);
  //         ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Berhasil mengirim OTP ke ${emailC.text}')));
  //       } else {
  //         ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Gagal mengirim OTP ke ${emailC.text}')));
  //       }
  //     } on FirebaseAuthException catch (e) {
  //       if (e.code == 'user-not-found') {
  //         // Get.defaultDialog(title: "Terjadi Kesalahan", middleText: "Email tidak terdaftar");
  //         ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Email tidak terdaftar')));
  //       }
  //     } catch (e) {
  //       print("error {$e}");
  //       ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error pada aplikasi kami')));
  //       // Get.defaultDialog(title: "Terjadi Kesalahan", middleText: "Kesalahan pada aplikasi kami");
  //     }
  //   } else {
  //     ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Email harus diisi')));
  //     // Get.defaultDialog(title: "Terjadi Kesalahan", middleText: "Email harus diisi");
  //   }
  // }
}
