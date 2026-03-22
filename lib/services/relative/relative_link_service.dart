import 'package:cloud_firestore/cloud_firestore.dart';

class RelativeLinkService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// 🔥 CONNECT USING CODE
  Future<void> connectToPatient({
    required String code,
    required String relativeId,
  }) async {
    try {
      final snapshot = await _firestore
          .collection('patients')
          .where('linkCode', isEqualTo: code)
          .limit(1)
          .get();

      if (snapshot.docs.isEmpty) {
        throw Exception("Invalid code");
      }

      final patientDoc = snapshot.docs.first;

      await _firestore
          .collection('patients')
          .doc(patientDoc.id)
          .set({
        "relativeId": relativeId,
      }, SetOptions(merge: true));

    } catch (e) {
      throw Exception("Connection failed: $e");
    }
  }
}