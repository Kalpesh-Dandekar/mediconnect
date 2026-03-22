import 'package:cloud_firestore/cloud_firestore.dart';

class RelativeReportService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// 🔥 STREAM REPORTS USING PATIENT ID
  Stream<QuerySnapshot> getPatientReports(String patientId) {
    return _firestore
        .collection("reports")
        .where("patientId", isEqualTo: patientId)
        .orderBy("createdAt", descending: true)
        .snapshots();
  }
}