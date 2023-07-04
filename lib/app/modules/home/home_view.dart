// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rumah_sampah_t_a/app/routes/app_pages.dart';
import 'package:rumah_sampah_t_a/app/utils/list_color.dart';
import 'package:rumah_sampah_t_a/app/utils/list_text_style.dart';
import 'package:rumah_sampah_t_a/app/utils/utils.dart';
import 'package:rumah_sampah_t_a/app/widgets/custom_back_button.dart';
import 'package:rumah_sampah_t_a/app/widgets/custom_submit_button.dart';
import 'package:rumah_sampah_t_a/app/widgets/custom_text_field.dart';
import 'package:rumah_sampah_t_a/models/user_data_model.dart';

import 'home_controller.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({super.key});
  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return Container(
        color: Colors.white,
        child: SafeArea(
          child: controller.homeMode.value == HomeMode.USER
              ? Scaffold(
                  body: StreamBuilder<DocumentSnapshot>(
                    stream: controller.authC.streamUser(),
                    builder: (context, snapshot) {
                      switch (snapshot.connectionState) {
                        case ConnectionState.active:
                        case ConnectionState.done:
                          controller.authC.userData = UserData.fromSnapshot(snapshot.data!);
                          return SingleChildScrollView(
                            child: Padding(
                              padding: EdgeInsets.all(16),
                              child: StreamBuilder<DocumentSnapshot>(
                                  stream: controller.fetchData(),
                                  builder: (context, snap) {
                                    switch (snap.connectionState) {
                                      case ConnectionState.active:
                                      case ConnectionState.done:
                                        var data = snap.data!.data() as Map<String, dynamic>;
                                        print('$data');
                                        return Column(
                                          children: [
                                            _header(),
                                            _cardProfile(data),
                                            _cardQuote(data),
                                            _cardFoto(data),
                                          ],
                                        );
                                      case ConnectionState.waiting:
                                        return Center(child: CircularProgressIndicator(color: Color(ListColor.colorButtonGreen)));
                                      default:
                                        return Center(child: Text("Error"));
                                    }
                                  }),
                            ),
                          );
                        case ConnectionState.waiting:
                          return Center(child: CircularProgressIndicator(color: Color(ListColor.colorButtonGreen)));
                        default:
                          return Center(child: Text("Error"));
                      }
                    },
                  ),
                  bottomNavigationBar: _bottomNavBar(),
                )
              : controller.homeMode.value == HomeMode.ADMIN
                  ? Material(
                      child: Container(
                        color: Colors.white,
                        height: double.infinity,
                        padding: EdgeInsets.all(20),
                        child: SingleChildScrollView(
                          child: StreamBuilder<DocumentSnapshot>(
                              stream: controller.fetchData(),
                              builder: (context, snap) {
                                switch (snap.connectionState) {
                                  case ConnectionState.active:
                                  case ConnectionState.done:
                                    var data = snap.data!.data() as Map<String, dynamic>;
                                    print('$data');
                                    return Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        AppBar(
                                          title: Text('Post Dashboard'),
                                          centerTitle: true,
                                          elevation: 0,
                                          backgroundColor: Colors.white,
                                          foregroundColor: Colors.black,
                                          leading: Material(
                                            color: Colors.transparent,
                                            child: InkWell(
                                              onTap: () {
                                                Get.back();
                                              },
                                              child: Icon(Icons.arrow_back_ios_outlined),
                                            ),
                                          ),
                                        ),
                                        SizedBox(height: 20),
                                        Align(
                                          alignment: Alignment.topRight,
                                          child: CustomSubmitButton(
                                            width: 70,
                                            onTap: () {
                                              controller.setViewMode(HomeMode.EDIT);
                                            },
                                            text: 'Edit',
                                          ),
                                        ),
                                        SizedBox(height: 20),
                                        _content(title: 'Quote :', value: data['quote']),
                                        _content(title: 'Foto :', value: data['image'], isImage: true),
                                        _content(title: 'Deskripsi :', value: data['deskripsi']),
                                      ],
                                    );
                                  case ConnectionState.waiting:
                                    return Center(child: CircularProgressIndicator(color: Color(ListColor.colorButtonGreen)));
                                  default:
                                    return Center(child: Text("Error"));
                                }
                              }),
                        ),
                      ),
                    )
                  : Scaffold(
                      resizeToAvoidBottomInset: true,
                      body: Material(
                        child: Container(
                          color: Colors.white,
                          height: double.infinity,
                          padding: EdgeInsets.all(20),
                          child: SingleChildScrollView(
                            child: StreamBuilder<DocumentSnapshot>(
                                stream: controller.fetchData(),
                                builder: (context, snap) {
                                  switch (snap.connectionState) {
                                    case ConnectionState.active:
                                    case ConnectionState.done:
                                      var data = snap.data!.data() as Map<String, dynamic>;
                                      controller.quoteC.text = data['quote'];
                                      controller.deskripsiC.text = data['deskripsi'];
                                      controller.fileC.value = File('${data['image']}');
                                      print('${controller.fileC.value}');
                                      return Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          CustomBackButton(onTap: () {
                                            controller.setViewMode(HomeMode.ADMIN);
                                            controller.isUpdate.value = false;
                                          }),
                                          SizedBox(height: 20),
                                          Align(
                                            alignment: Alignment.topRight,
                                            child: CustomSubmitButton(
                                              width: 70,
                                              onTap: () async {
                                                if (controller.isUpdate.value) {
                                                  if (controller.quoteC.text.isEmpty || controller.deskripsiC.text.isEmpty || controller.fileC.value == null) {
                                                    Utils.showNotif(TypeNotif.ERROR, 'Field harus diisi');
                                                    return;
                                                  }
                                                }
                                                await controller.submit().then((value) => Utils.showNotif(TypeNotif.SUKSES, 'Edit berhasil disimpan'));
                                              },
                                              text: 'Submit',
                                            ),
                                          ),
                                          SizedBox(height: 20),
                                          Text(
                                            'Quote :',
                                            style: ListTextStyle.textStyleBlackW700.copyWith(fontSize: 18),
                                          ),
                                          SizedBox(height: 8),
                                          CustomTextField(
                                            controller: controller.quoteC,
                                            hintText: 'Masukkan quote',
                                            maxLines: 5,
                                            isWithBorder: false,
                                          ),
                                          Text(
                                            'Foto :',
                                            style: ListTextStyle.textStyleBlackW700.copyWith(fontSize: 18),
                                          ),
                                          SizedBox(height: 8),
                                          Material(
                                            color: Colors.grey.shade50,
                                            borderRadius: BorderRadius.circular(10),
                                            child: Obx(() {
                                              return InkWell(
                                                borderRadius: BorderRadius.circular(10),
                                                onTap: () => controller.showUpload(context),
                                                onLongPress: () => controller.uploadComponent.previewFile(file: controller.fileC.value),
                                                child: Container(
                                                    constraints: BoxConstraints(minHeight: 113),
                                                    width: double.infinity,
                                                    decoration: BoxDecoration(
                                                      borderRadius: BorderRadius.circular(10),
                                                    ),
                                                    padding: EdgeInsets.all(16),
                                                    child: controller.isUpdate.value
                                                        ? Image.file(
                                                            controller.fileC.value!,
                                                            fit: BoxFit.fitWidth,
                                                          )
                                                        : CachedNetworkImage(imageUrl: controller.fileC.value!.path)),
                                              );
                                            }),
                                          ),
                                          Text(
                                            'Deskripsi :',
                                            style: ListTextStyle.textStyleBlackW700.copyWith(fontSize: 18),
                                          ),
                                          SizedBox(height: 8),
                                          CustomTextField(
                                            isWithBorder: false,
                                            controller: controller.deskripsiC,
                                            hintText: 'Masukkan deskripsi',
                                            maxLines: 5,
                                          ),
                                        ],
                                      );
                                    case ConnectionState.waiting:
                                      return Center(child: CircularProgressIndicator(color: Color(ListColor.colorButtonGreen)));
                                    default:
                                      return Center(child: Text("Error"));
                                  }
                                }),
                          ),
                        ),
                      ),
                    ),
        ),
      );
    });
  }

  Widget _content({String? title, VoidCallback? onTap, String? value, bool? isImage = false}) {
    return Padding(
      padding: EdgeInsets.only(bottom: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '$title',
            style: ListTextStyle.textStyleBlackW700.copyWith(fontSize: 18),
          ),
          SizedBox(height: 8),
          Material(
            color: Colors.grey.shade100,
            borderRadius: BorderRadius.circular(10),
            child: InkWell(
              borderRadius: BorderRadius.circular(10),
              onTap: onTap,
              child: Container(
                constraints: BoxConstraints(minHeight: 113),
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                ),
                padding: EdgeInsets.all(16),
                child: !isImage!
                    ? Text(
                        '$value',
                        style: ListTextStyle.textStyleBlack.copyWith(fontWeight: FontWeight.w600, fontSize: 14),
                      )
                    : CachedNetworkImage(
                        imageUrl: '$value',
                        placeholder: (context, url) => Center(child: Text('Tunggu Sebentar')),
                        // errorWidget: (context, url, error) => Icon(Icons.error),
                      ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _cardFoto(dynamic data) {
    return Column(
      children: [
        Container(
          height: 202,
          margin: EdgeInsets.only(top: 15),
          width: double.infinity,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            image: DecorationImage(
              fit: BoxFit.cover,
              image: NetworkImage('${data['image']}'),
            ),
          ),
          // child: Image.network('${data['image']}', fit: BoxFit.fitWidth),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 60, vertical: 7),
          child: Text(
            '${data['deskripsi']}',
            style: ListTextStyle.textStyleBlack.copyWith(
              fontSize: 14,
            ),
            textAlign: TextAlign.center,
          ),
        )
      ],
    );
  }

  Widget _cardQuote(dynamic data) {
    return Container(
      height: 110,
      width: double.infinity,
      margin: EdgeInsets.only(top: 16),
      decoration: BoxDecoration(color: Color(0xFF569F00).withOpacity(0.30), borderRadius: BorderRadius.circular(20)),
      padding: EdgeInsets.symmetric(vertical: 7, horizontal: 38),
      alignment: Alignment.center,
      child: Text(
        '${data['quote']}',
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
          _contentNavBar(icon: 'ic_produk.png', title: 'Produk', onTap: () => Get.toNamed(Routes.PRODUK)),
          _contentNavBar(icon: 'ic_tukar.png', title: 'Tukar Sampah', onTap: () => Get.toNamed(Routes.TUKARSAMPAH)),
          _contentNavBar(icon: 'ic_riwayat.png', title: 'Riwayat', onTap: () => Get.toNamed(Routes.RIWAYAT)),
        ],
      ),
    );
  }

  Widget _contentNavBar({String? icon, String? title, VoidCallback? onTap}) {
    return GestureDetector(
      onTap: onTap,
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
              // color: Color(ListColor.colorButtonGreen),
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

  Widget _cardProfile(dynamic data) {
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
              text: controller.authC.userData.sampah.toString(),
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
            controller.authC.userData.poin.toString(),
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
        InkWell(
          onTap: () => Get.toNamed(Routes.PROFILE),
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
