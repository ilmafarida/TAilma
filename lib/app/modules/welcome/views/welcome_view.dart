import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../routes/app_pages.dart';
import '../controllers/welcome_controller.dart';

class WelcomeView extends GetView<WelcomeController> {
  const WelcomeView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
          margin: EdgeInsets.only(left: 25, right: 25),
          alignment: Alignment.center,
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  "assets/image/logorumahsampah.png",
                  width: 250,
                  height: 150,
                ),
                SizedBox(height: 10),
                Text(
                  textAlign: TextAlign.center,
                  "Sampahku tanggung jawabku, sampahmu tanggung jawabmu",
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 13,
                  ),
                ),
                SizedBox(height: 150),
                Container(
                  width: double.infinity,
                  margin: EdgeInsets.symmetric(horizontal: 10),
                  height: 40,
                  child: ElevatedButton(
                      onPressed: () => Get.toNamed(Routes.LOGIN),
                      child: Text(
                        "Login",
                        style: TextStyle(
                            color: Colors.white,
                            fontFamily: 'Urbanist',
                            fontSize: 15),
                      ),
                      style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all<Color>(
                              Color(0xFF569F00)))),
                ),
                SizedBox(height: 10),
                Container(
                  width: double.infinity,
                  margin: EdgeInsets.symmetric(horizontal: 10),
                  height: 40,
                  child: OutlinedButton(
                      onPressed: () => Get.toNamed(Routes.SIGNUP),
                      child: Text(
                        "Registrasi",
                        style: TextStyle(
                            color: Colors.black,
                            fontFamily: 'Urbanist',
                            fontSize: 15),
                      ),
                      style: ButtonStyle(
                          overlayColor: MaterialStateProperty.all<Color>(
                              Color(0xFF569F00)))),
                )
              ],
            ),
          )),
    );
  }
}
