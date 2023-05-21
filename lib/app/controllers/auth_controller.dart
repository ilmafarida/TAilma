import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rumah_sampah_t_a/app/routes/app_pages.dart';
import 'package:rumah_sampah_t_a/app/utils/list_color.dart';
import 'package:rumah_sampah_t_a/app/utils/list_text_style.dart';
import 'package:rumah_sampah_t_a/app/utils/shared_preference.dart';
import 'package:rumah_sampah_t_a/models/user_data_model.dart';

class AuthController extends GetxController {
  FirebaseAuth auth = FirebaseAuth.instance;
  UserData userData = UserData();
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  Stream<User?> get streamAuthStatus => auth.authStateChanges();

  // void signup(String email, String password) async {
  //   try {
  //     await FirebaseAuth.instance
  //         .createUserWithEmailAndPassword(email: email, password: password);
  //     Get.offAllNamed(Routes.HOME);
  //   } on FirebaseAuthException catch (e) {
  //     if (e.code == 'weak-password') {
  //       print('The password provided is too weak.');
  //     } else if (e.code == 'email-already-in-use') {
  //       print('The account already exists for that email');
  //     }
  //   } catch (e) {
  //     print(e);
  //   }
  // }

  // void login(String email, String password) async {
  //   try {
  //     await auth.signInWithEmailAndPassword(email: email, password: password);
  //     Get.offAllNamed(Routes.HOME);
  //   } on FirebaseAuthException catch (e) {
  //     if (e.code == 'user-not-found') {
  //       print('No user found for that email.');
  //     } else if (e.code == 'wrong password') {
  //       print('Wrong password provided for that user.');
  //     }
  //   }
  // }

  Stream<DocumentSnapshot> streamUser() async* {
    String uid = auth.currentUser!.uid;
    yield* firestore.collection("user").doc(uid).snapshots();
  }

  void logout() async {
    showDialog(
      context: Get.context!,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Color(ListColor.colorButtonGray),
          insetPadding: EdgeInsets.symmetric(horizontal: 70),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          content: SizedBox(
            height: 100,
            width: 183,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Apakah kamu yakin\ningin log out?',
                  style: ListTextStyle.textStyleBlackW700.copyWith(fontSize: 15, height: 19.5 / 15),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 30),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    GestureDetector(
                      onTap: () => Get.back(),
                      child: Text(
                        'Tidak',
                        style: ListTextStyle.textStyleBlackW700.copyWith(fontSize: 15),
                      ),
                    ),
                    GestureDetector(
                      onTap: () async {
                        await FirebaseAuth.instance.signOut();
                        // await SharedPreference.clear();
                        Get.offAllNamed(Routes.LOGIN);
                      },
                      child: Text(
                        'Ya',
                        style: ListTextStyle.textStyleBlackW700.copyWith(fontSize: 15),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        );
      },
    );
  }
}
