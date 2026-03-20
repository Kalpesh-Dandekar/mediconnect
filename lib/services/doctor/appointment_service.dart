import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class DoctorAppointmentService {

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  User? get _user => _auth.currentUser;

  /// ================================
  /// 🔥 GET APPOINTMENTS (FIXED)
  /// ================================
  Stream<QuerySnapshot> getTodayAppointments() {

    if (_user == null) {
      throw Exception("Doctor not logged in");
    }

    /// 🔥 TEMP FIX: REMOVE DATE FILTER
    /// (we'll re-add properly later)

    return _firestore
        .collection("appointments")
        .where("doctorId", isEqualTo: _user!.uid)
        .orderBy("createdAt", descending: true)
        .snapshots();
  }

  /// ================================
  /// 🔥 UPDATE STATUS
  /// ================================
  Future<void> updateStatus({
    required String appointmentId,
    required String status,
  }) async {

    await _firestore
        .collection("appointments")
        .doc(appointmentId)
        .update({
      "status": status,
      "updatedAt": FieldValue.serverTimestamp(),
    });
  }

  /// ================================
  /// 🔥 START CONSULTATION
  /// ================================
  Future<void> startConsultation(String appointmentId) async {
    await updateStatus(
      appointmentId: appointmentId,
      status: "In Consultation",
    );
  }

  /// ================================
  /// 🔥 COMPLETE CONSULTATION
  /// ================================
  Future<void> completeConsultation(String appointmentId) async {
    await updateStatus(
      appointmentId: appointmentId,
      status: "Completed",
    );
  }
}