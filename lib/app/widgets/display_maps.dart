import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:latlong2/latlong.dart';
import 'package:rumah_sampah_t_a/app/utils/list_text_style.dart';

import '../utils/list_color.dart';
import 'custom_submit_button.dart';

class DisplayMaps extends StatefulWidget {
  double? latitude;
  double? longitude;
  final bool isAdmin;
  String alamat;
  Timer? timer;

  DisplayMaps({
    this.latitude,
    this.longitude,
    this.isAdmin = false,
    this.alamat = "",
    this.timer,
  });

  @override
  State<DisplayMaps> createState() => _DisplayMapsState();
}

class _DisplayMapsState extends State<DisplayMaps> {
  @override
  Widget build(BuildContext context) {
    if (widget.latitude == null || widget.longitude == null) {
      getCurrentLocation().then(
        (Position value) {
          setState(() {});
          print(value);

          widget.latitude = value.latitude;
          widget.longitude = value.longitude;
        },
      );
      return Center(child: CircularProgressIndicator());
    }

    return Material(
      child: Stack(
        children: [
          FlutterMap(
            options: MapOptions(
              keepAlive: true,
              center: LatLng(widget.latitude!, widget.longitude!),
              zoom: 17.0,
              maxZoom: 18.0,
              onMapReady: () async {
                List<Placemark> placemarks = await placemarkFromCoordinates(widget.latitude!, widget.longitude!);
                setState(() {});
                widget.alamat = placemarks.first.street!;
                print('Latitude: ${widget.latitude}');
                print('Longitude: ${widget.longitude}');
                print('Address: ${widget.alamat}');
              },
              onPositionChanged: (position, hasGesture) {
                if (!widget.isAdmin) {
                  if (hasGesture) {
                    widget.timer?.cancel();
                    widget.timer = Timer(Duration(milliseconds: 1000), () async {
                      widget.latitude = position.center!.latitude;
                      widget.longitude = position.center!.longitude;
                      List<Placemark> placemarks = await placemarkFromCoordinates(widget.latitude!, widget.longitude!);
                      setState(() {});
                      widget.alamat = placemarks.first.street!;
                      print('Latitude: ${widget.latitude}');
                      print('Longitude: ${widget.longitude}');
                      print('Address: ${widget.alamat}');
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
                        point: LatLng(widget.latitude!, widget.longitude!),
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
                          widget.alamat,
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
                              'alamat': widget.alamat,
                              'lat': widget.latitude,
                              'long': widget.longitude,
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
