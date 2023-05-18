import 'package:get/get.dart';

import '../modules/dashboard/bindings/dashboard_binding.dart';
import '../modules/dashboard/views/dashboard_view.dart';
import '../modules/home/bindings/home_binding.dart';
import '../modules/home/views/home_view.dart';
import '../modules/login/bindings/login_binding.dart';
import '../modules/login/bindings/login_binding.dart';
import '../modules/login/views/login_view.dart';
import '../modules/login/views/login_view.dart';
import '../modules/produk/bindings/produk_binding.dart';
import '../modules/produk/views/produk_view.dart';
import '../modules/riwayat/bindings/riwayat_binding.dart';
import '../modules/riwayat/views/riwayat_view.dart';
import '../modules/signup/bindings/signup_binding.dart';
import '../modules/signup/views/signup_view.dart';
import '../modules/tukarsampah/bindings/tukarsampah_binding.dart';
import '../modules/tukarsampah/views/tukarsampah_view.dart';
import '../modules/waiting/bindings/waiting_binding.dart';
import '../modules/waiting/views/waiting_view.dart';
import '../modules/welcome/bindings/welcome_binding.dart';
import '../modules/welcome/views/welcome_view.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

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
