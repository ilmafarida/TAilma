import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rumah_sampah_t_a/app/controllers/auth_controller.dart';

class UbahAlamatController extends GetxController {
  var authC = Get.find<AuthController>();
  var loading = false.obs;
  var kecamatanC = TextEditingController();
  var kelurahanC = TextEditingController();
  var alamatC = TextEditingController();
  int? idKecamatan;
  int? idKelurahan;

  var listKecamatan = [
    "Kartoharjo",
    "Manguharjo",
    "Taman",
  ];
  var listKelurahan = [
    "Kanigoro",
    "Kelun",
    "Kartoharjo",
    "Klegen",
    "Oro-Oro Ombo",
    "Pilangbango",
    "Rejomulyo",
    "Sukosari",
    "Tawangrejo",
    "Madiun Lor",
    "Manguharjo",
    "Nambangan Lor",
    "Nambangan Kidul",
    "Ngegong",
    "Pangongangan",
    "Patihan",
    "Sogaten",
    "Winongo",
    "Banjarejo",
    "Demangan",
    "Josenan",
    "Kejuron",
    "Kuncen",
    "Mojorejo",
    "Manisrejo",
    "Pandean",
    "Taman"
  ];

  @override
  void onInit() {
    super.onInit();
    kecamatanC.text = authC.userData.kecamatan.toString();
    if (listKecamatan.contains(kecamatanC.text)) idKecamatan = listKecamatan.indexOf(kecamatanC.text);
    kelurahanC.text = authC.userData.kelurahan.toString();
    if (listKelurahan.contains(kelurahanC.text)) idKelurahan = listKelurahan.indexOf(kelurahanC.text);
    alamatC.text = authC.userData.alamat.toString();
  }

  @override
  void onClose() {
    super.onClose();
  }

  void submit() {}

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
