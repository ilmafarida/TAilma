import 'package:get/get.dart';

import 'tukarsampah_controller.dart';

class TukarsampahBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<TukarsampahController>(
      () => TukarsampahController(),
    );
  }
}
