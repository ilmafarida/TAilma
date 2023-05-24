import 'package:get/get.dart';
import 'package:rumah_sampah_t_a/app/modules/admin/verifikasi_akun/verifikasi_akun_controller.dart';

class VerifikasiAkunBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<VerifikasiAkunController>(
      () => VerifikasiAkunController(),
    );
  }
}
