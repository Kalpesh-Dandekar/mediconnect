import 'package:cloud_firestore/cloud_firestore.dart';

class RelativeMedicineService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// 🔥 GET TODAY MEDICINES USING PATIENT ID
  Stream<QuerySnapshot> getTodayMedicines(String patientId) {
    final now = DateTime.now();

    final startOfDay = DateTime(now.year, now.month, now.day);
    final endOfDay = DateTime(now.year, now.month, now.day, 23, 59, 59);

    return _firestore
        .collection("medicines")
        .where("patientId", isEqualTo: patientId)
        .where("date",
        isGreaterThanOrEqualTo: Timestamp.fromDate(startOfDay))
        .where("date",
        isLessThanOrEqualTo: Timestamp.fromDate(endOfDay))
        .orderBy("date")
        .snapshots();
  }
}