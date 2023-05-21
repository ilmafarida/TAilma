// ignore_for_file: prefer_const_constructors
import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:rumah_sampah_t_a/app/controllers/auth_controller.dart';
import 'package:rumah_sampah_t_a/app/utils/shared_preference.dart';
import 'package:rumah_sampah_t_a/app/widgets/loading_component.dart';
import 'package:rumah_sampah_t_a/models/user_data_model.dart';
import 'firebase_options.dart';
import 'package:get/get.dart';
//import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'app/routes/app_pages.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await SharedPreference.init();
  final authC = Get.put(AuthController(), permanent: true);
  runApp(
    StreamBuilder(
        stream: authC.streamUser(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return MaterialApp(
              home: Scaffold(
                  body: Center(
                child: LoadingComponent(),
              )),
            );
          }
          // // authC.userData = UserData.fromSnapshot(snapshot.data!);

          // log('ID ${authC.userData}');
          return GetMaterialApp(
            theme: ThemeData(visualDensity: VisualDensity.adaptivePlatformDensity),
            debugShowCheckedModeBanner: false,
            title: 'Rumah Sampah',
            initialRoute: snapshot.data != null
                // ? SharedPreference.getUserRole() == 'user'
                ? authC.userData.role == 'user'
                    ? Routes.HOME
                    : Routes.DASHBOARD
                : Routes.WELCOME,
            // initialRoute: PreferenceService.getFirst() != 'untrue'
            //     ? Routes.ONBOARD
            //     : PreferenceService.getStatus() != 'logged'
            //         ? Routes.LOGIN
            //         : Routes.HOME,
            // initialRoute: Routes.HOME,
            defaultTransition: Transition.cupertino,
            getPages: AppPages.routes,
          );
        }),
  );
}
