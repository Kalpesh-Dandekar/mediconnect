import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class DoctorProfileService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  String? get _uid => _auth.currentUser?.uid;

  /// 🔥 GET DOCTOR PROFILE
  Stream<DocumentSnapshot> getProfile() {
    if (_uid == null) {
      throw Exception("User not logged in");
    }

    return _firestore.collection("users").doc(_uid).snapshots();
  }

  /// 🔥 UPDATE FIELD (SAFE)
  Future<void> updateField(String field, dynamic value) async {
    if (_uid == null) return;

    /// 🚫 Prevent empty updates
    if (value == null || value.toString().trim().isEmpty) {
      return;
    }

    await _firestore.collection("users").doc(_uid).update({
      field: value.toString().trim(),
      "updatedAt": FieldValue.serverTimestamp(), // optional but pro
    });
  }
}