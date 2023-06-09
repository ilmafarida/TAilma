import 'package:get/get.dart';
import 'package:rumah_sampah_t_a/app/modules/admin/report/report_binding.dart';
import 'package:rumah_sampah_t_a/app/modules/admin/report/report_view.dart';

import '../modules/admin/penukaran/penukaran_binding.dart';
import '../modules/admin/penukaran/penukaran_view.dart';
import '../modules/admin/pesanan/pesanan_binding.dart';
import '../modules/admin/pesanan/pesanan_view.dart';
import '../modules/admin/product/product_binding.dart';
import '../modules/admin/product/product_view.dart';
import '../modules/admin/sampah/sampah_binding.dart';
import '../modules/admin/sampah/sampah_view.dart';
import '../modules/admin/verifikasi_akun/verifikasi_akun_binding.dart';
import '../modules/admin/verifikasi_akun/verifikasi_akun_view.dart';
import '../modules/akun_terverifikasi/bindings/akun_terverifikasi_binding.dart';
import '../modules/akun_terverifikasi/views/akun_terverifikasi_view.dart';
import '../modules/antrian/antrian_binding.dart';
import '../modules/antrian/antrian_view.dart';
import '../modules/change_password/change_password_binding.dart';
import '../modules/change_password/change_password_view.dart';
import '../modules/dashboard/dashboard_binding.dart';
import '../modules/dashboard/dashboard_view.dart';
import '../modules/ganti_password/ganti_password_binding.dart';
import '../modules/ganti_password/ganti_password_view.dart';
import '../modules/home/home_binding.dart';
import '../modules/home/home_view.dart';
import '../modules/keranjang/keranjang_binding.dart';
import '../modules/keranjang/keranjang_view.dart';
import '../modules/login/login_binding.dart';
import '../modules/login/login_view.dart';
import '../modules/lupa_password/lupa_password_binding.dart';
import '../modules/lupa_password/lupa_password_view.dart';
import '../modules/produk/produk_binding.dart';
import '../modules/produk/produk_view.dart';
import '../modules/profile/profile_binding.dart';
import '../modules/profile/profile_view.dart';
import '../modules/riwayat/riwayat_binding.dart';
import '../modules/riwayat/riwayat_view.dart';
import '../modules/signup/signup_binding.dart';
import '../modules/signup/signup_view.dart';
import '../modules/tukarsampah/tukarsampah_binding.dart';
import '../modules/tukarsampah/tukarsampah_view.dart';
import '../modules/ubah_alamat/ubah_alamat_binding.dart';
import '../modules/ubah_alamat/ubah_alamat_view.dart';
import '../modules/waiting/waiting_binding.dart';
import '../modules/waiting/waiting_view.dart';
import '../modules/welcome/welcome_binding.dart';
import '../modules/welcome/welcome_view.dart';

// ignore_for_file: prefer_const_constructors

part 'app_routes.dart';

class AppPages {
  AppPages._();

  // ignore: ant_identifier_names
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
      page: () => WelcomeView(),
      binding: WelcomeBinding(),
    ),
    GetPage(
      name: _Paths.DASHBOARD,
      page: () => DashboardView(),
      binding: DashboardBinding(),
    ),
    GetPage(
      name: _Paths.PRODUK,
      page: () => ProdukView(),
      binding: ProdukBinding(),
    ),
    GetPage(
      name: _Paths.TUKARSAMPAH,
      page: () => TukarSampahView(),
      binding: TukarSampahBinding(),
    ),
    GetPage(
      name: _Paths.RIWAYAT,
      page: () => RiwayatView(),
      binding: RiwayatBinding(),
    ),
    GetPage(
      name: _Paths.WAITING,
      page: () => WaitingView(),
      binding: WaitingBinding(),
    ),
    GetPage(
      name: _Paths.LUPA_PASSWORD,
      page: () => LupaPasswordView(),
      binding: LupaPasswordBinding(),
    ),
    GetPage(
      name: _Paths.GANTI_PASSWORD,
      page: () => GantiPasswordView(),
      binding: GantiPasswordBinding(),
    ),
    GetPage(
      name: _Paths.PROFILE,
      page: () => ProfileView(),
      binding: ProfileBinding(),
    ),
    GetPage(
      name: _Paths.CHANGE_PASSWORD,
      page: () => ChangePasswordView(),
      binding: ChangePasswordBinding(),
    ),
    GetPage(
      name: _Paths.UBAH_ALAMAT,
      page: () => UbahAlamatView(),
      binding: UbahAlamatBinding(),
    ),
    GetPage(
      name: _Paths.VERIFIKASI_AKUN,
      page: () => VerifikasiAkunView(),
      binding: VerifikasiAkunBinding(),
    ),
    GetPage(
      name: _Paths.ADMIN_PRODUCT,
      page: () => AdminProductView(),
      binding: AdminProductBinding(),
    ),
    GetPage(
      name: _Paths.ADMIN_SAMPAH,
      page: () => AdminSampahView(),
      binding: AdminSampahBinding(),
    ),
    GetPage(
      name: _Paths.KERANJANG,
      page: () => KeranjangView(),
      binding: KeranjangBinding(),
    ),
    GetPage(
      name: _Paths.ANTRIAN,
      page: () => AntrianView(),
      binding: AntrianBinding(),
    ),
    GetPage(
      name: _Paths.PESANAN,
      page: () => PesananView(),
      binding: PesananBinding(),
    ),
    GetPage(
      name: _Paths.PENUKARAN,
      page: () => PenukaranView(),
      binding: PenukaranBinding(),
    ),
    GetPage(
      name: _Paths.AKUN_TERVERIFIKASI,
      page: () => const AkunTerverifikasiView(),
      binding: AkunTerverifikasiBinding(),
    ),
    GetPage(
      name: _Paths.REPORT,
      page: () => ReportView(),
      binding: ReportBinding(),
    ),
  ];
}
