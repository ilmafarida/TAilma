// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rumah_sampah_t_a/app/modules/lupa_password/lupa_password_controller.dart';
import 'package:rumah_sampah_t_a/app/routes/app_pages.dart';
import 'package:rumah_sampah_t_a/app/utils/list_color.dart';
import 'package:rumah_sampah_t_a/app/utils/list_text_style.dart';
import 'package:rumah_sampah_t_a/app/widgets/loading_component.dart';

class LupaPasswordView extends GetView<LupaPasswordController> {
  const LupaPasswordView({super.key});

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
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      _backButton(),
                      _header(),
                      _noHpField(),
                      _submitButton(context),
                      Spacer(),
                      _footer(),
                    ],
                  ),
          ),
        );
      }),
    );
  }

  Widget _submitButton(context) {
    return InkWell(
      onTap: () => controller.sendOtpCode(context,controller.noHpC.text),
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(vertical: 19),
        margin: EdgeInsets.only(top: 10),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: Color(ListColor.colorButtonGreen),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(
          "Kirim Kode",
          style: ListTextStyle.textStyleGray.copyWith(color: Colors.white),
        ),
      ),
    );
  }

  Widget _header() {
    return Padding(
      padding: EdgeInsets.only(top: 50),
      child: SizedBox(
        width: double.infinity,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Lupa Password?',
              style: ListTextStyle.textStyleBlack.copyWith(
                fontWeight: FontWeight.bold,
                fontSize: 30,
              ),
            ),
            SizedBox(height: 15),
            Text(
              'Jangan khawatir! Masukkan no telepon yang ditautkan dengan akun anda.',
              style: ListTextStyle.textStyleBlack.copyWith(
                fontSize: 16,
                height: 24 / 16,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _backButton() {
    return InkWell(
      onTap: () => Get.back(),
      child: Icon(
        Icons.arrow_back_ios,
        size: 18,
      ),
    );
  }

  Widget _noHpField() {
    return _textField(controller: controller.noHpC, hint: 'Masukkan no HP');
  }

  Widget _textField({
    @required TextEditingController? controller,
    @required String? hint,
    bool obscure = false,
    bool isPassword = false,
    Widget? icon,
  }) {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.only(top: 40, bottom: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: Color(0xFFF7F8F9),
        border: Border.all(color: Color(0xFF569F00)),
      ),
      child: TextField(
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

  Widget _footer() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          "Ingat Password? ",
          style: ListTextStyle.textStyleBlack.copyWith(
            fontWeight: FontWeight.w500,
            fontSize: 15,
          ),
        ),
        GestureDetector(
          onTap: () => Get.toNamed(Routes.LOGIN),
          child: Text(
            "Login",
            style: ListTextStyle.textStyleBlack.copyWith(
              fontWeight: FontWeight.bold,
              color: Color(ListColor.colorButtonGreen),
              fontSize: 15,
            ),
          ),
        )
      ],
    );
  }
}
