import 'package:get/get.dart';
import 'package:rumah_sampah_t_a/app/modules/profile/profile_controller.dart';

class ProfileBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ProfileController>(
      () => ProfileController(),
    );
  }
}
