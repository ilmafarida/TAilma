// To parse this JSON data, do
//
//     final kecamatan = kecamatanFromJson(jsonString);

import 'dart:convert';

Kecamatan kecamatanFromJson(String str) => Kecamatan.fromJson(json.decode(str));

String kecamatanToJson(Kecamatan data) => json.encode(data.toJson());

class Kecamatan {
  String id;
  String idKabupaten;
  String name;

  Kecamatan({
    required this.id,
    required this.idKabupaten,
    required this.name,
  });

  factory Kecamatan.fromJson(Map<String, dynamic> json) => Kecamatan(
        id: json["id"],
        idKabupaten: json["id_kabupaten"],
        name: json["name"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "id_kabupaten": "3577",
        "name": name,
      };
}
