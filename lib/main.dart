// ignore_for_file: prefer_const_constructors, deprecated_member_use

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:rumah_sampah_t_a/app/controllers/auth_controller.dart';
import 'package:rumah_sampah_t_a/app/modules/dashboard/dashboard_controller.dart';
import 'package:rumah_sampah_t_a/app/modules/dashboard/dashboard_view.dart';
import 'package:rumah_sampah_t_a/app/modules/home/home_controller.dart';
import 'package:rumah_sampah_t_a/app/modules/home/home_view.dart';
import 'package:rumah_sampah_t_a/app/modules/welcome/welcome_controller.dart';
import 'package:rumah_sampah_t_a/app/modules/welcome/welcome_view.dart';
import 'package:rumah_sampah_t_a/app/utils/shared_preference.dart';
import 'firebase_options.dart';
import 'package:get/get.dart';
//import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'app/routes/app_pages.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (Platform.isAndroid) {
    AndroidGoogleMapsFlutter.useAndroidViewSurface = true;
  }

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  await SharedPreference.init();
  final authC = Get.put(AuthController(), permanent: true);
  var roleUser = await SharedPreference.getUserRole();
  var idUser = await SharedPreference.getUserID();

  runApp(
    GetMaterialApp(
      theme: ThemeData(visualDensity: VisualDensity.adaptivePlatformDensity),
      debugShowCheckedModeBanner: false,
      title: 'Rumah Sampah',
      // initialRoute: idUser == ''
      //     ? roleUser == 'user'
      //         ? Routes.HOME
      //         : Routes.DASHBOARD
      //     : Routes.WELCOME,
      // initialRoute: Routes.LOGIN,
      defaultTransition: Transition.cupertino,
      getPages: AppPages.routes,
      home: StreamBuilder(
          stream: authC.streamAuthStatus,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              if (roleUser == 'user') {
                Get.put(HomeController());
                return HomeView();
              }
              Get.put(DashboardController());
              return DashboardView();
            } else {
              Get.put(WelcomeController());
              return WelcomeView();
            }
            // var data = snapshot.data;
            // authC.userData = UserData.fromSnapshot(data!);
            // print(authC.userData.toString());
          }),
    ),
  );
  print('::::$roleUser');
  print('::::$idUser');
  //   StreamBuilder(
  //     stream: authC
  //     builder: (context, snapshot) {
  //

  //       if (snapshot.connectionState == ConnectionState.waiting) {
  //         return CircularProgressIndicator();
  //       }

  //       // if (!snapshot.hasData || !snapshot.data!.exists) {
  //       //   return Text('Dokumen tidak ditemukan');
  //       // }
  //       return GetMaterialApp(
  //         theme: ThemeData(visualDensity: VisualDensity.adaptivePlatformDensity),
  //         debugShowCheckedModeBanner: false,
  //         title: 'Rumah Sampah',
  //         initialRoute: idUser == ""
  //             ? roleUser == 'user'
  //                 ? Routes.HOME
  //                 : Routes.DASHBOARD
  //             : Routes.WELCOME,
  //         // initialRoute: PreferenceService.getFirst() != 'untrue'
  //         //     ? Routes.ONBOARD
  //         //     : PreferenceService.getStatus() != 'logged'
  //         //         ? Routes.LOGIN
  //         //         : Routes.HOME,
  //         // initialRoute: Routes.HOME,
  //         defaultTransition: Transition.cupertino,
  //         getPages: AppPages.routes,
  //       );
  //     },
  //   ),
  // );
}
