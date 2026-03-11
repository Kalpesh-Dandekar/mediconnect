import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class TreatmentService {

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Stream<QuerySnapshot<Map<String, dynamic>>> getActiveTreatments() {

    final user = _auth.currentUser;

    if (user == null) {
      throw Exception("User not logged in");
    }

    return _firestore
        .collection("treatments")
        .where("patientId", isEqualTo: user.uid)
        .orderBy("createdAt", descending: true)
        .snapshots();
  }

  Future<void> updateEscalation({
    required String treatmentId,
    required bool value,
  }) async {

    await _firestore
        .collection("treatments")
        .doc(treatmentId)
        .update({
      "escalation": value
    });
  }
}