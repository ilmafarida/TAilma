import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rumah_sampah_t_a/app/modules/keranjang/keranjang_controller.dart';
import 'package:rumah_sampah_t_a/app/routes/app_pages.dart';
import 'package:rumah_sampah_t_a/app/utils/list_color.dart';
import 'package:rumah_sampah_t_a/app/utils/list_text_style.dart';
import 'package:rumah_sampah_t_a/app/widgets/custom_back_button.dart';
import 'package:rumah_sampah_t_a/app/widgets/custom_submit_button.dart';
import 'produk_controller.dart';

class ProdukView extends GetView<ProdukController> {
  @override
  Widget build(BuildContext context) {
    return Material(
      child: Obx(() {
        if (controller.produkUserMode.value == ProdukUserMode.LIST) {
          return Scaffold(
            backgroundColor: Colors.white,
            appBar: AppBar(
              title: Text('Produk'),
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
              actions: <Widget>[
                InkWell(
                  onTap: () => Get.toNamed(Routes.KERANJANG),
                  child: Container(
                    width: 80,
                    alignment: Alignment.center,
                    // margin: EdgeInsets.only(right: 30),
                    child: Icon(
                      Icons.shopping_cart_outlined,
                    ),
                  ),
                ),
              ],
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
                      return Text('No data available');
                    }
                    final List<DocumentSnapshot> documents = snapshot.data!.docs;
                    // final data = documents[i].data() as Map<String, dynamic>; // [MENGAMBIL SEMUA DATA]
                    // final data = documents.where((e) => (e['role'] == 'user') && (e['status'] == '-1')).toList();
                    return ListView.builder(
                      scrollDirection: Axis.vertical,
                      shrinkWrap: true,
                      itemCount: documents.length,
                      itemBuilder: (BuildContext context, int i) {
                        print(':::::: $documents');
                        return _listContent(i, documents);
                      },
                    );
                  }),
            ),
          );
        } else {
          return SafeArea(
              child: Scaffold(
            backgroundColor: Colors.white,
            body: Container(
              padding: EdgeInsets.all(20),
              width: double.infinity,
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomBackButton(onTap: () => controller.setViewMode(ProdukUserMode.LIST)),
                    StreamBuilder<DocumentSnapshot>(
                        stream: controller.fetchDataDetail(controller.dataIndexEdit.value.toString()),
                        builder: (context, snapshot) {
                          if (snapshot.hasError) {
                            return Text('Error: ${snapshot.error}');
                          }

                          if (snapshot.connectionState == ConnectionState.waiting) {
                            return Center(child: CircularProgressIndicator());
                          }

                          if (!snapshot.hasData || !snapshot.data!.exists) {
                            return Text('No data available');
                          }
                          final documents = snapshot.data!.data() as Map<String, dynamic>;
                          print('DETAIL ::::::::::::$documents');
                          print('DETAIL :::::${controller.dataIndexEdit.value} $documents');
                          Map<String, dynamic>? dataTambahan;

                          return Column(
                            children: [
                              SizedBox(height: 30),
                              _detailFoto(documents),
                              _upperDetail(documents),
                              Padding(
                                padding: EdgeInsets.symmetric(vertical: 30),
                                child: Text(
                                  documents['deskripsi'],
                                  style: ListTextStyle.textStyleBlack.copyWith(fontSize: 14),
                                ),
                              ),
                              CustomSubmitButton(
                                onTap: () {
                                  dataTambahan = documents;
                                  dataTambahan!['jumlah'] = controller.jumlahProduk.value;
                                  print('$dataTambahan');
                                  // controller.authC.dataKeranjang.value!.add(documents);
                                  controller.submitKeranjang(dataTambahan);
                                },
                                text: '+ keranjang',
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

  Widget _upperDetail(Map<String, dynamic> documents) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                documents['nama'],
                style: ListTextStyle.textStyleBlackW700.copyWith(fontSize: 32),
                maxLines: 2,
              ),
              Text.rich(
                TextSpan(
                  text: 'Rp.',
                  style: ListTextStyle.textStyleBlack.copyWith(fontWeight: FontWeight.w400, fontSize: 14),
                  children: [
                    TextSpan(
                      text: '${documents['harga']}',
                    ),
                    TextSpan(text: ' / '),
                    TextSpan(
                      text: '${documents['poin']}',
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
        Expanded(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 8.0),
            child: Obx(
              () {
                return Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Material(
                      borderRadius: BorderRadius.circular(20),
                      color: Colors.transparent,
                      child: InkWell(
                        borderRadius: BorderRadius.circular(20),
                        onTap: () {
                          if (controller.jumlahProduk.value == 1) {
                          } else {
                            controller.jumlahProduk.value--;
                          }
                          print('::::${controller.jumlahProduk.value}');
                          controller.jumlahProduk.refresh();
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(color: Colors.grey.shade400),
                          ),
                          alignment: Alignment.center,
                          padding: EdgeInsets.all(8),
                          child: Icon(
                            Icons.minimize,
                            size: 24,
                            color: controller.jumlahProduk.value == 1 ? Colors.grey : Colors.black,
                          ),
                        ),
                      ),
                    ),
                    Obx(() => Text(
                          controller.jumlahProduk.toString(),
                          style: ListTextStyle.textStyleBlackW700.copyWith(fontWeight: FontWeight.w900, fontSize: 16),
                        )),
                    Material(
                      borderRadius: BorderRadius.circular(20),
                      color: Colors.transparent,
                      child: InkWell(
                        borderRadius: BorderRadius.circular(20),
                        onTap: () {
                          controller.jumlahProduk.value++;
                          print('::::${controller.jumlahProduk.value}');
                          controller.jumlahProduk.refresh();
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(color: Colors.grey.shade400),
                          ),
                          alignment: Alignment.center,
                          padding: EdgeInsets.all(8),
                          child: Icon(
                            Icons.add,
                            size: 24,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    )
                  ],
                );
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget _detailFoto(Map<String, dynamic> documents) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20, vertical: 26),
      width: double.infinity,
      constraints: BoxConstraints(maxHeight: 200),
      decoration: BoxDecoration(
        color: Colors.grey,
        borderRadius: BorderRadius.circular(20),
      ),
      child: CachedNetworkImage(
        imageUrl: documents['gambar'],
        fit: BoxFit.contain,
      ),
    );
  }

  Widget _listContent(int i, List<DocumentSnapshot<Object?>> data) {
    return Padding(
      padding: EdgeInsets.only(bottom: 10),
      child: Material(
        borderRadius: BorderRadius.circular(18),
        child: InkWell(
          customBorder: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
          onTap: () => {
            print('::$i'),
            controller.setViewMode(ProdukUserMode.DETAIL),
            controller.dataDetail.value = data[i],
            controller.dataIndexEdit.value = i,
            print('::: ${controller.dataDetail.value['nama']}'),
          },
          child: Container(
            padding: EdgeInsets.all(18),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(18),
              border: Border.all(
                color: Color(ListColor.colorButtonGreen),
              ),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                CachedNetworkImage(
                  imageUrl: '${data[i]['gambar']}',
                  height: 72,
                  width: 100,
                ),
                SizedBox(height: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${data[i]['nama']}',
                        maxLines: 2,
                        style: ListTextStyle.textStyleBlackW700.copyWith(fontSize: 20),
                      ),
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
                      // Text(
                      //   '${data[i]['harga']}',
                      //   style: ListTextStyle.textStyleBlackW700.copyWith(fontSize: 14, fontWeight: FontWeight.w500),
                      // ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
