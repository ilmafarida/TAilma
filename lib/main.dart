// import 'dart:html';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:rumah_sampah_t_a/app/controllers/auth_controller.dart';
import 'package:rumah_sampah_t_a/app/utils/loading.dart';
import 'firebase_options.dart';
import 'package:get/get.dart';
//import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'app/routes/app_pages.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  // runApp(StreamBuilder<User?>(
  //   stream: FirebaseAuth.instance.authStateChanges(),
  //   builder: (context, snapshot) {
  //     if (snapshot.connectionState == ConnectionState.waiting) {
  //       return MaterialApp(
  //         home: Scaffold(
  //           body: Center(
  //             child: CircularProgressIndicator(),
  //           ),
  //         ),
  //       );
  //     }
  //     return GetMaterialApp(
  //       title: "Application",
  //       initialRoute: snapshot.data != null ? Routes.HOME : Routes.LOGIN,
  //       getPages: AppPages.routes,
  //     );
  //   },
  // ));
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final authC = Get.put(AuthController(), permanent: true);
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: authC.streamAuthStatus,
      builder: (context, snapshot) {
        // ignore: avoid_print
        print(snapshot.data);
        if (snapshot.connectionState == ConnectionState.active) {
          return GetMaterialApp(
            title: "Application",
            // initialRoute: snapshot.data != null ? Routes.HOME : Routes.LOGIN,
            initialRoute: Routes.SIGNUP,
            getPages: AppPages.routes,
            //home:  snapshot.data != null ? HomeView() : LoginView(),
          );
        }
        return const LoadingView();
      },
    );
  }
}
