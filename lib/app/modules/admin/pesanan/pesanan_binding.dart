import 'package:get/get.dart';
import 'package:rumah_sampah_t_a/app/modules/admin/pesanan/pesanan_controller.dart';


class PesananBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PesananController>(
      () => PesananController(),
    );
  }
}
