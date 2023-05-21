import 'package:get/get.dart';

import 'lupa_password_controller.dart';

class LupaPasswordBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<LupaPasswordController>(
      () => LupaPasswordController(),
    );
  }
}
