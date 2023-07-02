import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'dart:developer';

enum ReportUserMode { LIST, DETAIL, DETAIL_DATA }

class ReportController extends GetxController {
  var reportUserMode = Rx(ReportUserMode.LIST);
  var laporanPesanan = {}.obs;
  var indexDataDetail = 0.obs;
  var indexBulanDetail = "".obs;
  var detailPesanan = <DocumentSnapshot>[].obs;

  Stream<List<QueryDocumentSnapshot>> getPesananUserStream(String userId) {
    return FirebaseFirestore.instance.collection('user').doc(userId).collection('pesanan').where('status', isEqualTo: '5').where('jenis', isEqualTo: indexDataDetail.value == 1 ? 'tukar' : 'beli').snapshots().map((snapshot) {
      // log("$userId = ${snapshot.docs.length}");
      return snapshot.docs;
    });
  }

  Future<void> getAllPesanan() async {
    laporanPesanan.clear();
    QuerySnapshot userSnapshot = await FirebaseFirestore.instance.collection('user').get();

    Map<String, List<DocumentSnapshot>> laporanPesananMap = {};
    laporanPesananMap.clear();
    for (DocumentSnapshot userDoc in userSnapshot.docs) {
      List<QueryDocumentSnapshot> pesananUser = await getPesananUserStream(userDoc.id).first;

      for (QueryDocumentSnapshot pesananDoc in pesananUser) {
        DateTime tanggal = DateFormat("dd-MM-yyyy").parse((pesananDoc.data() as Map<String, dynamic>)['tanggal']);
        String bulan = DateFormat('MMMM yyyy', 'id_ID').format(tanggal);

        if (!laporanPesananMap.containsKey(bulan)) {
          laporanPesananMap[bulan] = [];
        }

        laporanPesananMap[bulan]!.add(pesananDoc);
      }
    }
    laporanPesanan.assignAll(laporanPesananMap);
    // laporanPesanan.value = laporanPesananMap;
  }

  String formatDate(DateTime date) {
    return DateFormat('dd-MM-yyyy').format(date);
  }

  @override
  void onInit() {
    getAllPesanan();
    super.onInit();
  }

  Future<void> onRefresh() {
    // Lakukan operasi refresh yang diperlukan, seperti mengambil ulang data dari Firestore
    // atau melakukan tindakan lain yang sesuai dengan kebutuhan Anda

    // Contoh: mengambil ulang data dengan memanggil metode getData()
    return getAllPesanan().then((_) {
      // Refresh berhasil, tidak perlu mengembalikan nilai
    }).catchError((error) {
      // Meng-handle error jika terjadi
      print('Error: $error');
    });
  }
}
