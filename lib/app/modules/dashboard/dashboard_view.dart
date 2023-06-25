import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rumah_sampah_t_a/app/routes/app_pages.dart';
import 'package:rumah_sampah_t_a/app/utils/list_color.dart';
import 'package:rumah_sampah_t_a/app/utils/list_text_style.dart';

import '../../controllers/auth_controller.dart';
import 'dashboard_controller.dart';

class DashboardView extends GetView<DashboardController> {
  final authC = Get.find<AuthController>();

  DashboardView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RefreshIndicator(
        onRefresh: () => controller.onRefresh(),
        child: SingleChildScrollView(
          child: Container(
            alignment: Alignment.center,
            color: Color(ListColor.colorBackground),
            child: Obx(() {
              return Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  _header(),
                  _cardProfile(controller.authC.userData),
                  _button(text: 'Verifikasi Akun', onTap: () => Get.toNamed(Routes.VERIFIKASI_AKUN)),
                  _button(text: 'Akun Terverifikasi', onTap: () => Get.toNamed(Routes.AKUN_TERVERIFIKASI)),
                  _button(text: 'Post Dashboard', onTap: () => Get.toNamed(Routes.HOME)),
                  _button(text: 'Produk', onTap: () => Get.toNamed(Routes.ADMIN_PRODUCT)),
                  _button(text: 'Sampah', onTap: () => Get.toNamed(Routes.ADMIN_SAMPAH)),
                  _button(text: 'Pesanan', onTap: () => Get.toNamed(Routes.PESANAN), isWithNotif: true, notifCount: controller.jumlahPesanan.value),
                  _button(text: 'Penukaran Sampah', onTap: () => Get.toNamed(Routes.PENUKARAN), isWithNotif: true, notifCount: controller.jumlahPenukaran.value),
                  _button(text: 'Report', onTap: () => Get.toNamed(Routes.REPORT)),
                ],
              );
            }),
          ),
        ),
      ),
    );
  }

  Widget _cardProfile(dynamic data) {
    return Container(
      margin: EdgeInsets.fromLTRB(20, 0, 20, 20),
      padding: EdgeInsets.all(10),
      height: 132,
      decoration: BoxDecoration(
        color: Color(0xFFEAEAEA),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          // DATA
          _headerCard(),
          // CARD HIJAU
          Spacer(),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _contentLeft(),
              _contentRight(),
            ],
          ),
          // QUOTE
        ],
      ),
    );
  }

  Widget _headerCard() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Halo Admin,',
              style: ListTextStyle.textStyleBlack.copyWith(fontWeight: FontWeight.bold, fontSize: 20),
            ),
            Text(
              'Yuk Kelola Data Sampah!',
              style: ListTextStyle.textStyleBlack.copyWith(
                fontSize: 13,
                color: Color(ListColor.colorButtonGreen),
              ),
            ),
          ],
        )
      ],
    );
  }

  Widget _contentLeft() {
    return Container(
      decoration: BoxDecoration(
        color: Color(ListColor.colorButtonGreen),
        borderRadius: BorderRadius.circular(20),
      ),
      width: 138.89,
      height: 63,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Sampah Masuk',
            style: ListTextStyle.textStyleWhite,
          ),
          RichText(
            text: TextSpan(
              text: '${controller.jumlahSampah.value}',
              style: ListTextStyle.textStyleWhite.copyWith(
                fontSize: 32,
                fontWeight: FontWeight.w900,
              ),
              children: [
                TextSpan(text: '/kg', style: ListTextStyle.textStyleWhite),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _contentRight() {
    return Container(
      decoration: BoxDecoration(
        color: Color(ListColor.colorButtonGreen),
        borderRadius: BorderRadius.circular(20),
      ),
      width: 138.89,
      height: 63,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Produk Terjual',
            style: ListTextStyle.textStyleWhite,
          ),
          Text(
            '${controller.jumlahProduk.value}',
            style: ListTextStyle.textStyleWhite.copyWith(
              fontSize: 32,
              fontWeight: FontWeight.w900,
            ),
          ),
        ],
      ),
    );
  }

  Widget _button({String? text, VoidCallback? onTap, bool isWithNotif = false, int? notifCount}) {
    return Stack(
      children: [
        InkWell(
          onTap: onTap!,
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
        ),
        if (isWithNotif && notifCount != null)
          Positioned(
            right: 0,
            top: 0,
            child: Container(
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(color: Colors.red, shape: BoxShape.circle),
              child: Text('$notifCount', style: ListTextStyle.textStyleWhite),
            ),
          )
      ],
    );
  }

  Widget _header() {
    return Container(
      width: Get.width,
      margin: EdgeInsets.fromLTRB(37, 35, 15, 20),
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
            onPressed: () => authC.logout(),
            // onPressed: () => authC.logout(),
            icon: Icon(Icons.logout),
          ),
        ],
      ),
    );
  }
}
