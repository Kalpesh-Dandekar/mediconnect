import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class DoctorDashboardService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  User? get _user => _auth.currentUser;

  Future<Map<String, dynamic>> getDashboardData() async {
    if (_user == null) {
      throw Exception("Doctor not logged in");
    }

    final doctorId = _user!.uid;

    /// 🔥 APPOINTMENTS
    final appointments = await _firestore
        .collection("appointments")
        .where("doctorId", isEqualTo: doctorId)
        .get();

    final total = appointments.docs.length;

    final waiting = appointments.docs.where((d) {
      final status =
      (d["status"] ?? "").toString().toLowerCase().trim();
      return status == "waiting";
    }).length;

    /// 🔥 CONSULTATIONS (FIXED FIELD)
    final consultations = await _firestore
        .collection("consultations")
        .where("assignedTo", isEqualTo: doctorId)
        .get();

    final done = consultations.docs.length;

    /// 🔥 EMERGENCIES (FIXED FIELD + FILTER)
    final emergencies = await _firestore
        .collection("emergencies")
        .where("assignedTo", isEqualTo: doctorId)
        .get();

    final emergencyCount = emergencies.docs.where((e) {
      final status =
      (e["status"] ?? "").toString().toLowerCase().trim();
      return status == "active";
    }).length;

    return {
      "total": total,
      "waiting": waiting,
      "done": done,
      "emergency": emergencyCount,
    };
  }

  /// 🔥 NEXT PATIENTS STREAM
  Stream<QuerySnapshot> getNextPatients() {
    if (_user == null) {
      throw Exception("Doctor not logged in");
    }

    return _firestore
        .collection("appointments")
        .where("doctorId", isEqualTo: _user!.uid)
        .orderBy("date")
        .limit(5)
        .snapshots();
  }
}