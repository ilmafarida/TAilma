import 'package:get/get.dart';
import 'package:rumah_sampah_t_a/app/controllers/auth_controller.dart';

class WaitingController extends GetxController {
  //TODO: Implement WaitingController
  var authC = Get.find<AuthController>();

  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

void onCancel(){
  authC.logout();
}
}
