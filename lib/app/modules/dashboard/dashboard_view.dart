import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rumah_sampah_t_a/app/routes/app_pages.dart';
import 'package:rumah_sampah_t_a/app/utils/list_color.dart';

import '../../controllers/auth_controller.dart';
import 'dashboard_controller.dart';

class DashboardView extends GetView<DashboardController> {
  final authC = Get.find<AuthController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   backgroundColor: Color(ListColor.colorBackground),
      //   elevation: 0,
      //   actions: [
      //     IconButton(
      //       onPressed: () async {
      //         await FirebaseAuth.instance.signOut();
      //         Get.offAllNamed(Routes.WELCOME);
      //       },
      //       // onPressed: () => authC.logout(),
      //       icon: Icon(Icons.logout),
      //     ),
      //   ],
      // ),
      body: SingleChildScrollView(
        child: Container(
          alignment: Alignment.center,
          color: Color(ListColor.colorBackground),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              _header(),
              _button(text: 'Verifikasi Akun', onTap: () => print('tes')),
              _button(text: 'Post Dashboard', onTap: () => print('tes')),
              _button(text: 'Produk', onTap: () => print('tes')),
              _button(text: 'Sampah', onTap: () => print('tes')),
              _button(text: 'Pesanan', onTap: () => print('tes')),
              _button(text: 'Penukaran Sampah', onTap: () => print('tes')),
            ],
          ),
        ),
      ),
    );
  }

  Widget _button({String? text, VoidCallback? onTap}) {
    return InkWell(
      onTap: onTap,
      child: Container(
        width: 260,
        height: 80,
        margin: EdgeInsets.only(bottom: 27),
        decoration: BoxDecoration(
          color: Color(ListColor.colorButtonGreen),
          borderRadius: BorderRadius.circular(8),
        ),
        alignment: Alignment.center,
        child: Text(
          text!,
          style: TextStyle(
            color: Colors.white,
            fontFamily: "Urbanist",
            fontWeight: FontWeight.w700,
            fontSize: 24,
          ),
        ),
      ),
    );
  }

  Widget _header() {
    return Container(
      width: Get.width,
      margin: EdgeInsets.fromLTRB(37, 35, 15, 44),
      child: Row(
        children: [
          Text(
            'Rumah Sampah',
            style: TextStyle(
              color: Color(ListColor.colorButtonGreen),
              fontFamily: "RockSalt",
              fontWeight: FontWeight.w400,
              fontSize: 20,
            ),
          ),
          Spacer(),
          IconButton(
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
              Get.offAllNamed(Routes.WELCOME);
            },
            // onPressed: () => authC.logout(),
            icon: Icon(Icons.logout),
          ),
        ],
      ),
    );
  }
}
