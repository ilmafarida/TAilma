import 'package:get/get.dart';

import '../controllers/akun_terverifikasi_controller.dart';

class AkunTerverifikasiBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AkunTerverifikasiController>(
      () => AkunTerverifikasiController(),
    );
  }
}
