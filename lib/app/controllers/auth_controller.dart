import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:rumah_sampah_t_a/app/routes/app_pages.dart';

class AuthController extends GetxController {
  FirebaseAuth auth = FirebaseAuth.instance;

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

  void logout() async {
    await FirebaseAuth.instance.signOut();
    Get.offAllNamed(Routes.LOGIN);
  }
}
