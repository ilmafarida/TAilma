import 'package:get/get.dart';
import 'package:rumah_sampah_t_a/app/modules/admin/product/product_controller.dart';

import 'sampah_controller.dart';

class AdminSampahBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AdminSampahController>(
      () => AdminSampahController(),
    );
  }
}
