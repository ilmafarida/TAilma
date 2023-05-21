import 'package:get/get.dart';
import 'package:rumah_sampah_t_a/app/modules/otp_verifikasi/otp_verifikasi_controller.dart';

class OtpVerifikasiBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<OtpVerifikasiController>(
      () => OtpVerifikasiController(),
    );
  }
}
