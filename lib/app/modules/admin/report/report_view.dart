import 'dart:developer';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:rumah_sampah_t_a/app/modules/admin/pesanan/pesanan_controller.dart';
import 'package:rumah_sampah_t_a/app/modules/admin/report/report_controller.dart';
import 'package:rumah_sampah_t_a/app/utils/list_color.dart';
import 'package:rumah_sampah_t_a/app/utils/list_text_style.dart';
import 'package:rumah_sampah_t_a/app/utils/utils.dart';
import 'package:rumah_sampah_t_a/app/widgets/custom_submit_button.dart';
import 'package:rumah_sampah_t_a/app/widgets/display_maps.dart';

class ReportView extends GetView<ReportController> {
  @override
  Widget build(BuildContext context) {
    return Material(
      child: Obx(() {
        if (controller.reportUserMode.value == ReportUserMode.LIST) {
          return Scaffold(
            backgroundColor: Colors.white,
            appBar: AppBar(
              title: Text(
                'Report',
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
            body: Padding(
              padding: EdgeInsets.only(top: 28.0),
              child: Obx(
                () {
                  if (controller.laporanPesanan.isEmpty) {
                    return Center(
                      child: Text('Tidak ada pesanan.'),
                    );
                  }
                  return ListView.separated(
                    itemCount: controller.laporanPesanan.length,
                    separatorBuilder: (context, index) => SizedBox(height: 8),
                    itemBuilder: (context, index) {
                      String bulan = controller.laporanPesanan.keys.toList()[index];
                      List<DocumentSnapshot> pesananBulan = controller.laporanPesanan[bulan]!;

                      return GestureDetector(
                        onTap: () {
                          controller.reportUserMode.value = ReportUserMode.DETAIL;
                          // controller.indexBulanDetail.value = bulan;
                          // log('$pesananBulan');
                          controller.detailPesanan = pesananBulan;
                        },
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
                                bulan,
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
                      );
                    },
                  );
                },
              ),
            ),
          );
        } else if (controller.reportUserMode.value == ReportUserMode.DETAIL) {
          return SafeArea(
            child: Scaffold(
                appBar: AppBar(
                  elevation: 0,
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.black,
                  leading: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: () => controller.reportUserMode.value = ReportUserMode.LIST,
                      // onTap: () {},
                      child: Icon(Icons.arrow_back_ios_outlined),
                    ),
                  ),
                ),
                backgroundColor: Colors.white,
                body: Padding(
                  padding: EdgeInsets.only(top: 20.0),
                  child: Column(
                    children: [
                      _widgetDetail(index: 0, text: 'Produk Terjual'),
                      _widgetDetail(index: 1, text: 'Sampah Masuk'),
                      _widgetDetail(index: 2, text: 'Pembayaran'),
                    ],
                  ),
                )),
          );
        } else {
          print(controller.indexDataDetail.value);
          // if (controller.indexDataDetail.value == 0) {
          //   for (var element in controller.detailPesanan) {
              
          //   }
          // }
          return SafeArea(
            child: Scaffold(
              appBar: AppBar(
                elevation: 0,
                backgroundColor: Colors.white,
                foregroundColor: Colors.black,
                leading: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: () => controller.reportUserMode.value = ReportUserMode.DETAIL,
                    // onTap: () {},
                    child: Icon(Icons.arrow_back_ios_outlined),
                  ),
                ),
              ),
              backgroundColor: Colors.white,
              // if (controller.indexDataDetail.value == 0) ...[],
              body: Padding(
                padding: EdgeInsets.all(30.0),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Text(
                          'Total Produk',
                          style: ListTextStyle.textStyleBlack,
                        ),
                        Spacer(),
                        Text(
                          '${controller.detailPesanan.length}',
                          style: ListTextStyle.textStyleBlack,
                        ),
                      ],
                    ),
                    Expanded(
                      child: ListView.builder(
                        itemCount: controller.detailPesanan.length,
                        itemBuilder: (context, index) {
                          DocumentSnapshot pesananDoc = controller.detailPesanan[index];

                          return Column(
                            children: [
                              Text('ID Pesanan: ${(pesananDoc.data() as Map<String, dynamic>)['tanggal']}'),
                            ],
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }
      }),
    );
  }

  Widget _widgetDetail({
    int? index,
    String? text,
  }) {
    return GestureDetector(
      onTap: () {
        controller.reportUserMode.value = ReportUserMode.DETAIL_DATA;
        controller.indexDataDetail.value = index!;
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
