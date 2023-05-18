// To parse this JSON data, do
//
//     final kelurahan = kelurahanFromJson(jsonString);

import 'dart:convert';

Kelurahan kelurahanFromJson(String str) => Kelurahan.fromJson(json.decode(str));

String kelurahanToJson(Kelurahan data) => json.encode(data.toJson());

class Kelurahan {
  String id;
  String idKecamatan;
  String name;

  Kelurahan({
    required this.id,
    required this.idKecamatan,
    required this.name,
  });

  factory Kelurahan.fromJson(Map<String, dynamic> json) => Kelurahan(
        id: json["id"],
        idKecamatan: json["id_kecamatan"],
        name: json["name"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "id_kecamatan": idKecamatan,
        "name": name,
      };
}
