import 'package:cloud_firestore/cloud_firestore.dart';

class RelativePatientService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<Map<String, dynamic>?> getPatient(String relativeId) async {
    try {
      /// 🔥 FIND PATIENT
      final snapshot = await _firestore
          .collection('patients')
          .where('relativeId', isEqualTo: relativeId)
          .limit(1)
          .get();

      if (snapshot.docs.isEmpty) return null;

      final patientDoc = snapshot.docs.first;

      final patientId = patientDoc.id;

      /// 🔥 GET USER NAME FROM USERS COLLECTION
      final userDoc = await _firestore
          .collection('users')
          .doc(patientId)
          .get();

      String name = "Patient";

      if (userDoc.exists) {
        name = userDoc.data()?['name'] ?? "Patient";
      }

      return {
        "id": patientId,
        "name": name,
      };

    } catch (e) {
      throw Exception("Failed to fetch patient: $e");
    }
  }
}