import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AppointmentService {

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  /// ================================
  /// BOOK APPOINTMENT
  /// ================================
  Future<void> bookAppointment({
    required String doctorName,
    required String department,
    required DateTime date,
    required String timeSlot,
  }) async {

    final user = _auth.currentUser;

    if (user == null) {
      throw Exception("User not logged in");
    }

    final patientId = user.uid;

    /// 🔥 Fetch patient name
    final userDoc = await _firestore
        .collection("users")
        .doc(patientId)
        .get();

    final patientName = userDoc.data()?["name"] ?? "Patient";

    /// 🔥 Find doctor
    final doctorQuery = await _firestore
        .collection("users")
        .where("name", isEqualTo: doctorName)
        .where("role", isEqualTo: "Doctor") // ⚠️ case sensitive
        .limit(1)
        .get();

    if (doctorQuery.docs.isEmpty) {
      throw Exception("Doctor not found");
    }

    final doctorDoc = doctorQuery.docs.first;
    final doctorId = doctorDoc.id;

    /// 🔥 Prevent double booking
    final existingAppointment = await _firestore
        .collection("appointments")
        .where("doctorId", isEqualTo: doctorId)
        .where("date", isEqualTo: Timestamp.fromDate(date))
        .where("timeSlot", isEqualTo: timeSlot)
        .get();

    if (existingAppointment.docs.isNotEmpty) {
      throw Exception("Selected time slot already booked");
    }

    /// 🔥 Generate token (simple)
    final token = DateTime.now().millisecondsSinceEpoch % 1000;

    /// 🔥 Create appointment (UPDATED STRUCTURE)
    await _firestore.collection("appointments").add({

      /// CORE
      "patientId": patientId,
      "patientName": patientName,

      "doctorId": doctorId,
      "doctorName": doctorName,

      /// DETAILS
      "department": department,
      "reason": department, // simple for now
      "timeSlot": timeSlot,
      "date": Timestamp.fromDate(date),

      /// STATUS FLOW
      "status": "Waiting", // ✅ IMPORTANT FIX

      /// EXTRA
      "token": token,
      "createdAt": FieldValue.serverTimestamp(),
    });
  }

  /// ================================
  /// STREAM PATIENT APPOINTMENTS
  /// ================================
  Stream<QuerySnapshot> getPatientAppointments() {

    final user = _auth.currentUser;

    if (user == null) {
      throw Exception("User not logged in");
    }

    final patientId = user.uid;

    return _firestore
        .collection("appointments")
        .where("patientId", isEqualTo: patientId)
        .orderBy("createdAt", descending: true)
        .snapshots();
  }

  /// ================================
  /// CANCEL APPOINTMENT
  /// ================================
  Future<void> cancelAppointment(String appointmentId) async {

    await _firestore
        .collection("appointments")
        .doc(appointmentId)
        .update({
      "status": "Cancelled"
    });
  }

  /// ================================
  /// UPDATE STATUS (Doctor side use)
  /// ================================
  Future<void> updateAppointmentStatus({
    required String appointmentId,
    required String status,
  }) async {

    await _firestore
        .collection("appointments")
        .doc(appointmentId)
        .update({
      "status": status
    });
  }
}