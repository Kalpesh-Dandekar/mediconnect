import 'package:cloud_firestore/cloud_firestore.dart';

class RelativeLinkService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// 🔥 CONNECT USING CODE (FIXED FULL)
  Future<void> connectToPatient({
    required String code,
    required String relativeId,
  }) async {
    try {
      /// 1. Find patient using code
      final snapshot = await _firestore
          .collection('patients')
          .where('linkCode', isEqualTo: code)
          .limit(1)
          .get();

      if (snapshot.docs.isEmpty) {
        throw Exception("Invalid code");
      }

      final patientDoc = snapshot.docs.first;
      final patientId = patientDoc.id;

      /// 2. Save in patients collection (existing logic)
      await _firestore
          .collection('patients')
          .doc(patientId)
          .set({
        "relativeId": relativeId,
      }, SetOptions(merge: true));

      /// 🔥 3. IMPORTANT: ALSO SAVE IN USERS COLLECTION
      await _firestore
          .collection('users')
          .doc(patientId)
          .set({
        "relativeId": relativeId,
      }, SetOptions(merge: true));

      /// 🔥 4. (OPTIONAL BUT GOOD) store patientId in relative user
      await _firestore
          .collection('users')
          .doc(relativeId)
          .set({
        "patientId": patientId,
      }, SetOptions(merge: true));

      print("✅ Patient connected successfully");

    } catch (e) {
      throw Exception("Connection failed: $e");
    }
  }
}