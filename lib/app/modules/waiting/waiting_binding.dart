import 'package:get/get.dart';

import 'waiting_controller.dart';

class WaitingBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<WaitingController>(
      () => WaitingController(),
    );
  }
}
