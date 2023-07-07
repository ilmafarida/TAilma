import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rumah_sampah_t_a/app/modules/admin/report/report_controller.dart';
import 'package:rumah_sampah_t_a/app/utils/chart_display.dart';
import 'package:rumah_sampah_t_a/app/utils/list_color.dart';
import 'package:rumah_sampah_t_a/app/utils/list_text_style.dart';
import 'package:rumah_sampah_t_a/app/utils/utils.dart';

class ReportView extends GetView<ReportController> {
  @override
  Widget build(BuildContext context) {
    return Material(
      child: Obx(
        () => Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            title: Text(
              'Report' ' ${controller.selectedValue.value != "Semua" ? controller.selectedValue.value : ""}',
              style: ListTextStyle.textStyleBlackW700.copyWith(fontSize: 24),
            ),
            centerTitle: true,
            elevation: 0,
            backgroundColor: Colors.white,
            foregroundColor: Colors.black,
            leading: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () => Get.back(),
                child: Icon(Icons.arrow_back_ios_outlined),
              ),
            ),
          ),
          body: RefreshIndicator(
            onRefresh: () => controller.onRefresh(),
            child: Obx(
              () {
                if (controller.laporanPesanan.isEmpty && controller.laporanPesananByBulan.isEmpty) {
                  return Center(
                    child: Text('Tidak ada pesanan.'),
                  );
                }

                return SingleChildScrollView(
                  padding: EdgeInsets.all(16),
                  child: SizedBox(
                    height: Get.height,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // TODO : IMPLEMENTASI DROPDOWN
                        Align(
                          alignment: Alignment.centerRight,
                          child: Container(
                            constraints: BoxConstraints(maxWidth: 120),
                            decoration: BoxDecoration(
                              color: Color(ListColor.colorButtonGreen),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            padding: EdgeInsets.symmetric(horizontal: 10),
                            child: DropdownButtonFormField(
                              alignment: Alignment.center,
                              style: ListTextStyle.textStyleWhite,
                              dropdownColor: Color(ListColor.colorButtonGreen),
                              decoration: InputDecoration(border: InputBorder.none),
                              value: controller.laporanPesananByBulan.keys.first,
                              // value: controller.selectedValue,
                              // items: List.generate(
                              //   controller.laporanPesananByBulan.length,
                              //   (index) {
                              //     final item = controller.laporanPesananByBulan[index];
                              //     print(item);
                              //    ) return DropdownMenuItem<Map<String, dynamic>>(
                              //       value: item,
                              //       child: Text('$item'), // Menggunakan kunci (keys) sebagai teks item
                              //     );
                              //   },
                              // ),
                              items: controller.laporanPesananByBulan.keys.map<DropdownMenuItem<String>>((key) {
                                return DropdownMenuItem<String>(
                                  value: key,
                                  child: Text('$key'),
                                );
                              }).toList(),
                              onChanged: (str) {
                                controller.selectedValue.value = str.toString();
                                print(str);
                              },
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 300,
                          child: ChartContainer(title: 'Produk Dijual', chart: controller.laporanPesananByBulan.values.first),
                        )

                        // ListView.separated(
                        //   shrinkWrap: true,
                        //   itemCount: controller.laporanPesanan.length,
                        //   separatorBuilder: (context, index) => SizedBox(height: 8),
                        //   itemBuilder: (context, index) {
                        //     String bulan = controller.laporanPesanan.keys.toList()[index];
                        //     List<DocumentSnapshot> pesananBulan = controller.laporanPesanan[bulan]!;
                        //     return GestureDetector(
                        //       onTap: () {
                        //         controller.detailPesanan.clear();
                        //         controller.detailPesanan.value = pesananBulan;
                        //         controller.reportUserMode.value = ReportUserMode.DETAIL;
                        //       },
                        //       child: Container(
                        //         width: Get.width,
                        //         margin: EdgeInsets.symmetric(horizontal: 22),
                        //         padding: EdgeInsets.symmetric(horizontal: 17, vertical: 10),
                        //         decoration: BoxDecoration(
                        //           color: Color(ListColor.colorBackgroundGray),
                        //           borderRadius: BorderRadius.circular(10),
                        //         ),
                        //         child: Row(
                        //           crossAxisAlignment: CrossAxisAlignment.center,
                        //           children: [
                        //             Text(
                        //               bulan,
                        //               style: ListTextStyle.textStyleBlackW700.copyWith(fontSize: 18),
                        //             ),
                        //             Spacer(),
                        //             Icon(
                        //               Icons.arrow_forward_ios,
                        //               color: Colors.black,
                        //               size: 15,
                        //             ),
                        //           ],
                        //         ),
                        //       ),
                        //     );
                        //   },
                        // ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget _widgetDetail({
    int? index,
    String? text,
  }) {
    return GestureDetector(
      onTap: () {
        controller.reportUserMode.value = ReportUserMode.ALL;
        controller.indexDataDetail.value = index!;
        controller.getPesananByBulan();
      },
      child: Padding(
        padding: EdgeInsets.only(bottom: 17),
        child: Container(
          width: Get.width,
          margin: EdgeInsets.symmetric(horizontal: 22),
          padding: EdgeInsets.symmetric(horizontal: 17, vertical: 10),
          decoration: BoxDecoration(
            color: Color(ListColor.colorBackgroundGray),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                text!,
                style: ListTextStyle.textStyleBlackW700.copyWith(fontSize: 18),
              ),
              Spacer(),
              Icon(
                Icons.arrow_forward_ios,
                color: Colors.black,
                size: 15,
              ),
            ],
          ),

          // child: ExpansionTile(
          //   title: Text('Bulan: $bulan'),
          //   children: pesananBulan.map((pesananDoc) {
          //     DateTime tanggal = DateFormat("dd-MM-yyyy").parse((pesananDoc.data() as Map<String, dynamic>)['tanggal']);
          //     String formattedDate = controller.formatDate(tanggal);

          //     return ListTile(
          //       title: Text('Tanggal: $formattedDate'),
          //       subtitle: Text('ID Pesanan: ${pesananDoc.id}'),
          //     );
          //   }).toList(),
          // ),
        ),
      ),
    );
  }
}
