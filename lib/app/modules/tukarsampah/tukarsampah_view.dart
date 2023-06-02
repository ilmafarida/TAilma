import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rumah_sampah_t_a/app/modules/tukarsampah/tukarsampah_controller.dart';
import 'package:rumah_sampah_t_a/app/routes/app_pages.dart';
import 'package:rumah_sampah_t_a/app/utils/list_color.dart';
import 'package:rumah_sampah_t_a/app/utils/list_text_style.dart';
import 'package:rumah_sampah_t_a/app/widgets/custom_back_button.dart';
import 'package:rumah_sampah_t_a/app/widgets/custom_submit_button.dart';

class TukarSampahView extends GetView<TukarSampahController> {
  @override
  Widget build(BuildContext context) {
    return Material(
      child: Obx(() {
        if (controller.tukarSampahViewMode.value == TukarSampahViewMode.LIST) {
          return Scaffold(
            backgroundColor: Colors.white,
            appBar: AppBar(
              title: Text('Tukar Sampah'),
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
                  onTap: () => Get.toNamed(Routes.ANTRIAN),
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
                      return Text('Belum ada data');
                    }
                    final List<DocumentSnapshot> documents = snapshot.data!.docs;
                    // final data = documents[i].data() as Map<String, dynamic>; // [MENGAMBIL SEMUA DATA]
                    // final data = documents.where((e) => (e['role'] == 'user') && (e['status'] == '-1')).toList();
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Informasi Sampah',
                          style: ListTextStyle.textStyleGreenW500.copyWith(fontSize: 22, fontWeight: FontWeight.w700),
                        ),
                        Text(
                          'Pilih jenis sampah dan masukkan perkiraan berat sampah',
                          style: ListTextStyle.textStyleBlack.copyWith(fontSize: 14, fontWeight: FontWeight.w400),
                        ),
                        SizedBox(height: 35),
                        ListView.builder(
                          scrollDirection: Axis.vertical,
                          shrinkWrap: true,
                          itemCount: documents.length,
                          itemBuilder: (BuildContext context, int i) => _listContent(i, documents),
                        ),
                      ],
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
                    CustomBackButton(onTap: () => controller.setViewMode(TukarSampahViewMode.LIST)),
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
                            return Text('Belum ada data');
                          }
                          final documents = snapshot.data!.data() as Map<String, dynamic>;
                          print('DETAIL ::::::::::::$documents');
                          print('DETAIL :::::${controller.dataIndexEdit.value} $documents');
                          Map<String, dynamic>? dataTambahan;

                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(height: 30),
                              _upperContent(documents),
                              SizedBox(height: 40),
                              _bodyContent(documents),
                              Align(
                                alignment: Alignment.bottomCenter,
                                child: CustomSubmitButton(
                                  onTap: () async {
                                    dataTambahan = documents;
                                    dataTambahan!['jumlah'] = controller.jumlahTukarSampah.value;
                                    print('$dataTambahan');
                                    await controller.submitKeranjang(dataTambahan);
                                    Get.toNamed(Routes.ANTRIAN);
                                  },
                                  text: '+ antrian',
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

  Column _bodyContent(Map<String, dynamic> documents) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Syarat penukaran :',
          style: ListTextStyle.textStyleBlack.copyWith(fontSize: 14, fontWeight: FontWeight.w600),
        ),
        SizedBox(height: 10),
        Container(
          padding: EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Color(ListColor.colorButtonGreen).withOpacity(0.30),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            documents['syarat'].toString().replaceAll('\\n', '\n'),
            style: ListTextStyle.textStyleBlack.copyWith(fontSize: 13, fontWeight: FontWeight.w400),
          ),
        ),
        SizedBox(height: 20),
        Text(
          'Poin :',
          style: ListTextStyle.textStyleBlack.copyWith(fontSize: 14, fontWeight: FontWeight.w600),
        ),
        SizedBox(height: 10),
        Container(
          padding: EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Color(ListColor.colorButtonGreen).withOpacity(0.30),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            documents['poin'] + ' poin' + ' / ' + documents['satuan'],
            style: ListTextStyle.textStyleBlack.copyWith(fontSize: 14, fontWeight: FontWeight.w600),
          ),
        )
      ],
    );
  }

  Widget _upperContent(Map<String, dynamic> documents) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Perkiraan Berat', style: ListTextStyle.textStyleBlack.copyWith(fontSize: 16, fontWeight: FontWeight.w400)),
            Text(
              documents['jenis'],
              style: ListTextStyle.textStyleBlackW700.copyWith(fontSize: 22),
              maxLines: 2,
            ),
          ],
        ),
        Spacer(),
        Obx(() {
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
                    if (controller.jumlahTukarSampah.value == 1) {
                    } else {
                      controller.jumlahTukarSampah.value--;
                    }
                    print('::::${controller.jumlahTukarSampah.value}');
                    controller.jumlahTukarSampah.refresh();
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
                      color: controller.jumlahTukarSampah.value == 1 ? Colors.grey : Colors.black,
                    ),
                  ),
                ),
              ),
              Obx(() => Padding(
                    padding: EdgeInsets.symmetric(horizontal: 5),
                    child: Text.rich(
                      TextSpan(
                        text: '${controller.jumlahTukarSampah} ',
                        style: ListTextStyle.textStyleBlackW700.copyWith(fontWeight: FontWeight.bold, fontSize: 20),
                        children: [
                          TextSpan(
                            text: documents['satuan'],
                            style: ListTextStyle.textStyleGreenW500.copyWith(fontWeight: FontWeight.bold, fontSize: 20),
                          ),
                        ],
                      ),
                    ),

                    // Text(
                    //   '${controller.jumlahTukarSampah} ' '',
                    //   style: ListTextStyle.textStyleBlackW700.copyWith(fontWeight: FontWeight.w900, fontSize: 16),
                    // ),
                  )),
              Material(
                borderRadius: BorderRadius.circular(20),
                color: Colors.transparent,
                child: InkWell(
                  borderRadius: BorderRadius.circular(20),
                  onTap: () {
                    controller.jumlahTukarSampah.value++;
                    print('::::${controller.jumlahTukarSampah.value}');
                    controller.jumlahTukarSampah.refresh();
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
        }),
      ],
    );
  }

  Widget _listContent(int i, List<DocumentSnapshot<Object?>> data) {
    return Padding(
      padding: EdgeInsets.only(bottom: 10),
      child: Container(
        padding: EdgeInsets.all(18),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: Color(ListColor.colorButtonGreen),
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Container(
              decoration: BoxDecoration(shape: BoxShape.circle),
              margin: EdgeInsets.only(right: 20),
              height: 88,
              width: 88,
              child: ClipOval(
                child: CachedNetworkImage(
                  imageUrl: '${data[i]['gambar']}',
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${data[i]['jenis']}',
                    maxLines: 2,
                    style: ListTextStyle.textStyleBlackW700,
                  ),
                  Align(
                    alignment: Alignment.bottomRight,
                    child: CustomSubmitButton(
                      onTap: () {
                        print('::$i');
                        controller.setViewMode(TukarSampahViewMode.DETAIL);
                        controller.dataDetail.value = data[i];
                        controller.dataIndexEdit.value = i;
                        print('::: ${controller.dataDetail.value['jenis']}');
                      },
                      text: 'Pilih',
                      width: 57,
                      height: 28,
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
