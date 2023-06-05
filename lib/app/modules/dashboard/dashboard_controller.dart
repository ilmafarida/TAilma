import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DashboardController extends GetxController {
  final _firestore = FirebaseFirestore.instance;
  var jumlahPesanan = Rxn();
  var jumlahPenukaran = Rxn();

  @override
  void onInit() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      buildOrderCountWidget();
    });
    super.onInit();
  }

  StreamBuilder<QuerySnapshot<Map<String, dynamic>>> buildOrderCountWidget() {
    return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
      stream: _firestore.collection('user').snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
        if (snapshot.hasError) {
          return SizedBox.shrink();
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return SizedBox.shrink();
        }

        calculateOrderCounts(snapshot.data!.docs);

        return SizedBox.shrink();
      },
    );
  }

  void calculateOrderCounts(List<QueryDocumentSnapshot<Map<String, dynamic>>> userDocs) {
    int tukarCount = 0;
    int beliCount = 0;

    for (var userDoc in userDocs) {
      Stream<QuerySnapshot<Map<String, dynamic>>> antrianStream = _firestore.collection('user').doc(userDoc.id).collection('pesanan').where('jenis', isEqualTo: 'tukar').where('status', isEqualTo: '1').snapshots();
      Stream<QuerySnapshot<Map<String, dynamic>>> pesananStream = _firestore.collection('user').doc(userDoc.id).collection('pesanan').where('jenis', isEqualTo: 'beli').where('status', isEqualTo: '1').snapshots();
      antrianStream.listen(
        (QuerySnapshot<Map<String, dynamic>> antrianSnapshot) {
          tukarCount += antrianSnapshot.docs.length;
          jumlahPenukaran.value = tukarCount;
        },
        onDone: () {
          if (jumlahPenukaran.value != tukarCount) jumlahPenukaran.value = tukarCount;
        },
      );
      pesananStream.listen(
        (QuerySnapshot<Map<String, dynamic>> pesananSnapshot) {
          beliCount += pesananSnapshot.docs.length;
          jumlahPesanan.value = beliCount;
        },
        onDone: () {
          if (jumlahPesanan.value != beliCount) jumlahPesanan.value = beliCount;
        },
      );
    }
  }
}
