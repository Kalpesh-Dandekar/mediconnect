import 'package:cloud_firestore/cloud_firestore.dart';

class RelativeDashboardService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<Map<String, dynamic>> getDashboardData(String patientId) async {
    try {
      /// MEDICINES
      final meds = await _firestore
          .collection("medicines")
          .where("patientId", isEqualTo: patientId)
          .get();

      final total = meds.docs.length;

      final taken = meds.docs
          .where((d) =>
      (d.data()["status"] ?? "")
          .toString()
          .toLowerCase() == "taken")
          .length;

      String nextDose = "All taken";
      for (var doc in meds.docs) {
        if ((doc.data()["status"] ?? "") == "pending") {
          nextDose = doc.data()["time"] ?? "--";
          break;
        }
      }

      /// NEXT VISIT
      final nextVisitSnap = await _firestore
          .collection("appointments")
          .where("patientId", isEqualTo: patientId)
          .where("date", isGreaterThan: Timestamp.now())
          .orderBy("date")
          .limit(1)
          .get();

      String nextVisitDate = "--";
      String nextVisitDoctor = "";

      if (nextVisitSnap.docs.isNotEmpty) {
        final data = nextVisitSnap.docs.first.data();
        final dt = (data["date"] as Timestamp).toDate();

        nextVisitDate = "${dt.day}/${dt.month}/${dt.year}";
        nextVisitDoctor = data["doctorName"] ?? "";
      }

      /// REPORT
      final reports = await _firestore
          .collection("reports")
          .where("patientId", isEqualTo: patientId)
          .orderBy("createdAt", descending: true)
          .limit(1)
          .get();

      String reportStatus = "--";

      if (reports.docs.isNotEmpty) {
        reportStatus = reports.docs.first.data()["status"] ?? "--";
      }

      return {
        "taken": taken,
        "total": total,
        "nextDose": nextDose,
        "nextVisitDate": nextVisitDate,
        "nextVisitDoctor": nextVisitDoctor,
        "reportStatus": reportStatus,
      };
    } catch (e) {
      print("Dashboard error: $e");
      return {
        "taken": 0,
        "total": 0,
        "nextDose": "--",
        "nextVisitDate": "--",
        "nextVisitDoctor": "",
        "reportStatus": "--",
      };
    }
  }
}