import 'package:flutter/material.dart';

import 'package:get/get.dart';

import 'tukarsampah_controller.dart';

class TukarsampahView extends GetView<TukarsampahController> {
  const TukarsampahView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('TukarsampahView'),
        centerTitle: true,
      ),
      body: Container(
        child: Center(
          child: Text(
            'Tukar Sampah',
            style: TextStyle(fontSize: 20),
          ),
        ),
      ),
    );
  }
}
