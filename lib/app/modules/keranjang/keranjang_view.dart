import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rumah_sampah_t_a/app/modules/keranjang/keranjang_controller.dart';
import 'package:rumah_sampah_t_a/app/routes/app_pages.dart';
import 'package:rumah_sampah_t_a/app/utils/list_color.dart';
import 'package:rumah_sampah_t_a/app/utils/list_text_style.dart';
import 'package:rumah_sampah_t_a/app/utils/utils.dart';
import 'package:rumah_sampah_t_a/app/widgets/custom_back_button.dart';
import 'package:rumah_sampah_t_a/app/widgets/custom_submit_button.dart';
import 'package:rumah_sampah_t_a/app/widgets/custom_text_field.dart';

class KeranjangView extends GetView<KeranjangController> {
  @override
  Widget build(BuildContext context) {
    return Material(
      child: Obx(() {
        if (controller.keranjangUserMode.value == KeranjangUserMode.LIST) {
          return Scaffold(
            backgroundColor: Colors.white,
            appBar: AppBar(
              title: Text(
                'Keranjang',
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
            body: Container(
              padding: EdgeInsets.all(16),
              width: double.infinity,
              child: StreamBuilder(
                  stream: controller.fetchData(),
                  builder: (BuildContext context, AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>?> snapshot) {
                    if (snapshot.hasError) {
                      return Text('Error: ${snapshot.error}');
                    }

                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(child: CircularProgressIndicator());
                    }

                    if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                      return Center(child: Text('Belum ada data'));
                    }
                    final List<DocumentSnapshot> documents = snapshot.data!.docs;
                    int kaliHarga = 0;
                    int kaliPoin = 0;
                    for (var element in documents) {
                      int jumlah = int.parse(element['jumlah']);
                      kaliHarga += int.parse(element['harga']) * jumlah;
                      kaliPoin += int.parse(element['poin']) * jumlah;
                    }
                    print('HARGA : $kaliHarga');
                    controller.dataTotalHarga.value = kaliHarga.toString();
                    print('POIN : $kaliPoin');
                    controller.dataTotalPoin.value = kaliPoin.toString();
                    return Column(
                      children: [
                        ListView.separated(
                          separatorBuilder: (context, index) => Divider(),
                          scrollDirection: Axis.vertical,
                          shrinkWrap: true,
                          itemCount: documents.length,
                          itemBuilder: (BuildContext context, int i) {
                            return _listContent(i, documents);
                          },
                        ),
                        _totalHarga(),
                        Padding(
                          padding: EdgeInsets.all(34),
                          child: CustomSubmitButton(
                              onTap: () {
                                controller.setViewMode(KeranjangUserMode.PAYMENT);
                                controller.noHpC.text = controller.authC.userData.nohp.toString();
                              },
                              text: 'Pesan',
                              width: 126),
                        ),
                      ],
                    );
                  }),
            ),
          );
        } else {
          return SafeArea(
              child: Scaffold(
            appBar: AppBar(
              title: Text(
                'Pemesanan',
                style: ListTextStyle.textStyleBlackW700.copyWith(fontSize: 24),
              ),
              centerTitle: true,
              elevation: 0,
              backgroundColor: Colors.white,
              foregroundColor: Colors.black,
              leading: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () => controller.setViewMode(KeranjangUserMode.LIST),
                  child: Icon(Icons.arrow_back_ios_outlined),
                ),
              ),
            ),
            backgroundColor: Colors.white,
            body: Container(
              padding: EdgeInsets.all(20),
              width: double.infinity,
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    StreamBuilder(
                        stream: controller.fetchData(),
                        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>?> snapshot) {
                          if (snapshot.hasError) {
                            return Text('Error: ${snapshot.error}');
                          }
                          if (snapshot.connectionState == ConnectionState.waiting) {
                            return Center(child: CircularProgressIndicator());
                          }
                          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                            return Center(child: Text('Belum ada data'));
                          }
                          final List<DocumentSnapshot<Map<String, dynamic>>> documents = snapshot.data!.docs;
                          var dataJson = documents.map((snapshot) => snapshot.data()).toList();
                          return Column(
                            children: [
                              SizedBox(height: 30),
                              CustomTextField(controller: controller.noHpC, hintText: 'Masukkan No Hp *'),
                              Obx(() => CustomTextField(icon: GestureDetector(onTap: () => controller.getLatLong(), child: Icon(Icons.location_on_rounded, color: Colors.black)), hintText: 'Masukkan Alamat *', title: 'Alamat', controller: controller.alamatC.value)),
                              Obx(() => CustomTextField(icon: Icon(Icons.calendar_month), onTap: () => controller.showDatePicker(), title: 'Tanggal pengiriman *', value: controller.tanggalC.value)),
                              Obx(() => CustomTextField(icon: Icon(Icons.alarm), onTap: () => controller.showWaktuPicker(), title: 'Waktu *', value: controller.waktuC.value)),
                              CustomTextField(hintText: 'Informasi *', controller: controller.informasiC),
                              _detailProduct(documents),
                              CustomSubmitButton(
                                onTap: () async {
                                  if (controller.noHpC.text.isEmpty || controller.alamatC.value.text.isEmpty || controller.tanggalC.value == '' || controller.waktuC.value == '' || controller.informasiC.text.isEmpty) {
                                    Utils.showNotif(TypeNotif.ERROR, 'Data harus diisi');
                                  } else {
                                    try {
                                      controller.submitPesanan(dataJson);
                                      Get.offNamed(Routes.RIWAYAT);
                                      Utils.showNotif(TypeNotif.SUKSES, 'Pesanan berhasil diproses');
                                    } catch (e) {
                                      print('ERORR $e');
                                    }
                                  }
                                },
                                text: 'Beli',
                                width: 100,
                              ),
                            ],
                          );
                        }),
                  ],
                ),
              ),
            ),
          ));
        }
      }),
    );
  }

  Padding _detailProduct(List<DocumentSnapshot<Object?>> documents) {
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
                  itemCount: documents.length,
                  itemBuilder: (context, i) {
                    return Column(
                      children: [
                        Row(
                          children: [
                            Text(
                              documents[i]['jenis'] + "  |  " + documents[i]['jumlah'],
                              style: ListTextStyle.textStyleBlack.copyWith(fontSize: 14),
                            ),
                            Spacer(),
                            Text(
                              'Rp ${documents[i]['harga']}',
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
                      'Total harga :',
                      style: ListTextStyle.textStyleBlackW700.copyWith(fontSize: 16),
                    ),
                    Spacer(),
                    Text.rich(
                      TextSpan(
                        text: 'Rp.',
                        style: ListTextStyle.textStyleBlack.copyWith(fontWeight: FontWeight.w400, fontSize: 14),
                        children: [
                          TextSpan(
                            text: controller.dataTotalHarga.value,
                          ),
                          TextSpan(text: ' / '),
                          TextSpan(
                            text: controller.dataTotalPoin.value,
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

  Widget _totalHarga() {
    return Container(
      margin: EdgeInsets.only(top: 50),
      decoration: BoxDecoration(color: Color(0xFFD9D9D9), borderRadius: BorderRadius.circular(30)),
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      // height: 43,
      width: double.infinity,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            'Total harga :',
            style: ListTextStyle.textStyleBlackW700.copyWith(fontSize: 16),
          ),
          Spacer(),
          Text.rich(
            TextSpan(
              text: 'Rp.',
              style: ListTextStyle.textStyleBlack.copyWith(fontWeight: FontWeight.w400, fontSize: 14),
              children: [
                TextSpan(
                  text: controller.dataTotalHarga.value,
                ),
                TextSpan(text: ' / '),
                TextSpan(
                  text: controller.dataTotalPoin.value,
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
    );
  }

  Widget _listContent(int i, List<DocumentSnapshot<Object?>> data) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            margin: EdgeInsets.only(right: 15),
            height: 70,
            width: 70,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: CachedNetworkImage(
                imageUrl: '${data[i]['gambar']}',
                fit: BoxFit.cover,
              ),
            ),
          ),
          SizedBox(height: 10),
          Flexible(
            fit: FlexFit.tight,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${data[i]['jenis']}',
                  maxLines: 2,
                  style: ListTextStyle.textStyleBlackW700.copyWith(fontSize: 14, fontWeight: FontWeight.w600),
                ),
                SizedBox(height: 13),
                Text.rich(
                  TextSpan(
                    text: 'Rp.',
                    style: ListTextStyle.textStyleBlack.copyWith(fontWeight: FontWeight.w400, fontSize: 14),
                    children: [
                      TextSpan(
                        text: '${data[i]['harga']}',
                      ),
                      TextSpan(text: ' / '),
                      TextSpan(
                        text: '${data[i]['poin']}',
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
          ),
          SizedBox(width: 5),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                InkWell(
                  onTap: () => {
                    controller.deleteCart(i),
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.transparent,
                      border: Border.all(color: Colors.black, width: 3),
                      shape: BoxShape.circle,
                    ),
                    padding: EdgeInsets.all(3),
                    child: Icon(
                      Icons.close_sharp,
                      size: 14,
                      color: Colors.black,
                    ),
                  ),
                ),
                SizedBox(height: 10),
                Obx(() {
                  return Container(
                    decoration: BoxDecoration(
                      color: Color(ListColor.colorButtonGreen),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    alignment: Alignment.center,
                    padding: EdgeInsets.all(6),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        InkWell(
                          borderRadius: BorderRadius.circular(20),
                          onTap: () {
                            if (data[i]['jumlah'] == '1' || data[i]['jumlah'] == '0') {
                              return;
                            } else {
                              controller.firestore.collection('user').doc(controller.authC.currentUser!.uid).collection('keranjang').doc('$i').update(
                                {
                                  'jumlah': (int.parse(data[i]['jumlah']) - 1).toString(),
                                },
                              );
                            }
                          },
                          child: Icon(
                            Icons.minimize_sharp,
                            // size: 16,
                            color: controller.dataDetail.value == 1 ? Colors.grey : Colors.white,
                          ),
                        ),
                        Text(
                          data[i]['jumlah'],
                          style: ListTextStyle.textStyleBlackW700.copyWith(fontWeight: FontWeight.w900, fontSize: 16, color: Colors.white),
                        ),
                        InkWell(
                          borderRadius: BorderRadius.circular(20),
                          onTap: () {
                            controller.firestore.collection('user').doc(controller.authC.currentUser!.uid).collection('keranjang').doc('$i').update(
                              {
                                'jumlah': (int.parse(data[i]['jumlah']) + 1).toString(),
                              },
                            );
                          },
                          child: Icon(
                            Icons.add,
                            size: 24,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  );
                })
              ],
            ),
          ),
        ],
      ),
    );
  }
}
