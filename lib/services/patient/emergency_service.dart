import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class EmergencyService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  /// 🔹 Create Emergency Request (UPDATED)
  Future<void> createEmergency(String type) async {
    final user = _auth.currentUser;

    if (user == null) {
      throw Exception("User not logged in");
    }

    /// 🔥 Fetch patient details
    final userDoc = await _firestore
        .collection("users")
        .doc(user.uid)
        .get();

    final data = userDoc.data();

    final patientName = data?["name"] ?? "Patient";

    await _firestore.collection("emergencies").add({
      "patientId": user.uid,
      "patientName": patientName, // ✅ NEW FIELD

      "type": type, // ambulance / doctor / caregiver
      "status": "active",
      "assignedTo": "",

      /// optional
      "message": "",

      "createdAt": FieldValue.serverTimestamp(),
      "updatedAt": FieldValue.serverTimestamp(),
    });
  }

  /// 🔥 Get active emergencies (doctor view)
  Stream<QuerySnapshot> getActiveEmergencies() {
    return _firestore
        .collection("emergencies")
        .where("status", isEqualTo: "active")
        .orderBy("createdAt", descending: true)
        .snapshots();
  }

  /// 🔥 Accept emergency (doctor/staff)
  Future<void> acceptEmergency(String emergencyId) async {
    final user = _auth.currentUser;

    if (user == null) return;

    await _firestore.collection("emergencies").doc(emergencyId).update({
      "status": "accepted",
      "assignedTo": user.uid,
      "updatedAt": FieldValue.serverTimestamp(),
    });
  }

  /// 🔥 Complete emergency
  Future<void> completeEmergency(String emergencyId) async {
    await _firestore.collection("emergencies").doc(emergencyId).update({
      "status": "completed",
      "updatedAt": FieldValue.serverTimestamp(),
    });
  }

  /// 🔥 Get emergencies assigned to current doctor (future use)
  Stream<QuerySnapshot> getMyEmergencies() {
    final user = _auth.currentUser;

    if (user == null) {
      throw Exception("User not logged in");
    }

    return _firestore
        .collection("emergencies")
        .where("assignedTo", isEqualTo: user.uid)
        .orderBy("createdAt", descending: true)
        .snapshots();
  }
}