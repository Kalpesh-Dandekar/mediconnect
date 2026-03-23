import 'package:cloud_firestore/cloud_firestore.dart';

class StaffDashboardService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// 🔥 GET TODAY RANGE
  DateTime get _startOfDay {
    final now = DateTime.now();
    return DateTime(now.year, now.month, now.day);
  }

  DateTime get _endOfDay {
    final now = DateTime.now();
    return DateTime(now.year, now.month, now.day, 23, 59, 59);
  }

  /// 🔥 MAIN DASHBOARD DATA
  Future<Map<String, int>> getDashboardData() async {
    try {
      /// ==============================
      /// 1️⃣ APPOINTMENTS (TODAY)
      /// ==============================
      final appointmentsSnap = await _firestore
          .collection("appointments")
          .where(
        "date",
        isGreaterThanOrEqualTo:
        Timestamp.fromDate(_startOfDay),
      )
          .where(
        "date",
        isLessThanOrEqualTo:
        Timestamp.fromDate(_endOfDay),
      )
          .get();

      /// ==============================
      /// 2️⃣ REPORTS
      /// ==============================
      final reportsSnap =
      await _firestore.collection("reports").get();

      int pendingReports = 0;
      int completedReports = 0;

      for (var doc in reportsSnap.docs) {
        final data = doc.data();

        final status =
        (data["status"] ?? "pending").toString();

        if (status == "completed") {
          completedReports++;
        } else {
          pendingReports++;
        }
      }

      /// ==============================
      /// 3️⃣ EMERGENCIES (ACTIVE ONLY)
      /// ==============================
      final emergencySnap = await _firestore
          .collection("emergencies")
          .where("status", isEqualTo: "pending")
          .get();

      /// ==============================
      /// FINAL RESPONSE
      /// ==============================
      return {
        "appointments": appointmentsSnap.docs.length,
        "pendingReports": pendingReports,
        "completedReports": completedReports,
        "emergencies": emergencySnap.docs.length,
      };

    } catch (e) {
      print("Dashboard Error: $e");

      /// 🔥 FAIL SAFE (APP WON'T CRASH)
      return {
        "appointments": 0,
        "pendingReports": 0,
        "completedReports": 0,
        "emergencies": 0,
      };
    }
  }
}