import 'package:get/get.dart';
import 'package:rumah_sampah_t_a/app/modules/antrian/antrian_controller.dart';
import 'package:rumah_sampah_t_a/app/modules/keranjang/keranjang_controller.dart';

class AntrianBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AntrianController>(
      () => AntrianController(),
    );
  }
}
