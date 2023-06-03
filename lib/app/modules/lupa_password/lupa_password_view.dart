// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:rumah_sampah_t_a/app/modules/lupa_password/lupa_password_controller.dart';
import 'package:rumah_sampah_t_a/app/routes/app_pages.dart';
import 'package:rumah_sampah_t_a/app/utils/list_color.dart';
import 'package:rumah_sampah_t_a/app/utils/list_text_style.dart';
import 'package:rumah_sampah_t_a/app/widgets/custom_back_button.dart';
import 'package:rumah_sampah_t_a/app/widgets/custom_submit_button.dart';
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
                : (controller.typeOtp.value == TypeOtpMode.SEND)
                    ? Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          _backButton(),
                          _header(),
                          _noHpField(),
                          CustomSubmitButton(onTap: () async => await controller.verifyPhoneNumber(controller.noHpC.text), text: 'Kirim'),
                          Spacer(),
                          _footer(),
                        ],
                      )
                    : Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          CustomBackButton(),
                          _headerOtp(),
                          _fieldOtp(),
                          SizedBox(height: 10),
                          CustomSubmitButton(onTap: () => controller.verifyCode(), text: 'Verifikasi'),
                          Spacer(),
                          _footerOtp(),
                        ],
                      ),
          ),
        );
      }),
    );
  }

  Widget _otpComponent(int idx) {
    return Obx(() {
      return Expanded(
        child: Container(
          height: 60,
          margin: EdgeInsets.only(right: 4), alignment: Alignment.center,
          // padding: EdgeInsets.fromLTRB(14, 10.5, 12, 10.5),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(4)),
            border: Border.all(
              // color: controller.otpController[idx].text.isNotEmpty
              //     ? Color(0xFFE8ECF4)
              //     : controller.errorOtp.value
              //         ? Color(0xFF5AD292)
              //         : Colors.red,
              color: !controller.errorOtp.value ? Color(0xFF5AD292) : Colors.red,
              width: 1,
            ),
          ),
          child: TextField(
            decoration: InputDecoration(
              border: InputBorder.none,
            ),
            enableSuggestions: false,
            controller: controller.otpController[idx],
            focusNode: controller.otpFocusNode[idx],
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w700,
            ),
            obscureText: false,
            keyboardType: TextInputType.number,
            inputFormatters: [
              LengthLimitingTextInputFormatter(1),
              FilteringTextInputFormatter.digitsOnly,
            ],
            // newInputDecoration: InputDecoration(
            //   isDense: true,
            //   isCollapsed: true,
            //   focusedBorder: InputBorder.none,
            //   enabledBorder: InputBorder.none,
            //   border: InputBorder.none,
            //   disabledBorder: InputBorder.none,
            // ),
            onChanged: (value) {
              // controller.verifyOtp();
              if (controller.otpController[idx].text.length == 1) {
                if (idx < (controller.otpLength - 1)) {
                  controller.otpFocusNode[idx + 1].requestFocus();
                  if (controller.otpController[idx].text.length == 1) {
                    controller.otpController[idx].selection = TextSelection(
                      baseOffset: 0,
                      extentOffset: controller.otpController[idx].value.text.length,
                    );
                  }
                }
              } else {
                if (idx > 0) {
                  controller.otpFocusNode[idx - 1].requestFocus();
                }
              }
            },
            onTap: () {
              controller.otpController[idx].selection = TextSelection(
                baseOffset: 0,
                extentOffset: controller.otpController[idx].value.text.length,
              );
            },
          ),
        ),
      );
    });
  }

  Widget _headerOtp() {
    return Padding(
      padding: EdgeInsets.only(top: 50),
      child: Container(
        width: double.infinity,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'OTP Verifikasi',
              style: ListTextStyle.textStyleBlack.copyWith(
                fontWeight: FontWeight.bold,
                fontSize: 30,
              ),
            ),
            SizedBox(height: 15),
            Text(
              'Masukkan kode verifikasi yang baru saja kami kirim ke alamat email anda.',
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

  Widget _textField({
    @required TextEditingController? controller,
    @required String? hint,
    bool obscure = false,
    bool isPassword = false,
    Widget? icon,
  }) {
    return TextField(
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
    );
  }

  Widget _footerOtp() {
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

  Widget _fieldOtp() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 20),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [for (int i = 0; i < controller.otpLength; i++) _otpComponent(i)],
      ),
    );
  }

  Widget _submitButton(context) {
    return InkWell(
      onTap: () => controller.verifyPhoneNumber(controller.noHpC.text),
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
    return _textFieldNumber(controller: controller.noHpC, hint: 'Masukkan no HP');
  }

  Widget _textFieldNumber({
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
