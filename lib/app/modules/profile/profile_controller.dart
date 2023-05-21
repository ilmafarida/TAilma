import 'package:get/get.dart';
import 'package:rumah_sampah_t_a/app/controllers/auth_controller.dart';
import 'package:rumah_sampah_t_a/app/modules/home/home_controller.dart';

class ProfileController extends GetxController {
  var authC = Get.find<AuthController>();
  var homeC = Get.find<HomeController>();

  final count = 0.obs;
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

  void increment() => count.value++;
}
