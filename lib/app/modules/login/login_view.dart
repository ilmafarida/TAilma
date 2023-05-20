import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rumah_sampah_t_a/app/controllers/auth_controller.dart';
import 'package:rumah_sampah_t_a/app/modules/login/login_controller.dart';
import '../../routes/app_pages.dart';

class LoginView extends GetView<LoginController> {
  final authC = Get.find<AuthController>();
  TextEditingController passwordC = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: ListView(
          padding: const EdgeInsets.all(25),
          children: <Widget>[
            Padding(padding: EdgeInsets.all(25)),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Selamat Datang, Mari Olah Sampahmu",
                  style: TextStyle(
                      color: Color(0xFF1E232C),
                      fontFamily: 'Urbanist',
                      fontSize: 24,
                      fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 100),
                Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: Color(0xFFF7F8F9)),
                    child: TextFormField(
                      validator: (value) {
                        bool emailValid = RegExp(
                                r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                            .hasMatch(value!);
                        if (value.isEmpty) {
                          return "Masukkan email";
                        }
                        else if (!emailValid) {
                          return "Masukkan email valid";
                        }
                        
                      },
                      controller: controller.emailC,
                      cursorColor: Colors.black,
                      decoration: InputDecoration(
                        labelText: "Email",
                        border: new OutlineInputBorder(
                            borderSide: BorderSide(color: Color(0xFF569F00))),
                        hintText: "Masukkan email",
                        hintStyle: TextStyle(
                          color: Color(0xFF8391A1),
                          fontFamily: 'Urbanist',
                          fontSize: 15,
                        ),
                        contentPadding:
                            EdgeInsets.symmetric(horizontal: 16, vertical: 17),
                      ),
                    )),
                SizedBox(height: 10),
                Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: Color(0xFFF7F8F9)),
                    child: Obx(() => TextFormField(
                          validator: (value) {
                            if (value!.isEmpty) {
                              return "Masukkan Password";
                            } else if (passwordC.text.length < 6) {
                              return "Password minimal 6 karakter";
                            }
                          },
                          obscureText: controller.isPasswordHidden.value,
                          controller: controller.passwordC,
                          cursorColor: Colors.black,
                          decoration: InputDecoration(
                            labelText: "Password",
                            border: new OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: Color(0xFF569F00))),
                            hintText: "Masukkan password",
                            hintStyle: TextStyle(
                              color: Color(0xFF8391A1),
                              fontFamily: 'Urbanist',
                              fontSize: 15,
                            ),
                            suffix: InkWell(
                              child: Icon(
                                controller.isPasswordHidden.value
                                    ? Icons.visibility
                                    : Icons.visibility_off,
                                color: Colors.grey,
                                size: 20,
                              ),
                              onTap: () {
                                controller.isPasswordHidden.value =
                                    !controller.isPasswordHidden.value;
                              },
                            ),
                            contentPadding: EdgeInsets.symmetric(
                                horizontal: 16, vertical: 17),
                          ),
                        ))),
              ],
            ),
            SizedBox(height: 5),
            Text(
              textAlign: TextAlign.right,
              "Lupa password?",
              style: TextStyle(
                  color: Color(0xFF6A707C),
                  fontFamily: 'Urbanist',
                  fontSize: 14,
                  fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 50),
            Container(
              width: double.infinity,
              height: 40,
              child: ElevatedButton(
                  onPressed: () {
                    controller.login();
                  },
                  // onPressed: () => authC.login(
                  //     controller.emailC.text, controller.passwordC.text),
                  child: Text(
                    "Login",
                    style: TextStyle(
                        color: Colors.white,
                        fontFamily: 'Urbanist',
                        fontSize: 15),
                  ),
                  style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all<Color>(Color(0xFF569F00)))),
            ),
            SizedBox(height: 150),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("Belum punya akun? ",
                    style: TextStyle(
                        color: Color(0xFF24282C),
                        fontFamily: 'Urbanist',
                        fontSize: 13,
                        fontWeight: FontWeight.bold)),
                TextButton(
                    onPressed: () => Get.toNamed(Routes.SIGNUP),
                    child: Text("Registrasi Sekarang!",
                        style: TextStyle(
                            color: Color(0xFF569F00),
                            fontFamily: 'Urbanist',
                            fontSize: 13,
                            fontWeight: FontWeight.bold)))
              ],
            )
          ],
        ));
  }
}


 // TextField(
            //   controller: controller.emailC,
            //   decoration: InputDecoration(labelText: "Email"),
            // ),
            // TextField(
            //   controller: controller.passwordC,
            //   decoration: InputDecoration(labelText: "Password"),
            // ),
            // SizedBox(
            //   height: 50,
            // ),
            // ElevatedButton(
            //     onPressed: () => authC.login(
            //         controller.emailC.text, controller.passwordC.text),
            //     child: Text("LOGIN")),