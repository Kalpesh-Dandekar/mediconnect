import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class MedicineService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  /// 🔥 GET ONLY TODAY MEDICINES (FIXED)
  Stream<QuerySnapshot> getTodayMedicines() {
    final user = _auth.currentUser;

    if (user == null) {
      throw Exception("User not logged in");
    }

    final now = DateTime.now();

    final startOfDay = DateTime(now.year, now.month, now.day);
    final endOfDay = DateTime(now.year, now.month, now.day, 23, 59, 59);

    return _firestore
        .collection("medicines")
        .where("patientId", isEqualTo: user.uid)
        .where("date", isGreaterThanOrEqualTo: Timestamp.fromDate(startOfDay))
        .where("date", isLessThanOrEqualTo: Timestamp.fromDate(endOfDay))
        .orderBy("date")
        .snapshots();
  }

  /// 🔥 UPDATE STATUS
  Future<void> updateMedicineStatus({
    required String medicineId,
    required String status,
  }) async {
    await _firestore
        .collection("medicines")
        .doc(medicineId)
        .update({"status": status});
  }

  /// 🔥 ADD MEDICINES (FIXED)
  Future<void> addMedicinesFromConsultation({
    required String patientId,
    required List<Map<String, dynamic>> prescriptions,
  }) async {

    final batch = _firestore.batch();
    final now = DateTime.now();

    for (var med in prescriptions) {

      final name = med["medicine"] ?? "";
      final duration =
          int.tryParse(med["duration"].toString()) ?? 1;

      final timings =
      List<String>.from(med["timings"] ?? []);

      for (int day = 0; day < duration; day++) {

        final date = now.add(Duration(days: day));

        for (var timing in timings) {

          final docRef = _firestore.collection("medicines").doc();

          batch.set(docRef, {
            "patientId": patientId,
            "name": name,
            "period": timing,
            "time": _getTimeFromPeriod(timing),
            "status": "pending",

            /// 🔥 IMPORTANT FIX
            "date": Timestamp.fromDate(date),

            "createdAt": FieldValue.serverTimestamp(),
          });
        }
      }
    }

    await batch.commit();
  }

  String _getTimeFromPeriod(String period) {
    switch (period) {
      case "Morning":
        return "09:00";
      case "Afternoon":
        return "14:00";
      case "Night":
        return "21:00";
      default:
        return "09:00";
    }
  }
}