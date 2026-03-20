import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'patient_profile_screen.dart';

class PatientDashboardScreen extends StatefulWidget {
  const PatientDashboardScreen({super.key});

  @override
  State<PatientDashboardScreen> createState() =>
      _PatientDashboardScreenState();
}

class _PatientDashboardScreenState extends State<PatientDashboardScreen> {

  String _userName = "Patient";

  String lastVisitDate = "--";
  String lastVisitDoctor = "";

  String nextVisitDate = "--";
  String nextVisitDept = "";

  int takenDoses = 0;
  int totalDoses = 0;

  /// REPORT
  String latestReportName = "--";
  String latestReportDate = "--";
  String latestReportStatus = "--";

  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadDashboard();
  }

  Future<void> _loadDashboard() async {

    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final uid = user.uid;

    try {

      String tempUserName = "Patient";

      String tempLastVisitDate = "--";
      String tempLastVisitDoctor = "";

      String tempNextVisitDate = "--";
      String tempNextVisitDept = "";

      int tempTakenDoses = 0;
      int tempTotalDoses = 0;

      String tempReportName = "--";
      String tempReportDate = "--";
      String tempReportStatus = "--";

      /// USER
      final userDoc = await FirebaseFirestore.instance
          .collection("users")
          .doc(uid)
          .get();

      if (userDoc.exists) {
        tempUserName = userDoc.data()?["name"] ?? "Patient";
      }

      /// LAST VISIT
      final lastVisitSnap = await FirebaseFirestore.instance
          .collection("appointments")
          .where("patientId", isEqualTo: uid)
          .orderBy("date", descending: true)
          .limit(1)
          .get();

      if (lastVisitSnap.docs.isNotEmpty) {
        final data = lastVisitSnap.docs.first.data();

        if (data["date"] != null) {
          final dt = (data["date"] as Timestamp).toDate();
          tempLastVisitDate = "${dt.day}/${dt.month}/${dt.year}";
        }

        tempLastVisitDoctor = data["doctorName"] ?? "";
      }

      /// NEXT VISIT
      final nextVisitSnap = await FirebaseFirestore.instance
          .collection("appointments")
          .where("patientId", isEqualTo: uid)
          .where("date", isGreaterThan: Timestamp.now())
          .orderBy("date")
          .limit(1)
          .get();

      if (nextVisitSnap.docs.isNotEmpty) {
        final data = nextVisitSnap.docs.first.data();

        if (data["date"] != null) {
          final dt = (data["date"] as Timestamp).toDate();
          tempNextVisitDate = "${dt.day}/${dt.month}/${dt.year}";
        }

        tempNextVisitDept = data["department"] ?? "";
      }

      /// MEDICINES
      final meds = await FirebaseFirestore.instance
          .collection("medicines")
          .where("patientId", isEqualTo: uid)
          .get();

      tempTotalDoses = meds.docs.length;

      tempTakenDoses = meds.docs
          .where((d) =>
      (d.data()["status"] ?? "")
          .toString()
          .toLowerCase() == "taken")
          .length;

      /// 🔥 REPORT (LATEST)
      final reports = await FirebaseFirestore.instance
          .collection("reports")
          .where("patientId", isEqualTo: uid)
          .orderBy("createdAt", descending: true)
          .limit(1)
          .get();

      if (reports.docs.isNotEmpty) {
        final data = reports.docs.first.data();

        tempReportName = data["testName"] ?? "--";

        if (data["status"] == "available") {
          tempReportDate = data["uploadedOn"] ?? "--";
          tempReportStatus = data["resultStatus"] ?? "Available";
        } else {
          tempReportDate = data["expectedOn"] ?? "--";
          tempReportStatus = "Pending";
        }
      }

      /// FINAL STATE UPDATE
      if (mounted) {
        setState(() {
          _userName = tempUserName;

          lastVisitDate = tempLastVisitDate;
          lastVisitDoctor = tempLastVisitDoctor;

          nextVisitDate = tempNextVisitDate;
          nextVisitDept = tempNextVisitDept;

          takenDoses = tempTakenDoses;
          totalDoses = tempTotalDoses;

          latestReportName = tempReportName;
          latestReportDate = tempReportDate;
          latestReportStatus = tempReportStatus;

          _loading = false;
        });
      }

    } catch (e) {
      print("Dashboard error: $e");
    }
  }

  String _greeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) return "Good Morning";
    if (hour < 17) return "Good Afternoon";
    return "Good Evening";
  }

  @override
  Widget build(BuildContext context) {

    final initials =
    _userName.isNotEmpty ? _userName[0].toUpperCase() : "P";

    return Container(
      color: const Color(0xFF0C1B2A),
      child: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 110),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              /// HEADER
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [

                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "${_greeting()}, ${_loading ? "..." : _userName}",
                          style: const TextStyle(
                            fontSize: 26,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          "Patient Dashboard",
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.white.withOpacity(0.6),
                          ),
                        ),
                      ],
                    ),
                  ),

                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) =>
                          const PatientProfileScreen(),
                        ),
                      );
                    },
                    child: CircleAvatar(
                      radius: 20,
                      backgroundColor:
                      const Color(0xFFFFB703).withOpacity(0.2),
                      child: Text(
                        initials,
                        style: const TextStyle(
                          color: Color(0xFFFFB703),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 24),

              /// SUMMARY GRID
              GridView.count(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: 2,
                mainAxisSpacing: 14,
                crossAxisSpacing: 14,
                childAspectRatio: 1.35,
                children: [

                  _SummaryCard(
                    icon: Icons.local_hospital_outlined,
                    title: "Last Visit",
                    value: lastVisitDate,
                    subtitle: lastVisitDoctor,
                  ),

                  _SummaryCard(
                    icon: Icons.medication_outlined,
                    title: "Medication",
                    value: "$takenDoses / $totalDoses",
                    subtitle: "$takenDoses taken",
                  ),

                  _SummaryCard(
                    icon: Icons.event_available_outlined,
                    title: "Next Visit",
                    value: nextVisitDate,
                    subtitle: nextVisitDept,
                  ),

                  _SummaryCard(
                    icon: Icons.receipt_long_outlined,
                    title: "Reports",
                    value: latestReportStatus,
                    subtitle: latestReportName,
                  ),
                ],
              ),

              const SizedBox(height: 28),

              /// REPORT SUMMARY
              _sectionTitle("Latest Lab Report"),
              const SizedBox(height: 12),
              _reportCard(),

              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  Widget _sectionTitle(String text) {
    return Text(
      text,
      style: TextStyle(
        fontSize: 12,
        letterSpacing: 1.1,
        color: Colors.white.withOpacity(0.6),
      ),
    );
  }

  Widget _reportCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF14283C),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withOpacity(0.05)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          Text(
            latestReportName,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w600,
            ),
          ),

          const SizedBox(height: 6),

          Text(
            "Date: $latestReportDate",
            style: const TextStyle(
              color: Colors.white70,
              fontSize: 12,
            ),
          ),

          const SizedBox(height: 4),

          Text(
            "Status: $latestReportStatus",
            style: TextStyle(
              color: latestReportStatus == "Normal"
                  ? Colors.greenAccent
                  : latestReportStatus == "Critical"
                  ? Colors.redAccent
                  : Colors.orangeAccent,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

class _SummaryCard extends StatelessWidget {

  final IconData icon;
  final String title;
  final String value;
  final String subtitle;

  const _SummaryCard({
    required this.icon,
    required this.title,
    required this.value,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF14283C),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withOpacity(0.05)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          Icon(icon, size: 18, color: Colors.tealAccent),

          const Spacer(),

          Text(
            value,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 2),

          Flexible(
            child: Text(
              title,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                  fontSize: 11,
                  color: Colors.white70),
            ),
          ),

          Flexible(
            child: Text(
              subtitle,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                  fontSize: 10,
                  color: Colors.white54),
            ),
          ),
        ],
      ),
    );
  }
}