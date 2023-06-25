import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:latlong2/latlong.dart';
import 'package:rumah_sampah_t_a/app/utils/list_color.dart';
import 'package:rumah_sampah_t_a/app/utils/list_text_style.dart';
import 'package:rumah_sampah_t_a/app/utils/utils.dart';
import 'package:rumah_sampah_t_a/app/widgets/custom_submit_button.dart';
import 'package:rumah_sampah_t_a/app/widgets/display_maps.dart';

import 'penukaran_controller.dart';

class PenukaranView extends GetView<PenukaranController> {
  @override
  Widget build(BuildContext context) {
    return Material(
      child: Obx(() {
        if (controller.riwayatUserMode.value == PenukaranUserMode.LIST) {
          return DefaultTabController(
            length: 3,
            initialIndex: 0,
            child: Scaffold(
              backgroundColor: Colors.white,
              appBar: AppBar(
                title: Text(
                  'Penukaran',
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
                        _tabContent('Proses'),
                        _tabContent('Selesai'),
                      ],
                    ),
                  ),
                ),
              ),
              body: TabBarView(
                children: [
                  buildTabContent(1),
                  buildTabContent(3),
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
                    onTap: () => controller.setViewMode(PenukaranUserMode.LIST),
                    child: Icon(Icons.arrow_back_ios_outlined),
                  ),
                ),
              ),
              backgroundColor: Colors.white,
              body: SingleChildScrollView(
                padding: EdgeInsets.all(20),
                child: _detailContent(controller.tabC.value),
              ),
            ),
          );
        }
      }),
    );
  }

  Widget _detailContent(int tab) {
    print('ID : ${controller.dataIndexEdit.value} |||| ${controller.dataDetail}');

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
              _dataCard(title: 'Nama', value: controller.dataDetail!['nama']),
              _dataCard(title: 'Tanggal Pengiriman', value: controller.dataDetail!['tanggal']),
              _dataCard(title: 'Waktu', value: controller.dataDetail!['jam']),
              _dataCard(title: 'Alamat', value: controller.dataDetail!['alamat'], isMap: true),
              _dataCard(title: 'Informasi', value: controller.dataDetail!['informasi']),
            ],
          ),
        ),
        _detailProduct(),
        if (tab == 1 || tab == 2)
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Foto Sampah', style: ListTextStyle.textStyleBlackW700.copyWith(fontSize: 16)),
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
              Text(
                controller.dataDetail!['jenis'] == 'beli' ? 'Metode Pembayaran' : 'Metode Penukaran',
                style: ListTextStyle.textStyleBlackW700.copyWith(fontSize: 16),
              ),
              SizedBox(height: 4),
              Text(
                '${controller.dataDetail!['metode']}',
                style: ListTextStyle.textStyleBlackW700.copyWith(fontSize: 14, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              if (controller.dataDetail!['metode'] == 'Tukar dengan Produk')
                Column(
                  children: [
                    ListView.builder(
                      shrinkWrap: true,
                      itemCount: (controller.dataDetail!['tukar_dengan'] as List).length,
                      itemBuilder: (context, i) {
                        print(controller.dataDetail!['tukar_dengan'][i]);
                        return Column(
                          children: [
                            Row(
                              children: [
                                Text(
                                  controller.dataDetail!['tukar_dengan'][i]['nama'] + "  |  " + '${controller.dataDetail!['tukar_dengan'][i]['jumlah']}',
                                  style: ListTextStyle.textStyleBlack.copyWith(fontSize: 14),
                                ),
                                Spacer(),
                                Text(
                                  '${controller.dataDetail!['tukar_dengan'][i]['poin']}',
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
                      Text(
                        '${controller.dataDetail!['total_tukar_poin']} Poin',
                        style: ListTextStyle.textStyleBlackW700.copyWith(fontWeight: FontWeight.w400, fontSize: 14),
                      ),
                    ])
                  ],
                ),
            ],
          ),
        ),
        if (controller.dataDetail!['jenis'] == 'beli')
          if (tab == 1 || tab == 2)
            Padding(
              padding: EdgeInsets.only(top: 20),
              child: Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  CustomSubmitButton(
                    onTap: () => controller.openDialogReject(),
                    text: 'Tolak',
                    width: 100,
                    height: 35,
                  ),
                  CustomSubmitButton(
                    onTap: () async {
                      print('ID : ${controller.dataIndexEdit.value} |||| ${controller.dataDetail}');
                      await controller.firestore.collection('user').doc(controller.dataIndexEdit.value).collection('pesanan').doc('${controller.dataDetail!['uid']}').update({
                        'status': tab == 1 ? '2' : '5',
                      });
                      if (tab == 2) {
                        if (controller.dataDetail!['metode'] == 'Poin') {
                          DocumentSnapshot<Map<String, dynamic>> getUser = await controller.firestore.collection('user').doc(controller.dataIndexEdit.value).get();
                          Map<String, dynamic> dataUser = getUser.data()!;
                          int hasiltambah = int.parse(dataUser['poin']) + int.parse(controller.dataDetail!['total_poin']);
                          print(hasiltambah);
                          await controller.firestore.collection('user').doc(dataUser['uid']).update({'poin': '$hasiltambah'});
                        }
                        if (controller.dataDetail!['metode'] == 'Tukar dengan Produk') {
                          DocumentSnapshot<Map<String, dynamic>> getUser = await controller.firestore.collection('user').doc(controller.dataIndexEdit.value).get();
                          Map<String, dynamic> dataUser = getUser.data()!;
                          int hasilKurang = int.parse(dataUser['poin']) + int.parse(controller.dataDetail!['total_tukar_poin']);
                          print(hasilKurang);
                          await controller.firestore.collection('user').doc(dataUser['uid']).update({'poin': '$hasilKurang'});
                        }
                      }

                      controller.setViewMode(PenukaranUserMode.LIST);
                      Utils.showNotif(TypeNotif.SUKSES, tab == 1 ? 'Berhasil diterima' : 'Pesanan diproses');
                    },
                    text: tab == 1 ? 'Terima' : 'Selesai',
                    width: 100,
                    height: 35,
                  ),
                ],
              ),
            ),
        if (controller.dataDetail!['jenis'] == 'tukar')
          if (tab == 1 || tab == 2)
            Padding(
              padding: EdgeInsets.only(top: 20),
              child: Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  if (tab == 1)
                    CustomSubmitButton(
                      onTap: () => controller.openDialogReject(),
                      text: 'Tolak',
                      width: 100,
                      height: 35,
                    ),
                  CustomSubmitButton(
                    onTap: () async {
                      print('ID : ${controller.dataIndexEdit.value} |||| ${controller.dataDetail}');
                      await controller.firestore.collection('user').doc(controller.dataIndexEdit.value).collection('pesanan').doc('${controller.dataDetail!['uid']}').update({
                        'status': tab == 1 ? '3' : '5',
                      });
                      if (tab == 2) {
                        if (controller.dataDetail!['metode'] == 'Poin') {
                          DocumentSnapshot<Map<String, dynamic>> getUser = await controller.firestore.collection('user').doc(controller.dataIndexEdit.value).get();
                          Map<String, dynamic> dataUser = getUser.data()!;
                          int hasiltambah = int.parse(dataUser['poin']) + int.parse(controller.dataDetail!['total_poin']);
                          print(hasiltambah);
                          await controller.firestore.collection('user').doc(dataUser['uid']).update({'poin': '$hasiltambah'});
                        }
                      }
                      controller.setViewMode(PenukaranUserMode.LIST);
                      Utils.showNotif(TypeNotif.SUKSES, tab == 1 ? 'Berhasil diterima' : 'Pesanan diproses');
                    },
                    text: tab == 1 ? 'Terima' : 'Selesai',
                    width: 100,
                    height: 35,
                  ),
                ],
              ),
            ),
      ],
    );
  }

  Widget _radioButtonContent({@required String? title, bool? isSubtitle = false}) {
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
          } else {}
        } else {
          controller.metode.value = "";
        }
      },
      subtitle: controller.metode.value == "Transfer"
          ? isSubtitle!
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
    print(controller.fileBuktiPembayaran.value!.path);
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

  Widget _dataCard({@required String? title, @required String? value, bool isMap = false}) {
    return Row(
      children: [
        SizedBox(
          width: 150,
          child: Text(
            title!,
            maxLines: 2,
            style: ListTextStyle.textStyleBlack.copyWith(fontSize: 14),
          ),
        ),
        Text(':'),
        SizedBox(width: 10),
        Expanded(
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Expanded(
                child: Text(
                  value!,
                  style: ListTextStyle.textStyleBlack.copyWith(fontSize: 14),
                  maxLines: 6,
                ),
              ),
              if (isMap)
                GestureDetector(
                  onTap: () {
                    // print(controller.dataDetail!['latlong']);
                    List<String> coordinates = controller.dataDetail!['latlong'].split(',');
                    Get.to(() {
                      return DisplayMaps(
                        isAdmin: true,
                        latitude: double.parse(coordinates[0]),
                        longitude: double.parse(coordinates[1]),
                      );
                    });
                  },
                  child: Icon(
                    Icons.location_on,
                    color: Colors.black,
                  ),
                )
            ],
          ),
        ),
      ],
    );
  }

  Widget buildTabContent(int tabNumber) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('user').snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }
        if (snapshot.data!.docs.isEmpty) {
          // Tidak ada dokumen "pesanan" yang ditemukan
          return SizedBox.shrink();
        }

        return Padding(
          padding: EdgeInsets.all(10),
          child: ListView.builder(
            itemCount: snapshot.data!.docs.length,
            shrinkWrap: true,
            itemBuilder: (BuildContext context, int index) {
              DocumentSnapshot userDoc = snapshot.data!.docs[index];
              return StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance.collection('user').doc(userDoc.id).collection('pesanan').where('status', isEqualTo: tabNumber.toString()).where('jenis', isEqualTo: 'tukar').snapshots(),
                builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> orderSnapshot) {
                  print(tabNumber);
                  if (orderSnapshot.hasError) {
                    return Text('Error: ${orderSnapshot.error}');
                  }
                  if (orderSnapshot.connectionState == ConnectionState.waiting) {
                    // return Center(child: CircularProgressIndicator());
                    return SizedBox();
                  }
                  if (orderSnapshot.data!.docs.isEmpty) {
                    // Tidak ada dokumen "pesanan" yang ditemukan
                    return SizedBox.shrink();
                  }
                  // Proses data pesanan yang ditemukan dengan status 1
                  return ListView.builder(
                    itemCount: orderSnapshot.data!.docs.length,
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemBuilder: (context, index) {
                      DocumentSnapshot orderDoc = orderSnapshot.data!.docs[index];
                      // print('ORDER:${orderDoc.id}');
                      Map? data = orderDoc.data() as Map?;
                      // Lakukan apa pun yang ingin Anda lakukan dengan pesanan yang memiliki status '[]
                      return Padding(
                        padding: EdgeInsets.only(bottom: 16),
                        child: Material(
                          elevation: 1,
                          borderRadius: BorderRadius.circular(10),
                          child: InkWell(
                            onTap: () {
                              controller.dataDetail = data as Map<String, dynamic>;
                              controller.dataIndexEdit.value = userDoc.id;
                              controller.setViewMode(PenukaranUserMode.PAYMENT);
                              controller.dataDetail!.addAll({'nama': '${(userDoc.data() as Map<String, dynamic>)['fullname']}'});
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
                                    data!['jenis'] == 'beli' ? 'Pembelian Produk' : 'Tukar Sampah',
                                    style: ListTextStyle.textStyleBlackW700.copyWith(fontSize: 18),
                                  ),
                                  SizedBox(height: 5),
                                  Text(
                                    'Total poin : ${data['total_poin']} poin',
                                    style: ListTextStyle.textStyleBlackW700.copyWith(fontSize: 14),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  );
                },
              );
            },
          ),
        );
      },
    );
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
