// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';

class LoadingComponent extends StatelessWidget {
  const LoadingComponent({super.key});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        height: 150,
        width: 150,
        color: Colors.transparent,
        alignment: Alignment.center,
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                margin: EdgeInsets.only(bottom: 20),
                child: SizedBox(
                  width: 30,
                  height: 30,
                  child: CircularProgressIndicator(),
                ),
              ),
              Text("Mohon Tunggu"),
            ],
          ),
        ),
      ),
    );
  }
}
