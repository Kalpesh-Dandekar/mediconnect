import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../patient/medicine_service.dart';

class ConsultationService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final MedicineService _medicineService = MedicineService();

  User? get _user => _auth.currentUser;

  Future<void> saveConsultation({
    required String patientId,
    required String patientName,
    required String diagnosis,
    required String summary,
    required List<Map<String, dynamic>> prescriptions,
    required List<String> tests,
    required String advice,
    required String appointmentId, // ✅ IMPORTANT
    DateTime? followUpDate,
  }) async {

    if (_user == null) {
      throw Exception("Doctor not logged in");
    }

    final doctorId = _user!.uid;
    final doctorName = _user!.displayName ?? "Doctor";

    /// 🔥 SAVE CONSULTATION
    await _firestore.collection("consultations").add({
      "patientId": patientId,
      "patientName": patientName,
      "assignedTo": doctorId,
      "doctorName": doctorName,
      "diagnosis": diagnosis,
      "summary": summary,
      "prescriptions": prescriptions,
      "tests": tests,
      "advice": advice,
      "followUpDate": followUpDate != null
          ? Timestamp.fromDate(followUpDate)
          : null,
      "createdAt": FieldValue.serverTimestamp(),
    });

    /// 🔥 MARK APPOINTMENT COMPLETED (MAIN FIX)
    if (appointmentId.isNotEmpty) {
      await _firestore
          .collection("appointments")
          .doc(appointmentId)
          .update({
        "status": "Completed",
        "updatedAt": FieldValue.serverTimestamp(),
      });
    }

    /// 🔥 GENERATE MEDICINES
    if (prescriptions.isNotEmpty) {
      await _medicineService.addMedicinesFromConsultation(
        patientId: patientId,
        prescriptions: prescriptions,
      );
    }
  }
}