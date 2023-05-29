// ignore_for_file: prefer_const_constructors
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:rumah_sampah_t_a/app/controllers/auth_controller.dart';
import 'package:rumah_sampah_t_a/app/routes/app_pages.dart';

class LupaPasswordController extends GetxController {
  var authC = Get.find<AuthController>();
  var isPasswordHidden = true.obs;
  var codeOtp = RxnString();
  TextEditingController noHpC = TextEditingController(text: '+62');

  var loading = false.obs;

  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onClose() {
    noHpC.dispose();
    super.onClose();
  }

  void sendOtpCode(BuildContext context, String? phoneNumber) async {
    if (noHpC.text.isNotEmpty) {
      try {
        await authC.auth.verifyPhoneNumber(
          phoneNumber: phoneNumber,
          verificationCompleted: (PhoneAuthCredential credential) async {
            // Proses otentikasi selesai secara otomatis (misalnya dengan verifikasi nomor telepon Google)
            // credential dapat digunakan untuk masuk jika otentikasi selesai.
            // contoh:
            // await FirebaseAuth.instance.signInWithCredential(credential);
          },
          verificationFailed: (FirebaseAuthException e) {
            // Kesalahan saat mengirim kode OTP
            print('Kesalahan: ${e.message}');
          
          },
          codeSent: (String verificationId, [int? forceResendingToken]) {
            // Kode OTP terkirim ke nomor telepon yang diberikan
            // Simpan verificationId untuk digunakan saat memverifikasi kode OTP
            print('Kode OTP terkirim $phoneNumber');
            String smsCode = ""; // Kode OTP yang akan dimasukkan oleh pengguna
            // ...
            // OTP telah dikirim ke alamat No Hp pengguna
            Get.toNamed(Routes.OTP_VERIFIKASI);
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Berhasil mengirim OTP ke ${noHpC.text}')));
          },
          codeAutoRetrievalTimeout: (String verificationId) {
            // Waktu habis untuk mengambil kode OTP secara otomatis
            // Gunakan verificationId yang tersimpan untuk memverifikasi kode OTP secara manual
            // contoh:
            // String smsCode = '';
            // PhoneAuthCredential credential = PhoneAuthProvider.credential(verificationId: verificationId, smsCode: smsCode);
            // await FirebaseAuth.instance.signInWithCredential(credential);
          },
        );
      } on FirebaseAuthException catch (e) {
        if (e.code == 'user-not-found') {
          // Get.defaultDialog(title: "Terjadi Kesalahan", middleText: "No Hp tidak terdaftar");
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('No Hp tidak terdaftar')));
        }
        if (e.code == 'invalid-No Hp') {
          // Get.defaultDialog(title: "Terjadi Kesalahan", middleText: "No Hp tidak terdaftar");
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('No Hp tidak valid')));
        }
      } catch (e) {
        print("error {$e}");
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error pada aplikasi kami')));
        // Get.defaultDialog(title: "Terjadi Kesalahan", middleText: "Kesalahan pada aplikasi kami");
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('No Hp harus diisi')));
    }
  }
}
