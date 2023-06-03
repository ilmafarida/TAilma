import 'package:get/get.dart';
import 'package:rumah_sampah_t_a/app/modules/admin/penukaran/penukaran_controller.dart';

class PenukaranBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PenukaranController>(
      () => PenukaranController(),
    );
  }
}
