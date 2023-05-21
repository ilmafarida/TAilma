// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'waiting_controller.dart';

class WaitingView extends GetView<WaitingController> {
  const WaitingView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
          margin: EdgeInsets.only(left: 22, right: 22),
          alignment: Alignment.center,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                "assets/image/waiting.png",
                width: 250,
                height: 150,
              ),
              SizedBox(height: 10),
              Text(
                textAlign: TextAlign.center,
                "Tunggu sampai admin verifikasi akunmu ya..",
                style: TextStyle(fontFamily: 'Urbanist', fontSize: 20, fontWeight: FontWeight.w700),
              ),
            ],
          )),
    );
  }
}
