import 'package:get/get.dart';
import 'package:rumah_sampah_t_a/app/modules/admin/pesanan/pesanan_controller.dart';
import 'package:rumah_sampah_t_a/app/modules/admin/report/report_controller.dart';

class ReportBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ReportController>(
      () => ReportController(),
    );
  }
}
