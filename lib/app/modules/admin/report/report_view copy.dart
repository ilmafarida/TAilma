import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rumah_sampah_t_a/app/modules/admin/report/report_controller.dart';
import 'package:rumah_sampah_t_a/app/utils/list_color.dart';
import 'package:rumah_sampah_t_a/app/utils/list_text_style.dart';
import 'package:rumah_sampah_t_a/app/utils/utils.dart';

class ReportViewCopy extends GetView<ReportController> {
  @override
  Widget build(BuildContext context) {
    return Material(
      child: Obx(() {
        if (controller.reportUserMode.value == ReportUserMode.ALL) {
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
            body: RefreshIndicator(
              onRefresh: () => controller.onRefresh(),
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
                          controller.detailPesanan.clear();
                          controller.detailPesanan.value = pesananBulan;
                          controller.reportUserMode.value = ReportUserMode.ALL;
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
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          );
        } else if (controller.reportUserMode.value == ReportUserMode.ALL) {
          return SafeArea(
            child: Scaffold(
                appBar: AppBar(
                  elevation: 0,
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.black,
                  leading: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: () => controller.reportUserMode.value = ReportUserMode.ALL,
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
          String? titleReport;
          if (controller.indexDataDetail.value == 0) {
            titleReport = 'Total Produk';
          } else if (controller.indexDataDetail.value == 1) {
            titleReport = 'Total Sampah';
          } else {
            titleReport = 'Total Pembayaran';
          }
          Map<String, int> productReport = {};
          int totalTerjual = 0;
          if (productReport.isNotEmpty) productReport.clear();
          if (controller.indexDataDetail.value == 0) {
            for (var document in controller.detailPesanan) {
              var detailList = document['detail'] as List<dynamic>?;

              if (detailList != null) {
                for (var detail in detailList) {
                  var jenisProduk = detail['jenis'] as String?;
                  var jumlahProduk = int.parse(detail['jumlah']);

                  if (jenisProduk != null) {
                    productReport[jenisProduk] = (productReport[jenisProduk] ?? 0) + jumlahProduk;
                    totalTerjual += jumlahProduk;
                  }
                }
              }
              log('$productReport');
            }
          } else if (controller.indexDataDetail.value == 1) {
            for (var document in controller.detailPesanan) {
              var detailList = document['detail'] as List<dynamic>?;

              if (detailList != null) {
                for (var detail in detailList) {
                  var jenisProduk = detail['jenis'] as String?;
                  var jumlahProduk = int.parse(detail['jumlah']);

                  if (jenisProduk != null) {
                    productReport[jenisProduk] = (productReport[jenisProduk] ?? 0) + jumlahProduk;
                    totalTerjual += jumlahProduk;
                  }
                }
              }
            }
            log('$productReport');
          } else {
            for (var document in controller.detailPesanan) {
              // var detailList = document['detail'] as List<dynamic>?;
              var jenisProduk = document['metode'] as String?;
              var jumlahProduk = int.parse(document['total_harga']);

              if (jenisProduk != null) {
                productReport[jenisProduk] = (productReport[jenisProduk] ?? 0) + jumlahProduk;
                totalTerjual += jumlahProduk;
              }
            }
            log('$productReport');
          }

          return SafeArea(
            child: Scaffold(
              appBar: AppBar(
                elevation: 0,
                backgroundColor: Colors.white,
                foregroundColor: Colors.black,
                leading: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: () => controller.reportUserMode.value = ReportUserMode.ALL,
                    child: Icon(Icons.arrow_back_ios_outlined),
                  ),
                ),
              ),
              backgroundColor: Colors.white,
              // if (controller.indexDataDetail.value == 0) ...[],
              body: RefreshIndicator(
                onRefresh: () => controller.onRefresh(),
                child: Padding(
                  padding: EdgeInsets.all(30.0),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Text(
                            titleReport,
                            style: ListTextStyle.textStyleBlackW700,
                          ),
                          Spacer(),
                          Text(
                            '${controller.indexDataDetail.value == 2 ? Utils.formatUang(totalTerjual.toDouble()) : totalTerjual}',
                            style: ListTextStyle.textStyleBlackW700,
                          ),
                        ],
                      ),
                      Expanded(
                        child: Padding(
                          padding: EdgeInsets.only(top: 10),
                          child: ListView.separated(
                            separatorBuilder: (context, index) => Divider(
                              color: Color(ListColor.colorButtonGreen),
                            ),
                            itemCount: productReport.length,
                            itemBuilder: (BuildContext context, int index) {
                              var produk = productReport.keys.elementAt(index);
                              var jumlahTerjual = productReport.values.elementAt(index);
                              return Row(
                                children: [
                                  Text(
                                    produk,
                                    style: ListTextStyle.textStyleBlack.copyWith(fontSize: 14, fontWeight: FontWeight.w200),
                                  ),
                                  Spacer(),
                                  Text(
                                    '${controller.indexDataDetail.value == 2 ? Utils.formatUang(jumlahTerjual.toDouble()) : jumlahTerjual} ${controller.indexDataDetail.value == 1 ? "Kg" : ""}',
                                    style: ListTextStyle.textStyleBlack.copyWith(fontSize: 14, fontWeight: FontWeight.w200),
                                  ),
                                ],
                              );
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
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
