import 'dart:developer';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as base;

class UploadComponent {
  Future getFromGallery({Rxn<File>? file, bool? isSvg = false}) async {
    XFile? pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      file!.value = File(pickedFile.path);
      log(base.basename(file.value!.path));
      return pickedFile;
    } else {
      // JIKA USER CANCEL UPLOAD
      return;
    }
  }

  Future getFromCamera({Rxn<File>? file}) async {
    XFile? pickedFile = await ImagePicker().pickImage(source: ImageSource.camera);
    if (pickedFile != null) {
      file!.value = File(pickedFile.path);
      log(base.basename(file.value!.path));
      return pickedFile;
    } else {
      // JIKA USER CANCEL UPLOAD
      return;
    }
  }

  Future<void> uploadFileToFirestore({String? uid, String? path, File? file, FirebaseFirestore? firestore, String? database, String? field}) async {
    String fileName = 'DASHBOARD - ${DateTime.now()}';
    Reference storageReference = FirebaseStorage.instance.ref().child('$path/$fileName');
    UploadTask uploadTask = storageReference.putFile(file!);
    TaskSnapshot storageSnapshot = await uploadTask.whenComplete(() {});
    String downloadUrl = await storageSnapshot.ref.getDownloadURL();
    log("DOWNLOAD :: $downloadUrl");
    // Data telah berhasil diunggah ke Firestore
    await firestore!.collection('$database').doc(uid).update({'$field': downloadUrl});
  }

  previewFile({File? file, bool? formNetwork = false}) {
    showDialog(
      context: Get.context!,
      builder: (ctx) {
        final width = ctx.width;
        final height = ctx.height;
        return AlertDialog(
          content: Stack(
            children: [
              SizedBox(
                width: width * 0.9,
                height: height * 0.7,
                child: !formNetwork!
                    ? Image.file(
                        file!,
                        fit: BoxFit.fill,
                      )
                    : Image.network(
                        file!.path,
                        fit: BoxFit.fitWidth,
                      ),
              ),
              GestureDetector(
                onTap: () => Navigator.pop(Get.context!),
                child: Padding(
                  padding: const EdgeInsets.all(3.0),
                  child: Container(
                    decoration: BoxDecoration(color: Colors.black.withOpacity(0.5), shape: BoxShape.circle),
                    child: Icon(
                      CupertinoIcons.xmark_circle,
                      color: Colors.white.withOpacity(0.9),
                      size: 40,
                    ),
                  ),
                ),
              )
            ],
          ),
          insetPadding: EdgeInsets.zero,
          contentPadding: EdgeInsets.zero,
          clipBehavior: Clip.antiAliasWithSaveLayer,
        );
      },
    );
  }
}
