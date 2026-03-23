import 'package:cloud_firestore/cloud_firestore.dart';

class StaffReportService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// 🔥 STREAM REPORTS
  Stream<QuerySnapshot> getReports() {
    return _firestore
        .collection("reports")
        .orderBy("createdAt", descending: true)
        .snapshots();
  }

  /// 🔥 UPLOAD REPORT WITH SUMMARY
  Future<void> uploadReport({
    required String patientId,
    required String testName,
    required String collectedDate,
    required String labName,
    required String resultSummary,
  }) async {
    await _firestore.collection("reports").add({
      "patientId": patientId,
      "testName": testName,
      "givenOn": collectedDate,
      "uploadedOn": DateTime.now().toString(),
      "labName": labName,
      "doctorName": "Lab Staff",
      "resultStatus": "Normal",
      "resultSummary": resultSummary,

      /// 🔥 FIXED HERE
      "status": "completed", // was pending ❌ now completed ✅

      "createdAt": FieldValue.serverTimestamp(),
    });
  }
}