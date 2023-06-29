import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rumah_sampah_t_a/app/modules/admin/product/product_controller.dart';
import 'package:rumah_sampah_t_a/app/utils/list_color.dart';
import 'package:rumah_sampah_t_a/app/utils/list_text_style.dart';
import 'package:rumah_sampah_t_a/app/widgets/custom_back_button.dart';
import 'package:rumah_sampah_t_a/app/widgets/custom_submit_button.dart';
import 'package:rumah_sampah_t_a/app/widgets/custom_text_field.dart';
import 'package:rumah_sampah_t_a/app/widgets/upload_component.dart';

class AdminProductView extends GetView<AdminProductController> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
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
            onTap: () {
                  Get.back();
                },
            child: Icon(Icons.arrow_back_ios_outlined),
          ),
        ),
      ),
        resizeToAvoidBottomInset: false,
        body: Padding(
          padding: EdgeInsets.all(20),
          child: Obx(
            () => Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // CustomBackButton(onTap: () {
                //   Get.back();
                // }),
                SizedBox(height: 30),
                if (controller.productMode.value == ProductMode.VIEW) ...[
                  SingleChildScrollView(
                    child: SizedBox(
                      width: double.infinity,
                      child: Column(
                        children: [
                          SizedBox(height: 20),
                          Align(
                            alignment: Alignment.topRight,
                            child: CustomSubmitButton(
                              onTap: () {
                                controller.setViewMode(ProductMode.CREATE);
                                print('::: ${controller.dataIndexEdit.value}');
                              },
                              text: '+ produk',
                              width: 100,
                            ),
                          ),
                          SizedBox(height: 30),
                          StreamBuilder<QuerySnapshot<Map<String, dynamic>>?>(
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
                              // Memproses snapshot dan menampilkan data
                              final List<DocumentSnapshot> documents = snapshot.data!.docs;
                              return GridView.builder(
                                shrinkWrap: true,
                                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2, // Menentukan jumlah kolom dalam grid
                                  mainAxisSpacing: 8.0, // Jarak antar elemen pada sumbu utama (vertikal)
                                  crossAxisSpacing: 8.0, // Jarak antar elemen pada sumbu lintang (horizontal)
                                  childAspectRatio: 1.0, // Perbandingan lebar-tinggi setiap elemen dalam grid
                                ),
                                itemCount: documents.length,
                                itemBuilder: (context, i) {
                                  return Padding(
                                    padding: EdgeInsets.only(bottom: 10),
                                    child: Material(
                                      borderRadius: BorderRadius.circular(18),
                                      child: InkWell(
                                        customBorder: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(18),
                                        ),
                                        onTap: () {
                                          controller.dataIndexEdit.value = documents[i]['uid'];
                                          controller.dataEdit.value = documents[i];
                                          controller.setViewMode(ProductMode.EDIT);
                                        },
                                        child: Container(
                                          padding: EdgeInsets.all(18),
                                          alignment: Alignment.center,
                                          child: Text(
                                            '${documents[i]['nama']}',
                                            textAlign: TextAlign.center,
                                            style: ListTextStyle.textStyleBlackW700.copyWith(fontSize: 18),
                                          ),
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              );
                              // );
                            },
                          ),
                        ],
                      ),
                    ),
                  )
                ] else if (controller.productMode.value == ProductMode.CREATE) ...[
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          _field(controller: controller.namaC, hint: 'Nama Produk'),
                          _field(controller: controller.hargaC, hint: 'Harga', isNumber: true),
                          _field(controller: controller.poinC, hint: 'Poin', isNumber: true),
                          _field(controller: controller.deskripsiC, hint: 'Deskripsi', maxLinex: 6),
                          _fieldFoto(),
                          Padding(
                            padding: EdgeInsets.only(top: 40),
                            child: CustomSubmitButton(
                              onTap: () => controller.prosesSubmit(status: 0, uid:controller.dataIndexEdit.value),
                              text: 'Simpan',
                              width: 110,
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ] else ...[
                  // EDIT
                  Expanded(
                    child: SingleChildScrollView(
                      child: StreamBuilder<DocumentSnapshot>(
                          stream: controller.fetchDataDetail(),
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
                            // Memproses snapshot dan menampilkan data
                            final documents = snapshot.data!.data() as Map<String, dynamic>;
                            print('::::::::::::$documents');
                            controller.namaC.text = documents['nama'];
                            controller.hargaC.text = documents['harga'];
                            controller.poinC.text = documents['poin'];
                            controller.deskripsiC.text = documents['deskripsi'];
                            controller.deskripsiC.text = documents['deskripsi'];
                            if (!controller.isUpload.value) {
                              controller.file.value = File(documents['gambar']);
                            }
                            print(':::::${controller.dataIndexEdit.value} $documents');
                            return Column(
                              children: [
                                _field(controller: controller.namaC, hint: 'Nama Produk'),
                                _field(controller: controller.hargaC, hint: 'Harga', isNumber: true),
                                _field(controller: controller.poinC, hint: 'Poin', isNumber: true),
                                _field(controller: controller.deskripsiC, hint: 'Deskripsi', maxLinex: 6),
                                _fieldFoto(),
                                Padding(
                                  padding: EdgeInsets.only(top: 40),
                                  child: Row(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                    children: [
                                      CustomSubmitButton(
                                        onTap: () => controller.prosesSubmit(status: -1, uid: controller.dataIndexEdit.value),
                                        text: 'Hapus',
                                        width: 110,
                                      ),
                                      CustomSubmitButton(
                                        onTap: () => controller.prosesSubmit(status: 1, uid: controller.dataIndexEdit.value),
                                        text: 'Simpan',
                                        width: 110,
                                      )
                                    ],
                                  ),
                                )
                              ],
                            );
                          }),
                    ),
                  ),
                ]
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Widget _listContent(int i, List<DocumentSnapshot<Object?>> data) {
  //   return
  // }

  Widget _field({@required TextEditingController? controller, @required String? hint, bool? isNumber = false, int? maxLinex = 1}) {
    return CustomTextField(
      controller: controller!,
      hintText: 'Masukkan $hint *',
      isNumber: isNumber,
      maxLines: maxLinex,
    );
    // Container(
    //   decoration: BoxDecoration(
    //     borderRadius: BorderRadius.circular(20),
    //     border: Border.all(
    //       color: Color(ListColor.colorButtonGreen),
    //     ),
    //   ),
    //   margin: EdgeInsets.only(bottom: 22),
    //   padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
    //   child: Row(
    //     crossAxisAlignment: CrossAxisAlignment.start,
    //     children: [
    //       SizedBox(
    //         width: 110,
    //         child: Text(
    //           title!,
    //           style: ListTextStyle.textStyleBlack.copyWith(
    //             fontSize: 14,
    //             fontWeight: FontWeight.w400,
    //             color: Colors.black,
    //           ),
    //         ),
    //       ),
    //       Text(
    //         ':',
    //         style: ListTextStyle.textStyleBlack.copyWith(
    //           fontSize: 14,
    //           fontWeight: FontWeight.w400,
    //           color: Colors.black,
    //         ),
    //       ),
    //       SizedBox(width: 10),
    //       Expanded(
    //         child: Text(
    //           value!,
    //           style: ListTextStyle.textStyleBlack.copyWith(
    //             fontSize: 14,
    //             fontWeight: FontWeight.w400,
    //             color: Colors.black,
    //           ),
    //           softWrap: true,
    //           overflow: TextOverflow.visible,
    //           maxLines: 10,
    //         ),
    //       ),
    //     ],
    //   ),
    // );
  }

  _fieldFoto() {
    return Align(
      alignment: Alignment.center,
      child: InkWell(
        borderRadius: BorderRadius.circular(8),
        onTap: () => controller.showUpload(Get.context!),
        child: Obx(
          () => Container(
            width: double.infinity,
            height: 139,
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: Color(ListColor.colorButtonGreen),
              ),
            ),
            child: controller.file.value != null
                ? controller.isUpload.value
                    ? Image.file(
                        controller.file.value!,
                        fit: BoxFit.fitHeight,
                      )
                    : CachedNetworkImage(
                        imageUrl: controller.file.value!.path,
                        fit: BoxFit.cover,
                      )
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        'assets/image/logo-upload.png',
                        width: 34,
                        fit: BoxFit.contain,
                      ),
                      Text(
                        'Foto Produk',
                        style: TextStyle(
                          color: controller.file.value != null ? Colors.white : Color(ListColor.colorTextGray),
                          fontFamily: 'Urbanist',
                          fontSize: 15,
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
