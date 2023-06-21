import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:path/path.dart';
import 'package:rumah_sampah_t_a/app/modules/antrian/antrian_controller.dart';
import 'package:rumah_sampah_t_a/app/modules/keranjang/keranjang_controller.dart';
import 'package:rumah_sampah_t_a/app/routes/app_pages.dart';
import 'package:rumah_sampah_t_a/app/utils/list_color.dart';
import 'package:rumah_sampah_t_a/app/utils/list_text_style.dart';
import 'package:rumah_sampah_t_a/app/utils/utils.dart';
import 'package:rumah_sampah_t_a/app/widgets/custom_back_button.dart';
import 'package:rumah_sampah_t_a/app/widgets/custom_submit_button.dart';
import 'package:rumah_sampah_t_a/app/widgets/custom_text_field.dart';

class AntrianView extends GetView<AntrianController> {
  @override
  Widget build(BuildContext context) {
    return Material(
      child: Obx(() {
        if (controller.antrianUserMode.value == AntrianUserMode.LIST) {
          return Scaffold(
            backgroundColor: Colors.white,
            appBar: AppBar(
              title: Text(
                'Antrian',
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
                    int kaliPoin = 0;
                    for (var element in documents) {
                      int jumlah = int.parse(element['jumlah']);
                      kaliPoin += int.parse(element['poin']) * jumlah;
                    }
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
                              controller.setViewMode(AntrianUserMode.PAYMENT);
                              controller.noHpC.text = controller.authC.userData.nohp.toString();
                            },
                            text: 'Tukar',
                            width: 126,
                          ),
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
                  onTap: () => controller.setViewMode(AntrianUserMode.LIST),
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
                              _uploadKTP(context),
                              _detailProduct(documents),
                              Container(
                                padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  color: Color.fromRGBO(86, 159, 0, 0.3),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text('Metode Penukaran', style: ListTextStyle.textStyleBlackW700.copyWith(fontSize: 16)),
                                    _radioButtonContent(title: controller.listMetodePembayaran[0]),
                                    _radioButtonContent(title: controller.listMetodePembayaran[1]),
                                  ],
                                ),
                              ),
                              Obx(() {
                                if (controller.metode.value == "Tukar dengan Produk") {
                                  controller.sisaTemp.value = int.parse(controller.dataTotalPoin.value);
                                  return Align(
                                    alignment: Alignment.centerLeft,
                                    child: _tukarPoinDengan(documents),
                                  );
                                }
                                return SizedBox.shrink();
                              }),
                              Padding(
                                padding: EdgeInsets.only(top: 8.0),
                                child: CustomSubmitButton(
                                  onTap: () async {
                                    // print(':::  ${controller.dataIndexEdit.value}');
                                    if (controller.noHpC.text.isEmpty || controller.alamatC.value.text.isEmpty || controller.tanggalC.value == "" || controller.waktuC.value == "" || controller.informasiC.value.text.isEmpty || controller.fileSampah.value == null) {
                                      Utils.showNotif(TypeNotif.ERROR, 'Data harus diisi');
                                      return;
                                    } else {
                                      await controller.submitPesanan(dataJson);
                                      Get.offNamed(Routes.RIWAYAT);
                                      Utils.showNotif(TypeNotif.SUKSES, 'Pesanan berhasil diproses');
                                    }
                                  },
                                  text: 'Selesai',
                                  width: 100,
                                ),
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

  Widget _detailProduct(List<DocumentSnapshot<Object?>> documents) {
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
                              '${documents[i]['poin']}',
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
                      'Total poin :',
                      style: ListTextStyle.textStyleBlackW700.copyWith(fontSize: 16),
                    ),
                    Spacer(),
                    Text.rich(
                      TextSpan(
                        text: controller.dataTotalPoin.value,
                        style: ListTextStyle.textStyleGreenW500.copyWith(fontWeight: FontWeight.w400, fontSize: 14),
                        children: [
                          TextSpan(
                            text: ' poin',
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

  Widget _tukarPoinDengan(List<DocumentSnapshot<Object?>> documents) {
    return StreamBuilder(
        stream: controller.fetchDataProduk(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>?> snapshot) {
          if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Text('Belum ada data');
          }
          final List<DocumentSnapshot> documents = snapshot.data!.docs;
          print('data asli${documents.length}');

          print('POIN  :${controller.authC.userData.poin}');
          var indexTrue = documents.where((element) {
            print('PER POIN : ${element['poin']}');
            return int.parse(element['poin']) <= int.parse(controller.authC.userData.poin!);
          }).toList();
          print('data FILTER${indexTrue.length}');
          // controller.textEditingC.value = List<int>.filled(indexTrue.length, 0, growable: true);
          List<Map<String, dynamic>> dataList = [];

          for (var documentSnapshot in indexTrue) {
            // Periksa apakah data ada sebelumnya atau belum
            if (documentSnapshot.data() != null) {
              Map<String, dynamic>? data = documentSnapshot.data() as Map<String, dynamic>?;

              if (data != null) {
                data['jumlah'] = 0.obs; // Isi dengan nilai yang sesuai untuk 'jumlah'
                dataList.add(data);
              }
            } else {
              // Data tidak ada, tambahkan data baru dengan kunci 'jumlah'
              dataList.add({'jumlah': 0.obs});
            }
          }

          return Padding(
            padding: EdgeInsets.symmetric(vertical: 30),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Tukar poin dengan :',
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
                        itemCount: dataList.length,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: EdgeInsets.only(bottom: 8.0),
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      dataList[index]['nama'] + " (${dataList[index]['poin']})",
                                      maxLines: 2,
                                      style: ListTextStyle.textStyleBlack.copyWith(fontSize: 14),
                                    ),
                                    Spacer(),
                                    Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(8),
                                        // color: dataList == index ? Color(ListColor.colorButtonGreen) : Colors.grey.shade600,
                                        color: Color(ListColor.colorButtonGreen),
                                      ),
                                      child: Row(
                                        children: [
                                          InkWell(
                                            onTap: () {
                                              controller.kurangiItem(dataList[index], 1);
                                              print(dataList[index]);

                                              // num totalPoin = 0;
                                              // if (dataList[index]['jumlah'].value >= 1) {
                                              //   dataList[index].update('jumlah', (value) => (value - 1));

                                              //   totalPoin = int.parse(dataList[index]['poin']) * ((dataList[index]['jumlah'].value) - 1);

                                              //   controller.sisaPoin.value += totalPoin;

                                              //   print('Berhasil Mengurangi 1 ${dataList[index]['nama']}');
                                              // } else {
                                              //   print('Batas poin telah terlampaui. Tidak dapat menambahkan lebih banyak ${dataList[index]['nama']}');
                                              // }
                                              // print(dataList[index]['jumlah'].value);

                                              // if (controller.textEditingC[index] == 0) {
                                              //   controller.sisaPoin.value = int.parse(controller.dataTotalPoin.value);
                                              //   return;
                                              // }
                                              // if (index >= 0 && index < controller.textEditingC.length) {
                                              //   controller.textEditingC[index] = controller.textEditingC[index] - 1;
                                              //   totalPerkalian.value = controller.textEditingC[index] * int.parse(dataList[index]['poin']);
                                              //   if (controller.textEditingC[index] == 0) {
                                              //     controller.sisaPoin.value = int.parse(controller.dataTotalPoin.value);
                                              //   }
                                              // }
                                              // var hasilTambah = controller.sisaPoin.value + totalPerkalian.value;

                                              // print('CALC :$hasilTambah');
                                              // controller.sisaPoin.value = hasilTambah;
                                              // print('SISAPOIN :${controller.sisaPoin.value}');
                                            },
                                            child: Center(
                                              child: Icon(
                                                Icons.minimize_rounded,
                                                color: Colors.white,
                                                size: 20,
                                              ),
                                            ),
                                          ),
                                          Obx(() => Text('${dataList[index]['jumlah'].value}', style: TextStyle(color: Colors.white))),
                                          InkWell(
                                            onTap: () {
                                              // num totalPoin = 0;
                                              if (controller.sisaPoin.value == 0) {
                                                return;
                                              }
                                              controller.tambahItem(dataList[index], 1);
                                              // print(dataList[index]);
                                              // if (totalPoin <= controller.sisaPoin.value) {
                                              //   // int.parse(dataList[index]['jumlah']) + 1;
                                              //   dataList[index].update('jumlah', (value) => (value + 1));
                                              //   totalPoin = int.parse(dataList[index]['poin']) * ((dataList[index]['jumlah'].value) + 1);
                                              //   controller.sisaPoin.value -= totalPoin;
                                              //   print('Berhasil MEnambah 1 ${dataList[index]['nama']} || TOTAL KALI : $totalPoin');
                                              // } else {
                                              //   print('Batas poin telah terlampaui. Tidak dapat menambahkan lebih banyak ${dataList[index]['nama']}');
                                              // }

                                              // if (totalPerkalian.value > controller.sisaPoin.value) {
                                              //   return;
                                              // }
                                              // controller.sisaPoin.value = int.parse(controller.dataTotalPoin.value);
                                              // if (index >= 0 && index < controller.textEditingC.length) {
                                              //   controller.textEditingC[index] = controller.textEditingC[index] + 1;
                                              //   totalPerkalian.value = controller.textEditingC[index] * int.parse(indexTrue[index]['poin']);
                                              // }
                                              // if (controller.textEditingC[index] != 0) {
                                              //   if (controller.detailTukarPoin.any((element) => element['product']['uid'] == indexTrue[index]['uid'])) {
                                              //     controller.detailTukarPoin[index]['jumlah'] = controller.textEditingC[index];
                                              //   } else {
                                              //     controller.detailTukarPoin.add({
                                              //       'product': {
                                              //         'uid': indexTrue[index]['uid'],
                                              //         'nama': indexTrue[index]['nama'],
                                              //         'poin': indexTrue[index]['poin'],
                                              //       },
                                              //       'jumlah': controller.textEditingC[index]
                                              //     });
                                              //   }
                                              //   print('TEXTEDITING :${totalPerkalian.value}');
                                              // }
                                              // controller.sisaPoin.value -= totalPerkalian.value;

                                              // print('SISAPOIN :${controller.sisaPoin.value}');
                                            },
                                            child: Icon(Icons.add, color: Colors.white),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                      SizedBox(height: 20),
                      Obx(() {
                        return Row(
                          children: [
                            Text('Sisa poin : ', style: ListTextStyle.textStyleBlackW700.copyWith(fontSize: 16)),
                            Text(
                              '${controller.sisaPoin.value}',
                              style: ListTextStyle.textStyleBlackW700.copyWith(fontSize: 16),
                            ),
                          ],
                        );
                      }),
                    ],
                  ),
                ),
              ],
            ),
          );
        });
  }

  Widget _uploadKTP(BuildContext context) {
    return Align(
      alignment: Alignment.center,
      child: InkWell(
        onTap: () => controller.fileSampah.value == null ? controller.showUpload(context) : controller.previewFile(context),
        child: Obx(() {
          return controller.fileSampah.value != null
              ? Column(
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
                            controller.fileSampah.value!,
                            fit: BoxFit.fitHeight,
                            height: 100,
                          ),
                          SizedBox(height: 10),
                          CustomSubmitButton(
                            onTap: () => controller.showUpload(context),
                            text: 'Upload Ulang',
                            height: 40,
                            width: 100,
                          )
                        ],
                      ),
                    ),
                  ],
                )
              : Container(
                  width: double.infinity,
                  height: 75,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: Color(0xFFF7F8F9),
                    border: Border.all(
                      color: Color(ListColor.colorButtonGreen),
                    ),
                  ),
                  alignment: Alignment.center,
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
                        'Upload Foto Sampahmu',
                        style: TextStyle(
                          color: controller.fileSampah.value != null ? Colors.white : Color(ListColor.colorTextGray),
                          fontFamily: 'Urbanist',
                          fontSize: 15,
                        ),
                      ),
                    ],
                  ),
                );
        }),
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
            'Total poin :',
            style: ListTextStyle.textStyleBlackW700.copyWith(fontSize: 16),
          ),
          Spacer(),
          Text.rich(
            TextSpan(
              text: controller.dataTotalPoin.value,
              style: ListTextStyle.textStyleGreenW500.copyWith(fontWeight: FontWeight.w400, fontSize: 14),
              children: [
                TextSpan(
                  text: ' poin',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _listContent(int i, List<DocumentSnapshot<Object?>> data) {
    // print(data[i]['uid']);
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            width: 230,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${data[i]['jenis']}',
                  maxLines: 2,
                  style: ListTextStyle.textStyleBlackW700.copyWith(fontSize: 14, fontWeight: FontWeight.w600),
                ),
                SizedBox(height: 13),
                Text(
                  '${data[i]['poin']}' ' poin',
                  style: ListTextStyle.textStyleGreenW500.copyWith(fontWeight: FontWeight.w400, fontSize: 14),
                ),
              ],
            ),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                InkWell(
                  onTap: () => controller.deleteCart(data[i]['uid']),
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
                                controller.firestore.collection('user').doc(controller.authC.currentUser!.uid).collection('antrian').doc(data[i]['uid']).update(
                                  {
                                    'jumlah': (int.parse(data[i]['jumlah']) - 1).toString(),
                                  },
                                );
                              }
                            },
                            child: SizedBox(
                              width: 20,
                              child: Text(
                                '-',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  color: controller.dataDetail.value == 1 ? Colors.grey : Colors.white,
                                ),
                              ),
                            )),
                        Text(
                          data[i]['jumlah'],
                          style: ListTextStyle.textStyleBlackW700.copyWith(fontWeight: FontWeight.w900, fontSize: 16, color: Colors.white),
                        ),
                        InkWell(
                          borderRadius: BorderRadius.circular(20),
                          onTap: () {
                            controller.firestore.collection('user').doc(controller.authC.currentUser!.uid).collection('antrian').doc(data[i]['uid']).update(
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

  Widget _radioButtonContent({@required String? title}) {
    return Obx(() => RadioListTile(
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
              // print(controller.metode.value);
              if (value == "Poin") {
                // if (int.parse(controller.dataTotalPoin.value) > int.parse(controller.authC.userData.poin!)) {
                //   ScaffoldMessenger.of(Get.context!).showSnackBar(SnackBar(
                //     content: Text("Poin tidak cukup. Poin kamu : ${controller.authC.userData.poin}"),
                //     backgroundColor: Colors.red,
                //     showCloseIcon: true,
                //   ));
                //   controller.metode.value = "";
                // }
                var tambah = int.parse(controller.authC.userData.poin!) + int.parse(controller.dataTotalPoin.value);
                print('${controller.authC.userData.poin!} + ${controller.dataTotalPoin.value} = $tambah');
              } else {
                controller.sisaPoin.value = int.parse(controller.dataTotalPoin.value);
              }
            } else {
              controller.metode.value = "";
            }
          },
        ));
  }
}
