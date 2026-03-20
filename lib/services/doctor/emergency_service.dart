import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class DoctorEmergencyService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  User? get _user => _auth.currentUser;

  /// 🔥 Get ALL active emergencies (for dashboard)
  Stream<QuerySnapshot> getActiveEmergencies() {
    return _firestore
        .collection("emergencies")
        .where("status", whereIn: ["active", "accepted"])
        .orderBy("createdAt", descending: true)
        .snapshots();
  }

  /// 🔥 Get ONLY unassigned (important)
  Stream<QuerySnapshot> getUnassignedEmergencies() {
    return _firestore
        .collection("emergencies")
        .where("status", isEqualTo: "active")
        .orderBy("createdAt", descending: true)
        .snapshots();
  }

  /// 🔥 Get MY emergencies (accepted by me)
  Stream<QuerySnapshot> getMyEmergencies() {
    if (_user == null) {
      throw Exception("Doctor not logged in");
    }

    return _firestore
        .collection("emergencies")
        .where("assignedTo", isEqualTo: _user!.uid)
        .where("status", isEqualTo: "accepted")
        .orderBy("createdAt", descending: true)
        .snapshots();
  }

  /// 🔥 ACCEPT emergency
  Future<void> acceptEmergency(String emergencyId) async {
    if (_user == null) return;

    await _firestore.collection("emergencies").doc(emergencyId).update({
      "status": "accepted",
      "assignedTo": _user!.uid,
      "updatedAt": FieldValue.serverTimestamp(),
    });
  }

  /// 🔥 COMPLETE emergency
  Future<void> completeEmergency(String emergencyId) async {
    await _firestore.collection("emergencies").doc(emergencyId).update({
      "status": "completed",
      "updatedAt": FieldValue.serverTimestamp(),
    });
  }

  /// 🔥 OPTIONAL: Reject / release emergency
  Future<void> releaseEmergency(String emergencyId) async {
    await _firestore.collection("emergencies").doc(emergencyId).update({
      "status": "active",
      "assignedTo": "",
      "updatedAt": FieldValue.serverTimestamp(),
    });
  }
}