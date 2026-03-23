import 'package:cloud_firestore/cloud_firestore.dart';

class StaffAppointmentService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// 🔥 STREAM ALL APPOINTMENTS
  Stream<QuerySnapshot> getAppointments() {
    return _firestore
        .collection("appointments")
        .orderBy("date")
        .snapshots();
  }

  /// 🔥 UPDATE STATUS
  Future<void> updateStatus({
    required String appointmentId,
    required String status,
  }) async {
    await _firestore
        .collection("appointments")
        .doc(appointmentId)
        .update({"status": status});
  }
}