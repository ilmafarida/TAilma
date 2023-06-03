// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rumah_sampah_t_a/app/controllers/auth_controller.dart';
import 'package:rumah_sampah_t_a/app/modules/login/login_controller.dart';
import '../../routes/app_pages.dart';

class LoginView extends GetView<LoginController> {
  final authC = Get.find<AuthController>();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          backgroundColor: Colors.white,
          body: Padding(
            padding: const EdgeInsets.all(25),
            child: Column(
              children: <Widget>[
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Selamat Datang, Mari Olah Sampahmu",
                      style: TextStyle(color: Color(0xFF1E232C), fontFamily: 'Urbanist', fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 100),
                    Container(
                        width: double.infinity,
                        decoration: BoxDecoration(borderRadius: BorderRadius.circular(8), color: Color(0xFFF7F8F9)),
                        child: TextFormField(
                          validator: (value) {
                            bool emailValid = RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(value!);
                            if (value.isEmpty) {
                              return "Masukkan email";
                            } else if (!emailValid) {
                              return "Masukkan email valid";
                            }
                          },
                          controller: controller.emailC,
                          cursorColor: Colors.black,
                          decoration: InputDecoration(
                            labelText: "Email",
                            border: new OutlineInputBorder(borderSide: BorderSide(color: Color(0xFF569F00))),
                            hintText: "Masukkan email",
                            hintStyle: TextStyle(
                              color: Color(0xFF8391A1),
                              fontFamily: 'Urbanist',
                              fontSize: 15,
                            ),
                            contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 17),
                          ),
                        )),
                    SizedBox(height: 10),
                    Container(
                        width: double.infinity,
                        decoration: BoxDecoration(borderRadius: BorderRadius.circular(8), color: Color(0xFFF7F8F9)),
                        child: Obx(() => TextFormField(
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return "Masukkan Password";
                                } else if (controller.passwordC.text.length < 6) {
                                  return "Password minimal 6 karakter";
                                }
                              },
                              obscureText: controller.isPasswordHidden.value,
                              controller: controller.passwordC,
                              cursorColor: Colors.black,
                              decoration: InputDecoration(
                                labelText: "Password",
                                border: OutlineInputBorder(borderSide: BorderSide(color: Color(0xFF569F00))),
                                hintText: "Masukkan password",
                                hintStyle: TextStyle(
                                  color: Color(0xFF8391A1),
                                  fontFamily: 'Urbanist',
                                  fontSize: 15,
                                ),
                                suffix: InkWell(
                                  child: Icon(
                                    controller.isPasswordHidden.value ? Icons.visibility : Icons.visibility_off,
                                    color: Colors.grey,
                                    size: 20,
                                  ),
                                  onTap: () {
                                    controller.isPasswordHidden.value = !controller.isPasswordHidden.value;
                                  },
                                ),
                                contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 17),
                              ),
                            ))),
                  ],
                ),
                SizedBox(height: 5),
                Align(
                  alignment: Alignment.centerRight,
                  child: GestureDetector(
                    onTap: () => Get.toNamed(Routes.LUPA_PASSWORD),
                    child: Text(
                      textAlign: TextAlign.right,
                      "Lupa password?",
                      style: TextStyle(color: Color(0xFF6A707C), fontFamily: 'Urbanist', fontSize: 14, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                SizedBox(height: 30),
                Container(
                  width: double.infinity,
                  height: 40,
                  child: ElevatedButton(
                      onPressed: () {
                        controller.login();
                      },
                      style: ButtonStyle(backgroundColor: MaterialStateProperty.all<Color>(Color(0xFF569F00))),
                      // onPressed: () => authC.login(
                      //     controller.emailC.text, controller.passwordC.text),
                      child: Text(
                        "Login",
                        style: TextStyle(color: Colors.white, fontFamily: 'Urbanist', fontSize: 15),
                      )),
                ),
                Spacer(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Belum punya akun? ", style: TextStyle(color: Color(0xFF24282C), fontFamily: 'Urbanist', fontSize: 13, fontWeight: FontWeight.bold)),
                    TextButton(onPressed: () => Get.toNamed(Routes.SIGNUP), child: Text("Registrasi Sekarang!", style: TextStyle(color: Color(0xFF569F00), fontFamily: 'Urbanist', fontSize: 13, fontWeight: FontWeight.bold)))
                  ],
                )
              ],
            ),
          )),
    );
  }
}
