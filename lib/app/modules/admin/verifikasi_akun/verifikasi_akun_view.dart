import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rumah_sampah_t_a/app/modules/admin/verifikasi_akun/verifikasi_akun_controller.dart';
import 'package:rumah_sampah_t_a/app/utils/list_color.dart';
import 'package:rumah_sampah_t_a/app/utils/list_text_style.dart';
import 'package:rumah_sampah_t_a/app/widgets/custom_back_button.dart';
import 'package:rumah_sampah_t_a/app/widgets/custom_submit_button.dart';
import 'package:rumah_sampah_t_a/app/widgets/loading_component.dart';

class VerifikasiAkunView extends GetView<VerifikasiAkunController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Obx(
            () => Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomBackButton(onTap: () {
                  print('::: ${controller.viewMode.value}');
                  if (controller.viewMode.value == ViewMode.VIEW) {
                    Get.back();
                  }
                  controller.setViewMode(ViewMode.VIEW);
                }),
                SizedBox(height: 20),
                if (controller.viewMode.value == ViewMode.VIEW) ...[
                  Expanded(
                    child: Container(
                      width: double.infinity,
                      child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>?>(
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
                          // Memproses snapshot dan menampilkan data
                          final List<DocumentSnapshot> documents = snapshot.data!.docs;
                          // final data = documents[i].data() as Map<String, dynamic>; // [MENGAMBIL SEMUA DATA]
                          final data = documents.where((e) => (e['role'] == 'user') && (e['status'] == '-1')).toList();
                          return ListView.builder(
                            scrollDirection: Axis.vertical,
                            shrinkWrap: true,
                            itemCount: data.length,
                            itemBuilder: (BuildContext context, int i) {
                              return _listContent(i, data);
                            },
                          );
                        },
                      ),
                    ),
                  )
                ] else ...[
                  Expanded(
                    child: Column(
                      children: [
                        _field(title: 'Nama', value: controller.dataEdit.value['fullname']),
                        _field(title: 'Email', value: controller.dataEdit.value['email']),
                        _field(title: 'Kecamatan', value: controller.dataEdit.value['kecamatan']),
                        _field(title: 'Kelurahan', value: controller.dataEdit.value['kelurahan']),
                        _field(title: 'Alamat', value: controller.dataEdit.value['alamat']),
                        _fieldKtp(controller.dataEdit.value['ktp']),
                        Padding(
                          padding: EdgeInsets.only(top: 80),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              CustomSubmitButton(
                                onTap: () => controller.prosesVerifikasi(status: -1),
                                text: 'Unverifikasi',
                                width: 110,
                              ),
                              CustomSubmitButton(
                                onTap: () => controller.prosesVerifikasi(status: 1),
                                text: 'Verifikasi',
                                width: 110,
                              )
                            ],
                          ),
                        )
                      ],
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
            controller.setViewMode(ViewMode.EDIT),
            controller.dataEdit.value = data[i],
            print('::: ${controller.dataEdit.value['ktp']}'),
          },
          child: Container(
            padding: EdgeInsets.all(18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${data[i]['fullname']}',
                  style: ListTextStyle.textStyleBlackW700.copyWith(fontSize: 18),
                ),
                SizedBox(height: 10),
                Text(
                  '${data[i]['email']}',
                  style: ListTextStyle.textStyleBlackW700.copyWith(fontSize: 14, fontWeight: FontWeight.w500),
                ),
                Text(
                  '${data[i]['alamat']}',
                  style: ListTextStyle.textStyleBlackW700.copyWith(fontSize: 14, fontWeight: FontWeight.w500),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _field({@required String? title, @required String? value}) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: Color(ListColor.colorButtonGreen),
        ),
      ),
      margin: EdgeInsets.only(bottom: 22),
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 90,
            child: Text(
              title!,
              style: ListTextStyle.textStyleBlack.copyWith(
                fontSize: 14,
                fontWeight: FontWeight.w400,
                color: Colors.black,
              ),
            ),
          ),
          Text(
            ':',
            style: ListTextStyle.textStyleBlack.copyWith(
              fontSize: 14,
              fontWeight: FontWeight.w400,
              color: Colors.black,
            ),
          ),
          SizedBox(width: 20),
          Expanded(
            child: Text(
              value!,
              style: ListTextStyle.textStyleBlack.copyWith(
                fontSize: 14,
                fontWeight: FontWeight.w400,
                color: Colors.black,
              ),
              maxLines: 3,
            ),
          ),
        ],
      ),
    );
  }

  _fieldKtp(String file) {
    return Align(
      alignment: Alignment.center,
      child: InkWell(
        borderRadius: BorderRadius.circular(8),
        onTap: () => file != "" ? controller.previewFile(Get.context!, file) : {},
        child: Column(
          children: [
            Container(
              width: double.infinity,
              height: 139,
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: Color(ListColor.colorButtonGreen),
                ),
              ),
              child: Image.network(
                file,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.red.shade200), padding: EdgeInsets.all(10), child: Icon(Icons.error_rounded)),
                    SizedBox(height: 20),
                    Text('Belum upload KTP', style: ListTextStyle.textStyleBlack.copyWith(fontSize: 16)),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
