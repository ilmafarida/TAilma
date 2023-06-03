import 'package:get/get.dart';
import 'package:rumah_sampah_t_a/app/modules/ganti_password/ganti_password_controller.dart';

class GantiPasswordBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<GantiPasswordController>(
      () => GantiPasswordController(),
    );
  }
}
