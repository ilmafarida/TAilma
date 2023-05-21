import 'package:get/get.dart';
import 'package:rumah_sampah_t_a/app/modules/change_password/change_password_controller.dart';

class ChangePasswordBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ChangePasswordController>(
      () => ChangePasswordController(),
    );
  }
}
