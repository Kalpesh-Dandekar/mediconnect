import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class StaffProfileService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  String? get _uid => _auth.currentUser?.uid;

  /// 🔥 REAL-TIME PROFILE
  Stream<DocumentSnapshot<Map<String, dynamic>>> getProfile() {
    if (_uid == null) {
      throw Exception("User not logged in");
    }

    return _firestore
        .collection("users") // ✅ FIXED
        .doc(_uid)
        .snapshots();
  }

  /// 🔥 UPDATE NESTED PROFILE FIELD
  Future<void> updateField(String field, dynamic value) async {
    if (_uid == null) return;

    await _firestore
        .collection("users")
        .doc(_uid)
        .update({
      "profile.$field": value, // ✅ VERY IMPORTANT
    });
  }

  /// 🔥 UPDATE TOP LEVEL (OPTIONAL)
  Future<void> updateTopLevelField(String field, dynamic value) async {
    if (_uid == null) return;

    await _firestore
        .collection("users")
        .doc(_uid)
        .update({
      field: value,
    });
  }
}