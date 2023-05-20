import 'package:get/get.dart';

import 'produk_controller.dart';

class ProdukBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ProdukController>(
      () => ProdukController(),
    );
  }
}
