import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:path/path.dart';
import 'package:rumah_sampah_t_a/app/modules/riwayat/riwayat_controller.dart';
import 'package:rumah_sampah_t_a/app/utils/list_color.dart';
import 'package:rumah_sampah_t_a/app/utils/list_text_style.dart';
import 'package:rumah_sampah_t_a/app/widgets/custom_submit_button.dart';
import 'package:rumah_sampah_t_a/app/widgets/custom_text_field.dart';

class RiwayatView extends GetView<RiwayatController> {
  @override
  Widget build(BuildContext context) {
    return Material(
      child: Obx(() {
        if (controller.riwayatUserMode.value == RiwayatUserMode.LIST) {
          return DefaultTabController(
            length: 5,
            initialIndex: 0,
            child: Scaffold(
              backgroundColor: Colors.white,
              appBar: AppBar(
                title: Text(
                  'Riwayat',
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
                bottom: PreferredSize(
                  preferredSize: Size(double.infinity, 60),
                  child: Container(
                    padding: EdgeInsets.zero,
                    margin: EdgeInsets.symmetric(horizontal: 10),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Color.fromRGBO(86, 159, 0, 0.3),
                    ),
                    child: TabBar(
                      automaticIndicatorColorAdjustment: true,
                      dividerColor: Color(ListColor.colorButtonGreen),
                      labelColor: Colors.black,
                      indicator: BoxDecoration(
                        color: Colors.green.shade400,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      labelPadding: EdgeInsets.zero,
                      onTap: (value) => controller.tabC.value = value + 1,
                      tabs: [
                        _tabContent('Antrian'),
                        _tabContent('Pembayaran'),
                        _tabContent('Proses'),
                        _tabContent('Ditolak'),
                        _tabContent('Selesai'),
                      ],
                    ),
                  ),
                ),
              ),
              body: TabBarView(
                children: [
                  buildTabContent(1),
                  buildTabContent(2),
                  buildTabContent(3),
                  buildTabContent(4),
                  buildTabContent(5),
                ],
              ),
            ),
          );
        } else {
          return SafeArea(
              child: Scaffold(
            appBar: AppBar(
              elevation: 0,
              backgroundColor: Colors.white,
              foregroundColor: Colors.black,
              leading: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () => controller.setViewMode(RiwayatUserMode.LIST),
                  child: Icon(Icons.arrow_back_ios_outlined),
                ),
              ),
            ),
            backgroundColor: Colors.white,
            body: SingleChildScrollView(
              padding: EdgeInsets.all(20),
              child: _detailContent(controller.tabC.value),
            ),
          ));
        }
      }),
    );
  }

  Widget _detailContent(int tab) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: double.infinity,
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.grey.shade200,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _dataCard(title: 'Tanggal Pengiriman', value: controller.dataDetail!['tanggal']),
              _dataCard(title: 'Waktu', value: controller.dataDetail!['jam']),
              _dataCard(title: 'Alamat', value: controller.dataDetail!['alamat']),
              _dataCard(title: 'Informasi', value: controller.dataDetail!['informasi']),
            ],
          ),
        ),
        _detailProduct(),
        if (controller.dataDetail!['jenis'] == "beli") ...[
          if (tab == 2)
            Container(
              padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
              width: double.infinity,
              decoration: BoxDecoration(
                color: Color.fromRGBO(86, 159, 0, 0.3),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Metode Pembayaran', style: ListTextStyle.textStyleBlackW700.copyWith(fontSize: 16)),
                  _radioButtonContent(title: controller.listMetodePembayaran[0]),
                  _radioButtonContent(title: controller.listMetodePembayaran[1], isSubtitle: true),
                  _radioButtonContent(title: controller.listMetodePembayaran[2]),
                ],
              ),
            )
          else if (tab == 3 || tab == 5)
            Container(
              padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
              width: double.infinity,
              decoration: BoxDecoration(
                color: Color.fromRGBO(86, 159, 0, 0.3),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Metode Pembayaran', style: ListTextStyle.textStyleBlackW700.copyWith(fontSize: 16)),
                  SizedBox(height: 10),
                  Text(
                    '${controller.dataDetail!['metode']}',
                    style: ListTextStyle.textStyleBlackW700.copyWith(fontSize: 14),
                  ),
                  if (controller.dataDetail!['metode'] == 'Transfer') _uploadKTP(Get.context!, 1) else SizedBox.shrink(),
                ],
              ),
            )
          else if (tab == 4)
            Container(
              padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
              width: double.infinity,
              decoration: BoxDecoration(
                color: Color.fromRGBO(86, 159, 0, 0.3),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Alasan Penolakan :', style: ListTextStyle.textStyleBlackW700.copyWith(fontSize: 16, color: Colors.red)),
                  SizedBox(height: 10),
                  Text('${controller.dataDetail!['alasan']}', style: ListTextStyle.textStyleBlackW700.copyWith(fontSize: 14)),
                ],
              ),
            ),
          if (tab == 2)
            Padding(
              padding: EdgeInsets.only(top: 20),
              child: Align(
                alignment: Alignment.center,
                child: CustomSubmitButton(
                  onTap: () {
                    if (controller.metode.value == "") {
                      ScaffoldMessenger.of(Get.context!).showSnackBar(SnackBar(
                        content: Text("Pilih metode pembayaran"),
                        backgroundColor: Colors.red,
                        showCloseIcon: true,
                      ));
                      return;
                    }
                    if (controller.metode.value == "Transfer" && controller.fileBuktiPembayaran.value == null) {
                      ScaffoldMessenger.of(Get.context!).showSnackBar(SnackBar(
                        content: Text("Bukti pembayaran harus diupload"),
                        backgroundColor: Colors.red,
                        showCloseIcon: true,
                      ));
                      return;
                    }
                    controller.bayarPesanan();
                  },
                  text: 'Bayar',
                  width: 130,
                ),
              ),
            ),
        ] else ...[
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Foto Sampah', style: ListTextStyle.textStyleBlackW700.copyWith(fontSize: 16)),
              SizedBox(height: 10),
              Text(
                '${controller.dataDetail!['metode']}',
                style: ListTextStyle.textStyleBlackW700.copyWith(fontSize: 14),
              ),
              SizedBox(height: 10),
              Align(
                alignment: Alignment.center,
                child: GestureDetector(
                  onTap: () => controller.previewFile(Get.context!, 1),
                  child: CachedNetworkImage(
                    imageUrl: '${controller.dataDetail!['file-bukti']}',
                    height: 100,
                  ),
                ),
              ),
              SizedBox(height: 20),
            ],
          ),
          Container(
            padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
            width: double.infinity,
            decoration: BoxDecoration(
              color: Color.fromRGBO(86, 159, 0, 0.3),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Metode Pembayaran', style: ListTextStyle.textStyleBlackW700.copyWith(fontSize: 16)),
                SizedBox(height: 4),
                Text(
                  '${controller.dataDetail!['metode']}',
                  style: ListTextStyle.textStyleBlackW700.copyWith(fontSize: 14, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 10),
                Column(
                  children: [
                    ListView.builder(
                      shrinkWrap: true,
                      itemCount: (controller.dataDetail!['detail'] as List).length,
                      itemBuilder: (context, i) {
                        return Column(
                          children: [
                            Row(
                              children: [
                                Text(
                                  controller.dataDetail!['detail'][i]['jenis'] + "  |  " + controller.dataDetail!['detail'][i]['jumlah'],
                                  style: ListTextStyle.textStyleBlack.copyWith(fontSize: 14),
                                ),
                                Spacer(),
                                Text(
                                  (controller.dataDetail!['jenis'] == "beli") ? 'Rp ${controller.dataDetail!['detail'][i]['harga']}' : '${controller.dataDetail!['detail'][i]['poin']}',
                                  style: ListTextStyle.textStyleBlack.copyWith(fontSize: 14),
                                ),
                              ],
                            ),
                          ],
                        );
                      },
                    ),
                    SizedBox(height: 50),
                    Row(children: [
                      Text(
                        'Total  :',
                        style: ListTextStyle.textStyleBlackW700.copyWith(fontSize: 16),
                      ),
                      Spacer(),
                      if (controller.dataDetail!['jenis'] == "beli")
                        Text.rich(
                          TextSpan(
                            text: 'Rp.',
                            style: ListTextStyle.textStyleBlack.copyWith(fontWeight: FontWeight.w400, fontSize: 14),
                            children: [
                              TextSpan(
                                text: controller.dataDetail!['total_harga'],
                              ),
                              TextSpan(text: ' / '),
                              TextSpan(
                                text: controller.dataDetail!['total_poin'],
                                style: ListTextStyle.textStyleGreenW500.copyWith(fontWeight: FontWeight.w400, fontSize: 14),
                                children: [
                                  TextSpan(
                                    text: ' poin',
                                  ),
                                ],
                              ),
                            ],
                          ),
                        )
                      else
                        Text(
                          '${controller.dataDetail!['total_poin']} Poin',
                          style: ListTextStyle.textStyleBlackW700.copyWith(fontWeight: FontWeight.w400, fontSize: 14),
                        ),
                    ])
                  ],
                ),
              ],
            ),
          ),
          if (tab == 4)
            Container(
              margin: EdgeInsets.only(top: 10),
              padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
              width: double.infinity,
              decoration: BoxDecoration(
                color: Color.fromRGBO(86, 159, 0, 0.3),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Alasan Penolakan :', style: ListTextStyle.textStyleBlackW700.copyWith(fontSize: 16, color: Colors.red)),
                  SizedBox(height: 10),
                  Text('${controller.dataDetail!['alasan']}', style: ListTextStyle.textStyleBlackW700.copyWith(fontSize: 14)),
                ],
              ),
            ),
        ]
      ],
    );
  }

  Widget _radioButtonContent({@required String? title, bool isSubtitle = false}) {
    return RadioListTile(
      contentPadding: EdgeInsets.zero,
      dense: true,
      title: Text(title!, style: ListTextStyle.textStyleBlackW700.copyWith(fontSize: 14)),
      value: title,
      toggleable: true,
      activeColor: Colors.black,
      groupValue: controller.metode.value,
      onChanged: (value) {
        if (value != null) {
          controller.metode.value = value.toString();
          if (value == "Poin") {
            if (int.parse(controller.dataDetail!['total_poin']) > int.parse(controller.authC.userData.poin!)) {
              ScaffoldMessenger.of(Get.context!).showSnackBar(SnackBar(
                content: Text("Poin tidak cukup. Poin kamu : ${controller.authC.userData.poin}"),
                backgroundColor: Colors.red,
                showCloseIcon: true,
              ));
              controller.metode.value = "";
            }
          } else if (value == "Transfer") {
          } else {
          }
        } else {
          controller.metode.value = "";
        }
      },
      subtitle: controller.metode.value == "Transfer"
          ? isSubtitle
              ? Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Image.asset(
                      'assets/bank_mandiri.png',
                      height: 20,
                      width: 47,
                    ),
                    SizedBox(width: 4),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('1928147847', style: ListTextStyle.textStyleBlack.copyWith(fontSize: 14)),
                          _uploadKTP(Get.context!, 0),
                        ],
                      ),
                    )
                  ],
                )
              : null
          : null,
    );
  }

  Widget _tabContent(String? title) {
    return Tab(
      child: Text(
        title!,
        textAlign: TextAlign.center,
        style: ListTextStyle.textStyleBlackW700.copyWith(
          fontSize: 11,
          fontWeight: FontWeight.bold,
        ),
        maxLines: 1,
      ),
    );
  }

  Widget _uploadKTP(BuildContext context, int type) {
    if (type == 1) {
      controller.fileBuktiPembayaran.value = File(controller.dataDetail!['file-bukti']);
    }
    return Align(
      alignment: type == 1 ? Alignment.center : Alignment.topLeft,
      child: InkWell(
        onTap: () => controller.fileBuktiPembayaran.value == null ? controller.showUpload(context) : controller.previewFile(context, type),
        child: Obx(() {
          if (controller.fileBuktiPembayaran.value != null) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: Color(ListColor.colorButtonGreen),
                    ),
                  ),
                  child: Column(
                    children: [
                      if (type == 1)
                        CachedNetworkImage(
                          imageUrl: controller.dataDetail!['file-bukti'],
                          fit: BoxFit.fitHeight,
                          height: 100,
                        )
                      else
                        Image.file(
                          controller.fileBuktiPembayaran.value!,
                          fit: BoxFit.fitHeight,
                          height: 100,
                        ),
                      if (type == 1)
                        SizedBox.shrink()
                      else ...[
                        SizedBox(height: 10),
                        CustomSubmitButton(
                          onTap: () => controller.showUpload(context),
                          text: 'Upload Ulang',
                          height: 40,
                          width: 100,
                        )
                      ]
                    ],
                  ),
                ),
              ],
            );
          } else {
            return Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: Color(0xFFF7F8F9),
                border: Border.all(
                  color: Color(ListColor.colorButtonGreen),
                ),
              ),
              padding: EdgeInsets.symmetric(horizontal: 5),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    'assets/image/logo-upload.png',
                    width: 34,
                    fit: BoxFit.contain,
                  ),
                  Text(
                    'Upload Bukti Transfer',
                    style: TextStyle(
                      color: controller.fileBuktiPembayaran.value != null ? Colors.white : Color(ListColor.colorTextGray),
                      fontFamily: 'Urbanist',
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            );
          }
        }),
      ),
    );
  }

  Widget _dataCard({@required String? title, @required String? value}) {
    return Row(
      children: [
        SizedBox(
          width: 150,
          child: Text(
            title!,
            style: ListTextStyle.textStyleBlack.copyWith(fontSize: 14),
          ),
        ),
        Text(':'),
        SizedBox(width: 10),
        Expanded(
          child: Text(
            value!,
            style: ListTextStyle.textStyleBlack.copyWith(fontSize: 14),
            maxLines: 6,
          ),
        ),
      ],
    );
  }

  Widget buildTabContent(int tabNumber) {
    return StreamBuilder(
      stream: getStreamForTab(tabNumber),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          // Menampilkan data dari stream di dalam konten tab
          final List<DocumentSnapshot<Map<String, dynamic>>> documents = snapshot.data!.docs;
          return Padding(
            padding: EdgeInsets.all(20),
            child: ListView.separated(
                separatorBuilder: (context, index) => SizedBox(height: 10),
                itemCount: documents.length,
                itemBuilder: (context, i) {
                  return Material(
                    borderRadius: BorderRadius.circular(10),
                    child: InkWell(
                      onTap: () {
                        var dataJson = documents[i].data();
                        controller.dataDetail = dataJson;
                        print(controller.dataDetail);
                        controller.setViewMode(RiwayatUserMode.PAYMENT);
                      },
                      borderRadius: BorderRadius.circular(10),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.transparent,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        padding: EdgeInsets.symmetric(vertical: 14, horizontal: 18),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              documents[i]['jenis'] == 'beli' ? 'Pembelian Produk' : 'Tukar Sampah',
                              style: ListTextStyle.textStyleBlackW700.copyWith(fontSize: 18),
                            ),
                            SizedBox(height: 5),
                            Text(
                              documents[i]['jenis'] == 'beli' ? 'Total harga : ${documents[i]['total_harga']} / ${documents[i]['total_poin']} poin' : 'Total poin : ${documents[i]['total_poin']} poin',
                              style: ListTextStyle.textStyleBlackW700.copyWith(fontSize: 14),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                }),
          );
        } else if (snapshot.hasError) {
          // Menampilkan pesan jika terjadi error pada stream
          return Center(
            child: Text('Error: ${snapshot.error}'),
          );
        } else {
          // Menampilkan loading jika data belum tersedia
          return Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }

  Stream<dynamic> getStreamForTab(int tabNumber) {
    // Mengembalikan stream yang sesuai berdasarkan tabNumber
    // Ganti dengan implementasi Anda sendiri
    // Misalnya, mengambil stream dari Firebase Firestore atau Firebase Realtime Database
    if (tabNumber == 1) {
      return FirebaseFirestore.instance.collection('user').doc(controller.authC.currentUser!.uid).collection('pesanan').where('status', isEqualTo: '1').snapshots();
    }
    if (tabNumber == 2) {
      return FirebaseFirestore.instance.collection('user').doc(controller.authC.currentUser!.uid).collection('pesanan').where('status', isEqualTo: '2').snapshots();
    }
    if (tabNumber == 3) {
      return FirebaseFirestore.instance.collection('user').doc(controller.authC.currentUser!.uid).collection('pesanan').where('status', isEqualTo: '3').snapshots();
    }
    if (tabNumber == 4) {
      return FirebaseFirestore.instance.collection('user').doc(controller.authC.currentUser!.uid).collection('pesanan').where('status', isEqualTo: '4').snapshots();
    }
    return FirebaseFirestore.instance.collection('user').doc(controller.authC.currentUser!.uid).collection('pesanan').where('status', isEqualTo: '5').snapshots();
  }

  Widget _detailProduct() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 30),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            (controller.dataDetail!['jenis'] == "beli") ? 'Detail produk :' : 'Detail sampah :',
            style: ListTextStyle.textStyleBlack.copyWith(
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: 10),
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.grey.shade200,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              children: [
                ListView.builder(
                  shrinkWrap: true,
                  itemCount: (controller.dataDetail!['detail'] as List).length,
                  itemBuilder: (context, i) {
                    return Column(
                      children: [
                        Row(
                          children: [
                            Text(
                              controller.dataDetail!['detail'][i]['jenis'] + "  |  " + controller.dataDetail!['detail'][i]['jumlah'],
                              style: ListTextStyle.textStyleBlack.copyWith(fontSize: 14),
                            ),
                            Spacer(),
                            Text(
                              (controller.dataDetail!['jenis'] == "beli") ? 'Rp ${controller.dataDetail!['detail'][i]['harga']}' : '${controller.dataDetail!['detail'][i]['poin']}',
                              style: ListTextStyle.textStyleBlack.copyWith(fontSize: 14),
                            ),
                          ],
                        ),
                      ],
                    );
                  },
                ),
                SizedBox(height: 50),
                Row(
                  children: [
                    Text(
                      'Total  :',
                      style: ListTextStyle.textStyleBlackW700.copyWith(fontSize: 16),
                    ),
                    Spacer(),
                    if (controller.dataDetail!['jenis'] == "beli")
                      Text.rich(
                        TextSpan(
                          text: 'Rp.',
                          style: ListTextStyle.textStyleBlack.copyWith(fontWeight: FontWeight.w400, fontSize: 14),
                          children: [
                            TextSpan(
                              text: controller.dataDetail!['total_harga'],
                            ),
                            TextSpan(text: ' / '),
                            TextSpan(
                              text: controller.dataDetail!['total_poin'],
                              style: ListTextStyle.textStyleGreenW500.copyWith(fontWeight: FontWeight.w400, fontSize: 14),
                              children: [
                                TextSpan(
                                  text: ' poin',
                                ),
                              ],
                            ),
                          ],
                        ),
                      )
                    else
                      Text(
                        '${controller.dataDetail!['total_poin']} Poin',
                        style: ListTextStyle.textStyleBlackW700.copyWith(fontWeight: FontWeight.w400, fontSize: 14),
                      ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
