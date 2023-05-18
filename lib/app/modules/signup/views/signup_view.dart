import 'dart:convert';

import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rumah_sampah_t_a/app/controllers/auth_controller.dart';
// import 'package:rumah_sampah_t_a/models/kecamatan.dart';
import '../../../routes/app_pages.dart';
import '../controllers/signup_controller.dart';
import 'package:http/http.dart' as http;
import '../../../../models/kelurahan.dart';
import '../../../../models/kecamatan.dart';

class SignupView extends GetView<SignupController> {
  final authC = Get.find<AuthController>();
  // final String apiKey =
  //     "d544ff38a1eec00be9cfd3e5d0cbc3a9f5009a00cfba87c2d2fc23acf1fabd7c";
  // String? idKec;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        padding: EdgeInsets.all(25),
        children: <Widget>[
          Padding(padding: EdgeInsets.all(25)),
          Column(mainAxisAlignment: MainAxisAlignment.start, children: [
            Text(
              "Yuk Mulai Aksi Kamu!",
              style: TextStyle(
                  color: Color(0xFF1E232C),
                  fontFamily: 'Urbanist',
                  fontSize: 24,
                  fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text(
              "Silakan isi data terlebih dahulu sebelum memulai aksi kamu ya...",
              style: TextStyle(
                  color: Color(0xFF1E232C),
                  fontFamily: 'Urbanist',
                  fontSize: 15),
            ),
            SizedBox(height: 20),
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: Color(0xFFF7F8F9)),
              child: TextField(
                controller: controller.emailC,
                cursorColor: Colors.black,
                decoration: InputDecoration(
                    border: new OutlineInputBorder(
                        borderSide: BorderSide(color: Color(0xFF569F00))),
                    hintText: "Email : sampah@gmail.com",
                    hintStyle: TextStyle(
                      color: Color(0xFF8391A1),
                      fontFamily: 'Urbanist',
                      fontSize: 15,
                    ),
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 16, vertical: 17)),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Container(
                width: double.infinity,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: Color(0xFFF7F8F9)),
                child: Obx(
                  () => TextField(
                    obscureText: controller.isPasswordHidden.value,
                    controller: controller.passwordC,
                    cursorColor: Colors.black,
                    decoration: InputDecoration(
                      border: new OutlineInputBorder(
                          borderSide: BorderSide(color: Color(0xFF569F00))),
                      hintText: "Password : 123456",
                      hintStyle: TextStyle(
                        color: Color(0xFF8391A1),
                        fontFamily: 'Urbanist',
                        fontSize: 15,
                      ),
                      suffix: InkWell(
                        child: Icon(
                          controller.isPasswordHidden.value
                              ? Icons.visibility
                              : Icons.visibility_off,
                          color: Colors.grey,
                          size: 20,
                        ),
                        onTap: () {
                          controller.isPasswordHidden.value =
                              !controller.isPasswordHidden.value;
                        },
                      ),
                      contentPadding:
                          EdgeInsets.symmetric(horizontal: 16, vertical: 17),
                    ),
                  ),
                )),
            SizedBox(
              height: 10,
            ),
            SizedBox(
              height: 10,
            ),
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: Color(0xFFF7F8F9)),
              child: TextField(
                controller: controller.fullnameC,
                cursorColor: Colors.black,
                decoration: InputDecoration(
                    border: new OutlineInputBorder(
                        borderSide: BorderSide(color: Color(0xFF569F00))),
                    hintText: "Nama Lengkap",
                    hintStyle: TextStyle(
                      color: Color(0xFF8391A1),
                      fontFamily: 'Urbanist',
                      fontSize: 15,
                    ),
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 16, vertical: 17)),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              "Kota Madiun,",
              style: TextStyle(
                  color: Color(0xFF1E232C),
                  fontFamily: 'Urbanist',
                  fontSize: 20,
                  fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            // DropdownSearch<String>(
            //     popupProps: PopupProps.menu(
            //       showSelectedItems: true,
            //       disabledItemFn: (String s) => s.startsWith('I'),
            //     ),
            //     items: ["Kartoharjo", "Manguharjo", "Taman"],
            //     dropdownDecoratorProps: DropDownDecoratorProps(
            //       dropdownSearchDecoration: InputDecoration(
            //         hintText: "Pilih kecamatanmu..",
            //       ),
            //     ),
            //     onChanged: print),
            // SizedBox(height: 10),
            // DropdownSearch<String>(
            //     popupProps: PopupProps.menu(
            //       showSelectedItems: true,
            //       disabledItemFn: (String s) => s.startsWith('I'),
            //     ),
            //     items: ["Kartoharjo", "Manguharjo", "Taman"],
            //     dropdownDecoratorProps: DropDownDecoratorProps(
            //       dropdownSearchDecoration: InputDecoration(
            //         hintText: "Pilih kelurahanmu..",
            //       ),
            //     ),
            //     onChanged: print),
            // DropdownSearch<String>(
            //   popupProps: PopupProps.menu(
            //       // itemBuilder: (context, item, isSelected) => ListTile(
            //       //   title: Text(item.name),
            //       // ),
            //       //showSelectedItems: true,
            //       ),
            //   dropdownDecoratorProps: DropDownDecoratorProps(
            //     dropdownSearchDecoration: InputDecoration(
            //       hintText: "Kecamatan",
            //     ),
            //   ),
            //   onChanged: (value) => print(value),
            // dropdownBuilder: (context, selectedItem) =>
            //     Text(selectedItem?.name ?? ""),
            // asyncItems: (text) async {
            //   var response = await http.get(Uri.parse(
            //       "https://api.binderbyte.com/wilayah/kecamatan?api_key=$apiKey&id_kabupaten=3577"));
            //   if (response.statusCode != 200) {
            //     return [];
            //   }
            //   List allKecamatan = (json.decode(response.body)
            //       as Map<String, dynamic>)["value"];
            //   List<String> allNameKecamatan = [];

            //   allKecamatan.forEach((element) {
            //     allNameKecamatan.add(element["name"]);
            //     // Kecamatan(
            //   id: element["id"],
            //   idKabupaten: element["idKabupaten"],
            //   name: element["name"]));
            //     });
            //     return allNameKecamatan;
            //   },
            // ),
            // SizedBox(height: 10),
            // DropdownSearch<Kelurahan>(
            //   popupProps: PopupProps.dialog(
            //     itemBuilder: (context, item, isSelected) => ListTile(
            //       title: Text(item.name),
            //     ),
            //showSelectedItems: true,
            //   ),
            //   dropdownDecoratorProps: DropDownDecoratorProps(
            //     dropdownSearchDecoration: InputDecoration(
            //       hintText: "Kecamatan",
            //     ),
            //   ),
            //   onChanged: (value) => idKec = value?.id,
            //   dropdownBuilder: (context, selectedItem) =>
            //       Text(selectedItem?.name ?? ""),
            //   asyncItems: (text) async {
            //     var response = await http.get(Uri.parse(
            //         "https://api.binderbyte.com/wilayah/kelurahan?api_key=$apiKey&id_kecamatan=$idKec"));
            //     if (response.statusCode != 200) {
            //       return [];
            //     }
            //     List allKelurahan = (json.decode(response.body)
            //         as Map<String, dynamic>)["value"];
            //     List<Kelurahan> allModelKelurahan = [];

            //     allKelurahan.forEach((element) {
            //       allModelKelurahan.add(Kelurahan(
            //           id: element["id"],
            //           idKecamatan: element["idKecamatan"],
            //           name: element["name"]));
            //     });
            //     return allModelKelurahan;
            //   },
            // ),
            SizedBox(height: 10),
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: Color(0xFFF7F8F9)),
              child: DropdownSearch<String>(
                  popupProps: PopupProps.menu(
                    showSelectedItems: true,
                    disabledItemFn: (String s) => s.startsWith('I'),
                  ),
                  items: ["Kartoharjo", "Manguharjo", "Taman"],
                  dropdownDecoratorProps: DropDownDecoratorProps(
                    dropdownSearchDecoration: InputDecoration(
                      hintText: "Pilih kecamatanmu..",
                    ),
                  ),
                  onChanged: print),
            ),
            SizedBox(
              height: 10,
            ),
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: Color(0xFFF7F8F9)),
              child: DropdownSearch<String>(
                  popupProps: PopupProps.menu(
                    showSelectedItems: true,
                    disabledItemFn: (String s) => s.startsWith('I'),
                  ),
                  items: [
                    "Kanigoro",
                    "Kelun",
                    "Kartoharjo",
                    "Klegen",
                    "Oro-Oro Ombo",
                    "Pilangbango",
                    "Rejomulyo",
                    "Sukosari",
                    "Tawangrejo",
                    "Madiun Lor",
                    "Manguharjo",
                    "Nambangan Lor",
                    "Nambangan Kidul",
                    "Ngegong",
                    "Pangongangan",
                    "Patihan",
                    "Sogaten",
                    "Winongo",
                    "Banjarejo",
                    "Demangan",
                    "Josenan",
                    "Kejuron",
                    "Kuncen",
                    "Mojorejo",
                    "Manisrejo",
                    "Pandean",
                    "Taman"
                  ],
                  dropdownDecoratorProps: DropDownDecoratorProps(
                    dropdownSearchDecoration: InputDecoration(
                      hintText: "Pilih kelurahanmu..",
                    ),
                  ),
                  onChanged: print),
            ),
            SizedBox(
              height: 10,
            ),
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: Color(0xFFF7F8F9)),
              child: TextField(
                controller: controller.alamatC,
                cursorColor: Colors.black,
                decoration: InputDecoration(
                    border: new OutlineInputBorder(
                        borderSide: BorderSide(color: Color(0xFF569F00))),
                    hintText: "Alamat",
                    hintStyle: TextStyle(
                      color: Color(0xFF8391A1),
                      fontFamily: 'Urbanist',
                      fontSize: 15,
                    ),
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 16, vertical: 17)),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: Color(0xFFF7F8F9)),
              child: TextField(
                controller: controller.ktpC,
                cursorColor: Colors.black,
                decoration: InputDecoration(
                    border: new OutlineInputBorder(
                        borderSide: BorderSide(color: Color(0xFF569F00))),
                    hintText: "Upload KTP",
                    hintStyle: TextStyle(
                      color: Color(0xFF8391A1),
                      fontFamily: 'Urbanist',
                      fontSize: 15,
                    ),
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 16, vertical: 17)),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Container(
              width: double.infinity,
              height: 40,
              child: ElevatedButton(
                  onPressed: () {
                    controller.Signup();
                  },
                  child: Text(
                    "Registrasi",
                    style: TextStyle(
                        color: Colors.white,
                        fontFamily: 'Urbanist',
                        fontSize: 15),
                  ),
                  style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all<Color>(Color(0xFF569F00)))),
            ),
            SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("Sudah punya akun? ",
                    style: TextStyle(
                        color: Color(0xFF24282C),
                        fontFamily: 'Urbanist',
                        fontSize: 13,
                        fontWeight: FontWeight.bold)),
                TextButton(
                    onPressed: () => Get.toNamed(Routes.LOGIN),
                    child: Text("Login Sekarang!",
                        style: TextStyle(
                            color: Color(0xFF569F00),
                            fontFamily: 'Urbanist',
                            fontSize: 13,
                            fontWeight: FontWeight.bold)))
              ],
            )
          ])
        ],
      ),
      // body: Padding(
      //   padding: const EdgeInsets.all(25),
      //   child: Column(
      //     children: [
      //       TextField(
      //         controller: controller.emailC,
      //         decoration: InputDecoration(labelText: "Email"),
      //       ),
      //       TextField(
      //         controller: controller.passwordC,
      //         decoration: InputDecoration(labelText: "Password"),
      //       ),
      //       SizedBox(
      //         height: 50,
      //       ),
      //       ElevatedButton(
      //           onPressed: () => authC.signup(
      //               controller.emailC.text, controller.passwordC.text),
      //           child: Text("DAFTAR")),
      //       SizedBox(
      //         height: 10,
      //       ),
      //       Row(
      //         mainAxisAlignment: MainAxisAlignment.center,
      //         children: [
      //           Text("Sudah punya akun?"),
      //           TextButton(
      //               onPressed: () => Get.back(),
      //               child: Text("LOGIN SEKARANG"))
      //         ],
      //       )
      //     ],
      //   ),
      // )
    );
  }
}
