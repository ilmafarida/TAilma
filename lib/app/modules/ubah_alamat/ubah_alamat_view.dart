// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rumah_sampah_t_a/app/modules/ubah_alamat/ubah_alamat_controller.dart';
import 'package:rumah_sampah_t_a/app/routes/app_pages.dart';
import 'package:rumah_sampah_t_a/app/utils/list_color.dart';
import 'package:rumah_sampah_t_a/app/utils/list_text_style.dart';
import 'package:rumah_sampah_t_a/app/widgets/custom_submit_button.dart';
import 'package:rumah_sampah_t_a/app/widgets/custom_text_field.dart';
import 'package:rumah_sampah_t_a/app/widgets/display_maps.dart';
import 'package:searchable_paginated_dropdown/searchable_paginated_dropdown.dart';

class UbahAlamatView extends GetView<UbahAlamatController> {
  const UbahAlamatView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF5F5F5),
      body: Obx(() {
        return SafeArea(
          child: Padding(
            padding: EdgeInsets.all(16),
            child: controller.loading.value
                ? Center(
                    child: CircularProgressIndicator.adaptive(),
                  )
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      _backButton(),
                      _kecamatanField(),
                      _kelurahanField(),
                      Obx(() => _alamatField()),
                      CustomSubmitButton(onTap: () => controller.submit(), text: 'Simpan', width: 126),
                    ],
                  ),
          ),
        );
      }),
    );
  }

  Widget _backButton() {
    return Align(
      alignment: Alignment.centerLeft,
      child: Padding(
        padding: EdgeInsets.only(bottom: 50),
        child: InkWell(
          onTap: () => Get.back(),
          child: Icon(
            Icons.arrow_back_ios,
            size: 18,
          ),
        ),
      ),
    );
  }

  Widget _kecamatanField() {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        border: Border.all(color: Color(ListColor.colorButtonGreen)),
        borderRadius: BorderRadius.circular(8),
        color: Color(0xFFF7F8F9),
      ),
      child: SearchableDropdown<int>(
        width: double.infinity,
        hintText: Text('Pilih kecamatan'),
        searchHintText: 'Cari kecamatan',
        margin: EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 17,
        ),
        value: controller.idKecamatan,
        items: List.generate(
          controller.listKecamatan.length,
          (i) => SearchableDropdownMenuItem(
            value: i,
            onTap: () => controller.kecamatanC.text = controller.listKecamatan[i],
            label: controller.listKecamatan[i],
            child: Text(controller.listKecamatan[i]),
          ),
        ),
      ),
    );
  }

  Widget _kelurahanField() {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        border: Border.all(color: Color(ListColor.colorButtonGreen)),
        borderRadius: BorderRadius.circular(8),
        color: Color(0xFFF7F8F9),
      ),
      child: SearchableDropdown<int>(
        width: double.infinity,
        hintText: Text('Pilih kelurahan'),
        searchHintText: 'Cari kelurahan',
        margin: EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 17,
        ),
        value: controller.idKelurahan,
        items: List.generate(
          controller.listKelurahan.length,
          (i) => SearchableDropdownMenuItem(
            value: i,
            onTap: () => controller.kelurahanC.text = controller.listKelurahan[i],
            label: controller.listKelurahan[i],
            child: Text(controller.listKelurahan[i]),
          ),
        ),
      ),
    );
  }

  Widget _alamatField() {
    return CustomTextField(
      value: controller.alamatC.value,
      hintText: 'Alamat',
      onTap: () async {
        var res = await Get.to(() => DisplayMaps());
        if (res != null) {
          print(res);
          controller.alamatC.value = res['alamat'];
        }
      },
    );
  }
}
