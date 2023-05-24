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
  User? get currentUser => auth.currentUser;
  Stream<User?> get streamAuthStatus => auth.authStateChanges();

  var dataKeranjang = Rxn<List<Map<String, dynamic>>>();
  @override
  Future<void> onInit() async {
    print('KERANJANG : $dataKeranjang');
    super.onInit();
  }

  @override
  void onClose() {
    super.onClose();
  }

  Stream<DocumentSnapshot> streamUser() {
    String uid = auth.currentUser!.uid;
    return firestore.collection("user").doc(uid).snapshots();
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
                        await SharedPreference.clear();
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
