import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// 🔹 Get Current Logged User
  User? get currentUser => _auth.currentUser;

  /// 🔹 Register Basic User (Email + Password)
  Future<User?> registerBasicUser({
    required String email,
    required String password,
    required String name,
    required String role,
  }) async {
    try {
      UserCredential credential =
      await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      User? user = credential.user;

      if (user != null) {
        await _firestore.collection('users').doc(user.uid).set({
          'name': name,
          'email': email,
          'role': role,
          'createdAt': FieldValue.serverTimestamp(),
          'profile': {},
          'profileCompleted': false, // 🔥 important
        });
      }

      return user;
    } on FirebaseAuthException {
      rethrow;
    } catch (e) {
      throw Exception("Unexpected error during registration");
    }
  }

  /// 🔹 Login User
  Future<User?> loginUser({
    required String email,
    required String password,
  }) async {
    try {
      UserCredential credential =
      await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      return credential.user;
    } on FirebaseAuthException {
      rethrow;
    } catch (e) {
      throw Exception("Unexpected error during login");
    }
  }

  /// 🔹 Save Role Specific Details
  Future<void> saveRoleDetails({
    required String uid,
    required Map<String, dynamic> profileData,
  }) async {
    try {
      await _firestore.collection('users').doc(uid).set(
        {
          'profile': profileData,
          'profileCompleted': true,
        },
        SetOptions(merge: true),
      );
    } catch (e) {
      throw Exception("Failed to save profile details");
    }
  }

  /// 🔹 Fetch User Data
  Future<Map<String, dynamic>?> getUserData(String uid) async {
    try {
      DocumentSnapshot doc =
      await _firestore.collection('users').doc(uid).get();

      if (doc.exists) {
        return doc.data() as Map<String, dynamic>;
      }
      return null;
    } catch (e) {
      throw Exception("Failed to fetch user data");
    }
  }

  /// 🔥 Get User Role
  Future<String?> getUserRole(String uid) async {
    final doc = await _firestore.collection('users').doc(uid).get();
    return doc.data()?['role'];
  }

  /// 🔥 Check if profile is completed
  Future<bool> isProfileCompleted(String uid) async {
    final doc = await _firestore.collection('users').doc(uid).get();
    return doc.data()?['profileCompleted'] ?? false;
  }

  /// 🔹 Logout
  Future<void> logout() async {
    await _auth.signOut();
  }
}