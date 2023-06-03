// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:rumah_sampah_t_a/app/modules/lupa_password/lupa_password_controller.dart';
import 'package:rumah_sampah_t_a/app/modules/ganti_password/ganti_password_controller.dart';
import 'package:rumah_sampah_t_a/app/routes/app_pages.dart';
import 'package:rumah_sampah_t_a/app/utils/list_color.dart';
import 'package:rumah_sampah_t_a/app/utils/list_text_style.dart';
import 'package:rumah_sampah_t_a/app/widgets/custom_back_button.dart';
import 'package:rumah_sampah_t_a/app/widgets/custom_submit_button.dart';
import 'package:rumah_sampah_t_a/app/widgets/custom_text_field.dart';

class GantiPasswordView extends GetView<GantiPasswordController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF5F5F5),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Obx(() {
            if (controller.typePassword.value == TypePasswordViewMode.SUCCESS) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SvgPicture.asset('assets/success_change.svg'),
                  SizedBox(height: 40),
                  Text(
                    'Password Berubah !',
                    style: ListTextStyle.textStyleBlack.copyWith(
                      fontWeight: FontWeight.bold,
                      fontSize: 30,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Password anda telah berhasil dirubah',
                    style: ListTextStyle.textStyleBlack.copyWith(
                      fontWeight: FontWeight.bold,
                      fontSize: 30,
                    ),
                  ),
                  CustomSubmitButton(
                    onTap: () => Get.offNamed(Routes.LOGIN),
                    text: 'Kembali ke Login',
                  )
                ],
              );
            } else {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  CustomBackButton(),
                  _header(),
                  SizedBox(height: 20),
                  CustomTextField(
                    controller: controller.passC,
                    hintText: 'Password Baru',
                    isPassword: true,
                    obscure: controller.isPassHidden.value,
                    icon: InkWell(
                      child: Icon(
                        controller.isPassHidden.value ? Icons.visibility : Icons.visibility_off,
                        color: Colors.grey,
                        size: 20,
                      ),
                      onTap: () {
                        controller.isPassHidden.value = !controller.isPassHidden.value;
                      },
                    ),
                  ),
                  SizedBox(height: 10),
                  CustomTextField(
                    controller: controller.passConfirmC,
                    hintText: 'Konfirmasi Password',
                    isPassword: true,
                    obscure: controller.isPassConfirmHidden.value,
                    icon: InkWell(
                      child: Icon(
                        controller.isPassConfirmHidden.value ? Icons.visibility : Icons.visibility_off,
                        color: Colors.grey,
                        size: 20,
                      ),
                      onTap: () {
                        controller.isPassConfirmHidden.value = !controller.isPassConfirmHidden.value;
                      },
                    ),
                  ),
                  SizedBox(height: 20),
                  CustomSubmitButton(onTap: () => controller.submitForm(context), text: 'Perbarui Password'),
                ],
              );
            }
          }),
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
              'Buat password baru',
              style: ListTextStyle.textStyleBlack.copyWith(
                fontWeight: FontWeight.bold,
                fontSize: 30,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
