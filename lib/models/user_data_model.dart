// To parse this JSON data, do
//
//     final welcome = welcomeFromJson(jsonString);

import 'package:cloud_firestore/cloud_firestore.dart';

class UserData {
  String? alamat;
  String? email;
  String? fullname;
  String? kecamatan;
  String? kelurahan;
  String? ktp;
  String? password;
  String? role;
  String? status;
  String? uid;
  String? poin;
  String? sampah;
  String? nohp;

  UserData({
    this.alamat,
    this.email,
    this.fullname,
    this.kecamatan,
    this.kelurahan,
    this.ktp,
    this.password,
    this.role,
    this.status,
    this.uid,
    this.sampah,
    this.poin,
    this.nohp,
  });

  factory UserData.fromSnapshot(DocumentSnapshot json) {
    return UserData(
      alamat: json["alamat"] ?? '',
      email: json["email"] ?? '',
      fullname: json["fullname"] ?? '',
      kecamatan: json["kecamatan"] ?? '',
      kelurahan: json["kelurahan"] ?? '',
      ktp: json["ktp"] ?? '',
      password: json["password"] ?? '',
      role: json["role"] ?? '',
      status: json["status"] ?? '',
      uid: json["uid"] ?? '',
      poin: json["poin"] ?? '',
      sampah: json["sampah"] ?? '',
      nohp: json["nohp"] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "alamat": alamat,
      "email": email,
      "fullname": fullname,
      "kecamatan": kecamatan,
      "kelurahan": kelurahan,
      "ktp": ktp,
      "password": password,
      "role": role,
      "status": status,
      "uid": uid,
    };
  }

  @override
  String toString() {
    return 'alamat: $alamat, email: $email, fullname: $fullname, kecamatan: $kecamatan, kelurahan: $kelurahan, ktp: $ktp, password: $password, role: $role, status: $status, uid: $uid';
  }
}
