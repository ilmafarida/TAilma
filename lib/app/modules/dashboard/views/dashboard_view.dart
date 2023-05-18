import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rumah_sampah_t_a/app/modules/home/views/home_view.dart';
import 'package:rumah_sampah_t_a/app/modules/produk/views/produk_view.dart';
import 'package:rumah_sampah_t_a/app/modules/riwayat/views/riwayat_view.dart';
import 'package:rumah_sampah_t_a/app/modules/tukarsampah/views/tukarsampah_view.dart';
import 'package:rumah_sampah_t_a/app/routes/app_pages.dart';
import '../../../controllers/auth_controller.dart';
import '../controllers/dashboard_controller.dart';

class DashboardView extends GetView<DashboardController> {
  final authC = Get.find<AuthController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
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
      body: Container(
        child: Center(
          child: Text(
            'Dashboard',
            style: TextStyle(fontSize: 20),
          ),
        ),
      ),
    );
  }
}
