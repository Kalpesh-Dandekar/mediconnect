import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ReportService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  /// 🔹 Get current user
  User? get _user => _auth.currentUser;

  /// 🔹 Stream all reports (Reports Screen)
  Stream<QuerySnapshot> getPatientReports() {
    if (_user == null) {
      throw Exception("User not logged in");
    }

    return _firestore
        .collection('reports')
        .where('patientId', isEqualTo: _user!.uid)
        .orderBy('createdAt', descending: true)
        .snapshots();
  }

  /// 🔥 NEW: Get latest report (Dashboard use)
  Future<Map<String, dynamic>?> getLatestReport() async {
    if (_user == null) {
      throw Exception("User not logged in");
    }

    final snapshot = await _firestore
        .collection('reports')
        .where('patientId', isEqualTo: _user!.uid)
        .orderBy('createdAt', descending: true)
        .limit(1)
        .get();

    if (snapshot.docs.isEmpty) return null;

    return snapshot.docs.first.data();
  }

  /// 🔹 Summary (optional - keep)
  Future<Map<String, int>> getReportSummary() async {
    if (_user == null) {
      throw Exception("User not logged in");
    }

    final snapshot = await _firestore
        .collection('reports')
        .where('patientId', isEqualTo: _user!.uid)
        .get();

    int total = snapshot.docs.length;

    int pending = snapshot.docs
        .where((d) => (d.data()['status'] ?? "") == "pending")
        .length;

    int available = snapshot.docs
        .where((d) => (d.data()['status'] ?? "") == "available")
        .length;

    return {
      "total": total,
      "pending": pending,
      "available": available,
    };
  }
}