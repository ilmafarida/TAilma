import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rumah_sampah_t_a/app/modules/admin/report/report_controller.dart';
import 'package:rumah_sampah_t_a/app/utils/chart_display.dart';
import 'package:rumah_sampah_t_a/app/utils/list_color.dart';
import 'package:rumah_sampah_t_a/app/utils/list_text_style.dart';
import 'package:charts_flutter/flutter.dart' as charts;

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
          body: Obx(
            () {
              if (controller.laporanPesanan.isEmpty && controller.laporanPesananByBulan.isEmpty) {
                return Center(
                  child: Text('Tidak ada pesanan.'),
                );
              }
              return SizedBox(
                height: Get.height,
                child: SingleChildScrollView(
                  padding: EdgeInsets.all(16),
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
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Produk Terjual', style: ListTextStyle.textStyleBlackW700),
                            Expanded(
                              child: controller.buildBarChart(controller.laporanProdukSeriesList as List<Map<String, dynamic>>, 'Produk Terjual'),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        height: 300,
                        margin: EdgeInsets.only(top: 20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Sampah Masuk', style: ListTextStyle.textStyleBlackW700),
                            Expanded(
                              child: controller.buildBarChart(controller.laporanSampahSeriesList as List<Map<String, dynamic>>, 'Sampah Masuk'),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
