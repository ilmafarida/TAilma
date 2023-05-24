import 'package:get/get.dart';
import 'package:rumah_sampah_t_a/app/modules/admin/product/product_controller.dart';

class AdminProductBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AdminProductController>(
      () => AdminProductController(),
    );
  }
}
