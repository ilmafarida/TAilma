// ignore_for_file: prefer_const_constructors
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:rumah_sampah_t_a/app/controllers/auth_controller.dart';
import 'package:rumah_sampah_t_a/app/routes/app_pages.dart';
import 'package:rumah_sampah_t_a/app/utils/utils.dart';

enum TypeOtpMode { SEND, VERIFY }

class LupaPasswordController extends GetxController {
  var authC = Get.find<AuthController>();
  var isPasswordHidden = true.obs;
  var codeOtp = RxnString();
  TextEditingController emailC = TextEditingController();
  var typeOtp = TypeOtpMode.SEND.obs;

  var loading = false.obs;
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

  var idVerif = ''.obs;

  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onClose() {
    emailC.dispose();
    super.onClose();
  }

  // Future<void> verifyPhoneNumber(String? numberPhone) async {
  //   print(idVerif.value);
  //   // await FirebaseAuth.instance.verifyPhoneNumber(
  //   //   phoneNumber: '+44 7123 123 456',
  //   //   verificationCompleted: (PhoneAuthCredential credential) {},
  //   //   verificationFailed: (FirebaseAuthException e) {},
  //   //   codeSent: (String verificationId, int? resendToken) {},
  //   //   codeAutoRetrievalTimeout: (String verificationId) {},
  //   // );

  //   await authC.auth.verifyPhoneNumber(
  //     phoneNumber: numberPhone,
  //     verificationCompleted: (PhoneAuthCredential credential) async {
  //       await authC.auth.signInWithCredential(credential);
  //       print('Verifikasi otomatis berhasil');
  //     },
  //     verificationFailed: (FirebaseAuthException e) {
  //       print('Verifikasi otomatis gagal: ${e.message}');
  //     },
  //     codeSent: (String verificationId, int? resendToken) async {
  //       print('Kode verifikasi terkirim ke nomor telepon');
  //       idVerif.value = verificationId;
  //       typeOtp.value = TypeOtpMode.VERIFY;
  //       Utils.showNotif(TypeNotif.SUKSES, 'Berhasil mengirim kode ke$numberPhone');
  //     },
  //     codeAutoRetrievalTimeout: (verificationId) {
  //       idVerif.value = verificationId;
  //     },
  //   );
  // }

  Future<void> sendLinkToEmail(String? email) async {
    print(idVerif.value);
    await authC.auth.sendPasswordResetEmail(email: email!).then((value) {
      // Berhasil mengirim email reset password
      // Tampilkan pesan sukses atau arahkan pengguna ke halaman informasi reset password
      Utils.showNotif(TypeNotif.SUKSES, 'Berhasil mengirimkan link ke email $email');
      Get.offNamed(Routes.LOGIN);
    }).catchError((error) {
      // Gagal mengirim email reset password
      // Tampilkan pesan error atau arahkan pengguna ke halaman informasi kesalahan
      Utils.showNotif(TypeNotif.ERROR, 'Gagal mengirimkan link ke email $email');
    });
  }

  Future<void> verifyCode() async {
    if (otpController.length == 6) {
      String code = otpController[0].text + otpController[1].text + otpController[2].text + otpController[3].text + otpController[4].text + otpController[5].text;
      PhoneAuthCredential credential = PhoneAuthProvider.credential(verificationId: idVerif.value, smsCode: code);

      try {
        await authC.auth.signInWithCredential(credential);
        Get.offNamed(Routes.GANTI_PASSWORD);
        print('Verifikasi kode berhasil');
      } catch (e) {
        print('Verifikasi kode gagal: $e');
        Utils.showNotif(TypeNotif.ERROR, 'Kode salah');
      }
    }
  }
}
