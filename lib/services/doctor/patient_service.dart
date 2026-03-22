import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class PatientService {

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  User? get _user => _auth.currentUser;

  /// 🔥 GET ALL PATIENTS (FIXED)
  Stream<List<Map<String, dynamic>>> getPatients() {

    if (_user == null) {
      throw Exception("Doctor not logged in");
    }

    return _firestore
        .collection("appointments")
        .where("doctorId", isEqualTo: _user!.uid)
        .orderBy("date", descending: true)
        .snapshots()
        .asyncMap((snapshot) async {

      final docs = snapshot.docs;

      final Map<String, Map<String, dynamic>> latestPatients = {};

      for (var doc in docs) {

        final data = doc.data();
        final patientId = data["patientId"];

        if (patientId == null) continue;

        /// 🔥 TAKE ONLY LATEST ENTRY
        if (latestPatients.containsKey(patientId)) continue;

        final appointmentId = doc.id;

        final userDoc = await _firestore
            .collection("users")
            .doc(patientId)
            .get();

        final userData = userDoc.data();
        if (userData == null) continue;

        latestPatients[patientId] = {
          "id": patientId,
          "name": userData["name"] ?? "Unknown",
          "age": userData["age"] ?? "",
          "lastVisit": _formatDate(data["date"]),
          "diagnosis": data["department"] ?? "General Checkup",

          /// 🔥 CLEAN STATUS
          "status": data["status"] == "Completed"
              ? "Follow-up"
              : "Active",

          "visitedToday": data["status"] == "In Consultation",

          /// 🔥 MOST IMPORTANT
          "appointmentId": appointmentId,
        };
      }

      return latestPatients.values.toList();
    });
  }

  String _formatDate(dynamic timestamp) {

    if (timestamp == null) return "--";

    final dt = (timestamp as Timestamp).toDate();

    return "${dt.day} ${_month(dt.month)} ${dt.year}";
  }

  String _month(int m) {
    const months = [
      "Jan","Feb","Mar","Apr","May","Jun",
      "Jul","Aug","Sep","Oct","Nov","Dec"
    ];
    return months[m - 1];
  }
}