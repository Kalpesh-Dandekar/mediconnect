import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ReportService {

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  /// get reports for patient
  Stream<QuerySnapshot> getPatientReports() {

    final uid = _auth.currentUser!.uid;

    return _firestore
        .collection("reports")
        .where("patientId", isEqualTo: uid)
        .snapshots();
  }

}