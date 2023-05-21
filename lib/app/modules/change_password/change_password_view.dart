import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rumah_sampah_t_a/app/modules/change_password/change_password_controller.dart';
import 'package:rumah_sampah_t_a/app/utils/list_text_style.dart';
import 'package:rumah_sampah_t_a/app/widgets/custom_submit_button.dart';
import 'package:rumah_sampah_t_a/app/widgets/custom_text_field.dart';
import '../../routes/app_pages.dart';

class ChangePasswordView extends GetView<ChangePasswordController> {
  const ChangePasswordView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Container(
            margin: EdgeInsets.all(15),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _backButton(),
                  _passwordField(),
                  _newPasswordField(),
                  _submitButton(),
                ],
              ),
            )),
      ),
    );
  }

  Widget _backButton() {
    return Align(
      alignment: Alignment.centerLeft,
      child: InkWell(
        onTap: () => Get.back(),
        child: Icon(
          Icons.arrow_back_ios,
          size: 18,
        ),
      ),
    );
  }

  Widget _passwordField() {
    return Obx(() {
      return Padding(
        padding: EdgeInsets.only(top: 100),
        child: CustomTextField(
          controller: controller.passC,
          hintText: 'Password Baru',
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
          isPassword: true,
          obscure: controller.isPassHidden.value,
        ),
      );
    });
  }

  Widget _newPasswordField() {
    return Padding(
      padding: EdgeInsets.only(top: 15),
      child: CustomTextField(
        controller: controller.passNewC,
        hintText: 'Konfirmasi Password',
        icon: InkWell(
          child: Icon(
            controller.isPassNewHidden.value ? Icons.visibility : Icons.visibility_off,
            color: Colors.grey,
            size: 20,
          ),
          onTap: () {
            controller.isPassNewHidden.value = !controller.isPassNewHidden.value;
          },
        ),
        isPassword: true,
        obscure: controller.isPassNewHidden.value,
      ),
    );
  }

  Widget _submitButton() {
    return CustomSubmitButton(
      onTap: () => controller.submit(),
      text: 'Perbarui Password',
      width: 164,
    );
  }
}
