import 'package:get/get.dart';

import 'tukarsampah_controller.dart';

class TukarSampahBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<TukarSampahController>(
      () => TukarSampahController(),
    );
  }
}
