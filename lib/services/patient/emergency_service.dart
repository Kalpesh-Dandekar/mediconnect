import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class EmergencyService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  /// 🔥 CREATE EMERGENCY + SEND ALERTS
  Future<void> createEmergency(String type) async {
    final user = _auth.currentUser;

    if (user == null) {
      throw Exception("User not logged in");
    }

    /// 🔹 Get patient details
    final userDoc =
    await _firestore.collection("users").doc(user.uid).get();

    final data = userDoc.data();

    final patientName = data?["name"] ?? "Patient";
    final relativeId = data?["relativeId"];
    final doctorId = data?["doctorId"];

    /// 🔥 Dynamic message
    String message;

    if (type == "ambulance") {
      message = "🚨 URGENT: $patientName requested an ambulance!";
    } else if (type == "doctor") {
      message = "👨‍⚕️ $patientName requested a doctor consultation";
    } else if (type == "caregiver") {
      message = "👨‍👩‍👧 $patientName needs caregiver assistance";
    } else {
      message = "🚨 Emergency triggered by $patientName";
    }

    /// 🔹 Create emergency record
    final emergencyRef = await _firestore.collection("emergencies").add({
      "patientId": user.uid,
      "patientName": patientName,
      "type": type,
      "status": "active",
      "assignedTo": "",
      "message": message,
      "createdAt": FieldValue.serverTimestamp(),
      "updatedAt": FieldValue.serverTimestamp(),
    });

    /// 🔥 SEND TO RELATIVE
    if (relativeId != null) {
      await _firestore.collection("notifications").add({
        "toUserId": relativeId,
        "type": "emergency",
        "message": message,
        "timestamp": FieldValue.serverTimestamp(),
        "patientId": user.uid,
        "emergencyId": emergencyRef.id,
      });

      print("🚨 Alert sent to relative");
    }

    /// 🔥 SEND TO DOCTOR
    if (doctorId != null) {
      await _firestore.collection("notifications").add({
        "toUserId": doctorId,
        "type": "emergency",
        "message": message,
        "timestamp": FieldValue.serverTimestamp(),
        "patientId": user.uid,
        "emergencyId": emergencyRef.id,
      });

      print("🚨 Alert sent to doctor");
    }
  }

  /// 🔥 ACTIVE EMERGENCIES (doctor view)
  Stream<QuerySnapshot> getActiveEmergencies() {
    return _firestore
        .collection("emergencies")
        .where("status", isEqualTo: "active")
        .orderBy("createdAt", descending: true)
        .snapshots();
  }

  /// 🔥 ACCEPT EMERGENCY
  Future<void> acceptEmergency(String emergencyId) async {
    final user = _auth.currentUser;

    if (user == null) return;

    await _firestore.collection("emergencies").doc(emergencyId).update({
      "status": "accepted",
      "assignedTo": user.uid,
      "updatedAt": FieldValue.serverTimestamp(),
    });
  }

  /// 🔥 COMPLETE EMERGENCY
  Future<void> completeEmergency(String emergencyId) async {
    await _firestore.collection("emergencies").doc(emergencyId).update({
      "status": "completed",
      "updatedAt": FieldValue.serverTimestamp(),
    });
  }

  /// 🔥 MY EMERGENCIES (doctor)
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