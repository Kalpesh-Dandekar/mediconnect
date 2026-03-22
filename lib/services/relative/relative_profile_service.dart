import 'package:cloud_firestore/cloud_firestore.dart';

class RelativeProfileService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// 🔥 GET PROFILE
  Future<Map<String, dynamic>> getProfile(String relativeId) async {
    final userDoc =
    await _firestore.collection("users").doc(relativeId).get();

    String name = "User";
    String phone = "--";
    String relationship = "--";

    if (userDoc.exists) {
      final data = userDoc.data()!;
      name = data["name"] ?? "User";
      phone = data["phone"] ?? "--";
      relationship = data["relationship"] ?? "--";
    }

    /// GET LINKED PATIENT
    final patientSnap = await _firestore
        .collection("patients")
        .where("relativeId", isEqualTo: relativeId)
        .limit(1)
        .get();

    String patientName = "Not Connected";

    if (patientSnap.docs.isNotEmpty) {
      final patientId = patientSnap.docs.first.id;

      final patientUser =
      await _firestore.collection("users").doc(patientId).get();

      if (patientUser.exists) {
        patientName = patientUser.data()?["name"] ?? "Patient";
      }
    }

    return {
      "name": name,
      "phone": phone,
      "relationship": relationship,
      "patientName": patientName,
    };
  }

  /// 🔥 UPDATE PROFILE
  Future<void> updateProfile({
    required String userId,
    required String name,
    required String phone,
    required String relationship,
  }) async {
    await _firestore.collection("users").doc(userId).update({
      "name": name,
      "phone": phone,
      "relationship": relationship,
    });
  }
}