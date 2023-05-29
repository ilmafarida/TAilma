import 'package:get/get.dart';
import 'package:rumah_sampah_t_a/app/modules/keranjang/keranjang_controller.dart';


class KeranjangBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<KeranjangController>(
      () => KeranjangController(),
    );
  }
}
