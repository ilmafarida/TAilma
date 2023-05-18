import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/riwayat_controller.dart';

class RiwayatView extends GetView<RiwayatController> {
  const RiwayatView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('RiwayatView'),
        centerTitle: true,
      ),
      body: Container(
        child: Center(
          child: Text(
            'Riwayat',
            style: TextStyle(fontSize: 20),
          ),
        ),
      ),
    );
  }
}
