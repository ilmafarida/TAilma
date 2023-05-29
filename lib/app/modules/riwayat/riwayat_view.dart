import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
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
                bottom: TabBar(
                  dividerColor: Color(ListColor.colorButtonGreen),
                  labelColor: Colors.black,
                  tabs: [
                    Tab(text: 'Antrian'),
                    Tab(text: 'Pembayaran'),
                    Tab(text: 'Proses'),
                    Tab(text: 'Ditolak'),
                    Tab(text: 'Selesai'),
                  ],
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
            body: Column(
              children: [
                Container(
                  padding: EdgeInsets.all(20),
                  width: double.infinity,
                  child: SingleChildScrollView(
                    child: Column(
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
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ));
        }
      }),
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
                              'Total harga : ${documents[i]['total_harga']} / ${documents[i]['total_poin']} poin',
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
            'Detail produk :',
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
                              'Rp ${controller.dataDetail!['detail'][i]['harga']}',
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
