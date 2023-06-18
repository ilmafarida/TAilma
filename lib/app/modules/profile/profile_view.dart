import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rumah_sampah_t_a/app/modules/profile/profile_controller.dart';
import 'package:rumah_sampah_t_a/app/utils/list_text_style.dart';
import '../../routes/app_pages.dart';

class ProfileView extends GetView<ProfileController> {
  const ProfileView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: SafeArea(
        child: Scaffold(
          backgroundColor: Colors.white,
          body: Container(
              margin: EdgeInsets.all(20),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _backButton(),
                    _cardProfile(),
                    _listProfile(),
                  ],
                ),
              )),
        ),
      ),
    );
  }

  Widget _backButton() {
    return InkWell(
      onTap: () => Get.back(),
      child: Icon(
        Icons.arrow_back_ios,
        size: 18,
      ),
    );
  }

  Widget _cardProfile() {
    return Container(
      margin: EdgeInsets.only(top: 50),
      width: double.infinity,
      padding: EdgeInsets.all(10),
      height: 127,
      decoration: BoxDecoration(
        color: Color(0xFFEAEAEA),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            '${controller.authC.userData.fullname}',
            style: ListTextStyle.textStyleBlackW700,
          ),
          SizedBox(height: 10),
          Text(
            '${controller.authC.userData.poin} Poin',
            style: ListTextStyle.textStyleGreenW500,
          ),
        ],
      ),
    );
  }

  Widget _listProfile() {
    return Padding(
      padding: EdgeInsets.only(top: 50),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _listProfileContent(title: 'Email', value: '${controller.authC.userData.email}'),
          _listProfileContent(title: 'Alamat', value: '${controller.authC.userData.alamat}', isCanTap: true, onTap: () => Get.toNamed(Routes.UBAH_ALAMAT)),
          _listProfileContent(title: 'No Hp', value: '${controller.authC.userData.nohp}'),
          _listProfileContent(title: 'Pengaturan Akun', value: '', isCanTap: true, onTap: () => Get.toNamed(Routes.CHANGE_PASSWORD)),
          _listProfileContent(title: 'Logout', isLogout: true, onTap: () => controller.authC.logout()),
        ],
      ),
    );
  }

  Widget _listProfileContent({bool? isLogout = false, String? title, String? value, bool? isCanTap = false, VoidCallback? onTap}) {
    return Padding(
      padding: EdgeInsets.only(bottom: 20),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            width: 100,
            child: GestureDetector(
              onTap: (isLogout!) ? onTap : null,
              child: Text(
                title!,
                style: ListTextStyle.textStyleBlackW700.copyWith(fontSize: 15, color: isLogout ? Colors.red : Color(0xFF1E232C)),
              ),
            ),
          ),
          if (value != null)
            Expanded(
              child: Padding(
                padding: EdgeInsets.only(left: 10),
                child: SizedBox(
                  child: Text(
                    value,
                    style: ListTextStyle.textStyleBlackW700.copyWith(fontSize: 15, fontWeight: FontWeight.w500),
                    maxLines: 3,
                  ),
                ),
              ),
            ),
          if (isCanTap!) ...[
            // Spacer(),
            Align(
              alignment: Alignment.centerRight,
              child: SizedBox(
                width: 15,
                child: Expanded(
                  child: GestureDetector(
                    onTap: onTap,
                    child: Icon(Icons.arrow_forward_ios_rounded, size: 14),
                  ),
                ),
              ),
            ),
          ]
        ],
      ),
    );
  }
}
