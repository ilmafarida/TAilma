import 'package:get/get.dart';

import 'ubah_alamat_controller.dart';

class UbahAlamatBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<UbahAlamatController>(
      () => UbahAlamatController(),
    );
  }
}
