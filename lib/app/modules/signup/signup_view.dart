// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:rumah_sampah_t_a/app/controllers/auth_controller.dart';
import 'package:rumah_sampah_t_a/app/utils/list_color.dart';
import 'package:rumah_sampah_t_a/app/utils/list_text_style.dart';
import 'package:rumah_sampah_t_a/app/widgets/custom_submit_button.dart';
import 'package:rumah_sampah_t_a/app/widgets/loading_component.dart';
import 'package:searchable_paginated_dropdown/searchable_paginated_dropdown.dart';
// import 'package:rumah_sampah_t_a/models/kecamatan.dart';
import '../../routes/app_pages.dart';
import 'signup_controller.dart';

class SignupView extends GetView<SignupController> {
  final authC = Get.find<AuthController>();

  SignupView({super.key});
  // final String apiKey =
  //     "d544ff38a1eec00be9cfd3e5d0cbc3a9f5009a00cfba87c2d2fc23acf1fabd7c";
  // String? idKec;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: controller.loadingAPI.value
          ? LoadingComponent()
          : SingleChildScrollView(
              child: Container(
                width: Get.width,
                padding: EdgeInsets.symmetric(horizontal: 14, vertical: 38),
                child: Column(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        _header(),
                        _emailField(),
                        Obx(() => _passwordField()),
                        _namaField(),
                        _noHpField(),
                        Padding(
                          padding: EdgeInsets.only(bottom: 10),
                          child: Text(
                            "Kota Madiun,",
                            style: TextStyle(
                              color: Color(0xFF1E232C),
                              fontFamily: 'TimesNewRoman',
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        // DropdownSearch<String>(
                        //     popupProps: PopupProps.menu(
                        //       showSelectedItems: true,
                        //       disabledItemFn: (String s) => s.startsWith('I'),
                        //     ),
                        //     items: ["Kartoharjo", "Manguharjo", "Taman"],
                        //     dropdownDecoratorProps: DropDownDecoratorProps(
                        //       dropdownSearchDecoration: InputDecoration(
                        //         hintText: "Pilih kecamatanmu..",
                        //       ),
                        //     ),
                        //     onChanged: print),
                        // SizedBox(height: 10),
                        // DropdownSearch<String>(
                        //     popupProps: PopupProps.menu(
                        //       showSelectedItems: true,
                        //       disabledItemFn: (String s) => s.startsWith('I'),
                        //     ),
                        //     items: ["Kartoharjo", "Manguharjo", "Taman"],
                        //     dropdownDecoratorProps: DropDownDecoratorProps(
                        //       dropdownSearchDecoration: InputDecoration(
                        //         hintText: "Pilih kelurahanmu..",
                        //       ),
                        //     ),
                        //     onChanged: print),
                        // DropdownSearch<String>(
                        //   popupProps: PopupProps.menu(
                        //       // itemBuilder: (context, item, isSelected) => ListTile(
                        //       //   title: Text(item.name),
                        //       // ),
                        //       //showSelectedItems: true,
                        //       ),
                        //   dropdownDecoratorProps: DropDownDecoratorProps(
                        //     dropdownSearchDecoration: InputDecoration(
                        //       hintText: "Kecamatan",
                        //     ),
                        //   ),
                        //   onChanged: (value) => print(value),
                        // dropdownBuilder: (context, selectedItem) =>
                        //     Text(selectedItem?.name ?? ""),
                        // asyncItems: (text) async {
                        //   var response = await http.get(Uri.parse(
                        //       "https://api.binderbyte.com/wilayah/kecamatan?api_key=$apiKey&id_kabupaten=3577"));
                        //   if (response.statusCode != 200) {
                        //     return [];
                        //   }
                        //   List allKecamatan = (json.decode(response.body)
                        //       as Map<String, dynamic>)["value"];
                        //   List<String> allNameKecamatan = [];

                        //   allKecamatan.forEach((element) {
                        //     allNameKecamatan.add(element["name"]);
                        //     // Kecamatan(
                        //   id: element["id"],
                        //   idKabupaten: element["idKabupaten"],
                        //   name: element["name"]));
                        //     });
                        //     return allNameKecamatan;
                        //   },
                        // ),
                        // SizedBox(height: 10),
                        // DropdownSearch<Kelurahan>(
                        //   popupProps: PopupProps.dialog(
                        //     itemBuilder: (context, item, isSelected) => ListTile(
                        //       title: Text(item.name),
                        //     ),
                        //showSelectedItems: true,
                        //   ),
                        //   dropdownDecoratorProps: DropDownDecoratorProps(
                        //     dropdownSearchDecoration: InputDecoration(
                        //       hintText: "Kecamatan",
                        //     ),
                        //   ),
                        //   onChanged: (value) => idKec = value?.id,
                        //   dropdownBuilder: (context, selectedItem) =>
                        //       Text(selectedItem?.name ?? ""),
                        //   asyncItems: (text) async {
                        //     var response = await http.get(Uri.parse(
                        //         "https://api.binderbyte.com/wilayah/kelurahan?api_key=$apiKey&id_kecamatan=$idKec"));
                        //     if (response.statusCode != 200) {
                        //       return [];
                        //     }
                        //     List allKelurahan = (json.decode(response.body)
                        //         as Map<String, dynamic>)["value"];
                        //     List<Kelurahan> allModelKelurahan = [];

                        //     allKelurahan.forEach((element) {
                        //       allModelKelurahan.add(Kelurahan(
                        //           id: element["id"],
                        //           idKecamatan: element["idKecamatan"],
                        //           name: element["name"]));
                        //     });
                        //     return allModelKelurahan;
                        //   },
                        // ),
                        _kecamatanField(),
                        _kelurahanField(),
                        _alamatField(),
                        _uploadKTP(context),
                        _submitButton(),
                        _footer()
                      ],
                    )
                  ],
                ),
              ),
            ),
    );
  }

  Widget _footer() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          "Sudah punya akun? ",
          style: ListTextStyle.textStyleBlack.copyWith(
            fontWeight: FontWeight.w500,
            fontSize: 15,
          ),
        ),
        TextButton(
          onPressed: () => Get.toNamed(Routes.LOGIN),
          child: Text(
            "Login Sekarang!",
            style: ListTextStyle.textStyleBlack.copyWith(
              fontWeight: FontWeight.w500,
              color: Color(ListColor.colorButtonGreen),
              fontSize: 15,
            ),
          ),
        )
      ],
    );
  }

  Widget _submitButton() {
    return CustomSubmitButton(
      onTap: () => controller.signUp(),
      text: 'Registrasi',
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

  Widget _alamatField() {
    return _textField(controller: controller.alamatC, hint: 'Alamat');
  }

  Widget _namaField() {
    return _textField(controller: controller.fullnameC, hint: 'Nama lengkap');
  }

  Widget _passwordField() {
    return _textField(
      controller: controller.passwordC,
      isPassword: true,
      hint: 'Password : 123456',
      obscure: !controller.isPasswordHidden.value,
      icon: InkWell(
        child: Icon(
          controller.isPasswordHidden.value ? Icons.visibility : Icons.visibility_off,
          color: Colors.grey,
          size: 20,
        ),
        onTap: () {
          controller.isPasswordHidden.value = !controller.isPasswordHidden.value;
        },
      ),
    );
  }

  Widget _emailField() {
    return _textField(controller: controller.emailC, hint: 'Masukkan Email');
  }

  Widget _textField({
    @required TextEditingController? controller,
    @required String? hint,
    bool obscure = false,
    bool isPassword = false,
    Widget? icon,
    bool isNumber = false,
  }) {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: Color(0xFFF7F8F9),
        border: Border.all(color: Color(0xFF569F00)),
      ),
      child: TextField(
        inputFormatters: isNumber
            ? [
                LengthLimitingTextInputFormatter(12),
                FilteringTextInputFormatter.digitsOnly,
              ]
            : [],
        obscureText: isPassword ? obscure : false,
        controller: controller,
        cursorColor: Colors.black,
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: hint,
          hintStyle: ListTextStyle.textStyleGray,
          contentPadding: EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 17,
          ),
          suffixIcon: icon ?? icon,
        ),
      ),
    );
  }

  Widget _header() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Yuk, Mulai Aksi Kamu!",
          style: ListTextStyle.textStyleBlack.copyWith(
            fontWeight: FontWeight.w700,
            fontSize: 24,
          ),
        ),
        SizedBox(height: 18),
        Text(
          "Silakan isi data terlebih dahulu sebelum memulai aksi kamu ya...",
          style: ListTextStyle.textStyleBlack.copyWith(
            fontSize: 15,
            fontWeight: FontWeight.w400,
            height: 31.2 / 24,
          ),
        ),
        SizedBox(height: 10),
      ],
    );
  }

  Widget _uploadKTP(BuildContext context) {
    return InkWell(
      onTap: () => controller.showUpload(context),
      child: Obx(() {
        return Container(
          width: double.infinity,
          height: 75,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            color: controller.fileKtp.value != null ? Color(ListColor.colorButtonGreen) : Color(0xFFF7F8F9),
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
                controller.fileKtp.value != null ? 'Upload Ulang' : 'Upload KTP',
                style: TextStyle(
                  color: controller.fileKtp.value != null ? Colors.white : Color(ListColor.colorTextGray),
                  fontFamily: 'Urbanist',
                  fontSize: 15,
                ),
              ),
            ],
          ),
        );
      }),
    );
  }

  _noHpField() {
    return _textField(controller: controller.noHpC, hint: 'Masukkan No Hp', isNumber: true);
  }
}
