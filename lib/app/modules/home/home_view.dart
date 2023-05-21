// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rumah_sampah_t_a/app/modules/profile/profile_controller.dart';
import 'package:rumah_sampah_t_a/app/routes/app_pages.dart';
import 'package:rumah_sampah_t_a/app/utils/list_color.dart';
import 'package:rumah_sampah_t_a/app/utils/list_text_style.dart';
import 'package:rumah_sampah_t_a/models/user_data_model.dart';

import 'home_controller.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<DocumentSnapshot>(
          stream: controller.authC.streamUser(),
          builder: (context, snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.active:
              case ConnectionState.done:
                controller.authC.userData = UserData.fromSnapshot(snapshot.data!);
                return SafeArea(
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: EdgeInsets.all(16),
                      child: Column(
                        children: [
                          _header(),
                          _cardProfile(),
                          _cardQuote(),
                          _cardFoto(),
                        ],
                      ),
                    ),
                  ),
                );
              case ConnectionState.waiting:
                return Center(child: CircularProgressIndicator(color: Color(ListColor.colorButtonGreen)));
              default:
                return Center(child: Text("Error"));
            }
          }),
      bottomNavigationBar: _bottomNavBar(),
    );
  }

  Widget _cardFoto() {
    return Column(
      children: [
        Container(
          height: 202,
          margin: EdgeInsets.only(top: 15),
          width: double.infinity,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            image: DecorationImage(
              image: AssetImage(
                'assets/image/foto_kegiatan.png',
              ),
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 60, vertical: 7),
          child: Text(
            'Mewujudkan lingkungan yang bersih, nyaman dan terhindar dari bibit penyakit, Warga RT 59 RW 14, Kelurahan Nambangan Lor, Kecamatan Manguharjo, Kota Madiun melakukan kerja bakti bersama membersihkan lingkungan hunian.',
            style: ListTextStyle.textStyleBlack.copyWith(
              fontSize: 14,
            ),
            textAlign: TextAlign.center,
          ),
        )
      ],
    );
  }

  Widget _cardQuote() {
    return Container(
      height: 110,
      width: double.infinity,
      margin: EdgeInsets.only(top: 16),
      decoration: BoxDecoration(color: Color(0xFF569F00).withOpacity(0.30), borderRadius: BorderRadius.circular(20)),
      padding: EdgeInsets.symmetric(vertical: 7, horizontal: 38),
      alignment: Alignment.center,
      child: Text(
        'Kita tidak mewarisi sampah kepada anak cucu tetapi menghadirkan lingkungan yang sehat dan nyaman demi generasi anak bangsa yang berkualitas',
        style: ListTextStyle.textStyleBlack.copyWith(
          color: Colors.black,
          fontWeight: FontWeight.w600,
          fontSize: 14,
          height: 18.2 / 14,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget _header() {
    return Row(
      children: [
        Text(
          'Rumah Sampah',
          style: ListTextStyle.textStyleGreen,
        ),
        Spacer(),
        GestureDetector(
          onTap: () => controller.authC.logout(),
          child: Icon(Icons.logout),
        ),
      ],
    );
  }

  Widget _bottomNavBar() {
    return Container(
      height: 65,
      padding: EdgeInsets.symmetric(horizontal: 10),
      width: double.infinity,
      color: Color(0xFFE2E2E2),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _contentNavBar(icon: 'ic_home.png', title: 'Home', onTap: () => Get.offNamed(Routes.HOME)),
          _contentNavBar(icon: 'ic_produk.png', title: 'Produk', onTap: () => print('produk')),
          _contentNavBar(icon: 'ic_tukar.png', title: 'Tukar Sampah', onTap: () => print('tukar')),
          _contentNavBar(icon: 'ic_riwayat.png', title: 'Riwayat', onTap: () => print('riwayat')),
        ],
      ),
    );
  }

  Widget _contentNavBar({String? icon, String? title, VoidCallback? onTap}) {
    return GestureDetector(
      onTap:  onTap,
      child: Container(
        // color: Colors.red,
        margin: EdgeInsets.only(right: 10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/${icon!}',
              fit: BoxFit.contain, width: 30,
              height: 30,
              // errorBuilder: (context, error, stackTrace) => Icon(Icons.error),
            ),
            Text(
              title!,
              style: ListTextStyle.textStyleBlackRoboto,
            ),
          ],
        ),
      ),
    );
  }

  Widget _cardProfile() {
    return Container(
      margin: EdgeInsets.only(top: 10),
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
            'Sampah Kamu',
            style: ListTextStyle.textStyleWhite,
          ),
          RichText(
            text: TextSpan(
              text: '5',
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
            'Poin Kamu',
            style: ListTextStyle.textStyleWhite,
          ),
          Text(
            '1000',
            style: ListTextStyle.textStyleWhite.copyWith(
              fontSize: 32,
              fontWeight: FontWeight.w900,
            ),
          ),
        ],
      ),
    );
  }

  Widget _headerCard() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        InkWell(onTap: () => Get.toNamed(Routes.PROFILE),
          child: Container(
            margin: EdgeInsets.only(left: 10),
            decoration: BoxDecoration(color: Color(0xFF569F00), shape: BoxShape.circle),
            padding: EdgeInsets.all(5),
            alignment: Alignment.center,
            child: Icon(Icons.person_2_rounded),
          ),
        ),
        SizedBox(width: 14),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Halo ${controller.authC.userData.fullname.toString()},',
              style: ListTextStyle.textStyleBlack.copyWith(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            Text(
              'Yuk Daur Ulang Sampahmu!',
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
}
