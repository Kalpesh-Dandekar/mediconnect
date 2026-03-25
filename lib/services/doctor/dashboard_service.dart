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

    /// 🔥 CONSULTATIONS
    final consultations = await _firestore
        .collection("consultations")
        .where("assignedTo", isEqualTo: doctorId)
        .get();

    final done = consultations.docs.length;

    /// 🔥 UPDATED: ALL ACTIVE EMERGENCIES
    final emergencies = await _firestore
        .collection("emergencies")
        .where("status", isEqualTo: "active")
        .get();

    final emergencyCount = emergencies.docs.length;

    return {
      "total": total,
      "waiting": waiting,
      "done": done,
      "emergency": emergencyCount,
    };
  }

  /// 🔥 NEXT PATIENTS
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

  /// 🔥 NEW: EMERGENCY STREAM (future use)
  Stream<QuerySnapshot> getEmergencyStream() {
    return _firestore
        .collection("emergencies")
        .where("status", isEqualTo: "active")
        .orderBy("createdAt", descending: true)
        .snapshots();
  }
}