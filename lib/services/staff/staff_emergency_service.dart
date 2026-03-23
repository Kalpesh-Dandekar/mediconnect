import 'package:cloud_firestore/cloud_firestore.dart';

class StaffEmergencyService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// 🔥 GET ALL EMERGENCIES
  Stream<QuerySnapshot> getEmergencies() {
    return _firestore
        .collection("emergencies")
        .orderBy("createdAt", descending: true)
        .snapshots();
  }

  /// 🔥 UPDATE STATUS (HANDLE EMERGENCY)
  Future<void> updateEmergencyStatus({
    required String emergencyId,
    required String status,
  }) async {
    await _firestore
        .collection("emergencies")
        .doc(emergencyId)
        .update({
      "status": status,
      "updatedAt": FieldValue.serverTimestamp(),
    });
  }
}