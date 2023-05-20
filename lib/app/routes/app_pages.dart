import 'package:get/get.dart';

import '../modules/dashboard/dashboard_binding.dart';
import '../modules/dashboard/dashboard_view.dart';
import '../modules/home/home_binding.dart';
import '../modules/home/home_view.dart';
import '../modules/login/login_binding.dart';
import '../modules/login/login_view.dart';
import '../modules/produk/produk_binding.dart';
import '../modules/produk/produk_view.dart';
import '../modules/riwayat/riwayat_binding.dart';
import '../modules/riwayat/riwayat_view.dart';
import '../modules/signup/signup_binding.dart';
import '../modules/signup/signup_view.dart';
import '../modules/tukarsampah/tukarsampah_binding.dart';
import '../modules/tukarsampah/tukarsampah_view.dart';
import '../modules/waiting/waiting_binding.dart';
import '../modules/waiting/waiting_view.dart';
import '../modules/welcome/welcome_binding.dart';
import '../modules/welcome/welcome_view.dart';



part 'app_routes.dart';

class AppPages {
  AppPages._();

  // ignore: constant_identifier_names
  static const INITIAL = Routes.HOME;

  static final routes = [
    GetPage(
      name: _Paths.HOME,
      page: () => HomeView(),
      binding: HomeBinding(),
    ),
    GetPage(
      name: _Paths.LOGIN,
      page: () => LoginView(),
      binding: LoginBinding(),
      // children: [
      //   GetPage(
      //     name: _Paths.LOGIN,
      //     page: () => LoginView(),
      //     binding: LoginBinding(),
      //   ),
      // ],
    ),
    GetPage(
      name: _Paths.SIGNUP,
      page: () => SignupView(),
      binding: SignupBinding(),
    ),
    GetPage(
      name: _Paths.WELCOME,
      page: () => const WelcomeView(),
      binding: WelcomeBinding(),
    ),
    GetPage(
      name: _Paths.DASHBOARD,
      page: () => DashboardView(),
      binding: DashboardBinding(),
    ),
    GetPage(
      name: _Paths.PRODUK,
      page: () => const ProdukView(),
      binding: ProdukBinding(),
    ),
    GetPage(
      name: _Paths.TUKARSAMPAH,
      page: () => const TukarsampahView(),
      binding: TukarsampahBinding(),
    ),
    GetPage(
      name: _Paths.RIWAYAT,
      page: () => const RiwayatView(),
      binding: RiwayatBinding(),
    ),
    GetPage(
      name: _Paths.WAITING,
      page: () => const WaitingView(),
      binding: WaitingBinding(),
    ),
  ];
}
