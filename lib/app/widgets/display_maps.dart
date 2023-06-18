import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:latlong2/latlong.dart';
import 'package:rumah_sampah_t_a/app/utils/list_color.dart';
import 'package:rumah_sampah_t_a/app/utils/list_text_style.dart';
import 'package:rumah_sampah_t_a/app/utils/utils.dart';
import 'package:rumah_sampah_t_a/app/widgets/custom_submit_button.dart';

class DisplayMaps extends StatefulWidget {
  double? latitude;
  double? longitude;
  bool isAdmin;

  DisplayMaps({
    this.latitude,
    this.longitude,
    this.isAdmin = false,
  });

  @override
  State<DisplayMaps> createState() => _DisplayMapsState();
}

class _DisplayMapsState extends State<DisplayMaps> {
  String alamat = "";
  late double latitude;
  late double longitude;
  Timer? _debounceTimer;

  final Duration _debounceDuration = Duration(milliseconds: 500);

  @override
  void initState() {
    super.initState();
    if (widget.latitude != null && widget.longitude != null) {
      latitude = widget.latitude!;
      longitude = widget.longitude!;
    } else {
      latitude = Utils().centerMadiun.latitude;
      longitude = Utils().centerMadiun.longitude;
    }
    _debounceTimer = Timer(_debounceDuration, () {});
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Stack(
        children: [
          FlutterMap(
            options: MapOptions(
              // keepAlive: true,
              center: LatLng(latitude, longitude),
              zoom: 17.0,
              maxZoom: 18.0,
              onPositionChanged: (position, hasGesture) async {
                if (!widget.isAdmin) {
                  if (hasGesture) {
                    _debounceTimer!.cancel();
                    // Mulai timer baru
                    _debounceTimer = Timer(_debounceDuration, () async {
                      setState(() {});
                      latitude = position.center!.latitude;
                      longitude = position.center!.longitude;
                      // Dapatkan alamat berdasarkan lat-long
                      List<Placemark> placemarks = await placemarkFromCoordinates(latitude, longitude);
                      // print(placemarks);
                      alamat = placemarks.first.street ?? placemarks.first.thoroughfare!;
                      // Jika alamat tidak tersedia, Anda dapat menggunakan komponen lain seperti `locality`, `postalCode`, dll.
                      // Gunakan latitude, longitude, dan alamat yang didapat sesuai kebutuhan Anda
                      print('Latitude: $latitude');
                      print('Longitude: $longitude');
                      print('Address: $alamat');
                    });
                  }
                }
              },
            ),
            nonRotatedChildren: [
              TileLayer(
                urlTemplate: "https://{s}.google.com/vt/lyrs=m&x={x}&y={y}&z={z}",
                subdomains: ['mt0', 'mt1', 'mt2', 'mt3'],
              ),
              if (widget.isAdmin)
                MarkerLayer(
                  markers: [
                    Marker(
                        point: LatLng(latitude, longitude),
                        builder: (context) {
                          return Icon(
                            Icons.location_on_rounded,
                            color: Color(ListColor.colorButtonGreen),
                            size: 40,
                          );
                        })
                  ],
                )
            ],
          ),
          if (!widget.isAdmin)
            Align(
              alignment: Alignment.center,
              child: Icon(
                Icons.location_on_rounded,
                color: Color(ListColor.colorButtonGreen),
                size: 40,
              ),
            ),
          if (!widget.isAdmin)
            Padding(
              padding: EdgeInsets.symmetric(vertical: 15, horizontal: 10),
              child: Align(
                alignment: Alignment.bottomCenter,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Material(
                      elevation: 1,
                      borderRadius: BorderRadius.circular(10),
                      child: Container(
                        padding: EdgeInsets.all(10),
                        width: Get.width,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          alamat,
                          style: ListTextStyle.textStyleBlackW700.copyWith(fontSize: 14),
                        ),
                      ),
                    ),
                    SizedBox(height: 10),
                    Align(
                      alignment: Alignment.center,
                      child: CustomSubmitButton(
                        onTap: () async {
                          Get.back(
                            result: {
                              'alamat': alamat,
                              'lat': latitude,
                              'long': longitude,
                            },
                          );
                        },
                        text: 'Simpan',
                        width: 100,
                      ),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}

Future<Position> getCurrentLocation() async {
  bool serviceEnabled;
  LocationPermission permission;

  // Memeriksa apakah layanan lokasi diaktifkan
  serviceEnabled = await Geolocator.isLocationServiceEnabled();
  if (!serviceEnabled) {
    // Layanan lokasi tidak diaktifkan, lakukan penanganan yang sesuai
    return Future.error('Layanan lokasi tidak diaktifkan');
  }

  // Memeriksa izin lokasi pengguna
  permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.denied) {
    // Izin lokasi ditolak, minta izin kepada pengguna
    permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {
      // Izin lokasi ditolak, lakukan penanganan yang sesuai
      return Future.error('Izin lokasi ditolak');
    }
  }

  // Mendapatkan posisi saat ini
  return await Geolocator.getCurrentPosition();
}
