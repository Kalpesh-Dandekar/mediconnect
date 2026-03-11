import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class MedicineService {

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  /// STREAM PATIENT MEDICINES
  Stream<QuerySnapshot> getTodayMedicines() {

    final user = _auth.currentUser;

    if (user == null) {
      throw Exception("User not logged in");
    }

    return _firestore
        .collection("medicines")
        .where("patientId", isEqualTo: user.uid)
        .orderBy("createdAt")
        .snapshots();
  }

  /// UPDATE MEDICINE STATUS
  Future<void> updateMedicineStatus({
    required String medicineId,
    required String status,
  }) async {

    await _firestore
        .collection("medicines")
        .doc(medicineId)
        .update({
      "status": status
    });
  }
}