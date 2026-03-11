import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ProfileService {

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  /// Get patient profile
  Future<Map<String, dynamic>?> getProfile() async {

    final uid = _auth.currentUser!.uid;

    final doc = await _firestore
        .collection("users")
        .doc(uid)
        .get();

    return doc.data();
  }

  /// Update profile
  Future<void> updateProfile(Map<String, dynamic> data) async {

    final uid = _auth.currentUser!.uid;

    await _firestore
        .collection("users")
        .doc(uid)
        .update(data);
  }

  /// Logout
  Future<void> logout() async {
    await _auth.signOut();
  }
}